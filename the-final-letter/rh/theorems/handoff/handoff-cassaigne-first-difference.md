# Cassaigne's first-difference identity for the greedy digit word

**Kind:** Theorem
**Status:** CITED (literature; verified for the tested words)
**Area:** workspace
**Source:** [`HANDOFF.md`](../../research/various/HANDOFF.md) — §3.4 "The first-difference identity — a theorem, verified", lines 134–142; §8.2 item 6

## Statement

> Cassaigne's first-difference theorem holds in every case tested:
>
> ```
> p(L+1) − p(L) = # { right-special factors of length L }
> ```
>
> where a factor f is right-special iff both f·0 and f·1 occur. Verified for all three dialogue words at L = 1, 5, 10, 20, 100; e.g. {10,20,40,80} gives p(L+1) − p(L) = 1, 1, 2, 3, 0 at L = 1, 5, 10, 20, 100, and the right-special counts agree exactly each time.

## Hypotheses and notation

- p(L) := #{ distinct factors of length L occurring in w } (§2), counted in a truncation w_N of length N.
- A factor f of length L is right-special iff both f·0 and f·1 occur as factors of length L+1 in the word.
- The three dialogue words and their truncations are those of §2: N = 1400 (x = 1/π), N = 13000 (log 2), N = 2000 (√2−1).

## Proof / evidence

The source states this without proof; it attributes it to Cassaigne and verifies it numerically on the tested words (§8.2 item 6 makes it a required regression test: "`test_cassaigne_first_difference` — p(L+1) − p(L) equals the number of right-special factors, for every word and L tested"). The source presents it as "the single most useful proven tool for the open problem".

The source quotes the measured instance: for {10,20,40,80}, p(L+1) − p(L) = 1, 1, 2, 3, 0 at L = 1, 5, 10, 20, 100, with the right-special counts agreeing exactly each time.

## Dependencies and related results

- [handoff-offset-tuple-characterisation](handoff-offset-tuple-characterisation.md) — the ground-truth enumeration p(L) that both sides of the identity are computed from.
- §8.3 (Tier 1) states the finite form actually used: `p(L+1) - p(L) = #{f ∈ factors L : f ++ [0] ∈ factors (L+1) ∧ f ++ [1] ∈ factors (L+1)}`.
- §4 uses the identity to convert the complexity question into one about right-special factors, "which for a sparse word is a question about how many ways a window can be extended."

## Notes

- The status is CITED (literature), not PROVED: the source labels it "Cassaigne's first-difference theorem" and supplies only verification on the tested words, no proof of its own. The task's reading rule for a classical result set out as a labelled rung of the argument applies here.
- The source's own word is "verified" ("a theorem, verified", "holds in every case tested"): the finite checks do not by themselves establish the general statement.
