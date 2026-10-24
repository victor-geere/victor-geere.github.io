# Theorem 14 (parity lock, T9)

**Kind:** Theorem
**Status:** PROVED (paper argument; machine-checked in Lean)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh42/truths.md`](../../research/twin-prime-parity/rounds/rh42/truths.md) — §7 "Parity lock, and the transfer of rh41's complexity law"

## Statement

> At a positive target the residual stays non-negative (it can hit `0` exactly, when
> a term is taken with `α = r`), and a term is taken only when the residual is
> *positive*; odd-index terms are negative, so the sign test rejects them at every
> positive residual. Hence
>
> ```
> every take of a positive target sits at an EVEN index,
> every take of a negative target sits at an ODD index,
> so every gap of the signed support is EVEN and at least 2.
> ```

## Hypotheses and notation

- The signed/Tau rule of §0: at step `n` take `α_n` iff `sign(α_n) = sign(r_n)` and `|α_n| ≤ |r_n|`, then `r_{n+1} = r_n − α_n`; otherwise skip it, forever.
- `α_n = (−1)^n/(n+2)^p` — odd indices are negative, even indices positive; `r_n` is the residual, `α = r` denotes taking a term with equality.
- The **support** of a signed word is the set of indices taken; a **gap** is a gap of the signed support.
- "Every gap is EVEN" means gaps occur between even indices, hence have even length.

## Proof / evidence

> **PROVED** by induction on the step (and machine-checked in
> [`lean/Rh42/Tau.lean`](../../research/twin-prime-parity/rounds/rh42/lean/Rh42/Tau.lean): `tauStep_nonneg`, `take_parity`,
> `support_subset_even`, `support_gap_even_and_two_le`), **VERIFIED** for `p = 1, 2`
> and four targets.

## Dependencies and related results

- Used by the C1-regime statement of §7 (the C1 range uses that gaps are even and `≥ 2`).
- Handoff ledger row T9 (§11): "the signed support has all gaps even `≥ 2`", was VERIFIED, now **PROVED** + Lean.
- The `p = 1` transfer to the Egyptian greedy is Corollary 15.

## Notes

- The source flags the strict form as false, quoted verbatim: "The strict form "*the residual stays `> 0`*" is **false** at the boundary (`x = 1/2`, `p = 1`: the first term is taken with equality and the residual becomes `0`), which is why the machine-checked statements are the non-strict ones; the parity conclusion is unaffected."
- The four machine-checked declaration names are quoted exactly as printed.
