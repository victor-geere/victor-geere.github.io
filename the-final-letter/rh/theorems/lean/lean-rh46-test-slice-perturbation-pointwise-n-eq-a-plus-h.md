# Pointwise perturbation identity for the Liouville slice (indicator at `n = a + h`)

**Kind:** Theorem
**Status:** REFUTED (as stated in Lean; no copy elaborates, and the identity fails at h = 1, a = 2, n = 2)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh46/lean/Test7.lean`](../../research/twin-prime-parity/rounds/rh46/lean/Test7.lean) — lines 8 and 16–20 (representative copy; the same declaration name occurs in Test1–Test17 as a `theorem` and in Test18 as an `example`)

## Statement

Verbatim from `Test7.lean` (definition on line 8; theorem on lines 16–20, whose closing `:= by`
and proof script are omitted from the quotation; Test7 carries the source's own one-line title
`/-- Pointwise perturbation identity (correct signs). -/`):

```lean
/-- Pointwise perturbation identity (correct signs). -/
theorem corrSlice_sub_corr_pointwise (h a n : ℕ) (hh : h ≠ 0) :
    liouvilleSlice a n * liouvilleSlice a (n + h) - liouville n * liouville (n + h) =
      (if n = a + h then -2 * (liouville a * liouville (a + h)) else 0) +
      (if n + h = a then liouville a * liouville (a - h) else 0)
```

In the source's notation, with λ̃<sub>a</sub> the slice of λ at the index `a` and `[P]` the
indicator of `P`:

> λ̃<sub>a</sub>(n)·λ̃<sub>a</sub>(n+h) − λ(n)·λ(n+h) = [n = a+h]·(−2·λ(a)·λ(a+h)) + [n+h = a]·(λ(a)·λ(a−h))

This is the variant of the pointwise perturbation claim in which the `−2·λ(a)λ(a+h)` summand
is indexed by `n = a + h` rather than by `n = a`. All eighteen copies state the same formula;
Test1–Test6 write the two summands in the opposite order (`(if n + h = a then …) + (if n = a + h then …)`,
equal by commutativity of addition in ℤ), and Test18 states it in an `example` block instead of a
`theorem`.

## Hypotheses and notation

- `h a n : ℕ` with `h ≠ 0`.
- `Omega n = ArithmeticFunction.cardFactors n` (Mathlib's prime-factor count with multiplicity,
  line 6) and `liouville n = (-1) ^ Omega n` (`λ`, line 7).
- `liouvilleSlice a n` (`λ̃_a`, line 8) is `λ` with the **value** at `a` negated:
  `if n = a then -liouville n else liouville n`. Test1–Test18 write the same function as
  `if n = a then -liouville a else liouville n`; the two agree at every `n`.
- `if … then … else …` is Lean's `ite` on `ℕ`-equality; the arithmetic is in ℤ, and `a - h`
  is truncated subtraction in `ℕ`.

## Proof / evidence

The declaration `corrSlice_sub_corr_pointwise` occurs as a `theorem` in **Test1–Test17** and as an
`example` in **Test18** (all in namespace `Rh46`). **No copy contains a complete proof**:
re-elaborating all eighteen with the round's own toolchain (the `lean` binary used by `check.sh`,
`leanprover/lean4:v4.35.0-rc2` with Mathlib4) fails on every one, with `Test12.lean` (lines 27–28)
and `Test18.lean` (line 32) additionally containing an explicit `sorry`. The first error in the
copies is a tactic failure — a `rewrite` that finds no occurrence, `unknown identifier 'a'` after a
`subst`, or an application type mismatch in `slice_agree` — and the goals left unsolved include
`Test7.lean:33` with `⊢ -liouville a = liouville a`.

An explicit counterexample to the statement as written: `h = 1`, `a = 2`, `n = 2`. Then
λ(2) = −1, λ(3) = −1, λ̃<sub>2</sub>(2) = 1, λ̃<sub>2</sub>(3) = −1, so
LHS = 1·(−1) − (−1)·(−1) = −2, while both indicator conditions are false
(`2 + 1 ≠ 2` and `2 ≠ 2 + 1`) and the RHS is 0. This is visible in the first error of the
representative: `Test1.lean:24` reports the goal
`-liouville a * liouvilleSlice a (a + h) - liouville a * liouville (a + h) = (if a + h = a then liouville a * liouville (a - h) else 0) + if a = a + h then -2 * (liouville a * liouville (a + h)) else 0`,
whose right-hand side is `0`.

The source's own round records the *correct* identity at the level of the correlation sum
(`Rh46/Chowla.lean` lines 407–419): `corrSlice h a a - corr h a = -2 λ(a) λ(a+h) - 2 λ(a-h) λ(a)`.
Comparing summand by summand, the perturbation is `−2·λ(a)λ(a+h)` at `n = a` and `−2·λ(a−h)λ(a)`
at `n + h = a`; the present statement puts the first contribution at `n = a + h` (where the true
perturbation vanishes) and leaves the second with coefficient `+1` instead of `−2`. The present
statement is therefore the failed pointwise counterpart of that identity, not a proof of it.

## Dependencies and related results

- `slice_self` (`liouvilleSlice a a = -liouville a`) and `slice_agree` (`n < a → liouvilleSlice a n = liouville n`), declared in every one of these files and proved in full in
  [`Rh46/Chowla.lean`](../../research/twin-prime-parity/rounds/rh46/lean/Rh46/Chowla.lean) (lines 319, 332); the attempted proofs use both.
- The intended (and in the source unproved) identity at the level of the whole correlation:
  [The exact perturbation of the correlation by one sign flip (stated, not proved)](lean-rh46-chowla-corrslice-perturbation-identity.md), from `Rh46/Chowla.lean` lines 407–419.
- The companion variant of this same declaration with the `−2` summand indexed by `n = a`:
  [Pointwise perturbation identity for the Liouville slice (indicator at `n = a`)](lean-rh46-test-slice-perturbation-pointwise-n-eq-a.md).
- Proved companions in the round: [The slice perturbation has ℓ²-mass exactly 4](lean-rh46-chowla-corrslice-perturbation-l2-mass-four.md), [Prefix agreement of the slice correlations with corr h N](lean-rh46-chowla-corrslice-prefix-agreement.md).

## Notes

- The eighteen files Test1–Test18 are near-duplicate copies of this one statement and are **folded
  together** into this single file; Test7 is quoted as the representative because it carries the
  source's own title comment. Test1–Test6 differ only in the order of the two summands.
- The source never labels this result refuted, and never proves it. `REFUTED` is assigned by the
  harvester on the evidence above: the statement is false (counterexample `h = 1`, `a = 2`, `n = 2`),
  every copy's proof script fails, and the source's own recorded correlation-level identity gives a
  different perturbation. The source's title comment "correct signs" is **not** borne out.
- `slice_self` and `slice_agree`, declared in every file, are trivial plumbing (a `@[simp]`
  definitional unfolding and an `ite` unfolding) and are not harvested separately.
- The near-duplicate statement of this file and of
  [the variant indexed at `n = a`](lean-rh46-test-slice-perturbation-pointwise-n-eq-a.md) are the
  only two distinct `corrSlice_sub_corr_pointwise` formulations in Test1–Test27.
