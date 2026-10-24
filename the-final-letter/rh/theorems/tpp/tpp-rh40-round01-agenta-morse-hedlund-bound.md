# Morse–Hedlund: a non-eventually-periodic word has p(L) ≥ L+1

**Kind:** Theorem
**Status:** CITED (literature)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/round01_agentA.md`](../../research/twin-prime-parity/rounds/rh40/rounds/round01_agentA.md) — §"[RECALL]", lines 33–35

## Statement

> Morse–Hedlund: a non-eventually-periodic word has `p(L) ≥ L+1`; our word is finitely supported hence non-recurrent — that bound is attained in the C1 regime and lost later (HANDOFF §5).

## Hypotheses and notation

- `p(L)` is the number of distinct factors of length `L` of a (one-sided) infinite word.
- "Non-eventually-periodic" is the hypothesis: the word is not eventually periodic; equivalently its factor complexity is unbounded, and the cited bound `p(L) ≥ L+1` holds for it.
- "Our word" is the greedy harmonic digit word `w(x)` for `x = θ/π` (HANDOFF.md §2), which has finite support (finitely many 1s) and is therefore eventually identically zero, hence non-recurrent — so the lower bound cannot persist.
- The "C1 regime" is the prefix/linear regime of `p(L) = L + 1 + #{d_i < L}`; the source's phrase "lost later" refers to the saturation of `p(L)`.

## Proof / evidence

The source states this **without proof**; it is a recalled literature result used as a criterion. The workspace's parallel statement (from `research-journal.md`, Round 7) is the Sturmian form "p(L) = L+1 for all L ⟺ Sturmian ⟺ a coding of an irrational rotation", harvested as [Morse–Hedlund: p(L) = L + 1 for all L iff Sturmian](../research/research-journal-morse-hedlund.md), where the greedy words are shown to be non-Sturmian precisely because they saturate.

## Dependencies and related results

- [Morse–Hedlund: p(L) = L + 1 for all L iff Sturmian](../research/research-journal-morse-hedlund.md) — the equivalent characterisation harvested from `research-journal.md`.
- [Cassaigne's first-difference theorem](tpp-rh40-round01-agenta-cassaigne-first-difference-theorem.md) — the adjacent recalled result in the same `[RECALL]` section.
- [M6 — C1 as stated is false](tpp-rh40-readme-m6-c1-regime-boundary-refuted.md) and [Theorem D (the C1 regime, proved)](tpp-rh40-k-remaining-theorem-d-c1-regime.md) — the C1 regime the source says attains the bound.

## Notes

- Status CITED (literature): the document sets the classical result out as a rung of its own argument (it explains why the linear lower bound is attained only in the C1 regime and then lost), but supplies no proof of its own.
