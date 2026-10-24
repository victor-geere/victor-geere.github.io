# Routes A, B, C — technical status

Round `010`, received from `rounds/rh45`. This note is the technical companion to
[`../handoff.md`](../handoff.md) and [`../index.html`](../index.html).

---

> **ERRATUM (2026-10-12).** Two soundness bugs were found in the interval primitives
> [`eta_interval.exp_num`](../../../publish/013-twin-prime-parity-explicit-function/python/eta_interval.py) and
> [`eta_interval.ndef`](../../../publish/013-twin-prime-parity-explicit-function/python/eta_interval.py) (the latter feeds every complex division).
> Both are **fixed**, with regression tests [`check_exp_num.py`](../../../publish/013-twin-prime-parity-explicit-function/python/check_exp_num.py) and
> [`check_ndef.py`](../../../publish/013-twin-prime-parity-explicit-function/python/check_ndef.py); see
> [`rigorous/EXP_NUM_ERRATUM.md`](../../../publish/013-twin-prime-parity-explicit-function/notes/010-EXP_NUM_ERRATUM.md). **Route A and Route C are
> unaffected** (point sigma / no box path). The **Route B counts below are affected** — their
> curvature bounds came from box enclosures — and must be **re-run** before being quoted as
> rigorous. The conclusions may well survive (both runs had 1.7x–2.5x headroom) but that is an
> estimate, not a proof.

## 0. Where the obligations come from

§6 of [`../../eta-euler-acceleration.html`](../../eta-euler-acceleration.html)
(fourth-tier acceleration of `η`) asks for a way to certify zeros of `ζ` without
relying on the partial sums that fail to resolve them. The audit in
[`../audit.html`](../audit.html) fixed the exact form of the explicit formula and
listed the defects `F1–F7` of the first `rh45` draft; Routes A/B/C are the
response. The clean Weil form (audited; residual `≲ 10⁻⁴⁵` on smooth kernels) is

```
Σ_ρ Φ(ρ) = Φ(1) + Φ(0) − Σ_{n≥2} (Λ(n)/√n)[g(log n) + g(−log n)]
          + (1/2π) ∫_ℝ φ(t) Ψ(t) dt,      Ψ(t) = −log π + Re ψ(1/4 + it/2).
```

with `Φ(s) = φ((s−1/2)/i)`, `φ(t) = ∫ g(u) e^{itu} du`, `g` even.

---

## 1. The engine

`../rigorous/eta_interval.py`, on top of the bundled `../rigorous/ivmath.py`
(value + guaranteed error, 400 dps default, blanket `EPS = 10⁻³²⁰`).

**Ingredients.**

| ingredient | method |
|---|---|
| `n^{−1/2}`, `√2` | exact integer square roots, width `10⁻⁹⁰` |
| `e^y` | range reduction + Taylor with Lagrange remainder (`exp_num`) |
| `log n` | `K = 600` `2·atanh` series, cached (`log_hi`) |
| `n^{−σ}` | `exp(−σ log n)` over the `σ`-interval |
| phases | `ivmath` `cos`/`sin` on intervals |
| `η, η′, η″` | Euler-accelerated series `Σ Δᵏa₀/2^{k+1}` with proved geometric tails from the Hausdorff integral and its `s`-derivatives |
| `ζ, ζ′, ζ″` | quotient rules with `f = 1−2^{1−s}` |
| `θ, θ′` | Stirling series for `log Γ`, explicit remainder `2^{N+1}\|B_{2N+2}\|/((2N+2)(2N+1)\|z\|^{2N+1})` |
| `ψ, ψ′` | recurrence to `\|w\| ≥ 8`, then Stirling with remainder |
| `ξ′/ξ`, `(log ξ)″` | `1/s + 1/(s−1) − ½log π + ½ψ(s/2) + ζ′/ζ`, differentiated |

**Validation.** `check_engine.py` compares every enclosure with `mpmath`
(containment, not accuracy) and prints widths; `verify_engine.log` and
`recheck_engine.log` end in `0 fail(s)` (both re-run and re-archived). Point widths:
`~10⁻⁸` at `K = 60`, down to `~10⁻¹⁸` at `K = 90` on the high-precision path.
The **certified fast mode** (`eta_interval.fast_mode()`, `work = 60`, `EPS = 1e-40`)
is validated by `check_fast_mode.py` (`0 fail(s)`); it moves `WORK` and the rounding
slack `EPS` together, which setting `iv.WORK = 60` alone does not.

**Tails proved** (used by the certificates):

```
|Δᵏ a₀|     ≤ (1/|Γ|) [ x₀^σ/σ + (1−e^{−x₀})ᵏ Γ(σ) ]                      (η)
|Δᵏ b₀|     ≤ (1/|Γ|) [ 5/σ + 1/σ² + ρᵏ (5Γ(σ) + 1) ]                    (η′)
|Δᵏ c₀|     ≤ (1/|Γ|) [ 27/σ + 10/σ² + 2/σ³ + ρᵏ (27Γ(σ) + 13) ]        (η″)
|Γ(1/2+it)| = √(π/cosh πt)
```

---

## 2. Route A — unique simple on-line zeros

**Logic (Lean, `Rh45/Routes.lean`).**

* `exists_unique_root_of_sign_change` — `f` continuous on `[a,b]`,
  `f′ > 0` on `(a,b)`, `f a < 0 < f b` ⟹ a unique simple root in `(a,b)`.
* `exists_unique_root_of_sign_change_neg` — the `f′ < 0` mirror (needed at `γ₂`,
  `γ₄` where `Z′ < 0`).
* `certified_root_of_enclosures` — the same statement in enclosure form.

**Numerics (`rigorous/certify_unique.py`).** For each of `γ₁…γ₁₅` a bracket of
width `10⁻³` is exhibited with **enclosed** `Z(a) < 0 < Z(b)` and an **enclosed
one-signed** `Z′` on the bracket; the latter makes `Z` strictly monotone, so the
root is unique and simple. `certify_zeros.py` records the underlying existence
certificates. Log: `rigorous/certify_unique.log` (`5 / 5`, `exit=0`).

```
γ₁  Z′ ∈ [ 0.766441,  0.819918]
γ₂  Z′ ∈ [−1.17358,  −1.10014]
γ₃  Z′ ∈ [ 1.32035,   1.42321]
γ₄  Z′ ∈ [−1.34866,  −1.25925]
γ₅  Z′ ∈ [ 1.33534,   1.42899]
```

---

## 3. Route B — a rigorous Turing window

**Identity.** Let `ξ(s) = ½ s(s−1) π^{−s/2} Γ(s/2) ζ(s)` and

```
I₃ = ∫_{(½,½)→(1,½)→(1,T)→(½,T)} (ξ′/ξ) ds.
```

Because `ξ(s) = ξ(1−s)` and the rectangle `[0,1]×[½,T]` is symmetric, splitting
`∮∂R ξ′/ξ ds` into halves gives `2 I₃ = 2πi N(T)`, hence

```
N(T) = Im(I₃)/π,      the whole path lying in Re s ∈ [½, 1].
```

`Re s ∈ [½,1]` is exactly the domain on which the engine of §1 is valid; no
functional-equation or `Re s < 0` evaluation is needed. The identity was checked
numerically (mpmath) at `T = 20, 35, 50`, giving `1, 5, 10`.

**Quadrature.** `I3_certificate` uses the midpoint rule with the curvature bound
`|err| ≤ ⅛ |ds|² sup|f′|`, where `f = ξ′/ξ` and `f′ = (log ξ)″
= −1/s² − 1/(s−1)² + ¼ψ′(s/2) + ζ″/ζ − (ζ′/ζ)²`. With a per-path constant
`Lf ≥ sup|f′|` the step can be chosen so that the total budget is `< π/2`.

**Certificates.**

| `T` | configuration | enclosure of `Im(I₃)/π` | result |
|---|---|---|---|
| 3 | `steps/unit 10`, `K 50`, `Lf 25` | `[−0.34815161, 0.34815127]` | `N(3) = 0` |
| 15 | `steps/unit 48`, `K 40`, **fast mode** (`fast_mode()`: work 60, `EPS 1e-40`), value-only, `Lf 30` | `[0.57197018, 1.4279394]` | `N(15) = 1` (2870 s) |

**Turing step.** The certified on-line zeros with `½ < Im < 15` are exactly
`{γ₁}`. Hence `certified ⊆ zeros` and `zeros.card ≤ certified.card = 1 = N(15)`,
so Lean's `Rh45Routes.all_zeros_are_certified` (a packaged `turing_reduction`):

```
every zero with ½ < Im < 15 is simple and on the critical line.
```

---

## 4. Route C — the validated assembly

**Test function.** `g(u) = e^{−u²/2} cos(14u)/√(2π)` (rational centre, so the
kernel is exact), `φ(t) = ½(e^{−(t−14)²/2} + e^{−(t+14)²/2})`.

**Budget.** Each side is enclosed and the residual compared with the sum of the
proved tails:

| side | method | bound |
|---|---|---|
| prime | exact `Λ(n)`, `n ≤ 2000`, `Λ = μ ∗ log`-free sieve; tail `C(Nf(N) + ∫_N^∞ x\|f′\|)`, `ψ(x) ≤ (log 4 + 4)x` | `1.2·10⁻⁸` |
| archimedean | composite Simpson on `[0,30]`, `\|φ^{(k)}\| ≤ 𝔼\|Z\|^k`, `\|Ψ^{(k)}\| ≤ 2^{−k} k! Σ_j (¼+j)^{−k−1}` | `1.6·10⁻⁸` |
| zero | the five certified zeros with their brackets, plus the density tail | `1.6·10⁻⁸⁰` |

**Result.** `RHS − LHS = −9.07873·10⁻⁹ ≤ 2.794·10⁻⁸` →
`|residual| ≤ budget` (`rigorous/route_c_assembly.log`).

**Bugs fixed while validating** (recorded because they shaped the engine): the
von Mangoldt sieve initially computed `log rad` rather than `Λ` (see
`../von-mangoldt-sieve.html`), and `exp_num` on a wide negative interval returned
only its lower endpoint. Both are fixed; `check_engine.py` still passes.

---

## 5. Ledger (summary)

See [`../truths.md`](../truths.md) for the full rows.

| claim | status | evidence |
|---|---|---|
| Route A logic (both signs) | **PROVED** | Lean `exists_unique_root_of_sign_change[_neg]` |
| `γ₁…γ₁₅` unique simple on-line | **CERTIFIED** | `certify_unique.log` (5/5, `K=90`), `certify_unique10.log` (10/10), `certify_unique15.log` (15/15; `K` ladder 90/100/140/180) |
| `N(T) = Im(I₃)/π` | **NUMERICAL** (identity) | `index.html` §5.2 |
| `N(3) = 0`, `N(15) = 1`, `N(33) = 5` | **CERTIFIED** | `certify_count.log`; `certify_count15_uncond.log`; `certify_count33_par.log` |
| Turing windows `(½,15)` and `(½,33)` | **CERTIFIED** | Lean `all_zeros_are_certified` (generic) + the counts |
| Route C tails (prime, archimedean, zero) | **PROVED / CERTIFIED** | Lean `prime_tail_input`, `validated_truncation_bound`, `Rh45.archimedean_deriv_bound`, `Rh45.simpsonPanelEstimate` |
| Route C assembly | **VALIDATED** | `route_c_assembly.log` |
| `sup\|f′\| < 30` on the `I₃` path | **REMOVED** — superseded by a per-step enclosed `Lf` (`T1`, 2026-10-11) | `zeta_local_box`; `certify_count15_uncond.log` |

---

## 6. Open items

1. make the `T = 15` count unconditional (replace `Lf = 30` by a proved bound) —
   ~~**BLOCKED**~~ — **DONE (2026-10-11).** `certify_count15_uncond.py` with
   `Lf_const = None` certifies `N(15) ∈ [0.7981608, 1.2018097]`, i.e. `N(15) = 1`, with no
   cited `|ζ′/ζ|` bound (9571 s). The singularity `ζ = η/(1−2^{1−s})` at `t_k = 2πk/ln 2`
   is handled by routing near-`t_k` boxes to `zeta_local_box`, and the curvature bound was
   tightened (`Σ Lf` `74776 → 2282.1`). See
   [`../rigorous/T1_BLOCKER.md`](../../../publish/006-explicit-formula-routes-abc/rigorous/T1_BLOCKER.md);
2. ~~extend the window to `T = 33` (`N = 5`, covering `γ₁…γ₅`)~~ — **DONE (item `T2`,
   certified 2026-10-11)**: `N(33) ∈ [4.711, 5.2890345]`, i.e. `N(33) = 5`,
   unconditionally. Needed `K = 100` (the Euler acceleration requires `K ≳ 0.25·t`) and
   `steps/unit = 40` (at `32` the run was UNDECIDED by 3.8 %), computed in ≈ 2.6 h by the
   parallel `certify_count_par.py`; log `certify_count33_par.log`;
3. ~~tighten the archimedean term of Route C~~ — **DONE**: Simpson steps `1500 → 12000`
   cut the archimedean bound from `6.5·10⁻⁵` to `1.6·10⁻⁸` and the total budget to
   `2.794·10⁻⁸` (`rigorous/route_c_assembly.log`);
4. the auditor's `C1e` is **RETIRED and restated** as the convergent companion `C1f`
   (unsatisfiable as literally stated — off by `2/π`, divergent pole/prime sides,
   `log G/G` zero side; see [`../verify/DISPOSITIONS.md`](../verify/DISPOSITIONS.md));
   **`C4.1` is RETIRED** as an over-strong criterion of the task prompt;
5. ~~optionally expose a certified fast mode of the engine~~ — **DONE**:
   `eta_interval.fast_mode()` / `set_precision` expose it with the stated enclosure
   contract, validated by [`../rigorous/check_fast_mode.py`](../../../publish/006-explicit-formula-routes-abc/rigorous/check_fast_mode.py)
   (`0 fail(s)`).
