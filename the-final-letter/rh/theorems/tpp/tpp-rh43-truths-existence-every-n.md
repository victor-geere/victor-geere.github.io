# Theorem 7 (existence for every N >= 3)

**Kind:** Theorem
**Status:** **SETTLED 2026-10-11 (register OP-7).** The self-contained proof no longer needs equidistribution: the uniform height `t_N = π/log N` works, with an elementary proof for every `N ≥ 20` (terms `n ≤ √N` contribute at most `√N`; every `n ∈ [N/e, N]` gives `cos(t_N log n) ≤ −cos(π/log N)`), and certified explicit rational heights for `N = 3..19`. See `open/op07_root_existence.py` (PASS). The harvested PROOF-SKETCH/VERIFIED status is superseded.
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh43/truths.md`](../../research/twin-prime-parity/rounds/rh43/truths.md) — §1.4 "Existence for every `N >= 3` — the general statement" (ledger row T8)

## Statement

> **Theorem 7 (existence for every N >= 3).** For every `N >= 3` there is a real `t` with `Re S_N(t) = 0`; hence a balanced split exists for every `N >= 2`.
>
> **PROOF-SKETCH** (the finite part is verified, the density step is quoted): `Re S_N` is continuous and `Re S_N(0) = N > 0`. On the other side, for a *fixed* `N` the vector `(t log 2, …, t log N)` is equidistributed on the torus as `t` varies — the functions `t -> t log n` are linearly independent over `Q` — so the values `Re S_N(t)` take both signs infinitely often; in particular some `t` has `Re S_N(t) < 0` (choose `t` so that the terms of one sign dominate), and the intermediate value theorem gives a root.

## Hypotheses and notation

- `N >= 3` an integer; `t` real.
- **Quoted input:** equidistribution on the torus of `(t log 2, …, t log N)`, justified by the `Q`-linear independence of `t -> t log n` (the functions `t -> t log n` are linearly independent over `Q`).
- `Re S_N(0) = N > 0`, and continuity of `Re S_N`.

## Proof / evidence

- The ledger row T8 gives the status "**PROOF-SKETCH** + **VERIFIED** (`N <= 200`)", evidence "§1.4, §6".
- **VERIFIED** numerically for every `N = 3, …, 200` (the smallest positive root is bracketed and bisected for `N <= 50` in the certified table of §1.3, and the sign of `Re S_N` is found negative for a range of heights up to `N = 200`).
- A *self-contained* proof of the general statement — one that avoids equidistribution — is **OPEN** (truths.md §6).

## Dependencies and related results

- Uses the finite cases [Theorem 4 (N = 3)](tpp-rh43-truths-n3-existence-ivt.md), [Theorem 5 (N = 4)](tpp-rh43-truths-n4-ivt-witness.md) and [Theorem 6 (certified root table)](tpp-rh43-truths-certified-root-table.md).
- The open item is recorded in truths.md §6 and in [HANDOFF.md](../../research/twin-prime-parity/rounds/rh43/HANDOFF.md) §6.

## Notes

- The source states this result conditionally on a quoted equidistribution step and explicitly does **not** claim a self-contained proof; the source's §9 repeats: "It does **not** prove Theorem 7 for all `N` without equidistribution (§6)."
- The numerical evidence is complete through `N = 200`; the missing piece is described as "a quantitative 'some height makes the sum negative' estimate".
