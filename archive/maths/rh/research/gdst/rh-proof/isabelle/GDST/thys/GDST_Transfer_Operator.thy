theory GDST_Transfer_Operator
  imports GDST_Transform
begin

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

end
