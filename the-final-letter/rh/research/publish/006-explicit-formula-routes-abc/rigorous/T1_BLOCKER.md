# T1 — the `T = 15` count is UNCONDITIONAL (certified 2026-10-11)

**Item:** `T1` of `../../../TODO.md`: replace the *cited* bound
`|ζ′(σ+it)/ζ(σ+it)| ≤ A log(|t|+2)` (`σ ≥ ½`, `A = 1`, giving `Lf_const = 30`) by a
proved per-step bound, so the Turing window `(½,15)` is unconditional.

**Status: DONE.** [`certify_count15_uncond.py`](certify_count15_uncond.py) runs with
`Lf_const=None` — **no cited `|ζ′/ζ|` bound is used anywhere** — and certifies the count:

```
T=15 steps/unit=24 K=40 -> I3=(-6.553844068,3.141546283)  N in [0.7981608,1.2018097]
N(15) in [0.7981608,1.2018097] -> N(15)=1 CERTIFIED  (9571s)
UNCONDITIONAL: no cited |zeta'/zeta| bound was used; Lf is enclosed per step.
TURING: N(15)=1 = #certified on-line zeros with 1/2<Im<15 (gamma_1)
=> every zero with 1/2<Im<15 is simple and on the critical line.
```

N half-width `0.2018 < 0.5`; runtime `9571 s ≈ 2.66 h`. The corresponding *conditional*
run (`Lf_const = 30`, `certify_count15d`) reaches the same conclusion with a tighter
budget (`N ∈ [0.57197018, 1.4279394]`) and remains archived for comparison.

The rest of this note records how the obstruction was removed, since the two failure
modes are easy to reintroduce (this file was named `T1_BLOCKER.md` while the item was
open; the name is kept so existing links stay valid).

---

## 1. Fixed: the removable singularity of `ζ = η/(1 − 2^{1−s})` on `Re s = 1`

`f(s) = 1 − 2^{1−s}` vanishes on `Re s = 1` at `t_k = 2πk/ln 2` (`k = 0, ±1, …`;
`t_0 = 0`, `t_1 = 9.0647…`), and `η` vanishes there too, so `ζ` is analytic across.
The quotient engines divide by `f²`, `f³`, and the path's vertical edge is `Re s = 1`,
so a step box near `t_0 = 0` or `t_1 = 9.0647…` made `cdiv` raise.

Engine code ([`eta_interval.py`](eta_interval.py)):

* `singular_ts` / `box_near_singularity(..., window)` — rigorous `Num` enclosures of
  `t_k = 2πk/ln 2`; with `window > 0` the point `t_0 = 0` is included.
* `_two_pow_one_minus_s_wide`, `_zeta_point_wide` — the `2^{1−s}` and `ζ = η/f` enclosures
  without the `exp_small` domain restriction (`|(½−σ)log 2| ≤ ½`), needed on a Cauchy contour.
* `_sup_zeta_square(c, R, K)` — rigorous upper bound for `sup|ζ|` on a square: the
  maximum-modulus principle reduces it to the boundary, which is covered by segment boxes
  evaluated with `_zeta_point_wide`.
* `zeta_local_box(s_lo,s_hi,t_lo,t_hi,K,R0=4/5)` — enclosures of `ζ, ζ′, ζ″` on a box by a
  Taylor expansion about a regular centre `c`, with the remainder `O(ρ³)` controlled by the
  Cauchy estimate `|ζ‴(w)| ≤ 24 M / (π (R−ρ)³)`; `R` is chosen by a ladder, largest first.
* `xi_logderiv` uses `zeta_local_box` for **any positive-area box whose `t`-range is within
  `_SING_WINDOW = 7/10` of a `t_k`** (including `t_0 = 0`), and as a fallback when the quotient
  engines raise or the regular `ζ` envelope is too wide for the division
  (`(zc.re*zc.re + zc.im*zc.im).lo <= 0`).  Point boxes (step midpoints) keep the accurate
  point engines.

Verification (certified fast mode `work = 60`, `EPS = 1e-40`, `K = 40`):

* `python3 scan_i3_boxes.py 15 24 40` — `xi_logderiv` on **all 372** I3 boxes:
  `0 failing box(es)`.
* `python3 zeta_singularity.py` — `0 fail(s)`: `zeta_local_box` contains `ζ, ζ′, ζ″`, and the
  `xi_logderiv` fallback contains `xi′/xi` and `(log xi)″` (mpmath references at 60 dps);
  the proved bound there is `|f′| ≲ 25.6`.
* `check_fast_mode.py` → `0 fail(s)`; `check_engine.py` → `0 fail(s)`.

## 2. The earlier `steps/unit = 12` run was UNDECIDED, and why

At `steps/unit = 12`, before the window routing, the box enclosure of `f′ = (log ξ)″` was
dominated by the *phase error* of the Euler terms (each term `(m+1)^{-s}` has phase
uncertainty `(h/2)log(m+1)`, accumulated by the differences) and amplified by `1/f³` near
every `t_k`:

```
I3=(-6.553907731,3.141917746)   N in [-19.70387,21.704076]   UNDECIDED  (4955s)
Σ Lf = 74776  (median 8.1, worst 62862 at σ=1, t∈[103/12,26/3])   err(Iim) = 64.91
```

The `t_1` region and (crucially) the `t_0 = 0` region both contribute; `python3 probe_lf.py`
lists the offenders, and `certify_count15_uncond_r2.log` is kept as the record.

## 3. The fix and the new budget

Routing the near-`t_k` boxes through `zeta_local_box` (window `7/10`, `R0 = 4/5`) and raising
`steps/unit` to `24` gives (`python3 -c "import probe_lf; probe_lf.main(15,24,40)"`):

```
Σ Lf = 2282.1   (median 3.13; worst box is the one straddling t*, t∈[217/24,109/12], Lf=227,
                 because the *point* zeta'' at distance 0.0022 has error ~150 — budget share 0.049)
err(Iim) = Σ Lf / (8 * 24^2) = 0.495        N half-width = 0.158 < 0.5
```

The box straddling `t*` is inherently wide: `zeta_second_point` at the centre `c` with
`|f(c)| ≈ 1.5·10⁻³` loses precision through `f³`, so its `Lf = 227`; this is a valid bound and
does not threaten the budget.

## 4. Result of `python3 certify_count15_uncond.py` (`steps/unit = 24`, `K = 40`)

```
T=15 steps/unit=24 K=40 -> I3=(-6.553844068,3.141546283)  N in [0.7981608,1.2018097]
N(15) in [0.7981608,1.2018097] -> N(15)=1 CERTIFIED  (9571s)
UNCONDITIONAL: no cited |zeta'/zeta| bound was used; Lf is enclosed per step.
```

`Iim.e = 0.2018·π = 0.634`: the probe's `Σ Lf / (8·24²) = 0.495` plus `0.139` of midpoint
`term.im.e`, still far inside the `0.5·π = 1.571` window.  The measured run is archived in
[`certify_count15_uncond.log`](certify_count15_uncond.log).

## 5. Caveats

* The local method's Cauchy contour reaches `σ = 1.8` (`R = 4/5`).  `eta_box` containment
  there is verified, and the module's lower bound `|Γ(s)| ≥ 0.5 √(π/cosh(πt))` has a factor
  `≥ 2` margin on the contour (min ratio `|Γ(σ+it)|/|Γ(½+it)| = 1` at `σ = ½`).
* The routing does **not** change the `K` needed at high `t`: near-`t_k` boxes still call
  `eta_box` (at the given `K`) inside `_sup_zeta_square`, so `T = 33` still needs `K = 100`;
  the routing only removes the `1/f³` amplification.
* `Lf_const = 30` is still valid; [`certify_count15d.py`](certify_count15d.py)
  (`N(15)=1 CERTIFIED`, 2870 s) is unchanged.
