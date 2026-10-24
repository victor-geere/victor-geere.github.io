# Theorem 9 (why the complex picture is *not* the question)

**Kind:** Theorem
**Status:** PROVED (paper argument); the exact complex vanishing for `N >= 4` is OPEN
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh43/truths.md`](../../research/twin-prime-parity/rounds/rh43/truths.md) — §2 "The complex picture: `S_N(t) = 0` is a different question"

## Statement

> **Theorem 9 (why the complex picture is *not* the question).** For `N >= 2`, the numbers `1, 2^{-it}, …, N^{-it}` are `Q(t)`-linearly independent (they arise from distinct monomials in the multiplicatively independent `p^{-it}`), so `S_N(t) = 0` is a *non-degenerate* algebraic relation and can hold only in the degenerate configurations of `log`-arithmetic — as at `N = 2`, where `2^{-it} = -1` is exactly `t = (2k+1) pi/log 2`. For `N >= 4` whether any such `t` exists is **OPEN**; the grid minima of `|S_N|` recorded by the script (`3.58e-1, 3.08e-1, 2.19e-3, 7.75e-4` for `N = 3,4,5,6` on `[0,15]`, the auditor's certified lower bounds) are evidence, not proof, away from `N = 2, 3`.

## Hypotheses and notation

- `t` real; the numbers `1, 2^{-it}, …, N^{-it}` viewed as elements of `Q(t)`.
- "multiplicatively independent `p^{-it}`" refers to the primes `p <= N`.
- `Q(t)` is the source's notation for the field generated over `Q` by the transcendental `t`, in which the finite set of numbers is claimed linearly independent.
- `|S_N|` minima are over `[0,15]`, quoted as `3.58e-1, 3.08e-1, 2.19e-3, 7.75e-4` for `N = 3,4,5,6`.

## Proof / evidence

- Ledger T10 records `S_3(t) != 0` for all `t` as **PROVED**; the wider statement of Theorem 9 is given as a paper argument (§2) with the `N >= 4` case explicitly **OPEN**.
- The grid minima are described as "evidence, not proof"; they are the auditor's certified lower bounds recorded by the script.

## Dependencies and related results

- Related: [Theorem 8 (S_3(t) != 0)](tpp-rh43-truths-s3-nonvanishing.md); [S_2(pi/log 2) = 0 exactly](tpp-rh43-truths-s2-exact-vanishing.md) (T11); [Balance needs only the real equation](tpp-rh43-truths-balance-needs-only-real-equation.md) (T10).
- The open question is restated in truths.md §6 ("Exact complex vanishing for `N >= 4`") and HANDOFF.md §6.

## Notes

- The source does not spell out the claimed `Q(t)`-linear independence in detail; it is stated as the reason the relation `S_N(t) = 0` is non-degenerate. The `N >= 4` existence question is flagged OPEN in the statement itself, so this harvest must not be read as a vanishing or non-vanishing theorem for `N >= 4`.
