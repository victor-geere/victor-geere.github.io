# H3 — the three bridges B1, B2, B3 all fail

**Kind:** Claim
**Status:** REFUTED (numerical; no signal, index parity invisible to the correlation, no Euler product)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh47/HANDOFF.md`](../../research/twin-prime-parity/rounds/rh47/HANDOFF.md) — §3 "What this round verifies (done — 23/23 probe, 31/31 audit)", item **H3**, line 97

## Statement

> **H3** bridges B1, B2, B3 all fail: no signal (B1), index parity independent of
> `Ω`-parity and *invisible to the correlation itself* (`S(λ·(−1)ⁿ) = S(λ)` exactly,
> B2), no Euler product with discrepancy `2.0144` against tail `1.84·10⁻⁵` (B3).

## Hypotheses and notation

- B1, B2, B3 are the three candidate bridges of HANDOFF §2.
- `S(λ·(−1)ⁿ) = S(λ)` is the twist-invariance identity: `Σ λ(n)·(−1)ⁿ · λ(n+2)·(−1)^{n+2} = Σ λ(n)λ(n+2)`, exact.
- The discrepancy `2.0144` against tail `1.84·10⁻⁵` is the Dirichlet-series failure at `s = 2`.

## Proof / evidence

The HANDOFF states H3 as verified by the round's reconnaissance (probe **23/23 checks**, audit **31/31 checks**, both exit 0). Each component is recorded in full in `truths.md` §2: [B1](tpp-rh47-truths-bridge-b1-no-lambda-parity-signal.md) (nominal `z = −47.9` killed by controls `z = +0.43`, `+1.55`), [B2](tpp-rh47-truths-bridge-b2-index-parity-independent.md) (`χ²(1) = 2.944`, twist identity `0/10⁶` mismatches), [B3](tpp-rh47-truths-bridge-b3-no-euler-product.md) (`D(2) = −1.12681304`, `|difference| = 2.01438655`).

## Dependencies and related results

- [HANDOFF B1](tpp-rh47-handoff-bridge-b1-no-mechanism-known.md), [HANDOFF B2](tpp-rh47-handoff-bridge-b2-index-parity-refuted.md), [HANDOFF B3](tpp-rh47-handoff-bridge-b3-balance-route-refuted.md) — the individual rows.
- [H4 — the goal cannot be reached as it stands](tpp-rh47-handoff-h4-goal-unreachable-open.md) — the conclusion drawn from H3.
- [H1](tpp-rh47-handoff-h1-sylvester-sparse-support.md) and [H2](tpp-rh47-handoff-h2-parity-classes-balanced.md) — the other items of the same verification list.

## Notes

- H3 is the conjunction of the three refutations; it adds no new mathematics beyond the three bridge rows.
- The HANDOFF's `2.0144` is the same measurement as truths.md's `|difference| = 2.01438655`.
