# publish/003 — Budgets, reachability and the Tau alphabet

Third published edition. This folder packages **item §3 of `research/truths.md`**: the
two **ζ-budget** series of the greedy construction, **Brown's criterion** for
reachability, the **census** of the reachable set, and the **Tau alphabet** with its
parity lock.

## What the item is

The greedy word takes indices according to a *budget*: the positive half-series
`P(p)` and the negative half-series `N(p)`, normalised so that the word halts exactly
when the budget is complete. Everything downstream — which supports are reachable,
what fraction of the interval they fill, and the parity of the support — is a
consequence of the budget algebra.

**The closed forms.** `P(2) = π²/24`, `N(2) = π²/8 − 1`, `P(4) = π⁴/1440`,
`N(4) = π⁴/96 − 1`, and `P(2) + N(2) = π²/6 − 1`.

**The budget algebra.** `P + N = ζ − 1`, `P − N = 1 − η`, hence `P = (ζ − η)/2` and
`N = (ζ + η − 2)/2`, with `P(p) > N(p)` for every `p > 0`.

**Reachability.** Sub-sums of a non-increasing positive sequence fill the whole
interval `[0, A]` precisely under **Brown's condition** `a_k ≤ T_{k+1}` for every `k`
(`T_n = Σ_{k≥n} a_k`). The Lean development proves the gap lemma that drives this, and
also proves that the brief's *single* completeness condition is **not** sufficient.

**The census.** `S_1 = ⋃_A (Σ_{k∈A} a_k + [0, T_{n_min}])` with exact measure
`measure(S_1) = 2^{n_min−1} T_{n_min}`.

**The parity lock.** The support is even for `x > 0` and odd for `x < 0`. This is the
round's *rigidity* result: it separates index parity, and is the reason the budgets
cannot be read as carrying `Ω`-parity information (see `publish/008-parity-barrier`).

## Contents

| File | What it is |
|---|---|
| [`TRUTHS.md`](TRUTHS.md) | **The item**: the §3 ledger from `research/truths.md`, links re-pointed into this folder. |
| [`ROUND-TRUTHS.md`](ROUND-TRUTHS.md) | The round's own prose ledger, reproduced for provenance. |
| [`LEAN-README.md`](LEAN-README.md) | The Lean development's own module guide. |
| [`Rh42/Budget.lean`](Rh42/Budget.lean) | The budget closed forms and the even-part summability of `ζ(2)`, `ζ(4)`. |
| [`Rh42/Reachable.lean`](Rh42/Reachable.lean) | Brown's criterion (the gap lemma) and the insufficiency of the single condition. |
| [`Rh42/Tau.lean`](Rh42/Tau.lean) | The Tau algebra and the parity lock. |
| [`Rh41/DigitWord.lean`](Rh41/DigitWord.lean) | **Included dependency**: `Rh42` imports `Rh41.DigitWord`, so the upstream module is bundled here to keep the folder self-contained. It is byte-identical to the copy in `publish/002-greedy-digit-word`. |
| [`Rh42.lean`](Rh42.lean), [`check.sh`](check.sh) | Root module and build script. |
| [`reachable.py`](reachable.py) | The reachable-set census and its measure. |
| [`helix_zeta.py`](helix_zeta.py) | The helix/ζ budget computations. |
| [`logs/`](logs) | The recorded runs: `reachable.log` (80/80), `helix_zeta.log` and its rerun (70/70), and `lean_check.log`. |

## What is proved, and what is not

* **Proved in Lean** — the five budget closed forms; the even-part summability and sums
  for `ζ(2)` and `ζ(4)`; Brown's criterion via `gap_lemma`; `single_condition_not_sufficient`
  (the brief's single condition is false); the Tau algebra (`take_parity`,
  `tauStep_eq_self_of_odd/even`); and the parity lock
  (`support_subset_even`, `support_subset_odd_of_neg`).
* **Proved on paper and verified numerically** — the T1 sign
  (`Σ (−1)ⁿ/(n+2)^p` at `p = 1` equals `1 − ln 2 = +0.30685…`), the T2/T3 budget algebra
  (verified to `1e−50`), the T4 asymmetry `P(p) > N(p)`, and the census identity.
* **Certification** — the round's verification layer reports `80/80` and `70/70`; the
  recorded logs are in [`logs/`](logs).

Nothing here asserts an un-averaged Chowla statement. The parity lock is a statement
about *index* parity and is explicitly **not** a bridge to `Ω`-parity — that reading was
tested and refuted (`publish/008-parity-barrier`).

## Running the checks

```sh
./check.sh --all          # Lean 4 + Mathlib, 5 files, exits 0
python3 reachable.py      # the census and its measure
python3 helix_zeta.py     # the ζ budget computations
```

See `publish/002-greedy-digit-word/README.md` for the `LEAN_PREFIX` convention; it is
the same here.

## Dependencies

Everything needed is in this folder. The only external dependencies are **Mathlib**
(Lean) and **NumPy/mpmath** (the two Python scripts). `Rh41/DigitWord.lean` is bundled
because `Rh42` imports it.

## Provenance

Produced in the programme's round `rh42`; see `research/truths.md` §3. Sources are
reproduced unmodified except that markdown links have been re-pointed into this folder.
