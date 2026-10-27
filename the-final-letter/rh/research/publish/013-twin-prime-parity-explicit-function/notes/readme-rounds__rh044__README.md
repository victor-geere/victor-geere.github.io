# `rh044` — the smoothing bridge: from the finite-`N` balance to the zeros of ζ

**The question** (the gap left open by [`../rh43/truths.md`](../../../twin-prime-parity/rounds/rh43/truths.md) §7.6).
At `Re(S) = 1/2` the balance condition `Re S_N(1/2+it) = 0` has roots, but they are
generic oscillations of the Dirichlet polynomial, not zeros of ζ, because

```
S_N(1/2+it) − ζ(1/2+it)  =  O(√N)            (sharp cutoff)
```

is unbounded.  **Can a smoothing / summation method replace the sharp cutoff and
extract ζ to `o(1)` — even exponentially small — accuracy, so a finite-`N` condition
can see a zero?**

**The answer, in one line.**  **No — smoothing does not remove the `√N`.**  The exact
law (verified to 5–7 digits against the closed form) is

```
|S_N^φ(1/2+it) − ζ(1/2+it)| / √N  →  |M_φ(s)| ,   M_φ(s) = ∫_0^1 φ(u) u^{−(1/2+it)} du ,
```

so every weight grows like `√N`; smoothing buys only the constant `|M_φ(s)|` (a
factor `600` for the best weight tested).  **Exponential accuracy requires the
functional equation**, not smoothing: Riemann's theta route
`π^{−s/2}Γ(s/2)ζ(s) = 1/(s(s−1)) + ½[A(s)+A(1−s)]`, `A(s) = ∫_1^∞ x^{s/2−1}(θ(x)−1)dx`
reaches `e^{−πX}` with `O(√t)` terms.  So the bridge *is* buildable — but it is the
functional equation that builds it, and a one-sided smoothed sum alone provably
cannot.

---

## The settled facts (verified by the round and by its independent auditor)

**1. The sharp cutoff is the Euler–Maclaurin main term.**

```
S_N(s) = N^{1−s}/(1−s) + ζ(s) + O(N^{−1/2})        (checked to 5 digits at N = 10^5)
|S_N(1/2+it) − ζ(1/2+it)| / √N  →  1/|s−1| = 1/√(1/4 + t²)
```

| `t` | `1/√(1/4+t²)` | measured `\|S_N−ζ\|/√N` at `N = 10^2, 10^3, 10^4, 10^5` |
|---|---|---|
| 14.134725141734693 | 0.0707035277318 | 0.0709386, 0.0707218, 0.07070530, 0.07070370 |
| 21.022039638771555 | 0.0475556741611 | 0.0477615, 0.0475684, 0.04755687, 0.04755579 |

At a zero, `S_N ≈ √N/|s−1|` — the zero appears only after cancellation.  *(An earlier
draft of this round claimed the constant `1/√(2t)`; that is wrong by a factor `2.66`
at `t = 14.13` and is corrected here.)*

**2. The smoothing law — the round's main result.**

```
|S_N^φ(1/2+it) − ζ(1/2+it)| / √N  →  |M_φ(s)| ,   M_φ(s) = ∫_0^1 φ(u)u^{−(1/2+it)}du
```

| weight `φ(u)` | measured `\|E\|/√N` at `N = 10^5` | `\|M_φ(s)\|` | ratio |
|---|---|---|---|
| `1` (sharp) | 0.070703705 | `\|1/(s−1)\| = 0.070703528` | 1.0000025 |
| `u(1−u)` | 0.0049012629 | 0.0049012243 | 1.00001 |
| `(u(1−u))^3` | 0.00011771845 | 0.00011771845 | 1.000000 |
| `(1−cos 2πu)/2` | 0.0079729835 | 0.0079729835 | 1.000000 |
| `e^{−u}` | 0.026142297 | 0.026142378 | 0.999997 |

So **smoothing does not remove the `√N`** (the last-decade exponent is `0.5000` for
every weight); it rescales the constant, by up to a factor `600` for `(u(1−u))^3`.
*(An earlier draft claimed the smoothed error is `O(N^{−1/2})`; that is refuted by the
same measurements and corrected here.)*

**3. Exponential accuracy needs the functional equation.**  The classical theta
identity

```
π^{−s/2}Γ(s/2)ζ(s) = 1/(s(s−1)) + ½[A(s) + A(1−s)] ,   A(s) = ∫_1^∞ x^{s/2−1}(θ(x)−1)dx
```

is verified independently to `5.7·10^{−69}` (`s = 2`), `1.8·10^{−68}` (`s = 4`),
`1.0·10^{−64}` (`s = 1/2+it₁`), with a rigorous tail bound decaying like `e^{−πX}`
(`B(X) = 1.0·10^{−45}` at `X = 32`).  A one-sided smoothed sum omits a tail of size
`√N·|M_φ(s)|`, so only this route reaches `o(N^{−A})` for every `A`.

**4. Zero localisation.**  With a reliable evaluator the first five zeros are
`14.134725141734693790…, 21.022039638771554992…, 25.010857580145688763…,
30.424876125859513210…, 32.935061587739189690…` (both routes agree to the `1e−44`
bisection floor).  The *sharp* partial sum cannot do this: its first roots are
`0.303990, 0.213724, 0.163744` for `N = 10^3, 10^4, 10^5`, with `60, 102, 128` roots
in `(0,35)` — and `Re ζ` alone also has spurious sign changes (at `0.8195, 20.654,
29.739, 33.624`) that are not zeros; only `Z`-based bracketing is reliable.

**5. The zero count.**  `N(30) = 3`, `N(35) = 5`; the Riemann–von Mangoldt main term
is `3.5647` at `T = 30`, so `N(30) − main = −0.5647 = S(30)/π`, inside the expected
oscillation.

**6. Consequence for rh43 and for the parity problem.**  The bridge from the
finite-`N` balance to ζ's zeros is analytic, not algebraic: it needs the functional
equation (or the `O(N^{−σ})` Euler–Maclaurin remainder) to be controlled.  Nothing in
this round turns the sign of `cos(t log n)` into multiplicative/divisor information,
so the twin-prime parity obstruction is untouched.

## Files

| file | what it is |
|---|---|
| [`HANDOFF.md`](../../../twin-prime-parity/006/notes/HANDOFF.md) | the round's specification, the reconnaissance table, the targets T1–T5 |
| [`smoothed_zeta.py`](../python/smoothed_zeta.py) | the round's numerics: sharp vs smooth vs exponential vs theta, the fit tables, the zero localisation → [`verify/smoothed_zeta.log`](../../../twin-prime-parity/rounds/rh044/verify/smoothed_zeta.log) |
| [`verify/independent_check.py`](../../../twin-prime-parity/010/verify/independent_check.py) | the auditor's independent route (its own θ quadrature, its own ζ values) → **43/43 checks pass**, [`verify/independent_check.log`](../../../twin-prime-parity/010/verify/independent_check.log) |
| [`lean/`](lean) | the algebraic layer: the weight-defect identity, the triangle-inequality error bound, the radial-decay estimate |
| [`truths.md`](../../../../../geometric-dynamical-phase-transitions/truths.md) | the ledger: T1–T5, the four refuted first-draft claims R1–R4, and the verdict for the parity problem |

## Reproduce

```
cd ../../..
python3 rh044/smoothed_zeta.py
python3 rh044/verify/independent_check.py
cd rh044/lean && ./check.sh --all
```

The Lean layer ([`lean/Rh044/Smoothing.lean`](../lean/Rh044/Smoothing.lean), 383 lines,
`--all` exit 0, no `sorry`) proves the algebraic layer of the round: the
weight-defect identity `zetaSum N s − smoothedSum N φ s = Σ (1−φ(n/N))·zetaTerm s n`,
the triangle-inequality error bound
`‖zetaSum − smoothedSum‖ ≤ Σ ‖1−φ(n/N)‖·‖zetaTerm s n‖`,
the exact radial decay `‖zetaTerm (σ+tI) n‖ = n^{−σ}`, the summability comparison for
`σ > 1`, and the weight closed forms (`quadWeight`, its defect identities).

## What this folder will *not* claim

* No new bridge: the route through the functional equation is Riemann's (1859) and
  Riemann–Siegel (1932).
* No improvement of the zero-free region, of zero-counting bounds, or of the
  Riemann–Siegel formula.
* No connection to the twin-prime/parity obstruction beyond the statement that the
  required input is analytic (an error term), not algebraic.
