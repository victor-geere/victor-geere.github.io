# T14 — the positive-values-only two-subset problem

**Kind:** Theorem
**Status:** PROOF-SKETCH + VERIFIED (numerical, defect measured at 7 points, 15/15 checks); exact equality REFUTED at every tested point, OPEN in general
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh43/truths.md`](../../research/twin-prime-parity/rounds/rh43/truths.md) — §3.2 "The **positive-values-only** two-set problem (T14)" (ledger row T14)

## Statement

> ### 3.2 The **positive-values-only** two-set problem (T14)
>
> A looser reading of the question, worth separating out: work with the *positive* terms only and ask for two **disjoint subsets** `A, B` of them with `sum(A) = sum(B)` (equivalently `sum(A) = P/2`, `P = ` the positive total). This involves no balance equation at all.
>
> * **The top-level criterion is much weaker than balance.** Since `cos(t log 1) = 1` is always the largest positive term, a nonempty split needs `1 <= P/2`, i.e. `P >= 2`. That is a single *inequality*, satisfiable for every `t` once `N` is large enough (`N = 200`, `t = 0.2`: `P = 127.44`), whereas the balanced split needs the exact transcendental equation `Re S_N(t) = 0`.
> * **But exact equality of the two subsets needs completeness at *every* index.** By Brown's criterion the subset sums of `a_1 >= a_2 >= ... >= a_m` fill `[0, P]` exactly when `a_k <= a_{k+1} + ... + a_m` for **every** `k`. For the positive terms the last condition is `a_m <= 0`, which fails always: the final term has nothing after it, so a gap survives and no two subsets are exactly equal.
> * **Measured:** the greedy split (largest first, no overshoot — exact for complete sequences) leaves `P/2 - sum(A) = 4.3e-4` at `N=20, t=1/2`; `2.0e-2` at `N=20, t=1`; `4.3e-1` at `N=40, t=0.2`; `1.4e-2` at `N=60, t=2`; and only `1.0e-4`, `1.5e-4` at `N = 400, 800`, `t=1`. The defect is small and irregular but never zero ([`verify/positive_only_split.log`](../../research/twin-prime-parity/rounds/rh43/verify/positive_only_split.log), 15/15 checks; [`positive_only_N20.png`](../../research/twin-prime-parity/rounds/rh43/positive_only_N20.png) draws the best pair at `N=20, t=1/2`: `A={2,3,6,8,9,10,13,15,17}`, `B={1,4,5,7,11,12,14,16,18,19,20}`, sums `4.439862577` and `4.439877757` against `P/2 = 4.439870167`, gap `1.52e-5`).
> * **Caveat.** The last-index obstruction shows the subset sums do not *fill* `[0,P]`; it does not by itself prove `P/2` is outside the reachable set for every `N` and `t`. Exactness would require `P/2` to coincide with one of the finitely many subset sums — a coincidence among transcendental values. It is **REFUTED** at every tested point and **OPEN** in general.
> * **If exactness is relaxed to "within floating-point tolerance", the split always exists** (take the greedy pair; the residual is `< 1e-4` in the tested range). The obstruction is only to *exact* equality.

## Hypotheses and notation

- The positive terms only: `A, B` disjoint subsets of the indices with `cos(t log n) > 0`; `P` is the positive total.
- **Brown's criterion** (quoted): the subset sums of `a_1 >= a_2 >= ... >= a_m` fill `[0, P]` exactly when `a_k <= a_{k+1} + ... + a_m` for every `k`.
- The last-index condition `a_m <= 0` fails always, since the final term has nothing after it.
- Defect measurements are quoted for `(N, t)` — `N=20, t=1/2`: `4.3e-4`; `N=20, t=1`: `2.0e-2`; `N=40, t=0.2`: `4.3e-1`; `N=60, t=2`: `1.4e-2`; `N = 400, 800`, `t=1`: `1.0e-4`, `1.5e-4`.

## Proof / evidence

- Ledger row T14: status "**PROOF-SKETCH** + **VERIFIED** (defect measured at 7 points, 15/15 checks)", evidence "§3.2, `verify/positive_only_split.py`".
- The exact-equality question is "**REFUTED** at every tested point and **OPEN** in general"; the greedy-split defect is recorded in [`verify/positive_only_split.log`](../../research/twin-prime-parity/rounds/rh43/verify/positive_only_split.log) (15/15 checks).
- The float-tolerance relaxation always has a solution (greedy pair, residual `< 1e-4` in the tested range).

## Dependencies and related results

- Uses Brown's criterion (quoted classical completeness criterion, CITED within the argument).
- Related: [Theorem 11′ (the term-level split fails)](tpp-rh43-truths-term-level-split-fails.md) (T9′); contrast [Theorem 11](tpp-rh43-truths-numeric-split-exact.md) (T9).

## Notes

- The source explicitly warns that the last-index obstruction does **not** by itself prove `P/2` is unreachable for every `N` and `t`; the honest status is REFUTED at tested points, OPEN in general.
- The criterion `P >= 2` is described as "a single *inequality*", much weaker than the exact transcendental equation `Re S_N(t) = 0` required for the balanced split.
