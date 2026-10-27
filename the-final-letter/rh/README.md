# `rh/` — research source snapshot

This directory is a working snapshot of the parts of `~/workspace/rh` that the
evidence annex [`summary-rh/`](../summary-rh/README.md) cites. It exists so
that the citations in that annex resolve inside `the-final-letter/`.

It is not a mirror of the research repository: it holds the files reachable
from the imported documents, at their canonical paths. Documents that had been
flattened into `publish/013-twin-prime-parity-explicit-function/notes/` were
re-pointed to their original files rather than duplicated.

## Contents

| Path | Role |
|---|---|
| [`research/`](research/) | the research tree cited by `summary-rh/` |
| [`research-journal.md`](research-journal.md) | the programme journal |
| [`lean/ConeLean/`](lean/ConeLean/) and [`lean/TppLean/`](lean/TppLean/) | Lean developments cited by the ledger |
| [`theorems/tpp/`](theorems/tpp/) | the indexed TPP theorem notes |

## Repairs and remaining references

The snapshot was assembled from the live repository and then link-checked.
Missing references were repaired by importing the upstream file and, where a
document had been flattened, re-pointing the link at its canonical location.

Twenty-two references remain that cannot be repaired from the source
repository, because the target does not exist in `~/workspace/rh` either:

- `CLAUDE.md` (4 references) — a top-level guidance file that is not part of the
  research corpus.
- `dictionary.html` (6) — a removed HTML edition of the dictionary; the
  Markdown dictionary under `research/twin-prime-parity/dictionary/` is present.
- `research/publish/README.md` (3), the `publish/013.../index.html` (2) and the
  `notes/`, `lean/` README/index pages (4) — indexes that were never written
  or have been removed upstream.
- `theorems/file.md` (1) and `research/.../truths.md` (1) — literal placeholder
  paths in the source text.

They are the source corpus's own dangling references, not links created by the
import. The link checker reports them as informational.

## Checking

From the `the-final-letter/` directory:

```bash
python3 tools/check-links.py
```

Everything outside this snapshot is expected to have zero broken links.

[Back to the evidence layout](../EVIDENCE.md) · [Back to README](../README.md)
