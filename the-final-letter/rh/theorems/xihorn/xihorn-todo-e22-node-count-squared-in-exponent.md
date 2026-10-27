# E22 — the node count is the diagnostic, squared in the exponent

**Kind:** Claim
**Status:** PROVED (paper argument — Poisson summation on G5's saddle; with two measured consequences)
**Area:** xi-horn
**Source:** [`xi-horn/TODO.md`](../../xi-horn/TODO.md) — §E "Corrections already applied", entry E22

## Statement

> **E22. E10 is right and incomplete: the node count *is* the diagnostic,
> squared in the exponent.** E10 retracted "the binding constraint is node
> density" and said, correctly, that counting nodes across the peak estimates
> *algebraic* convergence while the trapezoid on this integrand is
> **geometric**. True — but it left the node count looking irrelevant, and it
> is not. **G5**'s saddle gives the peak's half-width in closed form,
> σ = 1/√(−P″(v\*)), and the integrand is Gaussian to leading order, so Poisson
> summation puts the rule's relative error at
>
> ```text
> error  ≈  exp( −2π²·(σ/h)² )
> ```
>
> — the nodes across the width, entering *squared in the exponent* rather than
> as a power. Two consequences, both measured. The law says halving h
> **quadruples** the correct digits, against E10's "roughly triples" read off
> H1's ladder; H1 measured ×3.79 and ×3.29, which is ×4 seen through a slowly
> moving σ and a precision floor. And it says exactly where the fixed grid
> gives out: σ/h is 4.60 at w = 2000, 1.90 at 9600, **0.86 at 4×10⁴** and 0.24
> at 4×10⁵, for predicted errors 4e−182, 1e−31, 4.6e−7 and 0.31. Measured, the
> standard grid agrees with a halved one to ten digits at w = 9600, to seven at
> 4×10⁴, and returns **−19.7** at w = 6.4×10⁶ where the truth is 3.693.

## Hypotheses and notation

- σ = 1/√(−P″(v\*)) is the peak's half-width from G5's saddle; h is the trapezoid step.
- The integrand is Gaussian to leading order; Poisson summation gives the relative error exp(−2π²(σ/h)²).
- The conclusion drawn: `Mellin::standard` is not a universal rule; `watson::adapted_rule` is what to use above w ≈ 4×10⁴.

## Proof / evidence

Derivation (Poisson summation on the Gaussian near the saddle) with two measured consequences: the digits-per-halving law ×4 against H1's measured ×3.79 and ×3.29, and the grid's failure point predicted at σ/h = 0.86 (4×10⁴, predicted error 4.6e−7) and 0.24 (4×10⁵, predicted error 0.31), with the standard grid returning −19.7 at w = 6.4×10⁶ where the truth is 3.693.

## Dependencies and related results

- [G5 — the C3 constant](xihorn-rust-results-g5-watson-constant-4.md) — the saddle σ = 1/√(−P″) comes from the same Laplace analysis; [H5 — the Lambert-W asymptotic](xihorn-h-track-h5-lambert-w-asymptotic.md) supplies the Lambert W used there.
- [H1 — a(n) at n = 1000](xihorn-h-track-h1-a1000-vs-os-table-1.md) — the ladder of digits per halving this law corrects (E10's "roughly triples").
- [E22 in rust/RESULTS.md](xihorn-rust-results-e22-node-count-error-law.md) — the same by-product recorded from the Rust side.

## Notes

- The source labels E22 explicitly "**not an error but a sharpening**" of E10, kept in the correction register "because anyone who acts on E10 alone will get the reach of the quadrature wrong".
- The measured contradiction of the old rule is stated by the source: "`Mellin::standard` is not a universal rule and never was; … **any table of Γ_Φ or R at large w computed on the fixed grid should be re-checked against it**."
