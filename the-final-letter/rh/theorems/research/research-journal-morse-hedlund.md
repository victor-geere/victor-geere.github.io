# Morse–Hedlund: p(L) = L + 1 for all L iff Sturmian

**Kind:** Theorem
**Status:** CITED (literature)
**Area:** workspace
**Source:** [`research-journal.md`](../../research-journal.md) — Round 7, line 566; "The ten things that stand" §10, line 623

## Statement

> What *is* true is the qualitative statement both agents converged on: the words are **finitely supported and eventually identically zero**, hence non-recurrent, so they cannot be Sturmian (Morse–Hedlund: p(L) = L+1 for all L ⟺ Sturmian ⟺ a coding of an irrational rotation), and p(L) **saturates** rather than growing linearly. So the complexity law is OPEN and the Sturmian reading is dead.

Restated among the ten things that stand:

> The greedy word itself is finitely supported, eventually zero, non-recurrent, hence **not Sturmian** (Morse–Hedlund) and **not a rotation sequence** — three-distance belongs to the constant-threshold model the handoff replaced.

## Hypotheses and notation

- p(L) is the number of distinct length-L factors of a binary word.
- A word is Sturmian iff p(L) = L + 1 for every L ≥ 1; equivalently it is a coding of an irrational rotation.
- The greedy digit word has finitely many 1s, so it is finitely supported and eventually identically zero.

## Proof / evidence

The theorem is cited (Morse–Hedlund) and used as the criterion: a Sturmian word has p(L) = L + 1 for all L, whereas the greedy words have p(L) saturating (for 1/π, p(L) = 609 for L ≥ 605), so they are non-Sturmian. The contrast is quantified in the same round: for a Sturmian word of slope b = θ/π, #ones(N) = bN + O(1) is **linear** (2026, 4413, 2637 at N = 20000 for the three targets), whereas the greedy word has A(N) = log₂ log N + O(1).

## Dependencies and related results

- [B's structural characterisation of the factor complexity](research-journal-complexity-structural-characterisation.md) — the saturating complexity law this framework interprets.
- [The complexity pair formula p(L) = L + 1 + Σ_{i<j} max(0, L − a_j + a_i)](research-journal-complexity-pair-formula.md) — the leading term that fails beyond small L.
- [The three-distance theorem (Sós 1958, Surányi 1958)](research-journal-three-distance-theorem.md) — the rotation structure that the greedy word does not have.

## Notes

- The status is CITED (literature): the Morse–Hedlund characterisation is classical, set out here as the rung by which the Sturmian reading of the greedy word is refuted.
- The source's contrast: "constant threshold → Θ(N) ones; harmonic threshold → Θ(log log N) ones; (θ/π)log N matches neither." Agent B refuted the mediator's identification of the retracted (θ/π)log N with the Sturmian prediction.
