---
layout: about
title: About
permalink: /en/
lang: en

role: "Ph.D. candidate in Information and Computer Engineering"
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
    url: https://scholar.google.com/citations?user=ygVA5cwAAAAJ
  - label: GitHub
    url: https://github.com/ShuRaAtum

profile:
  image:

selected_papers: true
social: true

announcements:
  enabled: false
---

I am a Ph.D. candidate in Information and Computer Engineering at Hansung University,
advised by [Prof. Hwa-Jeong Seo](https://scholar.google.co.kr/citations?user=NJTYsz0AAAAJ) in the
[CryptoCraft Lab](https://sites.google.com/view/cc-hs).
My work centers on **platform-optimized cryptographic implementation**. I take algorithms designed on
paper and squeeze real performance out of ARM, RISC-V, and GPU hardware.

Recent focus is **post-quantum cryptography (PQC)** benchmarking and engineering across
the [KpqC](https://www.kpqc.or.kr/) and NIST PQC submissions, including hybrid TLS 1.3, joint-PKI
infrastructure, and lightweight target platforms (Cortex-M, RV32). I also work on GPU-accelerated
symmetric ciphers (CUDA, Apple Silicon Metal) and AI-agent-assisted workflows for cryptographic
benchmarking and test-harness generation.

{% assign pc = site.data.research_map.counts -%}
Publications: **{{ pc.scie }} SCI(E) journal papers**{% if pc.journal > 0 %}, **{{ pc.journal }} in IACR TCHES**{% endif %},
**{{ pc.kci }} KCI journal papers**, **{{ pc.conference }} international conference papers**, and
**{{ pc.preprint }} preprints**. See the [publications](/en/publications/) page for the full list.
