import DirichletL
import CertifiedWindow
import DirichletExplicit
import DirichletArchimedean
import DirichletPrimeTail
import DirichletZeroTail
import DirichletLogDeriv
import DirichletGammaLogDeriv
import DirichletCompletedLogDeriv
import DirichletWeightedResidue
import DirichletWeightedArgumentPrinciple
import DirichletCompletedSymmetry
import DirichletRightPathLinear
import DirichletExplicitWiring
import DirichletZeroCounting
import DirichletZeroCount2
import DirichletMellinPrereq
import GammaBounds
import DirichletStripBound
import DirichletExplicitWiring2

open RouteABC
#print axioms RouteABC.chi3_isPrimitive
#print axioms RouteABC.routeB_for_chi3_of_window
#print axioms RouteABC.dirichletWeight_pow_prime
#print axioms RouteABC.DirichletExplicitData.validated
#print axioms RouteABC.dirichletPsi_deriv_bound
#print axioms RouteABC.norm_dirichletWeight_le
#print axioms RouteABC.sum_vonMangoldt_le
#print axioms RouteABC.dirichletPrimeSideLog_remainder_le
#print axioms RouteABC.dirichletPrimeSideLog_remainder_le_decay
#print axioms RouteABC.zeroTail_le_of_majorant
#print axioms RouteABC.gaussian_zeroTail_le
#print axioms RouteABC.dirichletPrimeSide_remainder_le_decay
#print axioms RouteABC.LSeries_dirichletWeight_eq
#print axioms RouteABC.neg_logDeriv_LSeries_dirichlet
#print axioms RouteABC.Complex.logDeriv_Gammaℝ
#print axioms RouteABC.logDeriv_LFunction_eq
#print axioms RouteABC.logDeriv_dirichletCompleted_eq_even
#print axioms RouteABC.logDeriv_dirichletCompleted_eq_odd
#print axioms RouteABC.rectBoundary_const_mul_inv
#print axioms RouteABC.weighted_inv_decomp
#print axioms RouteABC.rectBoundary_mul_inv
#print axioms RouteABC.rectBoundary_dslope_eq_zero
#print axioms RouteABC.weighted_argument_principle_factorized
#print axioms RouteABC.weighted_argument_principle_of_logDeriv
#print axioms RouteABC.logDeriv_eq_of_factorization
#print axioms RouteABC.weighted_argument_principle_of_analytic
#print axioms RouteABC.logDeriv_dirichletCompleted_one_sub
#print axioms RouteABC.logDeriv_dirichletCompleted_conj
#print axioms RouteABC.logDeriv_dirichletCompleted_reflection
#print axioms RouteABC.rectBoundary_F_logDeriv_eq
#print axioms RouteABC.dirichletCompleted_zeroSum
#print axioms RouteABC.rightPath_add
#print axioms RouteABC.rightPath_sub
#print axioms RouteABC.routeC_residual_bound_of_zeroSum
#print axioms RouteABC.isClosed_dirichletLZeros
#print axioms RouteABC.isDiscrete_dirichletLZeros
#print axioms RouteABC.IsCompact.inter_dirichletLZeros_finite
#print axioms RouteABC.dirichletCompleted_routeBCount
#print axioms RouteABC.norm_dirichletWeight_mul_cpow_le
#print axioms RouteABC.summable_vonMangoldt_rpow
#print axioms RouteABC.tsum_norm_dirichletWeight_le
#print axioms RouteABC.norm_contour_integrand_le
#print axioms RouteABC.finite_dirichletZeroCount_set
#print axioms RouteABC.summable_log_mul_exp
#print axioms RouteABC.finite_dirichletZeroCountUpTo_set
#print axioms RouteABC.dirichletZeroCountUpTo_eq_add
#print axioms RouteABC.dirichletZeroCountUpTo_le_sum
#print axioms RouteABC.sum_countIn_range_le
#print axioms RouteABC.zeroCountUpTo_le_of_density
#print axioms RouteABC.summable_densityWeight_mul_exp
#print axioms RouteABC.dirichletZeroCountUpTo_mono
#print axioms RouteABC.zeroCountUpTo_le_of_density_real
#print axioms RouteABC.zeroCountUpTo_le_quadratic
#print axioms RouteABC.densitySpacing_le_zero
#print axioms RouteABC.zeroTail_le_of_density
#print axioms RouteABC.norm_contour_integrand_le_global
#print axioms RouteABC.contour_termwise_integral_measure
#print axioms RouteABC.contour_termwise_integral
#print axioms RouteABC.LSeries_dirichletWeight_eq_tsum
#print axioms RouteABC.contour_cLine_eq_arch_sub_prime
#print axioms RouteABC.verticalLine_transport
#print axioms RouteABC.rightPath_transport
#print axioms RouteABC.dirichlet_explicit_formula_assembled
#print axioms RouteABC.routeC_residual_bound_of_assembled
#print axioms RouteABC.termwise_integral_of_dominated
#print axioms RouteABC.hLine_termwise_integral
#print axioms RouteABC.norm_horizontal_integrand_le
#print axioms RouteABC.contour_hLine_eq_arch_sub_prime
#print axioms RouteABC.tsum_eq_finite_add_tail
#print axioms RouteABC.routeC_residual_bound_of_truncation
#print axioms RouteABC.dirichletExplicitDataOfAssembledTruncated
#print axioms RouteABC.dirichletCompleted_ne_zero_of_one_lt_re
#print axioms RouteABC.continuousOn_mul_logDeriv_dirichletCompleted
#print axioms RouteABC.differentiableAt_mul_logDeriv_dirichletCompleted
#print axioms RouteABC.continuous_digamma_halfLine
#print axioms RouteABC.intervalIntegrable_arch
#print axioms RouteABC.LSeriesSummable_dirichletWeight
#print axioms RouteABC.abscissaOfAbsConv_dirichletWeight_le_one
#print axioms RouteABC.continuous_LSeries_dirichletWeight
#print axioms RouteABC.intervalIntegrable_LSeries
#print axioms RouteABC.abs_re_tsum_le
#print axioms RouteABC.abs_primeTail_le
#print axioms RouteABC.norm_integral_primeTerm_le
#print axioms RouteABC.tsum_shift_le
#print axioms RouteABC.shifted_vonMangoldt_tail_le
#print axioms RouteABC.norm_LSeries_dirichletWeight_le
#print axioms RouteABC.exists_bound_logDeriv_dirichletCompleted
#print axioms RouteABC.norm_logDeriv_sub_arch_le
#print axioms RouteABC.norm_logDeriv_dirichletCompleted_le_of_digamma
#print axioms RouteABC.dirichletCompleted_zeroCount_le
#print axioms RouteABC.norm_rightPath_le
#print axioms RouteABC.dirichletCompleted_zeroCount_le_of_contour
#print axioms RouteABC.norm_rightPath_le_of_transport
#print axioms RouteABC.dirichletCompleted_zeroCount_le_of_criticalStrip
#print axioms RouteABC.one_le_analyticOrderNatAt_of_zero
#print axioms RouteABC.ncard_le_sum_analyticOrder
#print axioms RouteABC.dirichletZeroCountIn_le_orderSum
#print axioms RouteABC.dirichletZeroCount_le_of_sum_bound
#print axioms RouteABC.dirichletZeroCount_le_of_criticalStrip
#print axioms RouteABC.analyticOrderAt_ne_top_dirichletCompleted
#print axioms RouteABC.exists_Z_of_hbd
#print axioms RouteABC.zeroFreeSegment_of_hbd
#print axioms RouteABC.logDerivIntegrable_of_zeroFreeSegment
#print axioms RouteABC.logDerivIntegrable_of_hbd
#print axioms RouteABC.dirichletZeroCount_le_of_hbd
#print axioms RouteABC.riemannVonMangoldtDensity_of_criticalStrip
#print axioms RouteABC.dirichletZeroCountIn_le_of_criticalStrip
#print axioms RouteABC.exists_delta_avoiding
#print axioms RouteABC.dirichletZeroCount_le_countIn
#print axioms RouteABC.exists_hbd_shift
#print axioms RouteABC.exists_Z_shift
#print axioms RouteABC.log_absorb
#print axioms RouteABC.riemannVonMangoldtDensity_of_verticalFree
#print axioms RouteABC.gammaFactor_ne_zero_of_re_pos
#print axioms RouteABC.dirichletCompleted_ne_zero_of_re_eq_one
#print axioms RouteABC.dirichletCompleted_ne_zero_of_re_eq_zero
#print axioms RouteABC.verticalFree_of_ne_one
#print axioms RouteABC.riemannVonMangoldtDensity_of_stripBound
#print axioms RouteABC.riemannVonMangoldtDensity_of_interface
#print axioms RouteABC.norm_Gamma_le_Gamma_re
#print axioms RouteABC.digammaGrowthBound_of_stripBound_small
#print axioms RouteABC.digammaGrowthBound_of_stripBound_all
#print axioms RouteABC.rootNumberSign_of_inv_eq_self
#print axioms RouteABC.sum_range_inv_le_log
#print axioms RouteABC.sum_range_inv_sq_le
#print axioms RouteABC.abs_div_mul_sqrt_le_inv
#print axioms RouteABC.abs_div_mul_sqrt_le_abs_div_sq
#print axioms RouteABC.Lseq_head_bound
#print axioms RouteABC.Lseq_tail_bound
#print axioms RouteABC.Lseq_bound
#print axioms RouteABC.log_sub_log_le_sum_range_inv
#print axioms RouteABC.inv_add_eq_inv_sub
#print axioms RouteABC.Lseq_split
#print axioms RouteABC.sum_range_inv_succ_le_log
#print axioms RouteABC.Lseq_real_bracket_abs_le
#print axioms RouteABC.norm_ofReal_eq_abs
#print axioms RouteABC.norm_Lseq_le
#print axioms RouteABC.logDeriv_GammaSeq
#print axioms RouteABC.mellin_gammaKernel
#print axioms RouteABC.gammaKernel_eq_indicator
#print axioms RouteABC.gammaKernel_eq_min
#print axioms RouteABC.continuous_gammaKernel
#print axioms RouteABC.deriv_GammaSeq_eq_mellin
#print axioms RouteABC.tendsto_gammaKernel
#print axioms RouteABC.norm_gammaKernel_le
#print axioms RouteABC.abs_log_le_add_inv
#print axioms RouteABC.abs_log_le_rpow
#print axioms RouteABC.integrableOn_dominator
#print axioms RouteABC.continuousOn_cpow_ofReal_Ioi
#print axioms RouteABC.tendsto_mellin_log_gammaKernel
#print axioms RouteABC.tendsto_Lseq_digamma
#print axioms RouteABC.digammaGrowthBound_of_one_le
#print axioms RouteABC.digamma_norm_le_strip
#print axioms RouteABC.digammaGrowthBound_of_pos
#print axioms RouteABC.norm_le_three_lines
#print axioms RouteABC.norm_le_of_three_lines_regularised
#print axioms RouteABC.digamma_norm_le_quarter
#print axioms RouteABC.zeroCount_le_of_jensen
#print axioms RouteABC.zeroDivisor
#print axioms RouteABC.norm_Gamma_le_of_GammaSeq_bound
#print axioms RouteABC.sum_range_cast_id
#print axioms RouteABC.sum_div_sub_one
#print axioms RouteABC.log_factorial_div_pow_le
#print axioms RouteABC.prod_rpow_real
#print axioms RouteABC.rpow_succ_le_prod_one_add_div
#print axioms RouteABC.natCast_pow_mul_factorial_div_prod_le
#print axioms RouteABC.norm_GammaSeq_eq
#print axioms RouteABC.prod_le_prod_of_nonneg
#print axioms RouteABC.prod_sqrt_lower
#print axioms RouteABC.div_sqrt_le_min
#print axioms RouteABC.prod_min_one_div_le
#print axioms RouteABC.factorial_div_pow_pred_le
#print axioms RouteABC.norm_Gamma_le_of_GammaSeq_eventually
#print axioms RouteABC.norm_GammaSeq_le_eventually
#print axioms RouteABC.abs_mul_exp_neg_div_le
#print axioms RouteABC.Gamma_le_one_of_mem
#print axioms RouteABC.Gamma_le_two_of_mem
#print axioms RouteABC.factorial_div_pow_ceil_le
#print axioms RouteABC.exp_half_le_three
#print axioms RouteABC.two_le_sixtyFour_mul_exp_neg_half
#print axioms RouteABC.norm_Gamma_le_decay_half
#print axioms RouteABC.norm_ofReal_add_mul_I_le
#print axioms RouteABC.Gamma_le_four_of_quarter
#print axioms RouteABC.norm_Gamma_le_decay_quarter
#print axioms RouteABC.norm_Gamma_le_decay_upper
#print axioms RouteABC.Gamma_eq_Gamma_add_two_div
#print axioms RouteABC.norm_Gammaℝ_le
#print axioms RouteABC.sum_range_natCast_chi_eq_univ
#print axioms RouteABC.sum_range_natCast_chi_eq_zero
#print axioms RouteABC.sum_range_mul_chi_eq_zero
#print axioms RouteABC.norm_sum_range_chi_le
#print axioms RouteABC.norm_natCast_cpow_neg
#print axioms RouteABC.norm_natCast_cpow_neg_anti
#print axioms RouteABC.sum_Ico_sub_telescope
#print axioms RouteABC.sum_Ico_rpow_sub_le

-- Part (A) step 3a: the complex Abel estimate and the O(log) bound for L on Re s ∈ [1,2].
#print axioms RouteABC.norm_cpow_neg_sub_le
#print axioms RouteABC.sum_Ico_rpow_neg_succ_le
#print axioms RouteABC.chi_zero_eq_zero
#print axioms RouteABC.norm_sum_range_chi_succ_le
#print axioms RouteABC.sum_Ico_mul_cpow_eq
#print axioms RouteABC.norm_sum_Ico_mul_cpow_le
#print axioms RouteABC.norm_sum_Ico_chi_cpow_le_cmplx
#print axioms RouteABC.norm_sum_Ico_chi_succ_cpow_le
#print axioms RouteABC.sum_range_rpow_neg_le_log
#print axioms RouteABC.norm_sum_Ico_chi_cpow_tail_le
#print axioms RouteABC.norm_chi_mul_cpow_neg_le
#print axioms RouteABC.norm_LSeries_range_le
#print axioms RouteABC.norm_LFunction_le_of_gt_one
#print axioms RouteABC.norm_LFunction_le_one
#print axioms RouteABC.norm_LFunction_le

-- Part (A) step 3b: the Mellin strip bound (journal §224/§225).
#print axioms RouteABC.norm_mellin_le
#print axioms RouteABC.norm_Lambda0_le
#print axioms RouteABC.norm_Lambda_le

-- Part (A) step 3b, Abel machinery for `0 < Re s` (journal §223).
#print axioms RouteABC.mul_one_sub_le_rpow_neg_sub_one
#print axioms RouteABC.sum_Ico_rpow_neg_succ_le_of_pos
#print axioms RouteABC.norm_sum_Ico_mul_cpow_le_of_pos
#print axioms RouteABC.norm_sum_Ico_chi_cpow_le_of_pos
#print axioms RouteABC.norm_sum_Ico_chi_succ_cpow_le_of_pos

-- Part (A) O1.T12: the pi/2 isolation (journal §344).
#print axioms RouteABC.tendsto_arctan_div_atTop

-- Part (A) O1.T12: the pi/2 isolation (journal §344).

-- Part (A) O1.T12: the closed-form bracketing integral (journal §338).
#print axioms RouteABC.intervalIntegral_logSqrt_eq

-- Part (A) O1.T12(ii) COMPLETE: the sum-vs-integral comparison by induction (journal §335).
#print axioms RouteABC.integral_le_sum_Ico_logSqrt

-- Part (A) O1.T12(ii) step 3 RIGHT-endpoint (the direction T12 consumes) + pointwise monotonicity (journal §331).
#print axioms RouteABC.logSqrt_sq_mono
#print axioms RouteABC.intervalIntegral_logSqrt_le

-- Part (A) O1.T12(ii) step 3: the per-piece inequality (journal §328).
#print axioms RouteABC.logSqrt_le_intervalIntegral

-- Part (A) O1.T12(ii) step 1: monotonicity of the bracketing integrand (journal §326).
#print axioms RouteABC.monotoneOn_logSqrt_sq

-- Part (A) O1.T12(i): the GammaSeq bracketing antiderivative (journal §324).
#print axioms RouteABC.hasDerivAt_gammaAntideriv
#print axioms RouteABC.hasDerivAt_gammaAntideriv_sqrt

-- Part (A) O1.T11: hH's integrability is automatic in the zero-free case (journal §311).
#print axioms RouteABC.integrable_norm_completedLogDeriv_horizontal

-- Part (A) O1.T5: the count bound conditional on the two inputs (journal §305).
#print axioms RouteABC.dirichletCompleted_zeroCount_le_of_L_and_hH

-- Part (A) O1.T10 COMPLETE: the interface from two named hypotheses (journal §303).
#print axioms RouteABC.criticalStripLogDerivBound_of_L_and_hH

-- Part (A) O1.T10: hH reduces to its integrable case (journal §302).
#print axioms RouteABC.exists_horizontal_bound_of_integrable_case

-- Part (A) O1.T10 step 3 COMPLETE: hV itself (journal §300).
#print axioms RouteABC.exists_integral_completedLogDeriv_re_one_le_of_L

-- Part (A) O1.T10 step 3(b): vertical-edge integrability (journal §296).
#print axioms RouteABC.intervalIntegrable_norm_completedLogDeriv_re_one

-- Part (A) O1.T10 step 3(c): the weighted-product chaining for hV (journal §294).
#print axioms RouteABC.weighted_product_le

-- Part (A) O1.T10 step 3(a): vertical-edge continuity of the log-derivative (journal §292).
#print axioms RouteABC.continuousOn_logDeriv_dirichletCompleted_re_one

-- Part (A) O1.T10 step 3: the elementary interval log bound (journal §290).
#print axioms RouteABC.abs_le_of_mem_Icc
#print axioms RouteABC.continuous_one_add_log_abs
#print axioms RouteABC.intervalIntegral_log_edge_le

-- Part (A) O1.T10 step 2: the conductor-augmented edge bound (journal §287).
#print axioms RouteABC.norm_completedLogDeriv_re_one_le_of_L

-- Part (A) O1.T10 step 1: the conductor term on the edge (journal §286).
#print axioms RouteABC.logDeriv_cpow_half
#print axioms RouteABC.logDeriv_dirichletCompleted_eq_re_one

-- Part (A) O1.T9/(V): the edge assembly, naming the two pointwise inputs (journal §279).
#print axioms RouteABC.norm_logDeriv_completedLFunction_re_one_le

-- Part (A) O1.T9/(V): the edge factorisation and decomposition (journal §277).
#print axioms RouteABC.completedLFunction_eq_gammaFactor_mul_LFunction_of_re_pos
#print axioms RouteABC.logDeriv_completedLFunction_eq_re_one

-- Part (A) O1.T9/(V): gammaFactor differentiability on the right half-plane (journal §276).
#print axioms RouteABC.differentiableAt_gammaFactor_of_re_pos

-- Part (A) O1.T9 corrected reading: the horizontal term vanishes where non-integrable (journal §272).
#print axioms RouteABC.horizontal_edge_eq_zero_of_not_integrable

-- Part (A) O1.T9: finiteness in a rectangle, and the perturbation lemma (journal §271).
#print axioms RouteABC.finite_zeros_in_reProdIm
#print axioms RouteABC.exists_zero_free_height_of_analytic

-- Part (A) O1.T9: discreteness of the zero set of a nonzero entire function (journal §271).
#print axioms RouteABC.isDiscrete_zeroSet_of_analyticOnNhd

-- Part (A) O1.T9: the perturbation-availability step of the contour repair (journal §269).
#print axioms RouteABC.exists_zero_free_height_of_finite

-- Part (A) O1.T9: the limit-passage step of the contour repair (journal §268).
#print axioms RouteABC.zeroCount_mono

-- Part (A) O1.T9/(V): h_gamma discharged, and (V) reduced to ONE hypothesis (journal §281).
#print axioms RouteABC.norm_logDeriv_gammaFactor_re_one_le
#print axioms RouteABC.norm_logDeriv_completedLFunction_re_one_le_of_L

-- Part (A) O1.T9/(V): the archimedean edge bound on [1/2,2], both parities (journal §280).
#print axioms RouteABC.norm_logDeriv_Gammaℝ_le

-- Part (A) O1.T9/(V): the gamma half of the vertical-edge bound (journal §273).
#print axioms RouteABC.norm_logDeriv_Gammaℝ_re_one_le

-- Part (A) step 4: route 1 (repaired), the polynomial bound on every right half-plane (journal §263).
#print axioms RouteABC.exists_norm_LFunction_le_div

-- Part (A) step 4: route 1 (repaired), the convexity substitute for `LFunction` (journal §256).
#print axioms RouteABC.exists_norm_LFunction_strip_le

-- Part (A) step 4: route 1 (repaired), `LFunction = dirichletSuccRangeLimit` on `0 < Re s` (journal §252).
#print axioms RouteABC.LFunction_eq_dirichletSuccRangeLimit

-- Part (A) step 4: route 1 (repaired), the connection to `LFunction` on `1 < Re s` (journal §251).
#print axioms RouteABC.dirichletSuccRangeLimit_eq_LFunction

-- Part (A) step 4: route 1 (repaired), holomorphy for the correct sequence (journal §250).
#print axioms RouteABC.differentiableOn_dirichletSuccRangeLimit

-- Part (A) step 4: route 1 (repaired), local uniform convergence for the correct sequence (journal §249).
#print axioms RouteABC.tendstoLocallyUniformlyOn_dirichletSuccRangeLimit

-- Part (A) step 4: route 1 (repaired), Cauchy and the limit for the correct sequence (journal §248).
#print axioms RouteABC.cauchySeq_dirichletSucc_range
#print axioms RouteABC.tendsto_dirichletSuccRangeLimit

-- Part (A) step 4: route 1 (repaired), uniform Cauchy on a strip for the correct sequence (journal §247).
#print axioms RouteABC.eventually_uniform_dirichletSucc_range_sub_lt

-- Part (A) step 4: route 1 (repaired), difference bound for the correct sequence (journal §246).
#print axioms RouteABC.norm_dirichletSucc_range_sub_le

-- Part (A) step 4: route 1, Dirichlet partial sums converge to `LFunction` (journal §241).
#print axioms RouteABC.tendsto_sum_range_LFunction

-- Part (A) step 4: route 1, the summand matches the `LSeries` term (journal §240).
#print axioms RouteABC.dirichlet_term_eq_LSeries_term

-- Part (A) step 4: route 1, the shift between the two partial-sum sequences (journal §239).
#print axioms RouteABC.dirichlet_range_shift

-- Part (A) step 4: route 1, holomorphy of the limit (journal §237).
#print axioms RouteABC.differentiableOn_dirichletRangeLimit

-- Part (A) step 4: route 1, local uniform convergence to the limit (journal §235).
#print axioms RouteABC.tendstoLocallyUniformlyOn_dirichletRangeLimit

-- Part (A) step 4: route 1, the pointwise limit of the Dirichlet partial sums (journal §233).
#print axioms RouteABC.tendsto_dirichletRangeLimit

-- Part (A) step 4: route 1, uniform Cauchy on a strip (journal §232).
#print axioms RouteABC.eventually_uniform_dirichlet_range_sub_lt

-- Part (A) step 4: route 1, the lower-index difference bound (journal §231).
#print axioms RouteABC.norm_dirichlet_range_sub_le

-- Part (A) step 4: route 1, range-Cauchy of the Dirichlet series (journal §230).
#print axioms RouteABC.cauchySeq_dirichlet_range

-- Part (A) step 4: route 1, the range-limit helpers (journal §229).
#print axioms RouteABC.tendsto_natCast_rpow_neg_atTop
#print axioms RouteABC.tendsto_natCast_succ_rpow_neg_atTop

-- Part (A) step 4: the interface reduced to its two edge bounds (journal §226).
#print axioms RouteABC.criticalStripLogDerivBound_of_edge_bounds

-- Part (A) step 3b COMPLETE (journal §225): the strip bound for `Λ_χ` and `dirichletCompleted χ`.
#print axioms RouteABC.norm_completedHurwitzZetaEven₀_le
#print axioms RouteABC.norm_completedHurwitzZetaOdd_le
#print axioms RouteABC.norm_completedLFunction_strip_le
#print axioms RouteABC.norm_dirichletCompleted_strip_le

-- Part (A) step 3b: the Re s = 1 boundary of `Λ_χ` and the open-strip holomorphy.
#print axioms RouteABC.tendsto_pow_mul_exp_neg_div_atTop
#print axioms RouteABC.tendsto_quadratic_mul_exp_neg_div_atTop
#print axioms RouteABC.exists_bound_log_mul_exp
#print axioms RouteABC.norm_gammaFactor_re_one_le
#print axioms RouteABC.completedLFunction_re_one
#print axioms RouteABC.norm_dirichletCompleted_re_one_le
#print axioms RouteABC.diffContOnCl_dirichletCompleted

-- Part (A) O1.T12 step 5 first brick: the stirlingSeq telescoping identity (journal §355).
#print axioms RouteABC.sum_range_log_stirlingSeq_telescope

-- Part (A) O1.T12 step 5 second brick: the partial-fraction telescoping sum (journal §357).
#print axioms RouteABC.sum_range_one_div_mul_succ

-- Part (A) O1.T12 step 5 orientation facts (journal §360).
#print axioms RouteABC.log_stirlingSeq_succ_antitone
#print axioms RouteABC.log_sqrt_pi_le_log_stirlingSeq

-- Part (A) O1.T12 step 5 brick 2prime: the 12-inside telescoping value (journal §361).
#print axioms RouteABC.sum_range_one_div_twelve_mul_succ

-- Part (A) O1.T12 step 5 brick 3: the backward Stirling tail bound (journal §363).
#print axioms RouteABC.log_stirlingSeq_sub_le

-- Part (A) O1.T12 step 5 COMPLETE: the sharp Stirling upper bound (journal §375).
#print axioms RouteABC.log_stirlingSeq_le_log_sqrt_pi_add

-- Part (A) O1.T12 step 2 first brick: the sharp Stirling upper bound for log n! (journal §378).
#print axioms RouteABC.log_factorial_le_stirling

-- Part (A) O1.T12 step 2b bridging brick: the norm-spelling identity (journal §382).
#print axioms RouteABC.log_norm_complex_add_nat

-- Part (A) O1.T12 step 2b bridging brick (product form) (journal §386).
#print axioms RouteABC.prod_norm_eq_prod_sqrt

-- Part (A) O1.T12 step 2b COMPLETE: the log of the norm identity (journal §387).
#print axioms RouteABC.log_norm_GammaSeq

-- Part (A) O1.T12 assembly (i): the Ico/range sum bridge (journal §392).
#print axioms RouteABC.sum_range_eq_sum_Ico_add

-- Part (A) O1.T12 assembly (ii) steps 1-5: the combined log bound (journal §403).
#print axioms RouteABC.log_norm_GammaSeq_le

-- Part (A) O1.T12 step 6(b) ingredient: arctan bounded by pi/2 (journal §407).
#print axioms RouteABC.arctan_le_pi_div_two

-- Part (A) O1.T12 step 6(b) ingredient: the log-in-n bound (journal §408).
#print axioms RouteABC.log_natCast_le_self

-- Part (A) O1.T12 step 6(b): the n log n cancellation (journal §411).
#print axioms RouteABC.mul_log_le_mul_log_add

-- Part (A) O1.T12 step 6(b): the arctan cancellation (journal §412).
#print axioms RouteABC.arctan_div_le_arctan_add_div

-- Part (A) O1.T12 step 6(b): the sigma log n cancellation (journal §413).
#print axioms RouteABC.mul_log_le_mul_log_add_left

-- Part (A) O1.T12 step 6(b): the log(2 pi n) cancellation (journal §414).
#print axioms RouteABC.log_two_pi_mul_le_self

-- Part (A) O1.T12 step 6(a): the exponentiated bound (journal §416).
#print axioms RouteABC.norm_GammaSeq_le_exp

-- Part (A) O1.T12 step 6(c) spelling bridge: log sqrt x = (1/2) log x (journal §418).
#print axioms RouteABC.log_sqrt_eq_half_mul_log

-- Part (A) O1.T12 step 6(c1) brick: the integral in the exponent spelling (journal §421).
#print axioms RouteABC.integral_logSqrt_eq

-- Part (A) O1.T12 step 6(c1) ingredient: 2 log(sigma+n) <= log((sigma+n)^2 + t^2) (journal §433).
#print axioms RouteABC.two_mul_log_le_log_sq_add

-- Part (A) O1.T12 step 6(c1) calc-step: the combined log cancellation (journal §442).
#print axioms RouteABC.n_log_cancel

-- Part (A) O1.T12 step 6(c1) calc-step: the arctan cancellation (journal §443).
#print axioms RouteABC.arctan_cancel

-- Part (A) O1.T12 step 6(c1): the combined sigma-log group (journal §456).
#print axioms RouteABC.sigma_log_group_le

-- Part (A) O1.T12 step 6(c1) key intermediate: the n-log absorption (journal §468).
#print axioms RouteABC.n_log_absorb

-- Part (A) O1.T12 step 6(c1): the log-variant absorption brick (journal §484).
#print axioms RouteABC.n_log_absorb_log

-- Part (A) O1.T12 re-aimed route: the product sum bounded below by (n+1) log|t| (journal §498).
#print axioms RouteABC.sum_log_norm_add_ge

-- Part (A) O1.T12 re-aimed route: the companion upper bound (journal §506).
#print axioms RouteABC.log_norm_add_le

-- Part (A) O1.T12 re-aimed route: the sum-level upper bound (journal §507).
#print axioms RouteABC.sum_log_norm_add_le

-- Part (A) O1.T12 re-aimed route: the sharp lower bound (journal §511).
#print axioms RouteABC.sum_log_le_sum_log_norm

-- Part (A) O1.T12 re-aimed route: the sum-level sharp lower bound (journal §512).
#print axioms RouteABC.sum_log_norm_ge

-- Part (A) O1.T12 corrected target: log||GammaSeq s n|| -> log||Gamma s|| (journal §518).
#print axioms RouteABC.tendsto_log_norm_GammaSeq

-- Part (A) O1.T12 final bound first brick: the GammaSeq size bound (journal §528).
#print axioms RouteABC.log_norm_GammaSeq_le_sum
