# 03 — Open problems and conjectures

This folder is the programme’s open layer: the registered problems OP-1…OP-19, the 36 finer-grained open/conjectured items harvested from the twin-prime-parity source documents, the resolved OP-5/OP-6 pair, the well-posed OP-19, and the external conjectures the programme tests against.

## The tally

The register has 19 items:

- **10 settled** — OP-2, OP-5, OP-6, OP-10, OP-7, OP-11, OP-12, OP-13, OP-14, OP-15.
- **1 impossible-as-inherited** — OP-3, whose well-posed replacement is OP-19.
- **1 refuted as stated** — OP-8 (refuted at every certified root; open in general).
- **7 open** — OP-1, OP-4, OP-9, OP-16, OP-17, OP-18, OP-19.

The 36 harvested items include 11 heuristic models graded `CONJECTURED`; those are recorded expectations, not committed targets. The register’s numbering and the harvest-level OP-20…OP-38 numbering are distinct; the source README explains the relation.

## The files

| File | What it contains |
|---|---|
| [OP register](01-op-register.md) | OP-1…OP-19 with the corrected statuses and the tally. |
| [Harvested open items](02-harvested-open-items.md) | The 36 OPEN/CONJECTURED items in three tables: Chowla/twin/Sarnak, the barrier, and the `rh40` greedy-word questions. |
| [OP-5 and OP-6](03-op-05-op-06-resolved.md) | The resolved threshold asymptotics, the `O(1/p)` correction, the exact ceiling law refutation, and the Lean headline theorems. |
| [OP-19](04-op-19-log-indicator.md) | The log-indicator barrier: why OP-3 is not a proposition, the log-arc repair, P1/P2, and what is known. |
| [Out of reach](05-out-of-reach.md) | The 2026 reassessment of OP-1, OP-4, OP-16, OP-17, OP-18. |
| [Major conjectures](06-major-conjectures.md) | Chowla, twin primes, Hardy–Littlewood/Dickson, Sarnak, Elliott, and the parity barrier. |

## The key open statement

The programme’s target is the un-averaged two-point Chowla statement

```
Σ_{n≤x} λ(n)λ(n+2) = o(x).
```

It is **OPEN**. The programme proves that no finite computation can decide it, that the two-point correlation has no Euler product, and that the greedy support is Sylvester-sparse. It does not prove the statement, and it does not prove the twin prime conjecture.

## The key well-posed replacement

OP-19 replaces the unstatable OP-3: for a log-arc rule `A_I = {n : log n mod 2π ∈ I}`, is `C_I(x) = Σ_{n≤x}1_{A_I}(n)λ(n) = o(x)`? This is open and has a definite truth value. OP-18, on a fixed class, is its existential dual.

[Back to the summary index](../README.md) · [Folder TOC](TOC.md)
