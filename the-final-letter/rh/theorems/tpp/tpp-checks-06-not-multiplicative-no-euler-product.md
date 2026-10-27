# SS4/SS5 — `n ↦ λ(n)λ(n+2)` is not multiplicative; no Euler product

**Kind:** Claim
**Status:** PROVED (paper argument / finite algebraic fact; VERIFIED (numerical) with a rigorous tail bound — discrepancy exceeds the tail by a factor `109 178`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/checks/06-numerical-checks.md`](../../research/twin-prime-parity/checks/06-numerical-checks.md) — § rh46, "Headline numbers" SS5 (lines 549–558); § rh47, "Headline numbers" B3 (lines 666–672); *Corrections* item 3

## Statement

> SS5 (why the analytic route is unavailable). `f(n)=λ(n)λ(n+2)` is **not multiplicative** (`f(1) = −1 ≠ 1`; `f(2)f(11) = −1 ≠ f(22)=1`; `f(2)f(13)=1 ≠ f(26)=−1`), and at `s=2`:
>
> | quantity | value |
> |---|---|
> | `D(2) = Σ_{n≤10^6} f(n)/n²` | −1.12681304 |
> | naive product `Π_{p≤10^5}(1 + Σ_k f(p^k)p^{−2k})` | 0.88759631 |
> | `|D(2) − product|` | 2.01440934 |
> | round's stated product tail bound | 1.80898647 |
> | **correct** tight tail bound | ≈ **1.84e-05** (n-tail `2e-6` + p-tail `1.645e-5` + k-tail `1e-9`) |

> B3 — `f(n) = λ(n)λ(n+2)` is **not multiplicative** and has **no Euler product**: `f(1) = −1`; coprime witnesses `f(2)f(11) = −1 ≠ f(22) = 1`, `f(2)f(13) = 1 ≠ f(26) = −1`, `f(3)f(5) = 1 ≠ f(15) = −1` (12 016 failing coprime pairs `a,b ≤ 200, ab ≤ 10^6`). At `s=2`: `D(2) = −1.1268130386`, `Π = 0.8875735163`, `|D(2) − Π| = 2.0143865549` against a rigorous total tail `n-tail 2.0000e-06 + p-tail 1.6449e-05 + k-tail 1.0000e-09 = 1.8450e-05` — the discrepancy exceeds the tail by a factor **109 178**.

## Hypotheses and notation

- `f(n) = λ(n)λ(n+2)` is the shifted two-point multiplicative correlation; `λ` is the Liouville function.
- Multiplicativity would require `f(1) = 1` and `f(ab) = f(a)f(b)` for coprime `a,b`; the witnesses above violate the second requirement.
- `D(2) = Σ_{n≤10^6} f(n)/n²`; `Π` is the naive Euler product `Π_{p≤10^5}(1 + Σ_k f(p^k)p^{−2k})`.
- The "naive product" truncates at `p ≤ 10^5`; the tail bound measures the omitted factors (`p > 10^5`) and the omitted `n`-tail.

## Proof / evidence

- `rh46/chowla_two_point.py` → `rh46/verify/chowla_two_point.log` SS5; auditor `rh46/verify/independent_check.py` → `independent_check.log` (model A exact to `2^{26}`), reproduced again by the rh47 auditor `rh47/verify/independent_check.py` → `independent_check.log` (**`RESULT: 31/31 checks pass`**); `rh47/greedy_parity_probe.py` → `greedy_parity_probe.log` SS4 gives `1.8450e-05` by a slightly looser split.
- The register's "What it establishes" for rh46: "The negative algebraic fact that the Euler-product/`ζ` route does not apply, verified numerically with a rigorous tail bound."
- *Corrections* item 3: the round's own `1.80898647` "is mis-derived. It equals `4·Σ_{p≤10^5} 1/p²` over the **retained** primes, not a bound on the omitted factor (`p > 10^5`). The correct tight bound is `≈1.84e-05` … The no-Euler-product verdict survives, on a tail ~`10^5×` smaller than published."

## Dependencies and related results

- The finite-prefix-indeterminacy entry of the same register section (SS4/A1) is the companion logical result.
- *Corrections* item 11: the "RH-conditional `x^{1/2+ε}`" reading of `max|S|` is **WITHDRAWN** precisely because "the shifted product is not multiplicative, so the Dirichlet-series/Perron route does not apply".

## Notes

- **Correction, 2025-10-06 (session 003, audit repair 4a/5).** The source's displayed evidence says `f(1) = +1`; **that is false for the `f` it defines one clause earlier, `f(n) = λ(n)λ(n+2)`**: `f(1) = λ(1)λ(3) = 1 · (−1) = −1`. The value is machine-checked in this repository — `ConeLean.chowlaAF_one : chowlaAF 1 = -1` (`lean/ConeLean/ParityObstruction.lean:33`, whose definition at :29–31 is exactly `n ↦ liouville n * liouville (n + 2)`) — so the correction is not a matter of opinion. The displayed quotation in *Statement* is left exactly as the source writes it; this note is the correction. The falsity of multiplicativity does **not** depend on the wrong sign: the coprime witnesses `f(2)f(11) = −1 ≠ f(22) = 1`, `f(2)f(13) = 1 ≠ f(26) = −1`, `f(3)f(5) = 1 ≠ f(15) = −1` are independent counterexamples, and `chowlaAF_not_multiplicative` (`ParityObstruction.lean:37`) proves the theorem `f` is not multiplicative.
- The two registers give slightly different `D(2)`/`Π` values (`−1.12681304` vs `−1.1268130386`, `0.88759631` vs `0.8875735163`); both are copied exactly as printed in their own sections.
- This is the negative fact that closes the ζ/Perron route; the register says it "kills the Dirichlet-series/Perron route".
