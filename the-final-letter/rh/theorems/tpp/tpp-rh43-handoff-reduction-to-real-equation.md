# The reduction: `P_N + M_N = Re S_N`, and balance as one real equation

**Kind:** Theorem
**Status:** PROVED (paper argument; the identities are Lean-checked in the round)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh43/HANDOFF.md`](../../research/twin-prime-parity/rounds/rh43/HANDOFF.md) — §2.3 "The reduction, and the answer"

## Statement

> ```
> P_N + M_N = Re S_N = 1 + Σ_{n=2}^{N} cos(t log n)        (identity)
> P_N = |M_N|  ⟺  Re S_N(t) = 0                            (one real equation)
> ```

The object and the split are fixed in §2.1:

> `S = i t` with `t` real, and
>
> ```
> S_N(t) = Σ_{n=1}^{N} n^{-it} = Σ_{n=1}^{N} exp(-i t log n) ∈ ℂ          (S_N(0) = N)
> P_N(t) = Σ_{cos(t log n) > 0} cos(t log n) ≥ 0        "the positive parts"
> M_N(t) = Σ_{cos(t log n) < 0} cos(t log n) ≤ 0        "the negative parts"
> ```

## Hypotheses and notation

- `S = i t` with `t` real, i.e. `Re(S) = 0`; `S_N(0) = N`.
- `P_N ≥ 0` the sum of the positive real parts, `M_N ≤ 0` the sum of the negative ones.
- `⟺` is the source's biconditional.

## Proof / evidence

- The source states both lines as an "identity" and as "one real equation" without a separate written proof here; the same identities are proved in Lean (truths.md §0.3 Theorem 1) and verified in the round's numerics.
- §2.3's role in the document is to reduce the round's question to `Re S_N(t) = 0`.

## Dependencies and related results

- The same identities appear in [The round's object and question](tpp-rh43-handoff-object-and-question.md) and in the truths harvest [The split is an identity](tpp-rh43-truths-split-is-an-identity.md).
- Related: [The answer: yes, for every N ≥ 2](tpp-rh43-handoff-answer-yes-every-n.md).

## Notes

- The source presents this as the reduction step of the round's answer rather than as a separately numbered theorem; it is harvested here because the document states it as the identity on which the answer rests.
- The corresponding Lean declarations are recorded in truths.md §0.3 and in the Lean README.
