---
layout: page
permalink: /ko/blog/
title: 글
description: 연구 노트, 논문 요약, 구현 노트.
nav: false
lang: ko
---

<div class="post-list">
{%- assign posts = site.posts | where: "lang", "ko" -%}
{%- for post in posts -%}
<article class="post-item">
  <h3><a href="{{ post.url | relative_url }}">{{ post.title }}</a></h3>
  <div class="post-meta">{{ post.date | date: "%Y-%m-%d" }} · {{ post.categories | join: ", " }}</div>
  {% if post.description %}<p>{{ post.description }}</p>{% endif %}
</article>
{%- endfor -%}
</div>
