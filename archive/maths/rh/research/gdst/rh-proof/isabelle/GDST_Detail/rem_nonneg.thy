theory rem_nonneg
  imports GDST_Base delta_range
begin

lemma rem_nonneg:
  fixes x :: real
  assumes "x \<ge> 0"
  shows "r n x \<ge> 0"
proof (induction n)
  case 0
  have "delta 0 x \<in> {0,1}" using delta_range by blast
  thus ?case using assms by (auto simp: r.simps)
next
  case (Suc n)
  have IH: "r n x \<ge> 0" by fact
  show ?case
  proof (cases "r n x \<ge> 1 / of_nat (n+3)")
    case True
    then have "delta (Suc n) x = 1" by (simp add: delta.simps)
    then have "r (Suc n) x = r n x - 1 / of_nat (n+3)"
      by (simp add: r.simps)
    also from IH have "... \<ge> 0" using True by (auto simp: field_simps)
    finally show ?thesis .
  next
    case False
    then have "delta (Suc n) x = 0" by (simp add: delta.simps)
    then have "r (Suc n) x = r n x" by (simp add: r.simps)
    with IH show ?thesis by simp
  qed
qed

end