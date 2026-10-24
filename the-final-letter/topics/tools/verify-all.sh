#!/usr/bin/env bash
# Full structural + Python + Lean verification of the topic reconstruction.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$HERE/.." && pwd)"
echo "== structural audit =="
python3 "$HERE/audit_topics.py"
echo "== python tests =="
"$HERE/run-tests.sh"
echo "== lean cores =="
"$HERE/check-all-lean.sh"
echo "== topic index =="
python3 "$HERE/build_topic_index.py"
echo "== link base =="
python3 "$ROOT/../tools/check-links.py"
echo "== all checks passed =="
