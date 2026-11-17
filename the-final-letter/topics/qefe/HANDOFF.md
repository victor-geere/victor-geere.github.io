# QEFE session handoff

## Scope

Work in `the-final-letter/topics/qefe` on the χ₄ characteristic-theta,
Mellin, and β-series route. The finite QEFE is ruled out; the active target is
finishing the dossier: promoting the refutation, hardening it near the pole,
deciding the two named inputs, and recording the general even-lattice case as
cited rather than as a research gap.

## Current state

- Lean: **T1–T219**, `./lean/check.sh` → `[check] OK Topic.lean`.
- Tests: **29 passed** (`python3 -m pytest -q tests`).
- STATUS: qefe `219 | 2 | 0 | 29`; totals
  `2074 theorems · 570 computations · 909 tests`.
- Structural audit: 64/64.
- No git commit; all changes are in the working tree.
- Active goal: **finish the QEFE dossier** — refutation promoted and hardened,
  named inputs decided, general even-lattice Poisson recorded as cited.

## Refutation (promoted)

The source's displayed finite functional equation is **false**, not merely
unproved: its right-hand side contains `Γ((1-s+a)/2)`, which has poles, while
`Ψ` is entire. The Lean refutation is T200–T204:

- `Gamma_neg_one` (T200): Mathlib's `Γ(-1) = 0` at the pole;
- `gammaRatio_ising_pole` (T201): `gammaRatio 0 3 = 0`;
- `qefe_fails_ising` (T202): `isingPsi 3 ≠ qefeRhs 4 0 1 isingPsi 3`;
- `gammaRatio_su2_pole` (T203): `gammaRatio 1 4 = 0`;
- `qefe_fails_su2` (T204): `su2Psi 4 ≠ qefeRhs 12 1 1 su2Psi 4`.

The point-evaluation form uses Mathlib's junk-value convention; the stronger
structural statement is unboundedness of the residual near the pole. T205–T206
supply the Gamma residue and the divergence `‖Γ(x)‖ → ∞` at `x → −1⁺`, the
first step toward that statement; T207 upgrades it to `‖gammaRatio 0 s‖ → ∞`
as `s → 3⁻`, and T208–T211 prove the full Ising residual is unbounded near
`s = 3`, and T212–T215 prove the same for the `SU(2)₄` residual near `s = 4`.
The refutation is now convention-independent for both worked examples.
T217 adds the finite growth obstruction: a finite exponential sum with non-zero
total cannot satisfy any weight-`w` modular relation. T218–T219 close the former
named input `LatticeThetaMellinChi4` (the identity is T120); no load-bearing
named inputs remain.

## Proved in this session

- **T96–T105** — the χ₄ Dirichlet series and the convergence-half-plane
  bridge:
  - `LSeries_chi4 : LSeries (χ₄ ·) s = betaSeries s` (T99);
  - `chi4` is quadratic and `χ₄⁻¹ = χ₄` (T100–T101);
  - Mathlib's Gauss sum/root number: `rootNumber chi4 = 1` (T102–T103);
  - `completedLFunction chi4 s = Γℝ(s+1)·β(s)` (T104);
  - `completedBeta s = 2^(s+1)·completedLFunction chi4 s` (T105).
- **T106–T114** — entireness of `completedBeta`:
  - `thetaMinus` is Mathlib's `oddKernel (1/4)` and `twistedTheta4` is
    `sinKernel (1/4)` (T106–T107);
  - continuity, exponential decay at `∞`, and `O(t^(−b))` at `0` for every
    `b` (T108–T110);
  - local integrability and the generic Mellin differentiability theorem give
    differentiability of the Mellin transform (T111–T113), hence
    `differentiable_completedBeta` (T114).
- **T115–T117** — the T24 replacement:
  - `completedBeta_functional_equation_all` for all `s` (T115);
  - the all-`s` bridge to `completedLFunction chi4` (T116);
  - `chi4_completedLFunction_one_sub_theta`, the T24 statement re-derived
    from the theta route (T117).
- **T121–T124** — the Epstein/lattice reduction and the count:
  - `r2 n`, `divisorSumChi4 n`, and `TwoSquaresFormula` (proved as T199);
  - `LSeries_divisorSumChi4` (T121): the divisor-sum L-series is `ζ(s)β(s)`;
  - `epstein_series_eq_four_zeta_beta` (T122): `LSeries r₂ = 4ζβ`;
  - `LambdaZ2_eq_epstein` (T123): `Λ_ℤ²(s) = π^(−s)Γ(s)·LSeries r₂`;
  - `r2_eq_zero_iff` (T124): `r2 n = 0` iff no integer representation
    `x²+y²=n` exists (the support case of the count).
- **T118–T120** — P1:
  - `gammaR_duplication` (T118);
  - `LambdaZ2 s := completedRiemannZeta s * completedBeta s`;
  - `lambdaZ2_self_dual : LambdaZ2 s = LambdaZ2 (1−s)` (T119);
  - `lambdaZ2_product : LambdaZ2 s = 4π^(−s)Γ(s)ζ(s)β(s)` for `Re s > 1`
    (T120).
- `#print axioms` on T117, T119, T120 reports only
  `[propext, Classical.choice, Quot.sound]`.

## Open

1. **Two-squares count — done.** `TwoSquaresFormula`
   (`r₂(n) = 4Σ_{d|n}χ₄(d)`) is T199, via the element/ideal count (T129–T136)
   and the ideal-count formula (T178–T198). All three local factors and the
   multiplicativity of the ideal count are formalised.
2. **Source finite functional equation — refuted.** T200–T204; the displayed
   equation fails at the gamma pole for both worked examples. The remaining
   strengthening is the unboundedness statement near the pole.
3. **Named inputs.** `LatticeThetaMellinChi4` is kept as a
   formalisation-independence asset. `RegularizedAnnularLatticeSeries` is
   retired as a headline gap and replaced by the precise open question of
   whether the functional equation survives the `k → ∞` limit of the
   `SU(2)_k` tower.
4. **General even-lattice Poisson summation.** Cited, not formalised; recorded
   as a routine generalisation rather than a research gap.
5. The original T24 (`chi4_completedLFunction_one_sub`) is retained; T117 is
   the theta-route replacement with the same statement.

## Exact next steps

1. ~~Prove `TwoSquaresFormula`~~ — completed as T199; T122/T123 are now
   unconditional.
2. Harden T200–T204 to unboundedness of the residual near the pole
   (`∀ M, ∃ s`, `M ≤ ‖residual s‖`), so the refutation does not depend on
   Mathlib's `Γ(-n) = 0` convention.
3. Formalise the finite growth obstruction: no non-zero finite sum
   `Σ cᵢ e^(−λᵢτ)` satisfies a weight-`w` modular relation.
4. Decide/propagate the named-input retirement
   (`RegularizedAnnularLatticeSeries` → `SU(2)_k` tower question) through
   `PHASE-ANNULAR.md` and the README.
5. Optionally, formalise rank-`n` Poisson summation and the general
   even-lattice theta.

## Known gotchas

- `Nat.even_or_odd` may produce `m + m` rather than `2 * m`; normalize
  explicitly.
- `(2*m+1)/2` is not automatic; use `Nat.add_mul_div_left`.
- Complex `cpow` casts: qualify `Complex.mul_cpow_ofReal_nonneg` and
  `Complex.inv_cpow_ofReal_nonneg`; otherwise rewriting fails.
- `SignType.sign` cast to `ℂ` needs `exact_mod_cast`.
- `(-3/2 : ℂ)` parses as `((-3)/2 : ℂ)`, so `Complex.cpow_neg` will not
  match. Write `(-(3/2 : ℂ))`, or extract a `have` for the cpow rewriting.
- A type ascription swallows arithmetic:
  `((i:ℤ):ℝ + 1/4)` parses `ℝ + 1/4` as a type. Parenthesize the cast:
  `(((i:ℤ):ℝ) + 1/4)`.
- `Equiv.neg ℤ` is displayed as `(Equiv.neg ℤ) c`; `rw` with a pattern `-c`
  can fail. Insert `change ... (-c) = ...` first.
- **New:** `atTop` and `Filter.atTop` did not unify in some `IsBigO` /
  `∀ᶠ` goals in this file. Write `Filter.atTop` explicitly.
- **New:** `filter_upwards [h]` can fail when `h : ∀ᶠ x in l, p x`; bind it
  first with `have hpos : ∀ᶠ t : ℝ in Filter.atTop, 0 < t := ...`.
- **New:** two consecutive `/-- ... -/` doc comments before one declaration
  are a parse error. Remove or merge the old docstring when adding a
  `Tnn` docstring.
- **New:** the Mathlib theta kernels are `HurwitzZeta.oddKernel` and
  `HurwitzZeta.sinKernel`; `oddKernel (↑(1/4:ℝ) : UnitAddCircle)` needs the
  explicit `UnitAddCircle` coercion.
- Do not add `sorry`/`axiom`; the dossier standard forbids them.
- Keep counts column-sum-consistent in `STATUS.md`.
- Regenerate the hub after README title/status changes:
  `python3 tools/build_topic_index.py`.

## Key files

- `the-final-letter/topics/qefe/lean/Topic.lean` — T1–T120.
- `the-final-letter/topics/qefe/THETA-INDEPENDENT.md` — the theta chain and
  the T24 replacement status.
- `the-final-letter/topics/qefe/L-SERIES-Z2.md` — the P1 product route and
  its Lean formalisation.
- `the-final-letter/topics/qefe/README.md`,
  `the-final-letter/topics/qefe/index.html`.
- `the-final-letter/topics/STATUS.md`.
- `the-final-letter/topics/qefe/tests/test_programme.py`.
- `the-final-letter/topics/qefe/python/programme.py`,
  `python/rational_certificates.py`.

## Commands

```bash
cd the-final-letter/topics/qefe
./lean/check.sh
python3 -m pytest -q tests
cd ..
python3 tools/audit_topics.py
python3 tools/build_topic_index.py
```
