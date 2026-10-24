# Status ledger

## The headline

**No Riemann hypothesis proof. No twin prime proof. No Chowla proof.** The repository’s verdict is that the greedy harmonic sine does not solve the parity problem for the twin prime conjecture, not by this programme as it stands. The one clean new theorem is the **finite-prefix indeterminacy theorem** for the two-point Liouville correlation.

The strongest finite-window result is the unconditional Turing certificate that every zero with `½ < Im < 15` and `½ < Im < 33` is simple and on the critical line. That is not RH and is not claimed as such.

## Proved — the positive ledger

| Area | Result | Status |
|---|---|---|
| Greedy word | factor-complexity law `p(L) = min(a_m+1, N−L+1) + [L ≤ N−a_m−1]` | THEOREM (Lean) |
| Budgets | `P=2^{−p}ζ`, `N=(1−2^{−p})ζ−1`, `P+N=ζ−1`, `P−N=1−η`, `P>N` | THEOREM (Lean at `p=2,4`) |
| Reachability | Brown’s criterion; completeness thresholds | THEOREM |
| Parity | signed support is parity-locked | THEOREM (Lean) |
| Balance | `P_N+M_N=Re S_N`; balance ⟺ `Re S_N=0`; attained for `N≥2` | THEOREM (Lean) |
| Zeros | `S_3(t)≠0`; `S_2(π/log 2)=0` | THEOREM (Lean) |
| Error | sharp error at a zero `√N/|s−1|` | THEOREM + NUMERICAL |
| Smoothing | smoothing does not remove `√N` | THEOREM + NUMERICAL |
| Explicit formula | corrected Weil form with archimedean term | THEOREM + NUMERICAL |
| Chowla | finite-prefix indeterminacy | THEOREM (Lean) |
| Chowla | `λ(n)λ(n+2)` not multiplicative; no Euler product | THEOREM (Lean) + NUMERICAL |
| Parity | greedy support Sylvester-sparse | THEOREM + NUMERICAL |
| Chowla | one-point `Σλ(n)=o(x)` ⟺ PNT | THEOREM (classical) |

The full P1–P19 table is in [04 — Barrier ledger](summary-rh/04-programme/04-barrier-ledger.md).

## Open — the register

19 registered problems:

- **10 settled** — OP-2, OP-5, OP-6, OP-10, OP-7, OP-11, OP-12, OP-13, OP-14, OP-15.
- **1 impossible-as-inherited** — OP-3; its well-posed replacement is OP-19.
- **1 refuted as stated** — OP-8 (every certified root `N=3…76`; open in general).
- **7 open** — OP-1, OP-4, OP-9, OP-16, OP-17, OP-18, OP-19.

The 36 harvested items include 11 heuristic models graded `CONJECTURED`; they are not committed targets. The full tables are in [03 — Open problems](summary-rh/03-open-problems/README.md).

## Refuted or withdrawn

| Statement | Correction |
|---|---|
| One-point Chowla is open | False; equivalent to PNT (X1) |
| Sparse bound `2·#{n≤x+2 : n∈A}` | False; correct `2·#{n≤x : n∈A or n+2∈A}` (X2) |
| rh46 product-tail `1.80898647` | Mis-derived; correct omitted tail `≈1.84·10⁻⁵` (X3) |
| rh45 “17/21, 4 failures” | Stale; 19/21 pass, 2 retired, no failures (X4) |
| “Every greedy-sine object is an additive character in `log n`” | Too wide; withdraw (X5) |
| “k-point Chowla contradicts the twin-prime failure mode” | Withdrawn as unverified (X6) |
| OP-5 error `O(1/p)` | False; corrected to `O(1)` and proved |
| Exact ceiling law `nmin p = ⌈p/log 2 − 5/2⌉` | False at a 451-digit `p` |
| OP-3 as stated | Not well-posed; replaced by OP-19 |
| OP-18 as phrased | Not well-posed; existential dual of OP-19 |
| 015 “dimension law” | Retracted by the paper’s own C0 |
| 015 character-sum identity | Corrected by C1 (exact for `q≡1 mod 8`; corrected for `q≡1 mod 4`) |

Full ledger: [05 — Errata](summary-rh/05-lean-verification/03-errata.md).

## Lean status

- 14 developments; `Op56` 9/9 green; `Rh45` 6/6; `Op57` 5/5; `Rh46` 42 theorems; `Rh47` 2/2.
- **No `axiom` declaration anywhere; no literal `sorry` remains.**
- `Rh41` has eight `native_decide` theorems; `Op56` is axiom-clean.
- Named Mathlib-gap hypotheses in `Rh45/Archimedean.lean` and `Rh45/RouteBAnalytic.lean`.

Full table: [05 — Lean status](summary-rh/05-lean-verification/01-lean-status.md).

## What would change the headline

- A proof of un-averaged two-point Chowla `Σλ(n)λ(n+2)=o(x)`.
- A proof of OP-19 (the log-indicator barrier), or a counterexample arc.
- A sign-blind rule with positive-density multiplicative coupling to `Ω`.
- A proof of the twin prime lower bound (would break the parity barrier).
- A proof of the Riemann hypothesis (none of the papers attempts it as a theorem; the explicit-formula work is finite-window certification).

## What is explicitly not claimed

- RH; the twin prime conjecture; Chowla for `k ≥ 2`; Sarnak; Elliott.
- That the `T=15`/`T=33` certificates are RH.
- That `CERTIFIED` numerics are asymptotic proofs.
- That the 11 heuristic `CONJECTURED` items are targets.

[Master README](summary-rh/README.md) · [Master TOC](summary-rh/TABLE-OF-CONTENTS.md) · [Glossary](summary-rh/GLOSSARY.md)
