# (12)–(13) The Laguerre–Pólya / Jensen criterion — RH ⟺ F has only real zeros ⟺ every J^{d,n} is hyperbolic

**Kind:** Theorem
**Status:** CITED (literature)
**Area:** xi-horn
**Source:** [`xi-horn/POSITIVITY.md`](../../xi-horn/POSITIVITY.md) — §5 "Beyond d = 2 — the Jensen polynomials", equations (12)–(13)

## Statement

> The full criterion is not Turán alone. Put Ξ in Laguerre–Pólya form: with x = −t²,
>
> ```
> Ξ(t) = F(−t²),      F(x) = Σ γ(n) x^n/(2n)! = Σ a(n) x^n/n! ,
> a(n) = γ(n)·n!/(2n)!                                                       (12)
> ```
>
> RH ⟺ F has only real (negative) zeros ⟺ every Jensen polynomial
>
> ```
> J^{d,n}(X) = Σ_{j=0}^{d} C(d,j)·a(n+j)·X^j                                  (13)
> ```
>
> is hyperbolic.

## Hypotheses and notation

- Ξ(t) = ξ(½ + it) is the completed zeta function (README §2); x = −t².
- γ(n) = 4∫₀^∞ u^{2n}·Φ(u)du are the even moments; F(x) = Σ γ(n)x^n/(2n)! = Σ a(n)x^n/n! with a(n) = γ(n)·n!/(2n)! the Laguerre–Pólya sequence.
- C(d,j) is the binomial coefficient; J^{d,n}(X) = Σ_{j=0}^{d} C(d,j)·a(n+j)·X^j.
- Hyperbolic means all roots real (here, real and negative).

## Proof / evidence

The source states the equivalence chain (12)–(13) as the classical Laguerre–Pólya criterion, without proof, and calls it one of the objects the arc's machinery already certifies. Its §6 states plainly that this is not new: "Jensen/Laguerre–Pólya is classical".

## Dependencies and related results

- The same criterion in its topological form (17): [xihorn-integers-lp-closedness-and-rh-equivalence.md](xihorn-integers-lp-closedness-and-rh-equivalence.md).
- The numerical hyperbolicity check for d ≤ 5: [xihorn-positivity-jensen-hyperbolic-to-d5.md](xihorn-positivity-jensen-hyperbolic-to-d5.md).
- Hyperbolicity as a sign of the discriminant: [xihorn-integers-hyperbolicity-is-a-sign.md](xihorn-integers-hyperbolicity-is-a-sign.md).
- The degree-generating function Σ_d J^{d,n}(X)t^d/d! = e^t·F_n(Xt): [xihorn-continuation-generating-function-all-jensen-degrees.md](xihorn-continuation-generating-function-all-jensen-degrees.md).

## Notes

- The source's §6 lists what this does not do: "**Finitely many conditions verified.** d ≤ 5, n ≤ 33. RH needs all d and all n, and the hard part is uniformity in d, which no amount of this table touches."
- The README dictionary states the same equivalence with the certification range: "RH ⟺ every J^{d,n} hyperbolic (all roots real) — certified here for d ≤ 6, n ≤ 30 by interval LDLᵀ, inside Chasse 2013's d ≤ 2×10¹⁷".
