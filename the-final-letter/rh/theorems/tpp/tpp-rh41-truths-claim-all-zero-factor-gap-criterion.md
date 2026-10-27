# The all-zero factor occurs iff an extended gap is ≥ L+1

**Kind:** Claim
**Status:** CHECKED (exhaustive finite, 95 835 cases; Lean-proved for all supports)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh41/TRUTHS.md`](../../research/twin-prime-parity/rounds/rh41/TRUTHS.md) — §2 "Auxiliary structure"

## Statement

> **Checked.** The all-zero factor occurs **iff** some gap between consecutive support points — or before the first / after the last — is `≥ L+1` (95 835 cases).

## Hypotheses and notation

- Same objects as [Theorem 1 (main)](tpp-rh41-truths-theorem-1-complexity-main.md): support `0 ≤ a_0 < … < a_m`, truncation length `N`, factor length `L`.
- "All-zero factor" is the length-`L` factor whose offset set is empty.
- "Extended gap" includes the gap before the first support point and the gap after the last: in Python the list is `[-1] + ones + [N]`.

## Proof / evidence

The source's evidence is an exhaustive check over 95 835 cases.

The round's Lean development proves the equivalence for **all** supports, `N` and `L`: `AllZero.allZero_iff_hasLargeGap`, where the Python list `[-1] + ones + [N]` is `AllZero.extSupport` shifted by one. Cross-checked against `allzero_ref`/`allzero_gap` over 1 444 551 cases.

## Dependencies and related results

- [Theorem 1 (main)](tpp-rh41-truths-theorem-1-complexity-main.md) — the window argument in its proof is where the all-zero factor is identified.
- Called claim A2 by the round's [Lean README](tpp-rh41-lean-readme-auxiliary-general-bound.md).

## Notes

- The source labels this only **Checked**; the round's Lean README records that it was subsequently proved for all supports, which is why the status line carries both.
- The count `95 835` is quoted exactly as printed.
