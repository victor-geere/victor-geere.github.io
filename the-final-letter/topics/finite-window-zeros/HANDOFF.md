# Handoff — verified Krawczyk certificate at `1/2 + 14i`

Status: **in progress, not complete**. No Lean-certified zero is claimed.
P3 (`ζ(1/2+5i) ≠ 0`) remains done. P5 remains finite-shadow-only.
No RH, twin-prime, Chowla, or infinite Weil-positivity claim is made anywhere.

## Where things stand

| item | state |
|---|---|
| counts | **758 theorems · 393 computations · 457 tests · 48/48 Lean builds** |
| audit | `python3 topics/tools/audit_topics.py` → 48/48 OK |
| links | `python3 tools/check-links.py` → 0 broken |
| default build | `./lean/check.sh` OK |
| `BigCheck.lean` | verified separately, **not** in default build (≈639 s) |

## Build commands

```bash
cd the-final-letter/topics/finite-window-zeros
./lean/check.sh                 # Topic, Cert, Seg, Krawczyk, EulerMaclaurin,
                                # ZetaBox14, BoxNorm, FixedBox, BlockCert, EtaEM
./lean/check.sh BigCheck.lean   # standalone million-term atom check, ~639 s
```

`check.sh` sets `LEAN_EXTRA_PATH` to
`the-final-letter/topics/partial-sum-plus-tail/lean`, which supplies
`IBox.lean`, `Transcend.lean`, `CpowBox.lean`, `ReplayGeneral.lean`.

Mathlib: `~/lean/mathlib4`, Lean `4.35.0-rc2`.

## File map

| file | content |
|---|---|
| `lean/EulerMaclaurin.lean` | T1–T214: Euler–Maclaurin, `zetaEM`, `zetaEMGen`, `S_even`, remainder bounds. |
| `lean/Interval.lean` | T215–T229, T234–T248, T264–T273: rational/complex intervals, `π`, `ζ(2)`, `ζ(4)`, `ζ(6)`, complex inverse, grid rounding. |
| `lean/Krawczyk.lean` | T230–T233, T249: concrete target, `h1`, `Yk`, `hmap`. |
| `lean/ZetaBox14.lean` | T250–T261, T277–T282: `params14`, `paramsFast`, million-term `allOK`, tail bound, block parameters. |
| `lean/BoxNorm.lean` | T262–T263: box endpoint and box-to-norm lemmas. |
| `lean/FixedBox.lean` | T264–T276, T283–T288: snapped boxes and folds, block values, block fold membership. |
| `lean/BlockCert.lean` | T289: `blockFold_1e6` at `B = M = 1000`. |
| `lean/EtaEM.lean` | T290–T292: forward differences and the iterated Euler transformation. |
| `lean/EMCritical.lean` | T293–T305: the Euler–Maclaurin remainder on the critical line (`0 < Re s`, every `K`). |
| `lean/EMBox14.lean` | `ptBox`, `inv_s14_sub_one`, `csPow`/`csPow_mem`, `Bzeta`; corner test **open** (see below). |
| `python/emit_em.py` | Reference emitter for the `zetaEMGen 1 N` box at `1/2+14i`; calibrates the `CpowBox` parameters. |
| `lean/Cert.lean`, `lean/Seg.lean` | P3 certificates for `1/2+5i`. |
| `python/emit_blocks.py` | Python rational mirror of the `CpowBox` layer (reference emitter). |

## Proved facts that matter

### Krawczyk target

- T230–T233: target `s0 = 1/2 + 14i`, `q = r = 1/4`, `Yk` rational.
- T249: `‖Yk‖ ≤ 3/2`, and

  ```lean
  hmap_of_zeta_bound :
    ‖ζ (1/2+14i)‖ ≤ 1/8 → ‖Yk * ζ‖ + (1/4)*(1/4) ≤ 1/4
  ```

- `h1` is discharged. Remaining Krawczyk inputs: `hC` and the ζ value bound.

### Eta partial sum at `1/2+14i`

- T251–T258: `params14` (`N=12,k=12,kI=128,n=16`) and `paramsFast`
  (`N=10,k=10,kI=256,n=12`); checker passes at `10^3`, `10^4`, `10^5`.
- T259: `allOK (paramsFast 1000000) S14 = true` (639 s, `BigCheck.lean`).
- T260: `‖s14‖ ≤ 15`.
- T261: `‖Σ' m, pairTerm s14 (m + 1000000)‖ ≤ 1/64`.

### Block layer

- T277–T282: block parameters, block split, block `allOK` from the global
  check, block box membership, block sum identity.
- T283–T288: list-range bridge, block values, pair fold, block pairs,
  `blockFold_mem`.
- T289: `blockFold_1e6` at `B = M = 1000`.

### `B₂` remainder on the critical line (T293–T300, `EMCritical.lean`)

- T293–T294: `emGShift s N j n → 0` for `0 < Re s` (previously `1 < Re s`).
- T295: the finite bridge `Sum_{k<n} ∫ B₁-weight = ½ B₂(0)(emG₁ n − emG₁ 0) − ½ Σ ∫ B₂-weight`,
  valid for every `s` and `n`.
- T296: the `B₂` series identity at `0 < Re s` (`tsum_correction_first_eq_of_re_pos`).
- T297–T298: `zetaEM = zetaEMGen 1 − ½ Σ' B₂`; `zetaEMRemainder 1 = −½ Σ' B₂`, at `0 < Re s`.
- T299–T300: `2 Re ζ(2)/(2π)² = 1/12`, and

  ```lean
  norm_zetaEMRemainder_one_le_of_re_pos :
    0 < s.re -> ‖zetaEMRemainder 1 N s‖ ≤
      (1/12) * ‖(s)₂‖ * ((N+1)^(-σ-2) + (N+1)^(1-σ-2)/(σ+1))
  ```

  At `s₀`, `N = 100` this is `≈ 1.5·10⁻³`, versus `|ζ(s₀)| ≈ 0.1056`.

### Euler transformation

- T290–T292 in `EtaEM.lean`:

  ```lean
  altSum_delta
  altSum_eq
  altSum_euler
  ```

  `altSum_euler` is the finite iterated identity with explicit boundary terms.
  Note the coefficient on `altSum (deltaN K a) N` is `2^{-K}` **without** a
  `(-1)^N` factor.

## Blockers

### 1. Box evaluation is noncomputable

`sumBox`/`blockPairs`/`foldPairs` depend on `Real.log`/`Real.exp` and the
Taylor enclosures in `Transcend.lean`, so they are `noncomputable`.
`native_decide` fails with:

```text
failed to compile definition … depends on 'blockPairs', which is 'noncomputable'
```

The million-term `allOK` is cheap only because it checks exponent bounds and
never constructs `expIBox`.

### 2. Python mirror is too slow

`python/emit_blocks.py` ports `logIvRat`, `expIvGeneral`, `expITaylor`,
`expIBox`, `cpowBox`. Measured:

```text
pair_box(0) ≈ 38.5 s
```

so `10^6` terms is order `10^7` s. Brute force is not viable.

### 3. Euler acceleration is only algebraic so far

`EtaEM.lean` proves the transformation but **not** the analytic bounds needed
to apply it at `Re s = 1/2`:

- finite-difference decay `|Δ^K a_n| ≤ C_K (n+1)^{-1/2-K}` for `a_n = n^{-s}`;
- absolute convergence of the transformed tail;
- vanishing of the two boundary sums as `N → ∞`.

### 4. `hC`

Needs:

- `DifferentiableAt ℂ (deriv riemannZeta) w`;
- a rigorous derivative enclosure on the disk of radius `1/4` around
  `s0 = 1/2+14i`;
- the resulting Krawczyk contraction `q`.

## Route change (2026-10-27)

**Step 1 below is superseded — do not pursue it.**  The iterated Euler
transformation for `η` is an *asymptotic* expansion on the critical line: the
observed error matches `2^{-K}|Δ^K a₀|` (`4.2·10⁻¹¹` at `K = 50`), but the only
easy rigorous bound is `2^{-K}·Σ_n|Δ^K a_n|`, which grows like `K!` and is
useless by `K = 50`.  Making it rigorous needs sector/monotonicity control of
`Δ^K a_n = (-1)^K (s)_K ∫ (n+Σt)^{-s-K}`, which the integrally-derived
Euler–Maclaurin route avoids entirely.

The `B₂` route is cheaper by six orders of magnitude in term count: `N = 100`
Euler–Maclaurin atoms plus one `B₂` ball, versus `10⁶` eta pairs.  Steps 3–5 are
unchanged; step 2 becomes "evaluate `zetaEMGen 1 100` in `Cx`" rather than
"evaluate a million-term block".

## Step-3 calibration (done; parameters are known-good)

`python/emit_em.py` mirrors the `CpowBox` layer in exact rational arithmetic and
pins down the parameters, which are **not** the ones `Cert.lean` uses:

* The `[-1,1]` side condition forces `kI >= |Im s| log b`, i.e. `>= 52` at
  `Im s = 14`, `b = 41`.  `Cert.lean`'s `kI = 32` is fine at height 5 and
  **fails here**.
* `expIBox` forms `exp(i t/kI)^kI` by *sequential* interval multiplication, so
  the box width is amplified by roughly `2^(kI/2)`.  At `kI = 64` a Taylor
  order of 12 leaves a box of width `50.5` — useless — because `expRem` is
  swamped by the amplification.

Measured corners of the enclosure of `zetaEMGen 1 N (1/2+14i)`:

| `(N_log, k, kI, n)` | `N` | `\|corner\|` | verdict |
|---|---|---|---|
| `(10, 10, 64, 12)` | 20 | `50.5` | fails the side condition budget |
| `(14, 16, 64, 20)` | 20 | `0.10569740` | tight and correct (`\|ζ\| = 0.1056263`) |

Working configuration: **`(14, 16, 64, 20)`**, `N = 20`, `K = 2`.
The `K = 2` remainder bound (T305) is `8.0·10⁻⁴`, so

`|ζ(s0)| <= 0.1057 + 0.0008 = 0.1065 <= 1/8`,

with `2·Re ζ(4)/(2π)^4 = |B_4|/4! = 1/720` rational and
`P_3 = (descPochhammer ℂ 3).eval (-s0) = 7041/8 + (5327/2)i`.

`K = 1` needs `N >= 40` (42 atoms, remainder `9·10⁻³`) because
`(1/12)||(s)_2||` is much larger; `K = 2` at `N = 20` costs 24 atoms instead.

## Blocker: the Lean box is wider than the mirror

`EMBox14.lean` evaluates the box with `native_decide` (26 s, all atom side
conditions pass), but the corner norm is **> 1**, while the exact-rational
mirror `python/emit_em.py` predicts `0.10570` for the same atoms and the same
`(14,16,64,20)` parameters — a factor-ten disagreement.

Localisation so far: `csPow 20`, `cpowBox 21 S14`, `cpowBox 21 S2box` have
corner norms ≤ 3, 1, 50 against predicted magnitudes 0.22, 0.22, 4.58 — so no
atom is grossly *wrong*, the excess is per-atom **width**.  Next things to
check, in order: `expRem`'s Lean definition vs the mirror's `(n+1)/(n!·n)`;
`expIvGeneral`'s split; `Iv.mul`'s `min4`/`max4`; `expITaylor`'s sign
convention.  A single `example : maxAbsIv (cpowBox 14 16 64 20 2 S14).re ≤ q`
bisected against the mirror's interval will pin it down in one compile.

Until then step 3 cannot be closed: a corner of `>1` is consistent with
`ζ(s0) ≠ 0` but not with `|ζ(s0)| ≤ 1/8`.

## Next steps, in order

0. ~~Relax the `B₂` remainder to `0 < Re s`.~~  **Done** (T293–T300).
1. *(superseded)* **Finish the Euler analytic bounds** in `EtaEM.lean`:
   - define `a n = (n+1 : ℂ) ^ (-s)` on the critical line;
   - prove finite-difference decay via the integral/MVT bound for `x^{-s}`;
   - prove `Summable (fun n => ‖deltaN K a n‖)`;
   - prove the boundary terms tend to `0`;
   - conclude an explicit `|η(s) - accelerated partial sum| ≤ ε` with
     `K ≈ 50`, `ε ≈ 10^{-10}`.
2. **Evaluate `zetaEMGen 2 20` as a rational box** (24 atoms, params
   `(14,16,64,20)`, see the calibration section).  Note the pole term is exact
   at the point: `1/(s0-1) = (-2 - 56i)/785`, so **no interval division is
   needed**.  *Superseded detail:*  Mirror the `Cert.lean`
   `sumBox` architecture: a fold of `CpowBox` atoms for `Σ_{n≤100} n^{-s}`, the
   `101^{1-s}/(s-1)` term (needs a complex reciprocal on `Cx`, which exists only
   on `Interval.lean`'s `ComplexInterval` — port `inv` to `Cx` or bound
   `|s-1| ≥ 3/4` and use `conj/|·|²` with `Iv.divPos`), and the `B₂` boundary
   term.  Then `‖ζ(s₀)‖ ≤ |box| + 1/600` via `BoxNorm.norm_le_of_mem_box`,
   feeding `hmap_of_zeta_bound`.
3. **ζ value bound.** As above; the `η` transfer is no longer needed for this
   step, though `Cert.lean`'s `zeta_ne_zero_of_eta_mem` remains the pattern.
4. **`hC`.** Prove differentiability of `ζ′` and a derivative enclosure on
   `‖w - s0‖ ≤ 1/4`; close the Krawczyk contraction.
5. **Final zero theorem** from `zeta_zero_of_krawczyk` (T148/T230).

## Hard rules

- No `sorry`, `axiom`, or `admit`.
- Do not weaken P3.
- Do not claim RH or infinite Weil positivity.
- P5 stays finite-shadow-only.
- Any new theorem needs a ledger row in `README.md` and `index.html`, plus
  updated counts in `topics/STATUS.md` and a `research-journal.md` entry.

## Useful numeric values

```text
s0 = 1/2 + 14i
ζ(s0)      ≈ 0.02224114261 − 0.10325812327i
ζ′(s0)     ≈ 0.74823369612 + 0.20443653378i
Yk         = 12436403768/10^10 − (3397942771/10^10) i
|Yk|       ≈ 1.289
|ζ(s0)|    ≈ 0.1056
tail(M=10^6) ≤ 1/64 ≈ 0.015625
```

## Git note

`EulerMaclaurin.lean`, `ZetaBox14.lean`, `BoxNorm.lean`, `FixedBox.lean`,
`BlockCert.lean`, and `EtaEM.lean` may be untracked. Check `git status`
before committing and preserve the existing ledger numbering.
