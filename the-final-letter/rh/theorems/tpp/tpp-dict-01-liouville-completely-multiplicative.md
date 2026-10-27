# Lemma 2.1 (multiplicativity)

**Kind:** Lemma
**Status:** PROVED (Lean, `liouville_mul`, for nonzero arguments)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/01-preliminaries.md`](../../research/twin-prime-parity/dictionary/01-preliminaries.md) — §2 "Arithmetic functions: the elementary facts", "Lemma 2.1 (multiplicativity)", line 32

## Statement

> **Lemma 2.1 (multiplicativity).**  `λ` is **completely** multiplicative:
> `λ(mn) = λ(m)λ(n)` for all `m, n ≥ 1`.  `μ` is multiplicative but not completely.

## Hypotheses and notation

- `Ω(n)` = the number of prime factors of `n` **with multiplicity**; `ω(n)` = the number of **distinct** prime factors.
- `λ(n) = (−1)^{Ω(n)}` (the **Liouville** function); `μ(n) = (−1)^{ω(n)}` if `n` is squarefree, else `0` (the **Möbius** function).
- The quantifier is `m, n ≥ 1`; the identity is **not** asserted for `m = 0`.

## Proof / evidence

The source's proof, verbatim:

> *Proof.*  `Ω(mn) = Ω(m) + Ω(n)`, and `(−1)^{a+b} = (−1)^a(−1)^b`.  ∎

The source's status and provenance line, verbatim:

> *Status:* THEOREM.  *Source:* rh46 `Rh46/Chowla.lean` (`liouville_mul`, for nonzero
> arguments; `liouville_mul_zero_false` refutes the `m = 0` case under the convention
> `λ(0) = 1`).

## Dependencies and related results

- Feeds the local-factor computation of [Lemma 2.3 (the divisor identity)](tpp-dict-01-liouville-divisor-identity.md): `Σ_{k≥0} λ(p^k)p^{−ks} = (1 + p^{−s})^{−1}`.
- The sibling dictionary chapter [`03-parity-problem.md`](../../research/twin-prime-parity/dictionary/03-parity-problem.md) records the same fact (harvested as [Liouville is completely multiplicative](tpp-dict-03-liouville-completely-multiplicative.md)).
- Ledger row A3 of [`00-dictionary.md`](../../research/twin-prime-parity/dictionary/00-dictionary.md) records `λ(n) = (−1)^{Ω(n)}`, `μ`, `Λ` with status **DEFINITION**; that row is not harvested (definitions are out of scope).

## Notes

- The source flags this explicitly as **restating round rh46**.
- Recorded trap: extending the identity to `m = 0` fails under the convention `λ(0) = 1`; the Lean declaration `liouville_mul_zero_false` is the recorded refutation.
- The second sentence (`μ` is multiplicative but not completely) is stated in the same labelled lemma; the source names no Lean declaration for it.
