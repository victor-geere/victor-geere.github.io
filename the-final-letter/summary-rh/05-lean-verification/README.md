# 05 — Lean verification and errata

This folder records the machine-checking status of the programme and the corrections that keep the record honest.

## The headline

There is **no `axiom` declaration anywhere** in the corpus, and **no literal `sorry` remains**. The last one, `Op56.tailSum_integral_lower`, was discharged by repairing its hypothesis to `N + 2 ≤ M` and proving it. The corpus is `sorry`-free.

The 14 developments include `Rh45` (explicit formula/routes), `Op56` (OP-5/OP-6, 9/9 green), `Op57`–`Op59` (generalisations), `Rh41`–`Rh47` (the rounds), `VonMangoldtSieves`, `ConeLean` and `TppLean`.

## The files

| File | What it contains |
|---|---|
| [Lean status](01-lean-status.md) | The development table, build status, `sorry`/axiom footprints, and caveats. |
| [Status taxonomy](02-status-taxonomy.md) | The status vocabulary, including `CERTIFIED`, `CONJECTURED`, `SETTLED`, `OUT OF REACH`. |
| [Errata](03-errata.md) | X1–X6, the OP-5 `O(1/p)` and ceiling-law corrections, the register corrections, and the paper-level corrections. |

## What the Lean layer does not do

It does not prove RH, the twin prime conjecture, Chowla, Sarnak, or Elliott. It formalises the programme’s positive results, the finite-prefix theorem, OP-5/OP-6, and the corrected sparse bound. `CERTIFIED` finite windows (`T=15`, `T=33`) are not RH.

## Caveats

- `Rh41` has eight theorems using `native_decide`; `Op56` is axiom-clean after the O2 removal.
- `Rh45/Archimedean.lean` and `Rh45/RouteBAnalytic.lean` carry named hypotheses for Mathlib gaps (digamma estimate, Simpson error, rectangle argument principle, conjugation of `ξ`).
- `CERTIFIED` is not `PROVED (Lean)`; the interval certificates are separate from the formal proofs.

[Back to the summary index](../README.md) · [Folder TOC](TOC.md)
