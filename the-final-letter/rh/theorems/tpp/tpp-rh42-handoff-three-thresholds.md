# T14 — the three thresholds `pN < pP < p*` with the values in §5.3

**Kind:** Claim
**Status:** VERIFIED (numerical, `findroot` at 80 dps; each residual `< 1e−30`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh42/HANDOFF.md`](../../research/twin-prime-parity/rounds/rh42/HANDOFF.md) — §6 "The rh42 ledger", row T14; §5.3 "Three thresholds, three zeta equations"

## Statement

> | threshold | equation | value | meaning |
> |---|---|---|---|
> | `p*` | `ζ(p) = 2` | 1.7286472389981836181 | rh41's threshold: the **combined** budget `P+N = ζ−1` reaches 1; equivalently (below) the positive half becomes **complete** |
> | `pP` | `2^{−p} ζ(p) = 1` | 1.4649845878051603837 | the positive budget reaches 1, i.e. `sin = +1` becomes writable |
> | `pN` | `(1−2^{−p}) ζ(p) = 2` | 1.3777851698375411838 | the negative budget reaches 1, i.e. `sin = −1` becomes writable |
>
> Ordering: `pN < pP < p*`. The whole sine range `[−1,1]` is inside budget iff
> `p ≤ pN`; for `pN < p ≤ pP` only positive sines are all in budget; beyond `pP` even `sin = 1`
> is out of budget.

The ledger row states it as: "the three thresholds `pN < pP < p*` with the values in §5.3" — **VERIFIED** | `findroot` at 80 dps; each residual `< 1e−30`.

## Hypotheses and notation

- `p*` is the root of `ζ(p) = 2`; `pP` the root of the positive-budget equation `P(p) = 2^{−p}ζ(p) = 1`; `pN` the root of the negative-budget equation `(1−2^{−p})ζ(p) = 2`.
- Appendix A restates: `pN = 1.3777851698375411838 (N(p) = 1)`, `pP = 1.4649845878051603837 (P(p) = 1)`, `p* = 1.7286472389981836181 (ζ(p) = 2)`.
- "residual" in the evidence cell: the residual of the root-finding equation at the located root.

## Proof / evidence

> | T14 | the three thresholds `pN < pP < p*` with the values in §5.3 | **VERIFIED** | `findroot` at 80 dps; each residual `< 1e−30` |

## Dependencies and related results

- Uses the budget definitions `P(p) = 2^{−p}ζ(p)`, `N(p) = (1−2^{−p})ζ(p) − 1` (row T2).
- `p*` is the threshold of the positive-half completeness result T10; the fourth threshold `q` (negative half) is T13.
- Restates `rh42/truths.md` "four thresholds enclosed" and the threshold table of the rh42 round.

## Notes

- `VERIFIED` only, at 80 dps with residuals `< 1e−30`; the values are the source's.
- §5.3 closes the section with: "At `p*` the budget interval is `[−0.3965305007, +0.6034694993]`, of length exactly `ζ(p*) − 1 = 1` — the combined budget is exactly the sine range's length, but it is split unevenly, so `sin = ±1` is *not* writable at `p*` (it needs `p ≤ pP` or `p ≤ pN` respectively)." The interval itself is row T15.
- The three values are printed to 19 significant digits in §5.3.
