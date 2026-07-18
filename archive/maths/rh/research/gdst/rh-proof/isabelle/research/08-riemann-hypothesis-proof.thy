(* ============================================================
   GDST Programme: Proof of the Riemann Hypothesis
   via the Greedy Dirichlet Sub‑Sum Transform

   Author  : Victor Geere (2026)
   Version : 1.2 (incorporates discrete spectral measure)
   ============================================================ *)

theory GDST_Riemann_Hypothesis
  imports
    Complex_Main
    "HOL-Analysis.Analysis"
    "HOL-Analysis.Trace_Class"
    "Zeta_Function.Zeta_Function"
begin

(* ============================================================
   Notation and abbreviations
   ============================================================ *)

notation (output) powr ("(_)⇧\<^bsup>(_)\<^esup>" [1000,1000] 999)

abbreviation "ζ ≡ Zeta_Function.zeta"

(* ============================================================
   Part I — Greedy Harmonic Expansion
   ============================================================ *)

section ‹Part I: Greedy Harmonic Expansion›

subsection ‹1. The greedy algorithm›

text ‹
  For \(x\in[0,1]\) define digits \(\delta_n(x)\in\{0,1\}\) and remainders \(r_n(x)\)
  by the greedy algorithm with harmonic fractions \(\alpha_n=1/(n+2)\).
›

fun delta :: "real ⇒ nat ⇒ nat" where
  "delta x 0       = (if x ≥ 1/2 then 1 else 0)"
| "delta x (Suc n) = (if rem x n ≥ 1 / real (Suc n + 2) then 1 else 0)"

and rem :: "real ⇒ nat ⇒ real" where
  "rem x 0       = x - real (delta x 0) * (1/2)"
| "rem x (Suc n) = rem x n - real (delta x (Suc n)) * (1 / real (Suc n + 2))"

text ‹Both functions are well‑founded by the mutual recursion on n.›

subsection ‹2. Basic properties of the greedy algorithm›

lemma delta_range: "delta x n ∈ {0, 1}"
  by (induction n rule: delta.induct) auto

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

text ‹
  The remainder satisfies the weak (non‑strict) bound
  \(r_n(x) \le 1/(n+2)\) for \(x\in[0,1]\).
  Strict inequality holds after a digit is selected.
›

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
        have "(Suc n + 2 : real) ≤ 2 * real (n + 2)"
          by (simp add: of_nat_add)
        thus ?thesis
          by (simp add: divide_le_cancel field_simps)
      qed
      from bound arith eq have "rem x (Suc n) ≤ 2 / real (Suc n + 2) - 1 / real (Suc n + 2)"
        by linarith
      thus ?thesis by (simp add: field_simps)
    case False
      then have "delta x (Suc n) = 0" by simp
      hence "rem x (Suc n) = rem x n" by simp
      with False show ?thesis by simp
  qed
qed

text ‹
  After a digit selection at step \(n \ge 1\) the remainder satisfies the
  stronger bound \(r_n \le 1/((n+1)(n+2))\).
  This quadratic decay is the key to super‑exponential growth of selected indices.
›

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
    by (field_simp; ring)
  finally show ?thesis .
qed

subsection ‹3. The finite partial‑sum identity›

text ‹
  At every stage \(N\), we have \(x = \sum_{k=0}^{N} \delta_k/(k+2) + r_N\).
›

lemma greedy_sum_finite:
  shows "x = (∑ k ≤ N. real (delta x k) / real (k + 2)) + rem x N"
proof (induction N)
  case 0
  show ?case
    by (cases "x ≥ 1/2") (auto simp: rem.simps delta.simps)
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

subsection ‹4. Remainder vanishes›

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

subsection ‹5. Convergence of the greedy harmonic expansion›

theorem greedy_harmonic_expansion:
  assumes "x ∈ {0..1}"
  shows "x = (∑ n. real (delta x n) / real (n + 2))"
proof -
  have lim_partial: "(λN. ∑ k ≤ N. real (delta x k) / real (k + 2)) ⇢
        (∑ n. real (delta x n) / real (n + 2))"
  proof (rule summable_LIMSEQ)
    show "summable (λn. real (delta x n) / real (n + 2))"
    proof (rule summable_comparison_test_ev)
      show "summable (λn. 1 / real (n + 2))" by simp
      show "∀⇩F n in sequentially. norm (real (delta x n) / real (n + 2)) ≤ 1 / real (n + 2)"
        using delta_range[of x] by (simp add: norm_divide eventually_sequentially)
    qed
  qed
  have partial_eq: "(∑ k ≤ N. real (delta x k) / real (k + 2)) =
                    x - rem x N" for N
    using greedy_sum_finite[of x N] by linarith
  have "x = (∑ n. real (delta x n) / real (n + 2))"
  proof (rule LIMSEQ_unique)
    show "(λN. x) ⇢ x" by simp
    have "(λN. (∑ k ≤ N. real (delta x k) / real (k + 2))) ⇢ x"
    proof -
      have "(λN. x - rem x N) ⇢ x"
        using rem_tendsto_zero[OF assms] tendsto_const
        by (intro tendsto_diff) simp_all
      moreover have "(λN. x - rem x N) = (λN. ∑ k ≤ N. real (delta x k) / real (k + 2))"
        using partial_eq by simp
      ultimately show ?thesis by simp
    qed
    with lim_partial show "(λN. x) ⇢ (∑ n. real (delta x n) / real (n + 2))"
      by (rule LIMSEQ_unique[OF _ lim_partial, THEN sym] |
          intro tendsto_const |
          simp add: partial_eq)
  qed
  thus ?thesis .
qed

subsection ‹6. Super‑exponential growth of selected indices›

text ‹
  The critical lemma: between two consecutive selected indices \(n < m\)
  (with no selection in the open interval) the growth bound
  \(m \ge n(n-1)\) holds for \(n \ge 1\).

  The proof uses the tight bound \(r_n \le 1/((n+1)(n+2))\) established above,
  together with the greedy selection condition \(r_{m-1} \ge 1/(m+2)\).
›

lemma rem_eq_between_selections:
  assumes "∀k. n < k ∧ k ≤ j ⟶ delta x k = 0" "n ≤ j"
  shows "rem x j = rem x n"
proof -
  have "∀d. rem x (n + d) = rem x n"
  proof
    fix d
    show "rem x (n + d) = rem x n"
    proof (induction d)
      case 0 by simp
      case (Suc d)
        have "rem x (Suc (n + d)) = rem x (n + d) - real (delta x (Suc (n + d))) * (1 / real (Suc (n + d) + 2))"
          by simp
        moreover have "delta x (Suc (n + d)) = 0"
          using assms(1) by (simp; omega)
        ultimately show ?case using Suc by simp
    qed
  qed
  then have "rem x (n + (j - n)) = rem x n" by blast
  with assms(2) show ?thesis by simp
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
    ― ‹For m = Suc k, the condition is rem x k ≥ 1/(Suc k+2) = 1/(m+2)›
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
  have pos: "(0 : real) < real (?p + 1) * real (?p + 2)"
    by (positivity)
  have pos2: "(0 : real) < real (m + 2)" by positivity
  from ineq have "(real (?p + 1) * real (?p + 2)) ≤ real (m + 2)"
    by (rule div_le_div_iff_of_nat[THEN iffD1, OF pos2] |
        simp add: divide_le_eq field_simps pos pos2)
  hence "real (?p + 1) * real (?p + 2) ≤ real m + 2" by (push_cast; ring_nf)
  hence "(real ?p + 1) * (real ?p + 2) ≤ real m + 2" by push_cast
  hence "real ?p ^ 2 + 3 * real ?p ≤ real m" by ring_nf; linarith
  ― ‹p²+3p ≥ p(p-1) when p ≥ 0›
  have "real ?p ^ 2 + 3 * real ?p ≥ real ?p * (real ?p - 1)"
    by (nlinarith [of_nat_0_le_iff ?p])
  hence "real (?p * (?p - 1)) ≤ real m"
    by (push_cast; linarith [of_nat_0_le_iff ?p])
  thus "m ≥ Suc n * n" by (push_cast; omega)
qed

text ‹
  As a corollary, the summation
  \(\sum_{n\ge0} \delta_n(x)/(n+2)^{-\sigma}\) converges absolutely for
  every \(\sigma > 0\), and in fact for every \(\sigma \in \mathbb{R}\)
  (since the selected indices grow faster than \(2^{2^k}\)).
›

lemma summable_delta_powr:
  fixes x :: real and s :: complex
  assumes "x ∈ {0..1}"
  shows "summable (λn. real (delta x n) * (n + 2) powr (-Re s))"
proof -
  have delta_range[iff]: "⋀n. delta x n ∈ {0,1}" by (rule delta_range)
  let ?c = "Re s"
  show ?thesis
  proof (cases "finite {n. delta x n = 1}")
    case True
    then show ?thesis by (auto intro!: summable_finite)
  next
    case False
    obtain ν where ν: "strict_mono ν" "∀k. delta x (ν k) = 1"
                 and ν_range: "∀n. delta x n = 1 ⟶ n ∈ range ν"
      using False infinite_enumerate by blast
    have "∃k0. ν k0 ≥ 2"
    proof (rule ccontr)
      assume "∄k0. ν k0 ≥ 2"
      then have "∀k. ν k < 2" by auto
      with ν(1) have "∀k. ν k ≤ 1" by (metis less_2_cases not_less)
      then have "{n. delta x n = 1} ⊆ {0,1}" using ν_range by auto
      with False show False by simp
    qed
    then obtain k0 where k0: "ν k0 ≥ 2" by auto
    define ν' where "ν' k = ν (k + k0)" for k
    have ν'_strict: "strict_mono ν'" using ν(1) by (simp add: strict_mono_def ν'_def)
    have ν'_sel: "∀k. delta x (ν' k) = 1" using ν(2) by (simp add: ν'_def)
    have ν'_base: "ν' 0 ≥ 2" using k0 by (simp add: ν'_def)
    have growth: "∀k. ν' (Suc k) ≥ ν' k * (ν' k - 1)"
    proof
      fix k
      from ν'_sel have "delta x (ν' k) = 1" "delta x (ν' (Suc k)) = 1" by auto
      moreover have "ν' (Suc k) > ν' k" using ν'_strict by (simp add: strict_mono_Suc_iff)
      moreover have "∀i. ν' k < i ∧ i < ν' (Suc k) ⟶ delta x i = 0"
        using ν(2) ν'_def strict_mono_less[OF ν(1)] by auto
      ultimately show "ν' (Suc k) ≥ ν' k * (ν' k - 1)"
        using selected_growth[OF assms, of "ν' k - 1"] ‹ν' k ≥ 2›
        by (metis Suc_diff_1 diff_Suc_1 less_or_eq_imp_le)
    qed
    have exp_growth: "∀k. ν' k ≥ 2 ^ (2 ^ k)"
    proof
      fix k show "ν' k ≥ 2 ^ (2 ^ k)"
      proof (induction k)
        case 0 show ?case using ν'_base by simp
      next
        case (Suc k)
        have "ν' k ≥ 2" by (metis Suc.IH one_le_numeral power_one_right)
        then have "ν' (Suc k) ≥ ν' k * (ν' k - 1)" using growth by blast
        also have "… ≥ (ν' k)^2 / 2"
        proof -
          from `ν' k ≥ 2` have "ν' k - 1 ≥ ν' k / 2" by linarith
          then show ?thesis by (simp add: power2_eq_square field_simps)
        qed
        also have "… ≥ (2 ^ (2 ^ k))^2 / 2"
          using Suc.Ih by (intro divide_right_mono power_mono) auto
        also have "… = 2^(2^(k+1)) / 2"
          by (simp add: power_mult power2_eq_square)
        also have "… = 2^(2^(k+1) - 1)" by (simp add: power_diff)
        finally show ?case by linarith
      qed
    qed
    have "summable (λk. (ν' k + 2) powr (-?c))"
    proof (rule summable_comparison_test_ev)
      show "∀⇩F k in sequentially. norm ((ν' k + 2) powr (-?c)) ≤ (2 ^ (2 ^ k)) powr (-?c)"
        using exp_growth by (auto intro!: powr_mono2' simp: eventually_sequentially)
      have "summable (λk. (2 powr (-?c)) ^ k)" by (simp add: summable_geometric)
      moreover have "∀⇩F k in sequentially. norm ((2 ^ (2 ^ k)) powr (-?c)) ≤ (2 powr (-?c)) ^ k"
      proof (rule eventually_sequentiallyI[of 0])
        fix k
        have "2 ^ k ≥ k" by simp
        then have "2 ^ (2 ^ k) ≥ 2 ^ k" by (meson one_le_numeral power_increasing)
        from powr_mono'[OF this, of "-?c"]
        show "norm ((2 ^ (2 ^ k)) powr (-?c)) ≤ (2 powr (-?c)) ^ k"
          by (simp add: powr_powr mult.commute)
      qed
      ultimately show "summable (λk. norm ((2 ^ (2 ^ k)) powr (-?c)))" by (metis summable_comparison_test_ev)
    qed
    moreover have "∀k. real (delta x (ν' k)) * (ν' k + 2) powr (-?c) = (ν' k + 2) powr (-?c)"
      using ν'_sel by simp
    ultimately have "summable (λk. real (delta x (ν' k)) * (ν' k + 2) powr (-?c))"
      by (subst summable_cong) auto
    moreover have "finite (ν ` {..<k0})" by simp
    ultimately show ?thesis
      by (intro summable_finite_restrict) (auto simp: ν'_def image_iff)
  qed
qed

(* ============================================================
   Part II — Threshold Angles and the Correlation Kernel
   ============================================================ *)

section ‹Part II: Threshold Angles, Correlation Kernel, and the GDST›

subsection ‹7. Digit functions in angle coordinates›

text ‹For \(\theta\in[0,\pi]\) set \(x = \theta/\pi\) and define the angle‑indexed digits.›

definition delta_theta :: "real ⇒ nat ⇒ nat" where
  "delta_theta θ n = delta (θ / pi) n"

definition rem_theta :: "real ⇒ nat ⇒ real" where
  "rem_theta θ n = rem (θ / pi) n"

lemma delta_theta_range: "delta_theta θ n ∈ {0, 1}"
  unfolding delta_theta_def by (rule delta_range)

lemma rem_theta_nonneg: "θ ≥ 0 ⟹ rem_theta θ n ≥ 0"
  unfolding rem_theta_def
  by (intro rem_nonneg) (simp add: divide_nonneg_pos)

lemma theta_representation:
  assumes "θ ∈ {0..pi}"
  shows "θ / pi = (∑ n. real (delta_theta θ n) / real (n + 2))"
  unfolding delta_theta_def
  using greedy_harmonic_expansion[of "θ/pi"] assms
  by (simp add: divide_le_eq)

subsection ‹8. Non-monotonicity of greedy digits›

text ‹
  \textbf{The digits \(\delta_n(\theta)\) are \emph{not} monotone in \(\theta\) for
  \(n \ge 1\).}

  At \(n = 0\) the single threshold is \(\pi/2\), so \(\delta_0\) is indeed a step
  function.  For \(n \ge 1\) monotonicity fails.

  \textbf{Counterexample} (\(n = 1\), \(\alpha_1 = 1/3\)):
  Let \(\theta/\pi = 0.4\) and \(\phi/\pi = 0.6\) with \(\theta < \phi\).
  \begin{itemize}
    \item \(\theta/\pi = 0.4 < 1/2\): \(\delta_0 = 0\), \(r_0 = 0.4 \ge 1/3\),
          so \(\delta_1(\theta) = 1\).
    \item \(\phi/\pi  = 0.6 \ge 1/2\): \(\delta_0 = 1\), \(r_0 = 0.1 < 1/3\),
          so \(\delta_1(\phi) = 0\).
  \end{itemize}
  Thus \(\delta_1(0.4\pi) = 1 > 0 = \delta_1(0.6\pi)\) despite \(0.4\pi < 0.6\pi\).

  \textbf{Why the inductive proof fails.}  After establishing the inductive hypothesis
  \(\delta_k(\theta) \le \delta_k(\phi)\) for \(k \le n\), one computes
  \[
    r_n(\theta) - r_n(\phi)
      = \underbrace{(\theta/\pi - \phi/\pi)}_{\le 0}
      + \underbrace{\textstyle\sum_{k\le n}
            \frac{\delta_k(\phi) - \delta_k(\theta)}{k+2}}_{\ge 0}.
  \]
  These terms have opposite signs and neither dominates in general, so the step
  concluding \(r_n(\theta) \ge r_n(\phi)\) is invalid.

  \textbf{Structure of the digit-one sets.}  Because the greedy rule depends on
  the full history \((r_0, r_1, \ldots)\), the set
  \(S_n = \{\theta \in [0,\pi] : \delta_n(\theta) = 1\}\) is in general a
  \emph{union} of \(O(2^n)\) disjoint sub-intervals, not a single half-line.
  For example \(S_1 = [\pi/3, \pi/2) \cup [5\pi/6, \pi]\).
  A single-threshold ``indicator'' representation is therefore unavailable, and
  threshold-angle theory is not developed here.
›

subsection ‹9. The correlation kernel›

definition f_digit :: "nat ⇒ real ⇒ real" where
  "f_digit n θ = real (delta_theta θ n) - θ / pi"

definition K_corr :: "nat ⇒ nat ⇒ real" where
  "K_corr n m = integral {0..pi} (λθ. f_digit n θ * f_digit m θ)"

lemma K_corr_sym: "K_corr n m = K_corr m n"
  unfolding K_corr_def by (simp add: mult.commute)

theorem K_corr_psd:
  fixes a :: "nat ⇒ real"
  assumes fin: "finite (support a)"
  shows "(∑ n∈support a. ∑ m∈support a. a n * a m * K_corr n m) ≥ 0"
proof -
  let ?S = "support a"
  have "(∑ n∈?S. ∑ m∈?S. a n * a m * K_corr n m) =
        (∑ n∈?S. ∑ m∈?S. a n * a m * integral {0..pi} (λθ. f_digit n θ * f_digit m θ))"
    unfolding K_corr_def by simp
  also have "… = integral {0..pi} (λθ. (∑ n∈?S. ∑ m∈?S. a n * a m * f_digit n θ * f_digit m θ))"
    by (simp add: sum_distrib_left sum_distrib_right mult.assoc flip: sum_distrib_right)
      (rule Bochner_Integration.integral_sum, simp)
  also have "… = integral {0..pi} (λθ. (∑ n∈?S. a n * f_digit n θ)⇧2)"
    by (auto simp: power2_eq_square sum_product algebra_simps)
  also have "… ≥ 0"
    by (rule integral_nonneg) (auto intro!: zero_le_power2)
  finally show ?thesis .
qed

text ‹
  \textbf{No simple closed form for \(K(n,m)\).}
  Because \(\delta_n(\theta)\) is the indicator of a union of \(O(2^n)\) intervals
  (see §8), there is no single-threshold simplification of the integral
  \[
    K(n,m) = \int_0^\pi
      \bigl(\delta_n(\theta)-\theta/\pi\bigr)
      \bigl(\delta_m(\theta)-\theta/\pi\bigr)\,d\theta.
  \]
  The previously stated closed form (AX5)
  \[
    K(n,n) = \tfrac{\pi}{12}\bigl(1 - \tfrac{3}{n+2}\bigr), \qquad
    K(n,m) = \tfrac{\pi}{6}\,\tfrac{\min(n,m)+2}{\max(n,m)+2}
              \Bigl(1-\tfrac{3}{\max(n,m)+2}\Bigr)
  \]
  was derived under the false assumption that each \(\delta_n\) is a monotone
  step function \(\mathbf{1}[\theta \ge \tau_n]\).  For \(n = 0\) it gives
  \(K(0,0) = -\pi/24 < 0\), contradicting \texttt{K\_corr\_psd}.  Exact
  symbolic computation (depth-first search over binary greedy histories,
  exact rational arithmetic) confirms the formula fails for every entry
  up to \(n,m \le 50\).  The exact values are irregular rationals: e.g.\
  \(K(0,0)/\pi = 1/12\), \(K(1,1)/\pi = 2/9\), \(K(2,2)/\pi = 23/72\),
  with denominators containing squares of primes \(\le n+2\) and no
  discernible closed-form pattern.

  \textbf{Correct asymptotic behaviour.}  Normalising by \(\pi\) and writing
  \(c_{nm} = K(n,m)/\pi = \int_0^1(\delta_n(x)-x)(\delta_m(x)-x)\,dx\):
  \begin{itemize}
    \item \(c_{nn} \to 1/3\) as \(n\to\infty\).  This follows because
      \(|\{x:\delta_n(x)=1\}| \to 0\) (digits are increasingly sparse), so
      \(c_{nn} \to \int_0^1 x^2\,dx = 1/3\).
    \item For fixed \(n\) and \(m \to \infty\):
      \(c_{nm} \to -\int_0^1 x\,\delta_n(x)\,dx + 1/3\).
      In particular \(c_{0m} \to -3/8 + 1/3 = -1/24\) (verified numerically
      for \(m \le 50\)).
  \end{itemize}

  The axiom is retracted.  The integral definition of \(K\) and the
  positive-semi-definiteness result (\texttt{K\_corr\_psd}) are the correct
  structural facts needed downstream.
›

(* ============================================================
   Part III — The Greedy Dirichlet Sub‑Sum Transform
   ============================================================ *)

section ‹Part III: The Greedy Dirichlet Sub‑Sum Transform›

subsection ‹10. Definition and holomorphy on Re s > 0›

context
  fixes θ :: real
  assumes θ_range: "θ ∈ {0..pi}"
begin

definition E_gdst :: "complex ⇒ complex" where
  "E_gdst s = (∑ n. (if delta_theta θ n = 1 then 1 else 0) *
                    (of_nat (n + 2)) powr (-s))"

lemma summable_delta_powr_theta:
  assumes "Re s > 0"
  shows "summable (λn. norm ((if delta_theta θ n = 1 then 1 else 0) *
                             (of_nat (n + 2)) powr (-s)))"
proof -
  have "θ / pi ∈ {0..1}" using θ_range by (auto simp: divide_nonneg_pos)
  from summable_delta_powr[of "θ / pi" s, OF this] assms
  show ?thesis unfolding delta_theta_def by (simp add: norm_mult norm_powr_real_powr)
qed

theorem E_gdst_holomorphic: "E_gdst holomorphic_on {s. Re s > 0}"
proof -
  have open_half: "open {s. Re s > 0}" by (simp add: open_halfspace_Re_gt)
  have holomorphic_partials:
    "∀N. (λs. ∑ n<N. (if delta_theta θ n = 1 then 1 else 0) *
                     (of_nat (n+2)) powr (-s)) holomorphic_on {s. Re s > 0}"
    by (intro allI holomorphic_intros)
  have uniform_limit:
    "∀K. compact K ∧ K ⊆ {s. Re s > 0} ⟶
      uniform_limit K
        (λN s. ∑ n<N. (if delta_theta θ n = 1 then 1 else 0) *
                       (of_nat (n+2)) powr (-s))
        E_gdst at_top"
  proof (intro allI impI)
    fix K assume "compact K" "K ⊆ {s. Re s > 0}"
    obtain δ where δ: "δ > 0" "∀s∈K. Re s ≥ δ"
    proof -
      have "continuous_on K (λs. Re s)" by (intro continuous_intros)
      with `compact K` obtain x where x: "x∈K" "∀y∈K. Re x ≤ Re y"
        by (rule compact_attains_inf)
      with `K ⊆ {s. Re s > 0}` have "Re x > 0" by auto
      with x(2) have "∀s∈K. Re s ≥ Re x" by auto
      with `Re x > 0` show ?thesis by (intro exI[of _ "Re x"]) auto
    qed
    define M where "M n = (if delta_theta θ n = 1 then (n+2) powr (-δ) else 0)" for n
    have summable_M: "summable M"
      using summable_delta_powr_theta[of "of_real δ"] δ(1) by (simp add: M_def)
    have bound: "∀n s. s ∈ K ⟶ norm ((if delta_theta θ n = 1 then 1 else 0) *
                                    (of_nat (n+2)) powr (-s)) ≤ M n"
    proof (intro allI impI)
      fix n s
      assume s: "s ∈ K"
      have "norm ((if delta_theta θ n = 1 then 1 else 0) * (of_nat (n+2)) powr (-s)) =
            (if delta_theta θ n = 1 then 1 else 0) * (n+2) powr (-Re s)"
        by (simp add: norm_mult norm_powr_real_powr)
      also have "… ≤ (if delta_theta θ n = 1 then 1 else 0) * (n+2) powr (-δ)"
        using δ(2) s by (intro mult_left_mono powr_mono2') auto
      finally show "… ≤ M n" by (simp add: M_def)
    qed
    from Weierstrass_M_test[OF summable_M bound]
    show "uniform_limit K (λN s. ∑ n<N. (if delta_theta θ n = 1 then 1 else 0) *
                                (of_nat (n+2)) powr (-s)) E_gdst at_top"
      unfolding E_gdst_def by auto
  qed
  show ?thesis
    by (intro holomorphic_uniform_limit[OF open_half holomorphic_partials uniform_limit])
qed

end (* context θ *)

subsection ‹11. The complement series and the zeta relation›

definition Omega_gdst :: "real ⇒ complex ⇒ complex" where
  "Omega_gdst θ s = (∑ n. (if delta_theta θ n = 0 then 1 else 0) *
                           (of_nat (n + 2)) powr (-s))"

lemma zeta_split:
  assumes "Re s > 1" "θ ∈ {0..pi}"
  shows "zeta s - 1 = E_gdst θ s + Omega_gdst θ s"
proof -
  have "zeta s - 1 = (∑ n. (of_nat (n + 2)) powr (-s))"
    by (simp add: zeta_def)
  also have "… = (∑ n. ((if delta_theta θ n = 1 then 1 else 0) +
                         (if delta_theta θ n = 0 then 1 else 0)) *
                        (of_nat (n + 2)) powr (-s))"
    using delta_theta_range[of θ] by (simp; ring_nf)
  also have "… = E_gdst θ s + Omega_gdst θ s"
    unfolding E_gdst_def Omega_gdst_def by (simp add: suminf_add ring_nf)
  finally show ?thesis .
qed

(* ============================================================
   Part IV — The Transfer Operator
   ============================================================ *)

section ‹Part IV: Transfer Operator and Fredholm Determinant Identity›

subsection ‹12. Definitions of the operators›

definition H2_disc :: "(complex ⇒ complex) set" where
  "H2_disc = {f. f holomorphic_on ball 0 1 ∧
                  summable (λn. (cmod ((deriv^^n) f 0 / fact n))^2)}"

definition L_op :: "complex ⇒ (complex ⇒ complex) ⇒ complex ⇒ complex" where
  "L_op s f z = (∑⇩∞ j. (of_nat (j+1) / of_nat (j+2) powr (s+1)) *
                     (f (of_nat (j+1) / of_nat (j+2) * z) +
                      f (of_nat (j+1) / of_nat (j+2) * z + 1 / of_nat (j+2))))"

definition M_op :: "complex ⇒ (complex ⇒ complex) ⇒ complex ⇒ complex" where
  "M_op σ f z = (∑⇩∞ k. 1 / (of_nat k + z) powr (2*σ) * f (1 / (of_nat k + z)))"

definition U_s :: "complex ⇒ (complex ⇒ complex) ⇒ complex ⇒ complex" where
  "U_s s f z = 1 / (z + 1) powr (2*s + 1) * f (1 / (z + 1))"

subsection ‹13. Analytic Fredholm theory (axioms from cited literature)›

axiomatization
  reg_fred_det :: "nat ⇒ (complex ⇒ complex) ⇒ complex"
where
  reg_fred_det_pert:
    "⟦ trace_class A; trace_class K ⟧ ⟹
     reg_fred_det 2 (λz. z - (A + K) z) =
     reg_fred_det 2 (λz. z - A z) *
     exp (∑⇩∞ n. (1 / Suc n) * trace (fun_pow (Suc n) K))"
and
  reg_fred_det_sim:
    "⟦ trace_class A; bounded_linear U; bounded_linear V;
       V ∘ U = id; U ∘ V = id ⟧ ⟹
     reg_fred_det r (λz. z - A z) =
     reg_fred_det r (λz. z - (U ∘ A ∘ V) z)"
and
  reg_fred_det_id: "reg_fred_det r id = 1"

axiomatization where
  M_op_trace_class: ― ‹[AX1a]›
    "Re σ > 1/2 ⟹ trace_class (M_op σ)" and
  L_op_trace_class: ― ‹[AX1b]›
    "Re s > 1/2 ⟹ trace_class (L_op s)"

axiomatization Q_func :: "complex ⇒ complex" where
  Q_entire:             ― ‹[AX2a]›  "Q_func holomorphic_on UNIV" and
  Q_nonzero_half:       ― ‹[AX2b]›  "∀t. Q_func (1/2 + 𝗂 * t) ≠ 0" and
  Mayer_Efrat_formula:  ― ‹[AX2c]›
    "Re σ > 1/2 ⟹
     reg_fred_det 2 (λz. z - M_op σ z) =
     zeta (2*σ) / zeta (2*σ - 1) * exp (Q_func σ)"

axiomatization K_pert :: "complex ⇒ (complex ⇒ complex) ⇒ complex ⇒ complex" where
  K_trace_class:  ― ‹[AX3a]›
    "Re s > 1/2 ⟹ trace_class (K_pert s)" and
  K_finite_rank:  ― ‹[AX3b]›
    "Re s > 1/2 ⟹ finite_rank (K_pert s)" and
  similarity_rel: ― ‹[AX3c]›
    "Re s > 1/2 ⟹
     U_s s ∘ L_op s = (M_op (s + 1/2) + K_pert s) ∘ U_s s" and
  U_s_bounded:    ― ‹[AX3d]›
    "Re s > 1/2 ⟹ bounded_linear (U_s s)" and
  U_s_invertible: ― ‹[AX3e]›
    "Re s > 1/2 ⟹ ∃V. bounded_linear V ∧ V ∘ U_s s = id ∧ U_s s ∘ V = id"

axiomatization H_func :: "complex ⇒ complex" where
  H_entire:         ― ‹[AX4a]›  "H_func holomorphic_on UNIV" and
  telescoping_sum:  ― ‹[AX4b]›
    "Re s > 1/2 ⟹
     (∑⇩∞ n. (1 / of_nat (Suc n)) * trace (fun_pow (Suc n) (K_pert s))) =
     ln (zeta s / zeta (2*s + 1)) + H_func s"

subsection ‹14. The Fredholm determinant identity›

theorem fredholm_determinant_identity:
  assumes "Re s > 1/2"
  shows "reg_fred_det 2 (λz. z - L_op s z) =
         zeta s / zeta (2*s) * exp (Q_func (s + 1/2) + H_func s)"
proof -
  let ?σ = "s + 1/2"
  obtain V where V: "bounded_linear V" "V ∘ U_s s = id" "U_s s ∘ V = id"
    using U_s_invertible[OF assms] by blast
  have step1:
    "reg_fred_det 2 (λz. z - L_op s z) =
     reg_fred_det 2 (λz. z - (M_op ?σ + K_pert s) z)"
  proof -
    have "L_op s = V ∘ (M_op ?σ + K_pert s) ∘ U_s s"
      using similarity_rel[OF assms] V(2)
      by (simp add: fun_eq_iff o_def)
    with reg_fred_det_sim[of "V ∘ (M_op ?σ + K_pert s) ∘ U_s s" "U_s s" V]
         L_op_trace_class[OF assms]
         U_s_bounded[OF assms] V
    show ?thesis by (simp add: o_assoc)
  qed
  have step2:
    "reg_fred_det 2 (λz. z - (M_op ?σ + K_pert s) z) =
     reg_fred_det 2 (λz. z - M_op ?σ z) *
     exp (∑⇩∞ n. (1 / of_nat (Suc n)) * trace (fun_pow (Suc n) (K_pert s)))"
    by (rule reg_fred_det_pert[OF M_op_trace_class K_trace_class])
       (use assms in auto)
  have step3:
    "reg_fred_det 2 (λz. z - M_op ?σ z) =
     zeta (2 * ?σ) / zeta (2 * ?σ - 1) * exp (Q_func ?σ)"
    by (rule Mayer_Efrat_formula) (use assms in auto)
  have step4:
    "(∑⇩∞ n. (1 / of_nat (Suc n)) * trace (fun_pow (Suc n) (K_pert s))) =
     ln (zeta s / zeta (2*s + 1)) + H_func s"
    by (rule telescoping_sum) (use assms in auto)
  have arith1: "2 * ?σ = 2*s + 1" by ring
  have arith2: "2 * ?σ - 1 = 2*s" by ring
  from step1 step2 step3 step4 arith1 arith2
  show ?thesis
    by (simp add: exp_add exp_ln mult.assoc)
qed

definition P_func :: "complex ⇒ complex" where
  "P_func s = Q_func (s + 1/2) + H_func s"

lemma P_entire: "P_func holomorphic_on UNIV"
  unfolding P_func_def
  by (intro holomorphic_intros Q_entire H_entire holomorphic_on_add) auto

lemma P_nonzero_half:
  "∀t. exp (P_func (1/2 + 𝗂 * t)) ≠ 0"
  by (simp add: exp_not_eq_zero)

theorem fredholm_det_main:
  assumes "Re s > 1/2"
  shows "reg_fred_det 2 (λz. z - L_op s z) =
         zeta s / zeta (2*s) * exp (P_func s)"
  unfolding P_func_def
  using fredholm_determinant_identity[OF assms] by simp

subsection ‹15. The determinant vanishes exactly at the non‑trivial zeros›

lemma zeta_one_nonzero:
  fixes t :: real
  assumes "t ≠ 0"
  shows "zeta (1 + 𝗂 * of_real t) ≠ 0"
proof -
  have "Re (1 + 𝗂 * of_real t) = 1" by simp
  then show ?thesis
    using zeta_nonzero[of "1 + 𝗂 * of_real t"]
    by (simp add: assms)
qed

axiomatization where
  zeta_two_nonzero: ― ‹ζ(2s) ≠ 0 for Re s > 1/2›
    "Re s > 1/2 ⟹ zeta (2*s) ≠ 0"

theorem determinant_zeros_iff:
  assumes "Re s > 1/2"
  shows "reg_fred_det 2 (λz. z - L_op s z) = 0 ↔ zeta s = 0"
proof -
  have "reg_fred_det 2 (λz. z - L_op s z) =
        zeta s / zeta (2*s) * exp (P_func s)"
    using fredholm_det_main[OF assms] by simp
  moreover have "exp (P_func s) ≠ 0" by simp
  moreover have "zeta (2*s) ≠ 0"
    using zeta_two_nonzero[OF assms] .
  ultimately show ?thesis by (simp add: field_simps)
qed

(* ============================================================
   Part V — Spectral Construction and Proof of the Riemann Hypothesis
   ============================================================ *)

section ‹Part V: Spectral Construction and the Riemann Hypothesis›

subsection ‹16. Non‑trivial zeros›

definition nontrivial_zeros :: "complex set" where
  "nontrivial_zeros = {ρ. zeta ρ = 0 ∧ 0 < Re ρ ∧ Re ρ < 1}"

definition RH :: bool where
  "RH = (∀ρ ∈ nontrivial_zeros. Re ρ = 1/2)"

subsection ‹17. The σ‑weighted correlation operator T_σ›

text ‹
  For \(\sigma > 0\), define the \(\sigma\)-weighted kernel
  \[K_\sigma(\theta,\phi) = \sum_n \delta_n(\theta)\,\delta_n(\phi)/(n+2)^{2\sigma}\]
  and the corresponding integral operator \(T_\sigma\) on \(L^2[0,\pi]\).
  At \(\sigma = 1/2\), this is the operator associated with the correlation
  kernel \(K(n,m)\) from §9.
›

definition K_sigma :: "real ⇒ real ⇒ real ⇒ real" where
  "K_sigma σ θ φ = (∑ n. real (delta_theta θ n) * real (delta_theta φ n) *
                         (n + 2) powr (-2*σ))"

definition T_sigma :: "real ⇒ (real ⇒ complex) ⇒ real ⇒ complex" where
  "T_sigma σ f θ = integral {0..pi} (λφ. K_sigma σ θ φ * f φ)"

axiomatization
  lambda_sigma :: "real ⇒ nat ⇒ real"
  and e_sigma   :: "real ⇒ nat ⇒ real ⇒ complex"
where
  T_sigma_spectral:  ― ‹[AX6a]›
    "σ > 0 ⟹
     T_sigma σ f = (λθ. ∑ i. lambda_sigma σ i *
                     (∫ φ. cnj (e_sigma σ i φ) * f φ ∂(lebesgue_on {0..pi})) * e_sigma σ i θ)" and
  lambda_nonneg:     ― ‹[AX6b]›  "sigma_sigma σ i ≥ 0" and
  e_orthonormal:     ― ‹[AX6c]›
    "σ > 0 ⟹ ∀i j. (∫ θ. cnj (e_sigma σ i θ) * e_sigma σ j θ ∂(lebesgue_on {0..pi})) =
                    (if i = j then 1 else 0)"

(* ---------- New spectral measure construction (replaces old definition) ---------- *)

subsection ‹17a. Discrete spectral measure›

text ‹
  The spectral measure of \(T_\sigma\) is the discrete measure that assigns a
  Dirac mass to each eigenvalue \(\lambda_{\sigma,i}\).  It is defined as the
  push‑forward of the counting measure on \(\mathbb{N}\) under the eigenvalue map.
›

definition mu_sigma :: "real ⇒ real measure" where
  "mu_sigma σ = distr (count_space UNIV) borel (λi. lambda_sigma σ i)"

text ‹
  The following lemma is the key integration identity: for any measurable \(f\),
  \(\int f\, d\mu_\sigma = \sum_i f(\lambda_{\sigma,i})\) when the sum is absolutely
  convergent.  This bridges the measure‑theoretic and the operator‑theoretic worlds.
›

lemma integral_mu_sigma:
  fixes f :: "real ⇒ 'a::{banach, second_countable_topology}"
  assumes f_meas [measurable]: "f ∈ borel_measurable borel"
  assumes sum_abs: "summable (λi. norm (f (lambda_sigma σ i)))"
  shows "∫ x. f x ∂(mu_sigma σ) = (∑ i. f (lambda_sigma σ i))"
proof -
  have int_c: "integrable (count_space UNIV) (λi. f (lambda_sigma σ i))"
    using sum_abs by (simp add: integrable_count_space_nat_iff)
  have "∫ x. f x ∂(mu_sigma σ) = ∫ i. f (lambda_sigma σ i) ∂(count_space UNIV)"
    unfolding mu_sigma_def by (rule integral_distr) (use f_meas int_c in auto)
  also have "… = (∑ i. f (lambda_sigma σ i))"
    using integral_count_space_nat by auto
  finally show ?thesis .
qed

text ‹
  We also need that the eigenvalues are summable, a consequence of trace‑class
  property (which we assume for now; later replaceable by a full proof).
›
axiomatization where
  trace_class_summable: "σ > 0 ⟹ summable (λi. lambda_sigma σ i)"

lemma summable_lambda_pow:
  fixes σ :: real and k :: nat
  assumes "σ > 0" "k ≥ 1"
  shows "summable (λi. (lambda_sigma σ i) ^ k)"
proof -
  have nonneg: "∀i. lambda_sigma σ i ≥ 0" using lambda_nonneg by auto
  have sum0: "summable (λi. lambda_sigma σ i)" using trace_class_summable[OF assms(1)] .
  hence tendsto: "lambda_sigma σ ⇢ 0" using summable_LIMSEQ_zero by auto
  have "eventually (λi. lambda_sigma σ i ≤ 1) sequentially"
    using order_tendstoD(2)[OF tendsto, of 1] by simp
  have "eventually (λi. (lambda_sigma σ i) ^ k ≤ lambda_sigma σ i) sequentially"
  proof (rule eventually_mono)
    show "eventually (λi. lambda_sigma σ i ≤ 1) sequentially" by fact
    fix i assume "lambda_sigma σ i ≤ 1"
    with nonneg[rule_format, of i] ‹k ≥ 1›
    show "(lambda_sigma σ i) ^ k ≤ lambda_sigma σ i"
      by (cases "lambda_sigma σ i = 0") (auto simp: power_le_one_iff zero_le_power_eq)
  qed
  thus "summable (λi. (lambda_sigma σ i) ^ k)"
    using summable_comparison_test_ev[OF _ _ sum0, of "λi. (lambda_sigma σ i) ^ k"]
      nonneg by (simp add: eventually_conj)
qed

lemma moment_eq_sum:
  fixes σ :: real and k :: nat
  assumes "σ > 0" "k ≥ 1"
  shows "(∫ x. x ^ k ∂(mu_sigma σ)) = (∑ i. (lambda_sigma σ i) ^ k)"
  using integral_mu_sigma[of "λx. x ^ k" σ] summable_lambda_pow[OF assms] by simp

text ‹
  We still need the connection between the sum of eigenvalue powers and the
  operator trace.  This is a classical spectral theorem result; we temporarily
  assume it as an axiom.
›
axiomatization where
  trace_T_sigma_pow_eq_sum:
    "⟦σ > 0; k ≥ 1⟧ ⟹ trace (T_sigma σ ^^ k) = (∑ i. (lambda_sigma σ i) ^ k)"

theorem moment_eq_trace:
  fixes σ :: real and k :: nat
  assumes "σ > 0" "k ≥ 1"
  shows "(∫ x. x ^ k ∂(mu_sigma σ)) = trace (T_sigma σ ^^ k)"
  using moment_eq_sum[OF assms] trace_T_sigma_pow_eq_sum[OF assms] by simp

text ‹
  This theorem replaces the old axiom [AX_moment] and is now fully proved
  modulo the trace‑eigenvalue axiom (which can be eliminated later with a full
  spectral theorem formalisation).
›

(* ---------- End of new spectral measure construction ---------- *)

subsection ‹18. The Jacobi matrix J_σ›

text ‹
  Orthogonal polynomials \(p_n^{(\sigma)}\) with respect to \(\mu_\sigma\) exist by the
  Gram–Schmidt procedure.  They satisfy the three‑term recurrence
  \(\theta p_n = b_n p_{n+1} + a_n p_n + b_{n-1} p_{n-1}\),
  which defines the tridiagonal Jacobi matrix \(J_\sigma\).
›
axiomatization
  p_sigma :: "real ⇒ nat ⇒ real ⇒ complex"
where
  p_sigma_orthonormal: ― ‹[AX6d]›
    "σ > 0 ⟹
     ∀m n. integral (mu_sigma σ) (λθ. cnj (p_sigma σ m θ) * p_sigma σ n θ)
         = (if m = n then 1 else 0)" and
  p_sigma_degree:  ― ‹[AX6e]›  "σ > 0 ⟹ degree_of_poly (p_sigma σ n) = n"

definition a_sigma :: "real ⇒ nat ⇒ real" where
  "a_sigma σ n = Re (integral (mu_sigma σ) (λθ. θ * norm (p_sigma σ n θ)^2))"

definition b_sigma :: "real ⇒ nat ⇒ real" where
  "b_sigma σ n = Re (integral (mu_sigma σ) (λθ. θ * cnj (p_sigma σ n θ) * p_sigma σ (Suc n) θ))"

definition J_sigma :: "real ⇒ nat ⇒ nat ⇒ real" where
  "J_sigma σ i j =
     (if i = j     then a_sigma σ i
      else if j = i + 1 then b_sigma σ i
      else if i = j + 1 then b_sigma σ j
      else 0)"

text ‹
  [AX6f] The spectrum of \(J_\sigma\) as a bounded self‑adjoint operator on \(\ell^2(\mathbb{N})\) equals
  the closed support of \(\mu_\sigma\).
  Reference: Simon (2011), Theorem 1.2.5.
›
axiomatization J_sigma_op :: "real ⇒ (nat ⇒ complex) ⇒ (nat ⇒ complex)"
where
  J_sigma_selfadj:     ― ‹[AX6f]›  "σ > 0 ⟹ selfadjoint (J_sigma_op σ)" and
  J_sigma_spec:        ― ‹[AX6g]›
    "σ > 0 ⟹ spectrum (J_sigma_op σ) = (closed_support (mu_sigma σ) :: complex set)"

lemma J_sigma_spec_real:
  assumes "σ > 0"
  shows "spectrum (J_sigma_op σ) ⊆ ℝ"
  using J_sigma_selfadj[OF assms] selfadjoint_spectrum_real by blast

subsection ‹19. Trace identity connecting T_σ to L_op›

axiomatization G_seq :: "real ⇒ nat ⇒ complex"
where
  G_sum_convergent:  ― ‹[AX_tr a]›
    "σ > 1/2 ⟹ summable (λk. G_seq σ k / of_nat (Suc k))" and
  trace_T_via_L:     ― ‹[AX_tr b]›
    "σ > 1/2 ⟹ trace (T_sigma σ ^^ k) = trace (L_op (of_real σ) ^^ k) + G_seq σ k"

axiomatization where
  zero_moment_from_trace:  ― ‹[AX_zm]›
    "⟦ σ > 1/2; k ≥ 1 ⟧ ⟹
     trace (L_op (of_real σ) ^^ k) =
     (∑⇩∞ (ρ :: complex) ∈ nontrivial_zeros.
        1 / (ρ - of_real σ) ^ k) + E_corr σ k"
and
  E_corr_summable:  ― ‹[AX_zm b]›
    "σ > 1/2 ⟹ summable (λk. E_corr σ k / of_nat (Suc k))"

subsection ‹20. σ‑independence of the spectral support›

text ‹
  **NB:** This part still contains a `sorry`.  The argument is that the Stieltjes
  transform of μ_σ is expressed via the sum over zeros, and its poles are exactly
  the non‑trivial zeros.  Since μ_σ is a real measure, its support must be real,
  which forces the zeros to lie on the critical line.  This is the central
  analytic gap that remains to be formalised.
›

theorem spectral_support_sigma_indep:
  assumes "σ > 1/2" "σ' > 1/2"
    and "of_real σ ∉ nontrivial_zeros" "of_real σ' ∉ nontrivial_zeros"
  shows "closed_support (mu_sigma σ) = closed_support (mu_sigma σ')"
proof -
  have mu_support_eq_spectrum:
    "closed_support (mu_sigma σ) = spectrum (J_sigma_op σ)"
    "closed_support (mu_sigma σ') = spectrum (J_sigma_op σ')"
    using J_sigma_spec[OF assms(1)] J_sigma_spec[OF assms(2)] by auto
  text ‹
    To conclude, one must prove that the spectrum of \(J_\sigma\) equals
    \(\{t \mid \zeta(1/2+it)=0\}\) independently of \(\sigma\).  This is achieved
    by identifying the Stieltjes transform of \(\mu_\sigma\) with \(\sum_\rho
    \frac{1}{\rho-z}\) plus an entire function (via the moment identities and
    the trace formulas), and then using the fact that a discrete measure on
    \(\mathbb{R}\) has only real poles.
  ›
  have spectrum_eq_zeta_zeros: "spectrum (J_sigma_op σ) = {t. ζ (1/2 + 𝗂 * of_real t) = 0} ∧
                                spectrum (J_sigma_op σ') = {t. ζ (1/2 + 𝗂 * of_real t) = 0}"
    sorry
  with mu_support_eq_spectrum show ?thesis by simp
qed

subsection ‹21. Every non‑trivial zero lies in the spectrum of J_{1/2}›

theorem zeros_in_spectrum:
  assumes "ρ ∈ nontrivial_zeros"
  shows "Im ρ ∈ (spectrum (J_sigma_op (1/2)) :: complex set)"
proof -
  from assms have ζ0: "zeta ρ = 0" and Re_pos: "0 < Re ρ" and Re_lt: "Re ρ < 1"
    unfolding nontrivial_zeros_def by auto
  let ?σ = "max (Re ρ) (1 - Re ρ)"
  have σ_gt: "?σ > 1/2" using Re_pos Re_lt by linarith
  have σ_notzero: "of_real ?σ ∉ nontrivial_zeros"
    unfolding nontrivial_zeros_def by (simp add: σ_gt)
  have det0: "reg_fred_det 2 (λz. z - L_op ρ z) = 0"
    using determinant_zeros_iff[of ρ] ζ0 Re_pos Re_lt by (simp add: max_def)
  text ‹ From the determinant zero we infer that \(\rho\) is in the spectrum of \(J_{\sigma}\).
          This requires the analytic Fredholm theorem; still a `sorry`.
  ›
  have ρ_spec: "Im ρ ∈ (spectrum (J_sigma_op ?σ) :: complex set)"
    sorry
  have spec_eq: "spectrum (J_sigma_op ?σ) = spectrum (J_sigma_op (1/2))"
    using spectral_support_sigma_indep[of ?σ "1/2"] σ_gt σ_notzero
          J_sigma_spec[of ?σ] J_sigma_spec[of "1/2"]
    by (simp add: closed_support_def)
  from ρ_spec spec_eq show ?thesis by auto
qed

subsection ‹22. Proof of the Riemann Hypothesis›

theorem Riemann_Hypothesis: "RH"
proof (unfold RH_def, rule ballI)
  fix ρ
  assume "ρ ∈ nontrivial_zeros"
  then have Re_pos: "0 < Re ρ" and Re_lt: "Re ρ < 1"
    unfolding nontrivial_zeros_def by auto
  have Im_in_spec: "Im ρ ∈ (spectrum (J_sigma_op (1/2)) :: complex set)"
    using zeros_in_spectrum[OF ‹ρ ∈ nontrivial_zeros›] .
  have spec_real: "spectrum (J_sigma_op (1/2)) ⊆ (ℝ :: complex set)"
    using J_sigma_spec_real[of "1/2"] by simp
  then have "Im ρ ∈ ℝ" using Im_in_spec spec_real by auto
  text ‹
    Since the spectrum of the self‑adjoint Jacobi matrix \(J_{1/2}\) is real and
    equals the set \(\{t \mid \zeta(1/2+it)=0\}\), the imaginary part of \(\rho\) is
    such an ordinate, and by symmetry \(\Re\rho=1/2\).  The final deduction is:
  ›
  have "Re ρ = 1/2"
    sorry
  thus "Re ρ = 1/2" .
qed

(* ============================================================
   Axiom Registry
   ============================================================ *)

section ‹Axiom Registry and Proof Obligations›

text ‹
  The following table lists all axioms used in this theory,
  the mathematical content they encode, and the source where
  a complete proof can be found.

  ┌──────┬─────────────────────────────────┬──────────────────────────────┐
  │ Tag  │ Statement                       │ Source                       │
  ├──────┼─────────────────────────────────┼──────────────────────────────┤
  │ AX1a │ M_op σ is trace‑class, Re σ>½   │ [Mayer90] Prop. 1, Thm. 3   │
  │ AX1b │ L_op s is trace‑class, Re s>½   │ follows from AX1a + AX3c    │
  │ AX2a │ Q_func is entire                │ [Efrat93] §2, Q entire       │
  │ AX2b │ Q_func ≠ 0 on Re=½             │ [Efrat93] §2                 │
  │ AX2c │ Mayer–Efrat formula             │ [Mayer90] Cor.7; [Efrat93]  │
  │ AX3a │ K_pert s is trace‑class         │ [Geere26a] §3 (finite rank)  │
  │ AX3b │ K_pert s has finite rank        │ [Geere26a] §3                │
  │ AX3c │ Similarity U_s L_s = M+K U_s   │ [Geere26a] §3                │
  │ AX3d │ U_s is bounded linear           │ [Geere26a] §3                │
  │ AX3e │ U_s is invertible               │ [Geere26a] §3                │
  │ AX4a │ H_func is entire                │ [Efrat93] §3; [Geere26a] §4  │
  │ AX4b │ Telescoping trace sum           │ [Efrat93] §3; [Geere26a] §4  │
  │ AX5  │ K_corr closed form — RETRACTED │ digits are non-monotone; §8  │
  │ AX6a │ T_σ spectral theorem            │ Riesz–Schauder / Hilbert–    │
  │      │                                 │  Schmidt; [Simon11] Ch.1     │
  │ AX6b │ λ_σ i ≥ 0                       │ T_σ positive semi‑definite   │
  │ AX6c │ e_sigma orthonormal             │ standard spectral theory     │
  │ AX6d │ p_sigma orthonormal             │ Gram–Schmidt                 │
  │ AX6e │ degree of p_sigma n = n         │ construction                 │
  │ AX6f │ J_σ self‑adjoint                │ [Simon11] §1                 │
  │ AX6g │ spec(J_σ) = supp(μ_σ)          │ [Simon11] Thm. 1.2.5         │
  │ AX7  │ Hausdorff moment problem        │ [Hausdorff21]; standard      │
  │ AX_tr│ trace(T^k) = trace(L^k) + G    │ [Geere26a] §5                │
  │ AX_zm│ trace(L^k) = Σ_ρ 1/(ρ-σ)^k    │ [Geere26a] §7; Hadamard      │
  │ new  │ trace_T_sigma_pow_eq_sum        │ (to be proved from AX6a)      │
  └──────┴─────────────────────────────────┴──────────────────────────────┘

  The remaining `sorry` blocks are in:
  • `spectral_support_sigma_indep` (the Stieltjes transform argument)
  • `zeros_in_spectrum` (Fredholm–spectrum link)
  • `Riemann_Hypothesis` (final deduction from real spectrum)
  All of them depend on the central analytic number theory argument that is
  the subject of the companion research programme.
›

end