# Corollary 15 (T8)

**Kind:** Corollary
**Status:** PROVED (paper argument; VERIFIED at p = 1 on four targets)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh42/truths.md`](../../research/twin-prime-parity/rounds/rh42/truths.md) — §7 "Parity lock, and the transfer of rh41's complexity law"

## Statement

> For `x > 0` the signed rule *is* the classical Egyptian greedy on `{k^{−p}}` at
> target `2^p x`: term `n = 2(k−1)` has value `2^{−p}k^{−p}`.

## Hypotheses and notation

- `x > 0` — positive target (the negative target is handled by the parity lock, Theorem 14).
- The signed/Tau rule of §0 with alphabet `α_n = (−1)^n/(n+2)^p`; at even `n = 2(k−1)` the value is `α_n = 2^{−p} k^{−p}`.
- Classical Egyptian greedy on `{k^{−p}}`: take `k^{−p}` whenever it fits.
- The dictionary is `term n = 2(k−1) ↔ index k`, so the signed target `x` corresponds to the classical target `2^p x`.

## Proof / evidence

> **PROVED + VERIFIED** at `p = 1` for `x = 1/2, 1/3, 2/5, 7/9`, matching support for
> support (`{0} ↔ {1}`, `{2,10} ↔ {2,6}`, `{2,6,38} ↔ {2,4,20}`, `{0,2,34} ↔ {1,2,18}`).

## Dependencies and related results

- [Theorem 14 (parity lock, T9)](tpp-rh42-truths-theorem-14-parity-lock.md) — the parity reduction to even indices.
- Handoff ledger row T8 (§11): "the positive half is the Egyptian greedy at `2^p x`", PROVED+VERIFIED before and after.

## Notes

- The source states the transfer limit, quoted verbatim: "So rh41's Theorem 8 (*every rational target terminates*) transfers to the positive half at `p = 1` and **only** there: at `p = 2` the rational `1/5` is not writable."
- The support correspondences are quoted exactly as printed.
