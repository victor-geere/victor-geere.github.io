/-
  Op56.lean — root module for the Lean formalisation of OP-5 and OP-6.

  Status.  `./check.sh --all` is **8/8 green**.  The authoritative current account is
  `../../006/handoff.md`; `README.md` in this directory carries the module-by-module
  detail.

  * `Op56/Defs.lean`     — definitions; no proofs, no gaps.
  * `Op56/Exact.lean`    — exact layer; **all proved, 0 sorries**.  `tailSum_integral_lower`
                           is a documented, **unused** negative result (the antitone
                           integral test is too lossy to prove completeness); it is now
                           proved with the honest hypothesis `N + 2 ≤ M`.
  * `Op56/Census.lean`   — the census structure (interval form, sub-sums); 0 sorries.
  * `Op56/PhiAsymptotic.lean` — the geometrically-dominated asymptotics of `Phi` up to
                           second order (`Phi_asymptotic`, `Phi_second_order*`,
                           `threshold_second_order*`); 0 sorries.
  * `Op56/PhiThird.lean` — the third-order layer and the whole OP-6 estimate chain; 0 sorries.
  * `Op56/Asymptotic.lean` — **all three asymptotic theorems PROVED, 0 sorries**:
                           `op5_threshold_asymptotic`, `op5_nmin_asymptotic` (restated
                           with the correct `O(1)` error term) and
                           `op6_reachable_fraction`; the leading coefficient
                           `leadingCoeff_forced` is proved here too.
  * `Op56/FloorAsymptotic.lean` — the floor/Diophantine meta-theorem (TODO O11):
                           `no_index_asymptotic_error` — an integer index cannot track an
                           irrational affine function to within `O(1/p)`.  This is the
                           reason the `O(1)` error term of `op5_nmin_asymptotic` is sharp
                           (`nmin_error_not_bigO_inv`); 0 sorries.  The concrete `log 2`
                           instances carry `Irrational (Real.log 2)` (Lindemann–Weierstrass,
                           absent from Mathlib) as an explicit hypothesis; the general
                           meta-theorem is unconditional and its declarations rest on
                           exactly `[propext, Classical.choice, Quot.sound]`.

  There is **no `axiom` declaration** anywhere in this development, **no `sorry`
  anywhere** in it, and **no compiled decision procedure** anywhere either.  All three
  asymptotic theorems therefore rest on exactly `[propext, Classical.choice, Quot.sound]`.
-/

import Op56.Defs
import Op56.Exact
import Op56.Census
import Op56.PhiThird
import Op56.Asymptotic
import Op56.FloorAsymptotic
