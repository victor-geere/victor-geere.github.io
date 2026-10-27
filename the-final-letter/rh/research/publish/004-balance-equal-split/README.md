# publish/004 — Partial sums at `Re S = 0` and the equal split

Fourth published edition. This folder packages **item §4 of `research/truths.md`**: the
**balance condition** for the partial sums `S_N(t) = Σ_{n≤N} n^{−it}` at the zero
abscissa `Re S = 0`, its equivalence to an **equal four-part split**, and the certified
root tables.

## What the item is

The greedy construction needs a *balanced* configuration: a length `N` and a height `t`
at which the partial sum has real part zero. Writing `S_N(t) = Σ_{n≤N} n^{−it}`, the
round settles what that condition actually is.

**Balance ⟺ zero.** `balanced N t ↔ Re S_N(t) = 0`. Only the **real** equation matters;
the complex sum `S_N(t) = 0` is a *different and harder* question, and the round proves
that reading it as the same question is a trap (`S_3(t) ≠ 0` for every `t`, while a real
root certainly exists).

**Equal split.** `balanced` is equivalent to the four parts of the two halves having
equal size — the structural form of the condition.

**Existence.** For `N = 3` the sign change `Re S_3(5/2) < 0 < Re S_3(0)` gives a root,
and a balanced `(N,t)` exists in general. The case `N = 2` is exact:
`Re S_2(π/log 2) = 0`. Certified root brackets are recorded for `N = 3…50`.

## Contents

| File | What it is |
|---|---|
| [`TRUTHS.md`](TRUTHS.md) | **The item**: the §4 ledger from `research/truths.md`, links re-pointed into this folder. |
| [`ROUND-NOTES.md`](ROUND-NOTES.md) | The round's own summary: the answer, its dependence on the split convention, and "three traps" that are part of the answer. |
| [`ROUND-TRUTHS.md`](ROUND-TRUTHS.md) | The round's full prose ledger, reproduced for provenance. |
| [`LEAN-README.md`](LEAN-README.md) | The Lean development's own module guide. |
| [`Rh43/Balance.lean`](Rh43/Balance.lean) | The Lean development (37 theorems): balance/zero equivalence, the equal split, existence, the `N = 2` exact case, `S_3(t) ≠ 0`, and `¬ ∀ N t, S_N(t) ≠ 0`. |
| [`Rh43.lean`](Rh43.lean), [`check.sh`](check.sh) | Root module and build script. |
| [`im_balance.py`](im_balance.py) | The imaginary-part balance computation. |
| [`zeta_split.py`](zeta_split.py) | The equal-split computation. |
| [`ivmath.py`](ivmath.py) | The interval-arithmetic helper used by the scripts. |
| [`plot_partition.py`](plot_partition.py) | Produces `partition_N20.json` — the certified balanced partition for `N = 20`. |
| [`partition_N20.json`](partition_N20.json), [`positive_only_N20.json`](positive_only_N20.json) | The certified partition data. |
| [`partition_N20.png`](partition_N20.png), [`positive_only_N20.png`](positive_only_N20.png) | The rendered figures. |
| [`verify/`](verify) | The independent check (`independent_check.py`), the positive-only split, and the two rendering scripts. |
| [`logs/`](logs) | The recorded runs, including `independent_check.log` and `lean_check.log`. |

## What is proved, and what is not

* **Proved in Lean** — `balanced_iff_realPartial_eq_zero`; `balanced_iff_equal_split`;
  `exists_realPartial_three_eq_zero` with `realPartial_three_five_halves_neg`;
  `exists_balanced_partial_sum`; `balanced_two` (the exact `N = 2` case);
  `zetaPartial_three_ne_zero`; and `not_forall_zetaPartial_ne_zero`.
* **Certified numerically** — the root brackets for `N = 3…50` (auditor check C3); the
  round's own certification reports `64/64` and an audit `102/102`.
* **The traps, recorded as part of the answer** — (i) the complex sum is not the
  question; (ii) the answer depends on the split convention; (iii) read at the level of
  the terms rather than the sums, the answer flips.

Nothing here asserts an un-averaged Chowla statement.

## Running the checks

```sh
./check.sh --all                    # Lean 4 + Mathlib, 2 files, exits 0
python3 im_balance.py               # imaginary-part balance
python3 zeta_split.py               # the equal split
python3 plot_partition.py           # regenerate partition_N20.json
python3 verify/independent_check.py # independent recomputation
python3 verify/plot_positive_only_png.py   # renders positive_only_N20.png
```

The two `verify/plot_*_png.py` scripts read and write the JSON/PNG files **in this
folder's root**; they use `Pillow` and need the fonts under
`/System/Library/Fonts/Supplemental/` (they fall back to Pillow's default font
otherwise).

## Dependencies

Everything needed is in this folder. External dependencies only: **Mathlib** (Lean),
**NumPy/mpmath** (the numerics) and **Pillow** (the two rendering scripts).

## Provenance

Produced in the programme's round `rh43`; see `research/truths.md` §4. Sources are
reproduced unmodified except that markdown links have been re-pointed into this folder.
