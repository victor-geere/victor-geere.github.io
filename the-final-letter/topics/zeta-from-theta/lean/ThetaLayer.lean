/-
# The theta layer, re-exported

Aggregate import for the theta-based development of the completed zeta function:

* `Theta.lean`  — the Jacobi theta series, `ψ`, and the theta functional equation;
* `Mellin.lean` — the Mellin representation of `Λ` on `Re s > 1`;
* `Zeta.lean`   — the split integral, the continuation `LambdaTilde`, its symmetry,
  and the classical functional equation for `riemannZeta`.

The namespace is `ZetaTheta`.  Nothing here uses Mathlib's `*_one_sub` lemmas in
the proofs of `LambdaTilde_one_sub` or `completedRiemannZeta_one_sub_theta`; the
only place Mathlib's `ζ` enters is the Dirichlet-series bridge.

This file exists so that downstream topics can import the layer by a single,
stable module name (`ThetaLayer`) without colliding with their own `Topic.lean`.
-/
import Theta
import Mellin
import Zeta
