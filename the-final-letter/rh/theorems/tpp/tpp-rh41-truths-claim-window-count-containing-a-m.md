# The exact number of windows containing a_m

**Kind:** Claim
**Status:** CHECKED (exhaustive finite, 25 044 603 cases; Lean-proved for all `1 ≤ L ≤ N`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh41/TRUTHS.md`](../../research/twin-prime-parity/rounds/rh41/TRUTHS.md) — §2 "Auxiliary structure"

## Statement

> **Checked.** `#{ t : window contains a_m } = max(0, min(a_m,N−L) − max(0,a_m−L+1) + 1)` (exactly, all `L`, 25 044 603 cases).

## Hypotheses and notation

- Same objects as [Theorem 1 (main)](tpp-rh41-truths-theorem-1-complexity-main.md): support `0 ≤ a_0 < … < a_m`, truncation length `N`, factor length `L`.
- The window at start `t` is `[t, t+L−1]`; it is counted when it contains `a_m`.
- The formula is the one used inside the proof of Theorem 1.

## Proof / evidence

The source's evidence is an exhaustive check over 25 044 603 cases ("exactly, all `L`").

The round's Lean development proves it for all `N, L, a_m` with `1 ≤ L ≤ N`: `WindowCount.card_windows_containing`, stated in `ℤ` to match the Python arithmetic (`ℤ` version via `card_Icc_int`, `cast_max_sub`), in `Rh41/WindowCount.lean` (no `native_decide`). Cross-checked against brute force over 10 850 cases.

## Dependencies and related results

- [Theorem 1 (main)](tpp-rh41-truths-theorem-1-complexity-main.md) — uses this count for the injective windows containing `a_m`.
- The same formula appears inside the proof of [Theorem 1](tpp-rh41-truths-theorem-1-complexity-main.md): `max(0, min(a_m, N−L) − max(0, a_m−L+1) + 1) = min(a_m+1, N−L+1)`.

## Notes

- The source labels this only **Checked**; the round's Lean README records the proof for all `1 ≤ L ≤ N` (in `ℤ` arithmetic), which is why the status line carries both.
- The count `25 044 603` is quoted exactly as printed.
