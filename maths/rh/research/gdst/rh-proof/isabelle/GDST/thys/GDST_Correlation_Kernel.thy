theory GDST_Correlation_Kernel
  imports GDST_Greedy_Expansion
begin

(* ============================================================
   Part II — Threshold Angles and the Correlation Kernel
   ============================================================ *)
section ‹Part II: Threshold Angles, Correlation Kernel, and the GDST›

subsection ‹7. Digit functions in angle coordinates›

definition delta_theta :: "real ⇒ nat ⇒ nat" where
  "delta_theta θ n = delta (θ / pi) n"

definition rem_theta :: "real ⇒ nat ⇒ real" where
  "rem_theta θ n = rem (θ / pi) n"

lemma delta_theta_range: "delta_theta θ n ∈ {0, 1}"
  unfolding delta_theta_def by (rule delta_range)

lemma rem_theta_nonneg: "θ ≥ 0 ⟹ rem_theta θ n ≥ 0"
  unfolding rem_theta_def
  by (intro rem_nonneg) (simp add: divide_nonneg_pos)

lemma theta_representation:
  assumes "θ ∈ {0..pi}"
  shows "θ / pi = (∑ n. real (delta_theta θ n) / real (n + 2))"
  unfolding delta_theta_def
  using greedy_harmonic_expansion[of "θ/pi"] assms
  by (simp add: divide_le_eq)

subsection ‹8. Non-monotonicity of greedy digits›

(* The digits delta_theta n are not monotone in theta for n >= 1.
   At n = 0 the single threshold is pi/2, so delta_theta 0 is a step function.
   For n >= 1 monotonicity fails. *)

subsection ‹9. The correlation kernel›

definition f_digit :: "nat ⇒ real ⇒ real" where
  "f_digit n θ = real (delta_theta θ n) - θ / pi"

definition K_corr :: "nat ⇒ nat ⇒ real" where
  "K_corr n m = integral {0..pi} (λθ. f_digit n θ * f_digit m θ)"

lemma K_corr_sym: "K_corr n m = K_corr m n"
  unfolding K_corr_def by (simp add: mult.commute)

theorem K_corr_psd:
  fixes a :: "nat ⇒ real"
  assumes fin: "finite (support a)"
  shows "(∑ n∈support a. ∑ m∈support a. a n * a m * K_corr n m) ≥ 0"
proof -
  let ?S = "support a"
  have "(∑ n∈?S. ∑ m∈?S. a n * a m * K_corr n m) =
        (∑ n∈?S. ∑ m∈?S. a n * a m * integral {0..pi} (λθ. f_digit n θ * f_digit m θ))"
    unfolding K_corr_def by simp
  also have "… = integral {0..pi} (λθ. (∑ n∈?S. ∑ m∈?S. a n * a m * f_digit n θ * f_digit m θ))"
    by (simp add: sum_distrib_left sum_distrib_right mult.assoc flip: sum_distrib_right)
      (rule Bochner_Integration.integral_sum, simp)
  also have "… = integral {0..pi} (λθ. (∑ n∈?S. a n * f_digit n θ)⇧2)"
    by (auto simp: power2_eq_square sum_product algebra_simps)
  also have "… ≥ 0"
    by (rule integral_nonneg) (auto intro!: zero_le_power2)
  finally show ?thesis .
qed

end
