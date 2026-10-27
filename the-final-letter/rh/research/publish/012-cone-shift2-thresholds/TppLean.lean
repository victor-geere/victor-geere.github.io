/-
TppLean — the Lean development for `theorems/tpp-rh42-handoff-three-thresholds.md` (T14).

Build: `cd lean && ./check.sh --all`   (Lean 4 v4.35.0-rc2 + Mathlib at `$HOME/lean`).

Contents
* `TppLean/Core.lean`           — the abstract ordering core (`pN < pP` from monotonicity + `N < P`)
* `TppLean/Budget.lean`         — the budgets `P`, `N`; strict antitonicity of the real ζ series
* `TppLean/ThreeThresholds.lean`— integer-certified partial sums and power comparisons
-/
import TppLean.Core
import TppLean.Budget
import TppLean.ThreeThresholds
