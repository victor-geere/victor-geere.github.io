# Certification requires zero information

**Kind:** Proposition
**Status:** PROVED (paper argument)
**Area:** workspace
**Source:** [`research-journal.md`](../../research-journal.md) — Round 7, line 572; Round 10 B's final verdict, line 691

## Statement

> The conclusion survives by a different route and should be stated as *certification requires zero information*: the only unconditional control is S(T) = O(log T), so no modulus depending on N alone can bound the truncation error.

Round 10, Agent B's closing note:

> His closing note: the greedy bound is *an easy tail estimate*, and the correct statement about certification is only that bounding ζ's truncation error requires zero information.

## Hypotheses and notation

- S(T) = N(T) − (T/2π)log(T/2π) + T/2π − 7/8 is the error term in the zero-counting formula; the unconditional bound quoted is S(T) = O(log T).
- "No modulus depending on N alone" means: no bound of the truncation error that is a function only of the number of terms N.
- Context: A had claimed the large sieve gives a √(N/T) lower bound on the L² mean error; that citation was refuted (see the large-sieve file).

## Proof / evidence

Stated as the corrected conclusion after the refutation of A's large-sieve lower bound. The journal's reasoning: the only unconditional control available is S(T) = O(log T), which depends on T (hence on the height), not on the number of terms N; therefore no modulus depending on N alone can bound the truncation error.

## Dependencies and related results

- [The Montgomery large sieve is an upper bound (A's lower-bound citation reversed)](research-journal-large-sieve-inequality.md) — the refutation that this conclusion replaces.
- [A's certification theorem for the greedy residual](research-journal-certification-theorem.md) — the greedy-side certification that does transfer, by contrast.
- [The AFE truncation floor: canonical m = √(t/2π) terms, error O(t^{−1/4})](research-journal-afe-truncation-floor.md) — the truncation error in question.

## Notes

- The status is PROVED (paper argument) on the strength of the O(log T) control: an N-only modulus cannot capture an error governed by S(T), which is a function of the height.
- The source contrasts this with the greedy construction's certification theorem, where 0 ≤ r_N ≤ Σ_{k>N}α_k **is** computable from N alone: "Certification, not the sine, is the idea that transfers — and it does not transfer to ζ."
