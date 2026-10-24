#!/usr/bin/env python3
"""
rh044/truths.md — the ledger of the smoothing round.

Statuses: PROVED (written argument or Lean), VERIFIED (independent recomputation in
this round), REFUTED (with the smallest witness), OPEN.

The round repairs the gap left by ../rh43/truths.md §7.6: the finite-N balance
condition at Re(S) = 1/2 cannot see a zeta zero because the sharp partial sum differs
from ζ by O(√N).  It asks whether smoothing fixes that.

**Headline: it does not.**  Smoothing rescales the constant but leaves the √N growth.
The exact law, verified to 5–7 digits against the closed form |M_φ(s)| (the Mellin
transform of the weight), is

    |S_N^φ(1/2+it) − ζ(1/2+it)| / √N  →  |∫_0^1 φ(u) u^{−(1/2+it)} du| = |M_φ(s)| ,

with the sharp cutoff (`φ ≡ 1`) giving the divergent-at-0 case whose constant is
`1/|s−1| = 1/√(1/4 + t²)`.  Exponential accuracy is reachable **only through the
functional equation** (Riemann's theta identity), not by any one-sided weight.

---

## 0. The corrections this round had to make to its own first draft

Three claims were written into the round's reconnaissance and are **REFUTED**; they
are kept here with their witnesses.

| # | wrong claim | witness / correction |
|---|---|---|
| R1 | the sharp fluctuation constant is `1/√(2t)` | false by a factor 2.66 at `t = 14.1347`: `1/√(2t) = 0.1880794` vs the measured `0.07070353`.  The true constant is `1/\|s−1\| = 1/√(1/4+t²) = 0.0707035277318`; normalised, `\|S_N−ζ\|·\|s−1\|/√N = 1.0000025` at `N = 10^5` |
| R2 | "smoothing removes the `√N` fluctuation; the smoothed error is `O(N^{−1/2})`" | false.  `\|S_N^φ − ζ\|·√N → ∞` for **every** weight; the measured exponents are `0.5000` (last decade, `N = 10^4 → 10^5`) for all six weights tested.  Smoothing changes only the constant `\|M_φ(s)\|` |
| R3 | "`\|S_N\|·√(2t)/√N → 1`" | false: measured `0.37592469` (`t = 14.1347`), `0.30835845` (`t = 21.0220`); the limit is `√(2t)/√(1/4+t²) = 0.37592375 / 0.30835768` |
| R4 | theta identity `ζ(s) = 1/(s−1) + 1/s + …` | false (off by exactly `1/s`: at `s = 2` it returns `1.547197551`).  The classical identity is `π^{−s/2}Γ(s/2)ζ(s) = 1/(s(s−1)) + ½[A(s)+A(1−s)]`, `A(s) = ∫_1^∞ x^{s/2−1}(θ(x)−1)dx` |

R1–R3 were caught by the round's auditor; R4 by the main agent before the audit.

---

## 1. The sharp cutoff (T1)

**Theorem 1 (Euler–Maclaurin, full first terms).**  For `s = 1/2 + it` and any fixed
`t`, as `N → ∞`

```
S_N(s) − ζ(s) = N^{1−s}/(1−s) + (1/2)N^{−s} − (s/12)N^{−s−1} + …
```

hence `|S_N(s) − ζ(s)| = √N/|s−1| + O(1)` and `|S_N−ζ|/√N → 1/|s−1| = 1/√(1/4+t²)`.
Each coefficient is checked exactly: at `N = 102400`,
`|R_1|·√N = 0.49999959` (against `1/2`) and `|R_2|·N^{3/2} = 1.178630488`
(against `|s|/12 = 1.178630487`).  The phase also matches:
`|S_N|√(1/4+t²)/√N → 1.00000244` and `arg S_N + t log N − arctan(2t) → −6.9·10^{−5}`.
**PROVED** (Euler–Maclaurin), **VERIFIED**: 

| `t` | `1/√(1/4+t²)` | `\|S_N−ζ\|/√N` at `N = 10^2, 10^3, 10^4, 10^5` |
|---|---|---|
| 14.134725141734693 | 0.0707035277318 | 0.0709386, 0.0707218, 0.07070530, 0.07070370 |
| 21.022039638771555 | 0.0475556741611 | 0.0477615, 0.0475684, 0.04755687, 0.04755579 |

At a zero `ζ(1/2+it) = 0`, the partial sum is therefore `≈ √N/|s−1|` — it never
"sees" the zero; the zero appears only after the cancellation
`ζ − S_N = −√N/|s−1| + O(N^{−1/2})`.

## 2. The smoothing law (T2) — the round's main result

**Theorem 2 (weight law).**  For a bounded weight `φ : [0,1] → ℝ` whose Mellin
transform `M_φ(s) = ∫_0^1 φ(u)u^{−s}du` converges,

```
|S_N^φ(1/2+it) − ζ(1/2+it)| / √N   →   |M_φ(s)| .
```

**VERIFIED** to 5–7 digits at `N = 10^5`, `t = 14.134725141734693`, for six weights:

| weight `φ(u)` | measured `\|E\|/√N` | `\|M_φ(s)\|` | ratio |
|---|---|---|---|
| `1` (sharp) | 0.070703705 | `\|1/(s−1)\| = 0.070703528` | 1.0000025 |
| `u(1−u)` | 0.0049012629 | 0.0049012243 | 1.00001 |
| `(u(1−u))^3` | 0.00011771845 | 0.00011771845 | 1.000000 |
| `(1−cos 2πu)/2` | 0.0079729835 | 0.0079729835 | 1.000000 |
| `e^{−u}` | 0.026142297 | 0.026142378 | 0.999997 |

**Consequences.**

1. **The `√N` growth is universal.**  No bounded weight removes it; the last-decade
   log–log exponent is `0.5000` for every weight tested.
2. **Smoothing buys only a constant.**  Best of the tested weights,
   `(u(1−u))^3`: `|M_φ| = 1.18·10^{−4}` against the sharp `7.07·10^{−2}` — a factor
   `600`.  The max of `|E|√N` over `N = 10^2 … 10^5` is `7070` (sharp), `490`
   (`u(1−u)`), `11.8` (`(u(1−u))^3`), `797` (raised cosine), `2614` (`e^{−u}`).
3. **The residual's closed form.**  `S_N^φ − ζ = N^{1−s}J_φ(s) + φ(0)ζ(s) + R_N`,
   with `|R_N|·√N` bounded by a weight-dependent constant: `0.5` exactly for the
   sharp cutoff (`R_N = ½N^{−s}`), `0.0386` (`u(1−u)`), `1.25·10^{−3}` (raised
   cosine), `3.3·10^{−7}` (`(u(1−u))^3`), `0.192` (`e^{−u}`), with fitted residual
   slopes `−0.50, −1.00, −2.00, −3.00, −0.49`.  For the exponential weight *summed
   to convergence* one has instead `E = Γ(1−s)N^{1−s} + O(1/N)` with
   `|Γ(1−s)| = √(π/cosh πt) = 5.7·10^{−10}` — exponentially small in `t`, but the
   hidden `√N` term takes over only beyond `N ≈ 4.6·10^{18}`.
4. **Bounded error would need `M_φ(s) = 0`** for the relevant heights `t`.  For a
   *nonnegative* weight this is impossible, since `∫_0^1 φ(u)u^{−1/2−it}du` cannot
   vanish when `φ ≥ 0` is not identically zero (the integrand has constant argument
   `−t log u`, and the modulus integral is strictly positive).  A sign-changing
   `φ` could in principle make the integral vanish at isolated `t`; making it vanish
   identically in `t` would need the measure `φ(u)u^{−1/2}du` to annihilate every
   `u^{−it}`, which forces `φ ≡ 0`.  Either way the one-sided route cannot reach
   `o(1)` for all `t`.

## 3. Exponential accuracy needs the functional equation (T3)

**Theorem 3 (Riemann's theta identity).**
```
π^{−s/2}Γ(s/2)ζ(s) = 1/(s(s−1)) + ½[A(s) + A(1−s)] ,   A(s) = ∫_1^∞ x^{s/2−1}(θ(x)−1)dx ,
```
with `θ(x) = Σ_{n∈ℤ} e^{−πn²x}` and `θ(1/x) = √x θ(x)`.
**PROVED** (classical; Riemann 1859), **VERIFIED** by the auditor's independent route
(own theta + own incomplete gamma, no import from the round): agreement with `ζ` to
`5.7·10^{−69}` (`s = 2`), `1.8·10^{−68}` (`s = 4`), `1.0·10^{−64}` (`s = 1/2+it₁`).
The rigorous tail bound decays like `e^{−πX}`: `B(X) = 7.9·10^{−7}, 1.6·10^{−12},
1.2·10^{−23}, 1.0·10^{−45}, 1.9·10^{−48}` at `X = 4, 8, 16, 32, 34`.

**The bridge, therefore, exists — but it is the functional equation that builds it.**
A one-sided smoothed sum has error `√N·|M_φ(s)|`; the theta route is
`e^{−πX}`-accurate with `O(√t)` terms.

## 4. Zero localisation (T4)

**VERIFIED.**  With a reliable `ζ` evaluator (mpmath's `mp.zeta`, cross-checked by
the auditor's theta route), bracketed bisection gives the first five zeros:
`14.1347251417346937904572519836`, `21.0220396387715549926284795939`,
`25.0108575801456887632137909926`, `30.4248761258595132103118975306`,
`32.9350615877391896906623689641` (both routes agree to the `1e-44` bisection floor).

In contrast, the **sharp partial sum cannot do this**: for `N = 10^3, 10^4` the first
positive roots of `Re S_N(1/2+it)` are `0.30398963, 0.21372367`, with `60` and `102`
roots in `(0,35)` (stable under scan refinement `0.05` vs `0.02`) — generic
oscillations, `t_1·log N = 2.0999, 1.9685` (an effective `t_1 ~ (log N)^{−1.22}` from
the two-point fit, drifting to the model `π/2`), and `|ζ(1/2+it_1)| = 1.26, 1.35`,
i.e. no root within `10^{−3}` of a true zero.  (The `N = 10^5` count `≈128` from
earlier partial runs is **not** claimed here: it was omitted for runtime and is
unverified — recorded as OPEN.)
**Two independent calculations (`Re S_N` and `Z(t)`) confirm: the sharp partial sum's
roots are not zeta zeros.**  (`Re ζ` alone also has spurious roots — at `0.8195`,
`20.654`, `29.739`, `33.624` there are sign changes of `Re ζ` but no zero of `ζ`;
only `Z(t)`-based bracketing is reliable.)

## 5. The zero count (T5)

**VERIFIED with caveat.**  `N(30) = 3`, `N(35) = 5` (counted via `Z`-sign changes).
The Riemann–von Mangoldt main term is `(T/2π)log(T/2πe) + 7/8 = 3.5647` at `T = 30`,
so `N(30) − main = −0.5647 = S(30)/π`, inside the expected oscillation; the main term
alone rounds to 4 and does **not** determine the count.

## 6. Verdict for the gap, and the parity problem

* The gap of `../rh43/truths.md` §7.6 is **closed in the sense that the mechanism is
  identified**: the sharp cutoff's `O(√N)` is the Euler–Maclaurin main term
  `N^{1−s}/(1−s)`; smoothing rescales its constant by `|M_φ(s)|/|1/(s−1)|`; and
  `o(1)` accuracy is available only via the functional equation, at `e^{−πX}`.
* It is **not** closed in the sense of a new bridge: the route is Riemann's (1859) /
  Riemann–Siegel (1932), and this round adds no new analytic input.
* **Parity problem:** unchanged and untouched.  Every object here is an additive
  character in `log n`; the round's one genuinely new statement (Theorem 2) is a
  statement about the *weight*, not about multiplicative structure, and nothing in it
  turns the sign of `cos(t log n)` into divisor information.  The parity obstruction
  is exactly the absence of such an input.

## 7. Open

* Whether some non-positive or oscillating weight has `M_φ(1/2+it) = 0` identically
  in `t` (which would give bounded error without the functional equation) — the
  Mellin transform of a real weight cannot vanish identically by a positivity
  argument on `[0,1]`, but a complex-valued weight is not excluded by this round.
* An explicit `N`–`t` trade-off for the smoothed route in the `o(1)` regime.
