# C3 — Z(L) counts the length-L factors with no right extension inside w

**Kind:** Claim
**Status:** VERIFIED (numerical; `verify_agentB.py` B-a)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md) — §C "The greedy word itself", register row C3

## Statement

> `Z(L) := |F(L)| − #{prefixes of F(L+1)} = #{f ∈ F(L) : f has no right extension inside w}`

## Hypotheses and notation

- `F(L)` is the set of length-`L` factors of the finitely supported word `w`; "prefixes of `F(L+1)`" means the length-`L` prefixes of the length-`(L+1)` factors, as a set.
- `Z(L)` is defined as the difference of the two counts.

## Proof / evidence

Register row C3's evidence cell reads: "`verify_agentB.py` B-a".

## Dependencies and related results

- Register row C4 (the corrected finite-word identity, which uses `Z(L)`).
- Register row C5 (`Z(L) ∈ {0,1}` always) and C6 (`Z(L) = 1` exactly on `[N − a_m − 1, N − 1]`).
- Register row D4 (the terminal-window lemma), the geometric reading of `Z(L) = 1`.

## Notes

- `Z(L)` is deliberately **not** a left-special count; register row C7 shows `LS ≡ 0` on these words.
