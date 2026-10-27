# Theorem 3.1 (factorisation through the height — THEOREM)

**Kind:** Theorem
**Status:** PROVED (paper argument; source also NUMERICAL, 200 dps)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/02-greedy-harmonic-sine.md`](../../research/twin-prime-parity/dictionary/02-greedy-harmonic-sine.md) — §3 "The helix, and what the word cannot see", "Theorem 3.1 (factorisation through the height — THEOREM)", line 76

## Statement

> **Theorem 3.1 (factorisation through the height — THEOREM).**  The rule reads exactly
> one real number, the height `x = sin(2πθ)`.  Therefore
> ```
> θ, θ+1, θ+2, 1/2 − θ   give the SAME word;
> 1 − θ                  gives the sign-flipped height, hence the other word;
> the lift (cos 2πθ, sin 2πθ, θ) is not periodic — the word cannot see it.
> ```

## Hypotheses and notation

- "The rule" is the signed (Tau) rule of Definition 2.2, or the unsigned greedy of Definition 1.1; its only input is the target height `x`.
- `θ` is measured in turns; the target is the signed height `x = sin(2πθ)`.
- "Word" `w(x) = δ_0δ_1δ_2…` is the take/skip sequence of Definition 1.1.
- The lift is the triple `(cos 2πθ, sin 2πθ, θ)`.

## Proof / evidence

The source gives the proof verbatim:

> *Proof.*  The rule's only input is the target, and
> `sin(2π(θ+1)) = sin(2πθ)`, `sin(2π(1/2−θ)) = sin(2πθ)`, `sin(2π(1−θ)) = −sin(2πθ)`.  ∎

and the status line:

> *Status:* THEOREM + NUMERICAL (200 dps, prefixes above the `10⁻¹⁰⁰` precision floor).
> *Source:* rh42 §8, `T16`.

## Dependencies and related results

- [Corollary 3.2](tpp-dict-02-periodic-rules-cannot-see-turns.md) — the stated consequence for periodic input functions.
- Definitions 1.1 and 2.2 (the rules) — definitions, not harvested.

## Notes

- Ledger entry for the **rh42** round (§8, `T16`), as the source states.
- The parenthetical "prefixes above the `10⁻¹⁰⁰` precision floor" is the source's own caveat on the numerical check at 200 dps and is reproduced.
