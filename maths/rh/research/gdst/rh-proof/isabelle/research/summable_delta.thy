context
  fixes θ :: real
  assumes θ_range: "θ ∈ {0..pi}"
begin

definition E_gdst :: "complex ⇒ complex" where
  "E_gdst s = (∑ n. (if delta_theta θ n = 1 then 1 else 0) * (of_nat (n+2)) powr (-s))"

lemma summable_delta_powr_theta:
  assumes "Re s > 0"
  shows "summable (λn. norm ((if delta_theta θ n = 1 then 1 else 0) * (of_nat (n+2)) powr (-s)))"
proof -
  have "θ / pi ∈ {0..1}" using θ_range by (auto simp: divide_le_eq)
  from summable_delta_powr[of "θ / pi" s, OF this assms] show ?thesis
    unfolding delta_theta_def by simp
qed

lemma summable_selected_powr_real:
  fixes δ :: real
  assumes "δ > 0"
  shows "summable (λn. if delta_theta θ n = 1 then (n+2) powr (-δ) else 0)"
proof -
  have "summable (λn. norm ((if delta_theta θ n = 1 then 1 else 0) * (of_nat (n+2)) powr (- of_real δ)))"
    using summable_delta_powr_theta[of "of_real δ"] assms by (simp add: Re_complex_of_real)
  then show ?thesis
    by (simp add: norm_mult norm_powr_real_powr)
qed

theorem E_gdst_abs_convergent:
  assumes "Re s > 0"
  shows "summable (λn. norm ((if delta_theta θ n = 1 then 1 else 0) * (of_nat (n+2)) powr (-s)))"
  using summable_delta_powr_theta[OF assms] .

theorem E_gdst_holomorphic: "E_gdst holomorphic_on {s. Re s > 0}"
proof -
  have open: "open {s. Re s > 0}" by (simp add: open_halfspace_Re_gt)
  have holomorphic_partials: "∀N. (λs. ∑ n<N. (if delta_theta θ n = 1 then 1 else 0) * (of_nat (n+2)) powr (-s)) holomorphic_on {s. Re s > 0}"
    by (intro allI holomorphic_intros)
  have uniform: "∀K. compact K ∧ K ⊆ {s. Re s > 0} ⟶
                uniform_limit K
                  (λN s. ∑ n<N. (if delta_theta θ n = 1 then 1 else 0) * (of_nat (n+2)) powr (-s))
                  E_gdst at_top"
  proof (intro allI impI)
    fix K assume "compact K" "K ⊆ {s. Re s > 0}"
    have "∃δ>0. ∀s∈K. Re s ≥ δ"
    proof -
      have "continuous_on K (λs. Re s)" by (intro continuous_intros)
      from `compact K` this have "∃x∈K. ∀y∈K. Re x ≤ Re y"
        by (rule compact_attains_inf)
      then obtain x where x: "x∈K" "∀y∈K. Re x ≤ Re y" by auto
      with `K ⊆ {s. Re s > 0}` have "Re x > 0" by auto
      with x(2) have "∀s∈K. Re s ≥ Re x" by auto
      with `Re x > 0` show ?thesis by (intro exI[of _ "Re x"]) auto
    qed
    then obtain δ where δ: "δ > 0" "∀s∈K. Re s ≥ δ" by blast
    define M where "M n = (if delta_theta θ n = 1 then (n+2) powr (-δ) else 0)" for n
    have summable_M: "summable M"
      using summable_selected_powr_real[OF δ(1)] by (simp add: M_def)
    have bound: "∀n s. s ∈ K ⟶ norm ((if delta_theta θ n = 1 then 1 else 0) * (of_nat (n+2)) powr (-s)) ≤ M n"
    proof (intro allI impI)
      fix n s
      assume s: "s ∈ K"
      have "norm ((if delta_theta θ n = 1 then 1 else 0) * (of_nat (n+2)) powr (-s)) =
            (if delta_theta θ n = 1 then 1 else 0) * (n+2) powr (-Re s)"
        by (simp add: norm_mult norm_powr_real_powr)
      also have "… ≤ (if delta_theta θ n = 1 then 1 else 0) * (n+2) powr (-δ)"
      proof (cases "delta_theta θ n = 1")
        case True
        then show ?thesis using δ(2) s by (intro mult_left_mono powr_mono2') auto
      qed simp
      finally show "norm ((if delta_theta θ n = 1 then 1 else 0) * (of_nat (n+2)) powr (-s)) ≤ M n"
        by (simp add: M_def)
    qed
    from Weierstrass_M_test[OF summable_M bound]
    have "uniform_limit K (λN s. ∑ n<N. (if delta_theta θ n = 1 then 1 else 0) * (of_nat (n+2)) powr (-s))
          (λs. ∑ n. (if delta_theta θ n = 1 then 1 else 0) * (of_nat (n+2)) powr (-s)) at_top"
      by (simp add: eventually_at_top_dense)
    moreover have "(λs. ∑ n. (if delta_theta θ n = 1 then 1 else 0) * (of_nat (n+2)) powr (-s)) = E_gdst"
      unfolding E_gdst_def ..
    ultimately show "uniform_limit K (λN s. ∑ n<N. ... ) E_gdst at_top" by simp
  qed
  then show ?thesis
    by (intro holomorphic_uniform_limit[OF open holomorphic_partials uniform])
qed

end