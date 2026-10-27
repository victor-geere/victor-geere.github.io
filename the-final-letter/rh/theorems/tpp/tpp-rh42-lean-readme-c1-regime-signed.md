# The C1 regime — an even positive gap is `≥ 2`, and a support with a gap equal to `2` has C1 range `L ≤ 2`

**Kind:** Theorem
**Status:** PROVED (Lean, machine-checked; no `sorry`) + VERIFIED (the example `{2,4}`, `N = 10`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh42/lean/README.md`](../../research/twin-prime-parity/rounds/rh42/lean/README.md) — `### Rh42/Tau.lean — truths.md §7`, final row

## Statement

> | `truths.md` | Lean | notes |
> |---|---|---|
> | the C1 regime | `GapsAtLeast`, `two_le_of_even_pos`, `c1_range_le_two_of_gap_eq_two`, `complexity_c1_example` | an even positive gap is `≥ 2`; a support with a gap equal to `2` has rh41 C1 range `L ≤ 2` (verified on `{2,4}` with `N = 10`: `p(2) = 3`) |

## Hypotheses and notation

- `GapsAtLeast`: the predicate that all gaps of a support are at least a given bound.
- `two_le_of_even_pos`: an even positive gap is `≥ 2`.
- `c1_range_le_two_of_gap_eq_two`: a support with a gap equal to `2` has rh41's C1 range `L ≤ 2`.
- `complexity_c1_example`: the concrete instance `{2,4}` with `N = 10`, where `p(2) = 3` (`p(L)` is the factor complexity of the digit word).
- rh41's C1 regime is `p(L) = L+1` for `L` below the onset.

## Proof / evidence

The evidence is the machine-checked declarations `GapsAtLeast`, `two_le_of_even_pos`, `c1_range_le_two_of_gap_eq_two`, `complexity_c1_example` in `Rh42/Tau.lean`, together with the example figures quoted in the README's notes column (`{2,4}`, `N = 10`, `p(2) = 3`).

## Dependencies and related results

- Uses the parity lock and the even-gap statements of the same file.
- The referenced "rh41 C1 range" is rh41's Theorem 5 (`p(L) = L+1` for `L ≤ min(min gap, a_0, N−a_0−1)`, each bound sharp), restated in the round's HANDOFF §3.1.
- The HANDOFF §5.6.3 records the companion claim: "rh41's complexity law applies verbatim (the Lean `complexity_main` is generic in the support — re-checked on the Tau supports `{0,2,4,10}`, `{2,6,38}`, `{0,8}`), but the *C1 regime and the plateau onset* of a signed word are governed by this parity constraint".

## Notes

- The row mixes a machine-checked declaration with a finite example; the README labels the example "verified on `{2,4}` with `N = 10`: `p(2) = 3`".
- The wording "rh41 C1 range `L ≤ 2`" is quoted as printed; the bound refers to the C1 range of the signed support.
