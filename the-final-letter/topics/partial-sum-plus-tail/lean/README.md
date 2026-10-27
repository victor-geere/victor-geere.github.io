# Lean core — partial sum plus tail

## Build

```bash
cd the-final-letter/topics/partial-sum-plus-tail
./lean/check.sh
```

`check.sh` compiles `IBox.lean`, `Expr.lean`, `Transcend.lean`, `Replay.lean`,
`ReplayAtoms.lean`, `Topic.lean`, `SourceClaims.lean`, `EulerMaclaurin.lean`,
`Width.lean`, `WidthCheck.lean`, `ReplayGeneral.lean` and
`EnclosureHypothesis.lean` in dependency order against the shared Mathlib at
`~/lean/mathlib4`. The recorded build is [`BUILD.log`](BUILD.log).

## What is formalised

| File | Content |
|---|---|
| [`IBox.lean`](IBox.lean) | Rational intervals `Iv` and complex rectangles `Cx`; soundness of `add`, `neg`, `sub`, `scale`, `mul`, `inflate` over both `ℚ` and `ℝ`. |
| [`Expr.lean`](Expr.lean) | The straight-line certificate language `Expr`, the computable checker `wf`, and the inclusion theorem `wf_sound`: if every atom lies in its declared box and `wf` accepts, the denoted value lies in the final box. |
| [`Transcend.lean`](Transcend.lean) | Kernel-checked enclosures for `π`, `exp`, `log`, `sin` and `cos`: Taylor/log series, explicit geometric or alternating remainders, `Real.hasSum_log_one_add`, `Real.hasSum_cos`/`sin`, and `2π` reduction. |
| [`Replay.lean`](Replay.lean) | A concrete generated ζ(2) certificate; `cert_mem` applies `wf_sound` and `native_decide` checks `wf`. |
| [`ReplayAtoms.lean`](ReplayAtoms.lean) | The true atom values `σ`, the totalised boxes `A'`, and `atom_mem'`; `cert_mem_closed` is the replay with no atom hypothesis. |
| [`Topic.lean`](Topic.lean) | The partial-sum-plus-tail transport lemmas (`tsum_eq_finite_add_tail`, the residual and three-tail bounds) and the eta cos/sin split (`etaTerm_re`, `etaTerm_im`, `etaPartial_re`, `etaPartial_im`). |
| [`SourceClaims.lean`](SourceClaims.lean) | S3: `riemannZeta_nat_re_le` (`ζ(m) ≤ 1 + 1/(m−1)`), S4: `eta_eq_one_sub_two_cpow_mul_zeta`, and S5: `LFunction_eq_hurwitz_sum` (the finite Hurwitz-zeta sum with the `j = 0` term removed). |
| [`ReplayGeneral.lean`](ReplayGeneral.lean) | **P1, rectangle form.** The domain bridge `zeta_eq_hurwitzZetaNP_one`; rational radius bounds for complex powers, the integral, the iterated derivatives/Bernoulli corrections and the tail; and their assembly `zeta_mem_box`, a closed enclosure of `ζ(s)` for every `s` with `Re s > 1`, arbitrary `M, K`, with no atom hypothesis. Checked at ζ(2) (`zeta_two_mem_box`). |
| [`Width.lean`](Width.lean) | **P2.** `Cx.width`, the target-width checker `Expr.wfWidth`, and its soundness theorem `Expr.wfWidth_sound`. |
| [`WidthCheck.lean`](WidthCheck.lean) | The ζ(2) replay accepted by the width checker at target `10⁻⁴`, with every atom discharged (`cert_wfWidth`, `cert_mem_width`). |
| [`EnclosureHypothesis.lean`](EnclosureHypothesis.lean) | **R14 template.** `ne_zero_of_mem_of_not_mem_zero`; no numerical critical-strip instance is claimed. |
| [`CpowBox.lean`](CpowBox.lean) | **Complex-power atom.** `cpowBox N k n m b S` combines `logIv`, `expIvGeneral`, `cosBox`/`sinBox` and `2π` reduction into a box for `b^{-s}` on `s ∈ S`; `cpowBox_mem` proves soundness from four checkable side conditions. A concrete `3^{-(1/2+5i)}` instance is checked. |
| [`EulerMaclaurin.lean`](EulerMaclaurin.lean) | First stage of the S1–S2 formalisation: `periodicBernoulli` and the non-periodic `hurwitzZetaNP`, with `periodicBernoulli_add_one`, `periodicBernoulli_zero`, `periodicBernoulli_intCast` and `hurwitzZetaNP_eq_hurwitzZeta_of_mem_Ico` and `hurwitzZetaNP_eq_tsum` (the ordinary Hurwitz series for `Re s > 1`). It also proves the `K = 0` finite Euler–Maclaurin identity (`finite_eulerMaclaurin_zero`), the interior derivative `B̃_n' = n B̃_{n-1}` (`hasDerivAt_periodicBernoulli`), the polynomial model of `B̃_n` on each unit interval, the endpoint Bernoulli values, and the first polynomial integration-by-parts identity, the raw unit-interval recursion `unit_recursion_raw`, the global recursion `global_recursion_raw` obtained by summing over adjacent intervals, and its odd specialisation `odd_recursion_mul`. It uses the a.e. identification of `B̃₁`, local integration by parts, interval integrability, and the telescoping sum. The general finite Euler–Maclaurin induction is now proved as `finite_eulerMaclaurin` for smooth (not necessarily analytic) functions, and the smooth cutoff extension `hurwitzSmooth` is constructed for `(a+x)^{-s}`; Fourier inversion, the ζ-sum evaluation, and the Bernoulli supremum bound `‖B̃_{2K+1}‖∞ ≤ 2(2K+1)! ζ(2K+1)/(2π)^(2K+1)` are also proved; the Dirichlet series `HasSum` representation of the non-periodic zeta for `Re s > 1` (`hasSum_hurwitzZetaNP`) and its differentiability away from `s = 0, 1` (`differentiableAt_hurwitzZetaNP`) are also proved; the tail integrability `integrableOn_hurwitzTerm`, the at-infinity decay `tendsto_hurwitzTerm_atTop_zero`, the improper integral `integral_Ioi_hurwitzTerm`, the iterated derivative formula via `rising`, and integrability of every derivative are also proved; the integral form of the S2 tail bound (`norm_integral_periodicBernoulli_mul_odd_le`) is also proved; the finite Euler–Maclaurin identity for the Hurwitz term `(a+x)^{-s}` (`finite_eulerMaclaurin_hurwitz`) is also proved; the endpoint decay lemmas `tendsto_hurwitzTerm_neg_atTop_zero` and `tendsto_iteratedDeriv_hurwitzTerm_atTop_zero` are also proved; the final S1 decomposition (`hurwitzZetaNP_eq_eulerMaclaurin`) and the combined S1/S2 theorem with tail bound (`hurwitzZetaNP_eulerMaclaurin_with_bound`) are proved for `K ≥ 1`. |

No `sorry`, no `axiom`, no `admit`.

## What is not formalised

- The eta reduction of the rectangle enclosure to `0 < Re s ≤ 1`, and the
  emission of a single symbolic `Expr` whose `wf` is checked. The rectangle
  enclosure for `Re s > 1` is proved in `ReplayGeneral.lean` (T44–T49); the
  identity and tail bound are T36–T43; S3–S5 are in `SourceClaims.lean`.
- A symbolic width theorem for `zetaBox`. The certificate format checks a target
  width for a concrete certificate (T50), but the rectangle enclosure is
  deliberately crude.
- The transcendental enclosures are now **proved** in `Transcend.lean` (see
  the theorem ledger T26–T31): `π` from Mathlib's 20-digit bounds, `exp` by a
  reduced Taylor series and arbitrary scaling, `log` from the positive
  `log(1+a)` series with a geometric tail, and `sin`/`cos` from the alternating
  series with a rigorous `2π` reduction.  The atom leaves of the concrete
  ζ(2) replay are discharged in `ReplayAtoms.lean` (`cert_mem_closed`), so the
  replay itself has no atom hypothesis. The Euler–Maclaurin formula and its
  tail bound are Lean theorems for `K ≥ 1` in `EulerMaclaurin.lean` (T36–T43).
- The independent certificate verifier and the certificate emitter: Python
  side (`verify_certificate.py`, `partial_tail.py`).
- Derivatives (`L'/L`), and the `s = 1` case for `L`.

The Lean replay of a concrete certificate uses `native_decide` to evaluate
`Expr.wf`; `Expr.wf_sound` itself is kernel-checked.

This layer enters the letter as Objective III. [Proof ledger C](../../../categories/05-proofs/proofs.md#c-the-certified-evaluation-layer) records what it proves and what remains a source claim; [finding F11](../../../categories/06-findings/findings.md#f11-certified-evaluation-is-an-instrument-not-a-key) records its role as an instrument rather than a bridge.

[Back to the programme](../README.md) · [Topic index](../../README.md)
