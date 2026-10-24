## 9. OP-5 and OP-6 — the resolved open problems

Lean (identical developments):
[`open/lean/Op56/`](Op56) and
[`006/lean/Op56/`](Op56). Prose:
[`open/OP-05-nmin-asymptotic.md`](notes/OP-05-nmin-asymptotic.md),
[`open/OP-06-reachable-fraction.md`](notes/OP-06-reachable-fraction.md),
[`006/handoff.md`](HANDOFF-006.md).

| result | statement | status | Lean proof |
|---|---|---|---|
| **OP-5 leading coefficient forced** | `Σ_{j≥1} x^j = 1` has unique root `x = 1/2`, so the exponent rate is `log 2` | PROVED (Lean) | [`leadingCoeff_forced`](Op56#L69) |
| **OP-5 threshold, leading** | `P_n = n·log 2 + O(1)` | PROVED (Lean) | [`op5_threshold_leading`](Op56#L87) |
| **OP-5 threshold, 2nd order** | `P_n = (n+3/2)log 2 + O(1)` | PROVED (Lean) | [`op5_threshold_second_order`](Op56#L124) |
| **OP-5 threshold, full** | `P_n = (n+3/2)log 2 + c/n + O(1/n²)`, `c = 3(log 2)² − (25/12)log 2` | PROVED (Lean, axiom-clean) | [`op5_threshold_asymptotic`](Op56#L189) |
| **OP-5 index form** | `n_min(p) = p/log 2 − 3/2 + O(1)` (corrected from a false `O(1/p)`) | PROVED (Lean, axiom-clean) | [`op5_nmin_asymptotic`](Op56#L239) |
| **OP-5 exact ceiling law** (O3) | `nmin p = ⌈p/log 2 − 5/2⌉` is **FALSE**. The crossing is `n_*(p) = p/log 2 − 3/2 + F(p)` with `F(p) = −b/(n_* log 2) + O(n_*⁻²) ≈ 2.698·10⁻³/p > 0`, `b = 3(log 2)² − (25/12)log 2`; the law holds iff `1 − {y} > F(p)`, `y = p/log 2 − 3/2`. First counterexample: a **451-digit** `p` with `nmin p = ⌈p/log 2 − 5/2⌉ + 1` | **REFUTED** (independently reproduced at 1150 dps); sharpest true uniform statement is the disjunction `nmin p ∈ {⌈A⌉, ⌈A⌉+1}`, unproved | [`006/verify/op05_nmin_ceiling_false.py`](verify-006), [`006/handoff.md`](HANDOFF-006.md) §6.4 |
| OP-5 ceiling-law reduction (Lean) | `nmin p = ⌈A⌉ ↔ Φ_p(⌈A⌉) < 1 ∧ 1 ≤ Φ_p(⌈A⌉+1)`; plus `IsComplete_mono`, `nmin_le_of_IsComplete` | PROVED (Lean, axiom-clean) — reduces the (false) law to its two pointwise halves | [`PhiThird.lean`](Op56) (`nmin_eq_iff_Phi_bounds`, `nmin_eq_ceil_of_Phi_bounds`) |
| **other moduli** (O9) | with `term(p,q,r,n) = (q(n+1)+r)^{−p}` the Brown criterion depends only on `N + 1 + r/q`, so (i) **`r = 0` is exactly `q`-independent** (`nmin(p;q,0) = nmin(p;2,0)` for every `q`) and (ii) the slope is **`1/log 2`** for every `q, r`: `nmin(p;q,r) = p/log 2 − 1 − r/q + O(1)`. The recorded "leading constant becomes `1/log q`-type data" is **FALSE** | **DERIVED + VERIFIED** (60 dps, 60 cases, `q ≤ 11`) | [`open/OP-09-other-moduli.md`](notes/OP-09-other-moduli.md), [`open/op09_moduli.py`](op09_moduli.py) |
| **fourth-order expansion** (O10) | `Phi_fourth_order`: `∃ C>0, ∀ᶠ n, ∀ u∈[1/2,1], \|Φ(u n, n) − [(eᵘ−1)⁻¹ + (u/2n)ΦS u + (−(u/3)ΦK3u + (u²/8)ΦK4u)/n² + E(u)/n³]\| ≤ C/n⁴`, with `C = 11·10¹²+2·10¹²+7`, `E(u) = (u/4)ΦK4u − (u²/6)ΦK5u + (u³/48)ΦK6u` | **PROVED (Lean, axiom-clean)**, `./check.sh --all` **9/9**. Chain: `phi_term_sharp4` (former sole blocker; constant `11`, ~118× margin), `tsum_pow8_exp_neg_half_le`, `tsum_shift_pow_exp_le8` (`m ≤ 8`), `phi_tail_sum_le4`, `phi_finite_part_le4`, `PhiMainS4_eq`, `Phi_fourth_order_aux`. Moments `1082`/`9366` (`k⁸`: `1091670`), not `541`/`4683`. **Not landed:** the threshold-form fourth order (`SFourth`), new analytic content | [`PhiFourth.lean`](Op56) |
| **OP-6 reachable fraction** | `L(p) = p log p − (1 + log log 2)p + O(1)` | PROVED (Lean, axiom-clean) | [`op6_reachable_fraction`](Op56#L294) |
| **OP-6 `1/p` coefficient** (O4) | closed form but **not constant**: `c(e) = −((log 2)²/2)(e² − e + 9/4)` with `e(p) = ⌈p/log 2 − 5/2⌉ − (p/log 2 − 5/2) ∈ [0,1)`, ranging over `[−(log 2)², −(9/8)(log 2)²] = [−0.480453, −0.540510]`. The formerly quoted constant `−0.540509640658…` is the `e = 0` (smooth-index) value — **the earlier constant-coefficient statement was false** | DERIVED + VERIFIED (`3.5·10⁻¹⁴` at `p = 10¹³`) | [`op06_ceiling_coefficient.py`](op06_ceiling_coefficient.py), [`OP-06-reachable-fraction.md`](notes/OP-06-reachable-fraction.md) §2.4 |
| `Φ` asymptotic | `∃ C>0, ∀ n≥4, ∀ u∈[1/2,1], \|Φ(n) − (e^u−1)⁻¹\| ≤ C/n` | PROVED (Lean) | [`Phi_asymptotic`](Op56) |
| existence of the threshold | `IsComplete p (4p)` for `p ≥ 2` | PROVED (Lean) | `exists_isComplete` (`Exact.lean`) |
| census identity | `reachableMeasure` census and ratio | PROVED (Lean) — but see caveat | [`census_measure_eq`](Op56#L56), [`census_ratio`](Op56#L60) |
| integral test (negative result) | `tailSum_integral_lower` — proved for the corrected hypothesis **`N + 2 ≤ M`**; the as-written `N + 1 ≤ M` form is **false** (`p=2, N=0, M=1`). Too lossy to prove completeness, so it stays a negative result | **PROVED** (Lean, 0 `sorry`) | [`Exact.lean#L143`](Op56#L143) |
| supporting helper | `∫_{Ioi M} (2x)^{-p} = (2M)^{-p}·M/(p−1)` | **PROVED** (Lean) | [`integral_two_mul_rpow`](Op56#L107) |
| **floor-asymptotic meta-theorem** (O11) | if `α` is irrational then no integer sequence `n` satisfies `\|n(p) − (αp + β)\| ≤ C/p` for all large `p` — i.e. an `O(1/p)` error in an index asymptotic is impossible for an irrational linear threshold | **PROVED** (Lean, axiom-clean) | [`no_index_asymptotic_error`](Op56), [`irrational_not_eventually_error_inv`](Op56) |
| OP-5 instance of O11 | `nmin p − nminAsym p` is **not** `O(1/p)` (conditional on `Irrational (Real.log 2)`, which Mathlib lacks) | PROVED (Lean, 1 explicit hypothesis) | [`nmin_error_not_bigO_inv`](Op56) |

**Census caveat (recorded, not stale).** `census_measure_eq` holds *by construction*:
`reachableMeasure` is defined to be `2^{nmin p}·tailSum p (nmin p)`, the right-hand side of
the census law. The strictly geometric statement — that the `2^{nmin}` translates in `S_1`
are pairwise disjoint and their union is exactly the sub-sum set — is **not** formalised;
`Op56/Census.lean` states this as the remaining "census counting" gap. The arithmetic is
verified numerically to `3.9·10⁻⁶²` for thirteen exponents
(`rounds/rh42/reachable.py` §2).

Numeric cross-checks: [`open/op05_nmin.py`](op05_nmin.py),
[`open/op06_reachable_fraction.py`](op06_reachable_fraction.py),
[`006/verify/`](verify-006). Full status of the directory, including
the corrections now applied to the `open/lean` docstrings, the `O(1/p)` → `O(1)` fix and
`RESULTS.html`, is in `open.md`.
