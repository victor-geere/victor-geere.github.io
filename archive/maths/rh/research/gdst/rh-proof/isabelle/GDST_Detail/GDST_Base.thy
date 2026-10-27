(* thys/GDST_Base.thy *)
theory GDST_Base
imports 
  Complex_Main
  "HOL-Analysis.Analysis"
begin

(* Mutual recursive definition of the greedy digit and remainder functions *)
fun delta :: "nat \<Rightarrow> real \<Rightarrow> real" and r :: "nat \<Rightarrow> real \<Rightarrow> real" where
  "delta 0 x = (if x \<ge> 1/2 then 1 else 0)"
| "r 0 x = x - delta 0 x * (1/2)"
| "delta (Suc n) x = (if r n x \<ge> 1 / of_nat (n+3) then 1 else 0)"
| "r (Suc n) x = r n x - delta (Suc n) x * (1 / of_nat (n+3))"

(*
  All other constants are declared but not yet defined.
  Their properties will be supplied later as axioms.
*)
consts
  zeta             :: "complex \<Rightarrow> complex"
  nontrivial_zeros :: "complex set"
  K_corr           :: "nat \<Rightarrow> nat \<Rightarrow> real"
  f                :: "nat \<Rightarrow> real \<Rightarrow> real"
  E_gdst           :: "real \<Rightarrow> complex \<Rightarrow> complex"
  Omega_gdst       :: "real \<Rightarrow> complex \<Rightarrow> complex"
  transfer_operator :: "complex \<Rightarrow> (complex \<Rightarrow> complex) \<Rightarrow> complex \<Rightarrow> complex"
  det2             :: "((complex \<Rightarrow> complex) \<Rightarrow> complex \<Rightarrow> complex) \<Rightarrow> complex"
  M_sigma          :: "complex \<Rightarrow> (complex \<Rightarrow> complex) \<Rightarrow> complex \<Rightarrow> complex"
  L_s              :: "complex \<Rightarrow> (complex \<Rightarrow> complex) \<Rightarrow> complex \<Rightarrow> complex"
  Q                :: "complex \<Rightarrow> complex"
  H                :: "complex \<Rightarrow> complex"
  P                :: "complex \<Rightarrow> complex"
  K_pert           :: "complex \<Rightarrow> (complex \<Rightarrow> complex) \<Rightarrow> complex \<Rightarrow> complex"
  U_s              :: "complex \<Rightarrow> (complex \<Rightarrow> complex) \<Rightarrow> complex \<Rightarrow> complex"
  T_sigma          :: "complex \<Rightarrow> (real \<Rightarrow> complex) \<Rightarrow> real \<Rightarrow> complex"
  mu_sigma         :: "complex \<Rightarrow> real measure"
  lambda_i         :: "complex \<Rightarrow> nat \<Rightarrow> real"
  J_sigma          :: "complex \<Rightarrow> (nat \<Rightarrow> real) \<Rightarrow> (nat \<Rightarrow> real)"
  S_reg            :: "complex \<Rightarrow> complex \<Rightarrow> complex"
  G_k              :: "complex \<Rightarrow> nat \<Rightarrow> complex"
  E_k              :: "complex \<Rightarrow> nat \<Rightarrow> complex"
  H_k              :: "complex \<Rightarrow> nat \<Rightarrow> complex"

axiomatization where placeholder: "True"

end