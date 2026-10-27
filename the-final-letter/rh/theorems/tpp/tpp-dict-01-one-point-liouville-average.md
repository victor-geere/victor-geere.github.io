# Lemma 2.4 (the one-point average — a THEOREM)

**Kind:** Lemma
**Status:** PROVED (paper argument; unconditional)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/01-preliminaries.md`](../../research/twin-prime-parity/dictionary/01-preliminaries.md) — §2 "Arithmetic functions: the elementary facts", "Lemma 2.4 (the one-point average — a THEOREM)", line 56

## Statement

> **Lemma 2.4 (the one-point average — a THEOREM).**  `Σ_{n≤x} λ(n) = o(x)`.  Indeed
> `λ = 1_squares ∗ μ` (i.e. `Σ_{n≥1}λ(n)n^{−s} = ζ(2s)/ζ(s)`), so
> `Σ_{n≤x}λ(n) = Σ_{d≤√x} M(x/d²)`, and `M(y) = Σ_{n≤y}μ(n) = o(y)` — which is
> **equivalent to PNT** — gives `o(x)·Σ_d d^{−2} = o(x)`.

## Hypotheses and notation

- `λ` is the Liouville function; `μ` the Möbius function; `M(y) = Σ_{n≤y} μ(n)`.
- `1_squares` is the indicator of the perfect squares, `∗` is Dirichlet convolution.
- `o(x)` is as `x → ∞`; the statement is unconditional.
- `M(y) = o(y)` is the source's cited equivalence to the prime number theorem.

## Proof / evidence

The source gives the proof route inline in the statement (quoted above) and the following status, correction and citation lines, verbatim:

> *Status:* THEOREM (unconditional; the `k = 1` Chowla case is equivalent to PNT).
> *Recorded correction:* rh46 §1.3 and rh47 §5.1 mislabel this **OPEN**; it is not.
> *Citation:* Tao, [arXiv:1605.04628](https://arxiv.org/abs/1605.04628).
> *Verified here:* `Σ_{d≤√x}M(x/d²) = Σ_{n≤x}λ(n)` exactly for `x = 100, 1000`, and
> `L(x)/x = −0.01400, −0.00940, −0.00288, −0.00053` at `x = 10³…10⁶`.

## Dependencies and related results

- [Lemma 2.3 (the divisor identity)](tpp-dict-01-liouville-divisor-identity.md) supplies `Σ λ(n)n^{−s} = ζ(2s)/ζ(s)`, i.e. `λ = 1_squares ∗ μ`.
- PNT (via `M(y) = o(y)`) is the analytic input.
- Same result in the sibling dictionaries: [the one-point case is equivalent to PNT](tpp-dict-05-one-point-case-equivalent-pnt.md) and [the one-point Chowla case iff PNT](tpp-dict-03-one-point-chowla-iff-pnt.md).

## Notes

- The source states a **recorded correction**: rh46 §1.3 and rh47 §5.1 mislabel this result **OPEN**; the source asserts it is not open. Read the harvested files from those rounds with that correction in mind.
- The `L(x)/x` figures are finite-range numerical values at `x = 10³…10⁶`; the source lists them as a check, not as the proof.
- No Lean declaration is named here for this lemma.
