# 015 — Parity Barrier in Primes over Function Field Zeta

| Field | Value |
|---|---|
| Source | [`research/publish/015-function-field-parity-barrier/manuscript.md`](../rh/research/publish/015-function-field-parity-barrier/manuscript.md) |
| Status | Published; dimensional obstruction and corrections C0/C1. |
| Harvested statements | 2 |

## Abstract

Over `𝔽_q[x]`, "primes" are monic irreducibles (qrimes) and "twin primes" are pairs `(f, f+2)`. The twin count
`T(n)` is a bilinear statistic, while the zeta function of the ring determines only linear (degree-count) data;
this separation is proved with an explicit witness. The programme's central question is constructive: can a
sieve, a degree window, or a second-moment argument cross the parity barrier in this model?

We report four measured failure modes. The Selberg `Λ²` upper bound at the classical level `n/2` carries the
classical Selberg constant `2^κ κ!` — `8×` the truth for the twin problem (`κ = 2`) and `2×` for the qrime
problem (`κ = 1`). Over `n ≤ 14` the twin ratio hovers near `4`, which an earlier version of this paper
mistook for the limit; computed from the same series it reaches `7.91` at `n = 1000`. **The correction is
marked below.** The constant is shift-independent: a polynomial shift divisible by every linear prime has the
same limit `8` against its own singular series. The bilinear pair weight is indefinite and defines no bound at
all. Degree windows give no `L^{−1/2}`
cancellation. The large sieve is slack by a factor of order `n`. The exact coprime-pair expansion of `T(n)` and
the degree grading that makes it exact are both machine-checked in Lean 4.

On the quantitative side, `T(n) = S(q)q^n/n² + E(n)` holds with `|E|/q^{n/2} ≤ 0.30` for every `n ≤ 14` at
`q = 3` (`T(13) = 3747`, `T(14) = 9510`), and the corresponding character-sum identity of the programme is corrected
at 80 primes: the original form holds exactly when `q ≡ 1 (mod 8)`, the corrected form for every
`q ≡ 1 (mod 4)` tested. None of this proves the fixed-`q` asymptotic; that
statement is conjectural in the literature we surveyed.

**Conclusion.** The barrier is a missing *object* — a way to resolve the two conditions jointly — not a missing
estimate. Over `𝔽_q[x]` that object is the Frobenius; over `ℤ` it would be a grading substitute for the Möbius
truncation. Four standard mechanisms are now closed by measurement, and every proof strategy must reproduce the
numbers recorded here — including the corrected constant `8`, not `4`.


---

## Harvested theorem-like statements

### Theorem (separation).

The zeta function of a set of qrimes determines exactly its degree counts, and no
function of those counts determines the twin count.

The proof exhibits two sets of four degree-2 qrimes over `𝔽₇` with identical degree profiles and twin counts
`1` and `0`. The general statement is machine-checked (`Separation.no_zeta_observable`); the witness is
`Separation.separation_F7`.

The consequence is structural: the twin count is *bilinear* data, and the zeta is *linear* data. No amount of
zeta computation recovers it.

### Theorem (parity).

Every divisor sum with bounded support is periodic; the twin indicator is not. Hence no
finite-level Selberg sieve weight equals the twin indicator.

This is the finite form of Selberg's parity principle. The two halves are Lean-checked (`Periodic`,
`NonPeriodic`). The theorem concerns the *indicator*, not the count: it excludes a class of weights, and
therefore any route must use growing support.

## Source

[`manuscript.md`](../rh/research/publish/015-function-field-parity-barrier/manuscript.md) · [`README.md`](../rh/research/publish/015-function-field-parity-barrier/README.md)
