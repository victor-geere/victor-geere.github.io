# THEOREM 2.6 (the lower bound stops at `P₂`: Chen)

**Kind:** Theorem
**Status:** CITED (literature)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/03-parity-problem.md`](../../research/twin-prime-parity/dictionary/03-parity-problem.md) — §2.3

## Statement

> **THEOREM 2.6 (the lower bound stops at `P₂`: Chen).** There are infinitely many primes `p` such that `p + 2` has at most **two** prime factors (`p+2 ∈ P₂`), and quantitatively `#{p ≤ x : p+2 ∈ P₂} ≫ x/(log x)²`.

## Hypotheses and notation

- `P₂` denotes the set of integers with at most two prime factors, counted with multiplicity.
- `≫` is Vinogradov notation (implied constant absolute).
- `#{p ≤ x : …}` counts primes `p ≤ x`.

## Proof / evidence

- The source gives no proof. *Status:* THEOREM (Chen Jingrun 1973). *Source:* [J. R. Chen, *On the representation of a larger even integer as the sum of a prime and the product of at most two primes*, Sci. Sinica **16** (1973) 157–176](https://www.sciengine.com/doi/10.1360/ya1973-16-2-157) "(verified: title/journal/volume/pages)".
- Appendix A row Che marks the citation **verified** (publisher record `sciengine.com/doi/10.1360/ya1973-16-2-157` for title, journal, volume, pages (the `cdn.` hostname, and the DOI at doi.org, no longer resolve — see Notes), plus an independent bibliographic record).

## Dependencies and related results

- Contrasted with [`THEOREM 2.5`](tpp-dict-03-brun-upper-bound.md) (the upper bound) and with [`OPEN 2.7`](tpp-dict-03-twin-prime-open.md) (`P₁ = prime`, open).
- The source's reading: "The gap between `P₂` (theorem, 2.6) and `P₁ = prime` (open) is *exactly* the parity barrier: the sieve-with-an-extra-condition technique ("Chen's switch") moves the obstruction up by one prime factor and no further. In general, sieve methods give lower bounds for `P_r` for `r ≥ 2` and never for `r = 1`."
- Restated as §4.1 row **T12**; the interpretation of the switch is HEURISTIC 2.8.
- Restated in the §7 ledger row "2.6".

## Notes

- Only the statement of Chen's theorem is harvested; the sentence "the switch is what supplies the parity input" is separately labelled HEURISTIC by the source (see [HEURISTIC 2.8](tpp-dict-03-chen-switch-heuristic.md)) and is not part of this theorem.

- **Primary-source check (2025-10-06, session 003 citation audit).** The statement and the attribution are correct: Chen's 1973 *Scientia Sinica* **16**(2) 157–176 paper proves, as its Theorem II, that for every positive even `h` there are infinitely many primes `p` with `p + h` either prime or a product of two primes — the `p + 2` case quoted here — and the `≫ x/(log x)²` strength is the standard quantitative form of Chen's sieve. Two details: (i) the live publisher page is `sciengine.com/doi/10.1360/ya1973-16-2-157` — the `cdn.` hostname used here no longer resolves and the DOI `10.1360/ya1973-16-2-157` itself returns 404 at doi.org and Crossref; the link is corrected above; (ii) the cited *title* advertises Theorem I (the Goldbach-type statement), while the twin-prime statement is Theorem II of the same paper, so the title alone does not evidence the claim — the attribution is legitimate but the supporting theorem should be named. The `≫ x/(log x)²` clause was verified against the standard literature, not against the primary PDF, which is not freely readable.
