# Corollary 2.4 (Egyptian transfer)

**Kind:** Corollary
**Status:** PROVED (paper argument; source labels it THEOREM + NUMERICAL)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/02-greedy-harmonic-sine.md`](../../research/twin-prime-parity/dictionary/02-greedy-harmonic-sine.md) — §2 "The signed (Tau) reading — the \"harmonic sine\"", "Corollary 2.4 (Egyptian transfer)", line 68

## Statement

> **Corollary 2.4 (Egyptian transfer).**  For `x > 0` the signed rule **is** the classical
> Egyptian greedy on `{k^{−p}}` at target `2^p x` (term `n = 2(k−1)` has value
> `2^{−p}k^{−p}`).

## Hypotheses and notation

- The signed (Tau) rule of Definition 2.2, with alphabet `α_n = (−1)^n/(n+2)^p` (Definition 2.1).
- Target `x > 0` only (the corollary's scope is stated as `x > 0`).
- The identification is `n = 2(k−1)`, where the even-index signed term has value `2^{−p}k^{−p}`; the target of the classical Egyptian greedy is `2^p x`.

## Proof / evidence

The source gives no proof text. Its status line reads:

> *Status:* THEOREM + NUMERICAL.  *Source:* rh42 §7 (`{0}↔{1}`, `{2,10}↔{2,6,38}`,
> `{2,6,38}↔{2,4,20}`, `{0,2,34}↔{1,2,18}`).

The four displayed support correspondences are the source's numerical/structural evidence for the transfer.

## Dependencies and related results

- [Theorem 2.3 (parity lock)](tpp-dict-02-parity-lock.md) — the parity statement that selects the even indices used by the transfer.
- Definition 2.1 (the Tau alphabet) and Definition 2.2 (the signed rule) — definitions, not harvested.

## Notes

- The dictionary labels this item "Corollary 2.4" while its own status line says "THEOREM + NUMERICAL"; the harvest keeps the Kind as stated in the heading and the source's status wording.
- Ledger entry: §2 material restating the **rh42** round (the source cites `rh42 §7`).
