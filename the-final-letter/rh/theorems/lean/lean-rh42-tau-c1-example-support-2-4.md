# Instantiation of the rh41 C1 law on the parity-locked support `{2, 4}`: `p(2) = 3`

**Kind:** Theorem
**Status:** PROVED (Lean, no sorry)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh42/lean/Rh42/Tau.lean`](../../research/twin-prime-parity/rounds/rh42/lean/Rh42/Tau.lean) — `complexity_c1_example` (lines 356–375)

## Statement

> **Instantiation of the rh41 C1 law.** The parity-locked support `{2, 4}` has minimum gap exactly `2`, so with `N = 10` and `L = 2` the C1 hypotheses hold and `Rh41.complexity_c1` gives `p(2) = L + 1 = 3`.
>
> Lean statement (`complexity_c1_example`):
>
> `Rh41.complexity ({2, 4} : Finset ℕ) 10 2 = 3`

## Hypotheses and notation

- `{2, 4} : Finset ℕ` is a parity-locked support of the signed greedy word (both indices even, gap exactly `2`).
- `Rh41.complexity S N L` is the factor-complexity of the rh41 development; `N = 10` is the truncation bound and `L = 2` the C1 range parameter.
- `Rh41.DigitWord` (from `../../rh41/lean`) is imported by `Rh42/Tau.lean` for this reuse; the rh41 development itself is untouched.

## Proof / evidence

Machine-checked in `Rh42/Tau.lean` as the `theorem` `complexity_c1_example`. The proof verifies the C1 hypotheses for `S = {2, 4}`, `N = 10`, `L = 2`: `{2, 4} ⊆ Finset.range 10` and `S.Nonempty` by `decide`, the minimum of `S` is `2` (so `2 ≤ min' S` and `2 ≤ 10 - min' S - 1`), and then applies `Rh41.complexity_c1` and rewrites `2 + 1 = 3`. No `sorry`/`admit`/`axiom`/`native_decide` occurs in the file.

## Dependencies and related results

- Applies `Rh41.complexity_c1` (rh41's factor-complexity law, in `Rh41.DigitWord`; not contained in this source file, and not harvested here).
- The general structural statement behind the instantiation is [`lean-rh42-tau-c1-range-gap-two.md`](lean-rh42-tau-c1-range-gap-two.md); the gap structure comes from [`lean-rh42-tau-even-gaps.md`](lean-rh42-tau-even-gaps.md).
- The rh42 Lean README lists this row as part of "the C1 regime" ↔ `complexity_c1_example`, described as "verified on `{2,4}` with `N = 10`: `p(2) = 3`".

## Notes

- This is a concrete instantiation of the rh41 C1 law, not a new general complexity result. The README describes the same evaluation as a verification; in the Lean source it is a machine-checked `theorem` with no `sorry`.
- The declaration keyword is `theorem`, so the Kind is Theorem, even though the source's own name for the declaration is `complexity_c1_example`.
