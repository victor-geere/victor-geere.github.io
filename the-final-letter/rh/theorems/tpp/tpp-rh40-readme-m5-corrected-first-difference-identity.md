# M5 — the corrected finite-word first-difference identity p(L+1) − p(L) = RS(L) − Z(L)

**Kind:** Claim
**Status:** VERIFIED (numerical; all four dialogue words for every L, 5 666 values, 0 failures; independently recomputed against a bit-string implementation)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/README.md`](../../research/twin-prime-parity/rounds/rh40/README.md) — §4 "Corrections established at programme open", item **M5** (lines 144–163)

## Statement

> **Agent B repaired it in round 1, and the mediator has independently reproduced B's repair.** Define
>
> ```
> Z(L) := #{ f ∈ F(L) : f has no right extension inside w_N }
>       = #{ f ∈ F(L) : every occurrence of f ends at the last position } ∈ {0,1}
> ```
>
> Then the exact finite-word identity is
>
> ```
> p(L+1) − p(L) = RS(L) − Z(L)          for every L,
> ```
>
> verified by the mediator on all four dialogue words for **every** L (5 666 values, 0 failures), against an independent bit-string implementation that shares no code with `digitword.py`. See `verify/verify_agentB.py`. Z(L) is a uniqueness indicator for the terminal window t = N − L, not a count of windows; it is 0 on [605, 792] and 1 on [792, 1399] for 1/π, which is exactly why the decay regime is where the classical identity breaks.

## Hypotheses and notation

- `F(L)` is the set of length-`L` factors of the truncation `w_N`; `RS(L)` is the number of right-special factors of length `L`.
- `Z(L) ∈ {0,1}` is the number of length-`L` factors with no right extension inside `w_N`; the README notes it "is a uniqueness indicator for the terminal window `t = N − L`, not a count of windows".
- Agent B's equivalent definition (round 1): with `d⁺(f)` the number of right extensions of `f` inside `w_N`, `Z(L) = #{f ∈ F(L) : d⁺(f) = 0} = |F(L)| − |{prefix(g) : g ∈ F(L+1)}|`, which is 0 or 1.

## Proof / evidence

The README records the identity as verified "by the mediator on all four dialogue words for **every** L (5 666 values, 0 failures), against an independent bit-string implementation that shares no code with `digitword.py`", with `rh40/verify/verify_agentB.py` as the certificate and `RESULT: ALL CLAIMS VERIFIED` as its output. Agent B's round-1 report carries the finer count 18895/18895 over five words (the four dialogue words plus the true `e−2`); see [tpp-rh40-round01-agentb-exact-first-difference-identity.md](tpp-rh40-round01-agentb-exact-first-difference-identity.md). The source gives no proof of the identity beyond the elementary prefix count Agent B states ("`p(L+1)=sum of d+ over F(L)`, counting each (L+1)-factor by its unique length-L prefix").

## Dependencies and related results

- [M5 — Cassaigne's identity fails in the decay regime](tpp-rh40-readme-m5-cassaigne-identity-fails-decay.md) — the failure this identity repairs.
- [Agent B (a) — the exact finite first-difference identity](tpp-rh40-round01-agentb-exact-first-difference-identity.md) — B's own statement, with the refutations `RS(L) − LS(L+1)` 0/18895 and `RS(L) − LS(L)` 5/18895.
- [M2/M3 — five-piece slope structure](tpp-rh40-readme-m2-m3-five-piece-slope-structure.md) — the slope values the identity computes.

## Notes

- The README marks this as **new**: Agent B states "the finite-word correction `Z(L)` is elementary ... and I found no source stating it", and that "the naive `RS(L)-LS(L+1)` has no correct attribution - it is simply false".
- Status is VERIFIED (numerical), not PROVED: the source gives the identity as an exact statement and reports exhaustive verification, but the README's proof section supplies no general derivation for it as such.
