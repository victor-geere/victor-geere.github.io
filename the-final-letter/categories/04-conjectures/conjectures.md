# Conjectures

The programme uses “conjecture” in the strict sense: a precise statement that is neither proved nor refuted. The two headline conjectures are the Riemann hypothesis and the twin-prime conjecture; the rest are the programme’s own precise open statements.

| ID | Conjecture | Status |
|---|---|---|
| C1 | Riemann hypothesis | OPEN |
| C2 | Twin-prime conjecture | OPEN |
| C3 | Chowla for `k ≥ 2` | OPEN |
| C4 | Sarnak’s Möbius-disjointness | OPEN |
| C5 | Hypothesis (M) / Weil positivity | OPEN as an input |
| C6 | OP-19 log-indicator barrier | OPEN, well-posed |
| C7 | F.4 Lee–Yang property for the polygon | OPEN |
| C8 | de Bruijn–Newman `Λ = 0` | OPEN |
| C9 | Jensen/Li tower | OPEN |
| C10 | Uniform slow passage on the tightness window | OPEN/conjectural |

## C1 — Riemann hypothesis

Every non-trivial zero of `ζ` has real part `1/2`.

Formally, in the Lean synthesis:

```
def RiemannHypothesis : Prop :=
  ∀ s ∈ riemannZetaZeros, 0 < s.re → s.re < 1 → s.re = 1/2
```

**Status:** OPEN. The programme proves a conversion, not the conjecture. See [05 — Proofs](../05-proofs/proofs.md) and [`summary/05`](../../summary/05-spectral-measures-and-tightness/13-corollary-12.3.md).

## C2 — Twin-prime conjecture

There are infinitely many primes `p` such that `p+2` is prime.

Formally:

```
def TwinPrimeConjecture : Prop :=
  ∀ N : ℕ, ∃ p : ℕ, N < p ∧ Nat.Prime p ∧ Nat.Prime (p + 2)
```

**Status:** OPEN. The programme proves that the greedy-sine objects cannot reach it; it does not prove the conjecture. See [`summary-rh/03`](../../summary-rh/03-open-problems/06-major-conjectures.md).

## C3 — Chowla for `k ≥ 2`

For distinct `h₁,…,h_k`,

```
Σ_{n≤x} λ(n+h₁)⋯λ(n+h_k) = o(x).
```

The `k=2`, `h=(0,2)` case is the two-point target. The programme proves the finite-prefix indeterminacy theorem, which shows no finite computation can decide it.

**Status:** OPEN for every `k ≥ 2`. Log-averaged `k=2` and odd `k` are known; log-averaged even `k ≥ 4` is open.

## C4 — Sarnak’s Möbius-disjointness

For every deterministic sequence `a` of zero entropy,

```
Σ_{n≤x} μ(n)a(n) = o(x).
```

**Status:** OPEN in general. Chowla implies Sarnak; the equivalence is only log-averaged.

## C5 — Hypothesis (M) / Weil positivity

**(M):** the limit function has no zeros in `σ > 1`.

Equivalently, in the tensor programme, positivity of the Weil current `W` on the cone. Under (M) the Davenport–Heilbronn obstruction lapses, but (M) does not prove RH; it is the missing arithmetic positivity.

**Status:** OPEN as an input. True for `ζ`; false for the Davenport–Heilbronn function.

## C6 — OP-19 log-indicator barrier

For every log-arc rule `A_I = {n : log n mod 2π ∈ I}`,

```
C_I(x) = Σ_{n≤x} 1_{A_I}(n) λ(n) = o(x).
```

**Status:** OPEN and well-posed. The single arc `I=[0,π)` is the concrete instance. See [`summary-rh/03/04-op-19-log-indicator.md`](../../summary-rh/03-open-problems/04-op-19-log-indicator.md).

## C7 — F.4 Lee–Yang property for the polygon

There is a ferromagnetic spin system whose finite-volume partition functions are `η_N^{(N²)}`, or whose zeros are confined to a line for every `N`.

**Status:** OPEN. Passes the Davenport–Heilbronn litmus; the computable part is the transfer-operator form. See [`summary/09`](../../summary/09-quantum-placements/05-open-item-f.4.md).

## C8 — de Bruijn–Newman `Λ = 0`

The de Bruijn–Newman constant satisfies `Λ = 0`; equivalently RH. Known: `0 ≤ Λ ≤ 0.22`.

**Status:** OPEN. See [`summary/12`](../../summary/12-open-problems/remaining-gap.md).

## C9 — Jensen/Li tower

The Jensen polynomials of the even moments of Riemann’s `Φ` are hyperbolic at every degree; equivalently the Li coefficients are non-negative; equivalently RH.

**Status:** OPEN. Fixed degree at large shift is known (Griffin–Ono–Rolen–Zagier); uniformity in degree is the full tower.

## C10 — Uniform slow passage

On the tightness window, `|ζ′(ρ)| ≤ N^ε` for every critical-line zero `ρ` with `|γ| ≤ N^{1/2-ε}`.

**Status:** OPEN/conjectural; random-matrix prediction (Hughes–Keating–O’Connell) says yes. Not used by any theorem.

## What is not a conjecture

The finite-prefix indeterminacy theorem, the Davenport–Heilbronn sharpness, the Sylvester-sparsity theorem, and the conversion theorem are **proved**. They are not conjectures. The programme’s discipline is to keep the two lists separate.

[Back to README](README.md) · [Back to index](../../index.html)
