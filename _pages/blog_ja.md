---
layout: page
permalink: /ja/blog/
title: ブログ
description: 研究ノート、論文の要約、実装メモ。
nav: false
lang: ja
---

<div class="post-list">
{%- assign posts = site.posts | where: "lang", "ja" -%}
{%- for post in posts -%}
<article class="post-item">
  <h3><a href="{{ post.url | relative_url }}">{{ post.title }}</a></h3>
  <div class="post-meta">{{ post.date | date: "%Y-%m-%d" }} · {{ post.categories | join: ", " }}</div>
  {% if post.description %}<p>{{ post.description }}</p>{% endif %}
</article>
{%- endfor -%}
{%- if posts.size == 0 -%}
{%- assign blog_strings_key = "strings_" | append: page.lang -%}
<p class="empty-state">{{ site.data[blog_strings_key].blog.empty }}</p>
{%- endif -%}
</div>
