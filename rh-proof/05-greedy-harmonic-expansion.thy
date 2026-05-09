theory Greedy_Harmonic_Expansion
  imports Complex_Main
begin

section ‹Greedy Harmonic Expansion and Super‑Exponential Growth›

text ‹
  We formalise the greedy harmonic expansion of a number \(x \in [0,1]\).
  The fractions used are \(\frac1{n+2}\) for \(n=0,1,2,\dots\).
  The algorithm selects a binary sequence \(\delta_n \in \{0,1\}\) such that
  \[ x = \sum_{n=0}^\infty \frac{\delta_n}{n+2}, \]
  with the greedy rule: at step \(n\), choose \(\delta_n = 1\) if the remaining
  part is at least \(\frac1{n+2}\), else \(0\).
›

subsection ‹The greedy algorithm›

fun δ :: "real ⇒ nat ⇒ nat" where
  "δ x 0 = (if x ≥ 1/2 then 1 else 0)"
| "δ x (Suc n) = (if r x n ≥ 1/(Suc n + 2) then 1 else 0)"

fun r :: "real ⇒ nat ⇒ real" where
  "r x 0 = x - (δ x 0) * (1/2)"
| "r x (Suc n) = r x n - (δ x (Suc n)) * (1/(Suc n + 2))"

subsection ‹Basic properties›

lemma δ_range: "δ x n ∈ {0,1}"
  by (induction n) auto

lemma r_nonneg:
  assumes "x ≥ 0"
  shows "r x n ≥ 0"
proof (induction n)
  case 0
  then show ?case using assms by (cases "x ≥ 1/2") auto
next
  case (Suc n)
  then show ?case by (cases "r x n ≥ 1/(Suc n + 2)") auto
qed

text ‹
  The key estimate: for \(x\in[0,1]\) the remainder after step \(n\) is bounded by \(1/(n+2)\).
›

lemma r_bound_weak:
  assumes "x ∈ {0..1}"
  shows "r x n ≤ 1 / real (n + 2)"
proof (induction n)
  case 0
  show ?case
  proof (cases "x ≥ 1/2")
    case True
    then have "δ x 0 = 1" by simp
    hence "r x 0 = x - 1/2" by simp
    with assms True show ?thesis by auto
  next
    case False
    then have "δ x 0 = 0" by simp
    hence "r x 0 = x" by simp
    with assms False show ?thesis by auto
  qed
next
  case (Suc n)
  note IH = Suc
  show ?case
  proof (cases "r x n ≥ 1 / real (Suc n + 2)")
    case True
    then have sel: "δ x (Suc n) = 1" by simp
    hence eq: "r x (Suc n) = r x n - 1 / real (Suc n + 2)" by simp
    ― ‹From the induction hypothesis we have \(r x n \le 1/(n+2)\).
        Because \(1/(n+2) \le 2/(Suc n+2)\) (easy arithmetic), we get
        \(r x (Suc n) \le 2/(Suc n+2) - 1/(Suc n+2) = 1/(Suc n+2)\).›
    have bound: "r x n ≤ 1 / real (n + 2)" using IH by simp
    have arith: "1 / real (n + 2) ≤ 2 / real (Suc n + 2)"
    proof -
      have "real (Suc n + 2) ≤ 2 * real (n + 2)"
        by (simp add: of_nat_Suc add.commute)
      thus ?thesis
        by (simp add: divide_le_cancel field_simps)
    qed
    from bound arith eq have "r x (Suc n) ≤ 2 / real (Suc n + 2) - 1 / real (Suc n + 2)"
      by linarith
    thus ?thesis by (simp add: field_simps)
  next
    case False
    then have "δ x (Suc n) = 0" by simp
    hence "r x (Suc n) = r x n" by simp
    with False show ?thesis by simp
  qed
qed

subsection ‹Representation as an infinite sum›

lemma greedy_sum:
  fixes x :: real and N :: nat
  shows "x = (∑ n≤N. (real (δ x n)) / (n+2)) + r x N"
proof (induction N)
  case 0
  show ?case by (cases "x ≥ 1/2") auto
next
  case (Suc N)
  have "x = (∑ n≤N. (real (δ x n)) / (n+2)) + r x N" using Suc by simp
  also have "r x N = (real (δ x (Suc N))) / (Suc N + 2) + r x (Suc N)"
    by (cases "r x N ≥ 1/(Suc N + 2)") auto
  finally show ?case by (simp add: sum.atMost_Suc algebra_simps)
qed

text ‹The remainder tends to zero, therefore the infinite sum converges to \(x\).›

lemma remainder_vanishes:
  fixes x :: real
  assumes "x ∈ {0..1}"
  shows "(λn. r x n) ⇢ 0"
proof -
  have nonneg: "∀n. r x n ≥ 0" using assms r_nonneg by auto
  have decr: "decseq (r x)"
    by (intro monotoneI) (auto simp: r.simps split: if_splits)
  obtain L where "L ≥ 0" and lim: "(λn. r x n) ⇢ L"
    using decseq_convergent[OF nonneg decr] by auto
  from greedy_sum[of x n] have "r x n = x - (∑ k≤n. real (δ x k) / (k+2))" for n
    by (simp add: algebra_simps)
  hence "L = x - (∑ k. real (δ x k) / (k+2))"
    using lim by (auto dest!: LIMSEQ_unique)
  moreover have "summable (λk. real (δ x k) / (k+2))"
    by (rule summable_comparison_test_ev[OF _ _])
       (auto intro!: summable_norm_comparison_test simp: δ_range)
  ultimately have "L = 0"
  proof -
    have "x ≤ 1" using assms by auto
    from greedy_sum[of x "Suc N"] have "x = (∑ n ≤ Suc N. real (δ x n) / (n+2)) + r x (Suc N)" .
    also have "… ≥ (∑ n≤N. real (δ x n) / (n+2))" using nonneg[rule_format, of "Suc N"] by auto
    hence "∀N. (∑ n≤N. real (δ x n) / (n+2)) ≤ x" by linarith
    with lim have "x - L ≥ 0" by (intro tendsto_lowerbound) (auto simp: LIMSEQ_def)
    with `L ≥ 0` `x ∈ {0..1}` show ?thesis by force
  qed
  with lim show ?thesis by simp
qed

theorem greedy_harmonic_expansion:
  fixes x :: real
  assumes "x ∈ {0..1}"
  shows "x = (∑ n. (real (δ x n)) / (n+2))"
proof -
  have "x = (∑ n≤N. (real (δ x n)) / (n+2)) + r x N" for N by (rule greedy_sum)
  moreover have "(λN. r x N) ⇢ 0" using remainder_vanishes[OF assms] .
  ultimately show ?thesis
    using summable_LIMSEQ[of "λn. (real (δ x n)) / (n+2)"] by auto
qed

subsection ‹Remainder after a selection›

text ‹
  When \(\delta_n = 1\) (with \(n\ge 1\)), the remainder after step \(n\) satisfies
  \[ r_n \le \frac1{(n+1)(n+2)}. \]
  This sharper bound is crucial for the super‑exponential growth of the selected indices.
›

lemma rem_bound_after_selection:
  fixes x :: real and n :: nat
  assumes "x ∈ {0..1}" "δ x n = 1" "n ≥ 1"
  shows "r x n ≤ 1 / (real (n+1) * real (n+2))"
proof -
  have prev_r: "r x (n-1) ≥ 1 / (n+2)"
  proof (cases n)
    case 0
    with assms(3) show ?thesis by simp
  next
    case (Suc n')
    have "δ x (Suc n') = 1" using assms(2) Suc by simp
    then show ?thesis by (auto simp: Suc)
  qed
  have prev_bound: "r x (n-1) ≤ 1 / (n+1)"
    using r_bound_weak[OF assms(1), of "n-1"]
    by (simp add: add.commute)
  have "r x n = r x (n-1) - (δ x n) * (1 / (n+2))"
    by (cases n) (auto simp: r.simps)
  also have "… = r x (n-1) - 1 / (n+2)" using assms(2) by simp
  also have "… ≤ 1 / (n+1) - 1 / (n+2)"
    using prev_bound by linarith
  also have "… = 1 / (real (n+1) * real (n+2))"
    by (field_simp; ring)
  finally show ?thesis .
qed

subsection ‹Stability of the remainder between selections›

lemma r_stable_between_selections:
  fixes x :: real
  assumes "∀k. n < k ∧ k ≤ j ⟶ δ x k = 0" "n ≤ j"
  shows "r x j = r x n"
proof -
  have "∀d. r x (n + d) = r x n"
  proof
    fix d
    show "r x (n + d) = r x n"
    proof (induction d)
      case 0
      show ?case by simp
    next
      case (Suc d)
      have "r x (Suc (n + d)) = r x (n + d) - real (δ x (Suc (n + d))) * (1 / real (Suc (n + d) + 2))"
        by simp
      moreover have "δ x (Suc (n + d)) = 0"
        using assms(1) by (auto; omega)
      ultimately show ?case using Suc by simp
    qed
  qed
  then have "r x (n + (j - n)) = r x n" by blast
  with assms(2) show ?thesis by simp
qed

subsection ‹Super‑exponential growth of selected indices›

text ‹
  Let the selected indices be \(n_1 < n_2 < \dots\).  For any selected index \(n \ge 2\),
  the next selected index \(m > n\) satisfies \(m \ge n(n-1)\).
›

lemma next_selected_index_super_exponential:
  fixes x :: real and n :: nat
  assumes "x ∈ {0..1}" "δ x n = 1" "n ≥ 2"
  shows "∃m>n. δ x m = 1 ∧ m ≥ n * (n - 1)"
proof -
  have r_bound: "r x n ≤ 1 / (real (n+1) * real (n+2))"
    by (rule rem_bound_after_selection[OF assms(1,2)]) (use assms(3) in auto)
  ― ‹Because the remainder tends to zero but never becomes negative, there will be a
      further selection at some index \(m>n\).  Take the first such one.›
  have "∃m>n. δ x m = 1"
  proof (rule ccontr)
    assume no: "∄m>n. δ x m = 1"
    then have "∀k>n. δ x k = 0" by auto
    then have "∀k≥n. r x k = r x n"
      using r_stable_between_selections[of n k x] by auto
    then have "(λk. r x k) ⇢ r x n"
      using LIMSEQ_const by auto
    with remainder_vanishes[OF assms(1)] have "r x n = 0" by (simp add: LIMSEQ_unique)
    have "r x (n-1) = r x n + 1/(n+2)"
      using assms(2) by (cases n) (auto simp: r.simps)
    with `r x n = 0` have "r x (n-1) = 1/(n+2)" by simp
    have "r x (n-1) < 1" by (use r_bound_weak[OF assms(1), of "n-1"] in linarith)
    with `r x (n-1) = 1/(n+2)` show False by auto
  qed
  obtain m where m: "m > n" "δ x m = 1"
    and m_min: "∀k∈{n<..<m}. δ x k = 0"
    using `∃m>n. δ x m = 1` by (auto intro!: ex_least_nat_le)
  ― ‹Because no digit is selected between \(n\) and \(m-1\), the remainder does
      not change until the step before the next selection.›
  have r_m1: "r x (m-1) = r x n"
  proof (rule r_stable_between_selections)
    show "∀k. n < k ∧ k ≤ m-1 ⟶ δ x k = 0"
      using m_min m(1) by (auto; omega)
    show "n ≤ m-1" using m(1) by omega
  qed
  ― ‹The greedy condition for the selection at \(m\) yields \(r_{m-1} \ge 1/(m+2)\).›
  have sel_cond: "r x (m-1) ≥ 1 / (m+2)"
  proof (cases m)
    case 0
    with m(1) show ?thesis by simp
  next
    case (Suc k)
    have "δ x (Suc k) = 1" using m(2) Suc by simp
    then show ?thesis using Suc by (auto split: if_splits)
  qed
  with r_m1 have ineq: "1 / (m+2) ≤ r x n" by simp
  with r_bound have "1 / (m+2) ≤ 1 / (real (n+1) * real (n+2))" by linarith
  hence "real (n+1) * real (n+2) ≤ real (m+2)"
    by (simp add: divide_le_divide_iff_of_nat)
  hence "m ≥ real (n+1) * real (n+2) - 2"
    by linarith
  have "real (n+1) * real (n+2) - 2 = real (n^2 + 3*n)"
    by (simp add: power2_eq_square algebra_simps)
  also have "… ≥ real (n * (n - 1))"
    using `n ≥ 2` by (auto intro: mono_intros)
  finally show ?thesis
    using m(1,2) by (intro exI[of _ m]) auto
qed

text ‹
  Let \((\nu_k)\) be the strictly increasing enumeration of the selected indices.
  The previous lemma implies that \(\nu_{k+1} \ge \nu_k(\nu_k-1)\) whenever \(\nu_k \ge 2\).
›

theorem selected_indices_super_exponential:
  fixes x :: real and ν :: "nat ⇒ nat"
  assumes "x ∈ {0..1}" "strict_mono ν" "∀k. δ x (ν k) = 1"
  assumes base: "ν 0 ≥ 2"
  shows "ν (Suc k) ≥ ν k * (ν k - 1)" for k
proof -
  have "∀k. ν 0 ≤ ν k" by (simp add: assms(2) strict_mono_less_eq)
  then have "ν k ≥ 2" using base by auto
  have "δ x (ν k) = 1" using assms(3) by blast
  obtain m where "m > ν k" "δ x m = 1" "m ≥ ν k * (ν k - 1)"
    using next_selected_index_super_exponential[OF assms(1) `δ x (ν k) = 1` `ν k ≥ 2`]
    by blast
  with strict_mono_Suc_le[OF assms(2)] have "ν (Suc k) ≥ m"
    by (smt (verit, best) LeastI_ex assms(3) order_less_trans)
  with `m ≥ ν k * (ν k - 1)` show "ν (Suc k) ≥ ν k * (ν k - 1)" by simp
qed

subsection ‹Summability of the weighted series›

text ‹
  As a direct consequence of the super‑exponential spacing, the series
  \(\sum_{n} \delta_n(x) (n+2)^{-s}\) converges absolutely for every complex
  \(s\) with \(\Re s > 0\).  This makes the Greedy Dirichlet Sub‑Sum Transform
  an analytic function on the right half‑plane.
›

lemma summable_delta_powr:
  fixes x :: real and s :: complex
  assumes "x ∈ {0..1}" "Re s > 0"
  shows "summable (λn. norm ((if δ x n = 1 then 1 else 0) * (of_nat (n+2)) powr (-s)))"
        (is "summable ?a")
proof -
  let ?c = "Re s"
  have "?c > 0" using assms(2) by auto
  have norm_eq: "⋀n. norm (?a n) = real (δ x n) * (real n + 2) powr (-?c)"
    by (simp add: norm_mult norm_powr_real_powr)

  have "finite {n. δ x n = 1} ∨ (∃ν. strict_mono ν ∧ (∀k. δ x (ν k) = 1) ∧ (∀n. δ x n = 1 ⟶ n ∈ range ν))"
    by (cases "finite {n. δ x n = 1}"; auto intro: infinite_enumerate)
  moreover
  { assume fin: "finite {n. δ x n = 1}"
    then have "summable ?a"
      by (auto intro!: summable_finite simp: norm_eq)
  }
  moreover
  { assume inf: "infinite {n. δ x n = 1}"
    obtain ν where ν: "strict_mono ν" "∀k. δ x (ν k) = 1"
      and ν_range: "∀n. δ x n = 1 ⟶ n ∈ range ν"
      using inf infinite_enumerate by blast
    have "∃k0. ν k0 ≥ 2"
    proof (rule ccontr)
      assume "∄k0. ν k0 ≥ 2"
      then have "∀k. ν k < 2" by auto
      with ν(1) have "∀k. ν k ≤ 1" by (metis less_2_cases not_less)
      then have "{n. δ x n = 1} ⊆ {0,1}" using ν_range by auto
      with inf show False by simp
    qed
    then obtain k0 where k0: "ν k0 ≥ 2" by auto
    define ν' where "ν' k = ν (k + k0)" for k
    have ν'_strict: "strict_mono ν'" using ν(1) by (simp add: strict_mono_def ν'_def)
    have ν'_sel: "∀k. δ x (ν' k) = 1" using ν(2) by (simp add: ν'_def)
    have ν'_base: "ν' 0 ≥ 2" using k0 by (simp add: ν'_def)
    have growth: "∀k. ν' (Suc k) ≥ ν' k * (ν' k - 1)"
      using selected_indices_super_exponential[OF assms(1) ν'_strict ν'_sel ν'_base] .

    text ‹From this recurrence we prove inductively that \(\nu'_k \ge 2^{2^k}\).›
    have exp_growth: "∀k. ν' k ≥ 2 ^ (2 ^ k)"
    proof
      fix k
      show "ν' k ≥ 2 ^ (2 ^ k)"
      proof (induction k)
        case 0
        show ?case using ν'_base by simp
      next
        case (Suc k)
        have "ν' k ≥ 2" by (metis Suc.IH le_numeral_extra(4) one_le_power power_one_right)
        then have "ν' (Suc k) ≥ ν' k * (ν' k - 1)"
          using growth[rule_format, of k] by blast
        also have "… ≥ (ν' k)^2 / 2"
        proof -
          from `ν' k ≥ 2` have "ν' k - 1 ≥ ν' k / 2" by linarith
          then show ?thesis by (simp add: power2_eq_square field_simps)
        qed
        also have "… ≥ (2 ^ (2 ^ k))^2 / 2"
          using Suc.IH by (intro divide_right_mono power_mono) auto
        also have "… = 2 ^ (2 ^ (k+1)) / 2"
          by (simp add: power_mult power2_eq_square)
        also have "… = 2 ^ (2^(k+1) - 1)"
          by (simp add: power_diff)
        finally show ?case by linarith
      qed
    qed

    text ‹Hence \(\sum_k (\nu'_k+2)^{-c}\) is summable.›
    have "summable (λk. (ν' k + 2) powr (-?c))"
    proof (rule summable_comparison_test_ev)
      show "∀⇩F k in sequentially. norm ((ν' k + 2) powr (-?c)) ≤ (2 ^ (2 ^ k)) powr (-?c)"
        using exp_growth `?c > 0`
        by (auto simp: eventually_sequentially intro!: powr_mono2')
      have "summable (λk. (2 ^ (2 ^ k)) powr (-?c))"
      proof (rule summable_comparison_test_ev)
        show "∀⇩F k in sequentially. norm ((2 ^ (2 ^ k)) powr (-?c)) ≤ (2 powr (-?c)) ^ k"
        proof (rule eventually_sequentiallyI[of 0])
          fix k
          have "2 ^ k ≥ k" by simp
          hence "2 ^ (2 ^ k) ≥ 2 ^ k" by (metis one_le_numeral power_increasing)
          from powr_mono'[OF this, of "-?c"]
          have "(2 ^ (2 ^ k)) powr (-?c) ≤ (2 ^ k) powr (-?c)" by auto
          also have "(2 ^ k) powr (-?c) = (2 powr (-?c)) ^ k"
            by (simp add: powr_powr mult.commute)
          finally show "norm ((2 ^ (2 ^ k)) powr (-?c)) ≤ (2 powr (-?c)) ^ k"
            by simp
        qed
        show "summable (λk. (2 powr (-?c)) ^ k)"
          using `?c > 0` by (simp add: summable_geometric)
      qed
      then show "summable (λk. (2 ^ (2 ^ k)) powr (-?c))" .
    qed
    moreover have "∀k. norm (?a (ν' k)) = (ν' k + 2) powr (-?c)"
      using ν'_sel by (simp add: norm_eq)
    ultimately have "summable (λk. ?a (ν' k))"
      by (subst summable_cong) auto
    moreover have "finite (ν ` {..<k0})" by simp
    ultimately show "summable ?a"
      by (intro summable_finite_restrict)
         (auto simp: ν'_def image_iff)
  }
  ultimately show ?thesis by blast
qed

end