# Errata and withdrawn claims

The programme keeps its errors. This is the consolidated list; the source records are linked.

## Programme corrections X1–X6

| # | Claim | Correction |
|---|---|---|
| X1 | “one-point Chowla `Σλ(n) = o(x)` is OPEN” (rh46 §1.3, rh47 §5.1) | **False.** It is equivalent to PNT, a theorem: `λ = 1_squares ∗ μ`, so `Σλ(n) = Σ_{d≤√x}M(x/d²) = o(x)`. |
| X2 | sparse-modification bound `≤ 2·#{n≤x+2 : n∈A}` | **False.** Correct: `2·#{n≤x : n∈A or n+2∈A} ≤ 4·#{m≤x+2 : m∈A}`. Witness `A={5}`, `x=5`: `|ΔS|=4>2`. |
| X3 | rh46 product-tail `1.80898647` | Mis-derived (it bounds retained primes). Correct omitted-prime tail `≈1.84·10⁻⁵`; the conclusion (no Euler product) survives. |
| X4 | rh45 “17/21, 4 failures” | Stale. Log shows 19/21; `C1e` and `C4.1` are retired (over-strong/unsatisfiable), so current run is 19/21 pass, 2 retired, failures none. |
| X5 | “every greedy-sine object is an additive character in `log n`” | **Too wide.** `n^{-it}` is multiplicative on `(ℝ₊,×)` and the budgets are constants. Read the barrier as sign-blind, no arithmetic input. |
| X6 | “k-point Chowla contradicts the twin-prime failure mode” | **Withdrawn as unverified.** Replaced by `k=1 ⟺ PNT` and `Chowla ⇒ Sarnak`. |

## OP-5 / OP-6 corrections

- **`O(1/p)` error was false.** An integer index cannot beat the Diophantine gap against an irrational linear threshold. Corrected to `O(1)` and proved in Lean.
- **Exact ceiling law was false.** `nmin p = ⌈p/log 2 − 5/2⌉` fails at a **451-digit** `p` (`nmin p = ⌈·⌉+1`). The sharpest true uniform statement is the disjunction `nmin p ∈ {⌈A⌉, ⌈A⌉+1}`, unproved.
- **`census_measure_eq` holds by construction.** `reachableMeasure` is defined as `2^{nmin}·tailSum`; the geometric disjointness/union statement is not formalised (census counting gap).

## Register corrections

- **OP-2** is settled (equivalent to PNT), not open.
- **OP-3** is not well-posed as inherited; the well-posed replacement is **OP-19**.
- **OP-8** is refuted at every certified root `N=3…76`, open in general.
- **OP-13** direction was inverted: the upper bound `A(N)=O(log log N)` is proved; the `Ω` lower bound is the failing side.
- **OP-18** is not well-posed as phrased; on a fixed class it is the existential dual of OP-19.
- **OP-12**: rh46’s `2·#{…}` sparse bound is refuted; the corrected bound is machine-checked in `Rh47/Sparse.lean`.

## Paper-level corrections

- **006 explicit formula.** A first draft used the wrong normalisation; the corrected Weil form is the one used. The correction is kept on record.
- **015 function field.** The paper carries a correction notice: C0 retracts its own “dimension law”; C1 corrects the character-sum identity of phase 019 (exact for `q ≡ 1 mod 8`, corrected form for every `q ≡ 1 mod 4` tested). The Selberg constant is `8`, not `4`.
- **008 parity barrier.** No Lean layer; the paper is paper + numerics only.
- **007/014 and 001/011** are duplicate editions. 014 is the fuller edition of 007; 011 is the packaged edition of 001.

## What is not an error but is often misread

- `CERTIFIED` finite windows (`T=15`, `T=33`) are not RH.
- `PROVED (paper)` is not machine-checked.
- The 36 harvested open items include 11 heuristic models; they are not committed targets.

[Back to folder README](summary-rh/05-lean-verification/README.md) · [Back to the summary index](summary-rh/README.md)
