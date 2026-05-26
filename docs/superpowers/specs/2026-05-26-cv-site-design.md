# Personal CV Site — Design Spec

**Date:** 2026-05-26
**Owner:** ShuRaAtum (graduate student, optimized cryptographic algorithm implementations)
**Repo:** `ShuRaAtum/ShuRaAtum.github.io`
**Live URL:** `https://shuraatum.github.io`

## Purpose

A bilingual (English / Korean) personal site that serves two audiences with one artifact:

1. **Job applications** — recruiters and hiring committees should find publications, projects, and a downloadable CV within one click of the landing page.
2. **Research portfolio** — long-term home for papers, implementation projects, and occasional notes related to the owner's cryptography research.

English is the primary language (academic norm). Korean exists as a full mirror at `/ko/*` for Korean-speaking readers and domestic job applications.

## Theme & Stack

- **Base theme:** [`al-folio`](https://github.com/alshedivat/al-folio) (Jekyll, academic). Provides BibTeX-driven publications, project gallery, dark mode, KaTeX, citations.
- **Hosting:** GitHub Pages, served from the `gh-pages` branch.
- **Build:** GitHub Actions workflow shipped with al-folio (`.github/workflows/deploy.yml`) — Ruby + Node, `bundle exec jekyll build`, push to `gh-pages`.
- **Local dev:** `bundle exec jekyll serve` (Docker compose also provided by al-folio template).

## Information Architecture

Top-level pages (5):

| Slug (EN) | Slug (KO) | Page |
|-----------|-----------|------|
| `/en/` (root redirect) | `/ko/` | About — bio paragraph, profile photo, contact links, recent News |
| `/en/publications/` | `/ko/publications/` | Publications — auto-generated from `_bibliography/papers.bib` |
| `/en/projects/` | `/ko/projects/` | Projects — card grid from `_projects/*.md` |
| `/en/cv/` | `/ko/cv/` | CV — structured page + `Download PDF` button |
| `/en/blog/` | `/ko/blog/` | Blog/Notes — `_posts/*.md`, categories: `notes`, `paper-summary`, `implementation` |

Navigation order: `About · Publications · Projects · CV · Blog` on the left; `🌐 EN/KO · 🌓 Light/Dark` on the right.

## Bilingual Strategy

GitHub Pages does not build custom Ruby plugins by default, so a multi-language plugin is unsuitable. Instead, **manual mirroring** is used (compatible with the existing al-folio GitHub Actions build):

- Each page exists as two files: `_pages/about_en.md` (`permalink: /en/`) and `_pages/about_ko.md` (`permalink: /ko/`). Front matter `lang: en|ko` drives layout-level conditionals.
- Shared display strings live in `_data/strings_en.yml` and `_data/strings_ko.yml`; templates pick via `site.data.strings_{{ page.lang }}`.
- Language switcher (`_includes/lang-switcher.html`) swaps only the first path segment (`/en` ↔ `/ko`) of the current URL, so each page links to its sibling.
- The site root `/` redirects to `/en/` (default language).
- `papers.bib` is a single source of truth in English; localized rendering changes only display labels (e.g. "Selected publications" / "주요 논문").

Korean content scope (initial): About, CV, recent News, project short descriptions. Blog posts can be authored in either language with a `lang` front-matter field; the listing filters by current language.

## Content Model

### Publications — `_bibliography/papers.bib`

```bibtex
@inproceedings{kim2025lattice,
  title       = {Optimized Implementation of Lattice-Based Signatures on AVX-512},
  author      = {Kim, ShuRaAtum and Coauthor, A.},
  booktitle   = {CHES},
  year        = {2025},
  selected    = {true},
  pdf         = {paper.pdf},
  code        = {https://github.com/ShuRaAtum/repo},
  bibtex_show = {true},
  abbr        = {CHES}
}
```

- `selected: true` surfaces a paper to the home page's "Selected publications" block.
- Custom field `code` adds a GitHub link to the paper entry; requires a minor edit to `_layouts/bib.html` (al-folio supports custom fields via the same pattern as `pdf`).

### Projects — `_projects/<slug>.md`

```yaml
---
layout: page
title: HW-Accelerated Lattice Signatures
description: AVX-512 + AVX2 fallback. 3.4× speedup over reference.
img: assets/img/projects/lattice.jpg
github: https://github.com/ShuRaAtum/repo
paper: /en/publications/#kim2025lattice
category: implementation   # implementation | tool | course
importance: 1
lang: en
---
```

### CV — `_pages/cv_{en,ko}.md`

Structured sections (Education, Research Experience, Publications snapshot, Skills, Awards). Top-right `Download PDF` button links to `assets/pdf/cv_en.pdf` on `/en/cv/` and `assets/pdf/cv_ko.pdf` on `/ko/cv/`.

For v1, both PDFs may point to the same English file; owner can add a separate Korean PDF later without template changes. The PDF is maintained as a separate artifact (LaTeX source recommended) — the on-site page and the PDF can diverge slightly in formatting but must stay in sync on facts.

### Blog — `_posts/YYYY-MM-DD-slug.md`

Front matter: `lang: en|ko`, `categories: [notes|paper-summary|implementation]`, `date`, `title`. Listings filter by current `page.lang`.

## Visual Design

**Accent color:** `#0a66c2` (Academic Blue). Used for links, tags, focus states. Dark-mode variant: `#5aa3ec` (lighter, same hue).

**Typography:**
- Body (English-first): Roboto (al-folio default).
- Body (Korean): **Pretendard** via CDN, scoped through `:lang(ko)` selectors so it activates only on Korean pages and Korean text spans inside English pages.
  - CDN: `https://cdn.jsdelivr.net/gh/orioncactus/pretendard@latest/dist/web/static/pretendard.css`
- Headings: Roboto Slab (al-folio default) for English, Pretendard 700 for Korean.
- Code: JetBrains Mono.

**Layout — Home (About):** Two-column on desktop (180–200 px profile photo on the left, bio + contact links on the right), single column on mobile. Below: a "News" list of 3–5 recent items. Below News: a "Selected publications" block (3 items pulled from `selected: true` in `papers.bib`).

**Dark mode:** al-folio's built-in toggle. Default to system preference.

**Out of scope (YAGNI):** parallax, page transitions, glass/neumorphism effects, custom WebGL backgrounds. The goal is clarity and signal — not decoration.

## Deployment

- **Branch model:** `main` holds source; `gh-pages` (auto-generated) serves the site.
- **Actions workflow:** al-folio's bundled `deploy.yml` runs on push to `main`, builds with Ruby 3.x + Node 18+, pushes built site to `gh-pages`.
- **First deploy:** minimum-viable state — placeholder About, one BibTeX entry, one project card, CV skeleton + placeholder PDF. The site must build green before adding more content.
- **Custom domain:** deferred. Default URL `https://shuraatum.github.io` for now. Switching later requires only `_config.yml` `url` change + `CNAME` file + DNS records.

## Constraints & Decisions Log

- al-folio chosen over `academicpages` and custom-minimal because BibTeX automation has high long-term value for a research portfolio and the dark-mode + KaTeX defaults are already production-grade.
- Full bilingual mirroring (vs. English-only + Korean About page) chosen because the owner expects both domestic and international job applications.
- Custom Ruby plugins avoided in favor of the existing Actions build pipeline (GitHub Pages compatibility is then irrelevant — Actions does the build).
- `selected` papers limited to ~3 on the home page to keep above-the-fold focused.

## Open Questions (resolve during implementation)

- Initial bio text and profile photo — to be drafted by the owner.
- Real `papers.bib` content — owner to provide list of publications.
- Real `cv.pdf` — owner to provide LaTeX source or finished PDF.
- Whether to enable Disqus/Giscus comments on blog posts (default: disabled).

## Success Criteria

1. `https://shuraatum.github.io/` and `https://shuraatum.github.io/ko/` both render with the chosen theme and accent color.
2. Adding a new entry to `papers.bib` shows up on Publications without other edits.
3. Adding a Markdown file under `_projects/` shows up on Projects without other edits.
4. Language switcher round-trips: clicking 한국어 on `/en/publications/` lands on `/ko/publications/`, and vice versa.
5. `Download PDF` on `/en/cv/` (and `/ko/cv/`) downloads `assets/pdf/cv.pdf`.
6. The site builds and deploys green from a clean `git clone` + push to `main`.
