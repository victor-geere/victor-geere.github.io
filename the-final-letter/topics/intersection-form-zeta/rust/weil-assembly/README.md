# `weil-assembly` — certified Rust assembly of the `4 × 4` Weil Gram box

Implements the crate specified in
[`../../HANDOFF-RUST.md`](../../HANDOFF-RUST.md).  The program computes the
four-term Gaussian Weil Gram matrix

```
W(c)       = pole(c) + density(c) + prime(c)
G_ab       = (W(a-b) + W(b-a)) / 2
```

for `σ = 1/20`, centres `{-3/10, -1/10, 1/10, 3/10}` and prime cutoff
`X = 20000`, and emits

* `lean/Certificate.lean` — rational matrices `certG0`, `certE`, the slack
  `certT`, the exact `LDLᵀ` factors, a 12-digit representative `certA`, and
  kernel-checked proofs T91–T100;
* `python/rust_certificate.json` — the same data with every numeric leaf as an
  exact rational string `"p/q"`.

## Rigour

* No `f64` appears in the certificate path.
* `pole`, the finite prime sum and the final assembly use exact rational
  intervals (`rug::Rational`); `exp`, `log`, `sqrt`, `cos`, `sin` and `cosh`
  are evaluated by MPFR at 256 bits with directed rounding, then converted
  exactly to rationals.
* The density integral uses the Lean T79 Euler–Maclaurin decomposition of

  `Ω(t) = Re ψ(1/4 + it/2) − log π`

  with an MPFR `log` enclosure (a tighter replacement for the slow T32
  series, which is still available in `omega::omega_exact` for tests).  The
  T79 remainder `1/(81(N+1/4)^5)` is the only truncation.
* The oscillatory weight `∫ exp(−σ²t²) cos(ct) dt` is integrated panel by
  panel with a degree-8 complex Taylor expansion and a rigorous K-th
  derivative remainder; `Ω` is enclosed on each panel, and the error term is
  added symmetrically.
* The single panel adjacent to `0` uses the T79 point enclosure at its right
  endpoint and the T87 Lipschitz constant `psiSeriesBound 1`, bounded by the
  integral test in `omega::psi_bound_one_upper`.
* The Gaussian tail beyond `T = 150` uses `|Ω(t)| ≤ 10 + 5t`, proved from the
  standard digamma series in the module documentation.

## Build and run

From `the-final-letter/topics/intersection-form-zeta`:

```bash
cargo build --release --manifest-path rust/weil-assembly/Cargo.toml
./rust/weil-assembly/target/release/weil-assembly \
  --out-lean lean/Certificate.lean \
  --out-json python/rust_certificate.json
```

The default density configuration is `T = 150`, `H = 1/1000`, `N = 30`,
Taylor order `6`, first panel `10⁻⁵`, grid `10⁻¹⁵`; a run takes about three
minutes and produces density half-widths of `2.1·10⁻⁵`, pole/prime widths of
`10⁻¹⁵`, and `Ω` sample widths of `10⁻⁹` (or `1.24·10⁻⁵` at `t = 0`, where the
rational `γ` interval dominates).

## Tests

```bash
cargo test --release --manifest-path rust/weil-assembly/Cargo.toml
```

* `src/*` unit tests cover interval arithmetic, directed rounding, the 2328
  prime powers, the T79 rational enclosure, `Ω(0)`, and the T87 constant.
* `tests/golden.rs` runs the assembly and checks that the intervals contain
  the independent Python/mpmath values in `python/weil_certificate.json`,
  overlap the Python interval box, and satisfy the exact `LDLᵀ` identity.

The Python cross-check is `tests/test_rust_certificate.py` (15 tests).  Note
that the true number of prime powers with `p^k ≤ 20000` is **2328**, not the
`1360` stated in the handoff; the Python reference uses 2328.

## Output

`python/rust_certificate.json` has the same top-level schema as
`python/weil_certificate.json` (`gram`, `gram_raw`, `sigma`, `centres`,
`prime_cutoff`, `density_panels`, `margin`, `density`, `centre_matrix`,
`conversion_slack`, `operator_slack`, `leading_minors`, `ldl_pivots`, `ldl`,
`omega_samples`, `numerical`, `provenance`), plus the intermediate
`pole_intervals` and `prime_intervals`.
