/-
# The formal core — absolute polarized Hodge-index realization

This is the umbrella module of the topic: the proved formal core is the union
of the eleven layers imported here, and building this file builds all of them
in dependency order.

* [`Rescue`](Rescue.lean) — finite KMS positivity, compatibility of a chain of
  forms, the sign convention `s = -W`, and the finite quadratic-form criterion;
* [`Shadow`](Shadow.lean) — the rank-three Hodge index, the box/`LDLᵀ`
  positivity theorems, and the rational Gaussian Gram shadow;
* [`Archimedean`](Archimedean.lean) — `Re A_arch(ξ) = -Ω(ξ + i/2)/2`, the
  digamma conjugation and the evenness of the archimedean symbol;
* [`Symbol`](Symbol.lean) — the symbol identity `M = -Z'/Z`, the completed-zeta
  symmetries (functional equation, conjugation, zero quadruple, critical line),
  both pole residues, and the three RH formulations;
* [`Rectangle`](Rectangle.lean), [`ExplicitFormula`](ExplicitFormula.lean),
  [`TailBound`](TailBound.lean) — the rectangle contour and argument principle,
  the zeta zero count `∮ Z'/Z = 2πi(∑m − 2)`, and the zero-sum tail bound;
* [`Hadamard`](Hadamard.lean) — Weierstrass factors, canonical products,
  Jensen theory, the order-1 class and the quotient factorisation;
* [`Limit`](Limit.lean) — the compatible-positivity limit form on the scaling
  site;
* [`ZetaStrip`](ZetaStrip.lean) — the Euler–Maclaurin strip layer;
* [`Weil`](Weil.lean) — the pole and prime term signs of the explicit formula.

`lean/README.md` records exactly what is and is not formalised.  In particular
the distributional explicit formula, the infinite cone positivity (Weil's
criterion) and the analytic eigenvalue are **not** proved here.
-/
import Rescue
import Shadow
import Archimedean
import Symbol
import Limit
import Weil
import Hadamard
import Rectangle
import ExplicitFormula
import TailBound
import ZetaStrip
