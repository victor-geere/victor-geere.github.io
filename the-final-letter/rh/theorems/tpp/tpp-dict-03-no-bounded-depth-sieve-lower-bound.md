# THEOREM 5.2 (what is excluded)

**Kind:** Theorem
**Status:** PROVED (paper argument, immediate from THEOREM 2.1 / §2.1)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/03-parity-problem.md`](../../research/twin-prime-parity/dictionary/03-parity-problem.md) — §5.2

## Statement

> **THEOREM 5.2 (what is excluded).** By §2.1, no argument in the class of bounded-depth sieves (Definition 1.11) can produce a positive lower bound for the number of `n` with `n+h_1, …, n+h_k` prime, for any `k ≥ 2`. In particular, no pure sieve argument can prove `π₂(x) → ∞`, and — the sharpest published form — even under the generalised Elliott–Halberstam conjecture a sieve cannot improve on "at least two of any three admissible forms are prime" (T8).

## Hypotheses and notation

- The class of **bounded-depth sieves** is Definition 1.11 (parity-blind weights: finite non-negative combinations of `1_{n ≡ a (mod q)}` with `q | P(z)`, or Selberg weights truncated at `D = x^θ`, `θ < 1`).
- `h = (h_1, …, h_k)` is an admissible `k`-tuple (Definition 1.6); `k ≥ 2`.
- `π₂(x) := #{p ≤ x : p+2 prime}`.
- Row **T8** is the Polymath8b bounded-gap statement: see [row T8](tpp-dict-03-t8-polymath8b-bounded-gaps.md) and [THEOREM 2.1](tpp-dict-03-selberg-parity-principle.md) part (d).

## Proof / evidence

- The source derives this immediately from [`THEOREM 2.1`](tpp-dict-03-selberg-parity-principle.md) (§2.1): part (c) of 2.1 says no positive lower bound can be deduced from the class, and part (d) supplies the sharpest published instance.

## Dependencies and related results

- [`THEOREM 2.1`](tpp-dict-03-selberg-parity-principle.md) (the no-go theorem); [THEOREM 5.3](tpp-dict-03-no-impossibility-theorem.md) (the complementary "what is not excluded"); [HEURISTIC 5.4](tpp-dict-03-missing-input-heuristic.md) (the heuristic on what input would be needed); [OPEN 2.7](tpp-dict-03-twin-prime-open.md).
- Restated in the §7 ledger row "5.2".

## Notes

- This is a **method-class** statement: the source insists that what is excluded is a specific, well-defined class of arguments, not the integers and not every possible proof (see THEOREM 5.3).
