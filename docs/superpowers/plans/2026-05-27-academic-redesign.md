# Academic Redesign Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the "editorial" visual style (oversized name, kicker, accent dot, photo-as-aside) with a "Modern Academic" hero block (photo + name + affiliation + inline links) and a unified small-uppercase section-label pattern across About, CV, Publications, and Blog pages — while keeping Academic Blue and Pretendard.

**Architecture:** Mostly local Jekyll overrides. (1) Append new `academic-*` SCSS to `_sass/_overrides.scss`. (2) Rewrite `_layouts/about.liquid`. (3) Rewrite `_layouts/cv.liquid`. (4) Add a thin local `_layouts/page.liquid` override that swaps `.post-title` for the new academic header. (5) Update `_pages/about_{en,ko}.md` front-matter with new fields (`role`, `lab`, `university`, `advisor`, `links`). (6) Strip the no-longer-used `editorial-*` rules from `_sass/_overrides.scss`.

**Tech Stack:** Jekyll 4 (via `al_folio_core` 1.0.9), Liquid templates, SCSS, Bootstrap 5 base. No JS changes. No new dependencies.

**Verification approach:** Each task ends with `bundle exec jekyll build --baseurl /al-folio` to catch Liquid/SCSS errors, plus a `grep` check on a rendered HTML file to confirm the expected markup is emitted. The final task adds a manual browser-check checkpoint (light + dark, EN + KO) before the final cleanup commit.

**Spec:** [../specs/2026-05-27-academic-redesign-design.md](../specs/2026-05-27-academic-redesign-design.md)

---

## File Structure

**Modified:**
- `_sass/_overrides.scss` — remove `editorial-*` rules; add `academic-*` rules.
- `_layouts/about.liquid` — full rewrite.
- `_layouts/cv.liquid` — strip editorial wrapper; use new section-label class.
- `_pages/about_en.md`, `_pages/about_ko.md` — front-matter cleanup + new fields.
- `_data/strings_en.yml`, `_data/strings_ko.yml` — add `home.about_heading`.

**Created:**
- `_layouts/page.liquid` — local override of al-folio's default `page.liquid` so Publications/Blog header uses `.academic-section-label`.

**Untouched:**
- `_layouts/default.liquid`, `_includes/*` — no changes.
- `_pages/publications_*.md`, `_pages/blog_*.md`, `_pages/cv_*.md` — no front-matter changes.
- Navbar / language switcher / project card / cv-entry SCSS — preserved.
- `_bibliography/`, `_news/`, `_books/` — untouched.

---

## Task 1: Add bilingual `home.about_heading` strings

**Files:**
- Modify: `_data/strings_en.yml`
- Modify: `_data/strings_ko.yml`

**Why:** The new about layout uses a section label "About" that should respect the page language. Other section headings (`selected_publications_heading`, `news_heading`) already exist; we just need to add `about_heading`.

- [ ] **Step 1: Add `about_heading` to English strings**

Edit `_data/strings_en.yml` — under the `home:` key, add `about_heading: about` so the file reads:

```yaml
nav:
  about: about
  publications: publications
  projects: projects
  cv: cv
  blog: blog
home:
  about_heading: about
  news_heading: news
  selected_publications_heading: selected publications
cv:
  download_pdf: Download PDF
lang:
  switch_to_other: 한국어
  current: EN
```

- [ ] **Step 2: Add `about_heading` to Korean strings**

Edit `_data/strings_ko.yml` — under `home:`, add `about_heading: 소개`:

```yaml
nav:
  about: 소개
  publications: 논문
  projects: 프로젝트
  cv: 이력
  blog: 글
home:
  about_heading: 소개
  news_heading: 소식
  selected_publications_heading: 주요 논문
cv:
  download_pdf: PDF 다운로드
lang:
  switch_to_other: English
  current: KO
```

- [ ] **Step 3: Build to verify YAML parses**

Run: `bundle exec jekyll build --baseurl /al-folio`
Expected: Build succeeds (exit 0). No `Liquid Exception: undefined method` errors.

- [ ] **Step 4: Commit**

```bash
git add _data/strings_en.yml _data/strings_ko.yml
git commit -m "Add bilingual 'about' section heading strings"
```

---

## Task 2: Append new `academic-*` SCSS classes (additive)

**Files:**
- Modify: `_sass/_overrides.scss` (append at end of file, before the `@layer components` block)

**Why:** Add the new classes used by the rewritten layouts. Done as an additive change so the build keeps succeeding while we work — the old `editorial-*` rules are still in place until Task 7.

- [ ] **Step 1: Append new classes**

Open `_sass/_overrides.scss`. After the existing CSS but before the final `@layer components { ... }` block (which begins around the line `@layer components {`), insert this block:

```scss
// ----------------------------------------------------------------------------
// Academic (A3) style — Modern Academic. Replaces editorial-* hero treatment.
// Photo + name + affiliation as a horizontal hero block; small uppercase
// section labels for "About", "Selected Publications", etc.
// ----------------------------------------------------------------------------

.academic-page {
  max-width: 880px;
  margin: 0 auto;
  padding: 1rem 0 4rem;
}

.academic-hero {
  display: grid;
  grid-template-columns: 120px minmax(0, 1fr);
  gap: 1.4rem;
  align-items: start;
  margin: 1rem 0 2rem;

  @media (max-width: 575.98px) {
    grid-template-columns: 1fr;
    gap: 1rem;
  }
}

.academic-hero-photo {
  picture, figure { margin: 0; width: 120px; max-width: 100%; }

  img {
    width: 120px !important;
    max-width: 100%;
    height: 120px !important;
    aspect-ratio: 1 / 1;
    object-fit: cover;
    border-radius: 6px;
    display: block;
  }
}

.academic-hero-info {
  .academic-name {
    font-size: 1.5rem;
    font-weight: 700;
    letter-spacing: -0.01em;
    margin: 0 0 0.35rem;
    line-height: 1.2;
  }

  .academic-role {
    font-size: 0.95rem;
    color: var(--global-text-color);
    margin: 0 0 0.2rem;
    line-height: 1.45;
  }

  .academic-affil {
    font-size: 0.9rem;
    color: var(--global-text-color-light);
    margin: 0 0 0.15rem;
    line-height: 1.45;

    a {
      color: var(--global-theme-color);
      text-decoration: none;
      &:hover { color: var(--global-hover-color); text-decoration: underline; }
    }
  }

  :lang(ko) & .academic-name {
    letter-spacing: -0.02em;
  }
}

.academic-links {
  margin-top: 0.7rem;
  font-size: 0.88rem;
  line-height: 1.5;

  a {
    color: var(--global-theme-color);
    text-decoration: none;
    &:hover { color: var(--global-hover-color); text-decoration: underline; }
  }

  .sep {
    color: var(--global-divider-color);
    margin: 0 0.4rem;
    user-select: none;
  }
}

.academic-section {
  margin-top: 2rem;
}

.academic-section-label {
  font-size: 0.72rem;
  font-weight: 700;
  letter-spacing: 0.18em;
  text-transform: uppercase;
  color: var(--global-text-color-light);
  margin: 0 0 0.7rem;
  padding-bottom: 0.4rem;
  border-bottom: 1px solid var(--global-divider-color);
}

.academic-prose {
  font-size: 0.95rem;
  line-height: 1.65;
  color: var(--global-text-color);

  p { margin: 0 0 0.85rem; }
  p:last-child { margin-bottom: 0; }
  strong { font-weight: 600; }
  a { color: var(--global-theme-color); }
  a:hover { color: var(--global-hover-color); }
}

.academic-social {
  margin-top: 2rem;

  .contact-icons {
    font-size: 1.25rem;
    a { margin-right: 0.55rem; }
  }
}

// Publications and Blog index pages — emitted by the local page.liquid
// override (Task 5). The post-header is replaced with .academic-section-label.
.academic-page-header {
  margin-top: 0.5rem;
  margin-bottom: 1.5rem;

  .academic-section-label { margin-bottom: 0.4rem; }

  .academic-page-description {
    font-size: 0.95rem;
    color: var(--global-text-color);
    line-height: 1.6;
    margin: 0;
  }
}
```

- [ ] **Step 2: Build to verify SCSS compiles**

Run: `bundle exec jekyll build --baseurl /al-folio`
Expected: Build succeeds. No `Sass::SyntaxError`.

- [ ] **Step 3: Verify CSS is emitted in the compiled stylesheet**

Run: `grep -c 'academic-hero' _site/assets/css/main.css`
Expected: A positive integer (≥ 1).

- [ ] **Step 4: Commit**

```bash
git add _sass/_overrides.scss
git commit -m "Add academic-* SCSS classes (A3 redesign — additive)"
```

---

## Task 3: Rewrite `_layouts/about.liquid` to use the academic hero

**Files:**
- Modify: `_layouts/about.liquid` (full rewrite)

- [ ] **Step 1: Replace `_layouts/about.liquid` with the new layout**

Overwrite the file with this content exactly:

```liquid
---
layout: default
---
{%- assign s = nil -%}
{%- if page.lang -%}
  {%- assign strings_key = "strings_" | append: page.lang -%}
  {%- assign s = site.data[strings_key] -%}
{%- endif -%}

<div class="post academic-page academic-about">

  <header class="academic-hero">
    {% if page.profile and page.profile.image %}
      {% assign profile_image_path = page.profile.image | prepend: 'assets/img/' %}
      <div class="academic-hero-photo">
        {%
          include figure.liquid
          loading="eager"
          path=profile_image_path
          class="img-fluid"
          alt=page.profile.image
          cache_bust=true
        %}
      </div>
    {% endif %}

    <div class="academic-hero-info">
      <h1 class="academic-name">
        {% if site.title == 'blank' %}
          {{ site.first_name }}{% if site.middle_name and site.middle_name != "" %} {{ site.middle_name }}{% endif %} {{ site.last_name }}
        {% else %}
          {{ site.title }}
        {% endif %}
      </h1>

      {% if page.role %}<p class="academic-role">{{ page.role }}</p>{% endif %}

      {% if page.lab or page.university %}
        <p class="academic-affil">
          {% if page.lab %}{% if page.lab.url %}<a href="{{ page.lab.url }}">{{ page.lab.name }}</a>{% else %}{{ page.lab.name }}{% endif %}{% endif %}{% if page.lab and page.university %}, {% endif %}{% if page.university %}{{ page.university }}{% endif %}
        </p>
      {% endif %}

      {% if page.advisor %}
        <p class="academic-affil">
          Advised by
          {% if page.advisor.url %}<a href="{{ page.advisor.url }}">{{ page.advisor.name }}</a>{% else %}{{ page.advisor.name }}{% endif %}
        </p>
      {% endif %}

      {% if page.links %}
        <p class="academic-links">
          {% for link in page.links %}{% unless forloop.first %}<span class="sep">·</span>{% endunless %}<a href="{{ link.url }}"{% if link.url contains '://' %} target="_blank" rel="noopener noreferrer"{% endif %}>{{ link.label }}</a>{% endfor %}
        </p>
      {% endif %}
    </div>
  </header>

  <article class="academic-body">

    <section class="academic-section">
      <p class="academic-section-label">{% if s %}{{ s.home.about_heading }}{% else %}about{% endif %}</p>
      <div class="academic-prose">{{ content }}</div>
    </section>

    {% if page.selected_papers %}
      <section class="academic-section">
        <p class="academic-section-label">{% if s %}{{ s.home.selected_publications_heading }}{% else %}selected publications{% endif %}</p>
        {% include selected_papers.liquid %}
      </section>
    {% endif %}

    {% if page.social %}
      <section class="academic-section academic-social">
        <div class="contact-icons">{% social_links %}</div>
        {% if site.contact_note %}<div class="contact-note">{{ site.contact_note }}</div>{% endif %}
      </section>
    {% endif %}

  </article>
</div>
```

Note: this layout intentionally **omits** the `announcements` block. Per the spec, News is excluded.

- [ ] **Step 2: Build to verify Liquid renders**

Run: `bundle exec jekyll build --baseurl /al-folio`
Expected: Build succeeds. Warnings about missing `page.role` etc. are OK at this point — the front-matter is updated in Task 4 / Task 5.

- [ ] **Step 3: Verify the new markup is emitted**

Run: `grep -c 'academic-hero' _site/en/index.html`
Expected: ≥ 1 (the hero block markup is present).

Run: `grep -c 'editorial-title' _site/en/index.html`
Expected: 0 (the old oversized name is gone).

- [ ] **Step 4: Commit**

```bash
git add _layouts/about.liquid
git commit -m "Rewrite about layout with academic hero (A3)"
```

---

## Task 4: Update `_pages/about_en.md` front-matter and trim body

**Files:**
- Modify: `_pages/about_en.md`

- [ ] **Step 1: Replace `_pages/about_en.md` front-matter**

Replace the front-matter (everything between the `---` markers at the top of the file) with:

```yaml
---
layout: about
title: about
permalink: /en/
lang: en

role: "Ph.D. Candidate · Information & Computer Engineering"
lab:
  name: CryptoCraft Lab
  url: https://sites.google.com/view/cc-hs
university: Hansung University
advisor:
  name: Prof. Hwa-Jeong Seo
  url: https://scholar.google.co.kr/citations?user=NJTYsz0AAAAJ

links:
  - label: Email
    url: mailto:shuraatum@gmail.com
  - label: CV
    url: /en/cv/
  - label: Scholar
    url: https://scholar.google.com/citations?user=YOUR_ID
  - label: GitHub
    url: https://github.com/ShuRaAtum

profile:
  image: prof_pic.jpg

selected_papers: true
social: true

announcements:
  enabled: false
---
```

Notes:
- Replace `YOUR_ID` in the Scholar URL with the real Google Scholar user ID before committing. If the user does not have one yet, omit that link entry entirely.
- Verify `prof_pic.jpg` matches the current `_config.yml` `profile_image` setting — a recent commit (`ca06884`) replaced the image with `IMG_5425.jpg`. If `_config.yml` now points to `IMG_5425.jpg`, use `image: IMG_5425.jpg` instead.

Body content (everything after the second `---`) is unchanged.

- [ ] **Step 2: Build and verify the page renders without errors**

Run: `bundle exec jekyll build --baseurl /al-folio`
Expected: Build succeeds. No `undefined method` errors.

- [ ] **Step 3: Verify content is emitted correctly**

Run: `grep -c 'CryptoCraft Lab' _site/en/index.html`
Expected: ≥ 1.

Run: `grep -c 'academic-links' _site/en/index.html`
Expected: ≥ 1.

Run: `grep -c 'editorial-kicker' _site/en/index.html`
Expected: 0.

- [ ] **Step 4: Commit**

```bash
git add _pages/about_en.md
git commit -m "Update about_en front-matter for academic hero (drop kicker/tagline; add role/lab/advisor/links)"
```

---

## Task 5: Update `_pages/about_ko.md` front-matter and trim body

**Files:**
- Modify: `_pages/about_ko.md`

- [ ] **Step 1: Replace `_pages/about_ko.md` front-matter**

Replace the front-matter (everything between the `---` markers at the top of the file) with:

```yaml
---
layout: about
title: 소개
permalink: /ko/
lang: ko

role: "박사과정 · 정보컴퓨터공학과"
lab:
  name: CryptoCraft 연구실
  url: https://sites.google.com/view/cc-hs
university: 한성대학교
advisor:
  name: 서화정 교수님
  url: https://scholar.google.co.kr/citations?user=NJTYsz0AAAAJ

links:
  - label: 이메일
    url: mailto:shuraatum@gmail.com
  - label: 이력서
    url: /ko/cv/
  - label: Scholar
    url: https://scholar.google.com/citations?user=YOUR_ID
  - label: GitHub
    url: https://github.com/ShuRaAtum

profile:
  image: prof_pic.jpg

selected_papers: true
social: true

announcements:
  enabled: false
---
```

Notes:
- Replace `YOUR_ID` with the real Google Scholar user ID or omit the entry.
- Match the `profile.image` filename to whatever `about_en.md` uses.
- Body content (everything after the second `---`) is unchanged.

The phrase "Advised by" in the layout is in English. For the Korean page we accept the English phrase as a stylistic compromise (academic norm; consistent with how Korean academic pages often render). If the user wants it translated, that's a follow-up — for now the advisor name itself ("서화정 교수님") carries the meaning.

- [ ] **Step 2: Build and verify**

Run: `bundle exec jekyll build --baseurl /al-folio`
Expected: Build succeeds.

- [ ] **Step 3: Verify Korean content**

Run: `grep -c '한성대학교' _site/ko/index.html`
Expected: ≥ 1.

Run: `grep -c '서화정' _site/ko/index.html`
Expected: ≥ 1.

- [ ] **Step 4: Commit**

```bash
git add _pages/about_ko.md
git commit -m "Update about_ko front-matter for academic hero"
```

---

## Task 6: Rewrite `_layouts/cv.liquid` to use the academic section-label header

**Files:**
- Modify: `_layouts/cv.liquid`

- [ ] **Step 1: Replace `_layouts/cv.liquid` with the simplified version**

Overwrite the file with this content exactly:

```liquid
---
layout: default
---
{%- assign lang = page.lang | default: "en" -%}
{%- if lang == "ko" -%}
  {%- assign cv_data = site.data.cv_ko.cv -%}
{%- else -%}
  {%- assign cv_data = site.data.cv.cv -%}
{%- endif -%}

<div class="post academic-page cv-page">

  <header class="academic-page-header">
    <p class="academic-section-label">
      {{ page.title }}
      {% if page.cv_pdf %}
        <a class="cv-pdf-link" href="{{ page.cv_pdf | relative_url }}" target="_blank" rel="noopener noreferrer" title="Download PDF">
          <i class="fa-solid fa-file-pdf"></i>
        </a>
      {% endif %}
    </p>
    {% if cv_data.label %}<p class="academic-page-description">{{ cv_data.label }}</p>{% endif %}
  </header>

  <article class="cv-content">
    {% if cv_data.summary %}
      <p class="cv-summary">{{ cv_data.summary }}</p>
    {% endif %}

    {% if cv_data.location or cv_data.email %}
      <p class="cv-meta">
        {% if cv_data.email %}<a href="mailto:{{ cv_data.email }}">{{ cv_data.email }}</a>{% endif %}
        {% if cv_data.email and cv_data.location %} · {% endif %}
        {% if cv_data.location %}{{ cv_data.location }}{% endif %}
      </p>
    {% endif %}

    {% for section in cv_data.sections %}
      {%- assign section_name = section[0] -%}
      {%- assign entries = section[1] -%}
      <section class="academic-section">
        <p class="academic-section-label">{{ section_name }}</p>

        <ul class="cv-section-list">
          {% for entry in entries %}
            <li class="cv-entry">
              <div class="cv-entry-row">
                <div class="cv-entry-when">
                  {% if entry.start_date or entry.end_date %}
                    <span>{{ entry.start_date }}{% if entry.end_date %} — {{ entry.end_date }}{% endif %}</span>
                  {% elsif entry.date %}
                    <span>{{ entry.date }}</span>
                  {% endif %}
                </div>
                <div class="cv-entry-body">
                  {%- if entry.institution -%}
                    <strong>{{ entry.studyType }}, {{ entry.area }}</strong><br>
                    <span class="cv-entry-where">{{ entry.institution }}{% if entry.location %} · {{ entry.location }}{% endif %}</span>
                  {%- elsif entry.company -%}
                    <strong>{{ entry.position }}</strong><br>
                    <span class="cv-entry-where">{{ entry.company }}{% if entry.location %} · {{ entry.location }}{% endif %}</span>
                  {%- elsif entry.title -%}
                    {{ entry.title }}
                  {%- elsif entry.name -%}
                    <strong>{{ entry.name }}</strong>
                    {%- if entry.summary %}<br><span class="cv-entry-where">{{ entry.summary }}</span>{%- endif -%}
                    {%- if entry.keywords %}<br><span class="cv-entry-keywords">{{ entry.keywords }}</span>{%- endif -%}
                  {%- endif -%}

                  {% if entry.highlights %}
                    <ul class="cv-entry-highlights">
                      {% for hl in entry.highlights %}<li>{{ hl }}</li>{% endfor %}
                    </ul>
                  {% endif %}
                  {% if entry.summary and entry.company %}<p class="cv-entry-summary">{{ entry.summary }}</p>{% endif %}
                </div>
              </div>
            </li>
          {% endfor %}
        </ul>
      </section>
    {% endfor %}
  </article>
</div>
```

This preserves all the CV entry rendering logic but swaps the editorial wrapper for the academic page wrapper.

- [ ] **Step 2: Build and verify**

Run: `bundle exec jekyll build --baseurl /al-folio`
Expected: Build succeeds.

- [ ] **Step 3: Verify CV page emits the new markup and not the old**

Run: `grep -c 'academic-page-header' _site/en/cv/index.html`
Expected: ≥ 1.

Run: `grep -c 'editorial-title' _site/en/cv/index.html`
Expected: 0.

Run: `grep -c 'cv-entry-when' _site/en/cv/index.html`
Expected: ≥ 1 (CV entries still render).

- [ ] **Step 4: Commit**

```bash
git add _layouts/cv.liquid
git commit -m "Rewrite cv layout with academic section-label header"
```

---

## Task 7: Create local `_layouts/page.liquid` override for Publications and Blog

**Files:**
- Create: `_layouts/page.liquid`

**Why:** Publications and Blog index pages use `layout: page`, which al-folio's gem renders as `<h1 class="post-title">{{ page.title }}</h1>` + `<p class="post-description">{{ page.description }}</p>`. We want the same academic section-label pattern as CV. Overriding `page.liquid` locally is the cleanest path and is contained to this site.

- [ ] **Step 1: Create `_layouts/page.liquid`**

Create the file with this content:

```liquid
---
layout: default
---
{% if page._styles %}
  <style type="text/css">
    {{ page._styles }}
  </style>
{% endif %}

<div class="post academic-page">

  <header class="academic-page-header">
    <p class="academic-section-label">{{ page.title }}</p>
    {% if page.description %}<p class="academic-page-description">{{ page.description }}</p>{% endif %}
  </header>

  <article>
    {{ content }}
  </article>

  {% if page.related_publications %}
    <section class="academic-section">
      <p class="academic-section-label">references</p>
      <div class="publications">
        {% bibliography --cited_in_order %}
      </div>
    </section>
  {% endif %}

  {% if site.plugins contains 'al_comments' %}
    {% include plugins/al_comments.liquid %}
  {% endif %}
</div>
```

This mirrors the upstream `al_folio_core/_layouts/page.liquid` structure (so `_styles`, `related_publications`, and `al_comments` keep working) but swaps `.post-header / .post-title / .post-description` for the academic section-label pattern.

- [ ] **Step 2: Build and verify Publications and Blog index pages**

Run: `bundle exec jekyll build --baseurl /al-folio`
Expected: Build succeeds.

Run: `grep -c 'academic-page-header' _site/en/publications/index.html`
Expected: ≥ 1.

Run: `grep -c 'academic-page-header' _site/en/blog/index.html`
Expected: ≥ 1.

Run: `grep -c 'post-title' _site/en/publications/index.html`
Expected: 0.

- [ ] **Step 3: Acknowledge the new local override in `.al-folio-overrides.yml`**

Run this command to compute the upstream SHA and the new local SHA:

```bash
UPSTREAM=$(sha256sum vendor/bundle/ruby/3.2.0/gems/al_folio_core-1.0.9/_layouts/page.liquid | awk '{print $1}')
LOCAL=$(sha256sum _layouts/page.liquid | awk '{print $1}')
echo "upstream_sha256: $UPSTREAM"
echo "local_sha256: $LOCAL"
```

Then edit `.al-folio-overrides.yml` and append a new entry under `overrides:`:

```yaml
  _layouts/page.liquid:
    owner: al_folio_core
    gem_version: 1.0.9
    upstream_path: _layouts/page.liquid
    upstream_sha256: <paste UPSTREAM from above>
    local_sha256: <paste LOCAL from above>
    acknowledged_at: '2026-05-27'
```

This keeps the override-audit tooling (`bundle exec al-folio upgrade overrides audit`) happy on the next al-folio upgrade.

- [ ] **Step 4: Commit**

```bash
git add _layouts/page.liquid .al-folio-overrides.yml
git commit -m "Override page layout with academic section-label header"
```

---

## Task 8: Remove the now-unused `editorial-*` CSS rules

**Files:**
- Modify: `_sass/_overrides.scss`

**Why:** Now that no template references `editorial-*`, the CSS is dead. Strip it for cleanliness — but keep the navbar polish, the `:lang(ko)` Pretendard rules, the language switcher rules, the `.cv-entry-*` rules, the `.projects` card rules, and the `--global-theme-color` overrides.

- [ ] **Step 1: Verify no template still references `editorial-*`**

Run: `grep -rn 'editorial-' _layouts/ _includes/ _pages/`
Expected: No output (no remaining references).

If any references are found, fix them before continuing.

- [ ] **Step 2: Delete the editorial block from `_sass/_overrides.scss`**

In `_sass/_overrides.scss`, delete the entire block between (and including) the lines:

- The comment block that begins `// Editorial style overrides — applied to About page hero and section dividers.`
- Through the closing brace of the last `.editorial-*` rule (`.editorial-social { ... }`).

This is roughly the block from approximately line 39 (`// ---------- ... Editorial style overrides ...`) through line ~178 of the current file. Be careful not to delete the surrounding rules: keep `.lang-switcher`, `:lang(ko)`, `:root`, `html[data-theme="dark"]`, `.projects`, `.cv-page`, `.cv-section-list`, `.cv-entry*`, `nav#navbar`, and the `@layer components` block.

The `.cv-page` rule may include `.editorial-title--small` — delete that nested rule but keep the `.cv-page { .cv-pdf-link { ... } .cv-summary { ... } .cv-meta { ... } }` rules intact (those are still used by the new cv layout).

- [ ] **Step 3: Build and verify**

Run: `bundle exec jekyll build --baseurl /al-folio`
Expected: Build succeeds.

- [ ] **Step 4: Verify the compiled CSS no longer contains editorial rules**

Run: `grep -c 'editorial-kicker\|editorial-title\|editorial-rule\|editorial-hero\|editorial-grid' _site/assets/css/main.css`
Expected: 0.

Run: `grep -c 'academic-hero\|academic-section-label' _site/assets/css/main.css`
Expected: ≥ 2 (both classes still emitted).

Run: `grep -c '\.cv-entry-when\|\.cv-entry-where' _site/assets/css/main.css`
Expected: ≥ 2 (CV-entry rules preserved).

- [ ] **Step 5: Commit**

```bash
git add _sass/_overrides.scss
git commit -m "Remove editorial-* SCSS (superseded by academic-* rules)"
```

---

## Task 9: Manual browser verification + final wrap

**Why:** The build verifies markup compiles; only a human can confirm the design looks right in light/dark and EN/KO. This task is a checkpoint, not code.

- [ ] **Step 1: Serve the site locally**

Run: `bundle exec jekyll serve --baseurl /al-folio`
Expected: Server starts on `http://127.0.0.1:4000/al-folio/`.

- [ ] **Step 2: Open each page in a browser and confirm**

Open each URL and visually verify:

| URL | What to check |
|-----|---------------|
| `http://127.0.0.1:4000/al-folio/en/` | About page: photo on left, name + role + affiliation + advisor + links on right. "About" section label, then bio prose. "Selected Publications" section. Social icons at bottom. No oversized name. No accent dot. No big black rule. |
| `http://127.0.0.1:4000/al-folio/ko/` | Same as above, in Korean. Pretendard renders for the name and prose. |
| `http://127.0.0.1:4000/al-folio/en/cv/` | "CV" section label with PDF icon. Education / Experience / etc. as section-label headings. CV entries render with date column + body column. No oversized title. |
| `http://127.0.0.1:4000/al-folio/ko/cv/` | Same as above, in Korean. |
| `http://127.0.0.1:4000/al-folio/en/publications/` | "publications" section label + description. BibTeX list below. |
| `http://127.0.0.1:4000/al-folio/en/blog/` | "blog" section label + description. Post list below. |

Toggle dark mode (the navbar toggle) on the About and CV pages and confirm:
- Hero block readable.
- Section label borders visible against dark background.
- Links use `#5aa3ec` (lighter blue).

Resize the browser narrow (≤575px) and confirm the hero block stacks photo above info on the About page.

- [ ] **Step 3: If anything looks wrong, fix inline**

For each issue: edit the relevant file, run `bundle exec jekyll build`, re-verify in the browser, then commit with a `Polish:` prefixed message. Do not batch unrelated polish into one commit.

- [ ] **Step 4: Final state commit (if any polish landed)**

If Step 3 produced polish commits, no further commit is needed — they were already made individually.

If Step 3 produced no changes, the redesign is complete as of Task 8's commit.

- [ ] **Step 5: Sanity-check git log**

Run: `git log --oneline -10`
Expected: The most recent commits should describe the redesign, in order, with no half-done states.

---

## Out-of-Scope (not in this plan)

- Visual regression baseline updates — this fork does not ship Playwright tests locally (the AGENTS.md command list is for the upstream starter; this fork has no `npm run test:visual`). Browser verification in Task 9 substitutes.
- Removing the `_pages/news.md` file (if any unused) — leave as-is unless it actually breaks the build.
- Updating the `selected_papers` BibTeX list itself.
- Changing the navbar.
- Changing the color palette or Korean font.
- Translating the "Advised by" prefix to Korean (deferred — accepted as English in the Korean page for now).
