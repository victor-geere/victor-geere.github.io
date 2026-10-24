/-
  Rh42 — root module of the rh42 Lean development.

  Importing this file checks that every module of the development elaborates and
  that there are no name clashes.

  * `Rh42.Budget`     — the budget closed forms at `p = 2, 4` (from Mathlib's ζ values)
  * `Rh42.Reachable`  — Brown's criterion one-step lemmas, sub-sums, gap lemma, greedy
  * `Rh42.Tau`        — the signed greedy on `ℚ`: parity lock and even gaps
-/
import Rh42.Budget
import Rh42.Reachable
import Rh42.Tau
