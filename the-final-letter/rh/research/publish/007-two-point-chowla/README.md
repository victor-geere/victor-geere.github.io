# publish/007 — Two-point Chowla and the finite-prefix theorem

Seventh published edition. This folder packages **item §7 of `research/truths.md`**: the
two-point Chowla correlation of the Liouville function, the **finite-prefix
indeterminacy theorem**, and the trivial bound with its sharpness witness.

> **Note on editions.** This is the *same theorem* as
> [`publish/014-two-point-chowla`](../014-two-point-chowla), which is the fuller
> package (it adds a self-contained paper, an independent recomputation with its own
> `λ`, and bit-identical rerun logs). `007` is the copy made by item number when the
> `truths.md` ledger was packaged. If you want the complete edition, read `014`; this
> folder is self-contained too, but its verification layer is the round's own.

## What the item is

Let `λ(n) = (−1)^{Ω(n)}` be the Liouville function and

```
corr(h, N) = Σ_{n=1}^{N} λ(n) λ(n + h).
```

Two-point Chowla is the assertion `corr(2, N) = o(N)`. It is **open**.

**What this item establishes.**

* **The trivial bound.** `|corr(h,N)| ≤ N` for every `h, N`, since each summand is `±1`.
* **Sharpness.** `corr(0,N) = N` because `λ² = 1`. So `o(N)` is **not** a formal
  consequence of multiplicativity plus boundedness: the completely multiplicative
  `λ ≡ 1` has correlation exactly `N`.
* **The finite-prefix indeterminacy theorem.** Let `λ_a` be `λ` with its value at the
  single index `a` negated. Then `λ_a(n) = λ(n)` for every `n < a`, so
  `corrSlice(h,a,N) = corr(h,N)` whenever `N + h < a` — the two functions present
  **identical** correlation data on every prefix shorter than `a` — while
  `λ_a ≠ λ`. The perturbation has `ℓ²`-mass exactly `4` over any prefix containing `a`.
  Hence the truth of `corr(2,N) = o(N)` is a statement about the *limit* and cannot be
  decided from any initial segment: a finite computation can refute it but never prove
  it.
* **The shifted product is not multiplicative**, so
  `D(s) = Σ λ(n)λ(n+2) n^{−s}` has no Euler product and the `ζ`-based route does not
  apply.

## Contents

| File | What it is |
|---|---|
| [`TRUTHS.md`](TRUTHS.md) | **The item**: the §7 ledger from `research/truths.md`, links re-pointed into this folder. |
| [`ROUND-NOTES.md`](ROUND-NOTES.md) | The round's own write-up, including the recorded data correction `1244 → 1246`. |
| [`Rh46/Chowla.lean`](Rh46/Chowla.lean) | The Lean development: 462 lines, 37 theorems and lemmas, 7 definitions, no `sorry`, no `axiom`, no `native_decide`. |
| [`Rh46.lean`](Rh46.lean), [`check.sh`](check.sh) | Root module and build script. |
| [`chowla_two_point.py`](chowla_two_point.py) | The round's numerics: the correlation table, the prefix-maximum fit, the logarithmic average, the finite-prefix construction, and the no-Euler-product check. 30/30 checks, exit 0, sieve to `10⁹`. |
| [`independent_check.py`](independent_check.py) | The round's independent recomputation (own `λ`, own correlations, own prefix construction). 25/26 — the single non-pass is the recorded data correction. |
| [`logs/`](logs) | The recorded runs: `chowla_two_point.log`, `chowla_two_point.repro1.log` (bit-identical rerun), `independent_check.log`, `lean_check.log`, `exit_code.txt`. |

## What is proved, and what is not

* **Proved in Lean** — the trivial bound `corr_abs_le`; `corr_zero` and
  `corrAsymptotic_zero_false`; the slice layer (`slice_self`, `slice_agree`,
  `slice_sub_self`, `slice_ne_self_iff`, `slice_ne`, `slice_abs_le_one`);
  `corrSlice_eq_corr_of_lt` (prefix agreement); `corrSliceSqSub` (the `ℓ²`-mass);
  `corrSlice_ne_corr_self_statement`; and the non-multiplicativity witness
  `shiftProd_not_completely_multiplicative`.
* **Recorded, not elaborated** — the exact perturbation identity
  `corrSlice(h,a,a) − corr(h,a) = −2λ(a)λ(a+h) − 2λ(a−h)λ(a)` is a documented comment in
  `Rh46/Chowla.lean`, not a theorem. Its two halves *are* proved: the prefix agreement
  and the `ℓ²`-mass.
* **Open** — two-point Chowla itself. Nothing here asserts it.
* **A recorded data correction** — an early reconnaissance printed `S(10⁷) = 1244`; three
  independent constructions of `λ` plus a flat cumulative sum give **1246**. The `+2`
  discrepancy was a final-block boundary slip in the reconnaissance's streaming scan.

## Running the checks

```sh
./check.sh --all                  # Lean 4 + Mathlib, 2 files, exits 0
python3 chowla_two_point.py       # 30/30 checks, exit 0, sieve to 10^9 (~4 min)
python3 independent_check.py      # 25/26, exit 1 by design (see above)
```

`chowla_two_point.py` tees its output to `logs/chowla_two_point.log`. See
`publish/002-greedy-digit-word/README.md` for the `LEAN_PREFIX` convention.

## Dependencies

Everything needed is in this folder. External dependencies only: **Mathlib** (Lean) and
**NumPy/mpmath** (the two Python scripts).

## Provenance

Produced in the programme's round `rh46`; see `research/truths.md` §7. The round's many
transient `Check*.lean` / `Test*.lean` / `Scratch*.lean` files are **deliberately not
included** — several contain `sorry`, none is imported by `Rh46.lean`, and
`Rh46/Chowla.lean` is the complete, `sorry`-free development.
