/-
Axiom audit for the extracted Gaussian-integer library and the
ring-of-integers bridge.

Expected output for every line below:

  ... depends on axioms: [propext, Classical.choice, Quot.sound]

Run with `../check.sh GaussianInt/Audit.lean` (or the full `./lean/check.sh`).
-/
import GaussianInt.TwoSquares
import GaussianInt.RingOfIntegers

#print axioms GaussianInt.idealCountFormula
#print axioms GaussianInt.twoSquaresFormula
#print axioms GaussianInt.r2_eq_four_mul_idealCount
#print axioms GaussianInt.gaussianUnits_card_four
#print axioms GaussianInt.normElements_card_eq_four_mul_idealCount
#print axioms GaussianInt.irreducible_X_sq_add_one
#print axioms GaussianInt.toQI_injective
#print axioms GaussianInt.coord_eq
#print axioms GaussianInt.finrank_QI
#print axioms GaussianInt.exists_div
#print axioms GaussianInt.ringOfIntegersEquiv
