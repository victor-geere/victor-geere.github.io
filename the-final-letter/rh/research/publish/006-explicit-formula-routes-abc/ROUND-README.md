# 010 — rh45 Routes A, B, C: certified zeros and the validated explicit formula

This round receives the **rh45 Routes A/B/C** work from
`research/twin-prime-parity/rounds/rh45/` and presents it as a self-contained
package: the certification logic (machine-checked), the numerical enclosure
engine, five certified on-line zeros, a closed Turing window, and a validated
Weil explicit-formula assembly.

**Read in this order.**
[`notes/routes-a-b-c-status.md`](notes/routes-a-b-c-status.md) →
`handoff.md` →
[`index.html`](index.html) →
`lean/README.md`.

## Routes A, B, C

The obligations are §6 of `../eta-euler-acceleration.html`:

* **Route A** — a rigorous sign change plus a derivative-sign certificate giving a
  **unique simple zero on the critical line**;
* **Route B** — a rigorous **Turing-method reduction**: a rigorous total count
  `N(T)` equal to the number of certified on-line zeros forces every zero in the
  window to be simple and on the line;
* **Route C** — a **validated explicit-formula error assembly** with proven
  prime-side (Chebyshev `ψ`), archimedean (Stirling) and zero-side bounds.

## Results

**Route A — complete for `γ₁…γ₅`.** For each zero the engine produces an enclosed
`Z` sign change and an enclosed one-signed `Z′` on a bracket of width `10⁻³`; the
logical step is machine-checked for both signs
(`Rh45Routes.exists_unique_root_of_sign_change`, `…_neg`).

| zero | enclosed `Z′` | conclusion |
|---|---|---|
| γ₁ | `[0.766441, 0.819918]` | unique simple on-line zero |
| γ₂ | `[−1.17358, −1.10014]` | unique simple on-line zero |
| γ₃ | `[1.32035, 1.42321]` | unique simple on-line zero |
| γ₄ | `[−1.34866, −1.25925]` | unique simple on-line zero |
| γ₅ | `[1.33534, 1.42899]` | unique simple on-line zero |

(`rigorous/certify_unique.log`, 5/5.)

**Route B — two Turing windows are closed, both unconditionally (items T1, T2).**
For `N(T) = Im(I₃)/π` on the symmetric contour `(½,½) → (1,½) → (1,T) → (½,T)`, which
lies entirely in `Re s ∈ [½,1]`, the engine certifies

* `N(3) = 0` (`Im(I₃)/π ∈ [−0.348, 0.348]`),
* `N(15) = 1` — unconditionally (`Lf_const = None`):
  `N ∈ [0.7981608, 1.2018097]`, `9571 s` (`certify_count15_uncond.log`);
  the earlier `Lf_const = 30` certificate gives `Im(I₃)/π ∈ [0.572, 1.428]`, `2870 s`;
* `N(33) = 5` — unconditionally (`Lf_const = None`, `K = 100`, `steps/unit = 40`):
  `N ∈ [4.711, 5.2890345]`, `9391 s` (`certify_count33_par.log`; the parallel
  `certify_count_par.py` computes it in ≈ 2.6 h).

Since the only certified on-line zero with `½ < Im < 15` is `γ₁`, and the certified
on-line zeros with `½ < Im < 33` are exactly `γ₁…γ₅` (brackets up to `32.9341…32.9361`,
all `< 33`), the machine-checked `Rh45Routes.all_zeros_are_certified` gives:

> **every zero with `½ < Im < 15`, and every zero with `½ < Im < 33`, is simple and on the
> critical line.**

**Route C — validated assembly.** On the modulated Gaussian
`g(u) = e^{−u²/2}cos(14u)/√(2π)` the identity holds to

`RHS − LHS = −9.08·10⁻⁹` against a budget of `2.79·10⁻⁸`

(prime side `1.2·10⁻⁸`, archimedean Simpson `1.6·10⁻⁸`, zero tail `1.6·10⁻⁸⁰`).

## Toolchain and verification

* Lean 4 `v4.35.0-rc2` with Mathlib at `$HOME/lean/mathlib4`;
  `010/lean/check.sh --all` → **OK**, **0 `sorry`**, **0 `axiom`**, axiom
  footprint `[propext, Classical.choice, Quot.sound]`.
* Python engine: `010/rigorous/eta_interval.py` with its dependency
  `010/rigorous/ivmath.py` bundled here (the scripts now import locally).

## What this does not claim

* The **archived** `T = 15` certificate (`certify_count15d`) is rigorous **modulo the
  cited zero-free-region bound** `|ζ′(σ+it)/ζ(σ+it)| ≤ A log(|t|+2)` (`σ ≥ ½`) with
  `A = 1`, used to bound `|f′| < 30` on the path; the empirical value is `≈ 4.26`.
  The **unconditional** replacement (`Lf_const=None`, `certify_count15_uncond.py`) is now
  **certified**: `N(15) ∈ [0.7981608, 1.2018097]`, i.e. `N(15) = 1`, in 9571 s, with no
  cited `|ζ′/ζ|` bound anywhere. `xi_logderiv` routes every step box near a removable
  singularity `t_k = 2πk/ln 2` (including `t_0 = 0`) through the rigorous local Taylor
  enclosure `zeta_local_box` (Cauchy/Maximum-Modulus, largest-`R` ladder, `R0 = 4/5`); at
  `steps/unit = 24` the measured `Σ Lf = 2282.1`, so `err(Iim) = ΣLf/(8·24²) = 0.495`
  and the N half-width is `0.2018 < 0.5`. See
  [`rigorous/T1_BLOCKER.md`](rigorous/T1_BLOCKER.md) for the full history (including the
  earlier UNDECIDED run at `steps/unit = 12`).

## Engine facts worth knowing

* **`K` must scale with `t`.** The Euler-accelerated `η` enclosure needs `K ≳ 0.25·t`
  to stay tight: at `t = 33`, `zeta_point` returns a `1.8·10¹⁰`-wide (useless, though
  still sound) enclosure at `K = 40` versus `0.024` at `K = 100`. `T = 15` is fine at
  `K = 40`; `T = 33` needs `K = 100` (at `K = 80` one top-segment box still fails).
  Validated for `T = 33`: `scan_i3_boxes.py 33 16 100` → **536 boxes, 0 failing** (the same
  scan at `K = 40` reports 261 failures). The failure mode is loud, never silently unsound.
* **Long certificates can be parallelised.** `rigorous/certify_count_par.py` computes the
  same `I3(T)` as `I3_certificate` but evaluates the path's boxes in a process pool:
  the accumulation `Num(v + dv, e + de + err)` is order-independent (centres add, error
  radii add), so per-box contributions may be summed in any order. It reproduces the
  sequential centres exactly and cuts the `T = 33` run from ~9 h to well under 2 h.
* **The singularity of `ζ = η/(1−2^{1−s})` on `Re s = 1`** (at `t_k = 2πk/ln 2`) is
  removable for `ξ′/ξ` but fatal for the quotient engines; `zeta_local_box` plus the
  `_SING_WINDOW = 7/10` routing is the fix. Regression tools:
  [`rigorous/scan_i3_boxes.py`](rigorous/scan_i3_boxes.py) (every box `I3_certificate`
  feeds to `xi_logderiv`; honours `SCAN_WORKERS`) and
  [`rigorous/probe_lf.py`](rigorous/probe_lf.py) (the `Σ Lf` error budget; honours
  `PROBE_WORKERS`).
* No claim about RH; only the finite window `½ < Im < 15`, plus five individual
  zeros, is certified.
* Logs under `rigorous/` and `verify/` record the paths of the source round
  (`rounds/rh45/…`); the scripts themselves are path-independent.
