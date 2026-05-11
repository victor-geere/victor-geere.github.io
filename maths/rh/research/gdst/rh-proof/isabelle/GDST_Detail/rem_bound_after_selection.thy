theory rem_bound_after_selection
  imports GDST_Base rem_bound_weak
begin

lemma rem_bound_after_selection:
  fixes x :: real
  assumes "x \<in> {0..1}" "delta (Suc n) x = 1"
  shows "r (Suc n) x \<le> 1 / (of_nat (n+2) * of_nat (n+3))"
proof -
  have "r n x \<ge> 1 / of_nat (n+3)"
    using assms(2) by (simp add: delta.simps)
  have "r (Suc n) x = r n x - 1 / of_nat (n+3)"
    using assms(2) by (simp add: r.simps)
  also have "... \<le> (1 / of_nat (n+2)) - (1 / of_nat (n+3))"
    using `r n x \<ge> 1 / of_nat (n+3)` rem_bound_weak[OF assms(1)]
    by (simp add: field_simps)
  also have "(1 / of_nat (n+2)) - (1 / of_nat (n+3)) = 1 / (of_nat (n+2) * of_nat (n+3))"
    by (simp add: field_simps)
  finally show ?thesis .
qed

end