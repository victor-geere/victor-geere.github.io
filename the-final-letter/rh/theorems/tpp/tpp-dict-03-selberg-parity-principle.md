# THEOREM 2.1 (Selberg's parity principle, as sharpened by Polymath8b)

**Kind:** Theorem
**Status:** CITED (literature)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/03-parity-problem.md`](../../research/twin-prime-parity/dictionary/03-parity-problem.md) — §2.1

## Statement

> **THEOREM 2.1 (Selberg's parity principle, as sharpened by Polymath8b).** Consider the class of bounded-depth sieve weights of Definition 1.11. Then:
> **(a)** the *only* arithmetic input a weight of this class can use is the collection of local densities `A_d = (ω(d)/d)X + R_d` for squarefree `d | P(z)`, `d ≤ D`;
> **(b)** there is a non-negative model sequence `b` — with the *same* local densities `A_d` at every such `d`, and supported entirely on `O` (or entirely on a set of `Ω`-parity opposite to the target) — for which the count of `h`-primes is zero;
> **(c)** consequently no positive lower bound for `#{n ≤ x : n+h_1, …, n+h_k all prime}` can be deduced from the class. In particular the sieve cannot certify primality for *any* admissible tuple with `k ≥ 2`.
> **(d) (explicit published instance.)** Polymath8b prove that, even under the **generalised Elliott–Halberstam conjecture**, the best a purely sieve-theoretic argument can reach for an admissible triple is
> *"at least two of `n+h_1, n+h_2, n+h_3` are prime"*, and that this is **optimal** for sieve-theoretic considerations.

## Hypotheses and notation

- The class is that of **bounded-depth sieve weights** (Definition 1.11): parity-blind weights `w ≥ 0` that are finite non-negative combinations of `1_{n ≡ a (mod q)}` with `q | P(z)`, or Selberg weights truncated at a level `D = x^θ`, `θ < 1`; a *rule* is parity-blind if determined by the small-prime divisibility pattern of `n` alone.
- `𝒜` is a finite set of integers, `𝒫` a set of primes, `P(z) = Π_{p ≤ z, p ∈ 𝒫} p`, `A_d = #{n ∈ 𝒜 : d | n}` (Definition 1.9); the local-density input is `A_d = (ω(d)/d)X + R_d` for squarefree `d | P(z)`, `d ≤ D`.
- `O` is the odd parity class `{n : λ(n) = −1}` (Definition 1.5).
- `h = (h_1, …, h_k)` an admissible tuple (Definition 1.6).
- GEH = the generalised Elliott–Halberstam conjecture.

## Proof / evidence

- Cited, not proved here: the source attributes the result to [D. H. J. Polymath, *Variants of the Selberg sieve, and bounded intervals containing many primes*, arXiv:1407.4897, Res. Math. Sci. **1**:12 (2014)](https://arxiv.org/abs/1407.4897), quoting its abstract verbatim: *"We modify the 'parity problem' argument of Selberg to show that this result is the best possible that one can obtain from purely sieve-theoretic considerations."*
- The general principle is also cited to Ch. 16 ("the parity problem") of [J. Friedlander, H. Iwaniec, *Opera de cribro*, AMS Colloq. Publ. **57** (2010)](https://www.ams.org/books/coll/057/coll057-endmatter.pdf).
- The source's Appendix A marks the **original 1950 attribution to Selberg unverified** (row Se1), while the parity principle itself is "verified **through its modern use** in P8b and FI3 (row T17)".

## Dependencies and related results

- Definition 1.11 (parity-blind / bounded-depth weights); Definition 1.9 (sieve dimension, `A_d`); Definition 1.5 (parity classes).
- Restated as §4.1 row **T17** and §5.2 (THEOREM 5.2); part (d) is restated together with the bounded-gap numbers as §4.1 row **T8** ([row T8 file](tpp-dict-03-t8-polymath8b-bounded-gaps.md)).
- Its "Reading" is the source's warning that 2.1 is a statement about a **method**, not about the integers.

## Notes

- The source's own reading (quoted): "2.1 is a statement about a **method**, not about the integers. There is **no theorem** saying that the twin prime conjecture is unprovable, or that `E` and `O` cannot be separated by *some* argument. What is excluded is a specific, well-defined class of arguments."
- Harvested with Status CITED (literature): the source sets it out as a labelled theorem rung but proves none of it here.
- Restatements to note: §4.1 rows T17 and T8, §5.2, and the §7 ledger row "2.1".
