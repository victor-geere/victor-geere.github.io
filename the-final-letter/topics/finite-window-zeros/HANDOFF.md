# Handoff — verified Krawczyk certificate at `1/2 + 14i`

Status: **in progress, not complete**. No Lean-certified zero is claimed.
P3 (`ζ(1/2+5i) ≠ 0`) remains done. P5 remains finite-shadow-only.
No RH, twin-prime, Chowla, or infinite Weil-positivity claim is made anywhere.

## Where things stand

| item | state |
|---|---|
| counts | **787 theorems · 393 computations · 457 tests · 48/48 Lean builds** |
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

## Status of steps 1–5

| step | state |
|---|---|
| 1. Euler-acceleration bounds in `EtaEM.lean` | **superseded** — the expansion is asymptotic, not convergent; see "Route change" |
| 2. Replace the 10⁶-term block | **superseded** — Euler–Maclaurin reaches the bound with 21 atoms |
| 3. `‖ζ(1/2+14i)‖ ≤ 1/8` | **DONE** (T320/T321), sharpened to `23/200` (T322) |
| 4. `hC` | **REDUCED to `h1` + `h2`** (T329); `h2` has a concrete plan with no analytic unknowns |
| 5. Final zero theorem | **DONE, conditional on step 4** (`zeta_zero_14_of_bounds`, T329) |

Old blockers 1–3 (noncomputable box evaluation, slow Python mirror, algebraic-only
Euler transformation) are all resolved or bypassed; see "Route change" and
"Step-3 calibration".  No `sorry`/`axiom`/`admit` anywhere; `./lean/check.sh` is
green (12 files).

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

## Step 3: DONE

```lean
theorem zeta_norm_le_eighth : ‖riemannZeta s14‖ ≤ (1 / 8 : ℝ)
theorem hmap_zeta :
    ‖Yk * riemannZeta s14‖ + (1/4 : ℝ) * (1/4 : ℝ) ≤ (1/4 : ℝ)
```

Both proved with no `sorry` in `lean/EMBox14.lean` (T306–T321).  The enclosure
is 21 atoms — `csPow 20` plus a single `21^{-s}` atom — with

* parameters `(N_log, k, kI, n) = (20, 16, 48, 24)`;
* `Σ_{n=1}^{20} n^{-s}`, `21^{1-s}/(s-1)`, `21^{-s}/2` and
  `(1/12)s·21^{-(s+1)}` collapsed onto that one atom via `Complex.cpow_add`;
* scalar `1/2 + s/252 + 21/(s-1) = 177437/395640 - (20383/14130)i`
  (the pole factor is exactly `(-2-56i)/785` at a point box);
* corner `≤ 11/100` (`native_decide`), remainder `≤ 1/250` (T313), `B₄`
  boundary `≤ 1/1000` (T314); total `0.114361 < 1/8`.

Sequence: `ζ = zetaEM 20` (`zeta_eq_zetaEM_of_im`), `= zetaEMGen 2 + rem₂`,
`zetaEMGen 2 = zetaEMGen 1 + B₄`, `zetaEMGen 1 ∈ Bzeta`, then three triangle
inequalities.

## Step 4 (`hC`): analysis and a radius correction

```lean
hC : ∀ z ∈ Metric.closedBall s14 (r), ‖1 - Yk * deriv riemannZeta z‖ ≤ q
```

### `r = 1/4` is not reachable by the mean-value route

Supremum over the boundary circle (720 samples): `sup‖1 - Yk·ζ′‖ = 0.22955`
against a budget of `0.25`. The mean-value form

`‖1 - Yk ζ′(z)‖ ≤ ‖1 - Yk ζ′(s14)‖ + |Yk|·r·sup|ζ″|`

gives `0 + 1.2892·0.25·0.79244 = 0.25541 > 0.25` — it **fails by 2%**, even
with a perfect `sup|ζ″|`. The direct route (enclose `ζ′` over boxes and take
the sup) needs box radius `≤ 0.02`, i.e. ~150 EM boxes; and covering the
bounding box fails outright because its corners are at distance `0.354` from
`s14`, where the value is already `0.332`.

So `hC` at `r = 1/4` requires a *tight global* `ζ′` enclosure, not a
subdivision.

### `r = 1/5` works, and the map condition still holds

| r | sup‖1−Ykζ′‖ | sup‖ζ″‖ | MVT bound (≤0.25) | map: 1.2892·0.114361 + 0.25r ≤ r |
|---|---|---|---|---|
| 1/4 | 0.22955 | 0.79244 | 0.25541 ✗ | 0.20994 ≤ 0.25 ✓ |
| **1/5** | 0.17956 | 0.75863 | **0.19561 ✓** | **0.19744 ≤ 0.2 ✓** |
| 7/40 | 0.15538 | 0.74229 | 0.16747 ✓ | 0.19119 > 0.175 ✗ |

At `r = 1/5`, `q = 1/4` **both** Krawczyk conditions hold, with 28% margin on
`hC` and 1.3% on the map condition (which uses the *proved* T320 bound
`‖ζ(s14)‖ ≤ 0.114361` and needs only `‖Yk‖ ≤ 1.29`, a sharpening of the
existing `norm_Yk_le_three_halves`).

Changing the radius means `zeta_zero_of_krawczyk` is instantiated at `r = 1/5`
rather than `zeta_zero_quarter_ball`.  This is **not a weakening**: a zero in
the `1/5`-ball is a stronger statement than one in the `1/4`-ball.  Done in
T322–T326:

```lean
theorem zeta_norm_le_115 : ‖riemannZeta s14‖ ≤ (23 / 200 : ℝ)      -- sharp
theorem norm_Yk_le : ‖Yk‖ ≤ (1.29 : ℝ)                             -- sharp
theorem hmap_zeta_fifth :
    ‖Yk * riemannZeta s14‖ + (1/4) * (1/5) ≤ (1/5)                 -- map, proved
theorem fifth_ball_ne_one : ∀ z ∈ closedBall s14 (1/5), z ≠ 1      -- proved
theorem zeta_zero_fifth_ball ... (hC : ...) (hmap : ...) :
    ∃ z ∈ closedBall s14 (1/5), riemannZeta z = 0
```

So the *entire* remaining obligation for a certified zero is the single
hypothesis `hC`.  Exactly:

**Exactly one hypothesis remains**, and it is now reduced to two explicit
numerical inputs (T327–T329):

```lean
theorem zeta_zero_14_of_bounds
    (h1 : ‖1 - Yk * deriv riemannZeta s14‖ ≤ 1/1000)          -- point enclosure of ζ′
    (h2 : ∀ z ∈ closedBall s14 (1/5),
            ‖deriv riemannZeta z - deriv riemannZeta s14‖ ≤ 47/250) :  -- ζ′ Lipschitz
    ∃ z ∈ closedBall s14 (1/5), riemannZeta z = 0
```

Everything else is discharged: `Yk ≠ 0` (T327), the map condition
(`hmap_zeta_fifth`), the ball avoids `1` (`fifth_ball_ne_one`), and `hC`
follows by the triangle inequality (`hC_of_bounds`, T328):
`10⁻³ + 1.29·(47/250) = 0.24352 ≤ 1/4`.

The **true** values are `‖1 − Ykζ′(s14)‖ ≈ 10⁻¹⁰` and the Lipschitz constant
`0.1517`, so `h1` has a factor-`10⁶` slack and `h2` has 24% slack.

### The remaining work for `h2` — a plan that works

**Key realisation (round 15): no second-derivative remainder theory is needed.**
The remainder `R = zetaEM 20 - zetaEMGen 1 20` is *tiny* (`~3·10⁻³` over the
`0.45`-disk, T305 at `K=2`), so `R′` can be bounded by **Cauchy on `R`
itself**:

```
|R'(z)| <= M_R / rho,   rho = 0.45 - 0.2 = 0.25
```

with `M_R` from T305 at `K = 2`, `N = 20` over `Re s >= 0.05`:

| quantity | value |
|---|---|
| `‖s‖` max on the `0.45`-disk | `14.4812` |
| `‖(s)₄‖ ≤` | `64590` |
| `M_R` | `3.124·10⁻³` |
| `|R′| ≤ M_R/0.25` | `0.01249` |
| needed `sup‖G″‖ ≤ (47/250 − 2·0.01249)/0.2` | **`0.815`** |
| true `sup‖ζ″‖` on the `1/5`-ball | `0.75863` (7.4% margin) |
| total MVT `0.2·0.7586 + 2·0.0125` | `0.1767 ≤ 0.188` ✓ |

So `h2` follows from `sup‖G″‖ ≤ 0.815` where `G = zetaEMGen 1 20`, and `G″`
is **explicit**: differentiating `Σ_{n≤20} n^{-s}`, the pole term and the
`21^{-s}` multiples twice gives a finite expression in `n^{-s}`, `log n`,
`log 21`, and powers of `1/(s-1)`.

Remaining pieces, in order:

1. `M_R` over the `0.45`-disk (a small variant of T306; same shape).
2. `|R′| ≤ M_R/ρ` by Cauchy (`Complex.norm_deriv_le_div_of_mapsTo_ball` is
   already used in `EulerMaclaurin.lean`).
3. **`Cx.inv`** — a complex reciprocal on boxes with soundness, for the
   `1/(s-1)`, `1/(s-1)²`, `1/(s-1)³` factors. `Cx` has no `inv`;
   `Interval.lean`'s separate `ComplexInterval` does. This is the only genuinely
   new piece of infrastructure. Safe to add locally (not in the shared
   `IBox.lean`) since `Re(s-1) ∈ [-0.45,-0.05]` is bounded away from `0`.
4. The `G″` box formula and `sup‖G″‖ ≤ 0.815` by `native_decide`.
5. MVT assembly → `h2`; then `h1` in the same style (point enclosure of `ζ′`).

Nothing here is analytically hard any more; items 3–4 are mechanical but bulky.

### What this does *not* give

`hmap` was the last *numerical* premise of the Krawczyk step. `hC`
(`‖1 - Yk·ζ′‖ ≤ 1/4` on `‖w-s0‖ ≤ 1/4`) is still open, so **no zero is
certified yet**. No RH or infinite-positivity claim is made anywhere.

## Next steps, in order (current)

The only outstanding obligation is T329's two hypotheses (`h1`, `h2`).
Concretely, in this order:

1. `M_R` over the `0.45`-disk — a variant of T306 at `K=2`, `N=20`, `Re s ≥ 0.05`.
   Expect `≈ 3.124·10⁻³`.
2. `|R'| ≤ M_R/0.25` by Cauchy (`Complex.norm_deriv_le_div_of_mapsTo_ball`, as
   already used in `EulerMaclaurin.lean`), giving `≈ 0.01249`.
3. **`Cx.inv`** — complex reciprocal on boxes with soundness. `Cx` has none;
   `Interval.lean`'s separate `ComplexInterval` does. Put it in the topic's own
   file, not the shared `IBox.lean`: `Re(s-1) ∈ [-0.45,-0.05]` is bounded away
   from `0` on the `1/5`-ball, which is all the side condition needs.
4. The explicit `G''` box (`G = zetaEMGen 1 20`): `(log n)²·n^{-s}` summed over
   `n ≤ 20`, plus the differentiated pole and `21^{-s}` terms. Check
   `sup‖G''‖ ≤ 0.815` by `native_decide` (true value `0.75863`).
5. Assemble `h2`: `|ζ'(z) - ζ'(s14)| ≤ 0.2·sup‖G''‖ + 2·|R'| ≤ 0.188`.
6. `h1` in the same style: a point enclosure of `ζ'` at `s14` to `10⁻³`
   (true error `~10⁻¹⁰`, so six orders of slack).
7. `zeta_zero_14_of_bounds h1 h2` then yields the certified zero.

Then update the ledger (README + index.html), `topics/STATUS.md` counts and
`research-journal.md`, per the hard rules below.

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
