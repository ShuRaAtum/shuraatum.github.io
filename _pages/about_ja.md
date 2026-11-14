---
layout: about
title: 紹介
permalink: /ja/
lang: ja
display_name: オム・シウ

role: "漢城大学校 情報コンピュータ工学科 博士課程"
lab:
  name: CryptoCraft Lab
  url: https://sites.google.com/view/cc-hs
university: 漢城大学校（韓国・ソウル）
advisor:
  name: ソ・ファジョン（Hwa-Jeong Seo）教授
  url: https://scholar.google.co.kr/citations?user=NJTYsz0AAAAJ

links:
  - label: メール
    url: mailto:shuraatum@gmail.com
  - label: 経歴
    url: /ja/cv/
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

韓国・漢城大学校 情報コンピュータ工学科の博士課程に在籍し、
[CryptoCraft Lab](https://sites.google.com/view/cc-hs)で
[ソ・ファジョン教授](https://scholar.google.co.kr/citations?user=NJTYsz0AAAAJ)の指導のもと、
**プラットフォームに最適化した暗号実装**を研究しています。
紙の上で設計された暗号アルゴリズムを、ARM・RISC-V・GPU といった実際のハードウェアで最大限の性能まで引き出すことに取り組んでいます。

最近は**耐量子計算機暗号（PQC）のベンチマークと実装**を中心に、
[KpqC](https://www.kpqc.or.kr/)および NIST PQC の候補アルゴリズムを対象として、ハイブリッド TLS 1.3、
共同 PKI 基盤、軽量環境（Cortex-M、RV32）への適用を扱っています。
あわせて、GPU（CUDA、Apple Silicon Metal）による共通鍵暗号の高速化や、
暗号ベンチマーク・テストハーネス生成のための AI エージェント活用ワークフローにも取り組んでいます。

{%- assign pc = site.data.research_map.counts -%}
論文実績：**SCI(E) 論文誌 {{ pc.scie }}編**{% if pc.journal > 0 %}、**IACR TCHES {{ pc.journal }}編**{% endif %}、**KCI 論文誌 {{ pc.kci }}編**、
**国際会議 {{ pc.conference }}編**、**プレプリント {{ pc.preprint }}編**。全リストは[論文ページ](/ja/publications/)をご覧ください。
