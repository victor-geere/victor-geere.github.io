# Class number formula for `ℚ(i)` — status and remaining obligations

**Status:** the ring-of-integers bridge is now **proved** in Lean; the residue
comparison is **not**. This note records exactly what is done, what is not, and
what a completion would take. No claim of the class number formula for `ℚ(i)`
is made anywhere in the dossier.

**Related:** [HANDOFF-GAUSSIAN-IDEAL-COUNT.md](HANDOFF-GAUSSIAN-IDEAL-COUNT.md)
(Phase 2) · [GENERALISATION-QI.md](GENERALISATION-QI.md) (Phase 3) ·
[`lean/README.md`](lean/README.md) · [L-SERIES-Z2.md](L-SERIES-Z2.md).

---

## 1. What is proved

The handoff flagged the `𝓞 (ℚ(i)) ≃ ℤ[i]` bridge as "the main unknown" and
suggested writing a scoping note "before touching the class number formula"
(§3.4 and §6). The bridge turned out to be reachable and is now in
[`lean/GaussianInt/RingOfIntegers.lean`](lean/GaussianInt/RingOfIntegers.lean):

```lean
noncomputable def GaussianInt.ringOfIntegersEquiv :
    NumberField.RingOfIntegers GaussianInt.QI ≃+* Zsqrtd (-1)
```

where `GaussianInt.QI := AdjoinRoot (X ^ 2 + 1 : Polynomial ℚ)` presents `ℚ(i)`.
`#print axioms` on it reports only `[propext, Classical.choice, Quot.sound]`
(see [`lean/GaussianInt/Audit.lean`](lean/GaussianInt/Audit.lean)).

The proof deliberately avoids any trace/norm computation:

1. `ℚ(i)` is `AdjoinRoot (X² + 1)`; `X² + 1` is irreducible over `ℚ`
   (`irreducible_X_sq_add_one`), so Mathlib's `NumberField` instance applies.
2. `ℤ[i] ↪ ℚ(i)` is `Zsqrtd.lift` at the class of `X` (`toQI`), and is injective
   by `Zsqrtd.lift_injective` (`toQI_injective`).
3. `ℚ(i)` is two-dimensional over `ℚ` (`finrank_QI`), with the explicit
   `ℚ`-basis `pb2 = {1, i}` and coordinate decomposition
   `z = a + b·i`, `a b : ℚ` (`coord_eq`).
4. Coordinates plus a common denominator show every element of `ℚ(i)` is a
   quotient of two elements of `ℤ[i]` (`exists_div`), so
   `IsFractionRing (Zsqrtd (-1)) QI` (via `IsFractionRing.of_field`).
5. `ℤ[i]` is a Euclidean domain, hence `IsIntegrallyClosed`
   (`inferInstance`), and module-finite over `ℤ` (`Module.Finite.of_basis
   gaussianBasis`), hence integral over `ℤ`. Mathlib's
   `IsIntegralClosure.of_isIntegrallyClosed` then gives
   `IsIntegralClosure (Zsqrtd (-1)) ℤ QI`.
6. `NumberField.RingOfIntegers.equiv` converts that into the ring equivalence.

Nothing here is specific to `d = 1`; steps 1–4 and 6 are the shape a quadratic
generalisation reuses (see [GENERALISATION-QI.md](GENERALISATION-QI.md)).

## 2. What is *not* proved

The class number formula itself is **not** derived. The remaining chain, in
dependency order, is below. Each item names the Mathlib API it would use, so the
list is a work plan rather than a wish.

### 2.1 Transporting the ideal count (expected: mechanical)

> `Nat.card {I : Ideal (𝓞 QI) // absNorm I = n}
>    = Nat.card {J : Ideal (Zsqrtd (-1)) // absNorm J = n}` for every `n`.

`Ideal.absNorm` is `Submodule.cardQuot`, i.e. `Nat.card (R ⧸ I)`
(`Ideal.absNorm_apply`), for any `[IsDedekindDomain R] [Infinite R]`. A ring
equivalence `e : R ≃+* S` induces `Ideal.quotientEquiv I (I.map e) e rfl`, so
`Nat.card (R ⧸ I) = Nat.card (S ⧸ I.map e)` and hence `absNorm (I.map e) =
absNorm I`. What is missing is the packaged bijection on *ideals*: Mathlib has
`Ideal.map`/`Ideal.comap` with `Ideal.map_comap_of_surjective` and
`Ideal.comap_map_of_surjective`, but no bundled `Ideal R ≃ Ideal S` for a ring
equivalence. The plan is to build that equiv by hand (about 30–40 lines) and
derive the subtype equivalence.

### 2.2 Identifying the Dedekind zeta function (expected: cheap once 2.1 lands)

`NumberField.dedekindZeta K s` is *defined* as
`LSeries (fun n => Nat.card {I : Ideal (𝓞 K) // absNorm I = n}) s`
(`Mathlib/NumberTheory/NumberField/DedekindZeta.lean`). So 2.1 plus
`LSeries_congr` gives

```lean
dedekindZeta QI s = LSeries (fun n => (GaussianInt.idealCount n : ℂ)) s.
```

### 2.3 The `ζ(s)β(s)` identification (expected: cheap, needs one extraction)

`GaussianInt.idealCountFormula` (T198, now in
[`lean/GaussianInt/IdealCount.lean`](lean/GaussianInt/IdealCount.lean)) gives
`idealCount n = divisorSumChi4 n` for `n ≥ 1`. The companion identity
`LSeries (divisorSumChi4 ·) s = ζ(s) β(s)` is T121
(`QEFE.LSeries_divisorSumChi4`), but it is **not** in the extracted library: it
still lives in `Topic.lean` and depends on the QEFE-local `betaSeries`
(`Topic.lean`, the `BetaSeriesStatement` block). Extracting `betaSeries`,
`chi4Int` and T120–T123 into a fourth module (say `GaussianInt/BetaSeries.lean`)
is the clean fix; the beta functional equation machinery around T100–T123 is
much larger than what the identification actually needs.

### 2.4 The residue at `s = 1` (the genuinely hard analytic step)

Two independent limits must be equated:

```lean
Tendsto (fun s : ℝ => (s - 1) * dedekindZeta QI s) (𝓝[>] 1) (𝓝 (dedekindZeta_residue QI))
Tendsto (fun s : ℝ => (s - 1) * (riemannZeta s * betaSeries s)) (𝓝[>] 1) (𝓝 (π / 4))
```

The first is Mathlib's `NumberField.tendsto_sub_one_mul_dedekindZeta_nhdsGT`
(Dirichlet's class number formula) — available, unconditional. The second needs
`Res_{s=1} ζ = 1` together with `β(1) = π/4`.

**Good news, correcting the handoff's risk note (§3.3 item 5):** the Leibniz
series is already in Mathlib —
`Real.tendsto_sum_pi_div_four : Tendsto (fun k => ∑ i ∈ range k, (-1)^i / (2*i+1)) atTop (𝓝 (π/4))`
in `Mathlib/Analysis/Real/Pi/Leibniz.lean`. So `β(1) = π/4` reduces to rewriting
the QEFE `betaSeries` at `s = 1` as that alternating series and identifying its
`tsum` with the limit of partial sums. This is a short analytic exercise, not a
sub-project.

The residue step still requires care: `dedekindZeta` is an `LSeries` of nonnegative
integer coefficients, and `(s-1) * LSeries …` is a `Tendsto` along `𝓝[>] 1` of a
real-valued function, while `LSeries (fun n => (idealCount n : ℂ)) s` is
complex-valued. Bridging the two (real ↔ complex, and the `s : ℝ` vs `s : ℂ`
coercions) is bookkeeping that should be set up once, in a small `LSeries`
helper file.

### 2.5 The invariants of `ℚ(i)` (medium; definition checks below are from the checkout)

`dedekindZeta_residue QI` unfolds to

```text
(2 ^ nrRealPlaces QI * (2 * π) ^ nrComplexPlaces QI * regulator QI * classNumber QI)
  / (torsionOrder QI * Real.sqrt |discr QI|).
```

The expected values, and how they are defined, verified against this Mathlib
checkout:

| Invariant | Expected | Definition | Route |
|---|---|---|---|
| `nrRealPlaces` | `0` | `card {w : InfinitePlace K // IsReal w}` | every infinite place of `ℚ(i)` is complex |
| `nrComplexPlaces` | `1` | `card {w : InfinitePlace K // IsComplex w}` | `InfinitePlace QI` is a singleton |
| `regulator` | `1` | `ZLattice.covolume (unitLattice K)` | `rank K = card (InfinitePlace K) - 1 = 0`, and `regulator_eq_det` is the determinant of an empty matrix, i.e. `1` |
| `torsionOrder` | `4` | `Nat.card (CommGroup.torsion (𝓞 K)ˣ)` | via the bridge, units of `𝓞 QI` are `±1, ±i`, all torsion; `GaussianInt.gaussianUnits_card_four` gives `Nat.card ℤ[i]ˣ = 4` |
| `discr` | `-4` | `Algebra.discr ℤ (RingOfIntegers.basis K)` | trace form `Tr(a + bi) = 2a`, matrix `[[2,0],[0,-2]]`, determinant `-4` |

Two caveats worth recording rather than discovering later:

* `regulator` is stated for the full-rank unit lattice, but `logSpace K` is
  `{w : InfinitePlace K // w ≠ w₀} → ℝ` (dimension `r₁ + r₂ - 1 = 0` for
  imaginary quadratic), so the "lattice" is trivial. The determinant route via
  `regulator_eq_det` is the clean way to get `1`; the `covolume` definition
  itself should not be unfolded for a non-full-rank lattice.
* `discr` is defined through the *chosen* `RingOfIntegers.basis`. The
  discriminant is basis-independent, but the transported computation needs that
  fact stated for this basis (or a change-of-basis lemma with determinant a unit
  of `ℤ`). Budget for it; do not assume it.

### 2.6 Assembly

Once 2.1–2.5 land:

```lean
theorem classNumber_gaussianInt : NumberField.classNumber QI = 1
theorem L_one_chi4_ne_zero : betaSeries 1 ≠ 0
```

The derivation is `π * h / 4 = dedekindZeta_residue QI = β(1) = π / 4`, so
`h = 1`; `β(1) = π/4 ≠ 0` follows from `Real.pi_pos`.

## 3. Ordering and size

| Step | Depends on | Rough size | Risk |
|---|---|---|---|
| 2.1 ideal transport | bridge | small | API plumbing only |
| 2.2 zeta identification | 2.1 | small | `LSeries_congr` plumbing |
| 2.3 `ζβ` identification | extraction of the beta layer | small–medium | extraction boundaries |
| 2.5 invariants | bridge, 2.1 | medium | infinite places of `AdjoinRoot (X²+1)`; basis-independence of `discr` |
| 2.4 residue | 2.2, 2.3, Leibniz | medium | real/complex `LSeries` coercion |
| 2.6 assembly | all | small | — |

The bridge was the only item with genuine mathematical uncertainty. Everything
remaining is either API plumbing (2.1, 2.2) or standard but laborious
specialisation (2.5), with one short analytic lemma (2.4) that Mathlib already
provides in the needed form.

## 4. What not to claim

* The class number formula for `ℚ(i)` is **not** proved. Only the bridge
  `𝓞 (ℚ(i)) ≃ ℤ[i]` is.
* `L(1, χ₄) = π/4` is **not** proved in this development; Mathlib has the
  Leibniz series, but the identification with the QEFE `betaSeries` is not done.
* No statement here touches RH, Weil positivity, or the QEFE source claim.
