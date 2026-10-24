import Qrime
import Separation
import Mobius
import Curve
import Cubic
import Barrier
import Quad
import Cubing
import Distribution
import ArtinSchreier
import Resolvent
import Variance
import B4
import QuarticPoly
import ExtremalQuartic
import DepressedQuartic
import EvenQuartic
import JInvariant
import Doubling
import Gap
import Shift
import Collision
import Scale
import DerivativeQ
import CubeSym
import Fiber
import ValueSet
import Crit
import JZero
import Chebotarev
import DivisorSum
import SmallCap
import Factorization
import QuadFiber
import Composition
import NegSquare
import QSize
import QOrbit
import Periodic
import NonPeriodic

#print axioms Qrime.card_monic
#print axioms Qrime.shift_bijective
#print axioms Qrime.linear_not_determine_twin
#print axioms Qrime.local_factor

-- round 3: the separation and the Möbius inversion
#print axioms Separation.no_zeta_observable
#print axioms Separation.irreducible_quad_of_noRoot
#print axioms Separation.witness_irreducible
#print axioms Separation.separation_F7
#print axioms ZetaMobius.mobius_inversion
#print axioms ZetaMobius.mobius_inversion_rat

-- round 4: the curve lift and the degree-3 exact check
#print axioms CurveLift.no_pair_function_of_zeta
#print axioms CurveLift.witness_irreducible
#print axioms CurveLift.pair_shift_two
#print axioms CurveLift.pair_shift_one
#print axioms CurveLift.curve_separation
#print axioms CubicTwins.cubicTwin_five
#print axioms CubicSeven.cubicTwin_seven
#print axioms CubicSeven.sum_cubicTwin7
#print axioms CubicAverageFive.sum_cubicTwin5
#print axioms CubicAverageFive.cubicTwin5_shift_independent

-- round 12: the cubing bijection
#print axioms Cubing.cube_eq_one
#print axioms Cubing.cube_injective
#print axioms Cubing.cube_bijective

-- round 13: the uniform d=2 distribution
#print axioms QuadDistribution.d2_five
#print axioms QuadDistribution.d2_seven
#print axioms QuadDistribution.d2_eleven
#print axioms QuadDistribution.d2_thirteen

-- round 14: the degree-3 distribution over F_5
#print axioms CubicDistribution.cubic_fam_dist_five
#print axioms CubicDistribution.sum_cubic_fam_five
#print axioms CubicDistributionSeven.cubic_fam_dist_seven

-- round 15: the Artin-Schreier collapse
#print axioms ArtinSchreier.pow_five_eq_self
#print axioms ArtinSchreier.eval_artin_schreier
#print axioms ArtinSchreier.artin_schreier_no_root
#print axioms ArtinSchreier.derivative_X_pow_five_sub_X

-- round 18: the resolvent instance
#print axioms Resolvent.resolvent_roots_one
#print axioms Resolvent.quartic_no_root

-- round 20: the d=2 variance
#print axioms Variance.twin2_values
#print axioms Variance.twin2_fourth_moment
#print axioms Variance.twin2_divisible

-- round 22: the x^4+4 factorisation
#print axioms B4.x4_add_four

-- round 24: the quartic polynomial identity
#print axioms QuarticPoly.poly_identity

-- round 25: the extremal quartic factorization
#print axioms ExtremalQuartic.factor_x4

-- round 26: the depressed quartic normal form
#print axioms DepressedQuartic.depress

-- round 27: the even quartic factorization
#print axioms EvenQuartic.even_quartic_aux
#print axioms EvenQuartic.even_quartic_factor
#print axioms EvenQuartic.even_quartic_neg

-- round 28: the j-invariant scaling
#print axioms JInvariant.j_invariant_scale

-- round 29: the cusp-doubling witness
#print axioms Doubling.x4_add_one_eval

-- new goal round 1: the one-point/two-point gap
#print axioms Gap.individual_ne_average

-- new goal round 2: shift invariance
#print axioms Shift.irreducible_shift

-- new goal round 3: the collision identity
#print axioms Collision.diff_factor

-- new goal round 4: scaling invariance
#print axioms Scale.irreducible_scale

-- new goal round 5: the critical cubic
#print axioms DerivativeQ.deriv_quartic
#print axioms DerivativeQ.deriv_at_zero

-- new goal round 6: cube symmetry
#print axioms CubeSym.cube_scaling

-- new goal round 7: fiber identity
#print axioms Fiber.sum_fiber_sq
#print axioms Fiber.sum_fiber_card

-- new goal round 10: value-set Cauchy-Schwarz
#print axioms ValueSet.value_set_bound

-- new goal round 12: at most 3 critical points
#print axioms Crit.crit_le_three

-- new goal round 13: j=0 iff composition
#print axioms JZero.j_zero_iff

-- new goal round 14: Chebotarev route
#print axioms Chebotarev.cap_from_main_term
#print axioms Chebotarev.s4_density
#print axioms Chebotarev.threshold_25_gt

-- new goal round 16: twin indicator is not a divisor sum
#print axioms DivisorSum.twinInd_not_zeta_mul

-- new goal round 17: base cases in Lean
#print axioms SmallCap.cap_five
#print axioms SmallCap.cap_seventeen
#print axioms SmallCap.cap_nineteen
#print axioms SmallCap.cap_twentythree

-- new goal round 19: quadratic factorization
#print axioms Factorization.quadratic_factor
#print axioms Factorization.even_factor

-- new goal round 21: quadratic fiber
#print axioms QuadFiber.quad_fiber

-- new goal round 22: composition preimage
#print axioms Composition.neg_image_mem_Q

-- new goal round 23: -1 square implies -x^2 square
#print axioms NegSquare.neg_sq_mem_sq

-- new goal round 1: Q size arithmetic
#print axioms QSize.size_identity

-- new goal round 2: orbit lemmas for (A1)
#print axioms QOrbit.sigma_y
#print axioms QOrbit.sigma_arg

-- new goal round 3: the parity theorem
#print axioms Periodic.divisor_sum_periodic
#print axioms NonPeriodic.twinInd_not_periodic
#print axioms NonPeriodic.twinInd_not_divisor_sum

-- round 5: no Euler product, and the trivial linear bound
#print axioms Barrier.twinInd_not_mult
#print axioms Barrier.twinCount_le_card

-- round 7: the degree-2 chi-dependence (F_7)
#print axioms CurveLift.pair_shift_two
#print axioms QuadSeven.pair7_shift_one
#print axioms QuadSeven.pair7_shift_two

-- round 8: degree-2 chi-table
#print axioms QuadEleven.pair11_shift_two
#print axioms QuadThirteen.pair13_shift_two
#print axioms QuadSeventeen.pair17_shift_two
#print axioms QuadNineteen.pair19_shift_two
