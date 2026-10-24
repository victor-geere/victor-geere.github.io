/-
  Rh42 — root module of the rh42 Lean development.

  Importing this file checks that every module of the development elaborates and
  that there are no name clashes.

  * `Rh42.Budget`     — the budget closed forms at `p = 2, 4` (from Mathlib's ζ values)
  * `Rh42.Reachable`  — Brown's criterion one-step lemmas, sub-sums, gap lemma, greedy
  * `Rh42.Tau`        — the signed greedy on `ℚ`: parity lock and even gaps
  * `Rh42.PrecisionFloor` — OP-33(a): the `D`-digit forward-orbit step bound
    `2^{K−1} ≤ D` (the "7–13 steps before underflow" is a theorem, not a bug)
-/
import Rh42.Budget
import Rh42.Reachable
import Rh42.Tau
import Rh42.PrecisionFloor
