# The exact finite first-difference identity p(L+1) − p(L) = RS(L) − Z(L)

**Kind:** Claim
**Status:** VERIFIED (numerical; 18895/18895 over five words, 0 failures; the naive forms hold 0/18895 and 5/18895)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/round01_agentB.md`](../../research/twin-prime-parity/rounds/rh40/rounds/round01_agentB.md) — §"[CHARITABLE]" (i) and §"[TESTED]" (a), lines 12–52

## Statement

> Three repairs to HANDOFF §4/§7.2: (i) the exact first difference is p(L+1)-p(L)=RS(L)-Z(L), not RS(L); Z(L) is a uniqueness indicator for the terminal window t=N-L, not a count of windows.
>
> …
>
> (a) For all five words (1/pi (2,13,607) N=1400; log2 (0,4,36,6069) N=13000; sqrt2-1 (1,11,251) N=2000; (10,20,40,80) N=500; true e-2 (0,3,53) N=2000) and every L in [1,N-1]: p(L+1)-p(L)=RS(L)-Z(L) holds 18895/18895, 0 failures; naive RS(L)-LS(L+1) holds 0/18895; RS(L)-LS(L) 5/18895. The mediator's hypothesis is right, sharpened: the loss is -Z(L) in {0,-1}, and Z(L)=1 exactly when the terminal window t=N-L produces a factor occurring at no other t. For 1/pi, Z=0 on [605,791], Z=1 on [792,1399], RS=0 throughout; first_difference_check disagrees on exactly the 608 values L in [792,1399], first L=792=N-a_m-1.

## Hypotheses and notation

- `w_N` is a finitely supported word with ones `a_0 < … < a_m < N` (`m >= 1`); `F(L)` is its length-`L` factor set; `d⁺(f)` is the number of right extensions of `f` inside `w_N`; `RS(L)` is the number of right-special factors of length `L`.
- `Z(L) = #{f in F(L) : d⁺(f)=0} = |F(L)| − |{prefix(g) : g in F(L+1)}|`, "which is 0 or 1"; equivalently "`Z(L)=1` exactly when the terminal window `t=N-L` produces a factor occurring at no other `t`".
- The five test words are `1/pi (2,13,607)` at `N = 1400`, `log2 (0,4,36,6069)` at `N = 13000`, `sqrt2-1 (1,11,251)` at `N = 2000`, `(10,20,40,80)` at `N = 500`, and the true `e-2 (0,3,53)` at `N = 2000`.

## Proof / evidence

The source gives an elementary derivation: "The finite-word correction Z(L) is elementary (p(L+1)=sum of d+ over F(L), counting each (L+1)-factor by its unique length-L prefix) and I found no source stating it". The verification is the count above (18895/18895), and Agent B adds that "the naive RS(L)-LS(L+1) has no correct attribution - it is simply false". The same identity is independently reproduced by the mediator in the README for all four dialogue words and every `L` (5 666 values, 0 failures, against a bit-string implementation sharing no code with `digitword.py`); see [tpp-rh40-readme-m5-corrected-first-difference-identity.md](tpp-rh40-readme-m5-corrected-first-difference-identity.md).

## Dependencies and related results

- [Cassaigne's first-difference method for an extendable language](tpp-rh40-round01-agentb-cassaigne-extendable-language.md) — the classical identity this repairs for finite words.
- [M5 — Cassaigne's identity fails in the decay regime](tpp-rh40-readme-m5-cassaigne-identity-fails-decay.md) — the failure being repaired.
- [M5 — the corrected finite-word identity](tpp-rh40-readme-m5-corrected-first-difference-identity.md) — the README's independent reproduction.
- [Agent B (b) — the plateau and the decay crossover](tpp-rh40-round01-agentb-plateau-decay-boundary.md) — the `Z`/`RS` ranges on `1/pi`.

## Notes

- Agent B's `[VERDICT]` records the identity as "exactly verified" and the source states the finite-word correction is new: "I found no source stating it".
- The two refuted alternatives in the same test — `RS(L)-LS(L+1)` (0/18895) and `RS(L)-LS(L)` (5/18895) — are recorded here rather than as separate files; they are refutations of proposed corrections, not results.
