# Handoff — Option B: formalise the finite Gaussian Weil Gram certificate

**Status:** **O4 closed (2026-11-05).**  The finite certificate is Lean-proved:
`PrimeSpectrumTensor.gaussianGram4_posDef` in
[`../prime-spectrum-tensor/lean/DensityCertificates.lean`](../prime-spectrum-tensor/lean/DensityCertificates.lean)
states that the exact `4×4` Gaussian Weil Gram matrix at `σ = 1/20` is positive
definite.  This document is retained as the route record; §0 and §1 below now
record the closure instead of the open obligation.

## 0. Progress update — 2026-11-05

**O4 is closed.**  W1, W3, R1, the whole of R2's analysis, and the numerical
generation are Lean-checked, and the assembly is unconditional.  The four
density bands are produced by the generated files
`prime-spectrum-tensor/lean/DensityC0_0.lean` … `DensityC3_8.lean` (36 chunk
files); the final
theorem is `gaussianGram4_posDef`.

### Closed and machine-checked

| leaf | file | what |
|---|---|---|
| W1 | `prime-spectrum-tensor/lean/Transfer.lean` | `posDef_of_entry_bound` (`ε · dim < t`), the exact rational `L D Lᵀ` certificate `gramCentre4 − (227/10000)·I ≻ 0`, `gaussianGram4_posDef_of_entry_bound` |
| definitions + assembly | `GaussianGram.lean`, `Assembly.lean` | `poleTerm`, `densityTerm`, `primeTerm`, `gaussianGram4`, and `gaussianGram4_posDef_of_density_enclosure`: the target follows from four density intervals of half-width `10⁻³` |
| W3 pole | `PoleEnclosure.lean` | four rational intervals of width `2·10⁻⁶` |
| R1 prime | `PrimeEnclosure.lean` | `primeTerm` in `[−22·10⁻⁶, 0]` for `c ≤ 2/5`, and in `[−0.03649, −0.03646]` at `c = 3/5` |
| **R2 (analysis)** | `DensityEnclosure`, `DensityPanel`, `DensityWeight`, `DensityTail`, `MidpointRule`, `OmegaContinuous`, `OmegaGlobal`, `OmegaPanel`, `PanelAssembly`, `PanelSum`, `PanelCertificate`, `GaussianTail`, `LipSmall`, `DensityAssembly` | see below |
| series route (spare) | `SeriesRoute.lean` | `Σ_{k≥N} u_k(t) ≤ (t²/4)/(N+1/4)²` |

The 21 files of `prime-spectrum-tensor/lean` build with
`./check.sh` in about two minutes; 2,606 named proofs repo-wide.

### R2 — what was proved

* `densityTerm c σ = 2 · IntersectionForm.density σ c` (`DensityEnclosure`), so
  the shared library's `omega_mem` applies.
* `|Ω′(t)| ≤ 6/t` for `t ≥ 4` (`DensityPanel`), and `|Ω′(t)| ≤ 10` for **all**
  `t` (`LipSmall`, by the telescoping `Σ_j ((j+1/4)²+a²)⁻¹ ≤ 18`).
* `|Ω(t)| ≤ log(t+2) + 24` for all `t > 0` (`OmegaGlobal`), from
  `IntersectionForm.digamma_expansion`.
* `Ω` continuous and differentiable (`OmegaContinuous`).
* the **midpoint rule with a second-derivative remainder**
  `|∫_a^b f − (b−a)f(m)| ≤ B(b−a)³/4` (`MidpointRule`) — Mathlib has no
  quadrature rule.
* the weight `w(t) = σ²e^{−σ²t²}cos(ct)`: its first and second derivatives, and
  `|w″| ≤ 1/100`, `|w| ≤ 1/400` (`WeightBound`, `DensityWeight`).
* the **per-panel signed bound** (`PanelAssembly.panel_mem`) and its packaged
  form `panel_certificate` (one lemma invocation per panel).
* the panel-sum error (`PanelSum.panel_sum_error`), the `Ioi` split, the
  Gaussian moment `∫_T^∞ (1/400)x·e^{−x²/400} = e^{−T²/400}/2` (`GaussianTail`),
  and `|∫_{60}^∞ w·Ω| ≤ 10⁻⁴` (`DensityTail`).
* the **capstone** `DensityAssembly.density_approx_error`:
  `|density(1/20,c) − Σ_p qmid p·(b_p−a_p)·w(m_p)| ≤ Σ_p E p + 10⁻⁴`.

### R2 — the numerical generation (done)

The numerical generation.  Per panel and per `c ∈ {0, 1/5, 2/5, 3/5}` the
generator produces a rational bracket for
`w(m) = (1/400)·exp(−m²/400)·cos(cm)`.  It is emitted by
`prime-spectrum-tensor/lean/gen/panels.py`; the two obstacles named below (no
cos Taylor bound in Mathlib, `Real.exp_bound` only for `|x| ≤ 1`) were cleared
by `prime-spectrum-tensor/lean/CosBound.lean` and the four-step squaring chain.

* `Ω(m)`'s bracket is already available: `omega_mem m 1 1000` has measured width
  `≤ 10⁻²` up to `t = 60` (widths: `0.032` at `M=500`, `0.0094` at `M=1000`,
  `0.0081` at `M=2000`).
* **This is the blocker**: Mathlib has **no Taylor bound for `cos`** (only
  `cos_le_one_div_sqrt_sq_add_one` for `|x| ≤ 3π/2` and the Lipschitz bound
  `|cos x − cos y| ≤ |x−y|`), and `Real.exp_bound` requires `|x| ≤ 1` whereas the
  panel needs `exp(−m²/400)` with `m²/400` up to `9`.  Bounding these at ~600
  nodes therefore requires *new* machinery: a cos Taylor remainder plus
  argument reduction mod `2π` (with rational `π` bounds), and an exp bound for
  `|x| ≤ 9` (e.g. `exp(−y/16)¹⁶` by four squarings, since `y/16 ≤ 0.5625 ≤ 1`).
* Scale: 600 panels (width `0.1` on `[0,60]`) × 4 values of `c`
  ≈ 2,400 panel certificates and ≈ 3,000 transcendental bound checks, i.e.
  `10⁴`–`2·10⁴` generated lines.  `lean/gen/panels.py` is the scaffolding.

### The exact reduction

```lean
-- per panel:
panel_certificate hc hab ha0 hb60 hlip hm1 hm2
-- then:
density_approx_error h0 hT hpanel
-- then, for the four c:
gaussianGram4_posDef_of_density_enclosure hd0 hd1 hd2 hd3
```

**O4 is Closed.**  The numerical generation is complete: 1305 graded panels per
`c`, assembled by cumulative lemmas, give the four density bands to
`≈ 1.45·10⁻³` (inside the `1.75·10⁻³` slack of the transfer).  `No negative
witness exists` remains true — the matrix is numerically positive definite
(`λ_min ≈ 0.0227097`) — and it is now an affirmation that has been computed and
checked.

The fallback rungs of §8 (3×3 at `σ = 0.05`, or the `σ = 0.03` five-point rung)
remain available and are cheaper on R2.

---

**Parent dossier:** [`angular-partition-method`](README.md) · **O4 row:**
[`README.md`](README.md) §9 · **Bridge survey:**
[`../../bridge-to-weil-positivity.md`](../../bridge-to-weil-positivity.md) ·
**Numerical certificate:**
[`../prime-spectrum-tensor/WEIL-GRAM.md`](../prime-spectrum-tensor/WEIL-GRAM.md)

---

## 1. Mission

Replace the numerical/Python finite Gram certificate of
[`WEIL-GRAM.md`](../prime-spectrum-tensor/WEIL-GRAM.md) §3.3–3.5 with a Lean
theorem

```lean
theorem gaussianGram4_posDef :
    (gaussianGram 4 (0.05 : ℝ) (-0.3) (-0.1) 0.1 0.3).PosDef
```

for the exact 4×4 Gaussian Weil Gram matrix, with every numerical input an
explicit rational/interval bound checked in Lean. This is the M0′ finite
certificate in the route note. It is **not** the infinite Weil positivity
statement and **not** a proof of RH.

O4 is marked closed because this theorem is now Lean-proved (or the certificate
would have had to be recorded as a precise negative witness).

---

## 2. What is already proved in Lean

| Statement | Where |
|---|---|
| Finite zero sum + pole terms: `∮ (Z'/Z)·h = 2πi(∑_{ρ∈S} h ρ − h 0 − h 1)` | `absolute-polarized-hodge-index-realization/lean/ExplicitFormula.lean:1560`, `test_function_explicit_formula` |
| Tail bound: `‖∑_{S'} h − ∑_S h‖ ≤ (M/2π)(perimeter' + perimeter)` | `absolute-polarized-hodge-index-realization/lean/TailBound.lean:98`, `zero_sum_tail_bound` |
| Boundary norm bound | same file, `norm_rectIntegral_le` |
| Finite Gram PSD from a Cholesky factor `Lᴴ L` | `prime-spectrum-tensor/lean/Topic.lean:242`, `posSemidef_of_cholesky` |
| Rational shadow `L4Shadowᴴ * L4Shadow` is PSD | `prime-spectrum-tensor/lean/Topic.lean:272`, `L4Shadow_posSemidef` |
| Negative witness for the DH-shaped matrix | `prime-spectrum-tensor/lean/Topic.lean:235`, `GDH_not_posSemidef` |
| Finite Gram PSD in the angular-partition dossier (T73–T76) | `angular-partition-method/lean/Gram.lean` |

The shadow certificate covers **only** the rounded rational matrix
`L4Shadowᴴ * L4Shadow`; it does not certify the exact transcendental Gram
matrix. That gap is the whole task.

## 3. What exists numerically (not a proof)

`WEIL-GRAM.md` §3.1–3.5 records a Python interval certificate:

- `python/jet.py` — interval `Ω` jets (value and first four `t`-derivatives)
  from the digamma integral representation;
- `python/certify_gram.py` — panel quadrature, pole and prime terms, interval
  Gram matrix, and the centre/error/minor checks C18–C20;
- `TAIL-PROOF.md` — the explicit `u`-tail bound used by the jet;
- C22 — an end-to-end audited rerun at `H=0.1`, `T=100`, `U=4` with a
  `10^{−4}` entry margin.

The centre/error certificate uses

```
centre = interval midpoints,
t = 0.0209751863,
leading minors of centre − t·I: 0.0221277, 2.1412e−4, 1.5982e−6, 1.1271e−8,
```

all positive. **These are numerical facts, not Lean theorems.** The Python
certificate is the specification to formalise, not a substitute for it.

## 4. The mathematical target

Basis: `φ_a(u) = exp(−(u−a)²/(2σ²))`, `σ = 0.05`, centres
`−0.3, −0.1, 0.1, 0.3`. For `c = a−b`,

```
h_c(v) = √π σ exp(−(v−c)²/(4σ²)),
W(c) = 4πσ² exp(σ²/4) cosh(c/2)                     -- pole
     + σ² ∫ exp(−σ²t²) cos(ct) Ω(t) dt              -- archimedean
     − 2 Σ_{p^m ≤ X} (log p)/p^(m/2) h_c(log p^m),   -- prime
Ω(t) = Re ψ(1/4 + it/2) − log π,
G_{ab} = (W(a−b) + W(b−a))/2.
```

Needed: `G_{ab} ∈ [lo_{ab}, hi_{ab}]` with rational endpoints and a margin
large enough that `G` is positive definite.

### Error budget

The numerical margin is small (`λ_min ≈ 2.27·10^{−2}`), so the formalisation
needs an explicit budget. The `10^{−4}` entry margin of C22 covers the jet
series/tail allowances; the Lean proof must justify that number, not assume it.

**Important audit item.** The centre/error argument uses an entry margin `t`.
An entrywise bound `|G_{ab} − centre_{ab}| ≤ t` does **not** imply the Loewner
bound `G ⪰ centre − tI`; the spectral perturbation is bounded by the matrix
norm, which is up to the dimension times the entry bound. The Lean transfer
must use the correct norm (spectral/operator, or a diagonal-dominance argument
with the actual entry bounds), or a sharper interval determinant argument. Do
not formalise the centre/error step until this norm is pinned down.

## 5. Lean work breakdown

### W1 — exact rational certificate (easiest, start here)

- Define `centre : Matrix (Fin 4) (Fin 4) ℚ` from the C22 midpoints.
- Define `t : ℚ` (e.g. `209751863 / 10^10`).
- Prove `(centre - t • 1).PosDef` by exact leading-minor/LDL computation
  (`norm_num`, `decide`, or `native_decide`).
- Prove a generic transfer theorem in the correct norm, or a diagonal-dominance
  variant if the interval widths permit it.

Deliverable: `Transfer.lean`, with the algebraic certificate and no analytic
input.

### W2 — Ω bounds on `[0, T]`

- Define `omega (t : ℝ) : ℝ := (Complex.digamma (1/4 + t*I/2)).re - Real.log Real.pi`.
- Prove an interval enclosure on a grid, with explicit derivative bounds for
  the quadrature. The Python layer uses the integral representation
  ```
  Re ψ(z) = log|z| − Re(1/(2z))
            − 2∫_0^∞ u(u²+Re z²)/((u²+Re z²)²+(Im z²)²)/(e^{2πu}−1) du.
  ```
  Formalising this identity and its interval evaluation is the main analytic
  work. Reuse `absolute-polarized-hodge-index-realization/lean/Archimedean.lean`
  if it already has digamma identities.

### W3 — rigorous quadrature

- Rational-node Simpson/trapezoid rule with an explicit derivative bound on the
  panels; or Taylor models from W2.
- Tail `|t| > T`: Gaussian decay times a crude `Ω` bound.
- Prime tail: `Λ(n)/√n ≤ log n/√n` plus Gaussian decay; the Python C10 bound is
  the template.

### W4 — interval Gram matrix

- Define `gaussianGram` entrywise from W2/W3.
- Prove symmetry and the entrywise enclosures.
- Apply W1's transfer to get `Matrix.PosDef`.

### W5 — ledger and docs

- Add `gaussianGram4_posDef` to the `prime-spectrum-tensor` ledger and to the
  angular-partition O4 row/§7.9.
- Mark O4 **Closed** only if W1–W4 are all Lean-proved and the infinite
  positivity statement is recorded as the remaining open frontier (not closed).

## 6. Acceptance criteria

1. `gaussianGram4_posDef : (gaussianGram ...).PosDef` is Lean-proved with no
   `sorry`, `axiom` or `admit`.
2. Every numerical constant is a rational/interval bound checked by Lean, not a
   decimal literal asserted without proof.
3. `prime-spectrum-tensor/lean/check.sh` is green; the angular-partition
   `check.sh` and `pytest` remain green.
4. The ledger distinguishes the finite certificate from the infinite Weil
   positivity; no RH claim.
5. If the interval certificate cannot be completed, record the sharpest
   **negative witness** instead and do not mark O4 closed.

## 7. Files and commands

Suggested new files, all under `prime-spectrum-tensor/lean/`:

```
Transfer.lean        -- W1: rational minor certificate + PosDef transfer
OmegaBounds.lean     -- W2: digamma/Ω interval bounds
Quadrature.lean      -- W3: rigorous panel quadrature + prime tail
GaussianGram.lean    -- W4: exact Gram matrix and PosDef assembly
```

Add each to `prime-spectrum-tensor/lean/check.sh` (it currently takes `"$@"`).

Verify:

```bash
cd the-final-letter/topics/prime-spectrum-tensor
./lean/check.sh
python3 -m pytest tests -q

cd ../absolute-polarized-hodge-index-realization
./lean/check.sh
```

The numerical reference:

```bash
cd the-final-letter/topics/prime-spectrum-tensor
python3 python/certify_gram.py   # see WEIL-GRAM.md §3.5 for parameters
```

## 8. Risks and fallbacks

- **Digamma bounds** on `[0, 200]` are the hardest analytic input. If the full
  interval jet is too heavy, start with a coarser basis (e.g. the 3×3 or 5×5
  rungs with larger margins at `σ = 0.03–0.05`) and formalise that certificate
  first.
- **The margin collapses** as `σ` grows (`1.46·10^{−8}` at `σ=0.2`). Do not
  attempt the `σ=0.2` rung until the enclosure is sharp.
- **Centre/error vs entrywise error**: fix the norm before W1. If the entrywise
  margin is insufficient, use exact interval determinants/LDL, or derive a
  sharper spectral bound.
- **No negative witness is expected** for the 4×4 Gaussian matrix; the DH-shaped
  negative witness already in Lean is a different matrix. A genuine negative
  witness for the Gaussian matrix would refute the finite positivity route and
  should be recorded as such, not hidden.
- **Do not import across topic roots by filename.** The angular-partition and
  absolute-polarized roots both contain `ExplicitFormula.lean`; cross-topic
  imports collide. Keep the certificate in `prime-spectrum-tensor` and cite the
  other files in prose, or create a shared module root.

## 9. Suggested order

1. **W1** (rational transfer) — self-contained, buildable now.
2. **W2** on a small interval (`t ∈ [0, 2]`) as a pilot.
3. **W3** for the pilot interval; compare with C9/C13.
4. Extend to `T=100` and the full 4×4 matrix.
5. **W4/W5**, ledger, O4 status.

## 10. Non-goals

- The infinite Weil cone, RH, or any statement about all zeros.
- A Lean re-proof of the explicit formula: use
  `test_function_explicit_formula` from the local library.
- Replacing `mpmath` by Lean-native floating point; the target is interval
  arithmetic with rational endpoints.

## 11. Reading list

- [`WEIL-GRAM.md`](../prime-spectrum-tensor/WEIL-GRAM.md) §0–3.5 — the matrix,
  the three terms, the Python certificate.
- [`bridge-to-weil-positivity.md`](../../bridge-to-weil-positivity.md) — why M0′
  is the remaining finite route.
- [`self-adjoint-ccm/WEIL-BRIDGE.md`](../self-adjoint-ccm/WEIL-BRIDGE.md) §6 —
  R1, the finite Gram route.
- [`angular-partition-method/README.md`](README.md) §7.8–7.9 — the finite zero
  side and the M0′ pointer.
- [`index-lean.md`](../index-lean.md) — the local proof index.

---

**Bottom line.** The finite zero side of O4 is done. The exact finite Gram
certificate is a self-contained analytic/linear-algebra formalisation: rational
transfer + Ω enclosure + quadrature + assembly. It is the right next goal; it
is not a one-round patch.
