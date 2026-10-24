# HEURISTIC 3.2 (the random-sign model)

**Kind:** Claim
**Status:** CONJECTURED (heuristic model; not a proof)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/03-parity-problem.md`](../../research/twin-prime-parity/dictionary/03-parity-problem.md) — §3.1

## Statement

> **HEURISTIC 3.2 (the random-sign model).** If `(λ(n))_n` were a sequence of independent random signs, every correlation in 3.1 would be `O(x^{1/2+ε})` with probability `1`, and 3.1 would follow. The model ignores complete multiplicativity (which is what makes `λ` interesting) and is therefore **only** a heuristic; it does *not* explain why the correlations should vanish, only why `o(x)` is the "expected" size.

The file's status line: *Status:* HEURISTIC. *Programme note:* rh46's prefix-maximum fit `α = 0.5200 ± 0.0249` is *consistent with* `O(x^{1/2+ε})` on a finite range and proves nothing about the asymptotic — see [`06-numerical-checks.md`](../../research/twin-prime-parity/checks/06-numerical-checks.md).

## Hypotheses and notation

- `(λ(n))_n` is the Liouville sequence (Definition 1.2); the model is that it behaves as independent random signs.
- `x^{1/2+ε}` is the probabilistic size of a sum of `x` independent signs up to `x^{ε}`.
- `α = 0.5200 ± 0.0249` is the source's prefix-maximum exponent fit (round rh46).

## Proof / evidence

- The source states this explicitly as a **heuristic**: it says the model "is therefore **only** a heuristic".
- The programme note records that the finite-range fit `α = 0.5200 ± 0.0249` is consistent with the model's prediction but "proves nothing about the asymptotic".

## Dependencies and related results

- [Conjecture 3.1](tpp-dict-03-chowla-conjecture.md) (the correlations the model predicts); [THEOREM 3.3](tpp-dict-03-one-point-chowla-iff-pnt.md).
- The numerical register: [`06-numerical-checks.md`](../../research/twin-prime-parity/checks/06-numerical-checks.md).
- Restated in the §7 ledger row "3.2".

## Notes

- Harvested because the source numbers and labels it; status CONJECTURED so the heuristic is not read as evidence for the conjecture.
- The source explicitly warns that the model "ignores complete multiplicativity"; the numerical fit is a finite-range consistency check only.
