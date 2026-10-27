# 011/rigorous — a rigorous interval engine for `Λ'_χ/Λ_χ`

The last numerical piece of the Dirichlet Route-B generalisation: a rigorous, box-correct
enclosure engine for the completed Dirichlet `L`-function's logarithmic derivative and its
derivative.  It has no dependency on the network or on mpmath's numerical differentiation, and
no mpmath value ever enters a rigorous computation.

```python
import sys; sys.path.insert(0, "011/rigorous")
from fractions import Fraction
import dirichlet_interval as D

D.fast_mode()                                   # work = 60, EPS = 1e-40 (certified)
f, fp = D.lambda_logderiv([0, 1, -1], 1,          # chi_3, odd
                          Fraction(1, 2), Fraction(1, 2),   # Re s in [1/2,1/2]
                          Fraction(5), Fraction(5))         # Im s in [5,5]
# f  = Lambda'_chi/Lambda_chi  on the box,  fp = (log Lambda_chi)''
```

## API

| function | returns |
|---|---|
| `hurwitz_zeta_box(s_lo, s_hi, t_lo, t_hi, alpha, M=20, K=50)` | `Cx` enclosure of `zeta(s, alpha)` on `[s_lo,s_hi] x i[t_lo,t_hi]` |
| `dirichlet_L_box(chi, s_lo, s_hi, t_lo, t_hi, M=20, K=50)` | `Cx` enclosure of `L(chi,s) = N^-s sum_{a<N} chi(a) zeta(s, a/N)` |
| `dirichlet_L_logderiv(chi, ...)` | `(L'/L, (L'/L)')` as `Cx` enclosures, `(L'/L)' = L''/L - (L'/L)^2` |
| `lambda_logderiv(chi, parity, ...)` | `(Lambda'/Lambda, (log Lambda)'')` for `Lambda(s) = (N/pi)^((s+a)/2) Gamma((s+a)/2) L(s)`, `a = parity` |
| `hurwitz_remainder_bound(alpha, ...)` | `(R0,R1,R2)`, the EM truncation bounds for `zeta, zeta', zeta''` (diagnostics) |
| `set_precision(work)` / `fast_mode()` | re-exported from `eta_interval` (move `WORK`, `EPS`, mpmath precision together) |

`chi` is a coefficient list of length `N` with `chi[0] = 0`; `parity = 0` (even) or `1`
(odd); `alpha` is an **exact positive rational** (`Fraction`/`int`, or `mpf` converted
bit-exactly).  All four entry points are wrapped in the 010 precision pin, so the working
precision is `WORK` regardless of the caller's `mp.mp.dps`.

`Cx` is the 010 complex interval (`re`, `im` are `ivmath.Num`); `Num(v,e)` denotes
`[v-e, v+e]`.  `ValueError` is raised when a denominator enclosure touches 0 — in particular
when the box contains the pole `s = 1` (with `t = 0`), or when `L` cannot be excluded from 0
(a genuine zero of `L`, or a box too wide).

## Method

**Hurwitz zeta.** Euler–Maclaurin,

```
zeta(s,a) = sum_{k<M} (a+k)^-s + b^(1-s)/(s-1) + (1/2) b^-s
          + sum_{j=1..K} B_{2j}/(2j)! (s)_{2j-1} b^(-s-2j+1) + R_K(s),      b = a+M,
R_K(s)    = -(s)_{2K+1}/(2K+1)! * int_0^inf B~_{2K+1}(x) (b+x)^(-s-2K-1) dx,
|R_K|    <= |(s)_{2K+1}|/(2K+1)! * sup|B~_{2K+1}| * b^(-sigma-2K)/(sigma+2K),
sup|B~_{2K+1}| <= 2 (2K+1)! zeta(2K+1)/(2 pi)^(2K+1),   zeta(x) <= 1 + 1/(x-1).
```

The box is handled by interval arithmetic on every term (so the `s`-variation of the EM sum is
enclosed automatically) plus the worst-case remainder over the box (`sigma -> s_lo` maximises
`b^(-sigma-2K)/(sigma+2K)` because `b > 1`).

**Derivatives.** Differentiating the integral representation of `R_K` (with
`P = (s)_{2K+1}`, `J = int B~ (b+x)^(-s-2K-1) dx`, `P' = P A`, `P'' = P (A^2-B)`,
`A = sum 1/(s+i)`, `B = sum 1/(s+i)^2`):

```
R  = -P J/(2K+1)!,   R' = -(P' J + P J')/(2K+1)!,   R'' = -(P'' J + 2 P' J' + P J'')/(2K+1)!,
|J|   <= supB b^(-sigma-2K)/(sigma+2K),
|J'|  <= supB b^(-sigma-2K+1/2)/(sigma+2K-1/2),      (uses log u <= sqrt(u), u >= 1)
|J''| <= supB b^(-sigma-2K+1)/(sigma+2K-1),          (uses log^2 u <= u, u >= 1).
```

The differentiated *partial* sums use the corrected formulas of
[`../../lib/dirichlet_engine_probe.py`](../../../../lib/dirichlet_engine_probe.py):
`(s)_n' = (s)_n A`, `(s)_n'' = (s)_n (A^2 - B)`.  In the engine the `j`-th correction is kept
as `c_j b^-s R_j` with `R_j = (s)_{2j-1} b^{-(2j-1)} = prod_{i<2j-1} (s+i)/b` (moderate
factors), not as a huge rising factorial times a tiny power — the latter loses all relative
accuracy through `Num`'s per-operation slack at `b^{-2j+1} ~ 10^{-130}`.

**Assembly and completion.**  With `T(s) = sum_a chi(a) zeta(s,a/N)`,
`L = N^-s T`, `L' = N^-s (T' - log N T)`, `L'' = N^-s (T'' - 2 log N T' + log^2 N T)`, and

```
Lambda'/Lambda      = (1/2) log(N/pi) + (1/2) psi((s+a)/2) + L'/L,
(log Lambda)''      = (1/4) psi'((s+a)/2) + (L'/L)'.
```

`psi`, `psi'` come from the 010 `psi_num` (recurrence + Stirling with explicit remainder),
evaluated at the box centre and inflated to the box by a rigorous second-derivative bound
`|psi''(w)| <= 2 (1/sigma^3 + 1/(2 sigma^2))`, `sigma = Re w` (valid for every `Re w > 0`; the
010 constant `2.5` is only valid for large `t`).

## Verification

```
python3 verify/check_dirichlet_engine.py          # RESULT: PASS, exit 0
```

Checks: the replacement primitives on random intervals; containment of `zeta(s,a)`, `zeta'`,
`zeta''`, `L`, `L'/L`, `(L'/L)'`, `Lambda'/Lambda`, `(log Lambda)''` against mpmath references
at `chi_3, chi_4, chi_5, chi_8`, `Re s in {1/2, 3/4, 1}`, `t in {0.5, 1, 5, 14.1347, 20, 33, 50}`;
box correctness on positive-area boxes (sampled interior points); EM remainder domination;
`width <= 1e-6` (absolute or scaled by `max(1,|value|)`); the pole refusal.

**References.**  `zeta^{(k)}(s,a)` from `mp.zeta(..., derivative=k)`; `L^{(k)}` from the
Hurwitz assembly with those derivatives (they agree with `mp.diff(dirichlet)` to `~1e-81`).
The prompt's `mp.diff(lambda z: mp.log(mp.dirichlet(z,chi)), s)` is **not** used for
containment: it is only `~1e-11` accurate at `t = 50` and jumps by ~2 when the principal log
of `L` crosses its branch cut (a difference of `2.22` appears at one path point).  It is
reported as a diagnostic only.

### Measured widths and timings (`fast_mode`, `M=20, K=50`, Python 3.13, one core)

| quantity | count | worst width | time |
|---|---|---|---|
| `zeta, zeta', zeta''` (path points, all `a/N`) | 756 enclosures | `7.1e-10` | 165 s |
| `L` | 84 points | `1.25e-10` | — |
| `L'/L`, `(L'/L)'`, `Lambda'/Lambda`, `(log Lambda)''` | 84 points | see below | 242 s (both `L` and `Lambda`) |
| box correctness (small boxes) | 105 sampled checks | 0 failures | 34 s |

Per call at `M=20, K=50`: one `_hurwitz_all` (all three derivatives) ≈ 0.66 s; one
`lambda_logderiv` ≈ 2.9 s.

420 log-derivative/curvature enclosures were checked; **416 have absolute width `<= 1e-6`**.
The four exceptions are all at `chi_5, Re s = 1/2, t = 33`, where `|L(chi_5, 0.5+33i)| =
1.79e-3` (close to a zero of `L`): there `L'/L = 2.19e3` has width `2.7e-4`
(relative `1.2e-7`) and `(L'/L)' = 4.81e6` has width `1.18` (relative `2.5e-7`).  This is not
an engine defect: any enclosure of `L'/L` must scale like `|L|^-1`, so an *absolute* `1e-6`
target is unattainable near a zero.  The verifier therefore asserts
`width/max(1,|value|) <= 1e-6` (worst `2.5e-7`) and, separately, absolute `<= 1e-6` at every
point with `|L| >= 1e-2`.

### EM remainder domination (worst `|true - EM partial| / bound`, dps 160)

| `M, K` | `zeta` | `zeta'` | `zeta''` |
|---|---|---|---|
| `(20,50), (20,30), (12,20), (30,50)` | `0.487` | `0.254` | `0.141` |

The bound dominates with a factor `>= 2` at `M = 20, K = 50`, matching the probe's `~0.5`
ratio.

## Honest limits

* **`t`-range / term counts.**  The EM remainder is *not* monotone in `K`; for fixed `b = a+M`
  it explodes once `2K` passes the optimal truncation `~2 pi b`.  Measured `R_0` for
  `zeta(1/2+it, 1/3)` (the value itself, not the width):

  | `M \ K` | 50 | 100 | 200 |
  |---|---|---|---|
  | 20 | `t=50: 5e-27`, `t=100: 1e-6`, `t=200: 2e20` | `t=50: 2e-18`, `t=100: 6e8` | `t=50: 1e56` |
  | 50 | `t=100: 3e-46`, `t=200: 6e-20` | `t=200: 3e-30`, `t=400: 6e22` | `t=200: 1e-7` |
  | 100 | `t=200: 5e-50`, `t=400: 6e-21` | `t=400: 5e-38`, `t=800: 5e20` | `t=800: 1e-52` |
  | 200 | `t=400: 4e-51`, `t=800: 5e-21` | `t=800: 3e-40` | `t=800: 5e-74` |

  So `M = 20, K = 50` is certified and useful up to `t ~ 50` (bound `5e-27`, far below the
  `~1e-11` enclosure width), marginal at `t ~ 100` (`1e-6`), and useless beyond.  Rule of
  thumb: take `M ~ t/4` and `K = 50`, or `K ~ t/8` for a large safety margin.  Cost grows
  linearly in `M` and `K`.
* **Box size.**  Boxes are enclosed correctly for any width, but the returned width grows with
  the box (`~ |d/ds| x` width).  Once a sigma-width of `~0.1` makes the `L` enclosure contain
  0, `dirichlet_L_logderiv` / `lambda_logderiv` refuse with `ValueError`; the log-derivative
  is not enclosed across a zero of `L`.  `hurwitz_zeta_box` and `dirichlet_L_box` themselves
  still work (they have no zero to avoid).
* **The pole `s = 1`.**  A box with `s_lo <= 1 <= s_hi` and `t_lo <= 0 <= t_hi` raises
  `ValueError`.  The Route-B path has `t0 > 0`, so this is never hit there.  Note that the
  assembled `L` is entire for non-trivial `chi`, but the pole does not cancel in interval
  arithmetic, so such boxes are unsupported for `L` too.
* **Near a zero of `L`.**  Absolute widths of `L'/L` and `(L'/L)'` necessarily blow up like
  `|L|^-1`, `|L|^-2`; only relative accuracy survives (see above).
* **Working precision.**  The verifier runs in `fast_mode` (`WORK=60`, `EPS=1e-40`).  The
  default `WORK=400` is sound too but ~10x slower; widths are then limited by the 010
  `exp_small` remainder (`~2e-11` relative) rather than by `EPS`.
* **Not a certified window (this module).**  This engine supplies the enclosures Route B
  consumes; by itself it does not certify `Z`, `m`, `hno` for any `chi`.  The companion
  module [`dirichlet_routeB.py`](../python/dirichlet_routeB.py) does: for `chi_3`, `T = 10` it certifies
  `N_chi3(10) in [0.9999999979, 1.000000002]`, matches it with one certified on-line zero at
  `Im s = 8.039737156...`, and so certifies that every zero in the window is simple and on the
  critical line.  Note that `dirichlet_routeB.py` computes the count by **argument tracking**
  (`Im(I3) = Delta arg H`), not by the midpoint rule: the *box* enclosure of `L` returned here
  is sound but loose (Euler–Maclaurin cancellation near `Re s = 1/2`, `|Im s| ~ 1/2`), so the
  curvature bound it would give is unusable.

## Two unsound 010 primitives, and the local replacements

Reusing `../010/rigorous/` directly was not possible for the boxes here; three primitives were
replaced **inside `011/` only** (010 is untouched):

1. `eta_interval.ndef` (used by `Cx` division) returns `[x.lo/y.hi, x.hi/y.lo]`, the correct
   image of `x/y` only for a **nonnegative** numerator.  For a signed numerator the true image
   is `[x.lo/y.lo, x.hi/y.hi]` (the map is monotone in each variable, so the extrema are at
   corners), and the 010 formula under-covers by `~|x| * relwidth(y)`.  Random sampling: 19551
   of 27000 corner checks fall outside the returned interval.  With `x = L'`, `y = |L|^2` the
   shortfall is `~1e-11`, which exceeded the width of `L'/L` and made containment fail on the
   imaginary part.  Replacement: `_div_iv` (all four corners) and `_cdiv`.
2. `eta_interval.exp_num` for an interval with `y.hi <= 0` returns
   `[e^{y.hi} - err, e^{y.lo} + err]`; when the interval is wider than `err` this is inverted
   and `Num` clamps the negative radius to 0, returning a **zero-width point**.  Every
   interval-argument `exp` (hence `n_pow_neg_sigma`) with a genuinely negative exponent is
   affected.  Replacement: `_exp_box` (monotone, pointwise `_exp_pos` at each end).
3. `eta_interval.log_hi` evaluates `2 atanh((p-1)/(p+1))` with a fixed 600 terms, tail
   `~p^{-1200}`: at `p = 163` this is `2.7e-8`, far above the working precision — and
   `b = a + M = 20.375` for `chi_8` already needs `log 163`.  Replacement: `_log_frac`,
   which reduces `q/2^e` to `r in [1,2)`, so the series argument is `(r-1)/(r+1) <= 1/3` and
   `K = 2 WORK + 60` terms reach the working precision.

`psi_num` is still used as-is: its internal shortfall from defect 1 is `~1e-38` (the divisors
there are large), negligible against the `~1e-11` enclosure widths, and it is evaluated
pointwise at a box centre with a separate rigorous box inflation.

## Files

* `dirichlet_interval.py` — the engine (this folder's deliverable).
* [`../verify/check_dirichlet_engine.py`](../../../twin-prime-parity/011/verify/check_dirichlet_engine.py) — the verifier
  (`RESULT: PASS`), log at `../verify/check_dirichlet_engine.log`.
* reuses `../010/rigorous/ivmath.py`, `../010/rigorous/eta_interval.py`.
* adapted from `../../lib/dirichlet_engine_probe.py` (the derivative formulas).
