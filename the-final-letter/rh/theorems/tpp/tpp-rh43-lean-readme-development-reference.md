# Reference sheet: the Lean development of rh43

**Kind:** Proposition
**Status:** PROVED (Lean, no `sorry`, no `admit`, no project-specific `axiom`, no `native_decide`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh43/lean/README.md`](../../research/twin-prime-parity/rounds/rh43/lean/README.md) — header, "The object", "Notes on the proofs"

## Statement

> Machine-checked Lean 4 + Mathlib proofs for the rh43 round: the partial sums of the zeta Dirichlet series at `Re(S) = 0`, the positive/negative split, and the existence of a **balanced** partial sum.
>
> * No `sorry`, no `admit`, no project-specific `axiom`, no `native_decide`. A temporary `#print axioms` audit over every theorem reports exactly `[propext, Classical.choice, Quot.sound]`.
> * Everything is stated about the same object as the Python ground truth ([`../zeta_split.py`](../../research/twin-prime-parity/rounds/rh43/zeta_split.py)), whose certificates come from [`../ivmath.py`](../../research/twin-prime-parity/rounds/rh43/ivmath.py) and are independently reproduced by [`../verify/independent_check.py`](../../research/twin-prime-parity/rounds/rh43/verify/independent_check.py).
> * Self-contained: `import Mathlib` only.

The object is defined as:

```lean
noncomputable def zetaPartial (N : ℕ) (t : ℝ) : ℂ :=
  ∑ k ∈ Finset.range N, Complex.exp (-(t : ℂ) * Complex.I * Real.log (k + 1))
-- i.e. the sum of n^{-it} for n = 1, …, N

noncomputable def realPartial (N : ℕ) (t : ℝ) : ℝ :=
  ∑ k ∈ Finset.range N, Real.cos (t * Real.log (k + 1))

noncomputable def posRe (N : ℕ) (t : ℝ) : ℝ :=   -- terms with cos > 0
  ∑ k ∈ (Finset.range N).filter (fun k => 0 < Real.cos (t * Real.log (k + 1))),
    Real.cos (t * Real.log (k + 1))

noncomputable def negRe (N : ℕ) (t : ℝ) : ℝ :=   -- terms with cos < 0
  ∑ k ∈ (Finset.range N).filter (fun k => Real.cos (t * Real.log (k + 1)) < 0),
    Real.cos (t * Real.log (k + 1))

def balanced (N : ℕ) (t : ℝ) : Prop := posRe N t = -negRe N t
```

## Hypotheses and notation

- The five definitions `zetaPartial`, `realPartial`, `posRe`, `negRe`, `balanced` fix the round's object in Lean.
- The development is self-contained: `import Mathlib` only; the toolchain is `leanprover/lean4:v4.35.0-rc2` with Mathlib4 under `$HOME/lean`.
- `check.sh --all` checks `Rh43/Balance.lean` then `Rh43.lean`.

## Proof / evidence

- The README reports: no `sorry`, no `admit`, no project-specific `axiom`, no `native_decide`; the `#print axioms` audit over every theorem reports exactly `[propext, Classical.choice, Quot.sound]`.
- The same object as the Python ground truth `zeta_split.py`, whose certificates come from `ivmath.py` and are independently reproduced by `verify/independent_check.py`.

## Dependencies and related results

- Individual results harvested from the same README: [the real-part split identity](tpp-rh43-lean-readme-realpartial-split-identity.md), [the balance reduction](tpp-rh43-lean-readme-balanced-iff-realpartial-eq-zero.md), [the equal-split equivalences](tpp-rh43-lean-readme-balanced-iff-equal-split.md), [the trigonometric bounds](tpp-rh43-lean-readme-cos-bounds-at-five-halves.md), [existence of a balanced partial sum](tpp-rh43-lean-readme-exists-balanced-partial-sum.md), [`balanced_two`](tpp-rh43-lean-readme-balanced-two.md), [`zetaPartial_two_pi_div_log_two`](tpp-rh43-lean-readme-zetapartial-two-exact-vanishing.md), [`zetaPartial_three_ne_zero`](tpp-rh43-lean-readme-zetapartial-three-ne-zero.md), [`realPartial_continuous`](tpp-rh43-lean-readme-realpartial-continuous.md).

## Notes

- This entry is a reference sheet (the object definitions and the assurance claims) that the Lean README states as a block; it is harvested because those assurance claims are stated as results of the round ("no `sorry`", axiom list, ground-truth agreement).
- The definitions themselves are not theorems; the SPEC's definition exclusion applies to them, so they are quoted here only as context.
- The README also records that the complex split `posPart + negPart = zetaPartial` is deliberately **not** stated, since a term with `cos = 0` has nonzero imaginary part and belongs to neither filter.
