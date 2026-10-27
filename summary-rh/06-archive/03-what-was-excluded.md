# What was excluded, and why

`~/workspace/rh` contains **2,029** Markdown/HTML/TeX files. This summary does not reprint them all.

## Included exhaustively

- `research/truths.md` §§1–13 — the proved-results ledger, 13 section files.
- `research/publish/001–015/manuscript.md` — every bold theorem/lemma/proposition/corollary/conjecture/definition block, 147 statements across 15 paper files.
- `research/open.md` — the OP-1…OP-19 register and the 36 harvested OPEN/CONJECTURED items.
- `research/twin-prime-parity/README.md` — verdict, round table, X1–X6 corrections.
- `research/twin-prime-parity/dictionary/05-programme-barriers-and-harvest.md` — P1–P19, B1–B5, N1–N3, missing ingredient, verdict.
- `research/shift2-audit/REPORT.md` — the MRT misattribution correction and exact split.
- `research/open.md` §2–3 — Lean build, sorry/axiom audit, OP-5/OP-6 resolution.
- `research/TODO.md` §A.1 — OP-19 definition.

## Excluded or indexed only

- **`research-journal.md`** (38,751 lines): session log. Indexed, not reprinted.
- **`research/twin-prime-parity/open/HANDOFF.md`** (18,706 lines): development log. Indexed.
- **`research/twin-prime-parity/rounds/`** and **`theorems/rh3–rh39`**: per-round artefacts. Their canonical outputs are in the ledger, the 15 papers, or the open register. The rounds are provenance.
- **`html/rh3–rh39`**: rendered duplicates of the round papers.
- **Lean source files**: indexed via the Lean status table, not reprinted. The machine-checked statements are in the ledger.
- **Python scripts and logs**: indexed by the papers/ledger, not copied. Reproduction commands are in the source READMEs.
- **`xi-horn/`, `lean/`, `lib/`, `adv/`, `chowla2/`, `odd-core-adversary/`, `verify/`**: supporting code/numerics; not mathematical statements in the harvest sense.
- **`various/`**: pre-programme reconnaissance and A/B dialogue; legacy.

## Why

Duplicating every round file would multiply the same theorem across `theorems/`, `html/`, `rounds/`, `publish/` and the ledger. The ledger is explicitly the canonical harvest; the published papers are the canonical expositions; the open register is the canonical list of what remains. The archive is indexed so a reader can follow provenance without wading through duplicates.

[Back to folder README](summary-rh/06-archive/README.md) · [Back to the summary index](summary-rh/README.md)
