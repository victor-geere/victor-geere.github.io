# T3 — `P+N = ζ−1`, `P−N = 1−η`, `P = (ζ−η)/2`, `N = (ζ+η−2)/2`

**Kind:** Claim
**Status:** PROVED (paper argument; algebra) + VERIFIED (numerical, to 1e−81)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh42/HANDOFF.md`](../../research/twin-prime-parity/rounds/rh42/HANDOFF.md) — §6 "The rh42 ledger", row T3; derivation in §5.1

## Statement

> `ζ(p) = Σ_{k≥1} (2k)^{−p} + Σ_{k≥0} (2k+1)^{−p}`
> `     = P(p) + (N(p) + 1)`
> `so   P(p) + N(p) = ζ(p) − 1                                    (all terms from n = 2 on)`
>
> and, subtracting instead of adding,
>
> `P(p) − N(p) = Σ_{n≥2} (−1)^n n^{−p} = 1 − η(p),     η(p) = (1 − 2^{1−p}) ζ(p).`
>
> Hence the budgets are the `ζ`/`η` combinations
>
> `P(p) = (ζ(p) − η(p)) / 2 ,      N(p) = (ζ(p) + η(p) − 2) / 2 ,`

The ledger row states it compactly as `P+N = ζ−1`, `P−N = 1−η`, `P = (ζ−η)/2`, `N = (ζ+η−2)/2`.

## Hypotheses and notation

- `η(p) = Σ_{n≥1} (−1)^{n−1} n^{−p} = (1 − 2^{1−p}) ζ(p)` (`p ≠ 1`), `η(1) = ln 2`.
- `P(p)`, `N(p)` are the positive/negative budgets of row T2.
- In `P+N = ζ−1` and `P−N = 1−η`, `ζ` and `η` abbreviate `ζ(p)` and `η(p)`.

## Proof / evidence

> | T3 | `P+N = ζ−1`, `P−N = 1−η`, `P = (ζ−η)/2`, `N = (ζ+η−2)/2` | **PROVED** | algebra; verified to 1e−81 |

The source's §5.1: "All of this is recomputed: `P + N = ζ − 1` and `P − N = 1 − η` to 1e−81 at `p = 1.25, 1.5, 2, 3, 4`; direct even/odd partial sums agree within the truncation tail; the factored `η` matches its series at `p = 1.5, 2`; `η(1) = ln 2`."

## Dependencies and related results

- Depends on row T2 (`P(p) = 2^{−p}ζ(p)`, `N(p) = (1−2^{−p})ζ(p) − 1`) and the even/odd split of `ζ`.
- Feeds T4 (the asymmetry `1−η(p)`) and T14/T15 (the threshold values).
- Restates `rh42/truths.md` T2/T3 (harvested as "Theorem 2 (T2, T3)"); the same identities appear in the lean README (`Rh42/Budget.lean`, truths.md §2) and in Appendix A of the same HANDOFF.

## Notes

- The parenthetical "(all terms from n = 2 on)" is the source's own remark about which part of the `ζ` series the combined budget covers.
- The evidence figure `1e−81` is quoted exactly as the source gives it.
