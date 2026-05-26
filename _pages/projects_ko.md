---
layout: page
title: 프로젝트
permalink: /ko/projects/
description: 구현 및 연구 산출물.
lang: ko
nav: false
display_categories: [implementation, tool, course]
horizontal: false
---

<div class="projects">
{%- if site.enable_project_categories and page.display_categories %}
  {%- for category in page.display_categories %}
  <h2 class="category">{{ category }}</h2>
  {%- assign categorized_projects = site.projects | where: "category", category | where: "lang", page.lang -%}
  {%- assign sorted_projects = categorized_projects | sort: "importance" %}
  <div class="grid">
    {%- for project in sorted_projects -%}
    {% include projects.liquid %}
    {%- endfor %}
  </div>
  {% endfor %}
{%- else -%}
  {%- assign sorted_projects = site.projects | where: "lang", page.lang | sort: "importance" -%}
  <div class="grid">
    {%- for project in sorted_projects -%}
    {% include projects.liquid %}
    {%- endfor %}
  </div>
{%- endif -%}
</div>
