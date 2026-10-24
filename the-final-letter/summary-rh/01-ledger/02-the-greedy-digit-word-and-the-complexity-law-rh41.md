# 2. The greedy digit word and the complexity law — `rh41`

> Source: [`research/truths.md`](../../rh/research/truths.md), §2. Status language is the ledger’s own.

Lean: [`Rh41/DigitWord.lean`](../../rh/research/twin-prime-parity/rounds/rh41/lean/Rh41/DigitWord.lean),
[`Alphabet.lean`](../../rh/research/twin-prime-parity/rounds/rh41/lean/Rh41/Alphabet.lean),
[`GreedyResidual.lean`](../../rh/research/twin-prime-parity/rounds/rh41/lean/Rh41/GreedyResidual.lean),
[`AllZero.lean`](../../rh/research/twin-prime-parity/rounds/rh41/lean/Rh41/AllZero.lean),
[`WindowCount.lean`](../../rh/research/twin-prime-parity/rounds/rh41/lean/Rh41/WindowCount.lean),
[`Impossibility.lean`](../../rh/research/twin-prime-parity/rounds/rh41/lean/Rh41/Impossibility.lean).
Prose ledger: [`rounds/rh41/TRUTHS.md`](../../rh/research/twin-prime-parity/rounds/rh41/TRUTHS.md).

| result | statement | status | Lean proof |
|---|---|---|---|
| **Theorem 1** (complexity law) | For `L ≥ max(span, aₘ+1)`, `p(L) = min(aₘ+1, N−L+1) + [L ≤ N−aₘ−1]` | PROVED (Lean) | [`complexity_main`](../../rh/research/twin-prime-parity/rounds/rh41/lean/Rh41/DigitWord.lean#L119), [`complexity_main_TRUTHS`](../../rh/research/twin-prime-parity/rounds/rh41/lean/Rh41/DigitWord.lean#L212) |
| Cor. 2 (plateau) | `p(L) = aₘ + 2` on the plateau range | PROVED (Lean) | [`complexity_plateau`](../../rh/research/twin-prime-parity/rounds/rh41/lean/Rh41/DigitWord.lean#L226) |
| Cor. 3 (decay) | `p(L) = N−L+1` past the plateau; `p(N−1)=2`, `p(N)=1` | PROVED (Lean) | [`complexity_decay`](../../rh/research/twin-prime-parity/rounds/rh41/lean/Rh41/DigitWord.lean#L237), [`complexity_eq_two_of_pred`](../../rh/research/twin-prime-parity/rounds/rh41/lean/Rh41/DigitWord.lean#L262), [`complexity_eq_one_of_le`](../../rh/research/twin-prime-parity/rounds/rh41/lean/Rh41/DigitWord.lean#L253) |
| Cor. 4 | `N ≥ 2aₘ+2 ⟹ max_L p(L) = aₘ+2` | PROVED (Lean) | [`max_complexity`](../../rh/research/twin-prime-parity/rounds/rh41/lean/Rh41/DigitWord.lean#L331) |
| **Theorem 5** (C1 regime) | `L ≤ min(min_j d_j, a₀, N−a₀−1) ⟹ p(L) = L+1` | PROVED (Lean) | [`complexity_c1`](../../rh/research/twin-prime-parity/rounds/rh41/lean/Rh41/DigitWord.lean#L347) |
| all-zero factor | occurs iff some gap between support points (or before/after) is `≥ L+1` | PROVED (Lean) | [`allZero_iff_hasLargeGap`](../../rh/research/twin-prime-parity/rounds/rh41/lean/Rh41/AllZero.lean#L41) |
| window count | exact count of windows containing `aₘ` | PROVED (Lean) | [`card_windows_containing`](../../rh/research/twin-prime-parity/rounds/rh41/lean/Rh41/WindowCount.lean#L50) |
| **Theorem 6** (onset) | `onset` is **not** determined by `(gaps, N)` | PROVED (Lean, `native_decide`) | [`onset_not_determined_by_gaps`](../../rh/research/twin-prime-parity/rounds/rh41/lean/Rh41/DigitWord.lean#L546) |
| **Theorem 7** (maps) | `u' = q²/s − q`, `s' = 1 − {q²/s}` exactly; not the Gauss map | PROVED (Lean) | [`u_map`](../../rh/research/twin-prime-parity/rounds/rh41/lean/Rh41/GreedyResidual.lean#L585), [`induced_map`](../../rh/research/twin-prime-parity/rounds/rh41/lean/Rh41/GreedyResidual.lean#L612) |
| **Theorem 8** (rational termination) | every rational `x` terminates; `x = 1` has support `{0,1,4}` | PROVED (Lean) | [`terminates_rat`](../../rh/research/twin-prime-parity/rounds/rh41/lean/Rh41/GreedyResidual.lean#L362), [`taken_one_iff`](../../rh/research/twin-prime-parity/rounds/rh41/lean/Rh41/GreedyResidual.lean#L460) |
| squaring law | `r'/r² = (1−f)/(1+(1−f)r)`, `f = {1/r}` | PROVED (Lean) | [`squaring_law`](../../rh/research/twin-prime-parity/rounds/rh41/lean/Rh41/GreedyResidual.lean#L507) |
| no two-sided constant | no `c > 0` has `r' ≥ c·r²` for all orbits | PROVED (Lean) | [`no_positive_lower_bound`](../../rh/research/twin-prime-parity/rounds/rh41/lean/Rh41/GreedyResidual.lean#L534) |
| residual bound | `r_{k+1} ≤ r_k²` + the take rule ⟹ `n_k ≥ x^{−2^k} − 2`, hence `A(N) = O_x(log log N)` (direction **corrected** in the B.2 pass; the `Ω` lower bound is the failing side) | PROVED (paper; `residual_invariant` + `squaring_law` Lean) | [`residual_invariant`](../../rh/research/twin-prime-parity/rounds/rh41/lean/Rh41/GreedyResidual.lean#L413), [`squaring_law`](../../rh/research/twin-prime-parity/rounds/rh41/lean/Rh41/GreedyResidual.lean#L507) |
| **Theorem 9** (halting criterion) | non-increasing positive alphabet halts iff `Σ αₙ ≥ x` | PROVED (Lean) | [`partial_sums_iff`](../../rh/research/twin-prime-parity/rounds/rh41/lean/Rh41/Alphabet.lean#L284), [`taken_all_of_bounded_partial_sums`](../../rh/research/twin-prime-parity/rounds/rh41/lean/Rh41/Alphabet.lean#L213) |
| **Theorem 10** (structure) | `S > 1 ⟹` word never halts with unbounded gaps | PROVED (Lean) | [`powerAlpha_never_halts`](../../rh/research/twin-prime-parity/rounds/rh41/lean/Rh41/Alphabet.lean#L570) |
| **Theorem 11** (dichotomy false) | `αₙ = 2^{−(n+1)}` has both bounded gaps and exact termination | PROVED (Lean) | [`expAlpha_bounded_gaps_and_termination`](../../rh/research/twin-prime-parity/rounds/rh41/lean/Rh41/Alphabet.lean#L427) |
| **Theorem 12** (inverse impossibility) | no halting alphabet realises `p(L) = cL`; not Sturmian | PROVED (Lean) | [`no_linear_complexity_of_halting`](../../rh/research/twin-prime-parity/rounds/rh41/lean/Rh41/Alphabet.lean#L702), [`no_linear_growth`](../../rh/research/twin-prime-parity/rounds/rh41/lean/Rh41/Impossibility.lean#L21), [`no_sturmian_profile`](../../rh/research/twin-prime-parity/rounds/rh41/lean/Rh41/Impossibility.lean#L97) |
| bit-string agreement | offset-tuple count = bit-string factor count | PROVED (Lean) | [`complexity_eq_bitComplexity`](../../rh/research/twin-prime-parity/rounds/rh41/lean/Rh41/DigitWord.lean#L515) |
| refuted formulas | the six naive complexity formulas | REFUTED (Lean witnesses) | [`refuted_main_formula_all_L`](../../rh/research/twin-prime-parity/rounds/rh41/lean/Rh41/DigitWord.lean#L566) … [`refuted_span_formula`](../../rh/research/twin-prime-parity/rounds/rh41/lean/Rh41/DigitWord.lean#L600) |

*Open:* the matching upper bound `A(N) = O(log log N)` ([`rounds/rh41/TRUTHS.md`](../../rh/research/twin-prime-parity/rounds/rh41/TRUTHS.md) §3).

---
