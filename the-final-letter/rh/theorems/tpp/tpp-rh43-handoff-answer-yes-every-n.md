# The answer: yes, for every N ≥ 2

**Kind:** Theorem
**Status:** PROVED (paper argument) + VERIFIED (numerical); the case of every `N ≥ 3` is PROOF-SKETCH (equidistribution quoted) + VERIFIED to `N = 200`
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh43/HANDOFF.md`](../../research/twin-prime-parity/rounds/rh43/HANDOFF.md) — §2.3 "The reduction, and the answer"

## Statement

> **Yes.** `Re S_N(t) = 0` is attained for every `N ≥ 2`:
>
> * `N = 2`: `t = π/log 2` gives `1 + cos π = 0` **exactly**. The zero is tangential (`1 + cos(t log 2) ≥ 0` everywhere), so a sign-change search misses it — this was the round's first error and is now proved in Lean (`balanced_two`).
> * `N = 3`: `Re S_3(0) = 3 > 0`, `Re S_3(5/2) < 0` (certified `-0.084335758298…`), so IVT gives a root. **PROVED** in [`lean/Rh43/Balance.lean`](../../research/twin-prime-parity/rounds/rh43/lean/Rh43/Balance.lean), 38 theorems, no `sorry`, no new axiom; the two inputs are the trigonometric bounds `cos((5/2)log 2) < -0.16`, `cos((5/2)log 3) < -0.92`, derived from Mathlib's `log`/`π` bounds and the sine/cosine Taylor inequalities.
> * `N = 4`: `Re S_4(12/5) = -0.9506772… < 0`, same route.
> * `N = 3, …, 50`: certified root brackets, 47 digits each (the auditor's independent engine), reproduced by the round's own `ivmath` engine.
> * every `N ≥ 3`: existence is **PROOF-SKETCH + VERIFIED** (equidistribution), and a self-contained proof is the main open item (§6).

The round's object and question are fixed in §2.1–2.2: `S = i t` with `t` real, `S_N(t) = Σ_{n=1}^{N} n^{-it} = Σ_{n=1}^{N} exp(-i t log n) ∈ ℂ` (`S_N(0) = N`), split by the sign of the real part into `P_N(t) = Σ_{cos(t log n) > 0} cos(t log n) ≥ 0` and `M_N(t) = Σ_{cos(t log n) < 0} cos(t log n) ≤ 0`.

## Hypotheses and notation

- `t` real; `P_N ≥ 0` the sum of the positive real parts, `M_N ≤ 0` the sum of the negative ones.
- "Balanced" means `P_N(t) = |M_N(t)|`, equivalent to `Re S_N(t) = 0` (the reduction of §2.3).
- The `N = 2` zero is *tangential*: `1 + cos(t log 2) ≥ 0` everywhere, with equality at the roots.
- The `N = 3` inputs are the trigonometric bounds `cos((5/2)log 2) < -0.16` and `cos((5/2)log 3) < -0.92`.

## Proof / evidence

- **PROVED in Lean** for `N = 2` (`balanced_two`) and `N = 3` (38 theorems, no `sorry`, no new axiom, `#print axioms` = `[propext, Classical.choice, Quot.sound]`).
- **VERIFIED** numerics for `N = 4` (`Re S_4(12/5) = -0.9506772… < 0`) and for the 47-digit root brackets at every `N = 3, …, 50`.
- **PROOF-SKETCH + VERIFIED** for every `N ≥ 3`: equidistribution is quoted; the numerical evidence is complete through `N = 200`; a self-contained proof is the round's main open item (§6).

## Dependencies and related results

- The reduction to one real equation is [The reduction: `P_N + M_N = Re S_N`](tpp-rh43-handoff-reduction-to-real-equation.md).
- Related harvested handoff files: [N = 2 is balanced exactly at π/log 2](tpp-rh43-handoff-n2-tangential-zero.md), [N = 3 is balanced with the explicit IVT witness t = 5/2](tpp-rh43-handoff-n3-ivt-witness.md), [Existence for every N ≥ 3](tpp-rh43-handoff-existence-every-n.md).
- Related harvested truths files: [Theorem 3 (N = 2)](tpp-rh43-truths-n2-balanced-tangential.md), [Theorem 4 (N = 3)](tpp-rh43-truths-n3-existence-ivt.md), [Theorem 6 (certified root table)](tpp-rh43-truths-certified-root-table.md), [Theorem 7 (every N ≥ 3)](tpp-rh43-truths-existence-every-n.md).

## Notes

- The source's own one-paragraph version says "**The answer is yes for every `N ≥ 2`**" and records that `N = 1` is the only degenerate case.
- The `N ≥ 3` component is conditional on the quoted equidistribution step and is **not** claimed self-contained (§6).
