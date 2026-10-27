# Cassaigne's first-difference method for an extendable language

**Kind:** Theorem
**Status:** CITED (literature; Cassaigne, *Complexity and special factors*, Bull. SMF 125 (1997) 1–26, Zbl 0921.68065)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/round01_agentB.md`](../../research/twin-prime-parity/rounds/rh40/rounds/round01_agentB.md) — §"[KNOWN]", lines 29–32

## Statement

> Cassaigne's first-difference method (Complexity and special factors, Bull. SMF 125 (1997) 1-26, [Zbl 0921.68065](https://zbmath.org/?q=0921.68065)) gives p(L+1)-p(L)=sum_{f in F(L)}(d+(f)-1) for an *extendable* language, where d+>=1, so HANDOFF §3.4's form p(L+1)-p(L)=#right-special is correct only there; right-special/extendability as in [Cassaigne-Nicolas, arXiv:0903.1627](https://arxiv.org/abs/0903.1627).

## Hypotheses and notation

- `F(L)` is the set of length-`L` factors of the language; `d⁺(f)` is the number of right extensions of `f` inside the language.
- The hypothesis is **extendability**: the language is extendable, so `d⁺(f) >= 1` for every factor, and in that case the number of right-special factors (`d⁺(f) >= 2`) is exactly `Σ_{f∈F(L)}(d⁺(f) − 1)`.
- `HANDOFF.md` §3.4's form `p(L+1)-p(L)=#right-special` is therefore "correct only there" — i.e. only for an extendable language; the finitely supported truncations of the greedy digit word are not extendable, which is why the identity fails in the decay regime.
- The citation for the right-special/extendability framework is Cassaigne–Nicolas, arXiv:0903.1627.

## Proof / evidence

The source states this **without proof**: it is the literature side of Agent B's `[KNOWN]` separation ("separate what is already in the literature (correct attributions, URLs) from what would be new"), with the primary citation given as Bull. SMF 125 (1997) 1–26 and Zbl 0921.68065. The workspace's `HANDOFF.md` §3.4 carries the special (extendable) form as [Cassaigne's first-difference identity for the greedy digit word](../handoff/handoff-cassaigne-first-difference.md); Agent A's `[RECALL]` states the bispecial-count form as [Cassaigne's first-difference theorem](tpp-rh40-round01-agenta-cassaigne-first-difference-theorem.md).

## Dependencies and related results

- [The exact finite first-difference identity p(L+1) − p(L) = RS(L) − Z(L)](tpp-rh40-round01-agentb-exact-first-difference-identity.md) — the finite-word correction of this theorem.
- [Cassaigne's first-difference identity for the greedy digit word](../handoff/handoff-cassaigne-first-difference.md) — the same result as stated in `HANDOFF.md` §3.4.
- [Cassaigne's first-difference theorem (Agent A's recall)](tpp-rh40-round01-agenta-cassaigne-first-difference-theorem.md) — the parallel recalled form.
- [M5 — Cassaigne's identity fails in the decay regime](tpp-rh40-readme-m5-cassaigne-identity-fails-decay.md) — the failure at fixed `N`.

## Notes

- Status CITED (literature): the document sets the classical theorem out with an explicit hypothesis and citation as a rung of its own argument, but supplies no proof of its own.
- Agent B "found no source stating" the finite-word correction `Z(L)`; that positive result is harvested separately, not as part of this citation.

- **Primary-source correction (2025-10-06, session 003 citation audit).** The `Status` gives a wrong journal, volume and page range for Cassaigne's `Zbl 0921.68065` (the identity itself was matched to that paper's Proposition 3.4), and the statement drops the "factorial" hypothesis of the paper's Exercise 8. Bibliographic correction recorded here; the mathematical content of the document is supported.
