# Cassaigne's first-difference theorem

**Kind:** Theorem
**Status:** CITED (literature)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/round01_agentA.md`](../../research/twin-prime-parity/rounds/rh40/rounds/round01_agentA.md) — §"[RECALL]", lines 35–39

## Statement

> Cassaigne's first-difference theorem `p(L+1)−p(L) = Σ_{L}(k−1)(p_k(L+1)−p_k(L))` — in the bispecial-count form `p(L+1)−p(L) = #{right-special L} − #{left-special L+1}` — is the standard tool; M5 shows the finite word violates the first form in the decay region, which is expected because finitely-supported truncations are not uniformly recurrent.

## Hypotheses and notation

- `p(L)` is the factor complexity of a word; `p_k(L)` are the `k`-special-factor counts appearing in Cassaigne's general first-difference formula, and the second form counts right-special factors of length `L` and left-special factors of length `L+1`.
- The theorem is stated for the classical (extendable / uniformly recurrent) setting; the source's point is that the finitely supported truncations here are **not** uniformly recurrent, so "the finite word violates the first form in the decay region".
- "The standard tool" refers to its role in the round's strategy for the complexity `p(L)` of the greedy harmonic digit word.

## Proof / evidence

The source states this **without proof** and cites no page or paper in this sentence; it is classical literature recalled by Agent A, whose persona is charged with accurate recall of the literature. The workspace records the same identity, with the `#right-special` form and a verification on the tested words, in `HANDOFF.md` §3.4 (harvested as [Cassaigne's first-difference identity for the greedy digit word](../handoff/handoff-cassaigne-first-difference.md)), and Agent B states the general first-difference form for an extendable language with the citation *Complexity and special factors*, Bull. SMF 125 (1997) 1–26, Zbl 0921.68065 (harvested as [Cassaigne's first-difference method for an extendable language](tpp-rh40-round01-agentb-cassaigne-extendable-language.md)).

## Dependencies and related results

- [M5 — Cassaigne's identity fails in the decay regime](tpp-rh40-readme-m5-cassaigne-identity-fails-decay.md) — the failure the source refers to.
- [M5 — the corrected finite-word identity p(L+1) − p(L) = RS(L) − Z(L)](tpp-rh40-readme-m5-corrected-first-difference-identity.md) — the repair for finite words.
- [Agent B — Cassaigne's first-difference method for an extendable language](tpp-rh40-round01-agentb-cassaigne-extendable-language.md) — the same theorem with an explicit citation and hypothesis.
- [Morse–Hedlund: a non-eventually-periodic word has p(L) ≥ L+1](tpp-rh40-round01-agenta-morse-hedlund-bound.md) — the adjacent recalled result.

## Notes

- Status CITED (literature): the document sets the theorem out as a named rung of its own argument (it is the tool that M5 tests and that Agent B repairs), but supplies no proof of its own.
- The `[RECALL]` section also mentions "Trailing-edge corrections to `p` are the standard finite-word phenomenon (Cassaigne–Nicolas, *Factor complexity*)", "Sylvester/Egyptian-fraction and Kim–Song style sparse-word complexity are the nearest relatives", and "Sós, Surányi: the gap-pair statistics `(d_j+d_{j+1})` are the arithmetic-progression-triple quantifier". Those are bare mentions without a stated theorem and are **not** harvested.
