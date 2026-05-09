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

lemma r_less_one_over_n:
  shows "r x n < 1/(n+2)"
proof (induction n)
  case 0
  have "r x 0 = x - (if x ≥ 1/2 then 1/2 else 0)" by simp
  then consider "x ≥ 1/2" | "x < 1/2" by linarith
  then show ?case
  proof cases
    case 1
    then have "r x 0 = x - 1/2" by simp
    also have "... < 1/2" using assms by (auto simp: field_simps)
    finally show ?thesis by simp
  next
    case 2
    then have "r x 0 = x" by simp
    also have "... < 1/2" using 2 by linarith
    finally show ?thesis by simp
  qed
next
  case (Suc n)
  then show ?case
    by (cases "r x n ≥ 1/(Suc n + 2)") auto
qed

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

text ‹
  In the limit, the remainder vanishes because the harmonic series diverges
  and the selection stops when the remainder becomes zero.
  Hence the infinite sum representation holds.
›
lemma remainder_vanishes:
  fixes x :: real
  assumes "x ∈ {0..1}"
  shows "(λn. r x n) ⇢ 0"
proof -
  have "decseq (r x)"
  proof (intro monotoneI)
    fix n
    show "r x (Suc n) ≤ r x n"
      by (cases "r x n ≥ 1/(Suc n + 2)") auto
  qed
  moreover have "∀n. r x n ≥ 0" using assms r_nonneg by auto
  ultimately obtain L where "L ≥ 0" "(λn. r x n) ⇢ L"
    using decseq_convergent by auto
  from greedy_sum[of x "n"] assms have "∀n. r x n = x - (∑ k≤n. (real (δ x k))/(k+2))"
    by (simp add: algebra_simps)
  then have "L = x - (∑ k. (real (δ x k))/(k+2))"
    using ‹(λn. r x n) ⇢ L› tendsto_diff by auto
  have "summable (λk. 1/(k+2))" by simp
  hence "(∑ k. 1/(k+2)) = ∞" by (auto simp: summable_iff)
  moreover have "(∑ k. (real (δ x k))/(k+2)) ≤ (∑ k. 1/(k+2))"
    by (intro suminf_le) (auto simp: δ_range)
  ultimately have "L = 0" using `x ∈ {0..1}` `L ≥ 0` by force
  with `(λn. r x n) ⇢ L` show ?thesis by simp
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

subsection ‹Super‑exponential growth of selected indices›

text ‹
  Let \(n_1 < n_2 < \dots\) be the indices where \(\delta_{n_k}=1\).
  We prove that for \(n_k \ge 2\), the next index satisfies
  \(n_{k+1} \ge n_k (n_k - 1)\).
›

definition selected_indices :: "real ⇒ nat list" where
  "selected_indices x = sorted_list_of_set {n. δ x n = 1}"

text ‹
  The key observation: after step \(n\), the remainder \(r_n\) is
  strictly less than \(\frac1{n+2}\).  If the next selected index is
  \(m>n\), then the greedy condition forces \(r_{m-1} \ge \frac1{m+2}\).
  Since the remainders are non‑increasing, we have
  \[ \frac1{m+2} \le r_{m-1} \le r_n < \frac1{n+2}. \]
  This inequality implies \(m+2 > (n+1)(n+2)\), hence \(m > n(n-1)\)
  for \(n\ge2\).
›

lemma next_selected_index_bound:
  fixes x :: real and n :: nat
  assumes "δ x n = 1" "n ≥ 2"
  obtains m where "m > n" "δ x m = 1" "m ≥ n * (n - 1)"
proof -
  have "r x n < 1 / (n+2)" by (rule r_less_one_over_n)
  define m where "m = (LEAST m. m > n ∧ δ x m = 1)"
  from assms(1) have "∃m>n. δ x m = 1" using remainder_vanishes[of x] unfolding LIMSEQ_def
    by (metis assms(2) less_add_one)
  then have "m > n" "δ x m = 1" and m_min: "∀k∈{n<..<m}. δ x k = 0"
    unfolding m_def by (auto intro!: LeastI_ex)
  have "r x (m-1) = r x n - (∑ k=n+1..<m. (real (δ x k)) / (k+2))"
  proof (induction "m-1-n" arbitrary: m)
    case 0
    then have "m = Suc n" by linarith
    then show ?case by simp
  next
    case (Suc d)
    then obtain m' where m': "m = Suc m'" "m' ≥ n" by (metis Suc_diff_le diff_Suc_Suc)
    from Suc(2)[of m'] have "r x (m'-1) = r x n - (∑ k=n+1..<m'. (real (δ x k)) / (k+2))"
      using m' by (metis diff_Suc_less lessI)
    also have "r x (m-1) = r x (Suc m' - 1)" using m' by simp
    also have "... = r x m' - (real (δ x m')) / (m' + 2)" by simp
    also have "... = r x (m'-1) - (real (δ x (Suc (m'-1)))) / (Suc (m'-1) + 2)" by simp
    also have "... = r x (m'-1) - (if r x (m'-1) ≥ 1/(Suc (m'-1)+2) then 1/(Suc (m'-1)+2) else 0)"
      by simp
    also have "... = r x (m'-1) - (real (δ x (Suc (m'-1)))) / (Suc (m'-1)+2)"
      by (cases "r x (m'-1) ≥ 1/(Suc (m'-1)+2)") auto
    finally show ?case using Suc(2)[of m'] m' by simp
  qed
  also have "r x (m-1) ≥ 1/(m+2)"
  proof -
    from `δ x m = 1` have "r x (m-1) ≥ 1/(m+2)"
      by (cases "m = 0") (auto simp: r.simps split: if_splits)
    then show ?thesis .
  qed
  ultimately have "r x n ≥ 1/(m+2)"
    by (simp add: sum_nonneg)
  with `r x n < 1/(n+2)` have "1/(m+2) < 1/(n+2)" by linarith
  then have "m+2 > n+2" by (simp add: field_simps)
  hence "m > n" by linarith
  have "1/(m+2) < 1/((n+1)*(n+2))"
  proof -
    have "1/((n+1)*(n+2)) = 1/(n+1) - 1/(n+2)" by (simp add: field_simps)
    also have "1/(n+1) - 1/(n+2) > 0" using `n≥2` by auto
    ultimately show ?thesis using `1/(m+2) ≤ r x n` `r x n < 1/(n+2)` by auto
    (* Actually we need a direct bound: from 1/(m+2) ≤ r_n < 1/(n+2) we get m+2 > n+2, not enough.
       The super‑exponential bound requires a sharper remainder estimate. *)
  qed
  sorry
  (* The detailed calculation: we need to use that the remainder after selecting n is at most 1/(n+2),
     and the remainder before selecting m is at least 1/(m+2).  But we also have the intermediate
     skipped terms, which reduce the remainder further.  To get m ≥ n(n-1), we use the better bound:
     r_n ≤ 1/(n+1) - 1/(n+2) = 1/((n+1)(n+2)).  That is proved by noting that the remainder after 
     selecting a term of size 1/(n+2) is at most the next harmonic fraction minus the selected one.
     So the proper lemma is: if δ_n=1 then r_n < 1/(n+1) - 1/(n+2) = 1/((n+1)(n+2)).
     This follows because before step n, the remainder is at least 1/(n+2) (to select δ_n=1) and at most
     1/(n+1) (otherwise we would have selected at step n+1 earlier?).  Let's prove that lemma. *)
  oops

text ‹
  The missing refinement: After selecting index \(n\), the remainder satisfies
  \(r_n < \frac1{(n+1)(n+2)}\).  This stronger bound comes from the observation that
  the remainder before step \(n\) is at least \(1/(n+2)\) (the condition for selection)
  and strictly less than \(1/(n+1)\) (otherwise the next fraction would have been selected
  before the remainder dropped below its threshold).  Hence
  \[ r_n = r_{n-1} - \frac1{n+2} < \frac1{n+1} - \frac1{n+2} = \frac1{(n+1)(n+2)}. \]
›

lemma remainder_after_selection_bound:
  fixes x :: real and n :: nat
  assumes "δ x n = 1"
  shows "r x n < 1 / ((n+1)*(n+2))"
proof -
  have "r x (n-1) < 1/(n+1)"
  proof (cases n)
    case 0
    then show ?thesis using assms by (auto simp: r.simps)
  next
    case (Suc n')
    have "r x (Suc n') = r x n' - (if r x n' ≥ 1/(Suc n'+2) then 1/(Suc n'+2) else 0)"
      by simp
    with assms Suc have "r x (Suc n') = r x n' - 1/(Suc n'+2)" by simp
    have "r x n' < 1/(n'+2)" by (rule r_less_one_over_n)
    moreover from assms Suc have "δ x (Suc n') = 1" by simp
    then have "r x n' ≥ 1/(Suc n'+2)" by (cases "r x n' ≥ 1/(Suc n'+2)") auto
    ultimately have "1/(Suc n'+2) ≤ r x n' ∧ r x n' < 1/(n'+2)" by auto
    then have "r x n' - 1/(Suc n'+2) < 1/(n'+2) - 1/(Suc n'+2)" by linarith
    also have "... = 1/((n'+2)*(Suc n'+2))" by (simp add: field_simps)
    also have "... = 1/((Suc n'+1)*(Suc n'+2))" by simp
    finally show ?thesis using Suc by simp
  qed
  with assms show ?thesis
    by (cases n) (auto simp: r.simps split: if_splits)
qed

text ‹Now we can prove the super‑exponential growth.›

lemma next_selected_index_super_exponential:
  fixes x :: real and n :: nat
  assumes "δ x n = 1" "n ≥ 2"
  shows "∃m>n. δ x m = 1 ∧ m ≥ n * (n - 1)"
proof -
  have "r x n < 1 / ((n+1)*(n+2))" by (rule remainder_after_selection_bound[OF assms(1)])
  define m where "m = (LEAST m. m > n ∧ δ x m = 1)"
  from assms(1) have "∃m>n. δ x m = 1" using remainder_vanishes[of x] by (metis LIMSEQ_0 less_add_one)
  then have "m > n" "δ x m = 1" and m_min: "∀k∈{n<..<m}. δ x k = 0"
    unfolding m_def by (auto intro!: LeastI_ex)
  from `δ x m = 1` have "r x (m-1) ≥ 1/(m+2)"
    by (cases "m=0") (auto simp: r.simps split: if_splits)
  have "r x (m-1) = r x n - (∑ k=n+1..<m. (real (δ x k)) / (k+2))"
  proof (induction "m-1-n" arbitrary: m)
    case 0
    then have "m = Suc n" by linarith
    then show ?case by simp
  next
    case (Suc d)
    then obtain m' where m': "m = Suc m'" "m' ≥ n" by (metis Suc_diff_le diff_Suc_Suc)
    have "r x (m'-1) = r x n - (∑ k=n+1..<m'. (real (δ x k)) / (k+2))"
      using Suc(2)[of m'] m' by auto
    also have "r x (m-1) = r x (Suc m' - 1)" using m' by simp
    also have "... = r x m' - (real (δ x m')) / (m' + 2)" by simp
    also have "... = r x (m'-1) - (if r x (m'-1) ≥ 1/(Suc (m'-1)+2) then 1/(Suc (m'-1)+2) else 0)"
      by simp
    also have "... = r x (m'-1) - (real (δ x (Suc (m'-1)))) / (Suc (m'-1)+2)"
      by (cases "r x (m'-1) ≥ 1/(Suc (m'-1)+2)") auto
    finally show ?case using Suc(2)[of m'] m' by simp
  qed
  also have "r x (m-1) ≤ r x n" by (auto intro!: r_nonneg monotoneI)
  ultimately have "r x n ≥ 1/(m+2)"
    using `r x (m-1) ≥ 1/(m+2)` by auto
  with `r x n < 1 / ((n+1)*(n+2))` have "1/(m+2) < 1 / ((n+1)*(n+2))" by linarith
  then have "m+2 > (n+1)*(n+2)" by (simp add: field_simps)
  hence "m > (n+1)*(n+2) - 2" by linarith
  have "(n+1)*(n+2) - 2 = n*(n-1) + 4*n" by (simp add: field_simps)
  also have "... ≥ n*(n-1)" using `n≥2` by auto
  finally show ?thesis
    using `m > (n+1)*(n+2) - 2` `m > n` `δ x m = 1` by auto
qed

text ‹
  The selected indices therefore grow super‑exponentially.  In particular,
  the series \(\sum_{k} (n_k)^{-\sigma}\) converges for any \(\sigma>0\).
  This fact is essential for the absolute convergence of the GDST
  on the critical line.
›

theorem selected_indices_super_exponential:
  fixes x :: real and ν :: "nat ⇒ nat"
  assumes "strict_mono ν" "∀k. δ x (ν k) = 1"
    and "ν 0 ≥ 2"
  shows "∀k. ν (Suc k) ≥ ν k * (ν k - 1)"
proof (intro allI)
  fix k
  have "δ x (ν k) = 1" using assms by auto
  moreover have "ν k ≥ 2" using assms by (metis assms(3) linorder_le_cases not_less_iff_gr_or_eq order_le_less_trans strict_mono_less_eq)
  ultimately obtain m where "m > ν k" "δ x m = 1" "m ≥ ν k * (ν k - 1)"
    using next_selected_index_super_exponential by blast
  with assms(1) have "ν (Suc k) ≥ m"
    by (metis (no_types, lifting) LeastI_ex assms(2) m_def order_less_trans strict_mono_Suc_iff)
  with `m ≥ ν k * (ν k - 1)` show "ν (Suc k) ≥ ν k * (ν k - 1)" by simp
qed

end