# Handoff — verified Krawczyk certificate at `1/2 + 14i`

Status: **in progress, not complete**. No Lean-certified zero is claimed.
P3 (`ζ(1/2+5i) ≠ 0`) remains done. P5 remains finite-shadow-only.
No RH, twin-prime, Chowla, or infinite Weil-positivity claim is made anywhere.

## Where things stand

| item | state |
|---|---|
| counts | **750 theorems · 393 computations · 457 tests · 48/48 Lean builds** |
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

## Next steps, in order

1. **Finish the Euler analytic bounds** in `EtaEM.lean`:
   - define `a n = (n+1 : ℂ) ^ (-s)` on the critical line;
   - prove finite-difference decay via the integral/MVT bound for `x^{-s}`;
   - prove `Summable (fun n => ‖deltaN K a n‖)`;
   - prove the boundary terms tend to `0`;
   - conclude an explicit `|η(s) - accelerated partial sum| ≤ ε` with
     `K ≈ 50`, `ε ≈ 10^{-10}`.
2. **Replace the million-term block** with the accelerated finite sum
   (a few hundred terms), then compute its box with the existing
   `CpowBox`/`pairBox` layer at a feasible term count.
3. **ζ value bound.** Use `η(s) = (1 - 2^{1-s}) ζ(s)` and the accelerated
   `η` box to get `‖ζ(1/2+14i)‖ ≤ 1/8`; feed `hmap_of_zeta_bound`.
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
