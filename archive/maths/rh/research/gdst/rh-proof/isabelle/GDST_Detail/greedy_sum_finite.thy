(* greedy_sum_finite.thy *)
theory greedy_sum_finite
  imports GDST_Base
begin

text {* Lemma greedy_sum_finite: For every $N \ge 0$,
  $x = \sum_{k=0}^{N} \frac{\delta_k(x)}{k+2} + r_N(x)$. *}

lemma greedy_sum_finite:
  fixes x :: real
  shows "x = (\<Sum>k\<le>N. delta k x / of_nat (k+2)) + r N x"
proof (induction N)
  case 0
  have "r 0 x = x - delta 0 x * (1/2)"
    by (simp add: r.simps)
  then show ?case
    by (auto simp: field_simps)
next
  case (Suc N)
  have "x = (\<Sum>k\<le>N. delta k x / of_nat (k+2)) + r N x"
    using Suc by simp
  also have "r N x = delta (Suc N) x * (1 / of_nat (Suc N + 2)) + r (Suc N) x"
    using r.simps(2)[of N x]
    by (simp add: field_simps)
  also have "(\<Sum>k\<le>N. delta k x / of_nat (k+2)) +
             (delta (Suc N) x * (1 / of_nat (Suc N + 2)) + r (Suc N) x) =
             (\<Sum>k\<le>Suc N. delta k x / of_nat (k+2)) + r (Suc N) x"
    by (simp add: sum.atMost_Suc algebra_simps)
  finally show ?case .
qed

end