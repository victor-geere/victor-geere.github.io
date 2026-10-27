/-
  Rh044 — root module of the rh044 Lean development.

  Importing this file checks that every module of the development elaborates and
  that there are no name clashes.

  * `Rh044.Smoothing` — the algebraic layer of the round "smoothed partial sums
    of the zeta Dirichlet series": the term `zetaTerm s n = exp (-(s log n))`,
    the sharp sum `zetaSum` and the weighted sum `smoothedSum`, the exact
    weighted decomposition (`weighted_decomposition`) of their difference into
    the weight defect `1 - φ (n/N)`, the degenerate-weight lemmas
    (`smoothedSum_one`, `smoothedSum_zero_of_weight_eq_zero`), the
    triangle-inequality error bounds, the radial decay `‖zetaTerm (σ + tI) n‖ =
    n^{-σ}` with the tail summability for `σ > 1`, and the quadratic weight
    `u (1 - u)` with the closed form of its defect.
-/
import Rh044.Smoothing
