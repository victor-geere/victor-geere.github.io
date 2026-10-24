# Answer: yes — for every N ≥ 2

**Kind:** Theorem
**Status:** **SETTLED for every `N ≥ 3` (register OP-7, 2026-10-11).** PROVED (Lean) for `N = 2, 3`; the uniform height `t_N = π/log N` is proved elementarily for all `N ≥ 20` and certified for `N = 3..300` by `open/op07_root_existence.py` (298/298 construction-A certificates, 17/17 explicit rational heights for `N = 3..19`); no equidistribution is quoted.
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh43/README.md`](../../research/twin-prime-parity/rounds/rh43/README.md) — "Answer: yes — for every `N ≥ 2`"

## Statement

> **Answer: yes — for every `N ≥ 2`.** The split is an identity, `P_N + M_N = Re S_N(t)`, and the requested separation is exactly the single equation `Re S_N(t) = 0`, which is attained at every `N ≥ 2`:
>
> | N | how it is attained | status |
> |---|---|---|
> | 1 | `Re S_1 ≡ 1`: one positive part, no negative part — the only degenerate case | **PROVED** |
> | 2 | `t = π/log 2` exactly: the terms are `+1` and `−1`; the zero is *tangential* | **PROVED** (Lean) + **VERIFIED** |
> | 3 | `t = 5/2` has `Re S_3(5/2) = −0.084335758298… < 0` while `Re S_3(0) = 3 > 0`; IVT gives the root | **PROVED** (Lean) |
> | 4 | `Re S_4(12/5) = −0.950677206742… < 0`, same route | **PROVED** (certified) |
> | 3 … 50 | certified 47-digit root brackets (auditor's independent engine) | **VERIFIED** |
> | every `N ≥ 3` | by equidistribution of `(t log 2, …, t log N)` | **PROOF-SKETCH** + **VERIFIED** to `N = 200` |

The question of the round, from the header:

> For a complex input `S` with `Re(S) = 0` (`S = i t`), take a finite partial sum of the zeta Dirichlet series, `S_N(t) = Σ_{n=1}^{N} n^{-it}`, and split every term into its positive real part `P_N(t) ≥ 0` and its negative real part `M_N(t) ≤ 0`. Can the partial sum be separated into **two equal positive parts and two equal negative parts**, using only the positive parts and the negative parts with ordinary summation?

## Hypotheses and notation

- `S = i t`, `t` real (`Re(S) = 0`); `S_N(t) = Σ_{n=1}^{N} n^{-it}`.
- `P_N(t) ≥ 0` the sum of the positive real parts, `M_N(t) ≤ 0` the sum of the negative real parts.
- "The requested separation" is `P_N(t) = |M_N(t)|`, equivalently `Re S_N(t) = 0`.
- Certified values quoted: `Re S_3(5/2) = −0.084335758298…`, `Re S_4(12/5) = −0.950677206742…`.

## Proof / evidence

- **PROVED (Lean)** for `N = 2` (`t = π/log 2`, tangential zero) and `N = 3` (`t = 5/2` with the IVT witness).
- **PROVED (certified)** for `N = 4`: `Re S_4(12/5) = −0.950677206742… < 0`, same route.
- **VERIFIED** for the 47-digit root brackets over `N = 3 … 50` (auditor's independent engine).
- **PROOF-SKETCH + VERIFIED to `N = 200`** for every `N ≥ 3`, by equidistribution of `(t log 2, …, t log N)`.

## Dependencies and related results

- Harvested truths counterparts: [Theorem 2 (N = 1)](tpp-rh43-truths-n1-degenerate.md), [Theorem 3 (N = 2)](tpp-rh43-truths-n2-balanced-tangential.md), [Theorem 4 (N = 3)](tpp-rh43-truths-n3-existence-ivt.md), [Theorem 5 (N = 4)](tpp-rh43-truths-n4-ivt-witness.md), [Theorem 6 (root table)](tpp-rh43-truths-certified-root-table.md), [Theorem 7 (every N ≥ 3)](tpp-rh43-truths-existence-every-n.md).
- Harvested handoff counterpart: [The answer: yes, for every N ≥ 2](tpp-rh43-handoff-answer-yes-every-n.md).

## Notes

- The README's row for `N = 1` is listed inside the "Answer: yes" table but is the degenerate case, not a balance instance.
- The README's own §"What this folder does *not* claim" repeats that the `N ≥ 3` statement is not proved without equidistribution and that no relation to zeta zeros is claimed.
