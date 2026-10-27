# T15 — the N -> infinity asymptotic of the split

**Kind:** Theorem
**Status:** PROVED (identities) + VERIFIED (numerical); at `σ = 0` the ratio does not settle
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh43/truths.md`](../../research/twin-prime-parity/rounds/rh43/truths.md) — §8 ledger row T15 (prose in the section headed `### 7.5 The \`N -> infinity\` asymptotic of the split (T15)`)

## Statement

> | id | statement | status | evidence |
> |---|---|---|---|
> | T15 | the `N -> infinity` asymptotic of the split: `P_N + M_N = P_N − \|M_N\| = Re S_N`; the split converges (and is `~ (1/2)Σ n^{-σ}`) for `σ > 0`, but at `σ = 0` the ratio does not settle | **PROVED** (identities) + **VERIFIED** | §7.5 |

The prose section §7.5 states:

> Take the partial sum at a general abscissa `S = sigma + i t` (the round's case is `sigma = 0`), with `P_N` the sum of the positive real parts and `M_N <= 0` the sum of the negative ones. Two identities are exact for every `N` (**PROVED**, one line each):
>
> ```
> P_N + |M_N| = Σ_{n<=N} n^{-sigma} |cos(t log n)|          ("the additive size")
> P_N - |M_N| = Re S_N(sigma + i t)                         (the signed total)
> hence   relative gap  =  |P_N - |M_N|| / (P_N + |M_N|)
>                       =  |Re S_N(sigma+it)| / Σ n^{-sigma}|cos(t log n)| .
> ```
>
> The numerator is a *cancelling* sum (`Re ζ(σ+it)` in the strip), the denominator is a *non-cancelling* one (`Σ n^{-σ}|cos|`). That ratio is the whole content of the `N -> infinity` question, and its behaviour splits by abscissa:
>
> | abscissa | `P_N + |M_N|` | `|P_N - |M_N||` | relative gap |
> |---|---|---|---|
> | `sigma > 1` | `-> Σ n^{-σ}|cos(t log n)|` (converges) | `-> |Re ζ(σ+it)|` | `O(1)`, no decay |
> | `0 < sigma <= 1` | `~ N^{1-sigma}/(1-sigma)` times a positive constant (`~ (1/2) log N` at `sigma=1`) | `-> |Re ζ(σ+it)|` | `O(N^{-(1-sigma)}) -> 0` |
> | `sigma = 0` | `~ c(t) N`, `c(t)` oscillating | `= |Re S_N(i t)|`, itself `~ |C(t)| N` | `O(1)`, **does not settle** |
>
> Measured (`t = 14.134725`): at `sigma = 1/2`, `N = 10^6`, the gap is `36.05/1284.83 = 0.0281`; at `sigma = 1`, `0.3577/9.899 = 0.0361`; at `sigma = 2`, `0.6892/1.5427 = 0.4467`. **VERIFIED**.

## Hypotheses and notation

- General abscissa `S = sigma + i t`; the round's own case is `sigma = 0`.
- `P_N` the sum of the positive real parts, `M_N <= 0` the sum of the negative ones; the terms carry the radial weight `n^{-sigma}`.
- "Additive size" `P_N + |M_N| = Σ_{n<=N} n^{-sigma} |cos(t log n)|`; "signed total" `P_N - |M_N| = Re S_N(sigma + i t)`.
- Relative gap `= |P_N - |M_N|| / (P_N + |M_N|) = |Re S_N(sigma+it)| / Σ n^{-sigma}|cos(t log n)|`.
- The `sigma = 0` row carries the oscillating constant `c(t)` and `|C(t)|`.

## Proof / evidence

- Ledger row T15: "**PROVED** (identities) + **VERIFIED**", evidence "§7.5".
- The two identities are "exact for every `N` (**PROVED**, one line each)".
- Measured values (VERIFIED) at `t = 14.134725`: gaps `0.0281` (`sigma = 1/2`, `N = 10^6`), `0.0361` (`sigma = 1`), `0.4467` (`sigma = 2`).

## Dependencies and related results

- Related: [Theorem 12 (linear divergence)](tpp-rh43-truths-linear-divergence.md) — at `Re(S) = 0` both the split and its difference grow linearly in `N`, so the "remainder" in the Euler summation `S_N = (N^{1-it} - 1)/(1-it) + (1+N^{-it})/2 + R_N` is of the same order as the term one wants to keep.
- Related: [T16 (the critical-line case)](tpp-rh43-truths-critical-line-sigma-half.md).

## Notes

- The source's consequences and caveats are part of the statement's context: at `sigma = 0` the limit is not a usable asymptotic (`P_N/|M_N|` measured `0.042, 13.0, 0.26, 0.40, 21.3, 0.10` for `N = 10^2 … 10^7` at `t = 1`, "it does not settle"); for `sigma > 0` the limit exists and the balance becomes *relative*.
- The source also records that there is **no** closed form for the additive size `Σ n^{-σ}|cos(t log n)|` in terms of `ζ` alone, and that the guess `P_inf = (ζ(σ) - Re ζ(σ+it))/2` is **false** (it fails at `sigma = 2, t = 14.13`, predicting `0.478` against the measured `1.11597`).
- This asymptotic is explicitly stated **not** to help with the parity problem (truths.md §7.5 "Why this cannot help with the parity problem").
