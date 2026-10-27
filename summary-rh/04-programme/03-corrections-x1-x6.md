# Corrections X1–X6

> Source: [`research/twin-prime-parity/README.md`](../rh/research/twin-prime-parity/README.md), “Corrections this harvest forced on the rounds’ own records”. These are the programme’s own record corrections.

## Corrections this harvest forced on the rounds' own records

Compiling this directory exposed errors in the source rounds; they are corrected here
(and pointer notes are left in the round files):

| # | the round's claim | correction | witness |
|---|---|---|---|
| X1 | "one-point Chowla `Σ_{n≤x}λ(n) = o(x)` is itself **OPEN**" (rh46 §1.3, rh47 §5.1) | **false** — it is **equivalent to PNT**, i.e. a **theorem**.  `λ = 1_squares ∗ μ`, so `Σ_{n≤x}λ(n) = Σ_{d≤√x} M(x/d²) = o(x)` follows from `M(y) = o(y)` | identity verified exactly (`x = 100, 1000`), and `L(x)/x → 0` measured; citation: Tao, [arXiv:1605.04628](https://arxiv.org/abs/1605.04628) |
| X2 | the sparse-modification bound `≤ 2·#{n ≤ x+2 : n ∈ A}` (rh46 §3) | **false** — correct is `2·#{n ≤ x : n ∈ A or n+2 ∈ A} ≤ 4·#{m ≤ x+2 : m ∈ A}` | witness `A = {5}`, `x = 5`: `\|ΔS\| = 4 > 2` (rh47 §3) |
| X3 | rh46's product-tail `1.80898647` | mis-derived (it bounds the *retained* primes); the correct omitted-prime tail is `≈ 1.84·10⁻⁵` | the conclusion (no Euler product) survives |
| X4 | rh45/truths "17/21, 4 failures" | stale — the log shows **19/21**; both `C1e` and `C4.1` are now **RETIRED** (over-strong / unsatisfiable as stated), so the current run is *19/21 checks pass; 2 retired; failures: none* (exit 0) | `rh45/verify/independent_check.log`, `010/verify/DISPOSITIONS.md` |
| X5 | rh47's "every greedy-sine object is an additive character in `log n`" | **too wide / imprecise** — `n^{−it}` is multiplicative on `(ℝ₊,×)` and the budgets are constants; read the barrier as *sign-blind, no arithmetic input* | rh47 audit C3a exhibits a greedy object with an *arithmetic* alphabet that does mix (circularly) |
| X6 | rh46's "k-point Chowla contradicts the twin-prime failure mode" | **withdrawn as unverified**; replaced by the citable `k=1 ⟺ PNT` and `Chowla ⇒ Sarnak` | [`dictionary/03-parity-problem.md`](../rh/research/twin-prime-parity/dictionary/03-parity-problem.md) §4 |
