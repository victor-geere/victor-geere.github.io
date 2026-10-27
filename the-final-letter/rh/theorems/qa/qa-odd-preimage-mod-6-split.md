# The odd-preimage split: m ≡ 4 (mod 6) iff m has an odd Collatz ancestor

**Kind:** Theorem
**Status:** PROVED (paper argument)
**Area:** workspace
**Source:** [`qa.md`](../../research/various/qa.md) — Q11 answer (a), lines 396–411

## Statement

> In the Collatz tree (valid assuming the conjecture), going *backward* from a number m, the predecessors of m are always 2m (doubling), plus an **odd predecessor** n = (m − 1)/3 exactly when m ≡ 4 (mod 6) (so that n is an odd integer). So the "3n + 1 edges" of the tree land precisely on the residue class 4 mod 6. Therefore:
>
> - numbers **≡ 4 (mod 6)** have a unique odd Collatz-ancestor — they are "Collatz-composite," reachable by a 3n + 1 step;
> - numbers **≢ 4 (mod 6)** (i.e. ≡ 0, 1, 2, 3, 5 mod 6) have no odd ancestor — they are "Collatz-prime," odd-irreducible, only reachable by doubling.

## Hypotheses and notation

- The Collatz map is T(n) = n/2 if n even, T(n) = 3n + 1 if n odd.
- "Odd predecessor" of m means an odd n with T(n) = m, i.e. 3n + 1 = m.
- The tree is read backward from m: the predecessor via doubling is 2m, and the odd predecessor, when it exists, is n = (m − 1)/3.
- The source states the tree reading as "valid assuming the conjecture" (i.e. assuming every n reaches 1).
- The naming "Collatz-prime / Collatz-composite" is the source's own framing, and it says so.

## Proof / evidence

The source gives the argument inline: an odd predecessor n must satisfy 3n + 1 = m, so n = (m − 1)/3, which is an odd integer exactly when m ≡ 4 (mod 6). The doubled predecessor 2m always exists. The source labels the mod-6 split as its own framing ("This is my own framing, not literature"), while the arithmetic criterion itself is elementary and is proved in the sentence quoted.

## Dependencies and related results

- The source notes that the term "primes of a Collatz series" is undefined in the literature, and presents this as "the cleanest nonstandard 'prime vs. composite' reading"; it is also "genuinely Collatz-specific: it is the additive '3n + 1' structure, not ordinary multiplication, that does the factoring."
- The same answer gives two other readings it does not establish: (b) the ordinary rational primes appearing in an orbit (an open question), and (c) prime starting values (heuristic, no theorem known).

## Notes

- The status is PROVED (paper argument): the residue criterion is established in the source's own one-line argument. Only the *validity of the backward tree reading* is conditional on the conjecture, as the source states.
- The terminological half of the statement ("Collatz-prime", "Collatz-composite") is the source's framing and has no established status in the literature; the source says so explicitly.
