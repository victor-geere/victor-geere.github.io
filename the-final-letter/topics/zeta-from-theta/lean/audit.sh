#!/usr/bin/env bash
# Run the constant-level provenance audit (HANDOFF §7, Method B).
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
exec "$HERE/check.sh" Audit.lean
