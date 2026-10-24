# [DREAM] the window-class sum for p(L)

**Kind:** Claim
**Status:** **REFUTED as stated (2026-10-11 attack; OP-36).** The `[DREAM]` sum `p(L) = 1 + #{}(L>span) + Σ_{i≤j}|T(i,j)|` over-counts on **all 1399** `L` for `x = 1/π` (`T(i,j)` counts last-index `≤ j`, so each window is counted `m−J+1` times; the `(i,j)`-class-sizes variant over-counts on 604/1399); replaced by the corrected shape-union formula in the OP-34 entry. See `research/attacks/OP-34-36-37-35.md`.
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/round01_agentA.md`](../../research/twin-prime-parity/rounds/rh40/rounds/round01_agentA.md) — §"[DREAM]", lines 9–29

## Statement

> The object is a *window-class sum*. For a window start `t` write `[i(t), j(t)]` for the block of `ones` it meets; the factor is `(a_i−t, …, a_j−t)`. Each class contributes a set of translates, and `p(L)` is the size of the union. I claim the exact description is
>
> `T(i,j) = max(0, min(a_i, a_{j+1}−L) − max(0, a_{i−1}+1, a_i−L+1) + 1)`,
> `p(L) = 1 + #{}(L>span) + Σ_{i≤j} |T(i,j)|`,
>
> with the convention `a_{−1}=−1`, `a_{m+1}=∞`; the `+1` is the all-zero factor, present iff `L ≤ span` or `N−L+1` is large. My own implementations of this kept over-counting by 1–2 % in *ad hoc* runs, so I mark the union step **[DREAM]**, not [COMPUTABLE] — the class decomposition is right, my cardinality bookkeeping is not yet.
>
> Physically: for `L ≤ d_1+1` only singleton classes fire, so `p(L)=L+1`; the pair class `(i,i+1)` switches on at `L=d_i+2`, adding slope 1 (`d_i < L`); the deficit `D(L)=max_j(L−d_j−1−S_{1,j−2})_+` then grows linearly and *eats the pair slope back* — that is the 2→1. The plateau is `a_m+2`; the fall at `L=N−a_m` is the last 1 leaving the window.

## Hypotheses and notation

- `0 ≤ a_0 < … < a_m < N` is the support of the truncation `w_N`; `d_i = a_{i+1} − a_i` are the gaps; `span = a_m − a_0`.
- `[i(t), j(t)]` is the block of ones met by the window starting at `t`, i.e. the factors are classified by the index and offset of their first 1.
- `S_{1,k}` denotes the gap-chain sums the `[LEAP]` section refers to ("the arithmetic of the gap-chain sums `S_{1,k}`"); the source does not otherwise define them.
- Conventions: `a_{−1} = −1`, `a_{m+1} = ∞`; `#{}(L>span)` is the source's own notation for the all-zero-factor indicator.

## Proof / evidence

The source states this **without proof** and explicitly marks it conjectural: "I mark the union step **[DREAM]**, not [COMPUTABLE] — the class decomposition is right, my cardinality bookkeeping is not yet", and "My own implementations of this kept over-counting by 1–2 % in *ad hoc* runs". No verification of the formula is reported in this file.

## Dependencies and related results

- [Agent A (a) — the boundary rule L_max](tpp-rh40-round01-agenta-boundary-rule-l-max.md) — the companion `[COMPUTABLE]` result, itself refuted in general.
- [Agent A (c) — the decay law and the plateau value](tpp-rh40-round01-agenta-decay-law-and-plateau-value.md) — the `a_m+2` plateau value invoked here, verified separately.
- The source's own conventions are those of `HANDOFF.md` §3.2's offset-tuple enumeration, harvested as [the exact structural characterisation of the greedy digit word](../handoff/handoff-offset-tuple-characterisation.md).

## Notes

- The source's `[DREAM]` tag means conjecture, not result; it is harvested because the formula is presented as a labelled declaration, and it is recorded here with Status CONJECTURED so that the status cannot overstate.
- The `[LEAP]` section of the same file ("If the class decomposition closes, the whole complexity of the greedy word is the arithmetic of the gap-chain sums `S_{1,k}`, and `p` becomes decidable from the support alone") is a conditional remark on this conjecture, not a separate result, and is not harvested separately.
