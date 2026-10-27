# (9) The Turán inequality — c(n) = γ(n)/(2n)! is log-concave

**Kind:** Theorem
**Status:** CITED (literature; Csordas–Norfolk–Varga 1986, attribution flagged from memory; verified numerically for all n = 0 … 33)
**Area:** xi-horn
**Source:** [`xi-horn/POSITIVITY.md`](../../xi-horn/POSITIVITY.md) — §3 "Where the content actually is", equation (9)

## Statement

> The Taylor coefficients of Ξ are not γ(n) but
>
> ```
> c(n) = γ(n) / (2n)!                                                         (9)
> ```
>
> and *these* are log-concave. Verified for **all n = 0 … 33**:
>
> ```
>    n     c(n+1)²/(c(n)c(n+2))      Δ²log c(n)
>    0        2.149687885            −0.765323   OK
>    1        1.594115499            −0.466319   OK
>    2        1.405737775            −0.340562   OK
>    3        1.310063099            −0.270075   OK
>    5        1.212569287            −0.192741   OK
>   10        1.121044533            −0.114261   OK
>   15        1.085425112            −0.081972   OK
>   20        1.066295169            −0.064190   OK
>   25        1.054301221            −0.052878   OK
>   30        1.046055488            −0.045026   OK
> ```
>
> That is the **Turán inequality**, and it is a theorem — Csordas–Norfolk–Varga, 1986, from memory; check the citation before publishing it. Nothing is being discovered here. What is being *obtained* is the explicit form below.

## Hypotheses and notation

- γ(n) = 4∫₀^∞ u^{2n}·Φ(u)du are the even moments of the horn's profile.
- c(n) = γ(n)/(2n)! are the Taylor coefficients of ξ about ½ (equation (7)).
- Log-concavity is c(n+1)² ≥ c(n)·c(n+2), equivalently Δ²log c(n) ≤ 0.
- The verification is for all n = 0 … 33 at 60 decimal digits.

## Proof / evidence

The source attributes the result to Csordas–Norfolk–Varga, 1986, explicitly flagged as from memory, and reports a numerical verification for all n = 0 … 33: the ratio c(n+1)²/(c(n)c(n+2)) and the second log-difference Δ²log c(n) are tabulated (ratios 2.149687885 falling through 1.212569287 at n = 5 to 1.046055488 at n = 30; Δ²log c(n) negative throughout). The source states plainly: "Nothing is being discovered here."

## Dependencies and related results

- The moment expansion (7): [xihorn-positivity-moment-expansion-of-xi.md](xihorn-positivity-moment-expansion-of-xi.md).
- The margin identity that splits this ratio: [xihorn-positivity-margin-identity.md](xihorn-positivity-margin-identity.md).
- The Laguerre–Pólya sequence a(n) = γ(n)·n!/(2n)!: [xihorn-positivity-jensen-laguerre-polya-criterion.md](xihorn-positivity-jensen-laguerre-polya-criterion.md).

## Notes

- The citation is flagged by the source itself: "Csordas–Norfolk–Varga, 1986, from memory; check the citation before publishing it". The source's README dictionary also names it: "its log-concavity is the Turán inequality, a theorem since Csordas–Norfolk–Varga 1986".
- The numerical verification covers n = 0 … 33 only; the theorem itself is quoted as literature, not established here.
