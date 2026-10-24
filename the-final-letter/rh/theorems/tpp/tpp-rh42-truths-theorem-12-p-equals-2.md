# Theorem 12 (p = 2)

**Kind:** Theorem
**Status:** VERIFIED (exact rational arithmetic; structure from Theorem 10)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh42/truths.md`](../../research/twin-prime-parity/rounds/rh42/truths.md) — §5 "The exact structure at `p = 2` and `p = 3`"

## Statement

> At `p = 2`,
>
> ```
> S_2 = [0, π²/24 − 1/4] ∪ [1/4, π²/24],   the single gap being (0.161233516712…, 0.25).
> ```
>
> `π²` is enclosed by exact rationals (Machin: `π = 16 atan(1/5) − 4 atan(1/239)`,
> width `5.6·10⁻⁸⁴`), so reachability of a *rational* target is decidable in exact
> arithmetic.

## Hypotheses and notation

- `p = 2`, alphabet/positive half `a_k = (2k)^{−2}`.
- `S_2` — the sub-sum set of `a_2, a_3, …` (indices as in Theorem 10; the source's §5 display writes it for the `p = 2` positive half).
- `π²/24 = P(2)` and `π²/24 − 1/4 = P(2) − a_1` with `a_1 = 1/4` (Theorem 5).
- Machin's formula `π = 16 atan(1/5) − 4 atan(1/239)`; enclosure width `5.6·10⁻⁸⁴`.
- "Rational target reachable" means decidable in exact `Fraction` arithmetic given the rational enclosure of `π²`.

## Proof / evidence

The source states this as:

> **VERIFIED**: ten rational targets decided exactly, including
> `1/5 → not reachable`, `3/20 → reachable`, `1/4 → reachable`, `0.41 → reachable`,
> `0.42 → not reachable`. The unreachable rational `x = 1/5` stalls at
> `1/5 − (π²/24 − 1/4) = 0.038766483287…`; the exact `Fraction` run takes **every**
> even index `2, 4, …, 2K` and nothing else, and the deficit from the stall value is
> the missing tail, rigorously in `(0, 1/(4K))`.

The structural form (one gap, at the census threshold `n_min(2) = 2`) is proved by [Theorem 10 (census, new)](tpp-rh42-truths-theorem-10-census.md); the handoff ledger row T11 records the transition from PROOF-SKETCH to **PROVED** (Theorem 10) + **VERIFIED** exactly.

## Dependencies and related results

- [Theorem 10 (census, new)](tpp-rh42-truths-theorem-10-census.md) (structure), [Theorem 5 (closed forms)](tpp-rh42-truths-theorem-5-budget-closed-forms.md) (`P(2) = π²/24`).
- The refinement `measure(S_1) = 2^{n_min−1} · T_{n_min}` and the interval count follow from Theorem 10.
- Handoff ledger row R2/T11 (§11): "at `p = 2` the reachable set is one-gap".
- The unreachable target `x = 1/5` at `p = 2` is also the witness of [R2 — "inside the budget ⟹ writable"](tpp-rh42-truths-r2-inside-budget-not-writable.md) and [R5 — "every rational target terminates" at general p](tpp-rh42-truths-r5-rational-termination-general-p.md), and is one of the §8 fixtures of Theorem 16.

## Notes

- The source gives the gap as `(0.161233516712…, 0.25)` and the stall residual as `0.038766483287…`; both are quoted exactly as printed.
- The evidence is exact-rational (`Fraction`), not floating point; the enclosure width `5.6·10⁻⁸⁴` is the source's.
