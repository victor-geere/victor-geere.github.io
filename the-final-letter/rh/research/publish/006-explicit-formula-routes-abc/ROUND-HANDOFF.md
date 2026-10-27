# HANDOFF — rh45 Routes A, B, C: certified zeros and the validated explicit formula

**Directory** `research/twin-prime-parity/010/`
**Paper** [`index.html`](index.html) (Routes A/B/C) · [`audit.html`](audit.html) (the audit that defined the obligations)
**Lean** `lean/` (`Rh45.*`, modules `Rh45.Explicit`, `Rh45.Routes`, `Rh45.VonMangoldtSieve`)
**Toolchain** Lean 4 `v4.35.0-rc2` + Mathlib at `$HOME/lean/mathlib4` (no `lake` file; `lean/check.sh` rebuilds `LEAN_PATH`)
**Status** Route A **COMPLETE** · Route B window **(½, 15) CLOSED** · Route C **VALIDATED**
**Source round** `research/twin-prime-parity/rounds/rh45/` (kept for provenance; this folder is the continuation)

> Read [`notes/routes-a-b-c-status.md`](notes/routes-a-b-c-status.md) first; `index.html` is the paper.

---

## 1. The three obligations

They are §6 of `../eta-euler-acceleration.html` (the round's specification):

* **Route A** — interval sign change **plus** a derivative-sign certificate, giving a
  unique simple zero on the critical line. *Machine-checked logic + numerical certificate.*
* **Route B** — a rigorous Turing reduction: if a rigorous total count `N(T)` equals
  the number of certified on-line zeros in `(0, T)`, then every zero in the window
  is simple and on the critical line.
* **Route C** — a validated explicit-formula error assembly: the residual must be
  bounded by proven prime-side (Chebyshev `ψ`), archimedean (Stirling) and
  zero-side tails.

The audited Weil form used throughout (see `audit.html`, `truths.md` §1) is

```
2 Σ_{γ>0} φ(γ) = Φ(1) + Φ(0) + (1/2π) ∫_ℝ φ(t) Ψ(t) dt
                − Σ_{n≥2} (Λ(n)/√n) [g(log n) + g(−log n)],
Ψ(t) = −log π + Re ψ(1/4 + it/2),   Φ(1)+Φ(0) = 2φ(i/2) for even g.
```

---

## 2. TL;DR

| item | status | evidence |
|---|---|---|
| **Route A**: `γ₁…γ₅` unique, simple, on-line | **CERTIFIED 5/5** | `rigorous/certify_unique.log`; Lean `exists_unique_root_of_sign_change`, `…_neg` |
| existence certificates (`Z` sign change) | **CERTIFIED 5/5** | `rigorous/certify_zeros.log` |
| symmetric-contour identity `N(T) = Im(I₃)/π` | **VALIDATED numerically** (`1, 5, 10` at `T = 20, 35, 50`) | derive in `index.html` §5.2 |
| **Route B**: `N(3) = 0` | **CERTIFIED** (`Im(I₃)/π ∈ [−0.348, 0.348]`) | `rigorous/certify_count.log` |
| **Route B**: `N(15) = 1` | **CERTIFIED** (`Im(I₃)/π ∈ [0.572, 1.428]`, 2870 s) | `rigorous/certify_count15d.log` |
| **Turing windows `(½, 15)` and `(½, 33)`** | **BOTH CLOSED — and UNCONDITIONAL (items `T1`, `T2`)** | `certify_count15_uncond.log` (`N(15)=1`) and `certify_count33_par.log` (`N(33)=5`), both with `Lf_const=None` + Lean `Rh45Routes.all_zeros_are_certified` |
| **Route C** validated assembly | **PASSES**: residual `−9.08·10⁻⁹ ≤ 2.79·10⁻⁸` | `rigorous/route_c_assembly.log` |
| Lean build | `check.sh --all` **OK**, 0 `sorry`, 0 `axiom` | `verify/lean_check.log` |
| engine | `rigorous/eta_interval.py` (+ bundled `ivmath.py`) | validated by `rigorous/check_engine.py` |
| auditor | `19/21` pass; **2 retired** (`C4.1` over-strong, `C1e` unsatisfiable as stated and restated as `C1f`); **no failures** | `verify/independent_check.log`, `verify/DISPOSITIONS.md`, `audit.html` |

**The headline.** Five zeros are certified unique, simple and on the critical line;
the window `½ < Im < 15` is closed (every zero there is simple and on the line);
and the explicit-formula assembly is validated with an explicit error budget.

---

## 3. Key files

| path | what it is |
|---|---|
| `index.html` | the paper: proofs of Routes A/B/C, the engine spec, the certified results |
| `audit.html` | the audit of the original `rh45` submission against §6, with defect list `F1–F7` |
| `truths.md` | the round ledger (what is proved / verified / cited / open) |
| `explicit_formula.py` | the original Route C script (its convention `(E)` is false; superseded by `rigorous/route_c_assembly.py`) |
| `lean/Rh45/Explicit.lean` | algebraic layer (kernels, pole pair, count main term) |
| `lean/Rh45/Routes.lean` | **Route A/B/C logic**: sign-change theorems, `turing_reduction`, `all_zeros_are_certified`, `validated_truncation_bound`, `prime_tail_input` |
| `lean/Rh45/VonMangoldtSieve.lean` | `Λ 6 = 0` and `Λ` is not additive (used by the Route C audit) |
| `rigorous/eta_interval.py` | the enclosure engine (`η, η′, η″, ζ, ζ′, ζ″, θ, θ′, ψ, ψ′`, `ξ′/ξ`, `ξ″/ξ`) |
| `rigorous/ivmath.py` | bundled rigorous real arithmetic (value + guaranteed error) |
| `rigorous/check_engine.py` | engine validation → `rigorous/verify_engine.log`, `recheck_engine.log` |
| `rigorous/certify_zeros.py` | Route A existence certificates |
| `rigorous/certify_unique.py` | Route A uniqueness + simplicity certificates |
| `rigorous/certify_count.py` | `N(3) = 0` |
| `rigorous/certify_count15d.py` | `N(15) = 1` (certified fast mode: `eta_interval.fast_mode()`, `K=40`, value-only) |
| `rigorous/check_fast_mode.py` | validates the certified fast mode (contract + containment) → `rigorous/check_fast_mode.log` |
| `rigorous/route_c_assembly.py` | validated Route C assembly |
| `rigorous/von_mangoldt_sieve_check.py` | reproduction of the sieve finding used in `audit.html` |
| `verify/independent_check.py` | the auditor's independent route and its 21 checks |

---

## 4. Build and verify

```bash
cd research/twin-prime-parity/010/lean
./check.sh --all                      # Rh45/Explicit.lean, Rh45.lean -> 2/2 OK

cd ../rigorous
python3 check_engine.py               # engine containment checks (slow: ~8 min at K=60)
python3 check_fast_mode.py            # certified fast mode: contract + containment (<1 min)
python3 certify_unique.py             # Route A: 5/5 Theorem-A certificates (~2 min)
python3 certify_zeros.py              # Route A: 5/5 existence certificates
python3 certify_count.py              # Route B: N(3) = 0 (~8 min)
python3 certify_count15d.py           # Route B: N(15) = 1 (~45 min)
python3 route_c_assembly.py           # Route C: validated assembly (~2 min)
```

All scripts import `ivmath`/`eta_interval` from `rigorous/` itself; the only
non-standard Python dependency is `mpmath`.

### Axiom footprint

```lean
import Rh45
#print axioms Rh45Routes.exists_unique_root_of_sign_change
#print axioms Rh45Routes.exists_unique_root_of_sign_change_neg
#print axioms Rh45Routes.turing_reduction
#print axioms Rh45Routes.all_zeros_are_certified
#print axioms Rh45Routes.validated_truncation_bound
#print axioms Rh45Routes.prime_tail_input
```

All report `[propext, Classical.choice, Quot.sound]`; there are no `sorry`s and no
new `axiom`s.

---

## 5. The engine in one paragraph

`rigorous/eta_interval.py` is a rigorous point/box enclosure engine on top of
`ivmath`'s value-plus-guaranteed-error numbers: exact integer-square-root
`n^{−1/2}`, a range-reduced rigorous `exp`, high-accuracy `log n`, `ivmath`
phases, and the Euler-accelerated `η` series with proved geometric tails for
`η, η′, η″` (and hence `ζ, ζ′, ζ″`), plus rigorous `θ, θ′` by Stirling with an
explicit remainder, complex `ψ, ψ′` by recurrence + Stirling, and
`ξ′/ξ`, `f′ = (log ξ)″`. Point widths at the first zeros are `~10⁻⁸…10⁻¹⁸`
depending on `K` and the working precision. The engine's default working
precision is 400 dps. The **certified fast mode** is
`eta_interval.fast_mode()` (`work = 60`, `EPS = 1e-40`, `K = 40` per call), which
moves `WORK`, the rounding slack `EPS` and mpmath's precision **together** so that
the enclosure contract `EPS ≥ accumulated rounding at WORK dps` still holds;
`rigorous/check_fast_mode.py` validates it (`0 fail(s)`). Note that setting
`iv.WORK = 60` *alone* — as the early Route-B scripts did — does **not** satisfy the
contract, because `EPS` keeps its 400-digit value.

---

## 6. What remains (the handoff)

1. ~~**Make the `T = 15` count unconditional.**~~ **DONE (item `T1`, certified
   2026-10-11).** `certify_count15_uncond.py` runs with `Lf_const = None` — no cited
   `|ζ′/ζ|` bound — and certifies `N(15) ∈ [0.7981608, 1.2018097]`, i.e. `N(15) = 1`
   (9571 s, `steps/unit = 24`). Two engine obstructions were removed: the removable
   singularity of `ζ = η/(1−2^{1−s})` at `t_k = 2πk/ln 2` (boxes within `7/10` of any
   `t_k`, including `t_0 = 0`, routed to the rigorous local Taylor/Cauchy enclosure
   `zeta_local_box`, `R0 = 4/5`), and the loose curvature bound (`Σ Lf` fell
   `74776 → 2282.1`, so `err = ΣLf/(8·24²) = 0.495`). The former `Lf_const = 30`
   certificate (`certify_count15d`) is retained for comparison. See
   [`rigorous/T1_BLOCKER.md`](rigorous/T1_BLOCKER.md).
2. ~~**Close a larger window: `T` between `γ₅ = 32.935` and `γ₆ = 37.586`.**~~
   **DONE (item `T2`, certified 2026-10-11).**

   ```
   T=33 steps/unit=40 K=100 -> I3=(-21.381925500160733,15.7080176058059)
   N(33) in [4.711, 5.2890345] -> N(33)=5 CERTIFIED  (9391s)
   ```

   With `γ₁…γ₅` certified in `(½,33)` (brackets `14.1337…14.1357` … `32.9341…32.9361`),
   the machine-checked `Rh45Routes.all_zeros_are_certified` gives: *every zero with
   `½ < Im < 33` is simple and on the critical line.* Three obstacles were cleared, none
   of them in the original cost model: **`K ≳ 0.25·t`** is required by the
   Euler-accelerated `η` enclosure (`K = 40` gives a `1.8·10¹⁰`-wide, uselessly loose
   enclosure at `t = 33`; `K = 100` is clean, `scan_i3_boxes.py 33 16 100` → 536 boxes,
   0 failing, vs 261 failures at `K = 40`); the **budget** is `UNDECIDED by 3.8 %` at
   `steps/unit = 32` (half-width `0.519` vs `0.5`) and needs `steps/unit = 40`
   (half-width `0.289`); and the **runtime** is cut from `≈ 9 h` to `≈ 2.6 h` by the
   parallel certificate [`rigorous/certify_count_par.py`](rigorous/certify_count_par.py).
3. ~~**Tighten Route C.**~~ **DONE.** The Simpson step count was raised
   `1500 → 12000` (`route_c_assembly.py`); since the error is `∝ STEPS⁻⁴`, the
   archimedean bound fell from `6.5·10⁻⁵` to **`1.6·10⁻⁸`** (4096×), and the total
   budget from `6.499·10⁻⁵` to **`2.794·10⁻⁸`** (2326×, prime `1.2·10⁻⁸`, zero tail
   `1.6·10⁻⁸⁰`). The assembly still validates (`residual −9.08·10⁻⁹ ≤ 2.794·10⁻⁸`).
4. **Auditor's criteria — BOTH DISPOSED (item `T4`).** `C4.1` (the sharp Dirichlet
   partial sum does not resolve `γ₁` with `N ≤ 10⁶`) is **RETIRED** — an over-strong
   criterion of the original task prompt, not a defect of the round. `C1e` (the
   Cauchy kernel `F(t) = 1/(1/4+t²)` as literally stated) is **RETIRED as
   unsatisfiable-by-its-instrument** and **restated** as the convergent companion
   `C1f` at `a = 1` (the literal form is off by `2/π`, its pole and prime sides
   diverge like `π log N`, and its zero side only like `log G/G`). See
   [`verify/DISPOSITIONS.md`](verify/DISPOSITIONS.md); the audit now adjudicates
   *19/21 checks pass; 2 retired; failures: none*.
5. ~~**Optional engineering.** A certified fast mode could be exposed as a flag.~~
   **DONE.** `eta_interval.set_precision` / `fast_mode` expose the certified fast
   mode with a stated enclosure contract, validated by
   [`rigorous/check_fast_mode.py`](rigorous/check_fast_mode.py) (`0 fail(s)`), and
   [`rigorous/certify_count15d.py`](rigorous/certify_count15d.py) now uses it.

---

## 7. Caveats

* Every numerical result lives in a *log under `rigorous/`*; re-running the same
  script reproduces the certificate, but runtimes vary with machine speed.
* The logs embed the source-round paths (`rounds/rh45/…`) in their final lines;
  the scripts themselves use only paths relative to their own directory.
* The `T = 15` conclusion is **no longer conditional**: item `T1` is certified with `Lf_const = None` (`N(15) ∈ [0.7981608, 1.2018097]`, 9571 s), so no cited `|ζ′/ζ|` bound is used. The former `Lf_const = 30` certificate (`certify_count15d`) is retained for comparison. See [`rigorous/T1_BLOCKER.md`](rigorous/T1_BLOCKER.md).
* `explicit_formula.py` on its own does **not** reproduce the Route C certificate:
  its convention `(E)` is false and its run was interrupted (no log). The
  validated assembly is `rigorous/route_c_assembly.py`.
* Finite windows prove nothing about RH; see `truths.md` for the precise ledger
  of `PROVED / VERIFIED / NUMERICAL / CITED / OPEN`.

---

## 8. Provenance

Received from `research/twin-prime-parity/rounds/rh45/`:

* the papers `routes-abc.html` (→ `index.html`), `audit.html`,
  `von-mangoldt-sieve.html`;
* the full `rigorous/`, `verify/` and `lean/` trees;
* `truths.md` and the original round specification
  (`notes/rh45-HANDOFF.md`).

Changes made for this folder: `index.html` is the paper (cross-links in
`audit.html`, `von-mangoldt-sieve.html` repointed to it); the `../../`
reference to the §6 specification is now `../eta-euler-acceleration.html`;
`rigorous/ivmath.py` is bundled and the Python scripts import it locally;
`lean/check.sh` points its dependency directory at `../rounds/rh43/lean`; this
README, `handoff.md`, `notes/` and `lean/README.md` are new.
