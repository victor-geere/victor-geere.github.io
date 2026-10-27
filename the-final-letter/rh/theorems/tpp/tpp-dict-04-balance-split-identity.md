# Theorem 3.1 (the identity)

**Kind:** Theorem
**Status:** PROVED (Lean: `realPartial_eq_posRe_add_negRe`, `balanced_iff_realPartial_eq_zero`, `balanced_equal_split`, `equal_split_balanced`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/04-zeta-relations.md`](../../research/twin-prime-parity/dictionary/04-zeta-relations.md) — §3 "The balance split at `Re(S) = 0` (rh43)", "Theorem 3.1 (the identity)", line 72

## Statement

> **Theorem 3.1 (the identity).**  With `S_N(t) = Σ_{n≤N} n^{−it}`, and `P_N, M_N` the
> sums of the positive/negative real parts of the terms,
> ```
> P_N + M_N = Re S_N(t) ,        P_N = |M_N|  ⟺  Re S_N(t) = 0 .
> ```

## Hypotheses and notation

- `S_N(t) = Σ_{n≤N} n^{−it}` — the partial sum of the zeta series on the critical line, truncated at `N`.
- `P_N` = sum of the positive real parts of the terms `n^{−it}`; `M_N` = sum of the negative real parts of the terms.
- `Re S_N(t) = 0` is the "balance" condition of the section.

## Proof / evidence

The source states only:

> *Status:* THEOREM (Lean: `realPartial_eq_posRe_add_negRe`,
> `balanced_iff_realPartial_eq_zero`, `balanced_equal_split`, `equal_split_balanced`).

No proof sketch is given in this chapter; the four named Lean declarations are the evidence.

## Dependencies and related results

- Used by [Theorem 3.2 (attainability)](tpp-dict-04-attainability-of-balance.md) and [Theorem 3.5 (the term-level split fails)](tpp-dict-04-term-level-split-fails.md).
- Ledger entry for the **rh43** round (section headed "(rh43)").

## Notes

- The source writes `M_N` as "the sums of the positive/negative real parts of the terms" without a further sign convention; the printed identities are reproduced exactly and nothing is read into the sign of `M_N` here.
