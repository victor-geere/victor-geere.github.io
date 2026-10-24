# Why no radix can do it

**Kind:** Theorem
**Status:** PROVED (paper argument)
**Area:** rh-html
**Source:** [`rh7.html`](../../html/rh7.html) — §1 "The answer, and why a radix cannot move a prime", theorem box at lines 234–237

## Statement

> A radix is a choice of **additive** bookkeeping: it fixes how a number is assembled from place values by addition. Primality is a statement about **multiplicative** structure — the impossibility of a factorization. The two structures are related only through distributivity, which every base shares. So "the primes in base <i>b</i>" is, for any <i>b</i> whatsoever, the same set of numbers wearing different names. This is why the interesting question is not <i>which</i> numbers are prime in the 2π base, but **which objects the sieve is acting on** once it has been moved there — and there the answer does change.

## Hypotheses and notation

- A radix is any base <i>b</i>; the document's case of interest is the 2π base of the nested-circle numeral.
- Primality is the impossibility of a factorization, i.e. a property of the multiplicative structure of ℕ; place-value assembly is additive.
- Distributivity is the only relation between the two structures and is shared by every base.
- The "sieve" is the sieve of sines of rh5 §1, i.e. the rows sin(π<i>x</i>/<i>p</i>).

## Proof / evidence

The source argues the claim directly in §1 and reports the computation that motivated it: the first-miss cascade was run twice, "once on integers as in rh5 §1, and once natively, enrolling <i>rotations</i> rather than divisors", with both runs giving

> {2} ↦ 3, {2,3} ↦ 5, {2,3,5} ↦ 7, {2,3,5,7} ↦ 11, {2,3,5,7,11} ↦ 13.

"Nothing moved." The reason given is the additive/multiplicative distinction quoted in the statement.

## Dependencies and related results

- rh5 §1's sieve of sines and its first-miss cascade.
- The section's answer to the object-level question is the companion box "The relocation" (rh7 §2), which is not a theorem box and is not harvested: "the primes of the 2π base are the rotations of prime order".
- rh7 §4's box "The primes are not where they were" (harvested as rh7-primes-not-where-they-were.md) continues the object-level answer.

## Notes

- The source's box is labelled with a descriptive title rather than "Theorem"; it is a `box thm` block.
- The word "whatsoever" and the emphasis are the source's own; the claim is base-independence of the set of primes, not of its representation.
