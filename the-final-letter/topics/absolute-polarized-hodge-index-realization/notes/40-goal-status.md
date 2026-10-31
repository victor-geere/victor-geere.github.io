# Goal status after eight rounds: certified finite layer, open analytic layer

> **Round 57 correction.** The sign conclusion recorded below is
> superseded: the fixed-grid archimedean sum omitted the quadrature weights.
> Exact adaptive quadrature shows the sibling's cosh \(+\Omega\) form is
> positive semidefinite; the interval, critical-line, Bost–Connes and
> geometry items remain open. See
> [`41-quadrature-correction.md`](41-quadrature-correction.md).

**Status:** the eight-round goal is **not fully achieved**. The finite and
formal layer is done and verified; the analytic certification, the actual
Bost–Connes level check, and the scaling-site geometry remain open. This note
is the handoff, not a completion claim. No Riemann hypothesis proof is claimed yet.

## 1. The objective against the evidence

| objective clause | status | evidence |
|---|---|---|
| port the correct \(W\), replace the recorded \(N\) | **done at the documentation and module level**; the recorded \(N\) is rejected, the standard \(-\Omega\) formula is isolated and its Gram tested | notes 38–39; `python/rescue_probe.py`; banners on notes 25–36 |
| finite Gram certificates on Gaussian and compact-support families | **numerical tests and rational Lean shadows done**; a true interval enclosure of the analytic entries is **not** done | `G4_psd`, `G4_close`, `N4_not_psd`; `test_rescue.py` |
| resolve whether \(W\) is positive semidefinite on compact supports | **corrected round 57**: with exact quadrature the sibling's cosh \(+\Omega\) form is PSD; the \(-\Omega\) forms have small residuals | exact eigenvalues \((0,1.1\cdot10^{-7},9.98\cdot10^{-5},1.67\cdot10^{-3})\), note 41 |
| Bost–Connes compatibility at finite level | **lemma and full tensor-factor identity Lean-checked**; the actual Bost–Connes level inclusions are **not** modelled | `kmsFormTensorDelta_eq_kmsForm`, `badB_not_compatible` |
| update notes, README, journal, tests | **done** | notes 37–40, `lean/README.md`, journal rounds 45–56 |
| no RH claim; cone and scaling-site Hodge index open | **respected** | every status line |

## 2. What is Lean-checked

Build: `lean/check.sh` — four files, no `sorry`, `axiom` or `admit`.

| file | contents |
|---|---|
| [`Rescue.lean`](../lean/Rescue.lean) | finite KMS positivity; compatible positivity; non-compatibility counterexample; sign convention `s = -W`; quadratic-form criterion; reduced and full Kronecker-delta tensor-factor identities |
| [`Shadow.lean`](../lean/Shadow.lean) | rational Cholesky shadow `G4_psd`; quantitative bound `G4_close` (\(2\cdot10^{-5}\) against the rational target); indefinite recorded shadow `N4_not_psd` |
| [`Archimedean.lean`](../lean/Archimedean.lean) | `digamma_conj`; `arch_contour_identity` (`Re A_arch(ξ) = -½ Ω(ξ + i/2)`) |
| [`Symbol.lean`](../lean/Symbol.lean) | `logDeriv_completedZeta_of_ne_one`; `symbol_identity_continued`; `symbol_identity` on `Re s > 1` |

## 3. What is **not** verified

1. **No interval enclosure of an analytic Gram entry.** `G4_close` bounds the
   rational shadow against a rationalised target, not against the digamma
   integral. The certified Ω enclosure has width \(2\cdot10^{-4}\) at
   \(h=5\cdot10^{-4}\) (note 42), and no rigorous panel quadrature bound is
   implemented. A proved remainder bound for
   \(\int |\widehat F|^2\Omega\) is the missing certificate.
2. **Critical-line structure, partially formalised.** The identity is
   Lean-checked on `Re s > 1` (L-series) and in continued form with
   `ζ(s) ≠ 0`; the completed-zeta functional equation
   `Z(1-s) = Z(s)` is now Lean-checked (`completedZeta_one_sub`,
   from Mathlib's `completedRiemannZeta_one_sub`). The critical-line symmetry
   \(Z(1/2+it)=Z(1/2-it)\) is Lean-checked (`completedZeta_critical_line`),
   and so is the log-derivative antisymmetry
   \((Z'/Z)(1-s)=-(Z'/Z)(s)\) (`logDeriv_completedRiemannZeta_one_sub`),
   including its critical-line form
   \((Z'/Z)(1/2-it)=-(Z'/Z)(1/2+it)\).
   The distributional statement on the critical line and the \(-\Omega\)
   residual remain open.
3. **No actual Bost–Connes level model.** The Lean work covers the
   compatibility lemma, the full tensor-factor identity `B(a⊗1,a⊗1)=B(a,a)`,
   and a counterexample showing compatibility is not automatic. It does not
   prove that the Bost–Connes forms satisfy compatibility.
4. **No scaling-site Riemann–Roch/Hodge index.** The literal Yuan–Zhang
   objective remains impossible; the replacement is a programme, not a theorem.
5. **No RH proof yet.**

## 4. Next steps in order

1. **Interval certificate.** Pick the simplest analytic entry (the narrow
   Gaussian diagonal) and bound \(\int_0^\infty |\widehat F(t)|^2\Omega(t)\,dt\)
   with explicit panel and tail bounds, following the pattern of
   [`../../prime-spectrum-tensor/WEIL-GRAM.md`](../../prime-spectrum-tensor/WEIL-GRAM.md).
2. **Critical-line normalization.** Continue `symbol_identity` to
   `Re s = 1/2` and settle the \(-\Omega\) versus \(+\Omega\) convention on a
   broad test; this is the residual of note 39.
3. **Bost–Connes level model.** Build the finite Hecke algebra at level `N`,
   compute the forms, and test compatibility directly; if it fails, record the
   failure as the obstruction.
4. **Geometry.** Formulate the scaling-site Hodge index; keep the
   Yuan–Zhang no-go explicit.

## 5. Bottom line

- The programme has a Lean-checked finite core, a rejected normalization, an
  identified archimedean sign, and a quantified residual.
- It does **not** have an interval-certified analytic Gram matrix, a
  critical-line symbol theorem, a Bost–Connes compatibility proof, or the
  absolute realization.
- The goal remains active for a future round; this note records exactly where
  to resume.

[Back to the dossier](../README.md) · [Rescue](38-rescue.md) ·
[Broad-test discrepancy](39-broad-test-discrepancy.md) ·
[Lean core](../lean/README.md) · [Research journal](../research-journal.md)
