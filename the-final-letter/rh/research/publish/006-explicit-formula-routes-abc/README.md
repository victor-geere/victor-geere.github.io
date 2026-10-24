# publish/006 — The explicit formula and Routes A / B / C

Sixth published edition. This folder packages **item §6 of `research/truths.md`**: the
corrected **Weil explicit formula** (with its archimedean term), the three verification
routes **A** (uniqueness and simplicity of a zero), **B** (the Turing reduction), and
**C** (the validated truncation assembly), and the numerical certificates that make the
zero counts unconditional in the windows `½ < Im < 15` and `½ < Im < 33`.

## What the item is

The programme's instrument for extracting zero information from `ζ` is the explicit
formula. A first draft used the wrong convention; the corrected form is the one used
throughout here.

**The three routes.**

* **Route A — uniqueness and simplicity.** If `f` is continuous with `f′ > 0` on `(a,b)`
  and `f a < 0 < f b`, then `f` has a unique simple root in `(a,b)`; there is a mirror
  form for `f′ < 0`, and an enclosure form that discharges the hypotheses from interval
  bounds. This is what turns a certified bracket into a certified *simple zero*.
* **Route B — the Turing reduction.** If the certified zeros are a subset of the true
  zeros and the true zeros (in the window) are no more numerous than the certified ones,
  then the two sets are *equal*. Packaged, this says: every zero in the window is
  certified.
* **Route C — the error assembly.** The residual is bounded by the sum of the three
  tails (prime, archimedean, zero); the prime input is Chebyshev's
  `ψ(x) ≤ (log 4 + 4)x`.

**The headline numerical results.**

| Result | Value |
|---|---|
| `γ₁…γ₅` located from `ζ` alone | VERIFIED, 32–33 digits |
| `γ₁…γ₅` unique, simple, on the critical line | **CERTIFIED**, 5/5 |
| `N(3) = 0`, `N(15) = 1` | **CERTIFIED** |
| every zero with `½ < Im < 15` is simple and on the critical line | **CERTIFIED, UNCONDITIONAL** — `N(15) ∈ [0.7981608, 1.2018097]`, with `Lf_const = None` |
| every zero with `½ < Im < 33` is simple and on the critical line | **CERTIFIED, UNCONDITIONAL** — `N(33) ∈ [4.711, 5.2890345]`, `K = 100`, `steps/unit = 40` |
| Route C assembly | **VALIDATED** — residual `−9.08·10⁻⁹ ≤ 2.79·10⁻⁸` on the modulated Gaussian |
| admissible kernel (**T6**) | **FOUND** — the compact bump has `\|LHS\| = 2.0`, `RHS − LHS = −7.24·10⁻⁵⁴` |

**The two engine obstructions that had to be removed for the unconditional count.**
`ζ = η/(1 − 2^{1−s})` is singular on the `Re s = 1` edge at `t_k = 2πk/log 2`, including
`t_0 = 0`; boxes near a `t_k` are routed to a rigorous local Taylor/Cauchy enclosure
(`zeta_local_box`). And the curvature bound had to be enclosed per step rather than
cited, which brought `Σ Lf` from `74776` down to `2282.1`.

## Contents

| Path | What it is |
|---|---|
| [`TRUTHS.md`](TRUTHS.md) | **The item**: the §6 ledger from `research/truths.md`, links re-pointed into this folder. |
| [`ROUND-README.md`](ROUND-README.md) | The round's own orientation: Routes A/B/C, the Turing window, the certificate list. |
| [`ROUND-TRUTHS.md`](ROUND-TRUTHS.md), [`ROUND-HANDOFF.md`](ROUND-HANDOFF.md) | The round's truth table and handoff, for provenance. |
| [`notes/routes-a-b-c-status.md`](notes/routes-a-b-c-status.md) | The per-route status note: what each route still needs. |
| [`notes/rh45-HANDOFF.md`](notes/rh45-HANDOFF.md) | The `rh45` handoff. |
| [`Rh45/Routes.lean`](Rh45/Routes.lean) | The three routes: root existence/uniqueness/simplicity, the Turing reduction, the truncation bound, and the Chebyshev prime input. |
| [`Rh45/Explicit.lean`](Rh45/Explicit.lean) | The algebraic layer of the explicit formula: kernel evenness/positivity, `s ↔ 1−s` symmetry, pole-pair collapse, prime-side splitting, the main term. |
| [`Rh45/Archimedean.lean`](Rh45/Archimedean.lean) | The archimedean term `Ψ(t) = −log π + Re ψ(1/4 + it/2)`: continuity, the recurrence/reflection on the digamma line, the chain rule, the Leibniz bound and the composite-Simpson assembly. |
| [`Rh45/RouteBAnalytic.lean`](Rh45/RouteBAnalytic.lean) | The analytic content of Route B: `ξ(1−s) = ξ(s)`, the log-derivative symmetries, the contour reduction `∮ = I₃ − conj I₃ = 2i·Im I₃`, and `Im(I₃) = πZ`. |
| [`Rh45/VonMangoldtSieve.lean`](Rh45/VonMangoldtSieve.lean) | The von Mangoldt sieve bug: `Λ 6 = 0`, and `Λ` is not additive. |
| [`Rh45.lean`](Rh45.lean), [`check.sh`](check.sh) | Root module and build script. |
| [`rigorous/`](rigorous) | The engine and its certificates: `eta_interval.py` + `ivmath.py` (the interval engine), `check_engine.py`, `check_fast_mode.py`, `zeta_singularity.py`, the `certify_*` certificate drivers (`certify_unique`, `certify_count15_uncond`, `certify_count33_par`, `certify_zeros`, …), the probes (`probe_lf.py`, `scan_i3_boxes.py`, `kernel_probe.py`), `route_c_assembly.py`, and the recorded `.log` files. The two write-ups [`KERNEL_FINDINGS.md`](rigorous/KERNEL_FINDINGS.md) and [`T1_BLOCKER.md`](rigorous/T1_BLOCKER.md) (now a success note) sit here. |
| [`verify/`](verify) | The independent check, the auditor's [`DISPOSITIONS.md`](verify/DISPOSITIONS.md) (which retires checks `C4.1` and `C1e`), and the recorded logs. |
| [`explicit_formula.py`](explicit_formula.py) | The early explicit-formula script. Its convention is **false** and it is superseded by `rigorous/route_c_assembly.py`; kept for the record. |
| [`index.html`](index.html), [`audit.html`](audit.html) | The rendered round page and audit. |

## What is proved, and what is not

* **Proved in Lean** — the three routes (see the module list above); the von Mangoldt
  sieve witnesses; the algebraic layer of the explicit formula; the archimedean term
  (with **two named hypotheses** for Mathlib gaps: the digamma series estimate and the
  single-panel Simpson error); and the Route B analytic layer (with **two further named
  hypotheses**: the rectangle argument principle, which Mathlib lacks, and
  `ξ(conj s) = conj(ξ s)`).
* **Certified numerically** — the zero brackets, the two Turing windows, and the Route C
  assembly.
* **A finding, not a theorem** — the paper's `k = 0` digamma bound is **vacuous**
  (`Σ 1/(1/4 + j)` diverges); the Lean development therefore proves the recurrence
  route instead.
* **Refuted** — "smoothing removes the `√N`" in the sibling round; here, the auditor's
  criteria `C4.1` and `C1e` are **retired by disposition** (`C1e` restated as the
  convergent companion `C1f`). Full adjudication: *19/21 checks pass; 2 retired;
  failures: none*.
* **Not claimed** — anything about RH. Only the finite windows and five individual zeros.

## Running the checks

```sh
./check.sh --all                    # Lean 4 + Mathlib, 6 files, exits 0

cd rigorous
python3 check_engine.py             # re-validate the interval engine (0 fail(s))
python3 check_fast_mode.py          # the fast_mode enclosure contract (0 fail(s))
python3 zeta_singularity.py         # the singularity routing
python3 certify_count15_uncond.py   # the unconditional T = 15 count (~2.7 h)
python3 certify_count33_par.py 33 40 100 8   # the parallel T = 33 certificate (~2.6 h)
python3 route_c_assembly.py         # the Route C assembly
```

The certificate drivers are long-running: `certify_count15_uncond.py` took 9571 s and
the parallel `T = 33` run 9391 s on 8 workers. The recorded outputs are in
`rigorous/*.log`, so re-running is optional. `probe_lf.py` and `scan_i3_boxes.py` honour
`PROBE_WORKERS` / `SCAN_WORKERS`.

## Dependencies

Everything needed is in this folder. The only external dependencies are **Mathlib**
(Lean) and, for the numerics, **mpmath** (the interval engine and the certificates are
otherwise standard library).

## Provenance

Produced in the programme's round `rh45` and its folder `010`; see `research/truths.md`
§6. Sources are reproduced unmodified except that markdown links have been re-pointed
into this folder. `T1_BLOCKER.md` keeps its name so that existing references stay valid,
but it now documents the resolution rather than the obstruction.
