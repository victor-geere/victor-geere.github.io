#!/usr/bin/env zsh
#
# Moves all top-level folders into ./archive, excluding folders that
# start with "." or "archive". Files in the project root are left alone.

set -euo pipefail

script_dir="${0:A:h}"
cd "$script_dir"

archive_dir="archive"
mkdir -p "$archive_dir"

for item in *(N/); do
  [[ "$item" == "$archive_dir" ]] && continue
  [[ "$item" == archive* ]] && continue
  [[ "$item" == .* ]] && continue

  echo "Moving $item -> $archive_dir/"
  mv "$item" "$archive_dir/"
done
