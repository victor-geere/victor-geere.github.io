(* rem_tendsto_zero.thy *)
theory rem_tendsto_zero
  imports GDST_Base rem_nonneg rem_bound_weak
begin

text ‹Lemma rem\_tendsto\_zero: For $x \in [0,1]$, $r_N(x) \to 0$ as $N \to \infty$.›

lemma rem_tendsto_zero:
  fixes x :: real
  assumes "x \<in> {0..1}"
  shows "(\<lambda>N. r N x) \<longlonglongrightarrow> 0"
proof (rule tendsto_sandwich)
  show "\<forall>\<^sub>F N in sequentially. 0 \<le> r N x"
    using rem_nonneg assms by (auto simp: atLeastAtMost_iff)
  show "\<forall>\<^sub>F N in sequentially. r N x \<le> 1 / of_nat (N+2)"
    using assms rem_bound_weak[OF assms] by auto
  show "(\<lambda>N. 1 / of_nat (N+2)) \<longlonglongrightarrow> 0"
    by (rule tendsto_divide_0) simp
qed

end