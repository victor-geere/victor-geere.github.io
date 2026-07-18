theory GDST_Transform
  imports GDST_Correlation_Kernel
begin

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

end
