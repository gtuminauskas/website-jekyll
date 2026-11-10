#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
cd "$script_dir/personal"

if ! command -v bundle >/dev/null 2>&1; then
  echo "Bundler is missing. Install the Bundler version recorded in personal/Gemfile.lock first." >&2
  exit 1
fi

# Keep installed gems outside the site source and preserve the lockfile.
export BUNDLE_PATH="${BUNDLE_PATH:-${XDG_CACHE_HOME:-$HOME/.cache}/website-jekyll/bundle}"
export BUNDLE_FROZEN=true
if ! bundle check; then
  echo "Installing locked dependencies (internet access required for missing gems)..."
  bundle install
fi

echo "Preview: http://127.0.0.1:4000/ — refresh after edits; Ctrl+C stops the server."
# Polling also detects edits on filesystems with unreliable change notifications.
exec bundle exec jekyll serve \
  --host 127.0.0.1 \
  --baseurl "" \
  --destination "${TMPDIR:-/tmp}/website-jekyll-preview" \
  --force_polling
