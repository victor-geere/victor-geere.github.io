# (23) The entire repackaging — C(w) = Γ_Φ(w)/Γ(w+1) is entire

**Kind:** Proposition
**Status:** PROVED (paper argument)
**Area:** xi-horn
**Source:** [`xi-horn/CONTINUATION.md`](../../xi-horn/CONTINUATION.md) — §1 "The entire repackaging", equation (23)

## Statement

> The Taylor coefficients of ξ are c(n) = γ(n)/(2n)!, and (2n)! = Γ(2n+1), so the continuation of *that* sequence is
>
> ```
> C(w) = Γ_Φ(w) / Γ(w+1)                                                     (23)
> ```
>
> and this is **entire**. 1/Γ(w+1) has simple zeros at w = −1, −2, −3, …; Γ_Φ has simple poles at w = −1, −3, −5, …. Every pole is cancelled, and C picks up simple zeros at w = −2, −4, −6, … where the reciprocal gamma vanishes and Γ_Φ does not. At the cancelled points C takes finite values — e.g. C(−1) = 4Φ(0).
>
> That is the whole content of the "divide by (2n)!" step of POSITIVITY.md §3, seen properly: it is what turns a function with a pole string into an entire one.

## Hypotheses and notation

- γ(n) = 4∫₀^∞ u^{2n}·Φ(u)du are the even moments of the horn's profile; c(n) = γ(n)/(2n)! are the Taylor coefficients of ξ about ½.
- Γ_Φ is the Mellin transform of Φ, meromorphic on ℂ with simple poles at w = −1, −3, −5, … only (equation (22)).
- Γ(w+1) is the gamma function; 1/Γ(w+1) is entire with simple zeros at w = −1, −2, −3, ….
- The cancelled points are the odd negative integers w = −1, −3, −5, …; the new zeros are the even negative integers w = −2, −4, −6, ….

## Proof / evidence

The source gives the mechanism directly: the pole string of Γ_Φ (simple poles on the odd negative integers) and the zero string of 1/Γ(w+1) (simple zeros on all negative integers) cancel at the odd negative integers, and what remains of the reciprocal gamma's zeros are simple zeros of C at the even negative integers. At a cancelled point the value is finite; the source quotes C(−1) = 4Φ(0).

## Dependencies and related results

- The pole string of Γ_Φ: [xihorn-continuation-continuation-and-pole-string.md](xihorn-continuation-continuation-and-pole-string.md).
- The "divide by (2n)!" step, c(n) = γ(n)/(2n)!: [POSITIVITY.md](../../xi-horn/POSITIVITY.md) (9).
- The holomorphic margin built from C: [xihorn-continuation-holomorphic-margin.md](xihorn-continuation-holomorphic-margin.md).

## Notes

- The source states the entire property and the zero/pole bookkeeping without a separate formal proof; they follow from the pole string (22) and the standard zeros of 1/Γ.
- The source flags this as a re-reading of a step already performed in POSITIVITY.md §3, not as new content beyond the analytic explanation.
