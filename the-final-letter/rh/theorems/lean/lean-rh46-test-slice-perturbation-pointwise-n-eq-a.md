# Pointwise perturbation identity for the Liouville slice (indicator at `n = a`)

**Kind:** Theorem
**Status:** REFUTED (as stated in Lean; no copy elaborates, and the identity fails at h = 1, a = 2, n = 1)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh46/lean/Test20.lean`](../../research/twin-prime-parity/rounds/rh46/lean/Test20.lean) — lines 8 and 16–19 (representative copy; the same declaration name occurs in Test19, Test21, Test22, Test23, Test24, Test26, Test27)

## Statement

Verbatim from `Test20.lean` (definition on line 8; theorem on lines 16–19, whose closing
`:= by` and proof script are omitted from the quotation):

```lean
def liouvilleSlice (a n : ℕ) : ℤ := if n = a then -liouville n else liouville n

theorem corrSlice_sub_corr_pointwise (h a n : ℕ) (hh : h ≠ 0) :
    liouvilleSlice a n * liouvilleSlice a (n + h) - liouville n * liouville (n + h) =
      (if n = a then -2 * (liouville a * liouville (a + h)) else 0) +
      (if n + h = a then liouville a * liouville (a - h) else 0)
```

In the source's notation, with λ̃<sub>a</sub> the slice of λ at the index `a` and `[P]` the
indicator of `P`:

> λ̃<sub>a</sub>(n)·λ̃<sub>a</sub>(n+h) − λ(n)·λ(n+h) = [n = a]·(−2·λ(a)·λ(a+h)) + [n+h = a]·(λ(a)·λ(a−h))

i.e. the claim that flipping the value of λ at the single index `a` changes the summand
`λ(n)λ(n+h)` of the correlation exactly on the index conditions `n = a` and `n = a + h`, with
the values displayed. (The two summands of the correlation that contain `λ(a)` sit at `n = a`
and at `n + h = a`; see Proof / evidence.)

The eight copies spell the same statement with three immaterial variations:

* `-2 * (liouville n * liouville (n + h))` instead of `-2 * (liouville a * liouville (a + h))`
  (Test19, Test24, Test26) — equal under the branch hypothesis `n = a`;
* `liouville (a - h) * liouville a` instead of `liouville a * liouville (a - h)`
  (Test24, Test26, Test27) — commutativity of ℤ-multiplication;
* Test19–Test23 keep the two summands in the order displayed above.

## Hypotheses and notation

- `h a n : ℕ` with `h ≠ 0` — the only side condition the source imposes; the source states
  no reason for it.
- `Omega n = ArithmeticFunction.cardFactors n` (Mathlib's count of prime factors with
  multiplicity, `Test20.lean` line 6) and `liouville n = (-1) ^ Omega n` (`λ`, line 7).
- `liouvilleSlice a n` (`λ̃_a`, line 8) is `λ` with the **value** at `a` negated:
  `if n = a then -liouville n else liouville n`. (Test1–Test18 write the same function as
  `if n = a then -liouville a else liouville n`; the two agree at every `n`.)
- `if … then … else …` is Lean's `ite` on `ℕ`-equality; the arithmetic is in ℤ.
- The two `if … then … else …` factors are the two case indicators of the statement; the
  argument `a - h` of λ is truncated subtraction in `ℕ`.

## Proof / evidence

The declaration `corrSlice_sub_corr_pointwise` is a `theorem` (not a `sorry`-stub) in each of
**Test19, Test20, Test21, Test22, Test23, Test24, Test26, Test27** (`Rh46.corrSlice_sub_corr_pointwise`).
**No copy contains a complete proof**: re-elaborating all eight with the round's own toolchain
(the `lean` binary used by `check.sh`, `leanprover/lean4:v4.35.0-rc2` with Mathlib4) fails on
every one of them, with no `sorry` involved. In the failing case the goal is reduced (by the
attempted proof's own valid rewrites) to a false ℤ-identity, e.g.

* `Test20.lean:29` leaves `-(liouville n * liouville a) - liouville n * liouville (n + h) = liouville n * liouville a`;
* `Test23.lean:31`, `Test24.lean:29`, `Test27.lean:29` leave `-(x * y * 2) = x * y` with
  `x = liouville (a - h)`, `y = liouville a`, i.e. `−2xy = xy`, which is false for every
  `x, y ∈ {±1}`.

An explicit counterexample to the statement as written: `h = 1`, `a = 2`, `n = 1`. Then
λ(1) = 1, λ(2) = −1, λ(3) = −1, λ̃<sub>2</sub>(1) = 1, λ̃<sub>2</sub>(2) = 1, so
LHS = 1·1 − 1·(−1) = 2, while RHS = 0 + λ(2)·λ(1) = −1. The file `Test25.lean` (lines 15 and
10–13) isolates exactly this residual arithmetic fact — `-(x * y * 2) = x * y → x * y = 0` —
as an `example` (its first `example` even asserts `False` from that hypothesis, with a `sorry`).

The source's own round records the *correct* identity at the level of the correlation sum:
`Rh46/Chowla.lean` lines 407–419 state
`corrSlice h a a - corr h a = -2 λ(a) λ(a+h) - 2 λ(a-h) λ(a)`, whose summand at `n = a - h`
(i.e. `n + h = a`) is `−2·λ(a−h)·λ(a)`, not the `λ(a)·λ(a−h)` written here. The present
statement is therefore the failed pointwise counterpart of that identity, not a proof of it.

## Dependencies and related results

- `slice_self` (`liouvilleSlice a a = -liouville a`) and `slice_agree` (`n < a → liouvilleSlice a n = liouville n`), declared in every one of these files and proved in full in
  [`Rh46/Chowla.lean`](../../research/twin-prime-parity/rounds/rh46/lean/Rh46/Chowla.lean) (lines 319, 332); the attempted proofs use both.
- The intended (and in the source unproved) identity at the level of the whole correlation:
  [The exact perturbation of the correlation by one sign flip (stated, not proved)](lean-rh46-chowla-corrslice-perturbation-identity.md), from `Rh46/Chowla.lean` lines 407–419.
- The companion variant of this same declaration with the `−2` summand indexed by `n = a + h`:
  [Pointwise perturbation identity for the Liouville slice (indicator at `n = a + h`)](lean-rh46-test-slice-perturbation-pointwise-n-eq-a-plus-h.md).
- Proved companions in the round: [The slice perturbation has ℓ²-mass exactly 4](lean-rh46-chowla-corrslice-perturbation-l2-mass-four.md), [Prefix agreement of the slice correlations with corr h N](lean-rh46-chowla-corrslice-prefix-agreement.md).

## Notes

- The eight files Test19–Test27 (excluding Test25, which declares no theorem) are near-duplicate
  copies of this one statement and are **folded together** into this single file; Test20 is quoted
  as the representative.
- The source never labels this result refuted, and never proves it. `REFUTED` is assigned by the
  harvester on the evidence above: the statement is false (counterexample `h = 1`, `a = 2`, `n = 1`),
  and the residual goal left by every copy's own proof script is the false identity `−2xy = xy`.
  The status must not be read as a proof in either direction from the source; what the source
  performs is a sequence of correctness-decreasing proof attempts. Two independent checks agree:
  the failed elaborations above, and the round's own recorded identity `−2λ(a)λ(a+h) − 2λ(a−h)λ(a)`.
- `Test25.lean` is excluded from the harvest: it declares no `theorem`/`lemma` (only two `example`s,
  the first of which uses `sorry`), and its content is the residual arithmetic fact noted above.
- `slice_self` and `slice_agree`, declared in every file, are trivial plumbing (a `@[simp]`
  definitional unfolding and an `ite` unfolding) and are not harvested separately.
