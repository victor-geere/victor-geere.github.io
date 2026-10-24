# HEURISTIC 4.5 (why log-averaging is genuinely weaker)

**Kind:** Claim
**Status:** CONJECTURED (structural explanation; the rigorous content is THEOREM 4.4)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/03-parity-problem.md`](../../research/twin-prime-parity/dictionary/03-parity-problem.md) — §4.3

## Statement

> **HEURISTIC 4.5 (why log-averaging is genuinely weaker).** The logarithmic average weights `n ≤ x` by `1/n`, and is therefore dominated by the top of the range `[1, x]`; a bound on it constrains the *renormalised* partial sums `Σ_{n≤y}λ(n)λ(n+h)` only along a set of scales `y` of full logarithmic density, and gives no bound at a **prescribed** `y`, hence no bound on `S(y)/y` for any fixed `y`. There is no known Tauberian device that recovers an unweighted Cesàro mean from a `1/n`-weighted mean for a sequence such as `n ↦ λ(n)λ(n+h)` (which is neither non-negative nor monotone nor multiplicative).

The file's status line: *Status:* HEURISTIC (a structural explanation; the rigorous content is 4.4).

## Hypotheses and notation

- `S(y) := Σ_{n≤y} λ(n) λ(n+2)`; `λ` is the Liouville function (Definition 1.2).
- The logarithmic average weights `n ≤ x` by `1/n`; a "prescribed" scale `y` means a fixed `y`, as opposed to almost every scale.
- A Tauberian device would be needed to pass from the `1/n`-weighted mean to the unweighted Cesàro mean.

## Proof / evidence

- The source states this explicitly as **HEURISTIC**, and identifies its rigorous content as [`THEOREM 4.4`](tpp-dict-03-log-averaged-no-implication.md).
- The claim "there is no known Tauberian device" is a statement about the state of knowledge, not a proved impossibility.

## Dependencies and related results

- [`THEOREM 4.4`](tpp-dict-03-log-averaged-no-implication.md) (the rigorous statement); [THEOREM 3.8](tpp-dict-03-tao-log-two-point-chowla.md) / [THEOREM 3.9](tpp-dict-03-tao-teravainen-log-all-orders.md) (the log-averaged theorems); [OPEN 3.4](tpp-dict-03-two-point-chowla-open.md).
- Restated in the §7 ledger row "4.4–4.6".

## Notes

- Harvested because the source numbers and labels it; status CONJECTURED so the explanation is not read as a proof of the non-implication. The source itself says the rigorous content is 4.4.
