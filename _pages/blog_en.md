---
layout: page
permalink: /en/blog/
title: Blog
description: Research notes, paper summaries, implementation deep-dives.
nav: false
pagination:
  enabled: true
lang: en
---

<div class="post-list">
{%- assign posts = site.posts | where: "lang", "en" -%}
{%- for post in posts -%}
<article class="post-item">
  <h3><a href="{{ post.url | relative_url }}">{{ post.title }}</a></h3>
  <div class="post-meta">{{ post.date | date: "%Y-%m-%d" }}, {{ post.categories | join: ", " }}</div>
  {% if post.description %}<p>{{ post.description }}</p>{% endif %}
</article>
{%- endfor -%}
{%- if posts.size == 0 -%}
{%- assign blog_strings_key = "strings_" | append: page.lang -%}
<p class="empty-state">{{ site.data[blog_strings_key].blog.empty }}</p>
{%- endif -%}
</div>
