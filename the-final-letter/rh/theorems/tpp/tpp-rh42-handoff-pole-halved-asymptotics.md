# T5 — `P(p) ~ N(p) ~ 1/(2(p−1))` as `p ↓ 1` (the pole, halved)

**Kind:** Claim
**Status:** PROVED (paper argument) + VERIFIED (numerical, `P(p)(p−1) = 0.49999994` at `p = 1+10^{−6}`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh42/HANDOFF.md`](../../research/twin-prime-parity/rounds/rh42/HANDOFF.md) — §6 "The rh42 ledger", row T5; §5.2 "The pole at `p = 1`"

## Statement

> `P(p) = 2^{−p} ζ(p)  ~  1/(2(p−1)),      N(p) = (1−2^{−p}) ζ(p) − 1  ~  1/(2(p−1)),`
>
> i.e. the pole of `ζ` appears once on each side with half the residue: `P(p)(p−1) → 1/2`

The ledger row states it as: "`P(p) ~ N(p) ~ 1/(2(p−1))` as `p ↓ 1` (the pole, halved)".

## Hypotheses and notation

- `p ↓ 1` (as `p` decreases to `1`). §5.2 opens: "As `p ↓ 1`, `ζ(p) ~ 1/(p−1) + γ`".
- `γ` is the Euler–Mascheroni constant (the source writes `γ` without further definition).

## Proof / evidence

> | T5 | `P(p) ~ N(p) ~ 1/(2(p−1))` as `p ↓ 1` (the pole, halved) | **PROVED** + **VERIFIED** | `P(p)(p−1) = 0.49999994` at `p = 1+10^{−6}` |

The source's §5.2 continues: "(measured 0.49999994 at `p = 1 + 10^{−6}`; `P` and `N` both exceed `4.9·10^3` by `p = 1 + 10^{−4}`). Since both budgets are infinite at `p = 1`, **no** target fails the budget test, which is exactly the page's reason that a sine anywhere in `[−1,1]` can be written. This is the one place where the pole of `ζ` is *used* rather than avoided."

## Dependencies and related results

- Uses `P(p) = 2^{−p} ζ(p)` and `N(p) = (1−2^{−p}) ζ(p) − 1` (row T2).
- The companion H4 verdict row (§4) records: "at `p = 1` both series diverge — "the pole of zeta, once on each side" | **PROVED** (`P(p), N(p) ~ ζ(p)/2 ~ 1/(2(p−1))`) + **VERIFIED** | `P(p)(p−1) → 1/2`; exact harmonic partial sums; script §2".
- Underlies T6 (the budget test at `p = 1`).

## Notes

- The evidence numbers `0.49999994`, `p = 1 + 10^{−6}`, `4.9·10^3`, `p = 1 + 10^{−4}` are quoted exactly as the source gives them.
- The H4 row in §4 phrases the same asymptotic a second time with `ζ(p)/2`; both phrasings are the source's.
- Restates `rh42/truths.md` Theorem 4 (pole asymptotics) — a `p ↓ 1` statement.
