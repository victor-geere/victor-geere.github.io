# T2 — the smoothing law: `S_N^φ − ζ = N^{1−s} J(φ) + φ(0)ζ(s) + R_N`

**Kind:** Claim
**Status:** VERIFIED (numerical — finite-range fit on `N = 1e2…1.024e5` for six weights; the round's claim (b) "the residual is `O(N^{−σ})` with a weight-dependent constant" is the one marked VERIFIED in the log)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/checks/06-numerical-checks.md`](../../research/twin-prime-parity/checks/06-numerical-checks.md) — § rh044, "Headline numbers", T2 (lines 281–297) and "What it does not" (lines 354–363)

## Statement

> T2 — smoothing. Master law
> `S_N^φ − ζ = N^{1−s} J(φ) + φ(0)ζ(s) + R_N`, `J(φ)=∫_0^1 φ(u)u^{−s}du`, `R_N=O(N^{−σ})`:
>
> | weight φ | φ(0) | φ(1) | `|J|` (predicted `|E|/√N`) | observed at `N=102400` | residual slope |
> |---|---|---|---|---|---|
> | sharp `1` | 1 | 1 | 0.0707035277318 | 0.0707037004038 | −0.499989 |
> | `e^{−u}` (to N) | 1 | 0.3679 | 0.0261423776999 | 0.0261423115614 | −0.486895 |
> | raised cos `(1−cos 2πu)/2` | 0 | 0 | 0.00797298346237 | 0.00797298346841 | **−2.0** |
> | `u(1−u)` | 0 | 0 | 0.00490122433646 | 0.00490126062799 | **−0.999426** |
> | `(u(1−u))³` | 0 | 0 | 0.000117718448844 | 0.000117718448844 | **−3.00351** |
> | `e^{−u}` to convergence | — | — | `|Γ(1−s)| = 5.708835887e-10 = √(π/cosh πt)` | — | −0.998519 |
>
> Verdicts printed in the log:
> **(a) "the `O(√N)` fluctuation is removed by every weight with `φ(1)=0`" → REFUTED**
> (witness `u(1−u)`: `|E|(1.024e5)/|E|(400) = 16.4666` vs a `√N` factor `16.0`);
> **(b) "the residual is `O(N^{−σ})` with a weight-dependent constant" → VERIFIED**,
> with the sharper observed rates tabulated above.

## Hypotheses and notation

- `S_N^φ(s) = Σ_{n≤N} φ(n/N) n^{−s}` is the smoothed partial sum; `ζ = ζ(s)`.
- `J(φ)=∫_0^1 φ(u)u^{−s}du`; the leading term is `N^{1−s}J(φ)`, the second (constant) term `φ(0)ζ(s)`, and `R_N = O(N^{−σ})` the residual.
- Row `e^{−u}` (to N) is the weight truncated at `N`; row `e^{−u}` to convergence is the same weight taken to convergence, whose `|J|` is `|Γ(1−s)| = √(π/cosh πt)`.
- `(u(1−u))³` is the best tested weight; `σ = Re s = 1/2` on the critical line.

## Proof / evidence

- `rh044/smoothed_zeta.py` → `rh044/verify/smoothed_zeta.log` (**`59 checks pass, 0 fail`**, wall `302.5 s`), 60 dps for §§1–2; auditor `rh044/verify/independent_check.py` → `independent_check.log` (**`43/43 auditor checks pass`**, `EXIT_CODE=0`).
- The register's "What it establishes" for this round: "That the smoothed `|E|√N` is **unbounded** over `N=1e2…1e5` for all six weights (max `7070.37` sharp, `2614.23` for `e^{−u}`, `11.7718` for `(u(1−u))³`), and that the local log-log exponent is `+0.5` for every weight in the last decade — smoothing rescales the constant, it does not remove the term."
- `(u(1−u))³` "buys a factor `600`" per the register's summary of this round.

## Dependencies and related results

- T1 (sharp cutoff) and T3 (θ / functional equation) of the same register section.
- The register's *Corrections* item 6 (brief constants) and *item 11* (a withdrawn `x^{1/2+ε}` reading) are the companion corrections.

## Notes

- The verdict (a) refutation is "a finite witness (`N=400` vs `N=1.024e5`); it shows the `√N` term has not disappeared over that range, not that it never can" (register's "What it does not").
- "Only the θ / functional-equation route reaches `o(N^{−A})` for all `A` (error `e^{−πX}`) — and that route *uses* the functional equation, i.e. it is not a smoothing trick. No `φ` of the tested family gives `o(1)`."
- The register repeats its global warning for this row: PASS "means the check's criterion was met on the computed range, not that the claim is proved".
