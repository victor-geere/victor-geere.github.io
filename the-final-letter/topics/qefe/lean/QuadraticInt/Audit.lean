/-
Axiom audit for the Phase 3 quadratic developments (`d = 2` and `d = 3`).

Expected output for every line below:

  ... depends on axioms: [propext, Classical.choice, Quot.sound]
-/
import QuadraticInt.ZsqrtdTwo
import QuadraticInt.RingOfIntegersTwo
import QuadraticInt.Eisenstein
import QuadraticInt.RingOfIntegersThree
import QuadraticInt.SplitTwo
import QuadraticInt.SplitThree
import QuadraticInt.IdealCountTwo
import QuadraticInt.LocalTwo
import QuadraticInt.SplitCountTwo
import QuadraticInt.MultTwo
import QuadraticInt.FormulaTwo
import QuadraticInt.IdealCountThree
import QuadraticInt.SplitCountThree
import QuadraticInt.LocalThree
import QuadraticInt.SplitCountThreeFull
import QuadraticInt.MultThree
import QuadraticInt.FormulaThree
import GaussianInt.ClosedForm

-- d = 2
#print axioms ZsqrtdTwo.instEuclideanDomain
#print axioms ZsqrtdTwo.ringOfIntegersEquiv_two
#print axioms ZsqrtdTwo.prime_sq_add_two_sq
#print axioms ZsqrtdTwo.inert_prime_two
#print axioms ZsqrtdTwo.inert_ideal_count_even_two
#print axioms ZsqrtdTwo.ramified_ideal_count_two
#print axioms ZsqrtdTwo.split_ideal_count_one_two
#print axioms ZsqrtdTwo.split_ideal_count_two
#print axioms ZsqrtdTwo.idealCountTwo_mul
#print axioms ZsqrtdTwo.idealCountTwoFormula
#print axioms ZsqrtdTwo.rTwo_formula
#print axioms ZsqrtdTwo.idealCountTwo_eq_divisorSum
#print axioms ZsqrtdTwo.idealCountTwo_closed
#print axioms ZsqrtdTwo.rTwo_closed

-- d = 3
#print axioms EisensteinInt.instEuclideanDomain
#print axioms EisensteinInt.ringOfIntegersEquiv_three
#print axioms EisensteinInt.prime_normE
#print axioms EisensteinInt.inert_prime_three
#print axioms EisensteinInt.split_ideal_count_three
#print axioms EisensteinInt.inert_ideal_count_even_three
#print axioms EisensteinInt.ramified_ideal_count_three
#print axioms EisensteinInt.idealCountThree_mul
#print axioms EisensteinInt.idealCountThreeFormula
#print axioms EisensteinInt.rThree_formula
#print axioms EisensteinInt.idealCountThree_eq_divisorSum
#print axioms EisensteinInt.idealCountThree_closed
#print axioms EisensteinInt.rThree_closed
#print axioms GaussianInt.r2_closed
