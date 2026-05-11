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
  by (simp add: delta_def rem_def)

lemma rem_0 [simp]: "rem x 0 = x - real (delta x 0) * (1/2)"
  by (simp add: rem_def delta_def)

lemma rem_Suc [simp]:
    "rem x (Suc n) = rem x n - real (delta x (Suc n)) * (1 / real (Suc n + 2))"
  by (simp add: rem_def delta_def)

subsection "2. Basic properties of the greedy algorithm"

lemma delta_range: "delta x n ∈ {0, 1}"
  by (induction n) auto

lemma rem_nonneg:
  assumes "x ≥ 0"
  shows "rem x n ≥ 0"
proof (induction n)
  case 0
  show ?case
  proof (cases "x ≥ 1/2")
    case True  then show ?thesis using assms by simp
    case False then show ?thesis using assms by simp
  qed
next
  case (Suc n)
  show ?case
  proof (cases "rem x n ≥ 1 / real (Suc n + 2)")
    case True
      then have "delta x (Suc n) = 1" by simp
      hence "rem x (Suc n) = rem x n - 1 / real (Suc n + 2)" by simp
      with True show ?thesis by linarith
    case False
      then have "delta x (Suc n) = 0" by simp
      hence "rem x (Suc n) = rem x n" by simp
      with Suc show ?thesis by simp
  qed
qed

lemma rem_bound_weak:
  assumes "x ∈ {0..1}"
  shows "rem x n ≤ 1 / real (n + 2)"
proof (induction n)
  case 0
  show ?case
  proof (cases "x ≥ 1/2")
    case True
      then have "delta x 0 = 1" by simp
      hence "rem x 0 = x - 1/2" by simp
      with assms True show ?thesis by auto
    case False
      then have "delta x 0 = 0" by simp
      hence "rem x 0 = x" by simp
      with assms False show ?thesis by auto
  qed
next
  case (Suc n)
  note IH = Suc
  show ?case
  proof (cases "rem x n ≥ 1 / real (Suc n + 2)")
    case True
      then have sel: "delta x (Suc n) = 1" by simp
      hence eq: "rem x (Suc n) = rem x n - 1 / real (Suc n + 2)" by simp
      have bound: "rem x n ≤ 1 / real (n + 2)" using IH by simp
      have arith: "1 / real (n + 2) ≤ 2 / real (Suc n + 2)"
      proof -
        have pos1: "0 < real (n + 2)" by simp
        have pos2: "0 < real (Suc n + 2)" by simp
        have "1 * real (Suc n + 2) ≤ 2 * real (n + 2)" by (simp add: field_simps)
        with frac_le[OF pos1 pos2] show ?thesis by (simp add: mult.commute)
      qed
      from bound arith eq have "rem x (Suc n) ≤ 2 / real (Suc n + 2) - 1 / real (Suc n + 2)" by linarith
      thus ?thesis by (simp add: field_simps)
    case False
      then have "delta x (Suc n) = 0" by simp
      hence "rem x (Suc n) = rem x n" by simp
      with False show ?thesis by simp
  qed
qed

lemma rem_bound_after_selection:
  assumes "x ∈ {0..1}" "delta x (Suc n) = 1"
  shows "rem x (Suc n) ≤ 1 / (real (Suc n + 1) * real (Suc n + 2))"
proof -
  from assms(2) have cond: "rem x n ≥ 1 / real (Suc n + 2)" by simp
  from assms(2) have eq: "rem x (Suc n) = rem x n - 1 / real (Suc n + 2)" by simp
  have ub: "rem x n ≤ 1 / real (n + 2)"
    using rem_bound_weak[OF assms(1)] by simp
  have "real (n + 2) = real (Suc n + 1)" by (simp add: of_nat_Suc)
  hence "rem x n ≤ 1 / real (Suc n + 1)" using ub by simp
  hence "rem x (Suc n) ≤ 1 / real (Suc n + 1) - 1 / real (Suc n + 2)"
    using eq by linarith
  also have "1 / real (Suc n + 1) - 1 / real (Suc n + 2)
           = 1 / (real (Suc n + 1) * real (Suc n + 2))"
    by (simp add: field_simps)
  finally show ?thesis .
qed

subsection "3. The finite partial‑sum identity"

lemma greedy_sum_finite:
  shows "x = (∑ k ≤ N. real (delta x k) / real (k + 2)) + rem x N"
proof (induction N)
  case 0
  show ?case
    by (cases "x ≥ 1/2") (auto simp: delta_0 rem_0)
next
  case (Suc N)
  have "x = (∑ k ≤ N. real (delta x k) / real (k + 2)) + rem x N"
    using Suc.IH by simp
  also have "rem x N
    = real (delta x (Suc N)) / real (Suc N + 2) + rem x (Suc N)"
  proof (cases "rem x N ≥ 1 / real (Suc N + 2)")
    case True
      then have "delta x (Suc N) = 1" by simp
      thus ?thesis by (simp add: field_simps)
    case False
      then have "delta x (Suc N) = 0" by simp
      thus ?thesis by simp
  qed
  finally show ?case
    by (simp add: sum.atMost_Suc algebra_simps)
qed

subsection "4. Remainder vanishes"

lemma rem_tendsto_zero:
  assumes "x ∈ {0..1}"
  shows "(λN. rem x N) ⇢ 0"
proof (rule tendsto_sandwich)
  show "∀⇩F N in sequentially. (0 : real) ≤ rem x N"
    using rem_nonneg[of x] assms by (simp add: eventually_sequentially)
  show "(λN. 1 / real (N + 2)) ⇢ 0"
  proof -
    have "(λN. 1 / real (N + 2)) = (λN. inverse (real N + 2))"
      by (simp add: inverse_eq_divide)
    also have "… ⇢ 0"
      by (intro tendsto_inverse_0_at_top filterlim_at_top_add_const)
         (simp add: filterlim_real_sequentially)
    finally show ?thesis .
  qed
  show "∀⇩F N in sequentially. rem x N ≤ 1 / real (N + 2)"
    using rem_bound_weak[OF assms] by (simp add: eventually_sequentially)
  show "(λ_. 0 :: real) ⇢ 0" by simp
qed

subsection "5. Convergence of the greedy harmonic expansion"

theorem greedy_harmonic_expansion:
  assumes "x ∈ {0..1}"
  shows "x = (∑ n. real (delta x n) / real (n + 2))"
proof -
  have nonneg: "∀n. 0 ≤ real (delta x n) / real (n + 2)"
    by (auto simp: delta_range divide_nonneg_nonneg)
  have sum_eq: "∀N. (∑k≤N. real (delta x k) / real (k + 2)) = x - rem x N"
    using greedy_sum_finite[of x] by linarith
  have bounded: "∀N. (∑k≤N. real (delta x k) / real (k + 2)) ≤ x"
    using sum_eq rem_nonneg[OF assms[THEN atLeastAtMost_iff(1)]] by simp
  have summable: "summable (λn. real (delta x n) / real (n + 2))"
    by (intro summableI_nonneg_bounded[where A=x] nonneg bounded)
  then have S: "(∑n. real (delta x n) / real (n + 2)) =
                lim (λN. ∑k≤N. real (delta x k) / real (k + 2))"
    by (simp add: suminf_eq_lim)
  have "lim (λN. ∑k≤N. real (delta x k) / real (k + 2)) = x"
  proof (rule tendsto_unique)
    show "(λN. ∑k≤N. real (delta x k) / real (k + 2)) ⇢ x"
    proof -
      have "(λN. x - rem x N) = (λN. ∑k≤N. real (delta x k) / real (k + 2))"
        using sum_eq by fastforce
      moreover have "(λN. x - rem x N) ⇢ x"
        using rem_tendsto_zero[OF assms] tendsto_const by (intro tendsto_diff) auto
      ultimately show ?thesis by simp
    qed
    show "(λN. ∑k≤N. real (delta x k) / real (k + 2)) ⇢
          suminf (λn. real (delta x n) / real (n + 2))"
      using summable_LIMSEQ[OF summable] .
  qed simp
  with S show ?thesis by simp
qed

subsection "6. Super‑exponential growth of selected indices"

lemma rem_eq_between_selections:
  assumes "∀k. n < k ∧ k ≤ j ⟶ delta x k = 0" "n ≤ j"
  shows "rem x j = rem x n"
proof -
  obtain d where d: "j = n + d" using assms(2) by (metis le_iff_add)
  have "rem x (n + d) = rem x n"
  proof (induction d)
    case 0 show ?case by simp
    case (Suc d)
      have "rem x (n + Suc d) = rem x (n + d) -
            real (delta x (n + Suc d)) * (1 / real (n + Suc d + 2))"
        by simp
      also have "delta x (n + Suc d) = 0"
      proof -
        from d have "n + Suc d ≤ j" by auto
        moreover have "n < n + Suc d" by simp
        ultimately show ?thesis using assms(1) by auto
      qed
      finally show ?case by (simp add: Suc.IH)
  qed
  with d show ?thesis by simp
qed

theorem selected_growth:
  assumes "x ∈ {0..1}"
          "delta x (Suc n) = 1"  ― ‹selection at index Suc n ≥ 1›
          "delta x m = 1"         ― ‹next selection at m›
          "m > Suc n"             ― ‹strictly later›
          "∀k. Suc n < k ∧ k < m ⟶ delta x k = 0"  ― ‹nothing in between›
  shows "m ≥ Suc n * n"
proof -
  let ?p = "Suc n"
  ― ‹After selecting at ?p, the remainder is at most 1/((p+1)(p+2))›
  have rem_tight: "rem x ?p ≤ 1 / (real (?p + 1) * real (?p + 2))"
    using rem_bound_after_selection[OF assms(1) assms(2)] by simp
  ― ‹rem stable between ?p and m-1›
  have no_gap: "rem x (m - 1) = rem x ?p"
  proof (rule rem_eq_between_selections)
    show "?p ≤ m - 1" using assms(4) by omega
    fix k assume H: "?p < k ∧ k ≤ m - 1"
    hence "?p < k ∧ k < m" by omega
    thus "delta x k = 0" using assms(5) by simp
  qed
  ― ‹The greedy condition at m: rem x (m-1) ≥ 1/(m+2)›
  have sel_cond: "rem x (m - 1) ≥ 1 / real (m + 2)"
  proof -
    have "delta x m = 1" using assms(3) by simp
    obtain k where "m = Suc k"
      using Nat.not_zero_eq_nat assms(4) by (cases m) simp_all
    hence "rem x (m - 1) ≥ 1 / real (Suc k + 2)"
      using assms(3) ‹m = Suc k› by simp
    thus ?thesis using ‹m = Suc k› by simp
  qed
  ― ‹Combining: 1/(m+2) ≤ rem x ?p ≤ 1/((p+1)(p+2))›
  have ineq: "1 / real (m + 2) ≤ 1 / (real (?p + 1) * real (?p + 2))"
    using no_gap rem_tight sel_cond by linarith
  ― ‹Hence (p+1)(p+2) ≤ m+2, i.e., m ≥ (p+1)(p+2) - 2 = p²+3p ≥ p(p-1) = Suc n * n›
  have pos: "(0 : real) < real (?p + 1) * real (?p + 2)" by linarith
  have pos2: "(0 : real) < real (m + 2)" by linarith
  from ineq have "(real (?p + 1) * real (?p + 2)) ≤ real (m + 2)"
    using frac_le[OF pos pos2] by (simp add: field_simps)
  hence "real (?p + 1) * real (?p + 2) ≤ real m + 2" by (simp add: field_simps)
  hence "(real ?p + 1) * (real ?p + 2) ≤ real m + 2" by (simp add: field_simps)
  hence "real ?p ^ 2 + 3 * real ?p ≤ real m" by (simp add: field_simps; linarith)
  ― ‹p²+3p ≥ p(p-1) when p ≥ 0›
  have "real ?p ^ 2 + 3 * real ?p ≥ real ?p * (real ?p - 1)" by nlinarith
  hence "real (?p * (?p - 1)) ≤ real m"
    by (simp add: field_simps; linarith)
  thus "m ≥ Suc n * n" by (simp add: field_simps; omega)
qed

lemma pow2_ineq_nat: "2 ^ (2 ^ k + 1) ≥ (2::nat) ^ k"
proof (induction k)
  case 0 show ?case by simp
  case (Suc k)
    have "2 ^ (2 ^ Suc k + 1) = 2 ^ (2 * 2 ^ k + 1)" by simp
    also have "… = 2 * 2 ^ (2 * 2 ^ k)" by (simp add: power_add)
    also have "2 ^ (2 * 2 ^ k) = (2 ^ (2 ^ k)) ^ 2" by (simp add: power_mult)
    also have "… ≥ 2 ^ (2 ^ k)" by (simp add: power2_eq_square)
    also have "… ≥ 2 ^ k" using Suc.IH by simp
    also have "2 ^ k ≥ k" by simp
    finally show ?case by simp
qed

lemma pow2_ineq_real: "real (2 ^ (2 ^ k + 1)) ≥ real (2 ^ k)"
  using pow2_ineq_nat by auto

lemma summable_delta_powr:
  fixes x :: real and s :: complex
  assumes "x ∈ {0..1}" "Re s > 0"
  shows "summable (λn. real (delta x n) * (n + 2) powr (-Re s))"
proof -
  let ?c = "Re s"
  from assms(2) have c_pos: "?c > 0" by simp
  show ?thesis
  proof (cases "finite {n. delta x n = 1}")
    case True
    then show ?thesis by (auto intro!: summable_finite)
  next
    case False
    obtain ν where ν: "strict_mono ν" "∀k. delta x (ν k) = 1"
                 and ν_range: "∀n. delta x n = 1 ⟶ n ∈ range ν"
      using False infinite_enumerate by blast
    ― ‹We need a starting index where ν k is at least 4, so that the double‑exponential growth
    can be proved.›
    have "∃k0. ν k0 ≥ 4"
    proof (rule ccontr)
      assume "∄k0. ν k0 ≥ 4"
      then have "∀k. ν k < 4" by auto
      with ν(1) have "∀k. ν k ≤ 3" by (metis less_2_cases not_less)
      then have "{n. delta x n = 1} ⊆ {0,1,2,3}" using ν_range by auto
      with False show False by simp
    qed
    then obtain k0 where k0: "ν k0 ≥ 4" by auto
    define ν' where "ν' k = ν (k + k0)" for k
    have ν'_strict: "strict_mono ν'" using ν(1) by (simp add: strict_mono_def ν'_def)
    have ν'_sel: "∀k. delta x (ν' k) = 1" using ν(2) by (simp add: ν'_def)
    have ν'_base: "ν' 0 ≥ 4" using k0 by (simp add: ν'_def)

    ― ‹Quadratic growth between consecutive selections›
    have growth: "∀k. ν' (Suc k) ≥ ν' k * (ν' k - 1)"
    proof
      fix k
      from ν'_sel have "delta x (ν' k) = 1" "delta x (ν' (Suc k)) = 1" by auto
      moreover have "ν' (Suc k) > ν' k" using ν'_strict by (simp add: strict_mono_Suc_iff)
      moreover have "∀i. ν' k < i ∧ i < ν' (Suc k) ⟶ delta x i = 0"
        using ν(2) ν'_def strict_mono_less[OF ν(1)] by auto
      ultimately show "ν' (Suc k) ≥ ν' k * (ν' k - 1)"
        using selected_growth[OF assms(1), of "ν' k - 1"] ‹ν' k ≥ 4›
        by (metis Suc_diff_1 diff_Suc_1 less_or_eq_imp_le)
    qed

    ― ‹By induction, the selected indices grow at least like \(2^{2^k+1}\)›
    have exp_growth: "∀k. ν' k ≥ 2 ^ (2 ^ k + 1)"
    proof
      fix k show "ν' k ≥ 2 ^ (2 ^ k + 1)"
      proof (induction k)
        case 0
        show ?case using ν'_base by simp
      next
        case (Suc k)
        have "ν' (Suc k) ≥ ν' k * (ν' k - 1)" using growth by blast
        also have "ν' k - 1 ≥ ν' k / 2"
        proof -
          from Suc.IH have "ν' k ≥ 2" by force
          thus ?thesis by linarith
        qed
        hence "ν' k * (ν' k - 1) ≥ ν' k * (ν' k / 2)" by (auto intro: mult_left_mono)
        also have "… = (ν' k)^2 / 2" by (simp add: power2_eq_square)
        also have "… ≥ (2 ^ (2 ^ k + 1))^2 / 2"
          using Suc.IH by (intro divide_right_mono power_mono) auto
        also have "… = 2 ^ (2 * (2 ^ k + 1) - 1)"
          by (simp add: power_add power_mult)
        also have "2 * (2 ^ k + 1) - 1 = 2 ^ (k + 1) + 1"
          by (simp add: add.commute)
        finally show ?case by simp
      qed
    qed

    have summable_ν'_powr: "summable (λk. (ν' k + 2) powr (-?c))"
    proof (rule summable_comparison_test_ev)
      show "∀⇩F k in sequentially.
            norm ((ν' k + 2) powr (-?c)) ≤ (2 ^ (2 ^ k + 1)) powr (-?c)"
      proof
        fix k
        have "(ν' k + 2) powr (-?c) = ((ν' k + 2)⁻¹) powr ?c"
          by (simp add: powr_minus_divide)
        also have "… ≤ ((2 ^ (2 ^ k + 1))⁻¹) powr ?c"
        proof (rule powr_mono2)
          show "0 ≤ inverse (ν' k + 2)" by simp
          show "inverse (ν' k + 2) ≤ inverse (2 ^ (2 ^ k + 1))"
            using exp_growth by (simp add: inverse_le_imp_le)
          show "0 ≤ ?c" using assms(2) by simp
        qed
        also have "… = (2 ^ (2 ^ k + 1)) powr (-?c)"
          by (simp add: powr_minus_divide)
        finally show "norm ((ν' k + 2) powr (-?c)) ≤ (2 ^ (2 ^ k + 1)) powr (-?c)"
          by simp
      qed

      have "summable (λk. (2 powr (-?c)) ^ k)"
      proof (rule summable_geometric)
        show "norm (2 powr (-?c) :: real) < 1"
          using c_pos by (simp add: powr_less_one)
      qed
      moreover have "∀⇩F k in sequentially.
                      norm ((2 ^ (2 ^ k + 1)) powr (-?c)) ≤ (2 powr (-?c)) ^ k"
      proof (rule eventually_sequentiallyI[of 0])
        fix k
        have "(2 ^ (2 ^ k + 1)) powr (-?c) = ((2 ^ (2 ^ k + 1))⁻¹) powr ?c"
          by (simp add: powr_minus_divide)
        also have "… ≤ ((2 ^ k)⁻¹) powr ?c"
        proof (rule powr_mono2)
          show "0 ≤ inverse (2 ^ (2 ^ k + 1))" by simp
          show "inverse (2 ^ (2 ^ k + 1)) ≤ inverse (2 ^ k)"
            using pow2_ineq_real by (simp add: inverse_le_imp_le)
          show "0 ≤ ?c" using assms(2) by simp
        qed
        also have "… = (2 ^ k) powr (-?c)" by (simp add: powr_minus_divide)
        also have "(2 ^ k) powr (-?c) = (2 powr (-?c)) ^ k"
          by (simp add: powr_powr mult.commute)
        finally show "norm ((2 ^ (2 ^ k + 1)) powr (-?c)) ≤ (2 powr (-?c)) ^ k"
          by simp
      qed
      ultimately show "summable (λk. norm ((2 ^ (2 ^ k + 1)) powr (-?c)))"
        by (rule summable_comparison_test_ev)
    qed

    ― ‹Now sum over the full selection stream ν›
    have summable_ν_tail: "summable (λj. (ν (j + k0) + 2) powr (-?c))"
      using summable_ν'_powr by (simp add: ν'_def)
    have summable_ν: "summable (λk. (ν k + 2) powr (-?c))"
      using summable_iff_shift[of "λk. (ν k + 2) powr (-?c)" k0] summable_ν_tail by simp

    ― ‹Transfer summability to the original sequence,
       which vanishes outside the range of ν›
    have pos_f: "∀n. 0 ≤ real (delta x n) * (n + 2) powr (-?c)"
      by (auto intro!: mult_nonneg_nonneg powr_nonneg)
    {
      fix N
      define f where "f n = real (delta x n) * (n + 2) powr (-?c)" for n
      have "f n = (if n ∈ range ν then (n + 2) powr (-?c) else 0)" for n
        using ν(2) by (simp add: f_def)
      then have "sum f {..N} = sum (λn. if n ∈ range ν then (n + 2) powr (-?c) else 0) {..N}"
        by simp
      also have "… = sum (λn. (n + 2) powr (-?c)) ({..N} ∩ range ν)"
        by (rule sum.inter_restrict[symmetric]) auto
      also have "{..N} ∩ range ν = ν ` {k. ν k ≤ N}"
        using ν(1) strict_mono_less_eq by fastforce
      also have "sum (λn. (n + 2) powr (-?c)) (ν ` {k. ν k ≤ N}) =
                 sum (λk. (ν k + 2) powr (-?c)) {k. ν k ≤ N}"
        by (subst sum.reindex) (auto simp: ν(1).inj_on)
      finally have "sum f {..N} = sum (λk. (ν k + 2) powr (-?c)) {k. ν k ≤ N}" .
      moreover have "sum (λk. (ν k + 2) powr (-?c)) {k. ν k ≤ N} ≤
                     (∑k. (ν k + 2) powr (-?c))"
        using sum_le_suminf[OF summable_ν, of "{k. ν k ≤ N}"]
        by (auto intro!: powr_nonneg)
      ultimately have "sum f {..N} ≤ (∑k. (ν k + 2) powr (-?c))" by simp
    }
    with pos_f show "summable (λn. real (delta x n) * (n + 2) powr (-?c))"
      by (intro summableI_nonneg_bounded[where A="(∑k. (ν k + 2) powr (-?c))"]) auto
  qed
qed

end