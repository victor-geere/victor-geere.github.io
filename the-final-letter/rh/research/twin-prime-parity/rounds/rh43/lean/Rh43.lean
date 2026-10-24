/-
  Rh43 — root module of the rh43 Lean development.

  Importing this file checks that every module of the development elaborates and
  that there are no name clashes.

  * `Rh43.Balance` — partial sums of the zeta Dirichlet series on the critical
    line, the split of their real part into positive and negative totals, the
    accounting theorem `balanced ↔ realPartial = 0`, and the existence of a
    balanced partial sum (witness `N = 3`, by the intermediate value theorem).
-/
import Rh43.Balance
