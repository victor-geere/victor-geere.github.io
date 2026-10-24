# Sinc, sine kernel, moments — research programme

**Status:** finite formal core and exact computation layer reconstructed. The archived
zeta/random-matrix claims are recorded as **Source claim** or **Open / conjecture**, never as
theorems of this reconstruction.
**Source:** [`archive/essays/sinc-zeta.html`](../../archive/essays/sinc-zeta.html), with the
companion essays [`kosters-zeta-moments-sinc.html`](../../archive/essays/kosters-zeta-moments-sinc.html)
and [`shifted-moments-l-theta.html`](../../archive/essays/shifted-moments-l-theta.html).
**Inventory:** [Scraps](../../scraps.html) item 42 · [Topic index](../README.md).

## Provenance and what the source actually is

The three archived essays are short AI-generated expository surveys (the first is attributed to
Grok 3). They assemble standard material: the definition of the normalised sinc function, the
sine kernel, Montgomery's pair-correlation conjecture, Kösters' 2008 shifted-moment theorem, and
GRH-conditional bounds for shifted moments of `L`-functions and moments of theta functions.

The archive does **not** contain a new proof, a self-contained definition–theorem development, or
a calculation specific to this repository. Its value for a programme is therefore the finite
kernel and bookkeeping layer that surrounds the zeta asymptotics. That layer is what is
reconstructed here:

- the normalised sinc and its elementary values and symmetry;
- the sine kernel `K(x,y) = sinc(x−y)` and the Montgomery factor `1 − sinc²`;
- the phase-times-sinc factor in Kösters' kernel;
- a finite shifted-moment matrix and its Hermitian bookkeeping;
- the even Taylor moments of sinc.

Everything asymptotic — zeta zeros, pair correlation, GUE statistics, Kösters' limit theorem,
GRH-conditional bounds — remains outside the formal core.

### A normalisation inconsistency in the source

The source defines

\[
\operatorname{sinc}(x)=\frac{\sin(\pi x)}{\pi x}\quad(x\ne 0),\qquad \operatorname{sinc}(0)=1,
\]

but then quotes Kösters' second-moment limit as
`e^{−iπ(μ−ν)} · sinc(π(μ−ν))`. Under the stated definition the second factor would be
`sin(π²(μ−ν))/(π²(μ−ν))`, not the sine kernel. The intended factor is the normalised
`sin(π(μ−ν))/(π(μ−ν))`. This reconstruction formalises the normalised kernel `sincN` and records
the source's displayed expression as a **Source claim** with an ambiguity note; it does not
silently repair the archive.

## Reconstructed objects and notation

| Object | Definition | Role |
|---|---|---|
| Normalised sinc | `sincN x = sin(πx)/(πx)` for `x ≠ 0`, `sincN 0 = 1` | The source's `sinc` |
| Sine kernel | `K(x,y) = sincN(x − y)` | Pair-correlation kernel |
| Montgomery factor | `F(α) = 1 − sincN(α)²` | The source's `1 − (sin πα / πα)²` |
| Kösters kernel | `Köst(μ,ν) = exp(−iπ(μ−ν)) · sincN(μ−ν)` | Phase-times-sinc factor |
| Shifted-moment matrix | `M[j,k] = Köst(μ_j, μ_k)` for finite shifts `μ_0,…,μ_{n−1}` | Finite bookkeeping, not a zeta moment |
| Sinc Taylor moment | `c_k = (−1)^k π^{2k}/(2k+1)!` | Coefficient of `x^{2k}` in `sincN` |

The Python layer uses the same names in snake case (`sinc`, `sine_kernel`, `montgomery_F`,
`kosters_kernel`, `shifted_moment_matrix`, `sinc_taylor_coeff`).

## Theorem ledger

A row is marked **Theorem** only when [`lean/Topic.lean`](lean/Topic.lean) proves it with no
`sorry`, `axiom`, or `admit`. A row is marked **Computation** only when
[`tests/test_programme.py`](tests/test_programme.py) tests it. Source claims and open items are
not theorems of this reconstruction.

| # | Kind | Statement | Evidence / archived status |
|---|---|---|---|
| T1 | Theorem | `sincN 0 = 1` | `SincKernel.sincN_zero` |
| T2 | Theorem | `sincN (1/2) = 2/π` | `SincKernel.sincN_half` |
| T3 | Theorem | `sincN n = 0` for every non-zero integer `n` | `SincKernel.sincN_int_eq_zero` |
| T4 | Theorem | `0 < sincN x` for `0 < x < 1` | `SincKernel.sincN_pos_of_mem_Ioo` |
| T5 | Theorem | `K(x,y) = K(y,x)` (sine-kernel symmetry) | `SincKernel.sineKernel_comm` |
| T6 | Theorem | `0 ≤ 1 − sincN(α)²` (Montgomery factor non-negative) | `SincKernel.montgomeryF_nonneg` |
| T7 | Theorem | `‖Köst(μ,ν)‖ = |sincN(μ−ν)|` (the phase factor has unit modulus) | `SincKernel.kostersKernel_norm` |
| C1 | Computation | `sinc(0)=1`, `sinc(1/2)=2/π`, `sinc(1)=sinc(−3)=0`, and `sinc` is even | `test_sinc_edge_cases` |
| C2 | Computation | `K(x,x)=1` and `K(x,y)=K(y,x)` symbolically | `test_sine_kernel_diagonal_and_symmetry` |
| C3 | Computation | `F(0)=0`, `F(1)=1`, `F(1/2)=1−4/π²`, and `F ≥ 0` on a rational grid | `test_montgomery_factor_values_and_nonnegativity` |
| C4 | Computation | The exact even Taylor moments of `sinc` agree with sympy's series through order 8 | `test_sinc_taylor_moments` |
| C5 | Computation | Negative Taylor orders are rejected (edge case) | `test_invalid_taylor_orders_raise` |
| C6 | Computation | `Köst(μ,μ)=1` and `|Köst(μ,ν)|² = sincN(μ−ν)²` | `test_kosters_kernel_diagonal_and_modulus_squared` |
| C7 | Computation | A finite shifted-moment matrix is Hermitian, has unit diagonal, and has the expected modulus on each entry | `test_shifted_moment_bookkeeping` |
| C8 | Computation | `sincN x > 0` on a rational grid in `(0,1)` | `test_sinc_positivity_on_open_unit_interval` |
| S1 | Source claim | The Riemann hypothesis: all non-trivial zeros of `ζ` lie on `Re(s)=1/2` | Archived expository assertion; **open**, not proved here |
| S2 | Source claim | Montgomery's pair-correlation conjecture: zeta-zero statistics match the GUE/sine-kernel prediction | Archived conjecture; **open** |
| S3 | Source claim | Kösters' Theorem 1.1: the second shifted-moment limit is `e^{−iπ(μ−ν)} sinc(π(μ−ν))` | Published theorem cited by the archive; not formalised, and the archive's sinc normalisation is ambiguous |
| S4 | Source claim | Kösters' Theorem 1.2: the fourth moment has a related `sin²(x/2)` expression | Published theorem cited by the archive; not formalised |
| S5 | Source claim | Kösters' Conjecture 1.3 / CFKRS: the sine kernel persists in higher even moments | Archived conjecture; **open** |
| S6 | Source claim | Under GRH, shifted moments of `L`-functions bound moments of theta functions (Munsch–Shparlinski, Chandee, Ng) | Cited conditional results; not formalised |
| S7 | Source claim | The sine kernel in shifted moments constrains primes in short intervals | Speculative interpretation in the archive; no precise statement |
| O1 | Open / conjecture | A precise finite statement of Montgomery pair correlation suitable for formalisation | Needs zeta-zero counting and a limit theorem |
| O2 | Open / conjecture | Kösters' asymptotic theorem for second and fourth shifted moments | Needs contour integration and zeta asymptotics |
| O3 | Open / conjecture | Determinantal/GUE statistics of the sine kernel | Needs random-matrix probability theory |
| O4 | Open / conjecture | Positive semidefiniteness of infinite shifted-moment kernels | Only finite Hermitian bookkeeping is proved (C7) |
| O5 | Open / conjecture | The intended normalisation of the source's `sinc(π(μ−ν))` expression | Textual ambiguity; resolved here by formalising `sincN` |

## Python layer

[`python/programme.py`](python/programme.py) implements exact sympy mathematics:

- `sinc(x)` — piecewise normalised sinc;
- `sine_kernel(x, y)`;
- `montgomery_F(alpha)`;
- `kosters_kernel(mu, nu)`;
- `shifted_moment_matrix(shifts)` and `moment_ledger(shifts)`;
- `sinc_taylor_coeff(k)`, `sinc_taylor_polynomial(x, n)`, `sinc_series(x, n)`.

Numerical checks use sympy's `N(..., 40)` with explicitly stated tolerances; `mpmath` is not
needed. The module has no import side effects.

Run the suite:

```bash
cd the-final-letter/topics/sinc-sine-kernel-moments
python3 -m pytest -q tests
```

Current result: **8 passed** (about 5 s). Use the module directly with:

```bash
python3 - <<'PY'
import sys; sys.path.insert(0, "python")
from programme import sinc, sine_kernel, montgomery_F
print(sinc(0), sine_kernel(2, 2), montgomery_F(0))
PY
```

## Lean layer

[`lean/Topic.lean`](lean/Topic.lean) imports Mathlib and works in `namespace SincKernel`. It
defines `sincN`, `sineKernel`, `montgomeryF`, and `kostersKernel`, and proves T1–T7. There is no
`sorry`, no `axiom`, and no `admit`. [`lean/README.md`](lean/README.md) lists what is and is not
formalised.

```bash
cd the-final-letter/topics/sinc-sine-kernel-moments
./lean/check.sh
```

Recorded build: [`lean/BUILD.log`](lean/BUILD.log) — `[check] OK Topic.lean`.

## Open items and known gaps

1. **Montgomery pair correlation.** The source states the conjecture but gives no precise
   counting statement. A formal version needs the zero-counting function and a limit over test
   functions; it is not attempted here.
2. **Kösters' theorem.** The second- and fourth-moment asymptotics are cited, not proved. They
   require the analytic theory of `ζ` and contour integrals far beyond the finite kernel layer.
3. **GUE / random-matrix statistics.** The finite sine kernel is formalised; the determinantal
   point process and its spacing statistics are not.
4. **Infinite moment matrices.** C7 proves finite Hermitian bookkeeping only. Positive
   semidefiniteness of an infinite shifted-moment kernel is left open.
5. **Source normalisation.** The archive's `sinc(π(μ−ν))` conflicts with its own definition of
   `sinc`; the reconstruction uses the normalised kernel and records the discrepancy.
6. **No zeta content in Lean.** The Lean file deliberately says nothing about `ζ`, its zeros, the
   Riemann hypothesis, or primes.

## Provenance

- [`scraps.html`](../../scraps.html) — inventory entry 42.
- [`archive/essays/sinc-zeta.html`](../../archive/essays/sinc-zeta.html) — primary source.
- [`archive/essays/kosters-zeta-moments-sinc.html`](../../archive/essays/kosters-zeta-moments-sinc.html)
  and [`archive/essays/shifted-moments-l-theta.html`](../../archive/essays/shifted-moments-l-theta.html)
  — companion source essays.
- [`topics/README.md`](../README.md) — all topic folders.
- [`the-final-letter/index.html`](../../index.html) — programme index.

[Back to the topic index](../README.md) · [Scraps](../../scraps.html) · [The Final Letter](../../index.html)
