theory GDST_Greedy_Expansion
  imports
    Complex_Main
    "HOL-Analysis.Analysis"
begin

(* ============================================================
   Notation and abbreviations
   (The Zeta_Function import was unused and has been removed)
   ============================================================ *)

(* ============================================================
   Part I — Greedy Harmonic Expansion
   ============================================================ *)
section "Part I: Greedy Harmonic Expansion"

subsection "1. The greedy algorithm"

(* For x in [0,1] define digits delta x n in {0,1} and remainders rem x n
   by the greedy algorithm with harmonic fractions alpha n = 1/(n+2). *)

primrec greedy :: "real => nat => nat * real" where
  "greedy x 0 =
    (if x >= 1/2 then (1::nat, x - 1/2) else (0, x))"
| "greedy x (Suc n) =
    (let r = snd (greedy x n) in
     if r >= 1 / real (Suc n + 2)
     then (1::nat, r - 1 / real (Suc n + 2))
     else (0, r))"

definition delta :: "real => nat => nat" where
  "delta x n = fst (greedy x n)"

definition rem :: "real => nat => real" where
  "rem x n = snd (greedy x n)"

lemma delta_0 [simp]: "delta x 0 = (if x >= 1/2 then 1 else 0)"
  by (simp add: delta_def)

lemma delta_Suc [simp]:
    "delta x (Suc n) = (if rem x n >= 1 / real (Suc n + 2) then 1 else 0)"
  by (simp add: delta_def rem_def Let_def split: if_splits)

lemma rem_0 [simp]: "rem x 0 = x - real (delta x 0) * (1/2)"
  by (simp add: rem_def delta_def split: if_splits)

lemma rem_Suc [simp]:
    "rem x (Suc n) = rem x n - real (delta x (Suc n)) * (1 / real (Suc n + 2))"
  by (simp add: rem_def delta_def Let_def split: if_splits)

subsection "2. Basic properties of the greedy algorithm"

lemma delta_range: "delta x n \<in> {0, 1}"
  by (induction n) auto

lemma rem_nonneg:
  assumes "x \<ge> 0"
  shows "rem x n \<ge> 0"
proof (induction n)
  case 0
  show ?case using assms by (simp split: if_splits; linarith)
next
  case (Suc n)
  show ?case using Suc.IH by (auto split: if_splits; linarith)
qed

lemma rem_bound_weak:
  assumes "x \<in> {0..1}"
  shows "rem x n \<le> 1 / real (n + 2)"
proof (induction n)
  case 0
  show ?case using assms by (simp split: if_splits; linarith)
next
  case (Suc n)
  note IH = Suc
  show ?case
  proof (cases "rem x n \<ge> 1 / real (Suc n + 2)")
    case True
      then have sel: "delta x (Suc n) = 1" by auto
      hence eq: "rem x (Suc n) = rem x n - 1 / real (Suc n + 2)" by auto
      have bound: "rem x n \<le> 1 / real (n + 2)" using IH by auto
      have arith: "1 / real (n + 2) \<le> 2 / real (Suc n + 2)"
      proof -
        have "1 * real (Suc n + 2) \<le> 2 * real (n + 2)" by (simp add: field_simps)
        thus ?thesis by (simp add: divide_le_iff field_simps)
      qed
      from bound arith eq have "rem x (Suc n) \<le> 2 / real (Suc n + 2) - 1 / real (Suc n + 2)" by linarith
      thus ?thesis by (simp add: field_simps)
    case False
      then show ?thesis using IH by (auto split: if_splits; linarith)
  qed
qed

lemma rem_bound_after_selection:
  assumes "x \<in> {0..1}" "delta x (Suc n) = 1"
  shows "rem x (Suc n) \<le> 1 / (real (Suc n + 1) * real (Suc n + 2))"
proof -
  from assms(2) have cond: "rem x n \<ge> 1 / real (Suc n + 2)" by (auto split: if_splits)
  from assms(2) have eq: "rem x (Suc n) = rem x n - 1 / real (Suc n + 2)" by (auto split: if_splits)
  have ub: "rem x n \<le> 1 / real (n + 2)"
    using rem_bound_weak[OF assms(1)] by auto
  have "real (n + 2) = real (Suc n + 1)" by (simp add: of_nat_Suc)
  hence "rem x n \<le> 1 / real (Suc n + 1)" using ub by auto
  hence "rem x (Suc n) \<le> 1 / real (Suc n + 1) - 1 / real (Suc n + 2)"
    using eq by linarith
  also have "1 / real (Suc n + 1) - 1 / real (Suc n + 2)
           = 1 / (real (Suc n + 1) * real (Suc n + 2))"
    by (simp add: field_simps)
  finally show ?thesis .
qed

subsection "3. The finite partial-sum identity"

lemma greedy_sum_finite:
  shows "x = (\<Sum> k \<le> N. real (delta x k) / real (k + 2)) + rem x N"
proof (induction N)
  case 0
  show ?case
    by (cases "x \<ge> 1/2") (auto simp: delta_0 rem_0)
next
  case (Suc N)
  have "x = (\<Sum> k \<le> N. real (delta x k) / real (k + 2)) + rem x N"
    using Suc.IH by auto
  also have "rem x N
    = real (delta x (Suc N)) / real (Suc N + 2) + rem x (Suc N)"
  proof (cases "rem x N \<ge> 1 / real (Suc N + 2)")
    case True
      then have "delta x (Suc N) = 1" by auto
      thus ?thesis by (simp add: field_simps)
    case False
      then have "delta x (Suc N) = 0" by auto
      thus ?thesis by auto
  qed
  finally show ?case
    by (simp add: sum.atMost_Suc algebra_simps)
qed

subsection "4. Remainder vanishes"

lemma rem_tendsto_zero:
  assumes "x \<in> {0..1}"
  shows "(\<lambda>N. rem x N) \<longlonglongrightarrow> 0"
proof (rule tendsto_sandwich)
  show "\<forall>\<^sub>F N in sequentially. (0 :: real) \<le> rem x N"
    using rem_nonneg[of x] assms by (simp add: eventually_sequentially)
  show "(\<lambda>N. 1 / real (N + 2)) \<longlonglongrightarrow> 0"
  proof -
    have "(\<lambda>N. 1 / real (N + 2)) = (\<lambda>N. inverse (real N + 2))"
      by (simp add: inverse_eq_divide add.commute)
    also have "... \<longlonglongrightarrow> 0"
      by (intro tendsto_inverse_0_at_top filterlim_at_top_add_const)
         (simp add: filterlim_real_sequentially)
    finally show ?thesis .
  qed
  show "\<forall>\<^sub>F N in sequentially. rem x N \<le> 1 / real (N + 2)"
    using rem_bound_weak[OF assms] by (simp add: eventually_sequentially)
  show "(\<lambda>_. 0 :: real) \<longlonglongrightarrow> 0" by auto
qed

subsection "5. Convergence of the greedy harmonic expansion"

theorem greedy_harmonic_expansion:
  assumes "x \<in> {0..1}"
  shows "x = (\<Sum> n. real (delta x n) / real (n + 2))"
proof -
  have nonneg: "\<forall>n. 0 \<le> real (delta x n) / real (n + 2)"
    by (auto simp: delta_range divide_nonneg_nonneg)
  have sum_eq: "\<forall>N. (\<Sum>k\<le>N. real (delta x k) / real (k + 2)) = x - rem x N"
  proof (rule allI)
    fix N :: nat
    show "(\<Sum>k\<le>N. real (delta x k) / real (k + 2)) = x - rem x N"
      by (subst greedy_sum_finite; simp add: algebra_simps)
  qed
  have bounded: "\<forall>N. (\<Sum>k\<le>N. real (delta x k) / real (k + 2)) \<le> x"
    using sum_eq rem_nonneg[OF assms[THEN atLeastAtMost_iff(1)]] by auto
  have summable: "summable (\<lambda>n. real (delta x n) / real (n + 2))"
    by (intro summableI_nonneg_bounded[where A=x] nonneg bounded)
  then have S: "(\<Sum>n. real (delta x n) / real (n + 2)) =
                lim (\<lambda>N. \<Sum>k\<le>N. real (delta x k) / real (k + 2))"
    by (simp add: suminf_eq_lim)
  have "lim (\<lambda>N. \<Sum>k\<le>N. real (delta x k) / real (k + 2)) = x"
  proof (rule tendsto_unique)
    show "(\<lambda>N. \<Sum>k\<le>N. real (delta x k) / real (k + 2)) \<longlonglongrightarrow> x"
    proof -
      have "(\<lambda>N. x - rem x N) = (\<lambda>N. \<Sum>k\<le>N. real (delta x k) / real (k + 2))"
        using sum_eq by fastforce
      moreover have "(\<lambda>N. x - rem x N) \<longlonglongrightarrow> x"
        using rem_tendsto_zero[OF assms] tendsto_const by (intro tendsto_diff) auto
      ultimately show ?thesis by auto
    qed
    show "(\<lambda>N. \<Sum>k\<le>N. real (delta x k) / real (k + 2)) \<longlonglongrightarrow>
          suminf (\<lambda>n. real (delta x n) / real (n + 2))"
      using summable_LIMSEQ[OF summable] .
  qed simp
  with S show ?thesis by auto
qed

subsection "6. Super-exponential growth of selected indices"

lemma rem_eq_between_selections:
  assumes "\<forall>k. n < k \<and> k \<le> j \<longrightarrow> delta x k = 0" "n \<le> j"
  shows "rem x j = rem x n"
proof -
  obtain D where hD: "j = n + D" using assms(2) by (metis le_iff_add)
  have "rem x (n + D) = rem x n"
  proof (induction D)
    case 0 show ?case by auto
    case (Suc d)
      have "rem x (n + Suc d) = rem x (n + d) -
            real (delta x (n + Suc d)) * (1 / real (n + Suc d + 2))"
        by auto
      also have "delta x (n + Suc d) = 0"
      proof -
        from hD have "n + Suc d \<le> j" using Suc.hyps by arith
        moreover have "n < n + Suc d" by auto
        ultimately show ?thesis using assms(1) by auto
      qed
      finally show ?case by (simp add: Suc.IH)
  qed
  with hD show ?thesis by auto
qed

theorem selected_growth:
  assumes "x \<in> {0..1}"
          "delta x (Suc n) = 1"
          "delta x m = 1"
          "m > Suc n"
          "\<forall>k. Suc n < k \<and> k < m \<longrightarrow> delta x k = 0"
  shows "m \<ge> Suc n * n"
proof -
  let ?p = "Suc n"

  have rem_tight: "rem x ?p \<le> 1 / (real (?p + 1) * real (?p + 2))"
    using rem_bound_after_selection[OF assms(1) assms(2)] by auto

  have no_gap: "rem x (m - 1) = rem x ?p"
  proof (rule rem_eq_between_selections)
    show "?p \<le> m - 1" using assms(4) by arith
    fix k assume H: "?p < k \<and> k \<le> m - 1"
    hence "?p < k \<and> k < m" by arith
    thus "delta x k = 0" using assms(5) by auto
  qed

  have sel_cond: "rem x (m - 1) \<ge> 1 / real (m + 2)"
  proof -
    have "delta x m = 1" using assms(3) by auto
    obtain k where "m = Suc k"
      using Nat.not_zero_eq_nat assms(4) by (cases m) simp_all
    hence "rem x (m - 1) \<ge> 1 / real (Suc k + 2)"
      using assms(3) ‹m = Suc k› by auto
    thus ?thesis using ‹m = Suc k› by auto
  qed

  have ineq: "1 / real (m + 2) \<le> 1 / (real (?p + 1) * real (?p + 2))"
    using no_gap rem_tight sel_cond by linarith

  have pos: "(0 :: real) < real (?p + 1) * real (?p + 2)" by linarith
  have pos2: "(0 :: real) < real (m + 2)" by linarith
  from ineq have "(real (?p + 1) * real (?p + 2)) \<le> real (m + 2)"
    using frac_le[OF pos pos2] by (simp add: field_simps)
  hence "real (?p + 1) * real (?p + 2) \<le> real m + 2" by (simp add: field_simps)
  hence "(real ?p + 1) * (real ?p + 2) \<le> real m + 2" by (simp add: field_simps)
  hence "real ?p ^ 2 + 3 * real ?p \<le> real m" by (simp add: field_simps; linarith)

  have "real ?p ^ 2 + 3 * real ?p \<ge> real ?p * (real ?p - 1)" by nlinarith
  hence "real (?p * (?p - 1)) \<le> real m"
    by (simp add: field_simps; linarith)
  thus "m \<ge> Suc n * n" by (simp add: field_simps; arith)
qed

lemma pow2_ineq_nat: "2 ^ (2 ^ k + 1) \<ge> (2::nat) ^ k"
proof (induction k)
  case 0 show ?case by auto
  case (Suc k)
    have "2 ^ (2 ^ Suc k + 1) = 2 ^ (2 * 2 ^ k + 1)" by auto
    also have "... = 2 * 2 ^ (2 * 2 ^ k)" by (simp add: power_add)
    also have "(2::nat) ^ (2 * 2 ^ k) = (2 ^ (2 ^ k)) ^ 2" by (metis power_mult mult.commute)
    also have "... \<ge> 2 ^ (2 ^ k)" by (simp add: power2_eq_square)
    also have "... \<ge> 2 ^ k" using Suc.IH by auto
    also have "2 ^ k \<ge> k" by auto
    finally show ?case by auto
qed

lemma pow2_ineq_real: "real (2 ^ (2 ^ k + 1)) \<ge> real (2 ^ k)"
  using pow2_ineq_nat by auto

lemma summable_delta_powr:
  fixes x :: real and s :: complex
  assumes "x \<in> {0..1}" "Re s > 0"
  shows "summable (\<lambda>n. real (delta x n) * (n + 2) powr (-Re s))"
proof -
  let ?c = "Re s"
  from assms(2) have c_pos: "?c > 0" by auto
  show ?thesis
  proof (cases "finite {n. delta x n = 1}")
    case True
    then show ?thesis by (auto intro!: summable_finite)
  next
    case False
    obtain \<nu> where \<nu>: "strict_mono \<nu>" "\<forall>k. delta x (\<nu> k) = 1"
                 and \<nu>_range: "\<forall>n. delta x n = 1 \<longrightarrow> n \<in> range \<nu>"
      using False infinite_enumerate by blast

    have "\<exists>k0. \<nu> k0 \<ge> 4"
    proof (rule ccontr)
      assume "\<nexists>k0. \<nu> k0 \<ge> 4"
      then have "\<forall>k. \<nu> k < 4" by auto
      with \<nu>(1) have "\<forall>k. \<nu> k \<le> 3" by (metis less_2_cases not_less)
      then have "{n. delta x n = 1} \<subseteq> {0,1,2,3}" using \<nu>_range by auto
      with False show False by auto
    qed
    then obtain k0 where k0: "\<nu> k0 \<ge> 4" by auto
    define \<nu>' where "\<nu>' k = \<nu> (k + k0)" for k
    have \<nu>'_strict: "strict_mono \<nu>'" using \<nu>(1) by (simp add: strict_mono_def \<nu>'_def)
    have \<nu>'_sel: "\<forall>k. delta x (\<nu>' k) = 1" using \<nu>(2) by (simp add: \<nu>'_def)
    have \<nu>'_base: "\<nu>' 0 \<ge> 4" using k0 by (simp add: \<nu>'_def)


    have growth: "\<forall>k. \<nu>' (Suc k) \<ge> \<nu>' k * (\<nu>' k - 1)"
    proof
      fix k
      from \<nu>'_sel have "delta x (\<nu>' k) = 1" "delta x (\<nu>' (Suc k)) = 1" by auto
      moreover have "\<nu>' (Suc k) > \<nu>' k" using \<nu>'_strict by (simp add: strict_mono_Suc_iff)
      moreover have "\<forall>i. \<nu>' k < i \<and> i < \<nu>' (Suc k) \<longrightarrow> delta x i = 0"
        using \<nu>(2) \<nu>'_def strict_mono_less[OF \<nu>(1)] by auto
      have h4: "\<nu>' k \<ge> 4"
        using \<nu>'_base \<nu>'_strict by (metis le_trans monoD strict_mono_mono zero_le)
      ultimately show "\<nu>' (Suc k) \<ge> \<nu>' k * (\<nu>' k - 1)"
        using selected_growth[OF assms(1), of "\<nu>' k - 1"] h4
        by (metis Suc_diff_1 diff_Suc_1 less_or_eq_imp_le)
    qed


    have exp_growth: "\<forall>k. \<nu>' k \<ge> 2 ^ (2 ^ k + 1)"
    proof
      fix k show "\<nu>' k \<ge> 2 ^ (2 ^ k + 1)"
      proof (induction k)
        case 0
        show ?case using \<nu>'_base by auto
      next
        case (Suc k)
        have "\<nu>' (Suc k) \<ge> \<nu>' k * (\<nu>' k - 1)" using growth by blast
        also have "\<nu>' k - 1 \<ge> \<nu>' k / 2"
        proof -
          from Suc.IH have "\<nu>' k \<ge> 2" by force
          thus ?thesis by linarith
        qed
        hence "\<nu>' k * (\<nu>' k - 1) \<ge> \<nu>' k * (\<nu>' k / 2)" by (auto intro: mult_left_mono)
        also have "... = (\<nu>' k)^2 / 2" by (simp add: power2_eq_square)
        also have "... \<ge> (2 ^ (2 ^ k + 1))^2 / 2"
          using Suc.IH by (intro divide_right_mono power_mono) auto
        also have "... = 2 ^ (2 * (2 ^ k + 1) - 1)"
          by (simp add: power_add power_mult)
        also have "2 * (2 ^ k + 1) - 1 = 2 ^ (k + 1) + 1"
          by (simp add: add.commute)
        finally show ?case by auto
      qed
    qed

    have summable_\<nu>'_powr: "summable (\<lambda>k. (\<nu>' k + 2) powr (-?c))"
    proof (rule summable_comparison_test_ev)
      show "\<forall>\<^sub>F k in sequentially.
            norm ((\<nu>' k + 2) powr (-?c)) \<le> (2 ^ (2 ^ k + 1)) powr (-?c)"
      proof (rule eventually_sequentiallyI[of 0])
        fix k
        have "(\<nu>' k + 2) powr (-?c) = inverse (\<nu>' k + 2) powr ?c"
          by (simp add: powr_minus inverse_powr)
        also have "... \<le> inverse (2 ^ (2 ^ k + 1)) powr ?c"
        proof (rule powr_mono2)
          show "0 \<le> inverse (\<nu>' k + 2)" by auto
          show "inverse (\<nu>' k + 2) \<le> inverse (2 ^ (2 ^ k + 1))"
            using exp_growth by (simp add: inverse_le_imp_le)
          show "0 \<le> ?c" using assms(2) by auto
        qed
        also have "... = (2 ^ (2 ^ k + 1)) powr (-?c)"
          by (simp add: powr_minus inverse_powr)
        finally show "norm ((\<nu>' k + 2) powr (-?c)) \<le> (2 ^ (2 ^ k + 1)) powr (-?c)"
          by auto
      qed
      have "summable (\<lambda>k. (2 powr (-?c)) ^ k)"
      proof (rule summable_geometric)
        show "norm (2 powr (-?c) :: real) < 1"
          using c_pos by (simp add: powr_less_one)
      qed
      moreover have "\<forall>\<^sub>F k in sequentially.
                      norm ((2 ^ (2 ^ k + 1)) powr (-?c)) \<le> (2 powr (-?c)) ^ k"
      proof (rule eventually_sequentiallyI[of 0])
        fix k
        have "(2 ^ (2 ^ k + 1)) powr (-?c) = inverse (2 ^ (2 ^ k + 1)) powr ?c"
          by (simp add: powr_minus inverse_powr)
        also have "... \<le> inverse (2 ^ k) powr ?c"
        proof (rule powr_mono2)
          show "0 \<le> inverse (2 ^ (2 ^ k + 1))" by auto
          show "inverse (2 ^ (2 ^ k + 1)) \<le> inverse (2 ^ k)"
            using pow2_ineq_real by (simp add: inverse_le_imp_le)
          show "0 \<le> ?c" using assms(2) by auto
        qed
        also have "... = (2 ^ k) powr (-?c)" by (simp add: powr_minus inverse_powr)
        also have "(2 ^ k) powr (-?c) = (2 powr (-?c)) ^ k"
          by (simp add: powr_powr mult.commute)
        finally show "norm ((2 ^ (2 ^ k + 1)) powr (-?c)) \<le> (2 powr (-?c)) ^ k"
          by auto
      qed
      ultimately show "summable (\<lambda>k. (2 ^ (2 ^ k + 1)) powr (-?c))"
        by (rule summable_comparison_test_ev)
    qed


    have summable_\<nu>_tail: "summable (\<lambda>j. (\<nu> (j + k0) + 2) powr (-?c))"
      using summable_\<nu>'_powr by (simp add: \<nu>'_def)
    have summable_\<nu>: "summable (\<lambda>k. (\<nu> k + 2) powr (-?c))"
      using summable_iff_shift[of "\<lambda>k. (\<nu> k + 2) powr (-?c)" k0] summable_\<nu>_tail by auto


    have pos_f: "\<forall>n. 0 \<le> real (delta x n) * (n + 2) powr (-?c)"
      by (auto intro!: mult_nonneg_nonneg powr_nonneg)
    {
      fix N
      define f where "f n = real (delta x n) * (n + 2) powr (-?c)" for n
      have "f n = (if n \<in> range \<nu> then (n + 2) powr (-?c) else 0)" for n
        using \<nu>(2) by (simp add: f_def)
      then have "sum f {..N} = sum (\<lambda>n. if n \<in> range \<nu> then (n + 2) powr (-?c) else 0) {..N}"
        by auto
      also have "... = sum (\<lambda>n. (n + 2) powr (-?c)) ({..N} \<inter> range \<nu>)"
        by (rule sum.inter_restrict[symmetric]) auto
      also have "{..N} \<inter> range \<nu> = \<nu> ` {k. \<nu> k \<le> N}"
        using \<nu>(1) strict_mono_less_eq by fastforce
      also have "sum (\<lambda>n. (n + 2) powr (-?c)) (\<nu> ` {k. \<nu> k \<le> N}) =
                 sum (\<lambda>k. (\<nu> k + 2) powr (-?c)) {k. \<nu> k \<le> N}"
        by (subst sum.reindex) (auto simp: \<nu>(1).inj_on)
      finally have "sum f {..N} = sum (\<lambda>k. (\<nu> k + 2) powr (-?c)) {k. \<nu> k \<le> N}" .
      moreover have "sum (\<lambda>k. (\<nu> k + 2) powr (-?c)) {k. \<nu> k \<le> N} \<le>
                     (\<Sum>k. (\<nu> k + 2) powr (-?c))"
        using sum_le_suminf[OF summable_\<nu>, of "{k. \<nu> k \<le> N}"]
        by (auto intro!: powr_nonneg)
      ultimately have "sum f {..N} \<le> (\<Sum>k. (\<nu> k + 2) powr (-?c))" by auto
    }
    with pos_f show "summable (\<lambda>n. real (delta x n) * (n + 2) powr (-?c))"
      by (intro summableI_nonneg_bounded[where A="(\<Sum>k. (\<nu> k + 2) powr (-?c))"]) auto
  qed
qed

end