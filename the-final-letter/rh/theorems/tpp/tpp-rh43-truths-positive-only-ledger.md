# T14 — the positive-values-only two-subset problem (ledger row)

**Kind:** Theorem
**Status:** PROOF-SKETCH + VERIFIED (numerical, 15/15 checks); exact equality REFUTED at tested points, OPEN in general
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh43/truths.md`](../../research/twin-prime-parity/rounds/rh43/truths.md) — §8 ledger row T14 (§3.2)

## Statement

> | id | statement | status | evidence |
> |---|---|---|---|
> | T14 | the **positive-values-only** two-subset problem: top-level criterion only `P >= 2`, exact equality blocked by the completeness failure at the last index | **PROOF-SKETCH** + **VERIFIED** (defect measured at 7 points, 15/15 checks) | §3.2, `verify/positive_only_split.py` |

The §3.2 prose form:

> A looser reading of the question, worth separating out: work with the *positive* terms only and ask for two **disjoint subsets** `A, B` of them with `sum(A) = sum(B)` (equivalently `sum(A) = P/2`, `P = ` the positive total). This involves no balance equation at all.
>
> * **The top-level criterion is much weaker than balance.** Since `cos(t log 1) = 1` is always the largest positive term, a nonempty split needs `1 <= P/2`, i.e. `P >= 2`. That is a single *inequality*, satisfiable for every `t` once `N` is large enough (`N = 200`, `t = 0.2`: `P = 127.44`), whereas the balanced split needs the exact transcendental equation `Re S_N(t) = 0`.
> * **But exact equality of the two subsets needs completeness at *every* index.** By Brown's criterion the subset sums of `a_1 >= a_2 >= ... >= a_m` fill `[0, P]` exactly when `a_k <= a_{k+1} + ... + a_m` for **every** `k`. For the positive terms the last condition is `a_m <= 0`, which fails always: the final term has nothing after it, so a gap survives and no two subsets are exactly equal.
> * **Measured:** the greedy split (largest first, no overshoot — exact for complete sequences) leaves `P/2 - sum(A) = 4.3e-4` at `N=20, t=1/2`; `2.0e-2` at `N=20, t=1`; `4.3e-1` at `N=40, t=0.2`; `1.4e-2` at `N=60, t=2`; and only `1.0e-4`, `1.5e-4` at `N = 400, 800`, `t=1`. The defect is small and irregular but never zero.
> * **Caveat.** The last-index obstruction shows the subset sums do not *fill* `[0,P]`; it does not by itself prove `P/2` is outside the reachable set for every `N` and `t`. Exactness would require `P/2` to coincide with one of the finitely many subset sums — a coincidence among transcendental values. It is **REFUTED** at every tested point and **OPEN** in general.
> * **If exactness is relaxed to "within floating-point tolerance", the split always exists** (take the greedy pair; the residual is `< 1e-4` in the tested range). The obstruction is only to *exact* equality.

## Hypotheses and notation

- Positive terms only; disjoint subsets `A, B` with `sum(A) = sum(B)`, equivalently `sum(A) = P/2`.
- **Brown's criterion** (quoted): subset sums of `a_1 >= a_2 >= ... >= a_m` fill `[0, P]` exactly when `a_k <= a_{k+1} + ... + a_m` for every `k`; the last condition `a_m <= 0` fails always.
- Defects measured at seven `(N, t)` points (the values listed above).

## Proof / evidence

- Ledger row T14: "**PROOF-SKETCH** + **VERIFIED** (defect measured at 7 points, 15/15 checks)", evidence "§3.2, `verify/positive_only_split.py`".
- [`verify/positive_only_split.log`](../../research/twin-prime-parity/rounds/rh43/verify/positive_only_split.log) records 15/15 checks.

## Dependencies and related results

- The full prose statement, including the `positive_only_N20.png` pair `A={2,3,6,8,9,10,13,15,17}`, `B={1,4,5,7,11,12,14,16,18,19,20}` with sums `4.439862577` and `4.439877757` against `P/2 = 4.439870167` (gap `1.52e-5`), is [T14 (the positive-values-only two-subset problem)](tpp-rh43-truths-positive-only-two-subset-problem.md).
- Related: [T9′ / Theorem 11′](tpp-rh43-truths-term-level-split-fails.md).

## Notes

- Ledger row T14 restates §3.2. The source's caveat is essential: the completeness failure does not by itself settle the general exactness question.
