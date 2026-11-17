# Geometric zeta — the decompositions, and what they do not buy

**Status:** Phase 0 — catalogue, base formalisation, numerical checks, the
Lean-proved finite-product impossibility, the all-bases telescoping identity, the
Lambert/Mellin transform `Γ(s)ζ(s)^2`, and a new lower-bound expansion for
`ζ(σ)^2` from the Mellin integral (paper + numerical; the Lean core is proved,
and the integrated bound is accepted as a paper/numerical result — formalisation
item closed by decision, 2026-11-10).  The three exact decompositions are
stated and audited; the Lambert and Euler identities are re-exported in Lean, the
zero-free-factor structure is proved, `no_finite_euler_product` proves that no
finite Euler product can equal `ζ`, the all-bases sum is proved to be `7/4`, the
Lambert/Mellin transform is proved to equal `Γ(s)ζ(s)^2`, and the numerical layer
checks all three identities.  No Riemann-hypothesis claim and no
positivity claim.  The RH-relevance audit is a documented no-go
([RH-AUDIT.md](RH-AUDIT.md)).  The next phase targets a new
unconditional inequality from the Mellin/Lambert representation or the additive
base decomposition; the acceptance bar is in §7.

## 1. The objects

For an integer `a ≥ 2`, the **geometric zeta** is

```
g_a(s) = Σ_{m≥1} a^{−ms} = 1/(a^s − 1),      Re s > 0.
```

Each `g_a` is a legitimate zeta function of the monoid `a^ℕ`.  It is zero-free,
and its poles are the solutions of `a^s = 1`, i.e. `s = 2πik/log a`, all on
`Re s = 0`.

## 2. Three exact identities

### 2.1 Multiplicative: the Euler product

```
ζ(s) = ∏_p (1 − p^{−s})^{−1},      Re s > 1.
```

Each factor is a `g_p`, and the factorisation is unique factorisation of the
integers.  This is Mathlib's `riemannZeta_eulerProduct_tprod`.

### 2.2 Additive: the non-perfect-power decomposition

```
ζ(s) = 1 + Σ_{a∈A} 1/(a^s − 1),      Re s > 1,
```

where `A = {a ≥ 2 : a is not a perfect power}`.  Every `n ≥ 2` is uniquely
`n = a^m` with `a ∈ A` and `m ≥ 1` (take `m` to be the gcd of the exponents in
the prime factorisation of `n`).  Expanding each term and collecting by `n`
gives the Dirichlet series, the multiplicity being exactly `1`.  The `+1` is the
`n = 1` term.

The index set is essential.  Over **all** bases one gets a different function:
at `s = 2`, `1 + Σ_{a≥2} 1/(a²−1) = 1 + 3/4 = 7/4`, whereas
`ζ(2) = π²/6 ≈ 1.6449`.  The non-perfect-powers are the unique base system for
which the geometric pieces tile `ℤ_{≥2}` exactly once.  The all-bases identity
`1 + Σ_{a≥2} 1/(a²−1) = 7/4` is proved in Lean as `all_bases_geometric_sum`.

### 2.3 Logarithmic

```
log ζ(s) = Σ_p Σ_{m≥1} p^{−ms}/m,      Re s > 1.
```

The Euler product's logarithm, with the harmonic weights `1/m` recording the
multiplicity of the prime power `p^m`.

### 2.4 Lambert/Mellin

For `|q| < 1`,

```
Σ_{k≥1} q^k/(1 − q^k) = Σ_{n≥1} d(n) q^n,
```

where `d(n)` is the divisor count.  This is Mathlib's
`tsum_pow_div_one_sub_eq_tsum_sigma` at `k = 0`, since `σ_0(n) = d(n)`.  With
`q = e^{−t}` and `Re s > 1`, the Mellin transform is

```
∫_0^∞ t^{s−1} Σ_k e^{−kt}/(1 − e^{−kt}) dt = Γ(s) ζ(s)^2.
```

This is the exact dictionary: sums of geometric series in `q` become products of
`ζ` in `s`.

## 3. Candidate catalogue and non-equivalence audit

The audit rule: a statement is **safe** if it is proved unconditionally (then it
cannot be RH-equivalent unless it proves RH), **known** if it is an existing
theorem, **negative** if it proves an impossibility, and **flagged** if it
quantifies over zeros or is a restatement of RH.  A statement is not accepted as
the programme's headline merely because it is safe; it must also have content
beyond a rearrangement.

| id | statement | status | audit |
|---|---|---|---|
| **G1** | Euler product | proved (Mathlib), re-exported | known; safe |
| **G2** | additive non-perfect-power identity | proved in this dossier; Lean open | exact rearrangement; safe; content is the canonical index set |
| **G3** | Lambert identity | proved (Mathlib), re-exported | known; safe |
| **G4** | log identity | classical; Lean open | known; safe |
| **G5** | Mellin/Lambert `Γ(s)ζ(s)^2` | **proved in Lean** (`lambert_mellin`, `lambert_mellin_divisors`) | known classically; safe; new to the formal record |
| **G6** | geometric factors and finite Euler products are zero-free where defined | proved in Lean | structural; safe |
| **G7** | the all-bases geometric sum `1 + Σ_{a≥2} 1/(a²−1) = 7/4` via telescoping | **proved in Lean** (`all_bases_sum`, `all_bases_geometric_sum`) | positive exact identity; safe; contrasts with `ζ(2) = π²/6` |
| **G8** | lower-bound expansion `ζ(σ)^2 ≥ 2^σ Σ_{j=0}^J Γ(σ+j)/(j!Γ(σ)) E_j(σ+j)` | proved in the dossier + numerical; pointwise majorant Lean-proved (`lambert_majorant`) | integral/lattice bound; safe; **not** a coefficientwise comparison |
| **C1** | `1 + Σ_{a≥2} 1/(a²−1) = 7/4 ≠ ζ(2)` | exact, as G7 | illustrative; safe |
| **C2** | a finite sum `Σ_k c_k/(a_k^s−1)` cannot equal `ζ` | negative result: as `s→+∞` the sum `→0` while `ζ(s)→1` | safe; content |
| **C3** | a finite product `∏_k (1−p_k^{−s})^{−1}` cannot equal `ζ` | negative result: at `s = 1` the product is finite while `ζ` has a pole | **proved in Lean** (`no_finite_euler_product`); safe; content |
| **C4** | individual `g_a` have poles on `Re s = 0` and no termwise continuation past `Re s = 1` | structural | safe; explains the limit of the additive route |
| **C5** | non-perfect-powers have density `1`; perfect powers `≤ x` are `O(√x log x)` | classical counting | safe; arithmetic content; Lean open |
| **C6** | `|ζ(σ+it)| ≤ ζ(σ)` for `σ > 1` | trivial from the Dirichlet series | known; safe |
| **C7** | finite Euler products are zero-free in the critical strip | special case of G6 | safe; the "collective effect" statement |
| **C8** | "the additive sum has no zeros in the critical strip" | **invalid** | the sum diverges for `Re s ≤ 1`; there is no continuation to speak of |
| **C9** | "a positivity inequality from the Lambert series implies RH" | **not claimed** | any such implication would need its own audit; no positivity status is changed here |

The two flagged entries are recorded so they are not accidentally re-derived as
if they were theorems.

## 4. What the audit rules out

- **Finitely many geometric factors are impossible.**  A finite sum cannot equal
  `ζ` (C2), and a finite product cannot equal `ζ` (C3, Lean-proved as
  `no_finite_euler_product`).  The additive and multiplicative decompositions are
  necessarily infinite; this is the analytic form of Euclid's theorem.
- **No finite stage sees a zero.**  Each `g_a` is zero-free, and a finite Euler
  product is zero-free wherever it is defined (G6).  Zeros of `ζ` are therefore a
  collective effect of the infinite product's non-uniform convergence in the
  critical strip; nothing in a single factor or a finite stage hints at them.
- **The additive route does not continue.**  The individual terms `g_a` have
  poles on `Re s = 0`, and the sum converges only for `Re s > 1`.  It is an exact
  representation in the half-plane of absolute convergence, not a continuation.
- **The decompositions carry no zero information.**  They are rearrangements of
  the same Dirichlet series.  A genuine new inequality would have to be proved
  unconditionally and say something the rearrangements do not already say.

## 5. What is formalised in Lean

[`lean/Topic.lean`](lean/Topic.lean) (namespace `GeometricZeta`):

| item | Lean |
|---|---|
| G1 Euler product | `eulerProduct` |
| G3 Lambert identity | `lambert_identity`, `lambert_identity_divisors` |
| G6 geometric factor zero-free | `geomFactor_ne_zero` |
| G6 finite product zero-free | `finiteEulerProduct_ne_zero` |
| C3 no finite Euler product equals `ζ` | `no_finite_euler_product` |
| G7 all-bases geometric sum `= 7/4` | `all_bases_sum`, `all_bases_geometric_sum` |
| G5 Lambert/Mellin `Γ(s)ζ(s)^2` | `lambert_mellin`, `lambert_mellin_divisors` |
| Pointwise AM–GM majorant for `L(e^{−u²})` | `lambert_majorant` |
| Gaussian moment `∫ u^{2σ−1}e^{−a u²}du = ½Γ(σ)a^{−σ}` | `gaussian_moment` |
| Identification `Σ_n d(n)q^n = Σ_{k,m} q^{km}` | `lambert_eq_double` |
| Complex-power identity `((x:ℂ)^2)^(s−1) = x^(2(s−1))` | `cpow_sq` |
| Dirichlet series `Σ d(n)/n^s = ζ(s)^2` | `divisor_hasSum`, `divisor_summable` |

The additive identity (G2), the log identity (G4), and the counting statement
(C5) are not yet formalised; they are the next Lean targets.  The Mellin/Lambert
transform G5 **is** formalised (`lambert_mellin`, `lambert_mellin_divisors`),
supported by `divisor_hasSum` and `divisor_summable`; the pointwise AM–GM
majorant underlying the new inequality is `lambert_majorant`.  See [`lean/README.md`](lean/README.md).

## 5a. A new lower-bound expansion (the inequality direction)

For real `σ > 1` and every `J ≥ 0`,

```
ζ(σ)^2  ≥  2^σ  Σ_{j=0}^{J}  (Γ(σ+j) / (j! Γ(σ)))  E_j(σ+j),
E_j(τ) = Σ_{k,m≥1} (k − m)^{2j} / (k² + m²)^τ.
```

This is derived from the Mellin identity and the AM–GM identity
`k² + m² ≥ 2km`, not from a coefficientwise comparison of Dirichlet series.
The `j = 0` term is the AM–GM/lattice-sum bound; each higher term improves it;
the numerical ratios to `ζ(σ)^2` converge upward to `1`.  At `σ = 2` the `J = 0`
bound is `1.6971` (ratio `0.627`) and `J = 4` raises it to `2.3429`
(ratio `0.866`).  The derivation, numerical table, novelty caveat and Lean
targets are in [`INEQUALITY.md`](INEQUALITY.md).

## 6. Computations

[`python/programme.py`](python/programme.py) checks the three exact identities
numerically, independently of the Lean layer:

| item | check | test |
|---|---|---|
| G2 | `ζ(2) = 1 + Σ_{a∈A, a≤N} 1/(a²−1)`, tail-consistent tolerance | `test_additive_identity_at_two` |
| G2 | the same at `2.5 + 0.4i` | `test_additive_identity_complex` |
| C1 | the all-bases sum is `7/4`, not `ζ(2)` | `test_all_bases_are_not_zeta` |
| C5 | perfect powers are sparse; non-perfect-powers have density `1` | `test_perfect_power_count` |
| G3 | `Σ_k q^k/(1−q^k) = Σ_n d(n)q^n` | `test_lambert_identity` |
| G4 | `log ζ(s) = Σ_p Σ_m p^{−ms}/m` | `test_log_identity` |
| G8 | the lattice lower bound and its ratios to `ζ(σ)^2` (J = 0,1,2) | `test_lattice_lower_bound_valid` |

Ten pytest tests pass.

## 6a. RH-relevance audit

The half-plane inequality is unconditional and has no zero content.  A separate
audit, [`RH-AUDIT.md`](RH-AUDIT.md), works out the precise obstruction: the
quadrant lattice sum `E_0(s)` has a continuation relation (★) from the Epstein
functional equation, the difference `D(s) = ζ(s)^2 − 2^s E_0(s)` is non-negative
only for real `σ > 1`, and at a nontrivial zero `ρ` one has
`D(ρ) = −2^ρ E_0(ρ)`.  The half-plane inequality controls neither `E_0(ρ)` nor
the sign of the continued `D` on the line, so it is not a zero-exclusion
mechanism.  The audit records this as a **no-go** for this route, not as RH
progress.

## 7. The next phase: what would count as a new inequality

The acceptance bar for a headline statement:

1. **Proved unconditionally.**  An unconditional proof is the strongest
   non-equivalence guarantee; it cannot be RH-equivalent unless it proves RH.
2. **Content beyond rearrangement.**  Expanding and regrouping must not give the
   Dirichlet series back.
3. **No zero-location encoding.**  No quantification over zeros, zero-free
   regions, or zero-density without a separate implication audit.
4. **Formalised or formalisable.**  At least the statement and its proof sketch
   must be ready for Lean, with no `sorry`.

The Mellin/Lambert transform is now formalised (`lambert_mellin`).  The two
remaining directions are:

- **A new inequality from the Mellin representation.**  Use the positive
  coefficients `d(n) ≥ 0` in
  `Γ(s)ζ(s)^2 = ∫ t^{s−1}L(e^{−t})dt` to derive an unconditional bound that is
  not already a Dirichlet-series comparison.  This is the main open target.
- **Additive base decomposition.**  Formalise the unique-base theorem and mine
  the identity for a sharpened arithmetic statement about the non-perfect-power
  counting function.  The identity itself is a rearrangement, so the target is a
  consequence, not the identity.

If neither yields content beyond the known, the documented negative result — the
catalogue above — is the honest deliverable.

## 8. Reproduce

```bash
cd topics/geometric-zeta/lean && ./check.sh Topic.lean
cd topics/geometric-zeta && python3 -m pytest -q tests
```

[Topic index](../index.html) · [Ledger](../STATUS.md) · [Zeta from theta](../zeta-from-theta/README.md)
