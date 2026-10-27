# `rh45` — the explicit formula, used explicitly

**Why this round exists.**  [`rh43`](../rh43/truths.md) §7.6 asked for "a
smoothing/summation method (Euler–Maclaurin or an explicit formula)".  [`rh44`](../rh044/truths.md)
took the smoothing branch and found it does not work: every one-sided weight keeps
the `√N` error, `|S_N^φ − ζ|/√N → |M_φ(s)|`; only the functional equation reaches
`o(1)`.  This round takes the **explicit formula** branch directly — which is what
the question meant.

---

## The instrument — and the correct form of the formula

Riemann–von Mangoldt.  With `g` an even test function, its Fourier transform
`φ(t) = ∫_ℝ g(u)e^{itu}du`, and `Φ(s) = φ((s−1/2)/i)`, the identity is

```
Σ_ρ Φ(ρ)  =  Φ(1) + Φ(0)                              [poles of ζ at s = 1, 0]
           − Σ_{n≥2} (Λ(n)/√n)[g(log n) + g(−log n)]  [primes]
           + (1/2π) ∫_ℝ φ(t) Ψ(t) dt                  [ARCHIMEDEAN]
Ψ(t) = −log π + Re ψ(1/4 + it/2) ,        Φ(1) + Φ(0) = 2φ(i/2) for even g .
```

**What my first draft got wrong** (isolated numerically by the round's auditor, see
[`truths.md`](truths.md) §1):

| error | size (`σ=1` Gaussian) |
|---|---|
| pole arguments `F(1)+F(0)` instead of `2φ(i/2)` | `−0.659766246421` |
| **missing archimedean integral** `(1/2π)∫φΨ` | `−1.196346718078` |
| residual the draft left (must be 0) | `+0.536580471657` |

With the archimedean term restored, the identity holds to **≥ 20 digits** on four
kernels (Gaussian: residual `1.6·10⁻⁴⁴`; modulated Gaussian with `O(1)` LHS:
`9.6·10⁻⁴⁶`; narrow Gaussian: `−1.1·10⁻⁶³`; Cauchy companion `a=1`: ~2 digits, limited
by its `log G/G` zero-side tail).  The Cauchy kernel at `a = 1/2` is the boundary
case — both its pole term and its prime sum diverge — which is exactly why my first
Cauchy-based test could never have worked.

Three structural advantages over the partial-sum route:

1. **The zero information sits in the singularities**, not in a tail: the pole at
   `s = 1` (whose image ruined the sharp partial sum) is *used*, not fought.
2. **Both sides converge rapidly**: the zero sum decays like `e^{−γ²/2}` for Gaussian
   families, and the prime side carries `g(log n)`.
3. **It is unconditional and knows about the primes** through `Λ`.

The clean unconditional core, verified twice in this round, is the **counting
formula** `N(T) = θ(T)/π + 1 + S(T) = (T/2π)log(T/2πe) + 7/8 + S(T) + O(1/T)` with
`S(T) = (1/π)arg ζ(1/2+iT)`; residuals fall like `1/T` (main agent:
`3.32·10⁻⁴, 1.33·10⁻⁴, 6.63·10⁻⁵, 3.32·10⁻⁵, 2.21·10⁻⁵` at `T = 20…300`; auditor:
exact form to `1e−20`, plus an independent `ζ'/ζ` argument-principle count).

## The contrast with rh43/rh044 (T4)

| | partial sum (rh43/rh044) | explicit formula (rh45) |
|---|---|---|
| instrument | `S_N(1/2+it)`, sharp or smoothed | test function `g`, transform `φ` |
| error | `√N/\|s−1\|` or `√N·\|M_φ(s)\|` — **grows** | Gaussian-type, **decays** |
| zeros sit in | the cancellation `ζ − S_N` | the poles `s = 1, 0` (and archimedean term) |
| primes | invisible | `Σ Λ(n)/√n[g(log n)+g(−log n)]` |
| cost for `γ₁` | `N = 10^6` gives `\|Re S_N(γ₁)\| = 36.05`, still no sign change within `10^{−3}` | `O(T)` evaluations; 5 zeros to 32–33 digits |

## What the round does *not* claim

* No new explicit formula, no improvement of Riemann–Siegel, no zero-free region, no
  RH progress.
* **No parity-problem advance.**  The explicit formula is *unconditional* and primes
  enter through `Λ(n)` — but that is precisely the object the parity obstruction is
  about: a sieve weight built from `Λ` (or from `μ`, `λ`) cannot separate integers
  with an even number of prime factors from those with an odd number, so the formula
  can locate zeros but cannot manufacture the twin-prime lower bound.  A genuine
  advance there would need a correlation statement such as
  `Σ_{n≤x} λ(n)λ(n+2) = o(x)`.

## Files

| file | what it is |
|---|---|
| [`HANDOFF.md`](HANDOFF.md) | the round's specification and targets |
| [`explicit_formula.py`](explicit_formula.py) | T1–T3: the formula, the zero location, the count → [`verify/explicit_formula.log`](verify/independent_check.log) *(the script log `explicit_formula.log` was never produced: its run was interrupted; all rh45 numbers come from the independent audit)* |
| [`verify/independent_check.py`](verify/independent_check.py) | the auditor's independent route (`ζ'/ζ` count, own constants) → [`verify/independent_check.log`](verify/independent_check.log) |
| [`lean/`](lean) | T5: the algebraic layer |
| `truths.md` | the ledger |

## Reproduce

```
cd /Users/victor/workspace/rh
python3 rh45/explicit_formula.py
python3 rh45/verify/independent_check.py
cd rh45/lean && ./check.sh --all
```
