# `research/` — harvested truths, with Lean proofs

A single ledger of what has actually been **established** across `research/`, and
where the machine-checked proof lives. Paths are relative to this file
(`research/`); proofs outside the research tree (the workspace-level `lean/`
developments) are written `../lean/…`.

> **How to read a status.** Last reviewed and re-verified in this harvest.
>
> | status | meaning |
> |---|---|
> | **PROVED (Lean)** | machine-checked; `#print axioms` = `[propext, Classical.choice, Quot.sound]` only |
> | **PROVED (Lean + native_decide)** | machine-checked, but the proof inherits a `native_decide` axiom |
> | **PROVED (paper)** | written proof; no Lean formalisation |
> | **VERIFIED** | independently recomputed by a route that does not re-run the source |
> | **CHECKED** | exhaustively verified over a stated finite class |
> | **REFUTED** | counterexample or disproof exists, with a witness |
> | **OPEN** | neither proved nor refuted |
>
> Every Lean claim below was checked by source inspection (grep for `sorry`/`axiom`)
> and, for the headline results, by an executed `#print axioms` probe. There is **no
> `axiom` declaration anywhere** in the corpus, and **no literal `sorry` remains** —
> the last one (`Op56.tailSum_integral_lower`) was discharged by repairing its
> hypothesis and proving it (see §1).

---

## 1. The state of the Lean corpus (audit)

| development | location | build | `sorry` | axiom footprint |
|---|---|---|---|---|
| `Rh45` (Routes A/B/C, explicit formula) | [`twin-prime-parity/010/lean/`](twin-prime-parity/010/lean) | `check.sh --all` **OK** (6/6: +`Archimedean`, +`RouteBAnalytic`) | 0 | clean |
| `Op56` (OP-5, OP-6) | [`twin-prime-parity/open/lean/`](twin-prime-parity/open/lean) | `check.sh --all` **9/9 OK** (+`PhiFourth`, +`FloorAsymptotic`) | **0** | **clean** |
| `Op57` (Dirichlet L generalisation) | [`twin-prime-parity/007/lean/`](twin-prime-parity/007/lean) | 5/5 OK | 0 | clean |
| `Op58` (automorphic/spectral attempt) | [`twin-prime-parity/008/lean/`](twin-prime-parity/008/lean) | OK | 0 | clean |
| `Op59` (angle parity, Ω-signs) | [`twin-prime-parity/009/lean/`](twin-prime-parity/009/lean) | OK | 0 | clean |
| `Rh41` (greedy digit word) | [`twin-prime-parity/rounds/rh41/lean/`](twin-prime-parity/rounds/rh41/lean) | OK | 0 | 8 theorems use `native_decide` |
| `Rh42` (budgets, reachability, Tau) | [`twin-prime-parity/rounds/rh42/lean/`](twin-prime-parity/rounds/rh42/lean) | OK | 0 | clean |
| `Rh43` (balance) | [`twin-prime-parity/rounds/rh43/lean/`](twin-prime-parity/rounds/rh43/lean) | OK | 0 | clean |
| `Rh044` (smoothing) | [`twin-prime-parity/rounds/rh044/lean/`](twin-prime-parity/rounds/rh044/lean) | OK | 0 | clean |
| `Rh46` (Chowla) | [`twin-prime-parity/rounds/rh46/lean/Rh46/Chowla.lean`](twin-prime-parity/rounds/rh46/lean/Rh46/Chowla.lean) | OK (530 lines, 42 theorems; **all statements now proved** — OP-11 closed) | 0 | clean |
| `Rh47` (corrected sparse bound) | [`twin-prime-parity/rounds/rh47/lean/Rh47/Sparse.lean`](twin-prime-parity/rounds/rh47/lean/Rh47/Sparse.lean) | OK (`check.sh --all`, 2/2; OP-12 closed) | 0 | clean |
| `VonMangoldtSieves` | [`publish/001-von-mangoldt-sieves/VonMangoldtSieves.lean`](publish/001-von-mangoldt-sieves/VonMangoldtSieves.lean) | OK | 0 | clean |
| `ConeLean` (cone, parity obstruction) | [`../lean/ConeLean/`](../lean/ConeLean) | OK (11 modules) | 0 | clean |
| `TppLean` (three thresholds) | [`../lean/TppLean/`](../lean/TppLean) | OK | 0 | clean |

**Recorded caveats.**

1. ~~**`Op56.tailSum_integral_lower`** … a genuine `sorry`~~ — **now PROVED.** The
   lemma was **false** as written (`N + 1 ≤ M`; witness `p = 2`, `N = 0`, `M = 1`:
   LHS `0.25` vs `tailSum 2 1 = 0.16123…`). It is now a theorem under the corrected
   hypothesis **`N + 2 ≤ M`**, with the supporting helper `integral_two_mul_rpow`
   (`∫_{Ioi M} (2x)^{-p} = (2M)^{-p}·M/(p−1)`), and `#print axioms` is
   `[propext, Classical.choice, Quot.sound]`. It remains a documented, unused
   negative result (the antitone integral test is too lossy to prove completeness).
   The corpus is now **`sorry`-free**.
2. ~~**`native_decide` footprint** in `Op56`~~ — **removed (TODO item O2).** The
   `interval_cases j <;> native_decide` steps in `Op56.tsum_pow6_exp_neg_half_le` were
   replaced by `interval_cases j <;> norm_num [Nat.stirlingSecond]` /
   `[Nat.factorial]`, so **every probed `Op56` theorem now reports `#print axioms` =
   `[propext, Classical.choice, Quot.sound]`**, with no `native_decide` token anywhere in
   the development. The only remaining `native_decide` use in the whole corpus is the
   unrelated one in [`Rh41/DigitWord.lean`](twin-prime-parity/rounds/rh41/lean/Rh41/DigitWord.lean)
   (eight theorems: `onset_not_determined_by_gaps`, the six `refuted_*` witnesses,
   `plateau_empty_example`, `c1_bound_gap_necessary`).

---

## 2. The greedy digit word and the complexity law — `rh41`

Lean: [`Rh41/DigitWord.lean`](twin-prime-parity/rounds/rh41/lean/Rh41/DigitWord.lean),
[`Alphabet.lean`](twin-prime-parity/rounds/rh41/lean/Rh41/Alphabet.lean),
[`GreedyResidual.lean`](twin-prime-parity/rounds/rh41/lean/Rh41/GreedyResidual.lean),
[`AllZero.lean`](twin-prime-parity/rounds/rh41/lean/Rh41/AllZero.lean),
[`WindowCount.lean`](twin-prime-parity/rounds/rh41/lean/Rh41/WindowCount.lean),
[`Impossibility.lean`](twin-prime-parity/rounds/rh41/lean/Rh41/Impossibility.lean).
Prose ledger: [`rounds/rh41/TRUTHS.md`](twin-prime-parity/rounds/rh41/TRUTHS.md).

| result | statement | status | Lean proof |
|---|---|---|---|
| **Theorem 1** (complexity law) | For `L ≥ max(span, aₘ+1)`, `p(L) = min(aₘ+1, N−L+1) + [L ≤ N−aₘ−1]` | PROVED (Lean) | [`complexity_main`](twin-prime-parity/rounds/rh41/lean/Rh41/DigitWord.lean#L119), [`complexity_main_TRUTHS`](twin-prime-parity/rounds/rh41/lean/Rh41/DigitWord.lean#L212) |
| Cor. 2 (plateau) | `p(L) = aₘ + 2` on the plateau range | PROVED (Lean) | [`complexity_plateau`](twin-prime-parity/rounds/rh41/lean/Rh41/DigitWord.lean#L226) |
| Cor. 3 (decay) | `p(L) = N−L+1` past the plateau; `p(N−1)=2`, `p(N)=1` | PROVED (Lean) | [`complexity_decay`](twin-prime-parity/rounds/rh41/lean/Rh41/DigitWord.lean#L237), [`complexity_eq_two_of_pred`](twin-prime-parity/rounds/rh41/lean/Rh41/DigitWord.lean#L262), [`complexity_eq_one_of_le`](twin-prime-parity/rounds/rh41/lean/Rh41/DigitWord.lean#L253) |
| Cor. 4 | `N ≥ 2aₘ+2 ⟹ max_L p(L) = aₘ+2` | PROVED (Lean) | [`max_complexity`](twin-prime-parity/rounds/rh41/lean/Rh41/DigitWord.lean#L331) |
| **Theorem 5** (C1 regime) | `L ≤ min(min_j d_j, a₀, N−a₀−1) ⟹ p(L) = L+1` | PROVED (Lean) | [`complexity_c1`](twin-prime-parity/rounds/rh41/lean/Rh41/DigitWord.lean#L347) |
| all-zero factor | occurs iff some gap between support points (or before/after) is `≥ L+1` | PROVED (Lean) | [`allZero_iff_hasLargeGap`](twin-prime-parity/rounds/rh41/lean/Rh41/AllZero.lean#L41) |
| window count | exact count of windows containing `aₘ` | PROVED (Lean) | [`card_windows_containing`](twin-prime-parity/rounds/rh41/lean/Rh41/WindowCount.lean#L50) |
| **Theorem 6** (onset) | `onset` is **not** determined by `(gaps, N)` | PROVED (Lean, `native_decide`) | [`onset_not_determined_by_gaps`](twin-prime-parity/rounds/rh41/lean/Rh41/DigitWord.lean#L546) |
| **Theorem 7** (maps) | `u' = q²/s − q`, `s' = 1 − {q²/s}` exactly; not the Gauss map | PROVED (Lean) | [`u_map`](twin-prime-parity/rounds/rh41/lean/Rh41/GreedyResidual.lean#L585), [`induced_map`](twin-prime-parity/rounds/rh41/lean/Rh41/GreedyResidual.lean#L612) |
| **Theorem 8** (rational termination) | every rational `x` terminates; `x = 1` has support `{0,1,4}` | PROVED (Lean) | [`terminates_rat`](twin-prime-parity/rounds/rh41/lean/Rh41/GreedyResidual.lean#L362), [`taken_one_iff`](twin-prime-parity/rounds/rh41/lean/Rh41/GreedyResidual.lean#L460) |
| squaring law | `r'/r² = (1−f)/(1+(1−f)r)`, `f = {1/r}` | PROVED (Lean) | [`squaring_law`](twin-prime-parity/rounds/rh41/lean/Rh41/GreedyResidual.lean#L507) |
| no two-sided constant | no `c > 0` has `r' ≥ c·r²` for all orbits | PROVED (Lean) | [`no_positive_lower_bound`](twin-prime-parity/rounds/rh41/lean/Rh41/GreedyResidual.lean#L534) |
| residual bound | `r_{k+1} ≤ r_k²` + the take rule ⟹ `n_k ≥ x^{−2^k} − 2`, hence `A(N) = O_x(log log N)` (direction **corrected** in the B.2 pass; the `Ω` lower bound is the failing side) | PROVED (paper; `residual_invariant` + `squaring_law` Lean) | [`residual_invariant`](twin-prime-parity/rounds/rh41/lean/Rh41/GreedyResidual.lean#L413), [`squaring_law`](twin-prime-parity/rounds/rh41/lean/Rh41/GreedyResidual.lean#L507) |
| **Theorem 9** (halting criterion) | non-increasing positive alphabet halts iff `Σ αₙ ≥ x` | PROVED (Lean) | [`partial_sums_iff`](twin-prime-parity/rounds/rh41/lean/Rh41/Alphabet.lean#L284), [`taken_all_of_bounded_partial_sums`](twin-prime-parity/rounds/rh41/lean/Rh41/Alphabet.lean#L213) |
| **Theorem 10** (structure) | `S > 1 ⟹` word never halts with unbounded gaps | PROVED (Lean) | [`powerAlpha_never_halts`](twin-prime-parity/rounds/rh41/lean/Rh41/Alphabet.lean#L570) |
| **Theorem 11** (dichotomy false) | `αₙ = 2^{−(n+1)}` has both bounded gaps and exact termination | PROVED (Lean) | [`expAlpha_bounded_gaps_and_termination`](twin-prime-parity/rounds/rh41/lean/Rh41/Alphabet.lean#L427) |
| **Theorem 12** (inverse impossibility) | no halting alphabet realises `p(L) = cL`; not Sturmian | PROVED (Lean) | [`no_linear_complexity_of_halting`](twin-prime-parity/rounds/rh41/lean/Rh41/Alphabet.lean#L702), [`no_linear_growth`](twin-prime-parity/rounds/rh41/lean/Rh41/Impossibility.lean#L21), [`no_sturmian_profile`](twin-prime-parity/rounds/rh41/lean/Rh41/Impossibility.lean#L97) |
| bit-string agreement | offset-tuple count = bit-string factor count | PROVED (Lean) | [`complexity_eq_bitComplexity`](twin-prime-parity/rounds/rh41/lean/Rh41/DigitWord.lean#L515) |
| refuted formulas | the six naive complexity formulas | REFUTED (Lean witnesses) | [`refuted_main_formula_all_L`](twin-prime-parity/rounds/rh41/lean/Rh41/DigitWord.lean#L566) … [`refuted_span_formula`](twin-prime-parity/rounds/rh41/lean/Rh41/DigitWord.lean#L600) |

*Open:* the matching upper bound `A(N) = O(log log N)` ([`rounds/rh41/TRUTHS.md`](twin-prime-parity/rounds/rh41/TRUTHS.md) §3).

---

## 3. Budgets, reachability and the Tau alphabet — `rh42`

Lean: [`Rh42/Budget.lean`](twin-prime-parity/rounds/rh42/lean/Rh42/Budget.lean),
[`Reachable.lean`](twin-prime-parity/rounds/rh42/lean/Rh42/Reachable.lean),
[`Tau.lean`](twin-prime-parity/rounds/rh42/lean/Rh42/Tau.lean).
Prose ledger: [`rounds/rh42/truths.md`](twin-prime-parity/rounds/rh42/truths.md).

| result | statement | status | Lean proof |
|---|---|---|---|
| closed forms (T5) | `P(2)=π²/24`, `N(2)=π²/8−1`, `P(4)=π⁴/1440`, `N(4)=π⁴/96−1`, `P(2)+N(2)=π²/6−1` | PROVED (Lean) | [`positiveBudget_two`](twin-prime-parity/rounds/rh42/lean/Rh42/Budget.lean#L122), [`negativeBudget_two`](twin-prime-parity/rounds/rh42/lean/Rh42/Budget.lean#L131), [`positiveBudget_four`](twin-prime-parity/rounds/rh42/lean/Rh42/Budget.lean#L140), [`negativeBudget_four`](twin-prime-parity/rounds/rh42/lean/Rh42/Budget.lean#L149), [`budget_two_sum`](twin-prime-parity/rounds/rh42/lean/Rh42/Budget.lean#L158) |
| even/odd series | the `ζ(2)`, `ζ(4)` even-part summability and sums | PROVED (Lean) | [`hasSum_even_zeta_two`](twin-prime-parity/rounds/rh42/lean/Rh42/Budget.lean#L42), [`hasSum_even_zeta_four`](twin-prime-parity/rounds/rh42/lean/Rh42/Budget.lean#L55) |
| Brown's criterion (T?) | subset-sum reachability is an interval under the Brown condition | PROVED (Lean) | [`gap_lemma`](twin-prime-parity/rounds/rh42/lean/Rh42/Reachable.lean#L147) |
| single condition insufficient | the brief's single completeness condition is false | PROVED (Lean) | [`single_condition_not_sufficient`](twin-prime-parity/rounds/rh42/lean/Rh42/Reachable.lean#L171) |
| T1 sign | `Σ (−1)ⁿ/(n+2)^p` at `p = 1` equals `1 − ln 2 = +0.30685…` | PROVED (paper) + VERIFIED | [`rounds/rh42/truths.md`](twin-prime-parity/rounds/rh42/truths.md) §1 |
| T2/T3 budget algebra | `P+N = ζ−1`, `P−N = 1−η`, `P=(ζ−η)/2`, `N=(ζ+η−2)/2` | PROVED (paper) + VERIFIED to 1e−50 | [`rounds/rh42/truths.md`](twin-prime-parity/rounds/rh42/truths.md) §2 |
| T4 asymmetry | `P(p) > N(p)` for every `p > 0` | PROVED (paper) | [`rounds/rh42/truths.md`](twin-prime-parity/rounds/rh42/truths.md) §2 |
| census (Thm 10) | `S_1 = ⋃_A (Σ_{k∈A} a_k + [0, T_{n_min}])`, `measure(S_1) = 2^{n_min−1} T_{n_min}` | PROVED (paper) + VERIFIED | [`rounds/rh42/truths.md`](twin-prime-parity/rounds/rh42/truths.md) §4 |
| Tau algebra | `take_parity`, `tauStep_eq_self_of_odd/even` | PROVED (Lean) | [`Tau.lean`](twin-prime-parity/rounds/rh42/lean/Rh42/Tau.lean#L178) |
| parity lock | support is even for `x>0`, odd for `x<0` | PROVED (Lean) | [`support_subset_even`](twin-prime-parity/rounds/rh42/lean/Rh42/Tau.lean#L260), [`support_subset_odd_of_neg`](twin-prime-parity/rounds/rh42/lean/Rh42/Tau.lean#L274) |

Certification: `verify/` (80/80, 70/70).

---

## 4. Partial sums at `Re S = 0` and the equal split — `rh43`

Lean: [`Rh43/Balance.lean`](twin-prime-parity/rounds/rh43/lean/Rh43/Balance.lean)
(37 theorems). Prose ledger: [`rounds/rh43/truths.md`](twin-prime-parity/rounds/rh43/truths.md).

| result | statement | status | Lean proof |
|---|---|---|---|
| balance ⟺ zero | `balanced N t ↔ Re S_N(t) = 0` | PROVED (Lean) | [`balanced_iff_realPartial_eq_zero`](twin-prime-parity/rounds/rh43/lean/Rh43/Balance.lean#L187) |
| equal split | `balanced ↔` equal four-part split of the two halves | PROVED (Lean) | [`balanced_iff_equal_split`](twin-prime-parity/rounds/rh43/lean/Rh43/Balance.lean#L230) |
| existence `N = 3` | `Re S_3(5/2) < 0 < Re S_3(0)`, so a root exists | PROVED (Lean) | [`exists_realPartial_three_eq_zero`](twin-prime-parity/rounds/rh43/lean/Rh43/Balance.lean#L350), [`realPartial_three_five_halves_neg`](twin-prime-parity/rounds/rh43/lean/Rh43/Balance.lean#L330) |
| existence, general | a balanced `(N,t)` exists | PROVED (Lean) | [`exists_balanced_partial_sum`](twin-prime-parity/rounds/rh43/lean/Rh43/Balance.lean#L359) |
| `N = 2` exact | `Re S_2(π/log 2) = 0` | PROVED (Lean) | [`balanced_two`](twin-prime-parity/rounds/rh43/lean/Rh43/Balance.lean#L392) |
| `N = 3` no complex zero | `S_3(t) ≠ 0` for all `t` | PROVED (Lean) | [`zetaPartial_three_ne_zero`](twin-prime-parity/rounds/rh43/lean/Rh43/Balance.lean#L489) |
| not-all-nonzero | `¬ ∀ N t, S_N(t) ≠ 0` | PROVED (Lean) | [`not_forall_zetaPartial_ne_zero`](twin-prime-parity/rounds/rh43/lean/Rh43/Balance.lean#L458) |

Certification: 64/64, audit 102/102; roots certified for `N = 3…50` (auditor C3).

---

## 5. The smoothing bridge — `rh044`

Lean: [`Rh044/Smoothing.lean`](twin-prime-parity/rounds/rh044/lean/Rh044/Smoothing.lean)
(32 theorems). Prose: [`rounds/rh044/README.md`](twin-prime-parity/rounds/rh044/README.md).

| result | statement | status | evidence |
|---|---|---|---|
| weight defect identity | `zetaSum N s − smoothedSum N φ s = Σ (1−φ(n/N))·zetaTerm s n` | PROVED (Lean) | [`weighted_decomposition`](twin-prime-parity/rounds/rh044/lean/Rh044/Smoothing.lean#L121) |
| triangle-inequality bound | `‖zetaSum − smoothedSum‖ ≤ Σ ‖1−φ(n/N)‖·‖zetaTerm s n‖` | PROVED (Lean) | [`norm_smoothedSum_sub_zetaSum_le`](twin-prime-parity/rounds/rh044/lean/Rh044/Smoothing.lean#L204) |
| radial decay | `‖zetaTerm (σ+tI) n‖ = n^{−σ}` | PROVED (Lean) | [`abs_zetaTerm`](twin-prime-parity/rounds/rh044/lean/Rh044/Smoothing.lean#L215) |
| summability comparison | `σ > 1` comparison for the defect sum | PROVED (Lean) | [`summable_norm_zetaTerm`](twin-prime-parity/rounds/rh044/lean/Rh044/Smoothing.lean#L249) |
| quad-weight identities | `quadWeight` closed forms and defect identities | PROVED (Lean) | [`quadWeight_defect_eq`](twin-prime-parity/rounds/rh044/lean/Rh044/Smoothing.lean#L336), [`zetaSum_sub_smoothedSum_quadWeight`](twin-prime-parity/rounds/rh044/lean/Rh044/Smoothing.lean#L365) |
| **main result** | `\|S_N^φ(1/2+it) − ζ(1/2+it)\| / √N → \|M_φ(s)\|`, `M_φ(s)=∫₀¹φ(u)u^{−s}du` | PROVED (paper) + VERIFIED to 5–7 digits | [`rounds/rh044/README.md`](twin-prime-parity/rounds/rh044/README.md) §2 |
| refuted | "smoothing removes the `√N`" is **false**; the earlier `1/√(2t)` constant is wrong | REFUTED | `README.md` §2 |

---

## 6. The explicit formula and Routes A/B/C — `rh45` / `010`

Prose: [`010/README.md`](twin-prime-parity/010/README.md),
[`010/truths.md`](twin-prime-parity/010/truths.md),
[`010/notes/routes-a-b-c-status.md`](twin-prime-parity/010/notes/routes-a-b-c-status.md).
Lean: [`010/lean/Rh45/Routes.lean`](twin-prime-parity/010/lean/Rh45/Routes.lean),
[`Explicit.lean`](twin-prime-parity/010/lean/Rh45/Explicit.lean),
[`VonMangoldtSieve.lean`](twin-prime-parity/010/lean/Rh45/VonMangoldtSieve.lean).

| result | statement | status | Lean proof |
|---|---|---|---|
| **Route A** (uniqueness + simplicity) | `f` continuous, `f′ > 0` on `(a,b)`, `f a < 0 < f b` ⟹ unique simple root | PROVED (Lean) | [`exists_unique_root_of_sign_change`](twin-prime-parity/010/lean/Rh45/Routes.lean#L37) |
| Route A, decreasing case | mirror with `f′ < 0` | PROVED (Lean) | [`exists_unique_root_of_sign_change_neg`](twin-prime-parity/010/lean/Rh45/Routes.lean#L129) |
| Route A, enclosure form | enclosure hypotheses discharge the above | PROVED (Lean) | [`certified_root_of_enclosures`](twin-prime-parity/010/lean/Rh45/Routes.lean#L71) |
| **Route B** (Turing reduction) | `certified ⊆ zeros`, `zeros.card ≤ certified.card` ⟹ `zeros = certified` | PROVED (Lean) | [`turing_reduction`](twin-prime-parity/010/lean/Rh45/Routes.lean#L95) |
| Route B, packaged | every zero in the window is certified | PROVED (Lean) | [`all_zeros_are_certified`](twin-prime-parity/010/lean/Rh45/Routes.lean#L162) |
| **Route C** (error assembly) | residual bounded by the sum of the three tails | PROVED (Lean) | [`validated_truncation_bound`](twin-prime-parity/010/lean/Rh45/Routes.lean#L106) |
| Route C, prime input | Chebyshev `ψ(x) ≤ (log 4 + 4)x` | PROVED (Lean, Mathlib) | [`prime_tail_input`](twin-prime-parity/010/lean/Rh45/Routes.lean#L123) |
| explicit formula (algebraic layer) | evenness/positivity of kernels, `s ↔ 1−s` symmetry, pole-pair collapse `polePair = 2F(1/2)`, prime-side even splitting, smoothed count, main term `(T/2π)log(T/2πe)+7/8`, Fourier pairing | PROVED (Lean) | [`Explicit.lean`](twin-prime-parity/010/lean/Rh45/Explicit.lean#L223) |
| von Mangoldt sieve bug | `Λ 6 = 0`; `Λ` is not additive (witness `6 = 2·3`) | PROVED (Lean) | [`vonMangoldt_six`](twin-prime-parity/010/lean/Rh45/VonMangoldtSieve.lean#L6), [`vonMangoldt_not_additive`](twin-prime-parity/010/lean/Rh45/VonMangoldtSieve.lean#L16) |
| **numerical certificate** | `γ₁…γ₅` unique, simple, on the critical line | **CERTIFIED** 5/5 | [`rigorous/certify_unique.log`](publish/006-explicit-formula-routes-abc/rigorous/certify_unique.log) |
| **numerical certificate** | `N(3) = 0`, `N(15) = 1` on the symmetric contour | **CERTIFIED** | [`rigorous/certify_count15d.log`](publish/006-explicit-formula-routes-abc/rigorous/certify_count15d.log) |
| **Turing window, `T = 15`** | every zero with `½ < Im < 15` is simple and on the critical line | **CERTIFIED — UNCONDITIONAL** (item T1: `Lf_const=None`, no cited `\|ζ′/ζ\|` input; `N(15) ∈ [0.7981608, 1.2018097]`) | [`rigorous/certify_count15_uncond.log`](publish/006-explicit-formula-routes-abc/rigorous/certify_count15_uncond.log) + `all_zeros_are_certified` |
| **Turing window, `T = 33`** | every zero with `½ < Im < 33` is simple and on the critical line | **CERTIFIED — UNCONDITIONAL** (item T2: `K = 100`, `steps/unit = 40`; `N(33) ∈ [4.711, 5.2890345]`, half-width `0.289 < 0.5`). Needs the `K ≳ 0.25·t` Euler-acceleration requirement and the parallel certificate | [`rigorous/certify_count33_par.log`](publish/006-explicit-formula-routes-abc/rigorous/certify_count33_par.log) + `all_zeros_are_certified` |
| **Route C assembly** | residual `−9.08·10⁻⁹ ≤ 2.79·10⁻⁸` on the modulated Gaussian (archimedean bound tightened to `1.6·10⁻⁸` by `STEPS 1500→12000`) | **VALIDATED** | [`rigorous/route_c_assembly.log`](publish/006-explicit-formula-routes-abc/rigorous/route_c_assembly.log) |
| **engine re-validation** | `check_engine.py` at `K = 60`, two independent runs | **VERIFIED** (`0 fail(s)` both) | [`rigorous/verify_engine.log`](publish/006-explicit-formula-routes-abc/rigorous/verify_engine.log), [`rigorous/recheck_engine.log`](publish/006-explicit-formula-routes-abc/rigorous/recheck_engine.log) |
| **certified fast mode** | `eta_interval.fast_mode()`: `work = 60`, `EPS = 1e-40`; moves `WORK`, the rounding slack `EPS` and mpmath precision **together** so the enclosure contract `EPS ≥ accumulated rounding` holds (setting `iv.WORK = 60` alone does **not**) | PROVED (contract) + VERIFIED (`0 fail(s)`) | [`rigorous/check_fast_mode.py`](publish/006-explicit-formula-routes-abc/rigorous/check_fast_mode.py), [`log`](publish/006-explicit-formula-routes-abc/rigorous/check_fast_mode.log) |
| auditor criteria `C4.1`, `C1e` | `C4.1`: the sharp partial sum cannot resolve `γ₁` at `N ≤ 10⁶` — an over-strong criterion. `C1e`: the literal Cauchy kernel `F(t)=1/(1/4+t²)` is unsatisfiable (off by `2/π`; pole and prime sides diverge like `π log N`; zero side only `log G/G`) | **both RETIRED by disposition**; `C1e` restated as the convergent companion `C1f` (`a=1`, ~2-digit). Audit adjudication: *19/21 checks pass; 2 retired; failures: none* | [`010/verify/DISPOSITIONS.md`](twin-prime-parity/010/verify/DISPOSITIONS.md) |
| corrected Weil form | the audited identity, verified to ≥ 20 digits on four kernels | PROVED (paper) + VERIFIED | [`010/truths.md`](twin-prime-parity/010/truths.md) §1 |
| **archimedean term** (T7) | `Ψ(t) = −log π + Re ψ(1/4+it/2)`: continuity/measurability, recurrence/reflection on the digamma line, the chain rule `Ψ^{(k)} = (i/2)^k ψ^{(k)}` yielding the `2^{−k}` budget, the Leibniz product bound, and the composite-Simpson assembly `(b−a)h⁴/180·Σ_k binom(4,k) M_k P_{4−k}` | **PROVED** (Lean, 0 `sorry`/`axiom`), with 2 named hypotheses for Mathlib gaps (digamma series estimate; single-panel Simpson error). **Finding:** the paper's `k = 0` digamma bound is vacuous (`Σ 1/(1/4+j)` diverges) | [`Rh45/Archimedean.lean`](twin-prime-parity/010/lean/Rh45/Archimedean.lean) |
| archimedean bound (T3) | Simpson steps `1500 → 12000` (error `∝ STEPS⁻⁴`): archimedean bound `6.5·10⁻⁵ → 1.6·10⁻⁸`, total budget `6.499·10⁻⁵ → 2.794·10⁻⁸` | **VALIDATED** | [`rigorous/route_c_assembly.log`](publish/006-explicit-formula-routes-abc/rigorous/route_c_assembly.log) |
| **Route B analytic layer** (T8) | `ξ(1−s) = ξ(s)` (`xi_one_sub`, from Mathlib's `completedRiemannZeta_one_sub`); `logDeriv_one_sub`, `logDeriv_conj`, `logDeriv_one_sub_conj`, `xi_logDeriv_symmetry`; the contour reduction `rectBoundary_eq_rightPath_sub_conj`: `∮_{∂R} g = I₃ − conj I₃ = 2i·Im I₃` from the single symmetry `g(1−conj s) = −conj(g s)`; and `routeB_reduction` / `routeB_reduction_of_functional_equation`: `Im(I₃) = πZ` from the argument-principle count `∮ = 2πiZ` | **PROVED** (Lean, 6/6, axiom-clean). **Mathlib gaps as explicit hypotheses:** the rectangle argument principle (`∮ f′/f = 2πi·#zeros`; Mathlib has only Cauchy–Goursat, no winding number) and `ξ(conj s) = conj(ξ s)`; Mathlib has **no** `riemannXi` | [`Rh45/RouteBAnalytic.lean`](twin-prime-parity/010/lean/Rh45/RouteBAnalytic.lean) |
| counting formula | `N(T) = θ(T)/π + 1 + S(T)`, verified to 1e−20 | PROVED (paper) + VERIFIED | [`010/truths.md`](twin-prime-parity/010/truths.md) §4 |
| zeros to 32–33 digits | `γ₁…γ₅` located from `ζ` alone | VERIFIED | [`010/truths.md`](twin-prime-parity/010/truths.md) §5 |
| **admissible kernel** (T6) | the compactly supported even `g(u) = C(1−u²/144)⁴⁰cos(γ₁u)` on `[−12,12]` has `\|LHS\| = 2.0000000000`, `RHS−LHS = −7.24·10⁻⁵⁴` at `K = 100`, zero-tail `4.95·10⁻⁷⁷`. The literal negative claim ("`O(1)` LHS forces tail `≥ c/log G`") is **FALSE**; the correct law is `g ∈ C^m` ⟹ `φ = O(t^{−(m+1)})`, tail `O((log G)G^{−m})`, needing `m ≥ 1` | **FOUND + REFUTED** (high-precision numerical, not interval-certified) | [`rigorous/KERNEL_FINDINGS.md`](publish/006-explicit-formula-routes-abc/rigorous/KERNEL_FINDINGS.md), [`rigorous/kernel_probe.log`](publish/006-explicit-formula-routes-abc/rigorous/kernel_probe.log) |
| **unconditional `T=15` count** (T1) | **CERTIFIED, unconditional** — `N(15) ∈ [0.7981608, 1.2018097]`, i.e. `N(15) = 1`, with `Lf_const=None` (no cited `\|ζ′/ζ\|` bound anywhere); 9571 s at `steps/unit = 24`. Hence *every zero with `½ < Im < 15` is simple and on the critical line*. Two engine obstructions removed: the removable singularity of `ζ = η/(1−2^{1−s})` (routed to the rigorous local Taylor/Cauchy enclosure `zeta_local_box` for boxes within `7/10` of any `t_k`, including `t_0 = 0`), and the loose curvature bound (`Σ Lf` fell `74776 → 2282.1`, giving `err = 0.495`). Supersedes the `Lf_const = 30` certificate, which is retained for comparison | **DONE** | [`rigorous/certify_count15_uncond.log`](publish/006-explicit-formula-routes-abc/rigorous/certify_count15_uncond.log) |

**Not claimed:** anything about RH; only the finite window and five individual zeros.
The `T = 15` count is **unconditional** (item `T1`, certified 2026-10-11): the cited
`|ζ′/ζ| ≤ A log(t+2)` bound is **not** used —
`N(15) ∈ [0.7981608, 1.2018097]` from
[`certify_count15_uncond.py`](publish/006-explicit-formula-routes-abc/rigorous/certify_count15_uncond.py)
with `Lf_const = None`.

---

## 7. Two-point Chowla and the finite-prefix theorem — `rh46`

Lean: [`Rh46/Chowla.lean`](twin-prime-parity/rounds/rh46/lean/Rh46/Chowla.lean)
(530 lines, **42 theorems**; since the OP-11 closure it contains **no statement recorded
without proof**). Prose:
[`rounds/rh46/README.md`](twin-prime-parity/rounds/rh46/README.md).

| result | statement | status | Lean proof |
|---|---|---|---|
| trivial bound | `\|S(x,h)\| ≤ x` for every `h,x` | PROVED (Lean) | [`corr_abs_le`](twin-prime-parity/rounds/rh46/lean/Rh46/Chowla.lean#L210) |
| sharpness | `S(x,0) = x`; so `o(x)` is not formal | PROVED (Lean) | [`corr_zero`](twin-prime-parity/rounds/rh46/lean/Rh46/Chowla.lean#L227), [`corrAsymptotic_zero_false`](twin-prime-parity/rounds/rh46/lean/Rh46/Chowla.lean#L239) |
| **finite-prefix indeterminacy** | a modifiable `λ''` agreeing with `λ` on `[1,a)` with `S''(x)/x → 1` | PROVED (Lean) | [`corrSlice_eq_corr_of_lt`](twin-prime-parity/rounds/rh46/lean/Rh46/Chowla.lean#L381), [`exists_corrSlice_ne_corr`](twin-prime-parity/rounds/rh46/lean/Rh46/Chowla.lean), [`slice_agree`](twin-prime-parity/rounds/rh46/lean/Rh46/Chowla.lean#L332) |
| ℓ²-mass of perturbation | exactly `4` | PROVED (Lean) | [`corrSliceSqSub`](twin-prime-parity/rounds/rh46/lean/Rh46/Chowla.lean#L392) |
| shifted product not multiplicative | `shiftProd` is not completely multiplicative | PROVED (Lean) | [`shiftProd_not_completely_multiplicative`](twin-prime-parity/rounds/rh46/lean/Rh46/Chowla.lean#L298) |
| elementary λ facts | multiplicativity, `λ(n) ∈ {±1}`, `λ²=1`, `λ(mn)` on nonzero | PROVED (Lean) | [`liouville_mul`](twin-prime-parity/rounds/rh46/lean/Rh46/Chowla.lean#L162), [`liouville_mem`](twin-prime-parity/rounds/rh46/lean/Rh46/Chowla.lean#L174) |
| **two-point Chowla `Σ λ(n)λ(n+2) = o(x)`** | — | **OPEN** (2026 reassessment: still out of reach; every 2020–2026 advance is log-averaged / shift-averaged / conditional) | [`rounds/rh46/README.md`](twin-prime-parity/rounds/rh46/README.md), [`open/OP-01-04-16-17-18-tractability.md`](twin-prime-parity/open/OP-01-04-16-17-18-tractability.md) |
| `corrSlice_sub_corr_self_eq` | `corrSlice h a a − corr h a = −2λ(a)λ(a+h) − 2λ(a−h)λ(a)` for `0 < h < a` | **PROVED (Lean, OP-11)** | [`corrSlice_sub_corr_self_eq`](twin-prime-parity/rounds/rh46/lean/Rh46/Chowla.lean), helper `slice_term_sub` |

**Certified scratch caveat.** The `rh46/lean/` directory also contains unrelated
`Check*.lean`, `Test*.lean`, `Scratch*.lean` files; a few of those contain anonymous
`example`s with `sorry` (Check10/14/24, Test12/18/25, Scratch2). **None is imported by
`Rh46.lean`** — the deliverable is `Rh46/Chowla.lean`.

---

## 8. Greedy sine vs the parity barrier — `rh47`

Prose ledger: [`rounds/rh47/truths.md`](twin-prime-parity/rounds/rh47/truths.md).
The round's Lean layer is no longer empty: [`Rh47/Sparse.lean`](twin-prime-parity/rounds/rh47/lean/Rh47/Sparse.lean)
proves the corrected sparse bound, its sharpness witness and the falsity of the
inherited `2·#{n ≤ x+2 : n ∈ A}` form (item OP-12), in the `rh47/lean` layer
(`check.sh --all` 2/2, exit 0, axiom-clean).

| result | statement | status |
|---|---|---|
| **Sylvester-sparsity theorem** | for the support `A = {m₁<m₂<…}` of the greedy word, `m_{i+1} ≥ m_i(m_i−1)+1` | PROVED (paper) + VERIFIED (53 159 pairs, 0 violations) |
| support density | `≈ 3.9·10⁻⁵` (sizes `2.95 → 3.90` as `N = 10² → 10⁵`) | VERIFIED |
| `\|A\| ≥ 20` empty domain | none of 19 900 rational targets with denominator ≤ 200 has `\|A\| ≥ 20` | CHECKED |
| **B1** (support carries `λ`-parity) | nominal `z = −47.9` killed by controls: `z = +0.43`, `+1.55` | **REFUTED** |
| **B2** (budgets carry `Ω`-parity) | index parity invisible to the correlation: twist identity exact | **REFUTED** |
| **B3** (ζ-machinery applies) | `f(n)=λ(n)λ(n+2)` not multiplicative; `\|D(2) − model\| = 2.0144 > 1.84·10⁻⁵` | **REFUTED** |
| correct sparse bound | `\|S_A−S\| ≤ 2·#{n≤x: n∈A ∨ n+2∈A} ≤ 4·#{m≤x+2: m∈A}` | **PROVED (Lean, OP-12)**; rh46's `2·#{…}` is **REFUTED** (`A={5}`, `x=5`, `\|ΔS\|=4`) |
| R2 (barrier as a theorem) | no sign-blind `log n`-rule forces a multiplicative correlation | **OPEN — not well-posed as inherited; repaired into OP-19 (still open)** |
| R4 (Lean barrier formalisation) | — | **PARTIAL — `Rh47/Sparse.lean` done (OP-12); Brown/parity-lock port and R2 open** |
| **OP-16 / OP-17 / OP-18** | twin primes / Sarnak / sign-blind coupling | **out of reach** (2026 reassessment); **OP-18 is ⚠️ not well-posed as phrased** — its well-posed restriction is the existential dual of OP-19. See [`open/OP-01-04-16-17-18-tractability.md`](twin-prime-parity/open/OP-01-04-16-17-18-tractability.md) |

The programme's verdict: the goal is **not reachable by this programme as it
stands** ([`rounds/rh47/truths.md`](twin-prime-parity/rounds/rh47/truths.md)).

---

## 9. OP-5 and OP-6 — the resolved open problems

Lean (identical developments):
[`open/lean/Op56/`](twin-prime-parity/open/lean/Op56) and
[`006/lean/Op56/`](twin-prime-parity/006/lean/Op56). Prose:
[`open/OP-05-nmin-asymptotic.md`](twin-prime-parity/open/OP-05-nmin-asymptotic.md),
[`open/OP-06-reachable-fraction.md`](twin-prime-parity/open/OP-06-reachable-fraction.md),
[`006/handoff.md`](twin-prime-parity/006/handoff.md).

| result | statement | status | Lean proof |
|---|---|---|---|
| **OP-5 leading coefficient forced** | `Σ_{j≥1} x^j = 1` has unique root `x = 1/2`, so the exponent rate is `log 2` | PROVED (Lean) | [`leadingCoeff_forced`](twin-prime-parity/open/lean/Op56/Asymptotic.lean#L69) |
| **OP-5 threshold, leading** | `P_n = n·log 2 + O(1)` | PROVED (Lean) | [`op5_threshold_leading`](twin-prime-parity/open/lean/Op56/Asymptotic.lean#L87) |
| **OP-5 threshold, 2nd order** | `P_n = (n+3/2)log 2 + O(1)` | PROVED (Lean) | [`op5_threshold_second_order`](twin-prime-parity/open/lean/Op56/Asymptotic.lean#L124) |
| **OP-5 threshold, full** | `P_n = (n+3/2)log 2 + c/n + O(1/n²)`, `c = 3(log 2)² − (25/12)log 2` | PROVED (Lean, axiom-clean) | [`op5_threshold_asymptotic`](twin-prime-parity/open/lean/Op56/Asymptotic.lean#L189) |
| **OP-5 index form** | `n_min(p) = p/log 2 − 3/2 + O(1)` (corrected from a false `O(1/p)`) | PROVED (Lean, axiom-clean) | [`op5_nmin_asymptotic`](twin-prime-parity/open/lean/Op56/Asymptotic.lean#L239) |
| **OP-5 exact ceiling law** (O3) | `nmin p = ⌈p/log 2 − 5/2⌉` is **FALSE**. The crossing is `n_*(p) = p/log 2 − 3/2 + F(p)` with `F(p) = −b/(n_* log 2) + O(n_*⁻²) ≈ 2.698·10⁻³/p > 0`, `b = 3(log 2)² − (25/12)log 2`; the law holds iff `1 − {y} > F(p)`, `y = p/log 2 − 3/2`. First counterexample: a **451-digit** `p` with `nmin p = ⌈p/log 2 − 5/2⌉ + 1` | **REFUTED** (independently reproduced at 1150 dps); sharpest true uniform statement is the disjunction `nmin p ∈ {⌈A⌉, ⌈A⌉+1}`, unproved | [`006/verify/op05_nmin_ceiling_false.py`](twin-prime-parity/006/verify/op05_nmin_ceiling_false.py), [`006/handoff.md`](twin-prime-parity/006/handoff.md) §6.4 |
| OP-5 ceiling-law reduction (Lean) | `nmin p = ⌈A⌉ ↔ Φ_p(⌈A⌉) < 1 ∧ 1 ≤ Φ_p(⌈A⌉+1)`; plus `IsComplete_mono`, `nmin_le_of_IsComplete` | PROVED (Lean, axiom-clean) — reduces the (false) law to its two pointwise halves | [`PhiThird.lean`](twin-prime-parity/open/lean/Op56/PhiThird.lean) (`nmin_eq_iff_Phi_bounds`, `nmin_eq_ceil_of_Phi_bounds`) |
| **other moduli** (O9) | with `term(p,q,r,n) = (q(n+1)+r)^{−p}` the Brown criterion depends only on `N + 1 + r/q`, so (i) **`r = 0` is exactly `q`-independent** (`nmin(p;q,0) = nmin(p;2,0)` for every `q`) and (ii) the slope is **`1/log 2`** for every `q, r`: `nmin(p;q,r) = p/log 2 − 1 − r/q + O(1)`. The recorded "leading constant becomes `1/log q`-type data" is **FALSE** | **DERIVED + VERIFIED** (60 dps, 60 cases, `q ≤ 11`) | [`open/OP-09-other-moduli.md`](twin-prime-parity/open/OP-09-other-moduli.md), [`open/op09_moduli.py`](twin-prime-parity/open/op09_moduli.py) |
| **fourth-order expansion** (O10) | `Phi_fourth_order`: `∃ C>0, ∀ᶠ n, ∀ u∈[1/2,1], \|Φ(u n, n) − [(eᵘ−1)⁻¹ + (u/2n)ΦS u + (−(u/3)ΦK3u + (u²/8)ΦK4u)/n² + E(u)/n³]\| ≤ C/n⁴`, with `C = 11·10¹²+2·10¹²+7`, `E(u) = (u/4)ΦK4u − (u²/6)ΦK5u + (u³/48)ΦK6u` | **PROVED (Lean, axiom-clean)**, `./check.sh --all` **9/9**. Chain: `phi_term_sharp4` (former sole blocker; constant `11`, ~118× margin), `tsum_pow8_exp_neg_half_le`, `tsum_shift_pow_exp_le8` (`m ≤ 8`), `phi_tail_sum_le4`, `phi_finite_part_le4`, `PhiMainS4_eq`, `Phi_fourth_order_aux`. Moments `1082`/`9366` (`k⁸`: `1091670`), not `541`/`4683`. **Not landed:** the threshold-form fourth order (`SFourth`), new analytic content | [`PhiFourth.lean`](twin-prime-parity/open/lean/Op56/PhiFourth.lean) |
| **OP-6 reachable fraction** | `L(p) = p log p − (1 + log log 2)p + O(1)` | PROVED (Lean, axiom-clean) | [`op6_reachable_fraction`](twin-prime-parity/open/lean/Op56/Asymptotic.lean#L294) |
| **OP-6 `1/p` coefficient** (O4) | closed form but **not constant**: `c(e) = −((log 2)²/2)(e² − e + 9/4)` with `e(p) = ⌈p/log 2 − 5/2⌉ − (p/log 2 − 5/2) ∈ [0,1)`, ranging over `[−(log 2)², −(9/8)(log 2)²] = [−0.480453, −0.540510]`. The formerly quoted constant `−0.540509640658…` is the `e = 0` (smooth-index) value — **the earlier constant-coefficient statement was false** | DERIVED + VERIFIED (`3.5·10⁻¹⁴` at `p = 10¹³`) | [`op06_ceiling_coefficient.py`](twin-prime-parity/open/op06_ceiling_coefficient.py), [`OP-06-reachable-fraction.md`](twin-prime-parity/open/OP-06-reachable-fraction.md) §2.4 |
| `Φ` asymptotic | `∃ C>0, ∀ n≥4, ∀ u∈[1/2,1], \|Φ(n) − (e^u−1)⁻¹\| ≤ C/n` | PROVED (Lean) | [`Phi_asymptotic`](twin-prime-parity/open/lean/Op56/PhiAsymptotic.lean) |
| existence of the threshold | `IsComplete p (4p)` for `p ≥ 2` | PROVED (Lean) | `exists_isComplete` (`Exact.lean`) |
| census identity | `reachableMeasure` census and ratio | PROVED (Lean) — but see caveat | [`census_measure_eq`](twin-prime-parity/open/lean/Op56/Census.lean#L56), [`census_ratio`](twin-prime-parity/open/lean/Op56/Census.lean#L60) |
| integral test (negative result) | `tailSum_integral_lower` — proved for the corrected hypothesis **`N + 2 ≤ M`**; the as-written `N + 1 ≤ M` form is **false** (`p=2, N=0, M=1`). Too lossy to prove completeness, so it stays a negative result | **PROVED** (Lean, 0 `sorry`) | [`Exact.lean#L143`](twin-prime-parity/open/lean/Op56/Exact.lean#L143) |
| supporting helper | `∫_{Ioi M} (2x)^{-p} = (2M)^{-p}·M/(p−1)` | **PROVED** (Lean) | [`integral_two_mul_rpow`](twin-prime-parity/open/lean/Op56/Exact.lean#L107) |
| **floor-asymptotic meta-theorem** (O11) | if `α` is irrational then no integer sequence `n` satisfies `\|n(p) − (αp + β)\| ≤ C/p` for all large `p` — i.e. an `O(1/p)` error in an index asymptotic is impossible for an irrational linear threshold | **PROVED** (Lean, axiom-clean) | [`no_index_asymptotic_error`](twin-prime-parity/open/lean/Op56/FloorAsymptotic.lean), [`irrational_not_eventually_error_inv`](twin-prime-parity/open/lean/Op56/FloorAsymptotic.lean) |
| OP-5 instance of O11 | `nmin p − nminAsym p` is **not** `O(1/p)` (conditional on `Irrational (Real.log 2)`, which Mathlib lacks) | PROVED (Lean, 1 explicit hypothesis) | [`nmin_error_not_bigO_inv`](twin-prime-parity/open/lean/Op56/FloorAsymptotic.lean) |

**Census caveat (recorded, not stale).** `census_measure_eq` holds *by construction*:
`reachableMeasure` is defined to be `2^{nmin p}·tailSum p (nmin p)`, the right-hand side of
the census law. The strictly geometric statement — that the `2^{nmin}` translates in `S_1`
are pairwise disjoint and their union is exactly the sub-sum set — is **not** formalised;
`Op56/Census.lean` states this as the remaining "census counting" gap. The arithmetic is
verified numerically to `3.9·10⁻⁶²` for thirteen exponents
(`rounds/rh42/reachable.py` §2).

Numeric cross-checks: [`open/op05_nmin.py`](twin-prime-parity/open/op05_nmin.py),
[`open/op06_reachable_fraction.py`](twin-prime-parity/open/op06_reachable_fraction.py),
[`006/verify/`](twin-prime-parity/006/verify). Full status of the directory, including
the corrections now applied to the `open/lean` docstrings, the `O(1/p)` → `O(1)` fix and
`RESULTS.html`, is in [`open.md`](open.md).

---

## 10. Generalisations and attempts — `007`, `008`, `009`

| result | statement | status | Lean proof |
|---|---|---|---|
| character-weighted limit law | `Φ_c(p,n) → F_r(e^{−p/n})`, `F_r(x) = f_r(x)/(1−x^q)` | PROVED (Lean) | [`hasSum_F_of_periodic`](twin-prime-parity/007/lean/Op57/Blocks.lean#L50), [`F_eq_fblock`](twin-prime-parity/007/lean/Op57/Blocks.lean#L128) |
| parity leading equation | `x = 1/√2` (even `r`), `x = (√5−1)/2` (odd `r`) | PROVED (Lean) | [`leading_forced_parity_even`](twin-prime-parity/007/lean/Op57/Leading.lean#L66), [`leading_forced_parity_odd`](twin-prime-parity/007/lean/Op57/Leading.lean#L74) |
| `χ₃`, `χ₄` have no threshold | `F_r < 1` on `[0,1)` for all residues | PROVED (Lean) | [`chi3_no_leading_threshold`](twin-prime-parity/007/lean/Op57/Obstruction.lean#L147), [`chi4_no_leading_threshold`](twin-prime-parity/007/lean/Op57/Obstruction.lean#L153) |
| shift-2 split | `S(x,2) = S(⌊x/2⌋,1) + C(⌊(x+1)/2⌋)`, `C(K)=Σ_{k≤K} λ(4k²−1)` | PROVED (Lean) | [`Sh2_split`](twin-prime-parity/008/lean/Op58/Split.lean#L65), [`Ccore_eq_poly`](twin-prime-parity/008/lean/Op58/Split.lean#L56) |
| λ on the polynomial core | `liouville_pair`, `poly_identity`, `even_shift` | PROVED (Lean) | [`Op58/Defs.lean`](twin-prime-parity/008/lean/Op58/Defs.lean#L60) |
| sparse-pair bound | `\|Σ aₙ(wₙw_{n+2}−1)\| ≤ 2·#{crossings}` | PROVED (Lean) | [`sparse_pair_bound`](twin-prime-parity/009/lean/Op59/Sparse.lean#L42) |
| angle twist invisible | twist changes the correlation by `O(θ(N+2)/c)` | PROVED (Lean) | [`angle_twist_invisible`](twin-prime-parity/009/lean/Op59/Phase.lean#L123), [`phaseCrossing_card_le`](twin-prime-parity/009/lean/Op59/Phase.lean#L109) |

**Verdicts (paper, not Lean):** `007` — the OP-5 second-order expansion survives for
character sums, but the leading equation fails for `χ₃`, `χ₄` (29.7 % of 4537
`(χ,r)` pairs have a root). `008` — the automorphic/spectral input **does not** break
parity over ℚ (`L(s,λ)=ζ(2s)/ζ(s)` has no automorphic object; parity is broken over
`𝔽_q[T]` by Sawin–Shusterman but does not transfer). `009` — a sign either preserves
the pair cancellation (uninformative) or destroys it (useless); the parity barrier
stands.

---

## 11. von Mangoldt sieves — `publish/001-von-mangoldt-sieves`

Lean: [`VonMangoldtSieves.lean`](publish/001-von-mangoldt-sieves/VonMangoldtSieves.lean).

| result | statement | status | Lean proof |
|---|---|---|---|
| support | `Λ n ≠ 0 ↔ IsPrimePow n` | PROVED (Lean) | [`support_ne_zero_iff`](publish/001-von-mangoldt-sieves/VonMangoldtSieves.lean#L28) |
| prime powers | `Λ(pᵏ) = log p` | PROVED (Lean) | [`apply_prime_pow`](publish/001-von-mangoldt-sieves/VonMangoldtSieves.lean#L33) |
| divisor identity | `Σ_{d∣n} Λ d = log n` | PROVED (Lean) | [`divisor_identity`](publish/001-von-mangoldt-sieves/VonMangoldtSieves.lean#L40) |
| Möbius inversion | `Λ = μ ∗ log` | PROVED (Lean) | [`moebius_convolution`](publish/001-von-mangoldt-sieves/VonMangoldtSieves.lean#L44) |
| non-additive / non-multiplicative | with witnesses | PROVED (Lean) | [`not_additive`](publish/001-von-mangoldt-sieves/VonMangoldtSieves.lean#L50), [`not_multiplicative`](publish/001-von-mangoldt-sieves/VonMangoldtSieves.lean#L64) |
| bound | `Λ n ≤ log n` | PROVED (Lean) | [`le_log`](publish/001-von-mangoldt-sieves/VonMangoldtSieves.lean#L78) |

---

## 12. Cone, shift-2 core and the three thresholds (workspace `lean/`)

These proof files live **outside** `research/`, at the workspace root `lean/`.

| result | statement | status | Lean proof |
|---|---|---|---|
| shift-2 split (finite) | `chowlaSum` shift-2 decomposition | PROVED (Lean) | [`ShiftTwoCore.lean#L63`](../lean/ConeLean/ShiftTwoCore.lean#L63) |
| shift-2 ⟺ shift-1 + core | `shift_two_of_shift_one_and_core` | PROVED (Lean) | [`ShiftTwoCore.lean#L155`](../lean/ConeLean/ShiftTwoCore.lean#L155) |
| core not multiplicative | with witnesses | PROVED (Lean) | [`ShiftTwoCore.lean#L120`](../lean/ConeLean/ShiftTwoCore.lean#L120) |
| Chowla core identity | `chowlaSum_eq`, `chowlaSum_tendsto_iff_patCount_tendsto` | PROVED (Lean) | [`ChowlaEquiv.lean#L77`](../lean/ConeLean/ChowlaEquiv.lean#L77) |
| cone residue | `shift_two_of_...` / cone radius, critical weight summability | PROVED (Lean) | [`Cone.lean`](../lean/ConeLean/Cone.lean) |
| parity obstruction | `chowlaAF_not_multiplicative`, `chowlaAF_not_conv` | PROVED (Lean) | [`ParityObstruction.lean`](../lean/ConeLean/ParityObstruction.lean) |
| Abel/log-averaging barrier | `abelMean_tendsto_zero`, `log_abel` | PROVED (Lean) | [`ResidueReduction.lean#L443`](../lean/ConeLean/ResidueReduction.lean#L443) |
| shift-average barrier | `shift_average_does_not_control_single` | PROVED (Lean) | [`ShiftBarrier.lean#L94`](../lean/ConeLean/ShiftBarrier.lean#L94) |
| spectral structure | `dft_autocorr`, `corr_eq_zero_of_dft_mul_star_dft_eq` | PROVED (Lean) | [`SpectralStructure.lean`](../lean/ConeLean/SpectralStructure.lean) |
| **three thresholds** | `pN < pP < p*` for the rh42 budget (ledger row T14) | PROVED (Lean) | [`tpp_rh42_three_thresholds`](../lean/TppLean/ThreeThresholds.lean#L734) |

The three-thresholds theorem is an **internal programme result** — it is *not* a
twin-prime/parity result ([`theorems/tpp-rh42-three-thresholds-paper.html`](twin-prime-parity/theorems/tpp-rh42-three-thresholds-paper.html)).

---

## 13. The programme's positive ledger in one line each

1. The greedy digit word's **factor-complexity law** and the **inverse-problem
   impossibility** (rh41, Lean).
2. The signed **Tau alphabet**: budget algebra, Brown's criterion, the census law,
   the four thresholds, the **parity lock** (rh42, Lean).
3. The **balance ⟺ `Re S_N(t)=0`** identity, attainable for every `N ≥ 2`
   (rh43, Lean).
4. **Smoothing does not remove the `√N`**; only the functional equation does
   (rh044, Lean + verified).
5. The **correct Weil explicit formula** (with the archimedean term) and the
   **closed Turing windows `½ < Im < 15` and `½ < Im < 33`** (rh45/010, Lean + certificates,
   both unconditional).
6. The **finite-prefix indeterminacy theorem** — the programme's one clean new
   theorem about two-point Chowla (rh46, Lean).
7. The **Sylvester-sparsity theorem** for the greedy support (rh47, paper).
8. **OP-5** and **OP-6** resolved: `n_min(p) = p/log 2 − 3/2 + O(1)` and
   `measure(S_1)/P(p) = p^{−p}e^{(1+log log 2)p}(1+o(1))` (open/006, Lean).
9. The **von Mangoldt sieve** results, published (publish/001-von-mangoldt-sieves, Lean).
10. **Three thresholds** `pN < pP < p*` (workspace `lean/TppLean`, Lean).

**And the one thing it did not do:** prove anything about twin primes or the parity
obstruction. `Σ_{n≤x}λ(n)λ(n+2) = o(x)` remains **OPEN**.
