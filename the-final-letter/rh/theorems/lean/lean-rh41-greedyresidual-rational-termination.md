# Theorem 8 (first half) — rational termination of the greedy residual

**Kind:** Theorem
**Status:** PROVED (Lean, no sorry)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh41/lean/Rh41/GreedyResidual.lean`](../../research/twin-prime-parity/rounds/rh41/lean/Rh41/GreedyResidual.lean) — lines 354–358 (`Rh41.Harmonic.terminates_of_pos_lt_one`); lines 360–364 (`Rh41.Harmonic.terminates_rat`); lines 298–302 (`Rh41.Harmonic.terminates_aux`); lines 373–377 (`Rh41.Harmonic.terminates_from`); lines 379–384 (`Rh41.Harmonic.residual_eventually_zero`); lines 151–157 (`Rh41.Harmonic.num_sub_inv_lt`)

## Statement

> **Theorem 8 (first half).** Every positive rational below `1` terminates under the greedy rule.

> **Theorem 8 (first half), `p/q` form.** For `0 < p < q` the greedy residual of `p/q` reaches `0` at some finite step.

> **Theorem 8 (first half), general-index form.** From any step index `i`, a positive rational residual below `1/(i+1)` reaches `0` in finitely many steps.

> **Tail formulation.** The residual vanishes from some index on (and then stays `0`).

Formally (Lean 4 / Mathlib):

```lean
theorem terminates_of_pos_lt_one (r : ℚ) (hr0 : 0 < r) (hr1 : r < 1) :
    ∃ N, residual 0 r N = 0

theorem terminates_rat (p q : ℕ) (hp : 0 < p) (hq : p < q) :
    ∃ N, residual 0 ((p : ℚ) / q) N = 0

theorem terminates_aux (p : ℕ) : ∀ (i : ℕ) (r : ℚ),
    0 < r → r < 1 / ((i : ℚ) + 1) → r.num.natAbs = p → ∃ N, residual i r N = 0

theorem terminates_from (i : ℕ) (r : ℚ) (hr : 0 < r) (hlt : r < 1 / ((i : ℚ) + 1)) :
    ∃ N, residual i r N = 0

theorem residual_eventually_zero (i : ℕ) (r : ℚ) (hr : 0 < r)
    (hlt : r < 1 / ((i : ℚ) + 1)) : ∃ N, ∀ m, N ≤ m → residual i r m = 0
```

The engine of the induction is stated separately:

> **Fibonacci–Sylvester numerator decrease.** If the step with constant `k` is active (`1/k ≤ r`), the next constant is strictly beyond the greedy choice (`r·(k−1) < 1`), and the new residual is nonzero, then the numerator of the new residual (in lowest terms) is strictly smaller.

```lean
lemma num_sub_inv_lt {r : ℚ} {k : ℕ} (hk : 2 ≤ k) (hle : (1 : ℚ) / k ≤ r)
    (hltrk : r * ((k : ℚ) - 1) < 1) (hne : r - (1 : ℚ) / k ≠ 0) :
    (r - (1 : ℚ) / k).num.natAbs < r.num.natAbs
```

## Hypotheses and notation

- `residual n0 r k` — the residual after `k` steps of the greedy process with alphabet `1/(n+2)`, starting at step index `n0` with residual `r`; step `k` uses the constant `1/(n0+k+2)` (line 59).
- `active n r : Prop := (1 : ℚ) / (n + 2) ≤ r` (line 54).
- `terminates_aux` is the strong induction on the numerator `p = r.num.natAbs`; `terminates_from` and `terminates_of_pos_lt_one` are its instances (`i = 0` with `r < 1`); `terminates_rat` is the case `r = p/q`.
- `r.num` is the numerator of the rational `r` in lowest terms.

## Proof / evidence

Complete Lean proofs, no `sorry`/`admit`, no new axioms, no `native_decide` — declarations in `Rh41/GreedyResidual.lean` as cited above (sub-namespace `Rh41.Harmonic`).

The standard Fibonacci–Sylvester argument (file's section 2 header): at an active step with constant `k` the residual `p/q` becomes `(p·k − q)/(q·k)`, and `k < q/p + 1` gives `p·k − q < p`, so the numerator in lowest terms strictly decreases. `num_sub_inv_lt` formalises the numerator decrease; `terminates_aux` runs strong induction on the numerator for an arbitrary starting index `i` under the invariant `r < 1/(i+1)`; `residual_eventually_zero` combines `terminates_from` with `residual_eq_zero_of_le` (once the residual is `0` it stays `0`).

## Dependencies and related results

- [The support for x = 1 is exactly {0,1,4}](lean-rh41-greedyresidual-support-of-one.md) — the companion half of Theorem 8.
- [The residual invariant](lean-rh41-greedyresidual-residual-invariant.md) — the invariant `0 ≤ r < 1/(n+1)` preserved by the orbit.
- [The squaring law](lean-rh41-greedyresidual-squaring-law.md) — the quantitative form of the active-step dynamics.

## Notes

- Auxiliary declarations `residual_succ`, `active_iff`, `exists_active_const`, `firstActive` and its lemmas (`firstActive_spec`, `firstActive_min`, `firstActive_gt_inv`, `firstActive_ge`, `firstActive_gt_inv_pred`), `residual_add`, `residual_eq_zero_of_le`, `residual_zero_prefix`, `residual_shift`, `residual_stays`, `residual_first` are index bookkeeping and shift lemmas for this theorem and are not harvested separately.
- The file header describes the development as having "no `sorry`s, no `admit`s and no new axioms (only classical logic and `propext`/`Quot.sound` via Mathlib)."
