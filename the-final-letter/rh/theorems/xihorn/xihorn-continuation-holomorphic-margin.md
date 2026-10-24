# (24) The holomorphic margin — positivity at index n is exactly R(2n) > 1

**Kind:** Proposition
**Status:** PROVED (paper argument)
**Area:** xi-horn
**Source:** [`xi-horn/CONTINUATION.md`](../../xi-horn/CONTINUATION.md) — §2 "The holomorphic margin", equation (24)

## Statement

> The Turán ratio continues verbatim, with n → n+1 becoming w → w+2:
>
> ```
>             C(w+2)²          Γ_Φ(w+2)²         (w+3)(w+4)
>    R(w) = ───────────  =  ───────────────── · ──────────────                (24)
>           C(w)·C(w+4)     Γ_Φ(w)·Γ_Φ(w+4)     (w+1)(w+2)
>                           └─ Cauchy–Schwarz ─┘ └─ factorial gain ─┘
> ```
>
> meromorphic on ℂ, and **positivity at index n is exactly R(2n) > 1**. The margin ratio of POSITIVITY.md (11) is M(w) = −log R_γ(w) / log R_f(w), the two bracketed factors above.

The source adds the reading of the construction:

> The margin table is now the restriction of R to the even non-negative integers, and the questions one could not ask of a table become available: where does R equal 1? Is the real axis near that set? What is R doing at infinity?

## Hypotheses and notation

- C(w) = Γ_Φ(w)/Γ(w+1) is the entire continuation of c(n) = γ(n)/(2n)! (equation (23)).
- The first bracketed factor is the Cauchy–Schwarz defect of the horn's profile; the second is the factorial gain (w+3)(w+4)/((w+1)(w+2)).
- R is meromorphic on ℂ.
- Positivity at index n is the Turán condition of POSITIVITY.md (11): Δ²log γ(n) < log[(2n+3)(2n+4)/((2n+1)(2n+2))].
- M(w) is the margin ratio of POSITIVITY.md (11) with the index continued.

## Proof / evidence

The source obtains (24) by continuing the Turán ratio of POSITIVITY.md (10) off the integers, replacing n → n+1 by w → w+2 and using c(n) = γ(n)/(2n)! against (2n)! = Γ(2n+1). The equivalence "positivity at index n is exactly R(2n) > 1" is then the same comparison of defect against gain as POSITIVITY.md (11), evaluated at w = 2n.

## Dependencies and related results

- The entire repackaging C(w): [xihorn-continuation-entire-repackaging.md](xihorn-continuation-entire-repackaging.md).
- The margin identity (10)–(11): [xihorn-positivity-margin-identity.md](xihorn-positivity-margin-identity.md).
- The asymptotic law for R: [xihorn-continuation-asymptotic-law-limit-four.md](xihorn-continuation-asymptotic-law-limit-four.md).

## Notes

- Equation (24) is also the definition of R; what is harvested is the equivalence with Turán positivity at the even integers, together with the meromorphic character of R.
- The source's §6 does not claim this proves anything about RH: it is d = 2 only, and uniformity in the Jensen degree d is left open ([INTEGERS.md](../../xi-horn/INTEGERS.md) §5).
