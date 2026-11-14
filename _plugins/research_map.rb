# Builds the "platform x year" research map shown on the about pages.
#
# Reads _bibliography/papers.bib directly and exposes the result as
# `site.data.research_map`, so the map always matches the bibliography.
# Each entry opts in with a custom `platform` field holding one or more
# space-separated row keys (see ROWS). Entries without it are skipped.

require "bibtex"

module ResearchMap
  ROWS = %w[arm embedded x86 gpu protocol quantum].freeze

  # Venue (bib `abbr`) -> publication type, used for the counts quoted on the
  # about and CV pages. Add new venues here when a paper introduces one.
  VENUE_TYPES = {
    "AppSci" => "scie", "Electronics" => "scie", "Sensors" => "scie",
    "Symmetry" => "scie", "Mathematics" => "scie", "IEEE Access" => "scie",
    "TCHES" => "journal",
    "JKIISC" => "kci", "JKIICE" => "kci", "KTCCS" => "kci", "SMJ" => "kci",
    "ICISC" => "conference", "WISA" => "conference", "PlatCon" => "conference",
    "ePrint" => "preprint",
  }.freeze

  class Generator < Jekyll::Generator
    safe true
    priority :high

    def generate(site)
      path = File.join(site.source, "_bibliography", "papers.bib")
      return unless File.exist?(path)

      self_last = Array(site.config.dig("scholar", "last_name")).map(&:to_s)
      papers = BibTeX.open(path).data.select { |e| e.is_a?(BibTeX::Entry) }.filter_map do |e|
        next unless e.has_field?(:platform) && e.has_field?(:year)

        first_author = e.author&.first
        {
          "key" => e.key.to_s,
          "title" => clean(e.title),
          "year" => e.year.to_s.to_i,
          "abbr" => e.has_field?(:abbr) ? clean(e[:abbr]) : "",
          "first" => first_author ? self_last.include?(first_author.last.to_s) : false,
          "platforms" => e[:platform].to_s.split(/[\s,]+/) & ROWS,
        }
      end
      return if papers.empty?

      years = (papers.map { |p| p["year"] }.min..papers.map { |p| p["year"] }.max).to_a
      rows = ROWS.map do |row|
        {
          "key" => row,
          "cells" => years.map do |y|
            papers.select { |p| p["year"] == y && p["platforms"].include?(row) }
          end,
        }
      end.reject { |r| r["cells"].all?(&:empty?) }

      counts = Hash.new(0)
      papers.each { |p| counts[VENUE_TYPES.fetch(p["abbr"], "other")] += 1 }

      site.data["research_map"] = {
        "years" => years,
        "rows" => rows,
        "total" => papers.size,
        "first_author" => papers.count { |p| p["first"] },
        "counts" => counts,
      }
    end

    private

    def clean(value)
      value.to_s.delete("{}").gsub("--", "–").strip
    end
  end
end
