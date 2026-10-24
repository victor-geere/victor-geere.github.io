# Theorem 4.3 (exponential accuracy needs the functional equation)

**Kind:** Theorem
**Status:** CITED (literature, Riemann's theta identity; source also NUMERICAL)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/04-zeta-relations.md`](../../research/twin-prime-parity/dictionary/04-zeta-relations.md) — §4 "The critical line, and the failure of smoothing (rh43 §7.6, rh044)", "Theorem 4.3 (exponential accuracy needs the functional equation)", line 142

## Statement

> **Theorem 4.3 (exponential accuracy needs the functional equation).**  Riemann's theta
> identity
> ```
> π^{−s/2}Γ(s/2)ζ(s) = 1/(s(s−1)) + ½[A(s)+A(1−s)] ,   A(s) = ∫_1^∞ x^{s/2−1}(θ(x)−1)dx
> ```
> is verified to `5.7·10⁻⁶⁹` (`s=2`), `1.0·10⁻⁶⁴` (at `t = 14.13`), with tail bound
> `e^{−πX}X^{−3/4}` (`X_min = 25` for `10⁻³⁰`).

## Hypotheses and notation

- `Γ` is the gamma function, `ζ` the Riemann zeta function, `θ(x) = Σ_{n∈ℤ} e^{−πn²x}` the theta function used in the identity.
- `A(s) = ∫_1^∞ x^{s/2−1}(θ(x)−1)dx` is the incomplete-theta integral.
- The cited verification points are `s = 2` (to `5.7·10⁻⁶⁹`) and `t = 14.13` (to `1.0·10⁻⁶⁴`); the tail bound is `e^{−πX}X^{−3/4}` with `X_min = 25` for `10⁻³⁰`.

## Proof / evidence

The source gives the identity and its numerical verification only; its status line reads "THEOREM (classical) + NUMERICAL". The source supplies no proof and names no attribution beyond "Riemann's theta identity"; this harvest records it as literature, CITED, with the numerical verification as stated.

## Dependencies and related results

- The section context is the failure of smoothing (Theorem 4.2): exponential accuracy requires the functional equation of `ζ`, which the theta identity encodes.

## Notes

- Ledger entry for the **rh43 §7.6 / rh044** material named in the section heading.
- No attribution beyond the phrase "Riemann's theta identity" is given by the source, and none is added here.
