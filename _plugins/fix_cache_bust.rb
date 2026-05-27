# Fix for jekyll-cache-bust 0.0.1 + al_folio_core 1.0.9.
#
# Upstream's `bust_css_cache` filter hashes the contents of `assets/_sass/`
# (and a couple of fallback paths under the gem), but al-folio sass actually
# lives at `_sass/`. The default and the fallbacks all resolve to empty
# directories, so every build emits the same MD5 (`d41d8cd9...` — the digest
# of the empty string). The `?v=...` query string never changes, and CDN /
# browser caches happily serve stale CSS indefinitely.
#
# Override the filter so the hash is computed from the real `_sass/`
# directory, so each meaningful SCSS change produces a fresh URL.

require "digest/md5"

module Jekyll
  module CacheBust
    def bust_css_cache(file_name)
      CacheDigester.new(file_name: file_name, directory: "_sass").digest!
    end
  end
end
