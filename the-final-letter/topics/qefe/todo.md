# QEFE — next steps

Working list for the QEFE dossier, ordered by value per unit of work. The
programme's end state is the trichotomy at the foot of this file, not a proof of
the source's identity.

## 1. Promote the refutation — done

- [x] Change the status line in [`index.html`](index.html) and
      [`README.md`](README.md) from "the source's finite functional equation is
      **not** asserted" to what is actually proved: the displayed v8 identity is
      false, by a structural pole obstruction, independently of the numerics.
- [x] Add the refutation rows to the theorem ledger: `Gamma_neg_one`,
      `gammaRatio_ising_pole`, `qefe_fails_ising`, `gammaRatio_su2_pole`,
      `qefe_fails_su2` (T200–T204).
- [x] Correct the "Honesty note" in [`lean/README.md`](lean/README.md): it lists
      everything the file does *not* do, but not that it refutes the claim. Add
      the two refutations to the "It proves" table.
- [x] Make the refutation the topic's headline rather than a disclaimer. A
      dossier that refutes a claim is worth more than one that declines to
      assert it.

**Effort:** hours. **Done when:** `qefe_fails_ising` and `qefe_fails_su2` appear
in the ledger, both READMEs, and the status block, and no prose still describes
the identity as merely unproven.

## 2. Harden the refutation

- [ ] Replace the point-evaluation argument with **unboundedness near the first
      pole**: `‖Ψ(s) − RHS(s)‖ → ∞` as `s → 1 + a`, using continuity of `Ψ` and
      of `Γ((s+a)/2)` at `1 + a` and the simple pole of `Γ` at `0`.
- [ ] Keep the existing point evaluations as corollaries, not as the main
      statement.
- [ ] Note the three independent defects, any one sufficient:
      the pole obstruction (`test_gamma_pole_obstruction`), the printed theta
      exponent (`test_source_mellin_normalisation`), and the Ising sign product
      (`test_ising_sign_product_inconsistency`).

**Why:** `Real.Gamma (−1) = 0` is Mathlib's junk-value convention; a critic will
say the intended reading is meromorphic, where both sides diverge at `s = 3` and
the comparison is void. Unboundedness is immune to the convention and is the
correct structural statement.

**Effort:** days. **Done when:** a Lean theorem states the residual is unbounded
at the pole, and the docs say why the junk-value version is not the load-bearing
one.

## 3. Formalise the growth obstruction — partial

- [x] Non-zero total: `finiteThetaSum_not_modular_of_sum_ne_zero` (T217) proves
      that a finite exponential sum with `Σ cᵢ ≠ 0` fails every weight-`w`
      modular relation.
- [ ] Zero total: iterate the moment expansion (Vandermonde) to cover
      `Σ cᵢ = 0` while some `cᵢ ≠ 0`.
- [ ] Proof shape: at `τ → ∞` the left side of `Θ(1/τ) = ε τ^w Θ(τ)` has a
      nonzero power-series term `C τ^(−n)` (some moment `Σ cᵢ λᵢⁿ ≠ 0`), while
      the right side is `O(τ^w e^(−λ_min τ))`.
- [ ] Instantiate on the Ising and `SU(2)₄` data, where `Ψ(0) = 1`, so `Θ ≢ 0`.

**Why:** this is the theorem that explains why P1 cannot be generalised — the
negative half of the classification. Without it, "P1 is a template with nothing
to template" is an observation; with it, it is a proposition.

**Effort:** one to two weeks. **Done when:** `Topic.lean` contains the
obstruction and a corollary that no nonzero finite datum has a theta-derived
functional equation.

## 4. Close P1 in Lean by the product route — done

- [x] Formalise the short proof already in [`L-SERIES-Z2.md`](L-SERIES-Z2.md):
      `Λ_ℤ²(s) = Z(s)B(s)` via Legendre duplication, Mathlib's zeta functional
      equation, and the completed beta FE, hence `Λ_ℤ²(s) = Λ_ℤ²(1−s)`.
      Lean: `gammaR_duplication` (T118), `lambdaZ2_self_dual` (T119),
      `lambdaZ2_product` (T120).
- [x] Keep the theta route of T9 as an independent check, not as the dependency.
- [x] Move P1 from "Proposition" to "Theorem" in the ledger and drop the
      paper-only caveat from the lattice section.
- [ ] Remaining: identify `LambdaZ2` with the Epstein/lattice series
      `Σ_{(m,n)≠0}(m²+n²)^(−s)`; this needs the two-squares theorem
      `r₂(n) = 4Σ_{d|n}χ₄(d)`.

**Effort:** about a week. **Done when:** P1 is a `QEFE` theorem and
`test_z2_epstein_functional_equation` is backed by a proof rather than only by a
certificate.

## 5. Decide the fate of the two named inputs — done

- [x] Keep `LatticeThetaMellinChi4` in
      [`THETA-INDEPENDENT.md`](THETA-INDEPENDENT.md). It buys independence from
      the Hurwitz development — a formalisation asset, not new mathematics.
- [x] Retire `RegularizedAnnularLatticeSeries` in
      [`PHASE-ANNULAR.md`](PHASE-ANNULAR.md). Under the trichotomy it is an
      alternative continuation for an object that already has one (P1); it is a
      solution in search of a problem, and carrying it as a headline gap
      inflates the topic's apparent open surface.
- [x] Replace it with the precise open question: does the functional equation
      survive the `k → ∞` limit of the `SU(2)_k` tower?

**Effort:** hours to decide, a day to propagate. **Done when:** the named-input
list is one item plus one stated open problem, not two named inputs.

## 6. Retire "the infinite lattice functional equation is not yet proved"

- [x] Reword to "cited, not formalised". Formalising rank-`n` Poisson summation
      (Cassels; Conway–Sloane) remains an optional routine target.
- [ ] Do not let a routine generalisation read as a research gap while the
      genuinely open `χ₄` vector case sits beside it.
- [ ] Small addendum: give P2 a **rate**, not just a limit. The `O(1/k)` bound
      from the Jordan inequality is the quantitatively useful statement; a bare
      limit at `k = 2048` is a screenshot.

**Effort:** weeks to formalise, an afternoon to reword. **Done when:** the
status block distinguishes textbook generalisation from open problem.

---

## 7. Gaussian ideal count and the class number of `ℚ(i)` — Phase 1 and bridge done

Follow-on from the two-squares proof; the scoping record is
[`HANDOFF-GAUSSIAN-IDEAL-COUNT.md`](HANDOFF-GAUSSIAN-IDEAL-COUNT.md).

- [x] Extract T125–T199 into three Mathlib-only modules under
      [`lean/GaussianInt/`](lean/GaussianInt/), with no import of `Topic.lean`.
- [x] Keep the axiom set unchanged: `idealCountFormula`,
      `twoSquaresFormula` and `ringOfIntegersEquiv` all report only
      `[propext, Classical.choice, Quot.sound]`
      ([`lean/GaussianInt/Audit.lean`](lean/GaussianInt/Audit.lean)).
- [x] Prove the ring-of-integers bridge
      `𝓞 (ℚ(i)) ≃+* ℤ[i]` (`GaussianInt.ringOfIntegersEquiv`).
- [ ] Transport the ideal count along the bridge:
      `Nat.card {I : Ideal (𝓞 QI) // absNorm I = n} = GaussianInt.idealCount n`.
      Needs a bundled ideal-lattice equivalence for a ring equivalence, which
      Mathlib lacks.
- [ ] Identify `dedekindZeta QI` with `LSeries (fun n => idealCount n)` and then
      with `ζ(s)β(s)`. Needs the `betaSeries`/T121 layer extracted.
- [ ] Prove `β(1) = π/4` from Mathlib's `Real.tendsto_sum_pi_div_four`.
- [ ] Compute the five invariants of `ℚ(i)`: `nrRealPlaces = 0`,
      `nrComplexPlaces = 1`, `regulator = 1`, `torsionOrder = 4`, `discr = −4`.
- [ ] Assemble `classNumber QI = 1` and `betaSeries 1 ≠ 0`.

**Effort:** days for transport plus zeta identification; the invariants are the
slow part (infinite places of `AdjoinRoot (X² + 1)`, basis-independence of
`discr`). **Done when:** `classNumber_gaussianInt` and `L_one_chi4_ne_zero`
exist, axiom-clean, with no hypothesis of the class number formula.

### Phase 3 — done for `d = 2, 3`

- [x] `IsIntegrallyClosed (Zsqrtd (-2))`, via a norm-Euclidean division on the
      rounding residuals ([`lean/QuadraticInt/ZsqrtdTwo.lean`](lean/QuadraticInt/ZsqrtdTwo.lean)).
- [x] The bridge `𝓞 (ℚ(√−2)) ≃+* ℤ[√−2]` (`ringOfIntegersEquiv_two`).
- [x] The Eisenstein integer ring `ℤ[ω]` as a new type, with `CommRing`,
      norm `a² − ab + b²`, `w = 6` units, and a norm-Euclidean division
      ([`lean/QuadraticInt/Eisenstein.lean`](lean/QuadraticInt/Eisenstein.lean)).
- [x] The bridge `𝓞 (ℚ(√−3)) ≃+* ℤ[ω]` (`ringOfIntegersEquiv_three`).
- [x] **Split primes (`d = 2`)**: `p ≡ 1,3 (mod 8) ⇒ p = a² + 2b²`
      (`ZsqrtdTwo.prime_sq_add_two_sq`), via `legendreSym.at_neg_two` and
      Euler's criterion.
- [x] **Split primes (`d = 3`)**: `p ≡ 1 (mod 3) ⇒ p = a² − ab + b²`
      (`EisensteinInt.prime_normE`), via Cauchy's theorem giving a cube root of
      unity mod `p`.
- [x] The `w`-to-`1` Burnside block rerun for `w = 2`
      (`normElementsTwo_card_eq_two_mul_idealCount`).
- [x] Principal-ideal norm for `d = 2` (`absNorm_span_two`), plus the split
      factorisation with distinct prime ideals (`split_prime_ne_two`).
- [x] Inert and ramified local counts for `d = 2` (`LocalTwo.lean`).
- [x] Principal-ideal norm and the `6`-to-`1` correspondence for `d = 3`.
- [x] Split, inert and ramified local counts for `d = 3` (`LocalThree.lean`,
      `SplitCountThreeFull.lean`).
- [x] Multiplicativity for both fields (`MultTwo.lean`, `MultThree.lean`).
- [x] Ideal-count formulas and representation formulas for both fields
      (`FormulaTwo.lean`, `FormulaThree.lean`), axiom-audited.
- [x] Closed-form restatement of the capstones: `GaussianInt.r2_closed`,
      `ZsqrtdTwo.idealCountTwo_closed`/`rTwo_closed`,
      `EisensteinInt.idealCountThree_closed`/`rThree_closed`.
- [ ] `d = 7, 11, …` and non-PID fields (out of scope).
**Effort:** the ring types and bridges took the bulk of the new code; the
splitting laws are the remaining mathematical input. **Done when:** the two
representation formulas exist, axiom-clean, and `ℤ[i]` remains the `d = 1`
special case. Details in [`GENERALISATION-QI.md`](GENERALISATION-QI.md).

---

## End goal

A closed audit built on a trichotomy, not an open-ended formalisation:

> **(a)** `Θ` admits a weight-`w` modular transformation only if `Θ ≡ 0`; no
> nonzero finite datum gets a theta-derived functional equation.
> **(b)** The displayed v8 identity fails for both Ising (`D² = 4`, `a = 0`) and
> `SU(2)₄` (`D² = 12`, `a = 1`), with the residual unbounded at the first gamma
> pole. The failure is structural, not numerical.
> **(c)** The only completed series in the family with a proved functional
> equation is `Λ_ℤ² = 4π^(−s)Γ(s)ζ(s)β(s)` (P1), and it requires the lattice,
> which T12 shows is available only in the pointed case.
> **(d)** Along the `SU(2)_k` tower the half-spectrum converges to `ζ(2s)` and
> `η(2s)` for `s > 1/2` (P2). Whether the functional equation survives that limit
> is **open**.

Deliverable: one paper, one `sorry`-free Lean file whose critical path contains
no named inputs (the two `def : Prop` statements stay off the theorem path), and
a topic page whose headline is the trichotomy rather than the disclaimer.
