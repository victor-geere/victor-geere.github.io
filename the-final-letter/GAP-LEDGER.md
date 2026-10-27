# Gap ledger

The sources were written separately. This ledger lists the gaps that appeared when they were read as one programme, and how `the-final-letter/` fills them.

| # | Gap | How it is filled |
|---|---|---|
| G1 | `summary/` and `summary-rh/` are separate corpora with no shared argument | The final letter rewrites them into one two-wall programme; the source summaries become evidence annexes. |
| G2 | No shared vocabulary between RH measures and parity correlations | [GLOSSARY.md](GLOSSARY.md) defines the shared terms: wall, bridge, finite-prefix, global positivity, litmus, sign-blind. |
| G3 | No shared status ledger | [STATUS.md](STATUS.md) separates proved, proved limits, open, refuted, and Lean. |
| G4 | No cross-programme bridge analysis | [11 — Bridges](categories/11-bridges/bridges.md) evaluates eleven entries by the DH litmus, pointwise test, and status, including B11 to record that certified evaluation is not a bridge. |
| G5 | No statement of the common missing input | H6 and F6: both walls need a global arithmetic positivity, not a local estimate. |
| G6 | No single Lean development for the synthesis | [`lean/`](lean) builds `FinalLetter/Chowla.lean`, `Synthesis.lean`, and `FinalLetter.lean` with the same Lean installation. |
| G7 | No abstract, no single-page index, no unified TOC | [02 — Abstract](categories/02-abstract/abstract.md), [index.html](index.html), [TABLE-OF-CONTENTS.md](TABLE-OF-CONTENTS.md). |
| G8 | No explicit statement of futility | [12 — Final note](categories/12-final-note/final-note.md) argues that the failure is structural, not accidental. |
| G9 | No unified evidence map | [00 — Provenance](categories/00-provenance/README.md) maps the two summaries and the source repositories. |
| G10 | Open problems were sometimes stated as if they were theorems | The Lean synthesis uses `def` for RH, twin primes, and Chowla; no `axiom`. [STATUS.md](STATUS.md) keeps the list separate. |
| G11 | Computations used for the finite-scale claims were floating point, with no replayable certificate | Objective III supplies exact rational interval arithmetic, a straight-line certificate replayed by an independent checker, and a kernel-checked Lean soundness theorem. The transcendental enclosures and the Euler–Maclaurin identity and tail bound are Lean theorems (`EulerMaclaurin.lean`, S1–S2 for `K ≥ 1`); what remains is the replay wiring and a certified width. |

## Gaps inside the source corpora that the letter records

- The `summary/` website corpus has no parity/twin-prime layer; the letter imports it from `summary-rh/`.
- The `summary-rh/` corpus has no measure-theoretic RH conversion; the letter imports it from `summary/`.
- The two corpora use different status vocabularies; the letter unifies them in [STATUS.md](STATUS.md).
- The two corpora have different Lean developments; the letter vendors the finite-prefix core and writes a new synthesis layer.
- The source corpora contain claimed proofs of RH in `maths/` and archived programmes; the letter treats them as historical and does not adopt them.
- The source corpora contain errors (X1–X6, OP-5, 015); the letter keeps them in the errata rather than smoothing them away.

## Gaps that remain

- The conversion theorem is not formalised in Lean.
- The greedy/budget/balance layers are not imported into the `FinalLetter` build.
- The two walls are not proved; the letter does not pretend otherwise.
- OP-19, `(M)`, F.4, `Λ=0`, and the Jensen/Li tower remain open.
- The Euler–Maclaurin identity and the explicit tail bound of the certified evaluator are Lean theorems for `K ≥ 1`, and they now yield a closed rectangle enclosure for every `s` with `Re s > 1` (no atom hypothesis). The evaluator is not yet wired into the critical strip, and it is not used as a hypothesis in any theorem about either wall. A concrete certificate can be checked against a target width; a symbolic width theorem is not proved.

[Back to README](README.md) · [Back to index](index.html)
