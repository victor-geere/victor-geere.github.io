# Handoff — generating the certified `4×4` Weil Gram assembly in Rust

This document is the bridge between the completed Lean analytic layer and the
numerical `4×4` assembly. It specifies:

1. exactly what the Lean development already proves and what it needs;
2. the mathematical formulas the Rust program must enclose;
3. a Rust crate layout with function signatures and algorithms;
4. the certificate format and the generated Lean file;
5. the acceptance tests and the continuation plan.

> **Implementation status (complete).** The crate is
> [`rust/weil-assembly`](rust/weil-assembly); `lean/Certificate.lean`
> (T91–T100) and `python/rust_certificate.json` are checked in.  `cargo test
> --release` (22 tests), `python3 -m pytest -q tests` (45 tests) and
> `./lean/check.sh` (ten files, including `Certificate.lean`) all pass.  See
> §16 for the deviations from the plan below.

The guiding rule: **Rust may compute, but only rational numbers cross the
boundary.** Every enclosure is emitted as an exact rational interval and the
Lean side re-checks the arithmetic; no floating-point value is trusted.

---

## 1. Where the project stands

Lean (`the-final-letter/topics/intersection-form-zeta/lean/`):

| layer | theorems |
|---|---|
| finite intersection form, Hodge index | T1–T24 |
| rational `γ` interval, width `1.24·10⁻⁵` | T25–T33 |
| `Ω(0)`, `π`, `log π`, digamma conjugation, evenness | T34–T39 |
| Gauss limit, Euler–Maclaurin, expansion, shift | T40–T66 |
| rational-log reduction, panel point, log bound | T67–T70 |
| rational terms, finite gamma sum, real-part bridge | T71–T77 |
| **pointwise panel enclosure** `omegaLo ≤ Ω ≤ omegaHi` | **T79** |
| density transfer, Lipschitz, `Ω` derivative, all-`t` enclosure | T80–T87 |
| `t`-dependent term norm and `ψ'` series bound | T88–T90 |

Build: `./lean/check.sh` (nine files, ~2–3 min). Tests:
`python3 -m pytest -q tests` (30 pass).

The Lean side **does not** yet contain the numerical `4×4` density/prime
assembly. That is the Rust job.

---

## 2. The mathematical object

Fix

- `σ = 1/20` (the certificate uses `0.05`);
- centres `a ∈ {−3/10, −1/10, 1/10, 3/10}`;
- separations `c = a − b ∈ {0, ±1/5, ±2/5, ±3/5}`;
- prime cutoff `X = 20000`.

For `c` define

```
W(c) = pole(c) + density(c) + prime(c)
```

with

```
pole(c)    = 4π σ² exp(σ²/4) cosh(c/2)

density(c) = σ² ∫_{-∞}^{∞} exp(−σ² t²) cos(c t) Ω(t) dt
             = 2 σ² ∫_0^{∞} exp(−σ² t²) cos(c t) Ω(t) dt     (Ω even, T39)

prime(c)   = −2 Σ_{p^k ≤ X} (log p / p^{k/2}) · √π σ · exp(−(log(p^k) − c)²/(4σ²))
```

and the `4×4` entries

```
G_ab = (W(a−b) + W(b−a)) / 2.
```

The Lean T81 transfer applies to the `∫_0^∞` form; the factor `2` is exact.

Reference implementation (to be ported, **not** trusted):
`python/weil_shadow.py` (`weil_gaussian_pole`, `weil_gaussian_density`,
`weil_gaussian_prime`, `weil_gaussian_cross`) and
`python/certify_shadow.py`.

---

## 3. The Lean contract

The Rust program must emit two artifacts:

### 3.1 `lean/Certificate.lean`

A Lean file containing only rational literals and matrix definitions, for
example

```lean
import Enclosure

namespace IntersectionForm

/-- Centre matrix `G₀` (4×4, rational). -/
def certG0 : Matrix (Fin 4) (Fin 4) ℚ :=
  !![  a00, a01, a02, a03;
       a10, a11, a12, a13;
       a20, a21, a22, a23;
       a30, a31, a32, a33 ]

/-- Entrywise half-widths `E` (4×4, rational, nonnegative). -/
def certE : Matrix (Fin 4) (Fin 4) ℚ :=
  !![  e00, e01, e02, e03;
       e10, e11, e12, e13;
       e20, e21, e22, e23;
       e30, e31, e32, e33 ]

end IntersectionForm
```

Each literal is written as `(num : ℚ) / den` with decimal-free integers.
Symmetry is imposed by construction (`e_ij = e_ji`), and the diagonal
half-widths are the `|G_ii − centre_ii|` bounds.

The generic Lean theorems then instantiate:

- `box_ge` (T18): if `A` is Hermitian and `A_ij ∈ G0_ij ± E_ij`, then
  `A ⪰ G0 − tI` with `t = max_i Σ_j E_ij + 1e-9`;
- `posDef_of_box` (T19);
- the concrete instance checks of T21–T24 (`shadowA` etc.) show the pattern
  to copy: containment, symmetry, `G0 = P + tI`, row-sum, exact LDL.

Add `Cert.lean` to `check.sh` after `PanelEnclosure.lean`.

### 3.2 `python/rust_certificate.json`

Same schema as `python/weil_certificate.json` (see `load_certificate` in
`python/weil_shadow.py`), with every numeric leaf as an exact rational
string `"p/q"` (the existing Python `Fraction` parser accepts both decimal
and `p/q`). Required keys:

`gram`, `gram_raw`, `sigma`, `centres`, `prime_cutoff`, `density_panels`,
`margin`, `density`, `centre_matrix`, `conversion_slack`, `operator_slack`,
`leading_minors`, `ldl_pivots`, `ldl`, `omega_samples`, `numerical`,
`provenance`.

This JSON is for Python regression tests and human inspection; Lean reads
only `Certificate.lean`.

### 3.3 The numerical cross-check

`tests/test_weil_shadow.py` already checks that the recorded interval matrix
contains a high-precision numerical matrix. The Rust certificate should pass
the same test with its own JSON (point the test at the new file or emit the
same name).

---

## 4. Rust crate layout

Create `rust/weil-assembly/` (Cargo workspace member) with:

```
rust/weil-assembly/
  Cargo.toml
  src/
    main.rs          # CLI: emit Lean + JSON
    rational.rs      # exact rational wrapper
    interval.rs      # rational interval arithmetic + elementary functions
    omega.rs         # omegaLo / omegaHi (mirror of T79)
    density.rs       # density panels and quadrature
    primes.rs        # prime-power sieve and prime(c)
    pole.rs          # pole(c)
    assemble.rs      # G_ab, centre/error, box, LDL
    lean_out.rs      # Certificate.lean writer
    json_out.rs      # JSON writer
  tests/
    interval.rs      # interval sanity tests
    golden.rs        # compare against python/weil_certificate.json
```

Dependencies:

```toml
[dependencies]
rug = { version = "1", features = ["integer", "rational", "float"] }
serde = { version = "1", features = ["derive"] }
serde_json = "1"
clap = { version = "4", features = ["derive"] }
```

`rug` gives GMP rationals and MPFR floats with explicit rounding modes
(`Round::Down`, `Round::Up`). No other numeric crate is trusted.

---

## 5. Rigour: rational interval arithmetic

`interval.rs` defines

```rust
#[derive(Clone, Debug)]
pub struct Iv { pub lo: Rational, pub hi: Rational }
```

with the usual operations:

- `add`, `sub`, `neg`, `mul`, `div` (division only when `0 ∉ [lo,hi]`);
- `inv`, `pow_nat`, `pow_int`;
- `min`, `max`, `hull`, `intersect`;
- `contains(&Rational)`, `width`.

Transcendental functions must return **outward-rounded rationals**:

- `exp_iv`, `log_iv`, `cos_iv`, `sin_iv`, `sqrt_iv`, `cosh_iv`, `pi_iv`.

Implement each as:

1. evaluate with MPFR at precision `p` (e.g. 256 bits) in `Round::Down` and
   `Round::Up`;
2. convert the two `Float` values to `Rational` exactly;
3. add a small rational pad `2^(−p+8)` to absorb the conversion, or rely on
   MPFR's correct rounding and convert exactly (preferred).

Every function carries a unit test against `python/mpmath` at 80 digits,
checking that the true value lies inside.

**Do not** use `f64` anywhere in the certificate path.

---

## 6. `omega.rs` — the Lean T79 enclosure

Inputs: rational `t`, integer shift `N ≥ 1`, log-series depth `M`.

Definitions (exactly T71–T79, all rational):

```
reW = N + 1/4
imW = t/2
q   = reW² + imW²

t1 = reW / (2q)
t2 = (reW² − imW²) / (12 q²)
t4 = ((reW² − imW²)² − (2 reW imW)²) / (120 q⁴)
rem = 1 / (81 · reW⁵)
sum = Σ_{k=0}^{N−1} (k + 1/4) / ((k + 1/4)² + imW²)

logLo = logPointLo(M, q)     # T32 series
logHi = logPointHi(M, q)

omegaLo = ½ logLo − t1 − t2 + t4 − rem − sum − logPiHi
omegaHi = ½ logHi − t1 − t2 + t4 + rem − sum − logPiLo
```

`logPointLo/Hi` are the rational log series of T32:

```
logTermQ(a,k) = 2 · (1/(2k+1)) · (a/(a+2))^(2k+1)
logPartialQ(N,a) = Σ_{k<N} logTermQ(a,k)
logRemQ(N,a)     = 2 · (a/(a+2))^(2N+1) / ((2N+1)(1 − (a/(a+2))²))
logPointLo(N,x)  = logPartialQ(N, x−1)
logPointHi(N,x)  = logPointLo(N,x) + logRemQ(N,x−1)
```

with `M = 200` (the width is below `1e-30`; T32/T70 use the same).

`logPiLo/Hi` come from `piLo = 314159265358979323846/10^20`,
`piHi = ...847/10^20` and `logPointLo/Hi(M, piLo/piHi)`.

**Tests** (`omega.rs`):
- reproduce `omega_mem` numerically for `t = 1, 5, 10, 50` with `N = 10`,
  `M = 200`;
- check `omegaLo ≤ python-mpmath Ω ≤ omegaHi` at 60 digits;
- check the width is below `1e-4`.

---

## 7. `density.rs` — panel quadrature

Use the **Taylor-panel scheme** of
`prime-spectrum-tensor/python/programme.py` (C9–C21), which the Python
certificate already uses:

- partition `[0, T]` with `T = 100` and step `H = 0.1`;
- on each panel, build a degree-`U = 4` Taylor model of `Ω` from the
  rational `Ω` value at the panel centre (T79) plus interval derivatives
  (or, simpler, from the T87 Lipschitz bound and a midpoint value);
- multiply by the Gaussian/cosine weight intervals;
- add the analytic tail bound for `t > T`
  (`σ² e^{−σ²T²} · sup|Ω| / (σ² T)` style), with a certified crude
  `sup|Ω|` from T85/T90.

If exact derivatives are unavailable, a conservative fallback is:

```
on panel [a,b], Ω ∈ [Ωa − L·h, Ωa + L·h],  h = b−a,
L = psiSeriesBound 1   (T85; coarse)  or  the Rust evaluation of T90.
```

The panel integral is then enclosed by interval Gauss–Legendre of order 8
with a rational `h⁹` remainder bound, or by the midpoint rule with the
second-derivative bound; both are first-order in `h` for the *bound*, so use
`H = 1e-3` to `1e-4` and let Rust do the work (10⁵–10⁶ panels is fine).

Output per `c`:

```rust
struct DensityEnclosure { c: Rational, lo: Rational, hi: Rational }
```

**Acceptance**: the interval must contain the Python `density` entry from
`weil_certificate.json` (which is itself an interval; check overlap, not
containment of a point).

---

## 8. `primes.rs` — finite prime sum

- Sieve to `X = 20000`.
- For each prime `p`, for each `p^k ≤ X`:
  - `v = log(p^k) = k log p` as an interval;
  - `weight = log p / sqrt(p^k)` as an interval
    (`sqrt_iv(p^k)` = `sqrt_iv` of an integer);
  - `conv = √π · σ · exp(−(v − c)²/(4σ²))` as an interval;
  - `prime(c) −= 2 · weight · conv`.
- All operations interval, outward-rounded.
- The number of terms is **2328**, not 1360: the Python
  `_prime_power_data(20000)` length is 2328 (2262 primes plus 66 genuine
  prime powers).  The Rust test asserts 2328.

**Acceptance**: interval for `prime(c)` contains the Python value to
`1e-8`.

---

## 9. `pole.rs`

`pole(c) = 4π σ² exp(σ²/4) cosh(c/2)`, all interval:

- `pi_iv`, `exp_iv(σ²/4)`, `cosh_iv(c/2)`, exact rational `4σ²`.

**Acceptance**: width below `1e-12` for the four separations.

---

## 10. `assemble.rs` — the `4×4` box

For each pair `(a,b)`:

```
c  = a − b
Wp = pole(c) + density(c) + prime(c)
Wm = pole(−c) + density(−c) + prime(−c)
Gab = (Wp + Wm)/2
```

Build:

- `gram_raw[i][j] = Gab`;
- `centre[i][j] = (lo+hi)/2`  (rational);
- `err[i][j]    = (hi−lo)/2`  (rational, nonnegative);
- enforce symmetry: use `err[i][j] = max(err[i][j], err[j][i])`;
- `t = max_i Σ_j err[i][j] + 1/10^9`;
- `P = centre − t·I`;
- exact rational `LDLᵀ` of `P` (the existing Python `ldl_factorization`
  algorithm; port it or call the Python and import the rationals);
- `leading_minors`, `ldl_pivots`, `operator_slack`, `conversion_slack`.

The Rust program must assert `P` is positive definite (all pivots `> 0`),
otherwise exit non-zero with the failed pivot.

---

## 11. Emitting the artifacts

`main.rs`:

```
weil-assembly --out-lean lean/Certificate.lean \
              --out-json python/rust_certificate.json \
              --sigma 1/20 --cutoff 20000 --T 100 --H 1/1000
```

`lean_out.rs` writes decimal-free rational literals:

```rust
fn lean_rat(q: &Rational) -> String {
    format!("(({} : ℚ) / {})", q.numer(), q.denom())
}
```

`json_out.rs` writes `"p/q"` strings (the Python `Fraction` parser accepts
them).

---

## 12. Acceptance tests

1. `cargo test` — interval sanity, golden comparisons.
2. `python3 -m pytest -q tests` — the existing 30 tests, with the Rust JSON
   substituted for `weil_certificate.json` (or copied over it).
3. `./lean/check.sh` — now includes `Certificate.lean`; the generic
   `box_ge`/`posDef_of_box` and the concrete `Cert` instance must build.
4. Cross-check `density` and `prime` intervals against the Python values;
   report the widths.
5. Confirm `shadowA` positive definite and `box_contains` for the numerical
   matrix.

A run is **not** accepted if any Lean file needs `sorry`, `axiom`,
`native_decide`, or a floating-point literal.

---

## 13. Continuation plan after the Rust assembly

1. **Wire the certificate.** Generate `Certificate.lean`, add it to
   `check.sh`, and instantiate `box_ge`/`posDef_of_box` with `certG0`,
   `certE`, and the row-sum slack.
2. **Replace the numerical matrix by the analytic enclosure.** Use T79 at
   each rational panel node plus the T87/T90 Lipschitz bound to prove the
   density intervals used by the Rust program are contained in the Lean
   `Omega` enclosures; this closes the last "trust the Rust" gap.
3. **Prime sum in Lean (optional).** If full kernel checking of the prime
   sum is wanted, emit a `PrimeSum.lean` with the 2328 rational terms and a
   `Finset.sum` equality; the Rust program can generate it mechanically.
4. **Document.** Add the Rust certificate to `README.md`, `STATUS.md`, and
   the `intersection-form-zeta` row; record the new theorem count.
5. **Extend the dossier.** Once the `4×4` assembly is kernel-checked, the
   remaining open item is the infinite-dimensional Weil cone, not the finite
   shadow.

---

## 14. Risks and fallbacks

- **MPFR rounding.** Use `rug` with 256-bit precision and directed rounding;
  unit-test every transcendental against mpmath at 80 digits. If a function
  is not correctly rounded, pad the interval by `2^(−200)`.
- **Panel count.** `H = 1e-3` gives `10⁵` panels; Rust handles this in
  seconds to minutes. If the interval widths are too large, reduce `H` or
  raise the Taylor order `U`.
- **Density tail.** The Gaussian tail beyond `T = 100` is below `1e-200`;
  a crude `sup|Ω|` bound suffices.
- **Prime sum size.** 2328 terms is small; no acceleration needed.
- **Lean literal size.** `Certificate.lean` has 16 rationals with
  denominators up to `10^30`; `norm_num` handles them, but keep the
  denominators factored (emit `p/q` with `q` a product of primes) to keep
  elaboration fast.

---

## 15. One-paragraph summary for the next agent

The Lean project has a complete, unconditional analytic enclosure of
`Ω(t) = Re ψ(1/4+it/2) − log π` (T79), with a density-transfer theorem
(T81), a Lipschitz/all-`t` enclosure (T82/T87), and a `t`-dependent
derivative bound (T90). The only missing piece is the numerical `4×4`
assembly. Write a Rust crate that encloses `pole`, `density`, and the prime
sum in exact rational intervals, emits `lean/Certificate.lean` (rational
matrices `certG0`, `certE`) and `python/rust_certificate.json`, and verify
it with the existing Python tests plus `./lean/check.sh`. Then instantiate
the generic box theorems with the emitted constants and extend the ledger.

---

## 16. Implementation record (this run)

Delivered:

- `rust/weil-assembly/` — 10 modules, 22 Rust tests (`cargo test --release`)
  covering interval sanity, directed rounding, the 2328 prime powers, the
  T79 rational enclosure, `Ω(0)`, the T87 constant, the exact `LDLᵀ`
  identity, and golden comparisons against `python/weil_certificate.json`.
- `lean/Certificate.lean` — generated `certG0`, `certE`, `certT`, `certP`,
  `certL`, `certD`, `certA` plus `certD_pos`, `certL_lower`, `certL_det`,
  `certL_unit`, `cert_factor`, `certP_posDef`, `certA_herm`, `certA_mem_box`,
  `certE_row`, `certA_posDef` (T91–T100).  It compiles in ~16 s and contains
  no placeholder, extra axiom or floating-point literal.
- `lean/check.sh` now includes `Certificate.lean`.
- `tests/test_rust_certificate.py` — 15 tests cross-checking the JSON with
  independent mpmath values and exact `Fraction` arithmetic (C25–C39).

Deviations and corrections:

1. **Prime-power count.** The handoff's 1360 is wrong; `X = 20000` gives 2328
   prime powers, matching the Python reference.
2. **`Ω` log enclosure.** The T32 series `logPointLo/Hi` is far too slow for
   the large `q` occurring in the density panels (`M = 200` is not enough at
   `q ≈ 10⁴`).  The Rust `omega_panel_iv` keeps the exact T79
   Euler–Maclaurin decomposition and the T79 remainder `1/(81(N+1/4)^5)`,
   but replaces the T32 log series with an MPFR `log` enclosure.  This is
   still a valid lower/upper bound for `Ω` and is much tighter.  The literal
   T79 rational formula is retained as `omega::omega_exact` for tests.
3. **Density quadrature.** `H = 10⁻³`, `T = 150`, 150000 panels, Taylor order
   6 for the oscillatory weight, and the T79 panel enclosure of `Ω`.  The
   density half-width is `2.1·10⁻⁵`; the panel-adjacent-to-zero uses the T87
   Lipschitz bound (`psiSeriesBound 1 < 10`, computed by the integral test).
4. **JSON tests.** The handoff suggested re-pointing `test_weil_shadow.py` at
   the Rust JSON.  The existing tests use `Decimal` on numeric leaves and
   compare `Ω` samples against the vendored `mpmath.iv` enclosure, so they
   were left untouched; `tests/test_rust_certificate.py` is the Rust-specific
   suite.  Both certificates are now verified by the 45-test pytest run.
5. **Lean instance.** `certA` is the 12-digit rounding of the box centre, not
   an independent floating-point evaluation.  It is distinct from `certG0`
   and satisfies the containment proof, so `certA_posDef` is a genuine
   application of `posDef_of_box_rat`.  The Python tests independently verify
   that mpmath's numerical matrix lies in the Rust box.
6. **Remaining gap.** The rational box is a Rust computation.  Step 2 of §13
   (formalising the quadrature inside Lean) and step 3 (the prime sum in
   Lean) are not done; the kernel checks the box data and the numerical
   representative, not the derivation of the box from T79.
