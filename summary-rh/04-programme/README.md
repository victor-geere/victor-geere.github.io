# 04 — The programme: verdict, corrections, barriers

This folder is the narrative spine of the twin-prime-parity programme. Its verdict is stated first:

> **No — the greedy harmonic sine does not solve the parity problem for the twin prime conjecture, not by this programme as it stands.**

The programme produced a complete map of the barrier, a proved complexity/reachability theory for the greedy word, and one clean new theorem: the finite-prefix indeterminacy theorem for the two-point Liouville correlation. It did not produce a twin-prime lower bound, a proof of Chowla, or a proof of RH.

## The files

| File | What it contains |
|---|---|
| [Orientation](summary-rh/04-programme/01-orientation.md) | The one-paragraph summary and the per-round status table. |
| [Three claims](summary-rh/04-programme/02-three-claims.md) | The programme’s own take-aways: unreachable as it stands, one clean theorem, what would count as progress. |
| [Corrections X1–X6](summary-rh/04-programme/03-corrections-x1-x6.md) | The six record corrections the harvest forced on the rounds. |
| [Barrier ledger](summary-rh/04-programme/04-barrier-ledger.md) | The capstone: P1–P19 proved, B1–B5 bridges disposed of, N1–N3 not claimed, the missing ingredient, and the verdict. |
| [Shift-2 audit](summary-rh/04-programme/05-shift2-audit.md) | The MRT misattribution correction and the exact `S₂ = S₁ + C` split. |

## The positive ledger in brief

The programme proves a factor-complexity law for the greedy word, exact budgets and Brown reachability, a parity lock, the balance identity, the sharp partial-sum error at a zero, that smoothing cannot remove `√N`, the corrected explicit formula, the finite-prefix theorem, and the Sylvester-sparsity theorem. See [04 — Barrier ledger](summary-rh/04-programme/04-barrier-ledger.md) for the P1–P19 table.

## The five bridges, all disposed of

B1 (support carries λ-parity) **refuted**; B2 (budgets carry Ω-parity) **refuted**; B3 (ζ-machinery applies) **refuted** because the correlation has no Euler product; B4 (support is a positive-density witness) **refuted** because the support is Sylvester-sparse; B5 (arithmetic alphabet escapes) **refuted as circular**.

## The precise missing ingredient

A sign-blind rule `R` with a statistic `T`, computable from `R`, coupled to `Ω` at positive density. The programme supplies no such `R`/`T`, and its structure theorems say why the greedy ones cannot be it. Deciding whether any sign-blind rule can work is OP-3/OP-19.

[Back to the summary index](summary-rh/README.md) · [Folder TOC](summary-rh/04-programme/TOC.md)
