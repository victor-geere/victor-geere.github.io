# (P1) Euler product and analytic continuation of `ζ`

**Kind:** Theorem
**Status:** CITED (literature, classical)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/01-preliminaries.md`](../../research/twin-prime-parity/dictionary/01-preliminaries.md) — §3 "Prerequisites: what the programme uses from analysis", "(P1)", line 72

## Statement

> **(P1) Euler product and analytic continuation of `ζ`.**  `ζ(s) = Π_p (1−p^{−s})^{−1}`
> for `σ > 1`, with a simple pole at `s = 1` of residue `1`, and the functional equation
> `π^{−s/2}Γ(s/2)ζ(s) = π^{−(1−s)/2}Γ((1−s)/2)ζ(1−s)`.

## Hypotheses and notation

- `s = σ + it` is a complex variable; `σ > 1` is the range of the Euler product.
- The product is over the primes `p`; `Γ` is the gamma function.
- `ζ` is the Riemann zeta function, `Σ n^{−s}` for `σ > 1`, continued (source's §1 notation).

## Proof / evidence

The source gives no proof for this prerequisite; it carries only the status line, verbatim:

> *Status:* THEOREM (classical).

## Dependencies and related results

- Prerequisite for [the Dirichlet series on the critical line](tpp-dict-01-critical-line-truncation-error.md) and [the explicit formula (Riemann–von Mangoldt)](tpp-dict-01-explicit-formula-rvm.md).
- The ledger row A1 of [`00-dictionary.md`](../../research/twin-prime-parity/dictionary/00-dictionary.md) records `ζ(s)`, Euler product, functional equation with status **DEFINITION**; that row is not harvested.

## Notes

- Listed by the source under **§3 "Prerequisites: what the programme uses from analysis"**, i.e. as an imported classical rung of the programme's arguments, not as a new result of the workspace.
- Status is therefore recorded as **CITED (literature)**.
