# T8 — existence of a root for every N >= 3

**Kind:** Theorem
**Status:** PROOF-SKETCH (density step quoted) + VERIFIED (numerical, `N <= 200`); self-contained proof OPEN
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh43/truths.md`](../../research/twin-prime-parity/rounds/rh43/truths.md) — §8 ledger row T8 (§1.4)

## Statement

> | id | statement | status | evidence |
> |---|---|---|---|
> | T8 | existence of a root for every `N >= 3` | **PROOF-SKETCH** + **VERIFIED** (`N <= 200`) | §1.4, §6 |

The §1.4 numbered form:

> **Theorem 7 (existence for every N >= 3).** For every `N >= 3` there is a real `t` with `Re S_N(t) = 0`; hence a balanced split exists for every `N >= 2`.
> **PROOF-SKETCH** (the finite part is verified, the density step is quoted): `Re S_N` is continuous and `Re S_N(0) = N > 0`. On the other side, for a *fixed* `N` the vector `(t log 2, …, t log N)` is equidistributed on the torus as `t` varies — the functions `t -> t log n` are linearly independent over `Q` — so the values `Re S_N(t)` take both signs infinitely often; in particular some `t` has `Re S_N(t) < 0` (choose `t` so that the terms of one sign dominate), and the intermediate value theorem gives a root.

## Hypotheses and notation

- `N >= 3`; `t` real; `Re S_N(0) = N > 0`.
- **Quoted input:** equidistribution of `(t log 2, …, t log N)` on the torus, from the `Q`-linear independence of `t -> t log n`.

## Proof / evidence

- Ledger row T8: "**PROOF-SKETCH** + **VERIFIED** (`N <= 200`)", evidence "§1.4, §6".
- The finite part is verified; the density step is quoted rather than proved. The self-contained proof is the round's main open item.

## Dependencies and related results

- The numbered form is [Theorem 7 (existence for every N >= 3)](tpp-rh43-truths-existence-every-n.md).
- Related: [T5](tpp-rh43-truths-n3-balanced-ledger.md), [T6](tpp-rh43-truths-n4-balanced-ledger.md), [T7](tpp-rh43-truths-certified-root-ledger.md).

## Notes

- Ledger row T8 restates §1.4 Theorem 7. The status must not be read as an unconditional proof: the source names the missing quantitative estimate explicitly.
