# Academic Redesign — Design Spec

**Date:** 2026-05-27
**Owner:** ShuRaAtum
**Scope:** Visual redesign of the existing al-folio CV site (`shuraatum.github.io`) — replace the current "editorial" treatment with a "Modern Academic" look (A3) inspired by clean academic homepage style (e.g. aayushjain.dev, yossigi.github.io).

## Purpose

The current site uses an editorial style (oversized name "Si-Woo Eum.", uppercase kicker, large rule, profile photo as right-aside) that emphasizes visual personality. The owner wants a more conventional academic homepage feel — photo + name + affiliation as a horizontal hero block, small uppercase section labels, no oversized name treatment — while keeping the existing color (Academic Blue) and Korean font (Pretendard) decisions.

Scope: all four user-facing pages get the new treatment.

## Audience

Same as the parent spec ([../specs/2026-05-26-cv-site-design.md](2026-05-26-cv-site-design.md)): recruiters / hiring committees and academic peers. The new tone prioritizes academic legibility over editorial distinctiveness.

## Visual System (global)

Used across About, CV, Publications, Blog.

**Typography**
- Body: 0.95rem, line-height 1.65.
- English: system sans (`-apple-system, "Helvetica Neue", Arial, sans-serif`). No new web font for English — keep load light.
- Korean: Pretendard (already configured via `:lang(ko)` and CDN import — unchanged).
- Headings: same family, 600–700 weight. No serif. No oversized display.

**Color**
- Primary accent (light): `#0a66c2` (Academic Blue) — unchanged.
- Primary accent (dark theme): `#5aa3ec` — unchanged.
- Body text: al-folio default `--global-text-color`.
- Section dividers: 1px solid `--global-divider-color`.

**Section label pattern** (reused everywhere)
```scss
.academic-section-label {
  font-size: 0.72rem;
  font-weight: 700;
  letter-spacing: 0.18em;
  text-transform: uppercase;
  color: var(--global-text-color-light);
  margin: 0 0 0.6rem;
  padding-bottom: 0.4rem;
  border-bottom: 1px solid var(--global-divider-color);
}
```

This single class is used for "About", "Selected Publications", "Publications", "Blog", "CV", "Education", "Experience", etc.

## About Page

**Layout** (top-down):

1. **Hero block** — CSS grid, two columns on ≥640px (photo 120px column + info column), stacks on mobile.
   - Left: profile photo 120×120, `border-radius: 6px`, `object-fit: cover`.
   - Right:
     - `h1` name — `1.5rem`, weight 700, `letter-spacing: -0.01em`.
     - Role line — e.g. "Ph.D. Candidate · Information & Computer Engineering".
     - Affiliation line — e.g. "[CryptoCraft Lab](https://sites.google.com/view/cc-hs), Hansung University".
     - Advisor line — e.g. "Advised by [Prof. Hwa-Jeong Seo](https://scholar.google.co.kr/citations?user=NJTYsz0AAAAJ)".
     - Inline link row — Email · CV · Scholar · GitHub (separated by `·`, accent-color links).

2. **About section** — section label "About" + prose body (current bio content from `about_en.md` / `about_ko.md`, kept as Markdown body of the page).

3. **Selected Publications section** — section label + existing `selected_papers.liquid` include (already provided by `al_folio_core`). No change to the include itself.

4. **Social row** — small icons (mailto / Scholar / GitHub / CV PDF) at the bottom of the page. Reuse `{% social_links %}` from al-folio.

**Removed from current page:**
- `editorial-kicker` (uppercase tagline above name)
- `editorial-title` (oversized name with `clamp(2.75rem, 9vw, 6.5rem)`)
- `editorial-dot` (accent dot)
- `editorial-rule` (48px black bar under name)
- `editorial-grid` aside-right photo layout
- News section (`announcements.enabled: false` — explicitly omitted per user decision)

**Front-matter changes** (`about_en.md`, `about_ko.md`):
- Remove: `kicker`, `tagline`.
- Add: `role` (string), `lab` (object with `name` + `url`), `university`, `advisor` (object with `name` + `url`), `links` (ordered list of `{label, url}` items for the inline link row).
- Keep: `profile.image`, `selected_papers: true`, `social: true`, `announcements.enabled: false`.

## CV Page

- Strip the editorial wrapper. Header pattern:
  - Section label "CV" (using `.academic-section-label`).
  - Inline PDF link after the label (`.cv-pdf-link`, keeps current accent-color styling).
- Body — preserve existing CV entry structure entirely (`cv-section-list`, `cv-entry`, `cv-entry-row`, `cv-entry-when`, `cv-entry-body`, etc. all stay as-is). They already look clean.
- Section headers within CV (Education, Experience, etc.) reuse `.academic-section-label`.
- **Removed:** `editorial-title--small` heading and `editorial-rule` divider.

## Publications Page

- Uses al-folio's default `layout: page` (no local layout override).
- CSS-only restyle on `.post-header > .post-title` and `.post-description` to match section-label pattern when used on Publications/Blog pages. Scope via `body.publications-page` / `body.blog-page` class, or a CSS selector targeting `_pages/publications_*.md` rendered output.
- Alternative: minimal local `_layouts/page.liquid` override that emits `.academic-section-label` instead of `.post-title`. Decide during implementation — prefer CSS-only if feasible.

## Blog Page

- Same treatment as Publications.
- Post list (`<article class="post-item">`) keeps current structure; only the page header changes.

## Navigation

- No changes.
- Existing navbar polish (1200px container, language switcher, dark-mode toggle, responsive `navbar-expand-md`) preserved.

## Bilingual Considerations

- Same layout for `/en/*` and `/ko/*`. Content fields in front-matter are language-specific (`role`, `advisor`, etc. translated in each file).
- Pretendard already applied via `:lang(ko)` — unchanged.
- The hero block must render correctly with Korean text (longer character widths handled by `flex-wrap` / grid `minmax(0, 1fr)`).

## File-Level Changes

| File | Action |
|------|--------|
| `_layouts/about.liquid` | Full rewrite: hero block + section-labeled body + selected_papers + social. |
| `_layouts/cv.liquid` | Strip `editorial-about` / `editorial-hero` wrappers. Header becomes section-label + PDF link. CV entries unchanged. |
| `_sass/_overrides.scss` | Remove `editorial-*` rules (kicker, title, dot, rule, grid, aside, body, section, social). Add `.academic-hero`, `.academic-hero-photo`, `.academic-hero-info`, `.academic-section-label`, `.academic-links`. Keep `:lang(ko)` Pretendard rules, navbar polish, CV entry rules, project card rules, lang-switcher rules. |
| `_pages/about_en.md` | Front-matter: drop `kicker`/`tagline`; add `role`, `lab`, `university`, `advisor`, `links`. Body prose unchanged (or lightly trimmed). |
| `_pages/about_ko.md` | Same as above with Korean translations. |
| `_pages/publications_en.md` / `_ko.md` | No front-matter change. May add a `body.publications-page` hook (via Liquid front-matter `body_class`) if needed for CSS scoping. |
| `_pages/blog_en.md` / `_ko.md` | Same as publications. |
| `_pages/cv_en.md` / `_ko.md` | No front-matter change. |
| `_layouts/page.liquid` (optional) | If CSS-only scoping is awkward, create a thin local override that swaps `.post-title` for `.academic-section-label`. |

## Out of Scope

- Navigation structure changes (no new pages, no removed pages).
- News / announcements section (deferred — user explicitly excluded).
- Color palette changes.
- Korean font changes.
- Bibliography rendering changes (al-folio `bib.html` override stays).
- Lighthouse / performance optimization (separate concern).
- Dark mode tweaks beyond inherited accent color.

## Open Questions

None at design time. Implementation will resolve:
- Whether Publications/Blog header restyle is CSS-only or needs a local `page.liquid`. Prefer CSS-only.
- Exact wording of role/affiliation lines in `about_*.md` front-matter (user can edit during implementation).

## Testing

Visual regression — existing Playwright tests under `test/visual/` may need updated baselines for About/CV pages. Re-record after design is implemented and reviewed by user.

Manual check:
- Light + dark theme.
- English + Korean pages.
- Mobile (≤640px) — hero block stacks vertically.
- Section labels render with consistent spacing across all four pages.
