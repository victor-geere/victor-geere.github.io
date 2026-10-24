# the corrected barrier: a sign-blind alphabet with no arithmetic input

**Kind:** Claim
**Status:** OPEN (heuristic; the impossibility must stay OPEN, per the source's own correction 2)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh47/truths.md`](../../research/twin-prime-parity/rounds/rh47/truths.md) — §3 "The barrier, stated correctly (with the audit's corrections)", line 87

## Statement

> **Corrected statement.**  For a **sign-blind alphabet with no arithmetic input**, no object of the greedy-sine programme supplies a positive-density coupling to `Ω`; and `(★)`, the two-point Chowla statement, is **OPEN**.

The source's correction 2, which governs how this is to be read:

> 2. **The impossibility is a heuristic and must stay OPEN.**  What is *proved* is the
>    budget sign-blindness (strengthened by twist invariance) and the Euler-product
>    failure; "the two do not mix" is not a theorem.

## Hypotheses and notation

- "Sign-blind alphabet, no arithmetic input" is the corrected reading of the barrier: the alphabet carries no information about `Ω`.
- `Ω` is the total number of prime factors counted with multiplicity; `λ(n) = (−1)^{Ω(n)}`.
- `(★)` is `Σ_{n≤x} λ(n)λ(n+2) = o(x)`, the two-point Chowla statement.
- "Positive-density coupling" is the requirement recorded by the source: a witness needs positive density, by the sparse bound.

## Proof / evidence

The source states this as the round's corrected barrier and explains the correction:

> Two corrections the audit forced, both now recorded:
>
> 1. **My "every greedy-sine object is an additive character in `log n`" was too wide
>    and imprecise.**  `n^{−it}` is a *multiplicative* character on `(ℝ₊,×)`, and the
>    budgets are *constants* in `p`, not characters.  The barrier must be read as
>    *sign-blind alphabet, no arithmetic input* — because the audit exhibited a greedy
>    object of the *same take rule* whose alphabet is arithmetic
>    (`α_p = (−1)^{Ω(p+2)}/(p+2)`, `z = +10.1`) and which of course mixes: the signal
>    lives in the **alphabet**, not in the greedy selection, and using it is circular.

What is *proved*, on the source's own accounting, is only the budget sign-blindness (strengthened by twist invariance, [B2](tpp-rh47-truths-bridge-b2-index-parity-independent.md)) and the Euler-product failure ([B3](tpp-rh47-truths-bridge-b3-no-euler-product.md)). The barrier claim itself ("the two do not mix") is a heuristic.

## Dependencies and related results

- [B1](tpp-rh47-truths-bridge-b1-no-lambda-parity-signal.md), [B2](tpp-rh47-truths-bridge-b2-index-parity-independent.md), [B3](tpp-rh47-truths-bridge-b3-no-euler-product.md) — the three bridges whose failure the barrier summarises.
- [The rh46 sparse bound is false](tpp-rh47-truths-rh46-sparse-bound-refuted.md) and [the corrected sparse bound](tpp-rh47-truths-corrected-sparse-bound.md) — the density requirement quoted in the barrier.
- Restated in this round: [README barrier](tpp-rh47-readme-barrier-additive-character-open.md) and [HANDOFF barrier](tpp-rh47-handoff-barrier-additive-character-open.md), whose "additive character in `log n`" phrasing is the one corrected here.
- Earlier ledger row: [the corrected barrier](tpp-dict-00-corrected-barrier-open.md).
- The round's open target R2 — "prove (or refute) that no sign-blind deterministic rule seeing `n` only through `log n` can force a multiplicative correlation" — is recorded as **OPEN** in truths.md §5 and is exactly this claim's missing proof.

## Notes

- The status is **OPEN**: the source is explicit that the impossibility is a heuristic and "must stay OPEN", unlike the two verified legs.
- The correction is a *narrowing*: "additive character in `log n`" was too wide (`n^{−it}` is multiplicative on `(ℝ₊,×)`, and the budgets are constants in `p`), so the barrier is stated as *sign-blind alphabet, no arithmetic input*.
- The source's own record correction (README/HANDOFF) repeats that this round's barrier phrasing is too wide and that the impossibility is kept OPEN.
- The `(★)` component is separately recorded as an open problem; the source does not claim to settle it.
