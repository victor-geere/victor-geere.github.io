# Existence of a balanced partial sum (`exists_balanced_partial_sum`)

**Kind:** Theorem
**Status:** PROVED (Lean, no `sorry`, no numerical axiom) — "the answer of the round"
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh43/lean/README.md`](../../research/twin-prime-parity/rounds/rh43/lean/README.md) — "What is proved, item by item" (table row)

## Statement

> | theorem | statement |
> |---|---|
> | `exists_balanced_partial_sum` | `∃ N t, 0 < N ∧ balanced N t` — **the answer of the round** |

The supporting declarations in the same table:

> | `realPartial_three_five_halves_neg` | `realPartial 3 (5/2) < 0` |
> | `exists_zero_realPartial_three` | `∃ t ∈ Icc 0 (5/2), realPartial 3 t = 0` (IVT) |

## Hypotheses and notation

- `balanced N t` is `posRe N t = -negRe N t`; the existential asserts `0 < N`.
- `exists_zero_realPartial_three` locates a zero of `realPartial 3` in the closed interval `Icc 0 (5/2)`.
- `realPartial_three_five_halves_neg` is the sign input `realPartial 3 (5/2) < 0`.

## Proof / evidence

- **PROVED** in Lean: `exists_balanced_partial_sum`, with `realPartial_three_five_halves_neg` and `exists_zero_realPartial_three`, in [`Rh43/Balance.lean`](../../research/twin-prime-parity/rounds/rh43/lean/Rh43/Balance.lean).
- The IVT step is `exists_zero_realPartial_three` (`∃ t ∈ Icc 0 (5/2), realPartial 3 t = 0`); the sign input rests on the harvested bounds of [The two trigonometric bounds at t = 5/2](tpp-rh43-lean-readme-cos-bounds-at-five-halves.md).
- The file reports 38 theorems + 4 definitions, no `sorry`/`admit`/`axiom`/`native_decide`.

## Dependencies and related results

- Uses [The two trigonometric bounds at t = 5/2](tpp-rh43-lean-readme-cos-bounds-at-five-halves.md), [The balance reduction](tpp-rh43-lean-readme-balanced-iff-realpartial-eq-zero.md) and the continuity result `realPartial_continuous`.
- Counterparts in the truths harvest: [Theorem 4 (existence of a balanced partial sum)](tpp-rh43-truths-n3-existence-ivt.md), ledger row [T5](tpp-rh43-truths-n3-balanced-ledger.md); [Theorem 7 (existence for every N ≥ 3)](tpp-rh43-truths-existence-every-n.md) extends existence to all `N ≥ 3`.
- Companion harvested Lean README file: [`balanced_two` / `exists_balanced_two` — N = 2](tpp-rh43-lean-readme-balanced-two.md).

## Notes

- The source labels this "**the answer of the round**"; it is the Lean formalisation of the `N = 3` witness `t = 5/2`.
- The separate declaration `exists_realPartial_three_eq_zero` (`∃ t, realPartial 3 t = 0`) appears in the Lean development as recorded in truths.md §1.2; the README table lists the interval version.
