# Handoff — Option B: formalise the finite Gaussian Weil Gram certificate

**Status:** scoped handoff, no new theorem claimed. This document is for the
next agent/session that picks up O4 after the finite zero side was completed
and the exact finite Gram certificate was left open.

## 0. Progress update — 2026-11-04

**W1 is closed and Lean-checked.**  The operator-norm audit item of §4 was the
blocking prerequisite, and it is now a theorem:

- `posDef_of_entry_bound` — [`../../prime-spectrum-tensor/lean/Transfer.lean`](../../prime-spectrum-tensor/lean/Transfer.lean):
  if `(C − t·I).PosDef`, `G` is symmetric, every entry satisfies
  `|G i j − C i j| ≤ ε`, and `ε · dim < t`, then `G.PosDef`.  The dimension
  factor is stated explicitly, as §4 required.
- `gramCentre4_sub_posDef` (same file) — the exact rational `L D Lᵀ`
  certificate `(gramCentre4 − (227/10000)·I).PosDef`, with every scalar a
  rational literal and every entry identity checked by `norm_num`.
- `GaussianGram.lean` — the exact definitions (`omega`, `poleTerm`,
  `densityTerm`, `primeTerm`, `gaussianGram4`) and the assembly
  `gaussianGram4_posDef_of_enclosure`, which reduces the target theorem to the
  single entrywise enclosure `∀ i j, |gaussianGram4 (1/20) i j − gramCentre4 i j| ≤ ε`
  with `4ε < 0.0227`, i.e. `ε < 0.005675`.

**The route for W2 has changed, and it matters.**  Formalising the
differentiated Binet formula is not the cheapest path: `Ω` is better reached
through Mathlib's Euler limit for `Γ`, which gives

`Ω(t) = ψ(1/4) − log π + Σ_{k≥0} [1/(k+1/4) − (k+1/4)/((k+1/4)² + t²/4)]`

with `ψ(1/4) = −γ − 3 log 2 − π/2` in closed form and truncation error
`≤ t²/(8N²)` — an entry error of only `2.2/N²`.  Two blockers remain, both
recorded with their analysis in
[`../../prime-spectrum-tensor/OMEGA-ROUTE.md`](../../prime-spectrum-tensor/OMEGA-ROUTE.md):

* **B1** — differentiating the Euler limit: a locally uniform version of
  `Complex.GammaSeq_tendsto_Gamma`, or the integration route that avoids
  `UniformLimitsDeriv`.  This is the only analytic gap left in W2.
* **B2** — a verified interval quadrature of a ~100-term rational integrand
  (`exp` and `cos` need rational Taylor models; Lean has no such library).

**O4 stays Partial.**  §5 W1 is done; W2–W5 are open.  The fallback rungs of
§8 (3×3 at `σ = 0.05`, or the `σ = 0.03` five-point rung) remain available and
are cheaper on both B1 and B2.

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

O4 can be marked closed only when this theorem (or a precise negative witness)
is Lean-proved. Until then O4 stays **Partial**.

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
