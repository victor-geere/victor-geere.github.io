(* rem_bound_weak.thy *)
theory rem_bound_weak
  imports GDST_Base delta_range
begin

(*
  Lemma rem_bound_weak:
  For every x in [0,1] we have r_n(x) <= 1/(n+2) for all n.
  This is the unconditional weak remainder bound needed for convergence.
  The digits delta_n are NOT monotone (see section 8 of proof.html),
  but this bound holds anyway by induction on the recursive definition.
*)

lemma rem_bound_weak:
  fixes x :: real
  assumes "x \<in> {0..1}"
  shows   "r n x \<le> 1 / of_nat (n+2)"
proof (induction n)
  case 0
  have "delta 0 x \<in> {0,1}"
    using delta_range by blast
  then show ?case
    using assms by (auto simp: r.simps field_simps)
next
  case (Suc n)
  have IH: "r n x \<le> 1 / of_nat (n+2)" by fact
  have d_range: "delta (Suc n) x \<in> {0,1}"
    using delta_range by blast

  show ?case
  proof (cases "delta (Suc n) x = 1")
    case True
    then have r_suc: "r (Suc n) x = r n x - 1 / of_nat (n+3)"
      by (simp add: r.simps)

    also have "... \<le> 1 / of_nat (n+2) - 1 / of_nat (n+3)"
      using IH by auto

    also have "... = 1 / (of_nat (n+2) * of_nat (n+3))"
      by (simp add: field_simps)

    also have "... \<le> 1 / of_nat (n+3)"
      by (simp add: field_simps mult_right_mono of_nat_le_iff)

    also have "... = 1 / of_nat (Suc n + 2)" by simp
    finally show ?thesis .

  next
    case False
    then have "delta (Suc n) x = 0" using d_range by auto
    then have r_suc: "r (Suc n) x = r n x"
      by (simp add: r.simps)

    also have "... \<le> 1 / of_nat (n+2)" using IH .
    also have "... \<le> 1 / of_nat (n+3)"
      by (simp add: field_simps)
    also have "... = 1 / of_nat (Suc n + 2)" by simp
    finally show ?thesis .
  qed
qed

end