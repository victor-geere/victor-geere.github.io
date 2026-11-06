# Handoff — M0′ at 5×5: the next finite Gaussian Weil–Gram certificate

**Status:** **M0′ at 5×5 closed (2026-11-05).**  The theorem

```lean
theorem gaussianGram5_posDef : (gaussianGram5 (1/20)).PosDef
```

is Lean-proved in [`DensityCertificates5.lean`](lean/DensityCertificates5.lean), with
no `sorry`, `axiom` or `admit`.  This document is retained as the route record;
§0.1 below records the closure, including the one place where the scoping plan
had to change (the second-derivative constant at `c = 4/5`).

**Original scope (kept for the record).**  This document was written to scope
the extension of the closed `4×4` certificate
([`DensityCertificates.lean`](lean/DensityCertificates.lean),
[`HANDOFF-O4.md`](../angular-partition-method/HANDOFF-O4.md)) to the `5×5`
Gaussian basis.  It records what is reused, what is new, the measured numerics,
and the Lean work that was required.

**One correction to the brief.**  With the stated centres `−0.4, −0.2, 0, 0.2,
0.4` only **one** separation is new: `c = 4/5`.  The separations `0, 1/5, 2/5,
3/5` are exactly the four already certified for the `4×4` basis
(`±0.3, ±0.1`); `c = 0.4` and `c = 0.6` are `2/5` and `3/5`.  See §2.  So the
"three generator runs" of the brief reduce to one; the real work is the prime
enclosure at `4/5` and the `5×5` transfer certificate.

---

## 0. Where the programme stands

The `4×4` certificate is closed and axiom-clean:

```lean
theorem gaussianGram4_posDef : (gaussianGram4 (1/20)).PosDef
```

It is assembled in [`DensityCertificates.lean`](lean/DensityCertificates.lean)
from four generated density bands through the loose assembly of
[`Assembly.lean`](lean/Assembly.lean).  The
machinery that can be reused *unchanged*:

| Piece | Where | Reuse |
|---|---|---|
| entrywise-to-`PosDef` transfer, **any dimension** | `Transfer.lean`, `posDef_of_entry_bound` | general in `n`; no change |
| exact rational `LDLᵀ` ⇒ `PosDef` | `Transfer.lean`, `ldl_posDef_rat` | general in `n`; no change |
| Gram entry split `pole + density + prime` | `Assembly.lean`, `gaussianGram4_apply` | copy to `gaussianGram5_apply` |
| density generator (any `c`, chunked) | [`gen/panels.py`](lean/gen/panels.py), `emit_all.py`, `build_chunks.sh` | one new `c` |
| density assembly (`density ≈ Σ …`) | [`DensityC{0..3}_{0..8}`](lean/) | unchanged |
| `densityTerm = 2·IntersectionForm.density` | `DensityEnclosure.lean` | unchanged |
| pole enclosure at `c ≤ 3/5` | `PoleEnclosure.lean` | new `c = 4/5` |
| prime enclosure at `c ≤ 3/5` | `PrimeEnclosure.lean` | **new proof** for `4/5` |

The computed `5×5` matrix (see §3) has smallest eigenvalue
**`0.0214238`**, versus `0.0227097` for the `4×4`: adding the fifth centre at
spacing `0.2` costs only `1.3·10⁻³` of margin.  The collapse recorded in
`HANDOFF-O4.md` §8 is driven by **`σ`**, not by the basis size: at `σ = 0.2`
the same ladder has `λ_min = 1.46·10⁻⁸`.  The `σ = 1/20` rung is the sweet
spot; do not extrapolate the comfortable margin to larger `σ`.

### 0.1 Closure record (2026-11-05)

Everything below was carried out, with one correction to the plan.

| Work item | Result |
|---|---|
| density at `c = 4/5` | `DensityC4_0.lean` … `DensityC4_8.lean`; band `±1.5862·10⁻³` on `density`, i.e. `±3.172·10⁻³` on `densityTerm` |
| pole at `c = 4/5` | `cosh_04_mem`, `poleTerm_mem_c4` (band `[0.033982, 0.033985]`) |
| prime at `c = 4/5` | `primeTerm_mem_four_fifths` (band `[−0.02811, −0.027726]`) |
| transfer | `GaussianGram5.lean`: `gramCentre5 − (1/50)·I = L5·D5·L5ᵀ`, five positive pivots |
| assembly | `DensityCertificates5.lean`: `gaussianGram5_posDef` with `ε = 0.0036`, `5ε = 0.018 < 1/50` |

**The correction.**  The plan in §5.1 assumed that `panel_certificate_decay`
could be reused unchanged at `c = 4/5`.  Its hypothesis is `|c| ≤ 3/5`, and the
underlying second-derivative bound `|w″| ≤ 1/400` is proved by a triangle
inequality that at `c = 4/5` gives only

```
|w″| ≤ (1/400)·((1/200 + 9/100 + 16/25) + 2·(60/200)·(4/5)) = 0.0030375.
```

So the file adds the parallel lemmas `abs_deriv2_weight_le_four_fifths`
(bound `1/200`), `weight_midpoint_rule_four_fifths`,
`panel_certificate_four_fifths` and `panel_certificate_decay_four_fifths`, and
the generator takes `--wden 200` for this one `c`.  The larger constant costs
about `1.3·10⁻⁴` of total panel error and still leaves ample budget.  All other
`4×4` files are untouched.

**Axiom audit.**  `#print axioms PrimeSpectrumTensor.gaussianGram5_posDef`
gives `[propext, Classical.choice, Quot.sound]`.

---

## 1. The target

Basis: `φ_a(u) = exp(−(u−a)²/(2σ²))`, `σ = 1/20`, centres

```lean
def centre5 : Fin 5 → ℝ := ![-2/5, -1/5, 0, 1/5, 2/5]
def gaussianGram5 (σ : ℝ) : Matrix (Fin 5) (Fin 5) ℝ :=
  Matrix.of fun i j => gaussianGramEntry (centre5 i) (centre5 j) σ
```

Deliverable:

```lean
theorem gaussianGram5_posDef : (gaussianGram5 (1/20)).PosDef
```

reduced, exactly as in `4×4`, to one entrywise enclosure:

```lean
theorem gaussianGram5_posDef_of_entry_bound {G : Matrix (Fin 5) (Fin 5) ℝ} {ε : ℝ}
    (hGsym : ∀ i j, G i j = G j i)
    (hε : ∀ i j, |G i j - gramCentre5 i j| ≤ ε)
    (hε0 : 0 ≤ ε)
    (hdim : ε * 5 < gramMargin5) :
    G.PosDef
```

with `gramMargin5 := 1/50` and `gramCentre5` the rational Toeplitz matrix of §4.
This is *not* the infinite Weil cone and *not* a proof of RH.

---

## 2. The separation set (correction of the brief)

`W(c) = pole(c) + density(c) + prime(c)` is **not** even in `c` (only pole and
density are); the Gram entry is the symmetrisation
`G_ab = (W(a−b) + W(b−a))/2`.  The distinct separations are:

| `c` | status | density certificate | pole | prime |
|---:|---|---|---|---|
| `0` | exists | `density_mem_c0` | `poleTerm_mem_c0` | `primeTerm_mem_small` |
| `1/5` | exists | `density_mem_c1` | `poleTerm_mem_c1` | `primeTerm_mem_small` |
| `2/5` | exists | `density_mem_c2` | `poleTerm_mem_c2` | `primeTerm_mem_small` |
| `3/5` | exists | `density_mem_c3` | `poleTerm_mem_c3` | `primeTerm_mem_three_fifths` |
| **`4/5`** | **new** | **`density_mem_c4`** | **`poleTerm_mem_c4`** | **`primeTerm_mem_four_fifths`** |

`primeTerm_mem_small` has hypothesis `c ≤ 2/5` only, so it also covers
`c = −4/5` (where the true value is `< 10⁻⁹⁷`); that is the cheap upper half
of the `±4/5` pair.  Only `+4/5` needs the new prime proof.

If a *different* ladder is intended (for example centres spaced `0.4`:
`−0.8, −0.4, 0, 0.4, 0.8`), the new set becomes `c = 4/5, 6/5, 8/5` and the
transfer budget must be re-measured — do not reuse the numbers below blindly.

---

## 3. Measured numerics (30 digits, `σ = 1/20`)

Component values (`W(+c)` and `W(−c)` from
[`python/programme.py`](python/programme.py), `weil_gaussian_W`):

| `c` | pole | density | prime | `W(c)` | `W(−c)` | `g = (W(c)+W(−c))/2` |
|---:|---:|---:|---:|---:|---:|---:|
| 0 | 0.031435568 | 0.011700391 | −1.2e−22 | 0.043135958 | 0.043135958 | 0.043135958 |
| 1/5 | 0.031592876 | −0.048082135 | −2.4e−12 | −0.016489259 | −0.016489259 | −0.016489259 |
| 2/5 | 0.032066377 | −0.024035199 | −1.61e−5 | 0.008015080 | 0.008031178 | 0.008023129 |
| 3/5 | 0.032860810 | −0.016840432 | −3.65e−2 | −0.020461254 | 0.016020377 | −0.002220438 |
| **4/5** | **0.033984124** | **−0.013270045** | **−0.027750103** | **−0.007036024** | **0.020714079** | **0.006839028** |

Eigenvalues of the exact `5×5` Gram matrix (centres `−0.4 … 0.4`):

```
0.021423782, 0.022829404, 0.036997561, 0.049985978, 0.084443075
```

The `4×4` eigenvalues for comparison: `0.022709743, 0.026961276, 0.044852476,
0.078020338`.  These extend the rung table of
[`WEIL-GRAM.md`](WEIL-GRAM.md) §3 (add the `5×5` row).

### Prime term at `c = 4/5`

```
n = 2 :  −2·(log 2/√2)·(√π/20)·exp(−100(log 2 − 4/5)²) = −0.027735027
n ≥ 3 :  total = −1.5076·10⁻⁵   (n = 3 dominates; n = 4 is −7.2·10⁻¹⁷)
```

So `primeTerm (4/5) (1/20) ≈ −0.0277501`, with the `n ≥ 3` tail bounded below
by `−6·10⁻⁵` by any of the recipes in §5.3.

### Transfer budget

Choose `gramMargin5 = 1/50 = 0.02`; then `ε·5 < 0.02` allows
`ε < 4·10⁻³`.  The current density certificates give a `densityTerm`
half-width `2K ≈ 2.9·10⁻³` (`K = 1.45·10⁻³` per density), and the pole/prime
half-widths are `≤ 7·10⁻⁵`, so

```
ε ≈ 2.98·10⁻³,   5ε = 1.49·10⁻² < 2·10⁻².
```

No re-partitioning is needed.  (If a failure is ever found here, the fallback
is a finer panel width: `K ∝ h`, so `h₁ = 1/30` gives `K ≈ 10⁻³`.)

---

## 4. The rational centre and its exact certificate

`gramCentre5` is the symmetric Toeplitz matrix with first row

```lean
def gramCentre5 : Matrix (Fin 5) (Fin 5) ℝ :=
  !![ 4313596/100000000, -1648926/100000000,  802313/100000000,
      -222044/100000000,  683903/100000000;
      -1648926/100000000,  4313596/100000000, -1648926/100000000,
       802313/100000000, -222044/100000000;
       802313/100000000, -1648926/100000000,  4313596/100000000,
      -1648926/100000000,  802313/100000000;
      -222044/100000000,  802313/100000000, -1648926/100000000,
       4313596/100000000, -1648926/100000000;
       683903/100000000, -222044/100000000,  802313/100000000,
      -1648926/100000000,  4313596/100000000]
```

(the `g` row rounded to eight decimals; the rounding moves the eigenvalues by
`< 3·10⁻⁸`).  With `gramMargin5 = 1/50` the matrix `gramCentre5 − gramMargin5•1`
has the exact `L D Lᵀ` factorisation below; **all five pivots are positive**:

```lean
def L5 : Matrix (Fin 5) (Fin 5) ℝ :=
  !![1, 0, 0, 0, 0;
     -824463/1156798, 1, 0, 0, 0;
      802313/2313596, -1245996916029/1316884748870, 1, 0, 0;
     -55511/578399, 372523505701/658442374435,
       -1267547855216976959/1338271844921857398, 1, 0;
      683903/2313596, 306992663977/1316884748870,
       25592833894706703/31863615355282319,
       -2570352585012238190866716/2719988083579585055940089, 1]

def D5 : Matrix (Fin 5) (Fin 5) ℝ := diagonal
  ![ 578399/25000000,
     131688474887/11567980000000,
     669135922460928699/65844237443500000000,
     2719988083579585055940089/267654368984371479600000000,
     132318221028802992579779774327/27199880835795850559400890000000]
```

The pivots in decimal: `0.023136, 0.011384, 0.010162, 0.010162, 0.004865`.

Proof obligations, copied from `Transfer.lean` with `Fin 4 → Fin 5`:

| Lemma | Recipe |
|---|---|
| `gramCentre5_symm` | `fin_cases i <;> fin_cases j <;> norm_num [gramCentre5]` |
| `D5_eq_diagonal`, `D5_posDef` | as `D4_*` |
| `gramCentre5_factor` | `ext i j; fin_cases i <;> fin_cases j <;> simp [gramCentre5, gramMargin5, L5, D5, Matrix.mul_apply] <;> norm_num` — **no `Fin.sum_univ_five`**: use `Fin.sum_univ_succ` twice (or `fin_cases` on the sum index). |
| `L5_transpose_det` | the same unit-triangular proof as `L4_transpose_det` |
| `gramCentre5_sub_posDef` | `rw [gramCentre5_factor]; exact hD.conjTranspose_mul_mul_same …` as for `4×4` |
| `gaussianGram5_posDef_of_entry_bound` | three-line wrapper around `posDef_of_entry_bound` |

A Python snippet that regenerates `L5, D5` from the `g` row (exact
`fractions.Fraction`, no pivoting) is in §8.

---

## 5. Work packages

### 5.1 Density certificate at `c = 4/5` (mechanical, ~1 h wall clock)

The generator already accepts any `c`; `c = 4/5` changes only the cos argument:
`|c·m| ≤ 0.8 · 60 = 48`, so `cos_doublings` still returns `d = 6`
(`2⁵ < 48 ≤ 2⁶`) and the Taylor base has `|y| ≤ 1`, where the emitted
remainder bound `2.26·10⁻⁹ ≤ 10⁻⁸` holds.  **No code change is needed.**

Emit nine chunks (150 panels each) and build them, exactly as for the `4×4`:

```bash
cd lean/gen
python3 emit_all.py --size 150 --cc 4/5 --first-index 4   # needs the new flag, see §8
./build_chunks.sh 4                                        # resumable, ~25–40 min on two tracks
```

If `emit_all.py` is not extended, call `panels.py` directly with
`--start/--end/--import/--final --ns D4` (§8).

Expected output (sanity check): `density (1/20) (4/5) ≈ −0.0132700`, band
`K ≈ 1.45·10⁻³`, i.e. `LO ≈ −0.01472`, `HI ≈ −0.01182`.  The generated theorem:

```lean
theorem density_mem_c4 : IntersectionForm.density (1/20) (4/5) ∈ Set.Icc LO HI
```

Add `densityTerm_mem_c4` to `DensityCertificates.lean` (doubling the interval),
exactly as `densityTerm_mem_c0 … c3`.

### 5.2 Pole enclosure at `c = 4/5` (mechanical, ~30 min)

`poleTerm (4/5) (1/20) = (π/100)·exp(1/1600)·cosh(2/5) = 0.033984124`.

Add to `PoleEnclosure.lean`, copying `cosh_03_mem` and `poleTerm_mem_c3`:

```lean
theorem cosh_04_mem :
    (10810723 / 10000000 : ℝ) ≤ Real.cosh (2 / 5) ∧
      Real.cosh (2 / 5) ≤ 10810724 / 10000000 := by
  have hc := two_cosh_real (2 / 5)
  have h1 := Real.exp_bound (x := (2 / 5 : ℝ)) (by norm_num) (n := 8) (by norm_num)
  have h2 := Real.exp_bound (x := (-(2 / 5) : ℝ)) (by norm_num) (n := 8) (by norm_num)
  simp only [Finset.sum_range_succ, Finset.sum_range_zero, zero_add] at h1 h2
  norm_num at h1 h2
  rw [abs_le] at h1 h2
  constructor <;> linarith [h1.1, h1.2, h2.1, h2.2, hc]

theorem poleTerm_mem_c4 :
    (33983 / 1000000 : ℝ) ≤ poleTerm (4 / 5) (1 / 20) ∧
      poleTerm (4 / 5) (1 / 20) ≤ 33985 / 1000000 := by
  have hcosh : (10810723 / 10000000 : ℝ) ≤ Real.cosh ((4 / 5) / 2) ∧
      Real.cosh ((4 / 5) / 2) ≤ 10810724 / 10000000 := by
    rw [show (4 / 5 : ℝ) / 2 = 2 / 5 by norm_num]
    exact cosh_04_mem
  have h := poleTerm_between (4 / 5) hcosh (by norm_num)
  norm_num at h ⊢
  constructor <;> linarith [h.1, h.2]
```

(`cosh(2/5) = 1.08107237…`; verify the constants against
`Real.exp_bound` before committing.)

### 5.3 Prime enclosure at `c = 4/5` (the real work, ~half a day)

This is the only non-mechanical piece.  The existing domination

```
exp(−100(x−c)²) ≤ exp(−14x)      (x ≥ 1, c ≤ 3/5)
```

**fails** at `c = 4/5`, because at `x = log 3` the left side is `8.9·10⁻³`
while `exp(−14·log 3) = 1.6·10⁻⁷`.  The replacement that does work for all
`x ≥ log 3` is

```
exp(−100(x−4/5)²) ≤ exp(−8x),
```

which is the polynomial inequality `100x² − 168x + 64 ≥ 0`, i.e.
`25x² − 42x + 16 ≥ 0`, whose larger root is `1.0961 < log 3` (Mathlib:
`Real.log_three_gt_d9 : 1.0986122885 < log 3`).

Proof sketch (all available in Mathlib):

1. `exp_decay_le_four_fifths : exp(−100(x−4/5)²) ≤ exp(−8x)` for `x ≥ log 3`.
   From `Real.log_three_gt_d9` and `nlinarith` on `25x² − 42x + 16 ≥ 0`.
2. `exp(−8 log n) = (n⁸)⁻¹` (copy `exp_neg_log_pow` with exponent `8`).
3. `primeSummand (4/5) n ≤ (√π/20)·n⁻⁷` for `n ≥ 3`:
   `Λ(n)/√n ≤ log n ≤ n` (both already used in the file), times `n⁻⁸`.
4. Tail: `Σ_{n≥3} n⁻⁷ ≤ 1/3⁷ + ∫₃^∞ x⁻⁷ dx = 1/2187 + 1/(6·3⁶)`,
   times `√π/20 ≤ 8863/100000`, gives `< 7·10⁻⁵`.
5. Split `n = 2` exactly (`prime_sum_split`): the `n = 2` term is
   `−0.027735027`, evaluated with `log_two_mem`, `sqrt_two_mem`,
   `sqrt_pi_mem` as in `primeSummand_two`.

Target:

```lean
theorem primeTerm_mem_four_fifths :
    (-2782 / 100000 : ℝ) ≤ primeTerm (4 / 5) (1 / 20) ∧
      primeTerm (4 / 5) (1 / 20) ≤ -2773 / 100000
```

(the true value is `−0.0277501`; a `9·10⁻⁵`-wide interval is ample, since the
entry budget is `3·10⁻³`).

For the `−4/5` half reuse `primeTerm_mem_small (c := -(4/5)) (by norm_num)`.

### 5.4 The `5×5` transfer (`GaussianGram5.lean`, ~half a day)

Create `GaussianGram5.lean` (or extend `GaussianGram.lean` + `Transfer.lean`):

* `centre5`, `gaussianGram5`, `gaussianGramEntry`-based symmetry
  (`gaussianGram5_symm`);
* `gramCentre5`, `gramMargin5`, `L5`, `D5`, and the six lemmas of §4;
* `gaussianGram5_posDef_of_entry_bound`;
* `gaussianGram5_apply` (copy `gaussianGram4_apply` with `centre5`), used by
  the assembly.

### 5.5 Assembly (`DensityCertificates5.lean` or extend `DensityCertificates.lean`)

```lean
theorem gaussianGram5_posDef_of_density_enclosure_loose
    (hd0 : … densityTerm 0 …) (hd1 : … 1/5 …) (hd2 : … 2/5 …)
    (hd3 : … 3/5 …) (hd4 : -16443/1000000 ≤ densityTerm (4/5) (1/20) ∧
      densityTerm (4/5) (1/20) ≤ -10097/1000000) :
    (gaussianGram5 (1/20)).PosDef := by
  -- poleTerm_mem_c0 … c4, primeTerm_mem_small (c := 0,1/5,2/5,-1/5,-2/5,-4/5),
  -- primeTerm_mem_three_fifths, primeTerm_mem_four_fifths
  refine gaussianGram5_posDef_of_entry_bound (gaussianGram5_symm _) ?_ (by norm_num)
    (by norm_num [gramMargin5])
  intro i j
  rw [gaussianGram5_apply]
  fin_cases i <;> fin_cases j <;> simp only [centre5] <;>
    norm_num [gramCentre5] <;> … <;> rw [abs_le] <;> constructor <;> linarith […]
```

The `hd4` constants must be read off the generated `density_mem_c4` (as was
done for `c0 … c3` in `DensityCertificates.lean`), not hard-coded from this
document.  The values above are the ones actually generated:
`density ∈ [−0.008222, −0.005049]`, doubled to `densityTerm`.

Then:

```lean
theorem gaussianGram5_posDef : (gaussianGram5 (1/20)).PosDef :=
  gaussianGram5_posDef_of_density_enclosure_loose … (density_mem_c4 …) …
```

### 5.6 Documentation and ledger

* `WEIL-GRAM.md` §3: add the `5×5` rung row
  (`0.05 | ±0.4, ±0.2, 0 | 5 | 2.1424·10⁻² | −2.78·10⁻² at c=0.8`).
* `OMEGA-ROUTE.md`: record M0′ at `5×5` (generated files, bands, theorem).
* `prime-spectrum-tensor/README.md` ledger: one **Theorem** row
  (`gaussianGram5_posDef`) and one **Computation** row (the `5×5` eigenvalues).
* `lean/README.md`: new files and the axiom audit line.
* `STATUS.md`: bump the counts (`+1` theorem, `+1` computation, `+1` test).
* `HANDOFF-O4.md`: link this document from §9.

---

## 6. Acceptance criteria

The `5×5` rung counts as closed when:

1. `lean/check.sh` builds all files (including `DensityC4_*` and
   `GaussianGram5.lean`) with no `sorry`, `axiom` or `admit`;
2. `gaussianGram5_posDef : (gaussianGram5 (1/20)).PosDef` is axiom-clean
   (`#print axioms` → `propext`, `Classical.choice`, `Quot.sound`);
3. `python3 -m pytest tests -q` passes, with a computation test recording the
   `5×5` eigenvalues to the stated tolerance;
4. the ledger rows in README/index.html are updated (Theorem + Computation),
   and no source claim is upgraded;
5. a negative result, if one appears, is recorded as a refutation (with the
   witness) rather than worked around.

---

## 7. Risks and fallbacks

| Risk | Assessment | Fallback |
|---|---|---|
| **Transfer margin** | measured `λ_min = 0.021424`; `t = 1/50`, `5ε ≈ 0.0149 < 0.02` | use `t = 3/200` (pivots still positive, §4) with `5ε < 0.015`; or re-partition to `K ≈ 10⁻³` (`h₁ = 1/30`) |
| **Prime proof at 4/5** | the `exp(−14x)` bound genuinely fails; the `exp(−8x)` bound works with `log 3 > 1.096` | if the `log n ≤ n` tail constant is too coarse, use `Real.log_le_rpow_div` (`log n ≤ 3n^{1/3}`) for a sharper majorant; in the worst case split `n = 3,4,5` explicitly and bound `n ≥ 6` |
| **Generator runtime / memory** | nine chunks, 150 panels, ~5–9 min each; two tracks ≈ 25–40 min; two tracks at a time stay within the memory envelope used for the 4×4 (see [`gen/README.md`](lean/gen/README.md)) | smaller chunks (`--size 100`); `build_chunks.sh` is resumable |
| **Rational factorisation size** | `L5` entries up to 30 digits; `ext`/`norm_num` on 25 entries | prove the factorisation entrywise with explicit `Fin.sum_univ_succ` expansions; or provide leading-minor determinants instead |
| **A genuine negative certificate** | not expected, but it would be a real refutation of finite positivity on this basis | record it with the witness vector and the exact rational determinant; do **not** hide it, and do **not** patch the centre |

**Margin warning.**  The `4×4` was the easy rung (`λ_min = 0.0227`).  The
`5×5` is still comfortable, but do not extrapolate: at `σ = 0.2` the same ladder
has `λ_min = 1.46·10⁻⁸` (`WEIL-GRAM.md` §3), which no `10⁻³` enclosure can
resolve.  The `σ = 1/20`, spacing `0.2` rung is the sweet spot.

The post-5×5 audit [`MARGIN-SCALING.md`](MARGIN-SCALING.md) makes the warning
quantitative for the *fixed* basis: `λ_min` is `1.671·10⁻²` at `n = 6`,
`1.244·10⁻²` at `n = 7`, and collapses to `8.968·10⁻⁴` at `n = 9`.  Since the
transfer needs `n·ε < λ_min(n)`, a 6×6 rung requires `ε < 2.78·10⁻³` and hence
a re-partition of all six chains to about `h = 1/28` (~72 chunks); `n = 9`
would need `h ≈ 1/640` and is out of reach.  Do not treat 6×6 as a cheap
increment, and do not expect more rungs to approach the cone by themselves.

---

## 8. Files, commands, and the factorisation snippet

### File map (to be created)

```
prime-spectrum-tensor/lean/
  DensityC4_0.lean … DensityC4_8.lean     -- generated (c = 4/5, ns D4)
  GaussianGram5.lean                      -- centre5, gramCentre5, L5/D5, transfer wrapper
  DensityCertificates5.lean               -- bands, gaussianGram5_posDef (or extend the 4×4 file)
  PoleEnclosure.lean                      -- + cosh_04_mem, poleTerm_mem_c4
  PrimeEnclosure.lean                     -- + exp_decay_le_four_fifths, primeTerm_mem_four_fifths
```

### `emit_all.py` change

`emit_all.py` names files by `enumerate(args.cc)`, so `--cc 4/5` would write
`DensityC0_*`.  Add

```python
ap.add_argument("--first-index", type=int, default=0)
...
for i, c in enumerate(args.cc, start=args.first_index):
```

then run `python3 emit_all.py --size 150 --cc 4/5 --first-index 4`.

### Direct generator call (without the flag)

```bash
cd lean/gen
P=1305; S=150
for j in $(seq 0 8); do
  start=$((j*S)); end=$((start+S)); [ $end -gt $P ] && end=$P
  args=(--c 4/5 --h0 1/125 --h1 1/20 --start $start --end $end
        --out ../DensityC4_${j}.lean --ns D4)
  [ $j -gt 0 ] && args+=(--import DensityC4_$((j-1)))
  [ $end -eq $P ] && args+=(--final --name density_mem_c4)
  python3 panels.py "${args[@]}"
done
./build_chunks.sh 4
```

### Exact `L5`, `D5` generation

```python
from fractions import Fraction as F
g = [F(4313596,10**8), F(-1648926,10**8), F(802313,10**8),
     F(-222044,10**8), F(683903,10**8)]
n, t = 5, F(1, 50)
A = [[g[abs(i-j)] - (t if i == j else 0) for j in range(n)] for i in range(n)]
L = [[F(0)]*n for _ in range(n)]; D = [F(0)]*n
for j in range(n):
    D[j] = A[j][j] - sum(L[j][k]**2 * D[k] for k in range(j))
    L[j][j] = F(1)
    for i in range(j+1, n):
        L[i][j] = (A[i][j] - sum(L[i][k]*L[j][k]*D[k] for k in range(j))) / D[j]
# check L * diag(D) * Lᵀ == A exactly, then emit with str()
```

### Verification

```bash
cd the-final-letter/topics/prime-spectrum-tensor/lean
./check.sh DensityC4_8.lean GaussianGram5.lean DensityCertificates5.lean
./check.sh                      # full, including the 4×4 chunks
cd .. && python3 -m pytest tests -q
```

---

## 9. Non-goals and honesty rules

RH is the goal. We expect to achieve it. The rules below keep the route honest.

* Not the infinite Weil cone, not the distributional explicit formula, not RH yet.
* Do not upgrade the source claim until proven otherwise (an absolute Hodge index would imply RH).
* Do not present the numerical eigenvalues as a certificate: the certificate is
  the exact rational `L D Lᵀ` plus the entrywise bands.
* Keep the `4×4` result intact: the `5×5` extension must not weaken or bypass
  `gaussianGram4_posDef`.

---

[Back to the topic](README.md) ·
[4×4 handoff](../angular-partition-method/HANDOFF-O4.md) ·
[Route note](OMEGA-ROUTE.md) ·
[Numerical record](WEIL-GRAM.md)
