# Erratum — two soundness bugs in the interval primitives (found 2026-10-12)

**Severity: soundness of every positive-width box enclosure in the Route-B engine.**
Both bugs were found while building the independent Dirichlet-`L` interval engine in
`python/`, whose verifier flagged the inputs it was handed. Both are **fixed** in
[`eta_interval.py`](../python/eta_interval.py); regression tests added: [`check_exp_num.py`](../python/check_exp_num.py)
and [`check_ndef.py`](../python/check_ndef.py).

A third finding (`log_hi`'s width) is recorded below as an **accuracy**, not a soundness, issue.

---

## Bug 1 — `exp_num` inverted its interval for `y.hi ≤ 0`

```python
if y.hi <= 0:
    big   = ndef(ONE, _exp_pos(iv.Num(-y.lo, 0)))    # actually e^{y.lo}, the SMALLER end
    small = ndef(ONE, _exp_pos(iv.Num(-y.hi, 0)))    # actually e^{y.hi}, the LARGER end
    lo, hi = small.v - small.e, big.v + big.e        # swapped: lo > hi
    return iv.Num((lo + hi) / 2, (hi - lo) / 2 + EPS)  # NEGATIVE radius
```

For `y.lo ≤ y.hi ≤ 0` we have `e^{y.lo} ≤ e^{y.hi}`, so the names are the wrong way round, `lo > hi`,
and the radius is negative — which [`ivmath.Num.__init__`](../python/ivmath.py) **silently clamps to 0**,
turning the inconsistency into a plausible-looking zero-width point at the midpoint.

```
y = [-0.55, -0.45]   true range of e^y: [0.57694981038, 0.63762815162]
before: 0.6072889810006344 ± 0                 <- contains NEITHER endpoint
after : [0.57694981038, 0.63762815163]         <- correct
```

**Blast radius.** `n_pow_neg_sigma` calls `exp_num` on the hull of `-σ log n` over the box's
σ-range, so **every enclosure over a positive-width σ-box** was too narrow: `eta_box` (box form),
`zeta_point`/`zeta_prime_point`/`zeta_second_point`, `xi_logderiv` (the `(log ξ)″` mesh cells),
`probe_lf`, `scan_i3_boxes`, `zeta_singularity`. **Not** affected: point (`value_only`) evaluations,
`Z_num`/`Zprime_num`/`Zprime_box` (σ pinned to `1/2`), the Euler tails, the Stirling/ψ machinery.

**Fix.** For `y.hi ≤ 0` the endpoint `e^{y.lo}` is the lower one (`lo_e`, `hi_e` in the new code).

## Bug 2 — `ndef` used the nonnegative-numerator division formula

```python
lo = x.lo / y.hi
hi = x.hi / y.lo          # correct only when x >= 0
```

The extreme values of `x/y` over the rectangle are attained at its corners, but *which* corners
depends on the sign of `x`: for `x < 0` the map `y ↦ x/y` is **increasing** in `y`, so the extremes are
`x.lo/y.lo` and `x.hi/y.hi`. The old formula under-covered by `|x|·Δy / y²` — a relative shortfall
equal to the denominator's relative width.

```
x = [-1.8370969, -1.6862478]   y = [3.6373329, 3.7097691]
true range of x/y: [-0.50506704, -0.45454251]
before: [-0.49520519, -0.46359457]     <- misses both ends by ~0.01 (2 % of the value)
after : [-0.50506704, -0.45454251]     <- correct
```

Random test: **1584 / 3000 containment failures before, 0 / 3000 after.**

**Blast radius.** `Cx` division (`cdiv`) passes the *signed* combination `a.re*b.re + a.im*b.im` as
numerator, so **every complex division in the engine** was exposed — including `zeta_point`'s
`cdiv(eta, f)` and `psi_num`'s `cdiv(CZERO+1, W*W)`. Point evaluations usually survived because the
numerator interval is then narrow and the blanket `EPS` absorbs the shortfall; **box** evaluations did
not.

**Fix.** Take min/max over all four corner quotients (the map is monotone in each variable separately,
`y.lo > 0`).

## The archived certificates — impact assessment

| consumer | affected? | why |
|---|---|---|
| Route A (`certify_unique*.log`, `γ₁…γ₁₅`) | **no** | `Z_num`/`Zprime_box` use σ = 1/2 exactly (point σ) |
| Route C (`route_c_assembly.log`) | **no** | does not touch `eta_box`/`xi_logderiv` |
| Route B counts (`certify_count15_uncond.log`, `certify_count33_par.log`) | **yes** | the mesh *midpoint* terms are point evaluations, but the curvature bound `Lf` came from a **box** enclosure |

```
_, fpb = xi_logderiv(σ_lo, σ_hi, t_lo, t_hi, K, 10)      # unsound box enclosure
Lf = |fpb|_up                                              # -> not a bound on the box
```

So `Lf` was an upper bound on `|f'|` **at the cell midpoint**, not on the cell, and the quadrature
budget `Σ ⅛|ds|² Lf` was correspondingly too small. Near the removable singularities
`t_k = 2πk/ln 2` — precisely where `Lf` is largest and matters most — `|f| = |1 − 2^{1−s}|` is small,
its *relative* width is large, and the `ndef` shortfall is largest.

**Honest verdict.** The two archived runs had headroom (`T = 15`: half-width `0.2018` against the
`0.5` requirement, ×2.5; `T = 33`: `0.289`, ×1.73), so the conclusions *may* well survive. But this is
now an **estimate, not a proof**, and the shortfall is not bounded by the previous estimate: as
archived, **the two Route-B counts are not rigorous** and must be re-run with the fixed primitives,
after which the half-width must be re-checked against `0.5`. If a run tips past `0.5`, raise
`steps/unit`.

## Third finding — `log_hi` is sound but wide (accuracy, not soundness)

`log_hi`'s fixed 600-term `2·atanh` series has a tail that grows with `p`; measured widths (still
*containing* the true value everywhere, so sound):

| `p` | 61 | 97 | 127 | 163 | 199 | 257 |
|---|---|---|---|---|---|---|
| width of `log p` | 4.1e-19 | 1.5e-12 | 6.6e-10 | 5.5e-8 | 9.6e-7 | 1.9e-5 |

Since a wider `log n` makes `n^{-σ}` wider and hence `Lf` **larger**, this errs in the *conservative*
direction for the error budget — but it does make the box enclosures loose at large `K`, and it is why
the `011` engine uses its own binary-reduced `_log_frac`. Worth reducing in `010` if the Route-B
budget is ever recomputed at `K ≳ 130`.

## The fixes, verified

```
python3 check_ndef.py        # 0 fail(s)   — new: 0/3000 (was 1584/3000); cdiv 0 uncovered
python3 check_exp_num.py     # 0 fail(s)   — new: eta_box 0 corner failures (was 36)
python3 check_engine.py      # 0 fail(s)   — the project's own containment check
```

## Follow-up required

1. **Re-run** `certify_count15_uncond.py` and `certify_count33_par.py` with the fixed primitives and
   re-archive the logs; confirm the half-widths still fall below `0.5`, raising `steps/unit` if not.
   Cost ≈ 2.7 h and ≈ 2.6 h respectively.
2. Re-run `scan_i3_boxes.py` and `probe_lf.py` for the record (the honest `Σ Lf` will be larger).
3. Make `ivmath.Num` **reject** a negative radius instead of clamping it — that clamp is what hid bug 1.
4. Consider a `log_hi` with binary range reduction (as in `python/dirichlet_interval.py`).

---

## Re-run status (2026-10-12/13, round `011` continuation)

The two counts were relaunched with the fixed primitives into `rerun/`:

```
python3 certify_count_par.py 33 40 100 7 > rerun/certify_count33_par_rerun.log 2>&1
python3 certify_count_par.py 15 24 40 1  > rerun/certify_count15_uncond_rerun.log 2>&1
```

`certify_count_par.py` is used for both (its per-box accumulation is order-independent and it is
identical to `I3_certificate` box-for-box, so `15 24 40` reproduces `certify_count15_uncond.py`).
**Results:**

| run | archived (buggy primitives) | re-run (fixed primitives) | verdict |
|---|---|---|---|
| `T = 15`, `steps/unit = 24`, `K = 40` | `N ∈ [0.7981608, 1.2018097]`, hw 0.2018 | `N ∈ [0.56932353, 1.4325407]`, hw **0.4316** | `N(15)=1` **certified** (at the `1/8` convention; see below) |
| `T = 33`, `steps/unit = 40`, `K = 100` | `N ∈ [4.711, 5.2890345]`, hw 0.289 | `N ∈ [3.3040886, 6.695946]`, hw **1.696** | **UNDECIDED** — the archived `N(33)=5` does **not** survive |

So the erratum's suspicion is resolved concretely: the fix roughly doubles the `T = 15` budget and
**inflates the `T = 33` budget by a factor of ≈ 5.9**, because the `T = 33` curvature bound is
dominated by boxes near the removable singularities `t_k = 2πk/ln 2` (`t_1 ≈ 9.06`, `t_2 ≈ 18.13`,
`t_3 ≈ 27.19`), exactly where the corrected `exp_num`/`ndef` widen the enclosure most. The
`T = 33` count would need `steps/unit ≈ 74` to pin `5` at the `1/8` convention (and more with the
sharp `1/4` constant below).

**Resolution: the curvature bound was removed, not merely enlarged.** Since
`I₃ = ∫ logDeriv ξ ds = Δ log ξ`, its imaginary part is the continuous change of `arg ξ` along the
path. The new module [`python/zeta_routeB.py`](../python/zeta_routeB.py) tracks
`arg ξ` sample by sample from a rigorous value enclosure of
`ξ(s) = ½s(s−1)π^{−s/2}Γ(s/2)ζ(s)` (assembled from the `010` `zeta_point` and the shifted-Stirling
`Γ`); it never evaluates `Lf`, so it is immune to both this erratum and the midpoint-constant
finding below. It gives

```
N(15) ∈ [0.999999909, 1.000000091]   -> N=1 CERTIFIED
N(33) ∈ [4.999999675, 5.000000325]   -> N=5 CERTIFIED
```

in a few minutes each, and the logs are `python/zeta_routeB_arg_T15.log` and
`..._T33.log` (verified by `python/check_zeta_routeB.py`). So the two `ζ` windows are
**restored, and now with a much tighter and proof-clean method**; the archived quadrature runs
remain as the concrete demonstration of the erratum's blast radius.

## A third finding — the midpoint budget constant is `1/4`, not `1/8` (unproved, not a demonstrated error)

Independently of the box bug, the quadrature budget is written
`|err| ≤ (1/8)|ds|² sup|f′|` in `I3_certificate` and in the primer. The elementary bound for the
midpoint rule is

```
|err| ≤ (1/4)|ds|² sup|f′|
```

(the triangular kernel `h/2 − |x|` has `L¹` mass `h²/4`), and it is sharp even for holomorphic
`f`: the extremal profile is uniformly approximable on a segment by entire functions (Mergelyan).
So `1/8` is half the true constant and is **not a proved bound**.

Why the archived numbers are nevertheless very likely safe: the budget uses the engine's *box*
enclosure `Lf`, which overestimates `sup|f′|` by roughly `10⁶–10⁷` on ordinary Route-B boxes
(measured against high-precision quadrature), and this erratum's own observation is that `Lf` is
dominated by the Euler-series phase error rather than by the true variation. The overestimate
absorbs the factor of two in practice, but not in any proof.

The full note, with the derivation and the suggested fix, is
[`../../notes/midpoint-constant.md`](midpoint-constant.md). The
`011` Dirichlet count avoids the issue entirely: it computes the Turing count by rigorous
argument tracking (`Im(I3) = Δ arg H`), which needs no curvature bound at all.

## Follow-up status (completed 2026-10-13)

* **Item 1 (counts re-run):** done — see the re-run table above; `T=15` certifies, `T=33` at
  `steps/unit=40` is undecided, and both windows are restored by the curvature-free
  argument-tracking route.
* **Item 2 (`scan_i3_boxes` / `probe_lf` for the record):** `scan_i3_boxes.py 15 24 40` →
  **0 failing boxes**; `probe_lf.py 15 24 40` → `Σ Lf = 5490.4`, quadrature half-width
  `0.379` (`1/8`) / `0.759` (`1/4`) — the full run's half-width is larger (`0.4316`) because it
  also accumulates the point-enclosure error, not only the quadrature budget
  (`rerun/diag_T15.log`).  For `T = 33` the analogous box sweep is already implicit in the
  completed (undecided) quadrature run itself, which evaluated all 1340 boxes without raising; a
  separate `probe_lf 33 40 100` pass would only recompute the same `Lf` sums and was not
  duplicated.  `probe_lf.py` now takes CLI arguments and reports both constants.
* **Item 3 (`ivmath.Num` guard):** done — `Num.__init__` now **raises** on a negative radius
  instead of clamping to `0`.  The erratum regression checks pass with the guard in place:
  `check_ndef.py` (0/3000), `check_exp_num.py` (0 corner failures), `check_engine.py` (0 fail).
* **Item 4 (`log_hi` range reduction):** still open; the `011` engine's `_log_frac` is the
  reference replacement.

The `1/8` constant of the third finding has also been changed to `1/4` in
`eta_interval.I3_certificate` and `certify_count_par._one`, and the quadrature route is retired
as the primary Route-B count in favour of `python/zeta_routeB.py`.
