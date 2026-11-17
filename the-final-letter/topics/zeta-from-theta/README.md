# Zeta from theta — an FE-independent development of `ζ`

**Status:** **construction complete** (D0–D7 of the [handoff](HANDOFF.md)).
The theta layer now lives here, the standalone object `zetaTheta` is defined and
shown to satisfy the functional equation, it is identified with Mathlib's
`riemannZeta`, the trivial zeros and their removable singularity are handled, and
a constant-level provenance audit is recorded in [lean/AUDIT.md](lean/AUDIT.md).
Nothing here proves the Riemann hypothesis, and nothing here is a new theorem:
the payoff is architectural — a proof of the functional equation whose
dependency cone does not contain Mathlib's `*_one_sub` theorems — not additional
reach.

**Source:** the closing question of the theta-functional-equation work
(2026-11-09): *"does the new independent routes provide means to a proof that
would otherwise have been circular?"* The answer there was: no new reach, but one
loop can be broken — the loop between the functional equation and the
Hurwitz-zeta development. This topic is the construction that breaks it.

## 1. The loop

Mathlib routes the functional equation through Hurwitz zeta:

```
completedRiemannZeta_one_sub  ←  completedHurwitzZetaEven_one_sub
riemannZeta_one_sub           ←  hurwitzZetaEven_one_sub
```

and `completedRiemannZeta` is *defined* from the Hurwitz development
(`riemannZeta := hurwitzZetaEven 0`). Consequently any argument that needs the
functional equation *while developing Hurwitz-zeta material* depends on the
very development it is trying to establish. In a formal system this is not a
contradiction — a cycle simply means the proof is unavailable — but it is a real
obstruction to using the functional equation as a tool.

The [theta-functional-equation](../zeta-functional-equation/README.md) work
(V1–V40) proved `Λ(1 − s) = Λ(s)` from the theta series with a dependency cone
that is audited to be free of the functional equation:

| ingredient | provenance |
|---|---|
| `Real.tsum_exp_neg_mul_int_sq` (Poisson summation) | `PoissonSummation.lean` contains no occurrence of `riemannZeta` |
| `hasSum_mellin_pi_mul` | `MellinEqDirichlet.lean` has no reference to `one_sub` |
| `Complex.Gammaℝ_div_Gammaℝ_one_sub` | from `Complex.Gamma_mul_Gamma_one_sub` (Gamma reflection) |
| `riemannZeta_def_of_ne_zero` | definitional rewrite of `hurwitzZetaEven 0` |

So the *proof* of the functional equation was already independent. What was still
dependent was the *object*: `ζ` was defined by Hurwitz. This topic removes that
last dependence.

## 2. The construction

Write `ψ(t) = (θ(t) − 1)/2 = Σ_{n≥1} e^{−πn²t}` and
`Λ_θ(s) = ∫_0^∞ t^{s/2−1} ψ(t) dt` (the Mellin transform of the theta kernel).

1. **Mellin, `Re s > 1`.** `Λ_θ(s) = Γℝ(s) · Σ_{n≥1} n^{−s}` — the theta Mellin
   transform evaluated by `hasSum_mellin_pi_mul`.
2. **Split at 1 and substitute `t ↦ 1/t`.** Using `θ(1/t) = √t·θ(t)`:
   ```
   Λ_θ(s) = ∫_1^∞ ψ(t)(t^{s/2−1} + t^{(1−s)/2−1}) dt + 1/(s−1) − 1/s
   ```
   which is manifestly invariant under `s ↦ 1 − s`.
3. **Continue.** The right-hand side is analytic on `ℂ ∖ {0,1}`, so it *is* the
   continuation of `Λ_θ`: no Hurwitz zeta is involved at any stage. It is
   `LambdaTheta` in Lean.
4. **Define `ζ_θ := Λ_θ / Γℝ`** off the zeros of `Γℝ`, with the trivial zeros
   handled separately. It is `zetaTheta` in Lean.
5. **Identify.** On `Re s > 1`, `ζ_θ` is the Dirichlet series
   (`zetaSeries_eq_riemannZeta`, proved here), and the functional equation for
   `ζ` follows from the symmetry of `Λ_θ`.

Step 5 is the only place where Mathlib's `ζ` enters, and it enters *after* the
functional equation has been proved for `ζ_θ`.

## 3. What is proved here

The Lean layer is [`lean/Topic.lean`](lean/Topic.lean) (namespace
`ZetaFromTheta`) over the migrated `ZetaTheta` layer
([`lean/ThetaLayer.lean`](lean/ThetaLayer.lean) →
[`Theta.lean`](lean/Theta.lean), [`Mellin.lean`](lean/Mellin.lean),
[`Zeta.lean`](lean/Zeta.lean)).

| id | statement | Lean | status |
|---|---|---|---|
| D0 | the theta layer moves into `lean/`, namespace unchanged; both topics build | `ThetaLayer.lean` | proved |
| D1 | the Dirichlet series | `zetaSeries` | definition |
| T1 | `Σ n^{−s}` converges for `Re s > 1` | `summable_zetaSeries` | proved |
| T2 | the bridge `ζ_θ(s) = riemannZeta s` on `Re s > 1` | `zetaSeries_eq_riemannZeta` | proved |
| T3 | `ζ_θ(s) = Λ(s)/Γℝ(s)` on `Re s > 1` | `zetaSeries_eq_completed_div` | proved |
| **D2** | `LambdaTheta` is the split theta integral | `LambdaTheta` | definition |
| D2 | `LambdaTheta s = mellin ψ (s/2)` on `Re s > 1` | `LambdaTheta_eq_mellin` | proved |
| D2 | `LambdaTheta (1 − s) = LambdaTheta s` | `LambdaTheta_one_sub` | proved |
| D2 | `LambdaTheta` differentiable off `{0,1}` | `differentiableAt_LambdaTheta` | proved |
| **D3** | `zetaTheta = LambdaTheta / Γℝ` | `zetaTheta` | definition |
| D3 | `zetaTheta s = zetaSeries s` on `Re s > 1` | `zetaTheta_eq_zetaSeries` | proved |
| **D4** | the functional equation for `zetaTheta`, no Mathlib `*_one_sub` | `zetaTheta_one_sub` | proved + audited |
| **D5** | `zetaTheta s = riemannZeta s` off `{1} ∪ {−n}` | `zetaTheta_eq_riemannZeta` | proved |
| D5 | strengthened: off `{0,1}` | `zetaTheta_eq_riemannZeta_of_ne_zero_one` | proved |
| **D6** | `zetaTheta (−2(n+1)) = 0` | `zetaTheta_trivial_zero` | proved |
| **D6** | the punctured limit at `−2(n+1)` is `0` | `zetaTheta_removable_at_trivial_zero` | proved |
| **M6** | `riemannZeta (1−s) = … · riemannZeta s` assembled from `zetaTheta_one_sub` | `riemannZeta_one_sub_from_theta` | proved |
| **M6** | the same statement as `riemannZeta_one_sub_theta'`, unconditionally | `riemannZeta_one_sub_from_theta'` | proved + audited |

The full functional equation for `zetaTheta` is

```
zetaTheta (1 - s) = 2 * (2π)^(-s) * Γ(s) * cos (π s / 2) * zetaTheta s
```

under `s ∉ {−n}` and `s ≠ 1`. Its proof uses `LambdaTheta_one_sub` and
`Complex.Gammaℝ_div_Gammaℝ_one_sub` only.

## 4. What is not proved, and the limits

* **Correction to M5's premise.**  The handoff's preferred D6 route asks for
  `Λ_θ` to have a simple zero at `−2n`.  That is not what happens.  Analytically
  `Γℝ(s) = π^{−s/2}Γ(s/2)` has a *pole* at `s = −2n`, while `Λ_θ(s) = Λ(s)` is
  finite and non-zero there (`ξ(s) = ½s(s−1)Λ(s)` is entire and has no zero at a
  negative even integer).  Lean's `Complex.Gamma` assigns the value `0` at its
  poles, so `Complex.Gammaℝ_eq_zero_iff` records a *convention*, not an analytic
  zero: `Γℝ` is discontinuous at `−2n`.  The correct removability statement is
  therefore that `ζ_θ = Λ_θ/Γℝ` tends to `0` because the denominator blows up,
  not because the numerator vanishes.  `zetaTheta_removable_at_trivial_zero`
  proves exactly that limit (through D5), and the assigned value `0` is
  `ζ(−2n)`.
* **D6 is established through the identification, not by a multiplicity count.**
  At `s = −2n` Lean's `Γℝ` is `0` and `Λ_θ` is finite; the quotient is therefore
  `0` by the division convention, which is the correct value of `ζ(−2n)`. The
  removable-singularity statement proves that the punctured limit equals that
  value by agreeing with `riemannZeta` near the point. It does **not** give an
  independent proof that `Λ_θ` has a zero of the required order there. That
  computation — the one genuinely new piece of analysis in the handoff's
  preferred route — remains open. See [HANDOFF §4 M5](HANDOFF.md).
* **M6 is unconditional, but its `s = 1 + 2n` branch is an identification
  argument.** `riemannZeta_one_sub_from_theta'` has the same statement as
  `riemannZeta_one_sub_theta'` and is audited; the branch where `Γℝ (1 − s) = 0`
  is handled by proving both sides vanish, using Mathlib's trivial-zero lemma.
  That lemma is not a functional-equation lemma, and the audit confirms it does
  not pull one in.
* **No new theorem.** Every statement is classical. The contribution is the
  construction and its provenance.
* **"Independent" is audited, not decreed.** [lean/AUDIT.md](lean/AUDIT.md)
  records Method B (constant-level walk) for `zetaTheta_one_sub`,
  `zetaTheta_eq_riemannZeta`, `riemannZeta_one_sub_from_theta`,
  `riemannZeta_one_sub_from_theta'` and `zetaTheta_removable_at_trivial_zero`,
  plus two negative controls that the walker flags. Method C (negative build) was not run.
  The audit's limits — that it covers stored constants, not semantic intent — are
  stated there.
* **No Riemann-hypothesis content.** Nothing here locates, counts, or bounds a
  zero, and nothing here is positive-definite.

## 5. Provenance audit (D7)

The audit walks every `ConstantInfo` reachable from a target — types and values —
and intersects the reachable set with the seven forbidden names
`riemannZeta_one_sub`, `completedRiemannZeta_one_sub`,
`completedRiemannZeta₀_one_sub`, `completedHurwitzZetaEven_one_sub`,
`hurwitzZetaEven_one_sub`, `cosZeta_one_sub`, `sinZeta_one_sub`.

```bash
cd topics/zeta-from-theta/lean && ./audit.sh
```

Recorded output (2026-11-09, Lean `v4.35.0-rc2`):

```
provenance OK: ZetaFromTheta.zetaTheta_one_sub reaches 51118 declarations; none is in the forbidden set [...]
provenance OK: ZetaFromTheta.zetaTheta_eq_riemannZeta reaches 55193 declarations; none is in the forbidden set [...]
provenance OK: ZetaFromTheta.riemannZeta_one_sub_from_theta reaches 55435 declarations; none is in the forbidden set [...]
provenance OK: ZetaFromTheta.riemannZeta_one_sub_from_theta' reaches 55445 declarations; none is in the forbidden set [...]
provenance OK: ZetaFromTheta.zetaTheta_removable_at_trivial_zero reaches 55335 declarations; none is in the forbidden set [...]
[check] OK   Audit.lean
```

The implementation is [`lean/Audit.lean`](lean/Audit.lean); the method and its
limits are in [`lean/AUDIT.md`](lean/AUDIT.md).

## 6. Computations

The numerical layer ([`python/programme.py`](python/programme.py)) checks the
three quantitative claims independently of the Lean layer:

| Item | Statement | Test |
|---|---|---|
| C1 | the Dirichlet series reproduces `ζ` on `Re s > 1`, at the tail-consistent tolerance `N^{1−σ}/(σ−1)` | `test_bridge_residual_small` |
| C2 | the theta-side `Λ_θ` equals `Λ` on `Re s > 1` | `test_theta_side_matches_completed_zeta` |
| C3 | the theta-side symmetry `Λ_θ(1 − s) = Λ_θ(s)` | `test_theta_side_functional_equation` |
| C4 | `Γℝ(2) = 1/π` | `test_gamma_R_at_two` |

`Λ_θ` is evaluated from the split representation of step 2, with `ψ` summed to
24 terms and the tail integral over `[1, ∞)` done by quadrature. Six pytest tests
pass.

## 7. Integration

Each row was actioned in the same pass as the construction.

| Topic | Relation | Status |
|---|---|---|
| [zeta-functional-equation](../zeta-functional-equation/README.md) | **engine** — the theta layer V1–V40; now imports it through `ThetaLayer` | I1 done: `check.sh` points at this topic, its `Topic.lean` imports `ThetaLayer`, its README carries the provenance paragraph |
| [angular-partition-method](../angular-partition-method/README.md) | **third route** — T57 `completedMellinPart_one_sub` is the same symmetry as an annular-integral identity, and O7 continues the annular Mellin integral to `−3 < Re s` | I2 done: cross-reference in §7.9/§13 |
| [digamma-contour-shift](../digamma-contour-shift/README.md) | consumer of `Λ` and `Γℝ` | I3 done: cites `zetaTheta_one_sub` as the functional-equation source |
| [archimedean-prime-evaluation](../archimedean-prime-evaluation/README.md) | consumer of the archimedean factor | I4 done: dependency note added |
| [weil-positivity](../weil-positivity/README.md) / [missing-bridge](../missing-bridge/README.md) | the explicit formula consumes the functional equation (pole terms `h(0) + h(1)`, the `h ↔ ĥ` pairing) | I5 done: dependency note only; **no positivity status changed** |
| [absolute-polarized-hodge-index-realization](../absolute-polarized-hodge-index-realization/README.md) | the formal core that motivates independence | I6 done: cross-link from `notes/61-angular-bochner-framework.md` |
| [zero-sum-convergence](../zero-sum-convergence/README.md) | zero side | I7 done: cross-check note for the `ζ ↔ Λ` correspondence |

## 8. Reproduce

```bash
cd topics/zeta-from-theta/lean && ./check.sh Topic.lean
cd topics/zeta-from-theta/lean && ./audit.sh
cd topics/zeta-from-theta && python3 -m pytest -q tests
```

[Handoff](HANDOFF.md) · [Topic index](../index.html) · [Ledger](../STATUS.md)
