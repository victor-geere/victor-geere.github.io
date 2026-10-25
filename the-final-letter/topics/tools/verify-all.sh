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
echo "== publication.html hash =="
python3 - "$ROOT/../geometric-dynamical-phase-transitions/publication.html" \
            "$ROOT/../../publication.html" <<'PY'
import hashlib, sys
bundle, root = sys.argv[1], sys.argv[2]

def digest(path):
    h = hashlib.sha256()
    with open(path, "rb") as fh:
        for chunk in iter(lambda: fh.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()

a, b = digest(bundle), digest(root)
print(f"bundle  {a}")
print(f"root    {b}")
if a != b:
    print("FAIL: publication.html copies differ; keep the repository-root copy canonical",
          file=sys.stderr)
    sys.exit(1)
print("OK: publication.html copies match")
PY
echo "== all checks passed =="
