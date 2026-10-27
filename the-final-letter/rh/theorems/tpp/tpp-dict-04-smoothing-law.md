# Theorem 4.2 (the smoothing law — the round's main result)

**Kind:** Theorem
**Status:** PROVED (asymptotic; source also NUMERICAL, 5–7 digits)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/04-zeta-relations.md`](../../research/twin-prime-parity/dictionary/04-zeta-relations.md) — §4 "The critical line, and the failure of smoothing (rh43 §7.6, rh044)", "Theorem 4.2 (the smoothing law — the round's main result)", line 121

## Statement

> **Theorem 4.2 (the smoothing law — the round's main result).**  For a weight `φ` with
> convergent Mellin transform `M_φ(s) = ∫_0^1 φ(u)u^{−s}du`,
> ```
> |S_N^φ(1/2+it) − ζ(1/2+it)| / √N   →   |M_φ(s)| ,
> S_N^φ − ζ = N^{1−s}J_φ(s) + φ(0)ζ(s) + R_N .
> ```
> **Smoothing does not remove the `√N`**; it rescales the constant.  Measured at
> `N = 10⁵`, `t = 14.134725`:
>
> | weight `φ(u)` | `\|E\|/√N` | `\|M_φ(s)\|` | ratio |
> |---|---|---|---|
> | `1` (sharp) | 0.070703705 | 0.070703528 | 1.0000025 |
> | `u(1−u)` | 0.0049012629 | 0.0049012243 | 1.00001 |
> | `(u(1−u))³` | 0.00011771845 | 0.00011771845 | 1.000000 |
> | `(1−cos2πu)/2` | 0.0079729835 | 0.0079729835 | 1.000000 |
> | `e^{−u}` | 0.026142297 | 0.026142378 | 0.999997 |

> *Status:* THEOREM (asymptotic) + NUMERICAL (5–7 digits).
> *Consequence:* bounded error would need `M_φ(s) = 0`, impossible for a nonnegative
> weight — so no one-sided smoothing reaches `o(1)`.

## Hypotheses and notation

- `φ` is a weight with convergent Mellin transform `M_φ(s) = ∫_0^1 φ(u)u^{−s}du`; `S_N^φ` is the smoothed partial sum with that weight.
- `s = 1/2 + it`; the limit is `N → ∞` at fixed `t`.
- `J_φ(s)` and `R_N` are the source's names for the leading kernel factor and remainder in the second display; the chapter does not define them further.
- `E` is the error `S_N^φ(1/2+it) − ζ(1/2+it)`; the table was measured at `N = 10⁵`, `t = 14.134725`.

## Proof / evidence

The source's status line is "THEOREM (asymptotic) + NUMERICAL (5–7 digits)", and the table of five weights at `N = 10⁵`, `t = 14.134725` (ratios between `0.999997` and `1.00001`) is the numerical evidence. No proof is given in the chapter beyond the label "asymptotic".

## Dependencies and related results

- [Theorem 4.1 (sharp error at a zero)](tpp-dict-04-sharp-error-at-a-zero.md) — the sharp (`φ = 1`) case, whose constant `1/√(1/4+t²)` matches the first table row.
- The source's *Consequence*: since `M_φ(s) = 0` is impossible for a nonnegative weight, bounded error is unreachable by one-sided smoothing — the section's title, "the failure of smoothing".

## Notes

- Ledger entry for the **rh43 §7.6 / rh044** material named in the section heading.
- In the source table the first column header is `` weight `φ(u)` ``, the second `` `\|E\|/√N` `` and the third `` `\|M_φ(s)\|` ``, with the pipes escaped inside inline code; this is reproduced.
