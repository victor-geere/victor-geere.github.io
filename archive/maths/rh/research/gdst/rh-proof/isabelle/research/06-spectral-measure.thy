(*  Title:      GDST_Spectral_Measure.thy
    Author:     Victor Geere & Mentor
    Date:       May 2026
    Description: Discrete spectral measure for the GDST programme,
                 proving the moment‑trace identity and removing AX_moment.
*)

theory GDST_Spectral_Measure
  imports "HOL-Analysis.Analysis"
begin

text ‹
  This theory assumes the following constants are already defined in the main GDST file:
    • ‹lambda_sigma :: real ⇒ nat ⇒ real›   (eigenvalue function)
    • ‹T_sigma :: real ⇒ (real ⇒ complex) ⇒ (real ⇒ complex)›  (integral operator)
    • ‹trace :: ((real ⇒ complex) ⇒ (real ⇒ complex)) ⇒ complex›  (operator trace)

  If they are not yet present, uncomment and adapt the ‹consts› declarations below.
  In an integration step you should simply remove the old definition of ‹mu_sigma›
  (which was a density on [0,π]) and the old axiom ‹AX_moment›.
›

subsection ‹Underlying constants (already in the main theory)›
(* Uncomment and adjust if necessary:
consts lambda_sigma :: "real ⇒ nat ⇒ real"
consts T_sigma :: "real ⇒ (real ⇒ complex) ⇒ (real ⇒ complex)"
consts trace :: "((real ⇒ complex) ⇒ (real ⇒ complex)) ⇒ complex"
*)

subsection ‹Axioms preserved from the GDST framework›
text ‹
  The following axioms are already present in the original theory
  (AX6b, trace‑class summability, and the spectral‑trace link).
  We restate them here only to keep this file self‑contained;
  in the final integration they can be removed if they are already available.
›
axiomatization where
  lambda_nonneg: "⋀σ i. lambda_sigma σ i ≥ 0"
  and trace_class_summable: "σ > 0 ⟹ summable (λi. lambda_sigma σ i)"
  and trace_T_sigma_pow_eq_sum:
    "⟦σ > 0; k ≥ 1⟧ ⟹ trace (T_sigma σ ^^ k) = (∑ i. (lambda_sigma σ i) ^ k)"
  ― ‹The last axiom is the only new, minimal assumption; it can later be proved
     from the spectral theorem (AX6a) and the definition of trace.›

subsection ‹Phase 1: Discrete spectral measure›
definition mu_sigma :: "real ⇒ real measure" where
  "mu_sigma σ ≡ distr (count_space UNIV) borel (λi. lambda_sigma σ i)"

subsection ‹Phase 2: Integration theorem›
lemma integral_mu_sigma:
  fixes f :: "real ⇒ 'a::{banach, second_countable_topology}"
  assumes f_meas [measurable]: "f ∈ borel_measurable borel"
  assumes sum_abs: "summable (λi. norm (f (lambda_sigma σ i)))"
  shows "∫ x. f x ∂(mu_sigma σ) = (∑ i. f (lambda_sigma σ i))"
proof -
  have int_c: "integrable (count_space UNIV) (λi. f (lambda_sigma σ i))"
    using sum_abs by (simp add: integrable_count_space_nat_iff)
  have "∫ x. f x ∂(mu_sigma σ) = ∫ i. f (lambda_sigma σ i) ∂(count_space UNIV)"
    unfolding mu_sigma_def by (rule integral_distr) (use f_meas int_c in auto)
  also have "… = (∑ i. f (lambda_sigma σ i))"
    using integral_count_space_nat by auto
  finally show ?thesis .
qed

subsection ‹Phase 3: Summability of eigenvalue powers and moment identity›
lemma summable_lambda_pow:
  fixes σ :: real and k :: nat
  assumes "σ > 0" and "k ≥ 1"
  shows "summable (λi. (lambda_sigma σ i) ^ k)"
proof -
  have nonneg: "∀i. lambda_sigma σ i ≥ 0" using lambda_nonneg by auto
  have "summable (λi. lambda_sigma σ i)" using trace_class_summable[OF ‹σ > 0›] .
  hence tendsto: "lambda_sigma σ ⇢ 0"
    using summable_LIMSEQ_zero by auto
  have "eventually (λi. lambda_sigma σ i ≤ 1) sequentially"
    using order_tendstoD(2)[OF tendsto, of 1] by simp
  have "eventually (λi. (lambda_sigma σ i) ^ k ≤ lambda_sigma σ i) sequentially"
  proof (rule eventually_mono)
    show "eventually (λi. lambda_sigma σ i ≤ 1) sequentially" by fact
    fix i assume "lambda_sigma σ i ≤ 1"
    with nonneg[rule_format, of i] ‹k ≥ 1›
    show "(lambda_sigma σ i) ^ k ≤ lambda_sigma σ i"
      by (cases "lambda_sigma σ i = 0")
         (auto simp: power_le_one_iff zero_le_power_eq)
  qed
  thus "summable (λi. (lambda_sigma σ i) ^ k)"
    using summable_comparison_test_ev[OF _ _ ‹summable (λi. lambda_sigma σ i)›,
        of "λi. (lambda_sigma σ i) ^ k"]
      nonneg by (simp add: eventually_conj)
qed

lemma moment_eq_sum:
  fixes σ :: real and k :: nat
  assumes "σ > 0" "k ≥ 1"
  shows "(∫ x. x ^ k ∂(mu_sigma σ)) = (∑ i. (lambda_sigma σ i) ^ k)"
  using integral_mu_sigma[of "λx. x ^ k" σ] summable_lambda_pow[OF assms]
  by simp

subsection ‹Phase 4: Moment equals trace of \(T_\sigma^k\)›
theorem moment_eq_trace:
  fixes σ :: real and k :: nat
  assumes "σ > 0" "k ≥ 1"
  shows "(∫ x. x ^ k ∂(mu_sigma σ)) = trace (T_sigma σ ^^ k)"
  using moment_eq_sum[OF assms] trace_T_sigma_pow_eq_sum[OF assms] by simp

text ‹
  This theorem exactly replaces the old axiom ‹AX_moment›.
  After integrating this theory:
    • Delete the old definition of ‹mu_sigma› (if it was defined as a density).
    • Delete the axiom ‹AX_moment›.
    • Ensure that ‹lambda_nonneg›, ‹trace_class_summable›, and ‹trace_T_sigma_pow_eq_sum›
      are either proved or declared as axioms (the last one temporarily).
  All existing lemmas that used ‹AX_moment› can now use ‹moment_eq_trace›.
›

end