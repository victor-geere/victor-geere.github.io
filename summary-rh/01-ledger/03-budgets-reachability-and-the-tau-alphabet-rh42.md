# 3. Budgets, reachability and the Tau alphabet — `rh42`

> Source: [`research/truths.md`](../rh/research/truths.md), §3. Status language is the ledger’s own.

Lean: [`Rh42/Budget.lean`](../rh/research/twin-prime-parity/rounds/rh42/lean/Rh42/Budget.lean),
[`Reachable.lean`](../rh/research/twin-prime-parity/rounds/rh42/lean/Rh42/Reachable.lean),
[`Tau.lean`](../rh/research/twin-prime-parity/rounds/rh42/lean/Rh42/Tau.lean).
Prose ledger: [`rounds/rh42/truths.md`](../rh/research/twin-prime-parity/rounds/rh42/truths.md).

| result | statement | status | Lean proof |
|---|---|---|---|
| closed forms (T5) | `P(2)=π²/24`, `N(2)=π²/8−1`, `P(4)=π⁴/1440`, `N(4)=π⁴/96−1`, `P(2)+N(2)=π²/6−1` | PROVED (Lean) | [`positiveBudget_two`](../rh/research/twin-prime-parity/rounds/rh42/lean/Rh42/Budget.lean#L122), [`negativeBudget_two`](../rh/research/twin-prime-parity/rounds/rh42/lean/Rh42/Budget.lean#L131), [`positiveBudget_four`](../rh/research/twin-prime-parity/rounds/rh42/lean/Rh42/Budget.lean#L140), [`negativeBudget_four`](../rh/research/twin-prime-parity/rounds/rh42/lean/Rh42/Budget.lean#L149), [`budget_two_sum`](../rh/research/twin-prime-parity/rounds/rh42/lean/Rh42/Budget.lean#L158) |
| even/odd series | the `ζ(2)`, `ζ(4)` even-part summability and sums | PROVED (Lean) | [`hasSum_even_zeta_two`](../rh/research/twin-prime-parity/rounds/rh42/lean/Rh42/Budget.lean#L42), [`hasSum_even_zeta_four`](../rh/research/twin-prime-parity/rounds/rh42/lean/Rh42/Budget.lean#L55) |
| Brown's criterion (T?) | subset-sum reachability is an interval under the Brown condition | PROVED (Lean) | [`gap_lemma`](../rh/research/twin-prime-parity/rounds/rh42/lean/Rh42/Reachable.lean#L147) |
| single condition insufficient | the brief's single completeness condition is false | PROVED (Lean) | [`single_condition_not_sufficient`](../rh/research/twin-prime-parity/rounds/rh42/lean/Rh42/Reachable.lean#L171) |
| T1 sign | `Σ (−1)ⁿ/(n+2)^p` at `p = 1` equals `1 − ln 2 = +0.30685…` | PROVED (paper) + VERIFIED | [`rounds/rh42/truths.md`](../rh/research/twin-prime-parity/rounds/rh42/truths.md) §1 |
| T2/T3 budget algebra | `P+N = ζ−1`, `P−N = 1−η`, `P=(ζ−η)/2`, `N=(ζ+η−2)/2` | PROVED (paper) + VERIFIED to 1e−50 | [`rounds/rh42/truths.md`](../rh/research/twin-prime-parity/rounds/rh42/truths.md) §2 |
| T4 asymmetry | `P(p) > N(p)` for every `p > 0` | PROVED (paper) | [`rounds/rh42/truths.md`](../rh/research/twin-prime-parity/rounds/rh42/truths.md) §2 |
| census (Thm 10) | `S_1 = ⋃_A (Σ_{k∈A} a_k + [0, T_{n_min}])`, `measure(S_1) = 2^{n_min−1} T_{n_min}` | PROVED (paper) + VERIFIED | [`rounds/rh42/truths.md`](../rh/research/twin-prime-parity/rounds/rh42/truths.md) §4 |
| Tau algebra | `take_parity`, `tauStep_eq_self_of_odd/even` | PROVED (Lean) | [`Tau.lean`](../rh/research/twin-prime-parity/rounds/rh42/lean/Rh42/Tau.lean#L178) |
| parity lock | support is even for `x>0`, odd for `x<0` | PROVED (Lean) | [`support_subset_even`](../rh/research/twin-prime-parity/rounds/rh42/lean/Rh42/Tau.lean#L260), [`support_subset_odd_of_neg`](../rh/research/twin-prime-parity/rounds/rh42/lean/Rh42/Tau.lean#L274) |

Certification: `verify/` (80/80, 70/70).

---
