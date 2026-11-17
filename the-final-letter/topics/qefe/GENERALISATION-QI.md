# Generalising the ideal-count architecture to other imaginary quadratic fields

**Status: complete for `d = 2` and `d = 3`.** Both rings, their
ring-of-integers bridges, the split-prime theorems, the local ideal counts at
all three prime types, multiplicativity, the divisor-sum formula and the
representation formulas are proved in Lean, unconditionally and axiom-clean.
Nothing is assumed. The `d = 7, 11, …` cases are not attempted (see §6).

**Related:** [HANDOFF-GAUSSIAN-IDEAL-COUNT.md](HANDOFF-GAUSSIAN-IDEAL-COUNT.md)
(Phase 3) · [CLASS-NUMBER-QI.md](CLASS-NUMBER-QI.md) ·
[`lean/QuadraticInt/`](lean/QuadraticInt/).

---

## 1. The capstones (closed form)

Each field's representation count is a single arithmetic-function identity in
`n`, with the character sum written inline and no intermediate counting
function:

```lean
-- GaussianInt/ClosedForm.lean          d = 1,  w = 4,  χ₄
theorem GaussianInt.r2_closed (n : ℕ) (hn : 1 ≤ n) :
    (GaussianInt.r2 n : ℤ) = 4 * ∑ d ∈ n.divisors, ZMod.χ₄ (d : ZMod 4)

-- QuadraticInt/FormulaTwo.lean         d = 2,  w = 2,  χ₈'
theorem ZsqrtdTwo.idealCountTwo_closed (n : ℕ) (hn : 1 ≤ n) :
    (idealCountTwo n : ℤ) = ∑ d ∈ n.divisors, ZMod.χ₈' (d : ZMod 8)
theorem ZsqrtdTwo.rTwo_closed (n : ℕ) (hn : 1 ≤ n) :
    (Nat.card (NormElementsTwo n) : ℤ) =
      2 * ∑ d ∈ n.divisors, ZMod.χ₈' (d : ZMod 8)

-- QuadraticInt/FormulaThree.lean       d = 3,  w = 6,  χ₃
theorem EisensteinInt.idealCountThree_closed (n : ℕ) (hn : 1 ≤ n) :
    (idealCountThree n : ℤ) = ∑ d ∈ n.divisors, quadraticChar (ZMod 3) (d : ZMod 3)
theorem EisensteinInt.rThree_closed (n : ℕ) (hn : 1 ≤ n) :
    (Nat.card (NormElementsThree n) : ℤ) =
      6 * ∑ d ∈ n.divisors, quadraticChar (ZMod 3) (d : ZMod 3)
```

Read off: the number of representations of `n` by `x² + y²` is
`4 Σ_{d|n} χ₄(d)`, by `x² + 2y²` is `2 Σ_{d|n} χ₈'(d)`, and by `x² − xy + y²`
is `6 Σ_{d|n} χ₃(d)`.

The intermediate forms are also kept, because they expose the proof structure:
`idealCountTwoFormula` / `idealCountThreeFormula` identify the ideal count with
the divisor sum, and `rTwo_formula` / `rThree_formula` are the `w`-to-`1`
correspondence `Nat.card (NormElements _ n) = w · idealCount _ n`.

## 2. The complete file list

| File | Contents |
|---|---|
| [`QuadraticInt/ZsqrtdTwo.lean`](lean/QuadraticInt/ZsqrtdTwo.lean) | `ℤ[√−2]` is norm-Euclidean, UFD, integrally closed; `ℤ`-basis; units `±1` |
| [`QuadraticInt/RingOfIntegersTwo.lean`](lean/QuadraticInt/RingOfIntegersTwo.lean) | `𝓞 (ℚ(√−2)) ≃+* ℤ[√−2]` |
| [`QuadraticInt/SplitTwo.lean`](lean/QuadraticInt/SplitTwo.lean) | `p ≡ 1,3 (mod 8) ⇒ p = a² + 2b²` |
| [`QuadraticInt/IdealCountTwo.lean`](lean/QuadraticInt/IdealCountTwo.lean) | algebra norm, `absNorm (z) = |N z|`, units count, `2`-to-`1` correspondence, split factorisation |
| [`QuadraticInt/LocalTwo.lean`](lean/QuadraticInt/LocalTwo.lean) | inert `p ≡ 5,7` and ramified `p = 2` local counts |
| [`QuadraticInt/SplitCountTwo.lean`](lean/QuadraticInt/SplitCountTwo.lean) | split local count `k + 1` |
| [`QuadraticInt/MultTwo.lean`](lean/QuadraticInt/MultTwo.lean) | multiplicativity over coprime norms |
| [`QuadraticInt/FormulaTwo.lean`](lean/QuadraticInt/FormulaTwo.lean) | `χ₈'` divisor sums, the ideal-count and representation formulas |
| [`QuadraticInt/Eisenstein.lean`](lean/QuadraticInt/Eisenstein.lean) | the ring `ℤ[ω]`, norm `a² − ab + b²`, `w = 6` units, Euclidean division |
| [`QuadraticInt/RingOfIntegersThree.lean`](lean/QuadraticInt/RingOfIntegersThree.lean) | `𝓞 (ℚ(√−3)) ≃+* ℤ[ω]` |
| [`QuadraticInt/SplitThree.lean`](lean/QuadraticInt/SplitThree.lean) | cube root of unity mod `p ≡ 1 (mod 3)`, `p = a² − ab + b²` |
| [`QuadraticInt/IdealCountThree.lean`](lean/QuadraticInt/IdealCountThree.lean) | algebra norm, principal-ideal norm, `6`-to-`1` correspondence, split factorisation |
| [`QuadraticInt/SplitCountThree.lean`](lean/QuadraticInt/SplitCountThree.lean) | split factors distinct; bundled split data |
| [`QuadraticInt/SplitCountThreeFull.lean`](lean/QuadraticInt/SplitCountThreeFull.lean) | split local count `k + 1` |
| [`QuadraticInt/LocalThree.lean`](lean/QuadraticInt/LocalThree.lean) | inert `p ≡ 2` and ramified `p = 3` local counts |
| [`QuadraticInt/MultThree.lean`](lean/QuadraticInt/MultThree.lean) | multiplicativity |
| [`QuadraticInt/FormulaThree.lean`](lean/QuadraticInt/FormulaThree.lean) | `χ₃` divisor sums, the ideal-count and representation formulas |
| [`QuadraticInt/Audit.lean`](lean/QuadraticInt/Audit.lean) | `#print axioms` for every capstone |

## 3. How the two hard inputs were proved

**`d = 2` split primes.** `legendreSym.at_neg_two` identifies `(−2/p)` with the
Kronecker character `χ₈'`, whose explicit table gives `1` for `p ≡ 1, 3 (mod 8)`;
Euler's criterion (`legendreSym.eq_one_iff`) turns that into `x² ≡ −2`. Then
`p ∣ (x+√−2)(x−√−2)` but divides neither factor, so `p` is reducible; factoring
into non-units and comparing norms gives `a² + 2b² = p`.

**`d = 2` inert primes.** Conversely, `a² + 2b²` takes only the residues
`{0,1,2,3,4,6}` mod `8` (checked by `decide` on `ZMod 8`), so `p ≡ 5,7 (mod 8)`
admits no representation and stays prime.

**`d = 3` split primes.** `p ≡ 1 (mod 3)` gives `3 ∣ p − 1 = |(ZMod p)ˣ|`;
Cauchy's theorem produces a unit `g` of order `3`, so `(g−1)(g²+g+1) = 0` with
`g ≠ 1`, giving a root of `X²+X+1`. Then `N(x−ω) = x²+x+1`, so `p` is reducible.

**`d = 3` inert primes.** The norm form is `0` or `1` mod `3` (checked by
`decide` on `ZMod 3`), so `p ≡ 2 (mod 3)` has no representation and stays prime.

## 4. The local counts

For each field the ideal count at prime powers is computed by the same three
cases as for `ℤ[i]`:

| prime type | `d = 2` | `d = 3` |
|---|---|---|
| split | `p ≡ 1,3 (mod 8)`: `k+1` ideals of norm `p^k` | `p ≡ 1 (mod 3)`: `k+1` |
| inert | `p ≡ 5,7 (mod 8)`: `1` for even `k`, `0` for odd | `p ≡ 2 (mod 3)`: same |
| ramified | `p = 2`: `(2) = (√−2)²`, count `1` | `p = 3`: `(3) = (1−ω)²`, count `1` |

The ramified factorisations are `ZsqrtdTwo.ramified_two_sq_two` and
`EisensteinInt.ramified_three_sq_three`; the counts are
`ramified_ideal_count_two` / `ramified_ideal_count_three`. The split counts use
the `k+1` `k`-tuples `(π)^a (star π)^(k−a)`, which are pairwise distinct because
`(π) ≠ (star π)` (`split_span_ne_two`, `split_span_ne_three`).

## 5. What changed relative to the original plan

The original scoping note expected the ring types to be the bulk and the
splitting laws the risk. In the event the ring types were routine; the two real
inputs were the quadratic-character computations (`legendreSym.at_neg_two` for
`d = 2`, a cube root of unity via Cauchy for `d = 3`) and the distinctness of
the two split prime ideals. The latter needed a case analysis over the six
Eisenstein units, which is the only place where the `d = 3` development is
longer than the `d = 2` one.

## 6. Not attempted: `d = 7, 11, …`

The class-number-one list is `d = 1, 2, 3, 7, 11, 19, 43, 67, 163`. Beyond
`d = 3` the rings are again half-integer `ℤ[(1+√−d)/2]` (`d ≡ 3 mod 4`), so the
Eisenstein pattern is the template, not the `Zsqrtd` one. Each new field still
needs its own split-prime theorem (`p` represented by the norm form), with the
quadratic-character computation again the only substantive input. Non-PID
fields are out of scope: there the generator/ideal correspondence must become an
ideal-class correspondence.

## 7. What not to claim

* Only `d = 2` and `d = 3` are done; `d = 7` and beyond are not.
* The representation formulas are stated as `Nat.card` counts in terms of the
  divisor sums, not as closed-form arithmetic functions of `n`.
* The `ℤ[i]` results are unchanged; they remain the special case `d = 1`.
