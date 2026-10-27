# Lemma 2.2 (the square)

**Kind:** Lemma
**Status:** PROVED (Lean, `liouville_sq`, `liouville_abs_le_one`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/01-preliminaries.md`](../../research/twin-prime-parity/dictionary/01-preliminaries.md) — §2 "Arithmetic functions: the elementary facts", "Lemma 2.2 (the square)", line 39

## Statement

> **Lemma 2.2 (the square).**  `λ(n)² = 1` and `|λ(n)| ≤ 1` for every `n`.

## Hypotheses and notation

- `λ(n) = (−1)^{Ω(n)}` is the **Liouville** function (`Ω` counts prime factors with multiplicity).
- "for every `n`" is the source's quantifier; no restriction on `n` is stated.

## Proof / evidence

The source's proof, verbatim:

> *Proof.*  `λ(n) = ±1`.  ∎

The source's status and provenance line, verbatim:

> *Status:* THEOREM.  *Source:* rh46 (`liouville_sq`, `liouville_abs_le_one`).

## Dependencies and related results

- Immediate from the definition of `λ` (see [Lemma 2.1 (multiplicativity)](tpp-dict-01-liouville-completely-multiplicative.md) for the surrounding notation).
- Underlies the trivial bound `|S(x)| ≤ x` of the correlation (ledger row F1 of [`00-dictionary.md`](../../research/twin-prime-parity/dictionary/00-dictionary.md), harvested as [the trivial two-point bounds](tpp-dict-00-correlation-trivial-bound.md)).

## Notes

- The source flags this as **restating round rh46**.
- The source writes "for every `n`" without excluding `n = 0`; contrast the explicit `m = 0` trap recorded for `liouville_mul` in [Lemma 2.1](tpp-dict-01-liouville-completely-multiplicative.md).
