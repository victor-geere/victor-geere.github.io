# The exact formulation of the C1 boundary

**Kind:** Claim
**Status:** VERIFIED (derivation + spot checks; stated as the round's exact formulation)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/round01.md`](../../research/twin-prime-parity/rounds/rh40/rounds/round01.md) — §5 "Round 2 agenda", item 4

## Statement

> C1 holds at `L` **iff** `Σ_j min(L−2, d_j−1) = #{j : d_j < L}`, i.e. iff no gap satisfies `L−1 > d_j > L−2`.

The source continues: "Since the `d_j` are integers, that reads: C1 holds at `L` iff
`L − 1 ≤ min_j d_j`, **or** `L − 1 > max_j d_j`." It also records the consequence for
the measured first failures: "On the four dialogue words the second branch is out of
reach (it would need `L > 594, 6033, 240, 40` respectively while the decay regime
intervenes), which is exactly why the measured first failures are `d_1+2` for 1/π,
√2−1 and (10,20,40,80) but `d_2+2` for log 2 and true e−2."

## Hypotheses and notation

- C1 is the law `p(L) = L + 1`; `d_j = a_j − a_{j−1}` are the consecutive gaps of the support.
- `#{j : d_j < L}` counts the gaps strictly below `L`; the sum uses `min(L−2, d_j−1)`.

## Proof / evidence

The source states the identity from the class decomposition (the same derivation is recorded in register row F3 of [`truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md), with status `VERIFIED` (derivation + spot checks)). The §5 item is presented as the round's exact formulation and as the basis of round 2's task ("turn this identity into the `(N, a_0, d_1, …, d_m)` formula the handoff asked for, or prove that the `#{d_j < L}` sum is not expressible in the gaps alone once the decay regime is in play").

## Dependencies and related results

- Register row F3 of [`truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md), harvested as [tpp-rh40-rounds-truths-f3-exact-c1-formulation.md](tpp-rh40-rounds-truths-f3-exact-c1-formulation.md).
- Register rows F4 (four refuted candidates), F5 (which gap governs, `OPEN`); rows A1, A2, M6 of the same file.

## Notes

- **Restatement.** This statement restates register entry F3 of `truths.md` (round 1 of the rh40 dialogue). It is harvested here as well because §5 item 4 sets it out as the round's own exact formulation.
- The ledger (row 21 of `ledger.md`) records that a variant with `L` in place of `L − 1` — `L ≤ 1 + min_j d_j or L > max_j d_j` — is false on 65.6 % of 1 772 281 cases; the form above is the corrected one.
