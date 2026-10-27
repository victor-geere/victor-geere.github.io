# The Montgomery large sieve is an upper bound (A's lower-bound citation reversed)

**Kind:** Theorem
**Status:** CITED (literature)
**Area:** workspace
**Source:** [`research-journal.md`](../../research-journal.md) — Round 7, line 572

## Statement

> **B's refutation of A's large-sieve citation, accepted.** A wrote that the large sieve gives an L² mean error lower bound ~√(N/T) and cited Montgomery's *Topics in Multiplicative Number Theory*. B: the Montgomery large sieve is an **upper** bound, Σ_{r≤R}|Σ_{n≤N}a_n e(nt_r)|² ≤ (N + δ^{−1})Σ|a_n|² for δ-well-spaced points ([Montgomery, *Topics in multiplicative number theory*, LNM 227 (1971); zbMATH 0216.03501](https://zbmath.org/?q=an%3A0216.03501)); no lower bound of the stated shape follows, and lower bounds need second-moment/resonance arguments with different exponents. **The citation supports the opposite direction.** The conclusion survives by a different route and should be stated as *certification requires zero information*: the only unconditional control is S(T) = O(log T), so no modulus depending on N alone can bound the truncation error. A has now over-claimed in [RECALL] five times.

## Hypotheses and notation

- a_n are coefficients; {t_r} are δ-well-spaced points; the inequality is Σ_{r≤R}|Σ_{n≤N}a_n e(nt_r)|² ≤ (N + δ^{−1})Σ|a_n|².
- "δ-well-spaced" means |t_r − t_s| ≥ δ for r ≠ s.
- The claimed (false) lower bound was ~√(N/T).

## Proof / evidence

The source states the Montgomery large sieve inequality verbatim as the classical upper bound and cites it via the zbMATH record of Montgomery's *Topics in Multiplicative Number Theory*. The refutation is a direction check: an upper bound cannot yield the stated lower bound. The journal also states the replacement conclusion (see the certification-zero-information file) and records this as Agent A's fifth over-claim in [RECALL].

## Dependencies and related results

- [Certification requires zero information](research-journal-certification-zero-information.md) — the conclusion that survives by the different route.
- [Riemann–von Mangoldt: N(T) = (T/2π)log(T/2π) − T/2π + 7/8](research-journal-riemann-von-mangoldt.md) — the S(T) = O(log T) control invoked.
- [The AFE truncation floor: canonical m = √(t/2π) terms, error O(t^{−1/4})](research-journal-afe-truncation-floor.md) — the truncation error in question.

## Notes

- The status is CITED (literature): the large sieve inequality is a classical theorem cited as a rung, and the harvested content includes the journal's correction of its direction. The source does not prove the large sieve.
- The journal records this under the second-sitting error tally: "A: … the large-sieve direction and citation … all but one caught by B or by me."

- **Primary-source correction (2025-10-06, session 003 citation audit).** The zbMATH identifier given here, `0283.10024`, is **not** Montgomery's book: that record is Tijdeman, *On the maximal distance between integers composed of small primes*, Compos. Math. **28** (1974) 159–162 — a different subject. Montgomery's *Topics in multiplicative number theory* is LNM **227** (1971), zbMATH **0216.03501**, and the identifier is corrected above. The inequality and its direction are classical and correctly stated as an upper bound, but "the Montgomery large sieve" also miscredits it: the analytic large sieve is due to Linnik (1941), Rényi, Roth, Bombieri and Selberg–Gallagher, with Montgomery's book as an expositor. The mathematics of this document is unaffected; the citation now points at a real book about the real inequality.
