# T15 — at `p*` the budget interval is `[−0.39653, +0.60347]`, length `1`

**Kind:** Claim
**Status:** VERIFIED (numerical; `P(p*) = 2^{1−p*}`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh42/HANDOFF.md`](../../research/twin-prime-parity/rounds/rh42/HANDOFF.md) — §6 "The rh42 ledger", row T15; §5.3

## Statement

> At `p*` the budget interval is
> `[−0.3965305007, +0.6034694993]`, of length exactly `ζ(p*) − 1 = 1` — the combined budget is
> exactly the sine range's length, but it is split unevenly, so `sin = ±1` is *not* writable at
> `p*` (it needs `p ≤ pP` or `p ≤ pN` respectively).

The ledger row states it as: "at `p*` the budget interval is `[−0.39653, +0.60347]`, length `1`" — **VERIFIED** | `P(p*) = 2^{1−p*}`.

## Hypotheses and notation

- `p* = 1.7286472389981836181` (row T14), the root of `ζ(p) = 2`.
- Budget interval `[−N(p), P(p)]`; at `p*` the §5.1 table gives `ζ = 2.000000`, `P = 0.603469`, `N = 0.396531`, `P+N = 1.000000`.
- Evidence identity: `P(p*) = 2^{1−p*}` (equivalently, with `ζ(p*) = 2`, `P = 2^{−p*}ζ(p*) = 2^{1−p*}`).

## Proof / evidence

> | T15 | at `p*` the budget interval is `[−0.39653, +0.60347]`, length `1` | **VERIFIED** | `P(p*) = 2^{1−p*}` |

## Dependencies and related results

- Uses the thresholds (row T14) and the identity `P + N = ζ − 1` (row T3): at `p*`, `P+N = 1`.
- Explains why `sin = ±1` is not writable at `p*` (needs `p ≤ pP` or `p ≤ pN`).

## Notes

- `VERIFIED` only; no proof is claimed.
- Both endpoint printings are the source's: the long form `[−0.3965305007, +0.6034694993]` in §5.3 and the short form `[−0.39653, +0.60347]` in the ledger row.
- The interval is the budget interval, not the reachable set; by T10 it coincides with the reachable interval only for `p ≤ p*`.
