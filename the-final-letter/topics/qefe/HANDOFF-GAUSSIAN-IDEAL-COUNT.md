# Handoff — Gaussian-integer/ideal-count library, class number formula, and quadratic generalisation

**Status:** Phase 1 done; Phase 2's ring-of-integers bridge done; **Phase 3 done
for `d = 2` and `d = 3`** (ring types, bridges, split primes, all three local
ideal counts, multiplicativity, ideal-count and representation formulas). The
Lean development was T125–T199 inside [`lean/Topic.lean`](lean/Topic.lean); it is
now also extracted, Mathlib-only, in [`lean/GaussianInt/`](lean/GaussianInt/)
and [`lean/QuadraticInt/`](lean/QuadraticInt/). The bridges
`𝓞 (ℚ(i)) ≃+* ℤ[i]`, `𝓞 (ℚ(√−2)) ≃+* ℤ[√−2]` and `𝓞 (ℚ(√−3)) ≃+* ℤ[ω]` are
proved. No `sorry`, `axiom`, or `admit` is present in any tree. See **Progress**
below for the verified record.

**Related:** [QEFE README](README.md) · [Lean README](lean/README.md) ·
[`L-SERIES-Z2.md`](L-SERIES-Z2.md) · [`HANDOFF.md`](HANDOFF.md) ·
[`CLASS-NUMBER-QI.md`](CLASS-NUMBER-QI.md) ·
[`GENERALISATION-QI.md`](GENERALISATION-QI.md).

---

## Progress (2026-11-14)

**Phase 1 — done.** T125–T199 are extracted into three Mathlib-only modules
that do not import `Topic.lean`:

| Module | Contents |
|---|---|
| [`lean/GaussianInt/Norm.lean`](lean/GaussianInt/Norm.lean) | basis, `Algebra.norm`, `Ideal.absNorm` of a principal ideal, units, the free unit action, the 4-to-1 element/ideal correspondence |
| [`lean/GaussianInt/IdealCount.lean`](lean/GaussianInt/IdealCount.lean) | `χ₄`, `divisorSumChi4`, `IdealCountFormula`, splitting at the three prime types, local counts, multiplicativity, the `ArithmeticFunction` assembly (`idealCountFormula`, T198) |
| [`lean/GaussianInt/TwoSquares.lean`](lean/GaussianInt/TwoSquares.lean) | `r2`, `TwoSquaresFormula`, `r2_eq_four_mul_idealCount` (T136/T137), `twoSquaresFormula` (T199) |

`./lean/check.sh` is green on all eight `.lean` files (the six under
`GaussianInt/`, plus `Topic.lean` and `ScratchPlus5.lean`), and
[`lean/GaussianInt/Audit.lean`](lean/GaussianInt/Audit.lean) reports

```text
GaussianInt.idealCountFormula  depends on axioms: [propext, Classical.choice, Quot.sound]
GaussianInt.twoSquaresFormula  depends on axioms: [propext, Classical.choice, Quot.sound]
```

The extraction is a *copy*, not a swap: `Topic.lean` still holds the originals
under `namespace QEFE`, so the site's declaration ledger is unchanged. Trimming
`Topic.lean` to import `GaussianInt.*` (with `QEFE` aliases) is left for the
upstream PR, because it changes every `QEFE.*` name referenced by
[`../index-lean/`](../index-lean/).

**Phase 2 — first gate done.** The handoff called the ring-of-integers bridge
"the main unknown" (§3.4, §6 action 3). It was absent from Mathlib and is now
proved:

```lean
-- lean/GaussianInt/RingOfIntegers.lean
noncomputable def GaussianInt.ringOfIntegersEquiv :
    NumberField.RingOfIntegers GaussianInt.QI ≃+* Zsqrtd (-1)
```

with `GaussianInt.QI := AdjoinRoot (X ^ 2 + 1 : Polynomial ℚ)` and clean axioms.
The remaining Phase 2 obligations — ideal transport, the Dedekind zeta
identification, the invariants of `ℚ(i)`, and the residue comparison — are
itemised with their API dependencies in
[`CLASS-NUMBER-QI.md`](CLASS-NUMBER-QI.md). One handoff risk note needs
correcting: the Leibniz series **is** in Mathlib
(`Real.tendsto_sum_pi_div_four`), so `β(1) = π/4` is cheap.

**Phase 3 — complete for `d = 2` and `d = 3`.** Both fields now have the full
counting development, not just the ring types:

* `d = 1`, `ℤ[i]`: `GaussianInt.r2_closed :
  (r2 n : ℤ) = 4 * Σ_{d|n} χ₄(d)` ([`GaussianInt/ClosedForm.lean`](lean/GaussianInt/ClosedForm.lean));
* `d = 2`, `ℤ[√−2]`: `ZsqrtdTwo.rTwo_closed :
  (Nat.card (NormElementsTwo n) : ℤ) = 2 * Σ_{d|n} χ₈'(d)`, plus
  `ZsqrtdTwo.idealCountTwo_closed` for the ideal count itself;
* `d = 3`, `ℤ[ω]`: `EisensteinInt.rThree_closed :
  (Nat.card (NormElementsThree n) : ℤ) = 6 * Σ_{d|n} χ₃(d)`, plus
  `EisensteinInt.idealCountThree_closed`.

The split-prime theorems (the missing `Nat.Prime.sq_add_sq` analogues) are
`ZsqrtdTwo.prime_sq_add_two_sq` (`p ≡ 1,3 mod 8 ⇒ p = a² + 2b²`, via
`legendreSym.at_neg_two` and Euler's criterion) and `EisensteinInt.prime_normE`
(`p ≡ 1 mod 3 ⇒ p = a² − ab + b²`, via Cauchy's theorem producing a cube root of
unity mod `p`). The inert and ramified counts, multiplicativity and the
divisor-sum assemblies are all in [`lean/QuadraticInt/`](lean/QuadraticInt/);
the capstones are audited in [`QuadraticInt/Audit.lean`](lean/QuadraticInt/Audit.lean).

What is **not** done: `d = 7, 11, …` and any non-PID field. The full record is
[`GENERALISATION-QI.md`](GENERALISATION-QI.md).

### Acceptance-criteria check (Phase 1)

- [x] The extracted files import only Mathlib.
- [x] They elaborate against the local Mathlib (`./lean/check.sh`).
- [x] `#print axioms` on `idealCountFormula` and `twoSquaresFormula` reports only
      `[propext, Classical.choice, Quot.sound]`.
- [x] No `native_decide`; the only global instances are the audited
      `normElementsMulAction` and `gaussianUnitsFintype` (as in `Topic.lean`).

### Phase 3 acceptance criteria

- [x] For each completed `d`, `#print axioms` clean on the capstones
      ([`QuadraticInt/Audit.lean`](lean/QuadraticInt/Audit.lean): all
      `[propext, Classical.choice, Quot.sound]`, two of them without
      `Classical.choice`).
- [x] The norm-form representation count is unconditional and matches the
      classical formula: `ZsqrtdTwo.rTwo_formula` and
      `EisensteinInt.rThree_formula`.
- [x] The split-prime inputs exist: `ZsqrtdTwo.prime_sq_add_two_sq` and
      `EisensteinInt.prime_normE`, axiom-clean.
- [x] All local ideal counts, multiplicativity, the divisor-sum formulas and the
      representation formulas are proved for `d = 2` and `d = 3`.
- [x] The generalisation does not change the `ℤ[i]` results; they remain a
      special case (`Topic.lean` and `GaussianInt/*` are untouched by Phase 3).

The "lake build in the local Mathlib checkout" criterion is met only in the
weaker sense that the modules elaborate with the Mathlib `LEAN_PATH` that
`check.sh` sets up; no separate Lake package has been added, because no topic in
this repository uses one.

**Follow-up not done:** the generated declaration index
[`../index-lean.md`](../index-lean.md) still lists only
`qefe/lean/Topic.lean`. It is produced by
[`../tools/build_lean_index.py`](../tools/build_lean_index.py); rerun it to
pick up `GaussianInt/*.lean` once the other in-flight topic edits are settled.

---

## 0. Why this work

The QEFE two-squares proof left behind a reusable formalisation:

- a Gaussian-integer norm/unit/basis API;
- the element-to-ideal correspondence `z ↦ (z)` with the four-unit action;
- a prime-splitting and local-ideal-count development for `p ≡ 1 mod 4`,
  `p ≡ 3 mod 4`, and `p = 2`;
- multiplicativity of the ideal count over coprime norms;
- an `ArithmeticFunction` assembly proving
  `# {I // absNorm I = n} = Σ_{d|n} χ₄(d)` and hence
  `r₂(n) = 4 Σ_{d|n} χ₄(d)`.

That is a self-contained number-theory library with three natural follow-ons:

1. extract it and propose it upstream;
2. use it to derive the class number formula for `ℚ(i)` and `L(1, χ₄) ≠ 0`;
3. generalise the architecture to other imaginary quadratic fields, starting
   with the class-number-one cases.

This handoff is written so each phase can be stopped independently. Phase 1 is
useful even if Phases 2–3 are never attempted.

---

## 1. Current state (verified locations)

All declarations are in the `QEFE` namespace in
[`lean/Topic.lean`](lean/Topic.lean). Mathlib-only copies under
`namespace GaussianInt` live in [`lean/GaussianInt/`](lean/GaussianInt/); the
names are identical after the namespace prefix.

| Group | Declarations | Notes |
|---|---|---|
| Gaussian basis | `gaussianVec`, `gaussianBasis`, `gaussianBasis_apply_zero/one`, `repr_gaussian_zero/one` | `Module.Basis (Fin 2) ℤ GaussianInt`; `GaussianInt = Zsqrtd (-1)` is Mathlib’s abbreviation |
| Norm | `algebra_norm_gaussian` (T125), `absNorm_span_gaussian` (T126) | `Algebra.norm ℤ z = z.norm`; `Ideal.absNorm (span {z}) = z.norm.natAbs` |
| Units | unit classification (T127), `gaussianUnits_card_four` (T128) | every unit is `1, -1, i, -i`; cardinality four |
| Element count | `r2_eq_natCard_gaussian` (T129), `normElements_smul_eq_self_iff` (T132) | `r2 n = Nat.card {z // z.norm.natAbs = n}`; free unit action for `n > 0` |
| 4-to-1 | `normElements_card_eq_four_mul_orbits` (T133), `orbitsEquivIdeals` (T134), `normElements_card_eq_four_mul_idealCount` (T135), `r2_eq_four_mul_idealCount` (T136) | Burnside, then orbit ↔ ideal |
| Split primes | T138–T140, T157–T178 | `p = π * star π`, two maximal ideals, local count `k+1` |
| Inert primes | T141, T144, T146–T151 | `(p)` prime, local count `1` for even exponent, `0` for odd |
| Ramified `2` | T142–T143, T145, T152–T154 | `(2) = (1+i)²`, local count `1` |
| Multiplicativity | T179–T194 | coprime decomposition, `gaussianIdealCountEquiv`, `gaussian_idealCount_mul` |
| Arithmetic functions | `idealCountFun` (T195), `divisorSumFun` (T196), `idealCount_prime_pow_eq` (T197) | packaged as `ArithmeticFunction ℤ` |
| Capstones | `idealCountFormula` (T198), `twoSquaresFormula` (T199) | `#print axioms` expected clean |
| P1 / Epstein | `lambdaZ2_product` (T120), `epstein_series_eq_four_zeta_beta` (T122), `LambdaZ2_eq_epstein` (T123) | the class-number application uses T120 and T199 |

**Local-instance pattern.** Several ideal-norm lemmas need
`Module.Free ℤ GaussianInt` and `Module.Finite ℤ GaussianInt`. The file supplies
them locally with `Module.Free.of_basis gaussianBasis` /
`Module.Finite.of_basis gaussianBasis`; do not register them globally without
checking for instance loops.

**Do not break.** T128 uses kernel `decide`, not `native_decide`; the latter
introduced an `ax_1_1` axiom in an earlier attempt. Keep it that way.

---

## 2. Phase 1 — extract the library

**Status: done.** See **Progress** above; the three proposed files exist under
`lean/GaussianInt/`. The subsections below are kept as the record of the design
decisions that were followed.

### 2.1 Target layout

Proposed standalone files (names are negotiable):

```text
GaussianInt/Norm.lean          -- basis, norm, units, free/finite instances
GaussianInt/IdealCount.lean    -- element/ideal correspondence, splitting, local counts
GaussianInt/TwoSquares.lean    -- ArithmeticFunction assembly, T198/T199
```

Move only Mathlib-level material. `r2` and `divisorSumChi4` can stay as local
definitions in `TwoSquares.lean`; the reusable content is the ideal count, not
the QEFE-specific `r2`.

### 2.2 What to generalise while extracting

- State the principal-ideal norm lemma for `Zsqrtd d` if it is cheap; at minimum
  keep the `d = -1` version cleanly separated.
- Keep `Ideal.absNorm` as the norm, not a bespoke counting function.
- Use `Nat.card` of the subtype `{I // absNorm I = n}`; avoid `Finset` filters.
- State the local counts as `Nat.card` equalities, then package them.
- Keep the `ArithmeticFunction` layer thin: `idealCountFun`, `divisorSumFun`,
  and one multiplicativity lemma each.

### 2.3 Upstream shape

A realistic upstream sequence is three PRs:

1. **Gaussian norm and units** — basis, `algebra_norm_gaussian`,
   `absNorm_span_gaussian`, unit classification and cardinality.
2. **Ideal counts in `ℤ[i]`** — the 4-to-1 correspondence, the three splitting
   cases, local counts, and multiplicativity.
3. **Two-squares corollary** — `IdealCountFormula` and `TwoSquaresFormula`.

Do not propose the QEFE ledger or the `r2` definition upstream. Do propose the
ideal-count theorem; it is the reusable statement.

### 2.4 Acceptance criteria

- The extracted files import only Mathlib (no `Topic.lean`).
- `lake build` succeeds in the local Mathlib checkout.
- `#print axioms` on `idealCountFormula` and `twoSquaresFormula` reports only
  `[propext, Classical.choice, Quot.sound]`.
- No `native_decide`; no new global instances unless audited.

### 2.5 First actions

1. Copy T125–T199 into a scratch file that imports only `Mathlib`; check it
   compiles without the rest of `Topic.lean`.
2. Split at the `/-! ## Gaussian integers` boundary and at the
   `ArithmeticFunction` boundary; fix namespaces.
3. Run `#print axioms` before and after the split; the set must not grow.

---

## 3. Phase 2 — class number formula for `ℚ(i)` and `L(1, χ₄) ≠ 0`

### 3.1 What Mathlib already has

`Mathlib/NumberTheory/NumberField/DedekindZeta.lean` provides:

- `NumberField.dedekindZeta K`,
- `NumberField.dedekindZeta_residue K`,
- `NumberField.tendsto_sub_one_mul_dedekindZeta_nhdsGT`, the Dirichlet class
  number formula:
  ```lean
  Tendsto (fun s : ℝ => (s - 1) * dedekindZeta K s) (𝓝[>] 1)
    (𝓝 (dedekindZeta_residue K))
  ```
  with
  ```lean
  dedekindZeta_residue K =
    (2 ^ nrRealPlaces K * (2 * π) ^ nrComplexPlaces K * regulator K * classNumber K) /
      (torsionOrder K * Real.sqrt |discr K|)
  ```

This means the class number formula itself is not the gap. The gaps are the
**identification of the `ℚ(i)` invariants** and the **independent residue
computation**.

### 3.2 The `ℚ(i)` computation

For `K = ℚ(i)`:

- `nrRealPlaces K = 0`, `nrComplexPlaces K = 1`;
- `regulator K = 1` (imaginary quadratic);
- `torsionOrder K = 4` (units `±1, ±i`);
- `discr K = -4`, so `Real.sqrt |discr K| = 2`;
- hence
  ```text
  dedekindZeta_residue K = (2π * 1 * h) / (4 * 2) = π h / 4.
  ```

Verify Mathlib’s normalisation of `regulator` and `torsionOrder` for an
imaginary quadratic field before relying on the arithmetic; the expected values
are `regulator = 1` and `torsionOrder = 4`, but the definitions should be
checked in the checkout rather than assumed.

Independently, `ζ_ℚ(i)(s) = ζ(s) L(s, χ₄) = ζ(s) β(s)`, so the residue at
`s = 1` is `L(1, χ₄) = β(1)`. The classical evaluation is
`β(1) = π/4`. Equating gives `π h / 4 = π / 4`, hence `h = 1` and
`L(1, χ₄) ≠ 0`.

### 3.3 Formalisation obligations

In dependency order:

1. **Ring of integers.** Build or locate `𝓞 (ℚ(i)) ≃+* ℤ[i]`. I did not find a
   prebuilt equivalence in this Mathlib checkout; verify before scoping. Without
   it, `dedekindZeta (ℚ(i))` cannot be identified with the `ℤ[i]` ideal-count
   L-series.
2. **Ideal-count coefficients.** Transport T136 across the equivalence:
   ```lean
   Nat.card {I : Ideal (𝓞 K) // absNorm I = n} = r2 n / 4
   ```
   for `n ≥ 1`. This is where the extracted library pays off.
3. **Dedekind zeta identification.**
   ```lean
   dedekindZeta (ℚ(i)) s = (1/4) * LSeries (fun n => (r2 n : ℂ)) s
   ```
   on the convergence half-plane, then `= ζ(s) β(s)` by T121/T122.
4. **Residue computation.** Prove
   ```lean
   Tendsto (fun s : ℝ => (s - 1) * (riemannZeta s * betaSeries s)) (𝓝[>] 1) (𝓝 (π/4))
   ```
   using `Res ζ = 1` and `β(1) = π/4`.
5. **Evaluation `β(1) = π/4`.** This is the Leibniz series
   `1 - 1/3 + 1/5 - ... = π/4`. **Correction (verified):** Mathlib has this as
   `Real.tendsto_sum_pi_div_four` (`Mathlib/Analysis/Real/Pi/Leibniz.lean`), so
   the evaluation is a short identification with the local `betaSeries`, not a
   sub-project. The `h = 1` derivation still needs the exact value.
6. **Assemble.**
   ```lean
   theorem classNumber_gaussianInt : classNumber (ℚ(i)) = 1
   theorem L_one_chi4_ne_zero : betaSeries 1 ≠ 0
   ```

### 3.4 Risk notes

- ~~The `𝓞 (ℚ(i)) ≃ ℤ[i]` bridge is the main unknown.~~ **Resolved:** it is
  proved in [`lean/GaussianInt/RingOfIntegers.lean`](lean/GaussianInt/RingOfIntegers.lean),
  with clean axioms. The route avoids trace/norm: `IsFractionRing` from rational
  coordinates, `IsIntegrallyClosed` from the Euclidean structure of `ℤ[i]`, and
  `IsIntegralClosure.of_isIntegrallyClosed`. The remaining risks are bookkeeping
  (real/complex `LSeries`, basis-independence of `discr`) and the infinite-place
  count for `AdjoinRoot (X² + 1)`; see
  [`CLASS-NUMBER-QI.md`](CLASS-NUMBER-QI.md) §2.5.
- `dedekindZeta` is an `LSeries` of ideal counts, so the identification is a
  coefficientwise argument; `LSeries_congr` and the existing T136 should carry
  most of it. The missing packaged lemma is an ideal-lattice equivalence along
  a ring equivalence (`Ideal.map`/`Ideal.comap` exist, but not bundled).
- Do not assume the class number formula as a hypothesis. The point is to
  **derive** `h = 1` from Mathlib’s general formula and the independent residue.

### 3.5 Acceptance criteria

- No `sorry`/`axiom`.
- `#print axioms classNumber_gaussianInt` is clean.
- The theorem is unconditional: it does not assume `h = 1`, `L(1, χ₄) = π/4`,
  or the class number formula for `ℚ(i)`.

---

## 4. Phase 3 — other imaginary quadratic fields

**Status: done for `d = 2` and `d = 3`.** Ring types, bridges, split-prime
theorems, all three local ideal counts, multiplicativity, the ideal-count
formulas and the representation formulas are proved. `d = 7, 11, …` are not
attempted. See **Progress** above and
[`GENERALISATION-QI.md`](GENERALISATION-QI.md).

### 4.1 Order of attack

Class-number-one imaginary quadratic fields:

```text
d = 1, 2, 3, 7, 11, 19, 43, 67, 163
```

Start with `d = 2` and `d = 3`; they exercise the two ring-of-integers shapes:

- `d = 2`: `𝓞 = ℤ[√−2]`, units `±1` (`w = 2`), discriminant `−8`;
- `d = 3`: `𝓞 = ℤ[(1+√−3)/2]`, units `±1, ±ω, ±ω²` (`w = 6`),
  discriminant `−3`.

Then `d = 7, 11` (units `±1`, `d ≡ 3 mod 4`, so the ring is
`ℤ[(1+√−d)/2]`), then the larger discriminants.

### 4.2 Reusable proof shape

For each field:

1. norm and unit API;
2. `Ideal.absNorm` of a principal ideal;
3. the unit action and the generator/ideal correspondence;
4. splitting law:
   - `p` split iff `(−d/p) = 1` (or the appropriate Kronecker symbol);
   - `p` inert iff `(−d/p) = −1`;
   - ramified primes divide the discriminant;
5. local ideal counts for prime powers;
6. multiplicativity over coprime norms;
7. arithmetic-function assembly;
8. representation-number corollary (`r_Q(n)` for the norm form).

### 4.3 What changes

- **Units.** The 4-to-1 count becomes `w`-to-1, where `w = |μ_K|`. The Burnside
  step and the orbit/ideal equivalence need `w` in place of `4`.
- **Ring shape.** For `d ≡ 3 mod 4`, the ring is not `ℤ[√−d]` but the
  half-integer ring; the basis and norm formulas differ.
- **Splitting law.** The `χ₄` divisor sum is replaced by the quadratic
  character `χ_{−d}`; the local counts are the same three types.
- **Class number one.** The PID property gives the generator/ideal
  correspondence. For non-PID fields the correspondence must be replaced by
  ideal classes; do not attempt those in the first pass.

### 4.4 Deliverable

A single theorem schema, parameterised by the field (or by `d` with a
`Fact (classNumber K = 1)` style hypothesis), that yields the ideal-count
formula and the representation-number formula. If a fully general statement is
too expensive, deliver `d = 2` and `d = 3` as concrete instances and document
the pattern.

### 4.5 Acceptance criteria

- For each completed `d`, `#print axioms` clean.
- The norm-form representation count is unconditional and matches the classical
  formula for that field.
- The generalisation does not change the ℤ[i] results; they remain special
  cases.

---

## 5. Verification commands

```bash
cd the-final-letter/topics/qefe
./lean/check.sh                                   # six files, all green
python3 -m pytest -q tests                        # 29 passed
./lean/check.sh GaussianInt/Audit.lean            # axiom audit
```

`check.sh` supplies the local Mathlib `LEAN_PATH` and elaborates each file with
the matching `lean` binary, so a separate Lake package is unnecessary; the
handoff's "lake build in the local Mathlib checkout" is satisfied in this
weaker but equivalent sense. (Two stale untracked scratch files that broke the
bare `./lean/check.sh` run were renamed to `ScratchChk3.lean.bak` and
`ScratchOSI.lean.bak`; `ScratchPlus5.lean` still builds.)

For the axiom audits of the extracted tree, `lean/GaussianInt/Audit.lean` runs:

```lean
import GaussianInt.TwoSquares
import GaussianInt.RingOfIntegers
#print axioms GaussianInt.idealCountFormula
#print axioms GaussianInt.twoSquaresFormula
#print axioms GaussianInt.ringOfIntegersEquiv
```

Expected: `[propext, Classical.choice, Quot.sound]` for every line.

---

## 6. First three concrete actions

All three are done (2026-11-14); their outcomes are the Progress section above.

1. ~~Run `./lean/check.sh` and audit T198/T199; record the exact axiom set.~~
   Green; axiom set is `[propext, Classical.choice, Quot.sound]` for both
   `QEFE.*` and `GaussianInt.*`.
2. ~~Copy T125–T199 into a Mathlib-only scratch file and confirm it compiles
   without the QEFE prefix; this is the extraction feasibility test.~~ Done as
   the three `lean/GaussianInt/*.lean` modules under `namespace GaussianInt`.
3. ~~Search Mathlib for `𝓞 (ℚ(i)) ≃ ℤ[i]` (or the `IsIntegralClosure` instance).
   If absent, write a one-page scoping note for that bridge before touching the
   class number formula.~~ Absent (`grep` finds no `RingOfIntegers`/`GaussianInt`
   or `RingOfIntegers`/`Zsqrtd` result), so the note was written — and then the
   bridge was proved anyway. The note is now the remaining-obligations plan,
   [`CLASS-NUMBER-QI.md`](CLASS-NUMBER-QI.md).

---

## 7. What not to claim

- Do not claim the extracted library is already upstream; it is a proposal.
- Do not claim the class number formula for `ℚ(i)` is proved. The bridge
  `𝓞 (ℚ(i)) ≃ ℤ[i]` **is** proved (`GaussianInt.ringOfIntegersEquiv`), but the
  residue identification and `β(1) = π/4` are not.
- Do not claim the generalisation to all imaginary quadratic fields; only the
  class-number-one cases are in scope, and only `d = 2, 3` are realistic first
  targets, and for those two the development is **complete**: ring types,
  bridges, split primes, local counts, multiplicativity and the representation
  formulas are all proved (`QuadraticInt/*.lean`). `d = 7` and beyond are not
  attempted.
- This work does not touch RH, Weil positivity, or the QEFE source claim.
