theory greedy_harmonic_expansion
  imports GDST_Base greedy_sum_finite rem_tendsto_zero
begin

theorem greedy_harmonic_expansion:
  fixes x :: real
  assumes "x \<in> {0..1}"
  shows "(\<Sum>n. delta n x / of_nat (n+2)) = x"
proof -
  have *: "(\<lambda>N. (\<Sum>k\<le>N. delta k x / of_nat (k+2))) = (\<lambda>N. x - r N x)"
    using greedy_sum_finite by (rule ext) (auto simp: field_simps)
  moreover have "(\<lambda>N. x - r N x) \<longlonglongrightarrow> x"
    using assms rem_tendsto_zero[OF assms] by (auto intro!: tendsto_eq_intros)
  ultimately have limit: "(\<lambda>N. (\<Sum>k\<le>N. delta k x / of_nat (k+2))) \<longlonglongrightarrow> x"
    by argo
  hence "summable (\<lambda>n. delta n x / of_nat (n+2))"
    using summable_def by blast
  with summable_sums[OF this] show ?thesis
    by (simp add: sums_iff)
qed

end