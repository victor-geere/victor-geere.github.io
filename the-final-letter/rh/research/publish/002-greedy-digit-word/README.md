# publish/002 — The greedy digit word and the complexity law

Second published edition. This folder packages **item §2 of `research/truths.md`**:
the *greedy digit word* of the greedy-harmonic-sine construction and the **complexity
law** for its factor counts, together with the Lean formalisation, the numerical
cross-checks and the original round ledger.

## What the item is

The programme studies a greedy algorithm that splits a target `x` into a sum of
fractions `1/n`. Writing `S = {a_1 < a_2 < …}` for the support (the indices taken) and
truncating at `N`, the **factor** at window start `t` of length `L` is the offset set

```
{ a - t : a ∈ S,  t ≤ a ≤ t + L - 1 },
```

and `p(L)` — the *complexity* — is the number of distinct such factors over all
windows. `p(L)` measures how much of the word survives a length-`L` inspection, and
is the quantity that decides whether the greedy word can support a Sturmian-like
description.

**The complexity law (Theorem 1).** For `L ≥ max(span, a_m + 1)`,

```
p(L) = min(a_m + 1, N − L + 1) + [L ≤ N − a_m − 1].
```

Three corollaries follow: the **plateau** `p(L) = a_m + 2` on its range, the **decay**
`p(L) = N − L + 1` past it (with `p(N−1) = 2`, `p(N) = 1`), and the maximum
`max_L p(L) = a_m + 2` whenever `N ≥ 2a_m + 2`.

## Contents

| File | What it is |
|---|---|
| [`TRUTHS.md`](TRUTHS.md) | **The item**: the §2 ledger from `research/truths.md` — every result with its status and its Lean proof, links re-pointed into this folder. |
| [`ROUND-TRUTHS.md`](ROUND-TRUTHS.md) | The round's own prose ledger, reproduced for provenance. |
| [`LEAN-README.md`](LEAN-README.md) | The Lean development's own report: module guide and the three corrections to the printed theorems. |
| [`Rh41/DigitWord.lean`](Rh41/DigitWord.lean) | The complexity law, its corollaries, the C1 regime, and the refutations of six naive formulas. |
| [`Rh41/Alphabet.lean`](Rh41/Alphabet.lean) | The halting criterion for a non-increasing positive alphabet, the structure theorem, and the inverse impossibility. |
| [`Rh41/GreedyResidual.lean`](Rh41/GreedyResidual.lean) | The `u`-map and the induced map, rational termination, the squaring law, and the absence of a two-sided constant. |
| [`Rh41/AllZero.lean`](Rh41/AllZero.lean) | The all-zero-factor criterion. |
| [`Rh41/WindowCount.lean`](Rh41/WindowCount.lean) | The exact count of windows containing `a_m`. |
| [`Rh41/Impossibility.lean`](Rh41/Impossibility.lean) | No linear growth, no Sturmian profile. |
| [`Rh41.lean`](Rh41.lean) | Root module; importing it checks the whole development. |
| [`check.sh`](check.sh) | Builds the Lean development against Lean 4 + Mathlib. |
| [`digitword.py`](digitword.py) | Reference implementation of the greedy word and the factor count. |
| [`rigorous_check.py`](rigorous_check.py) | Independent recomputation of the ledger's numerical claims. |
| [`crosscheck.py`](crosscheck.py) | Cross-check of the Lean statements against the Python reference. |

## What is proved, and what is not

The full ledger is in [`TRUTHS.md`](TRUTHS.md); in outline:

* **Proved in Lean** — the complexity law and its corollaries; the C1 regime
  `L ≤ min(min_j d_j, a_0, N−a_0−1) ⟹ p(L) = L+1`; the all-zero criterion; the window
  count; the `u`-map identities (`u' = q²/s − q`, `s' = 1 − {q²/s}`, and that this is
  *not* the Gauss map); rational termination; the squaring law
  `r'/r² = (1−f)/(1+(1−f)r)`; that no `c > 0` gives `r' ≥ c·r²` for all orbits; the
  residual bound `r_{k+1} ≤ r_k² ⟹ A(N) = Ω_x(log log N)`; the halting criterion; the
  structure theorem; the failure of the bounded-gaps/termination dichotomy for
  `α_n = 2^{−(n+1)}`; and the inverse impossibility (no halting alphabet realises
  `p(L) = cL`).
* **Refuted in Lean** — the six naive complexity formulas.
* **Open** — the matching upper bound `A(N) = O(log log N)`. It would follow from a
  two-sided squaring law `r_{k+1} ≥ c·r_k²` with `c > 0`; the Lean development proves
  that `r_{k+1}/r_k² ≤ 1` has **no positive lower bound at all**, so that route is
  closed. The measured ratios fall as low as `0.028`.
* **One caveat** — the onset theorem (`onset` is not determined by `(gaps, N)`) is
  proved with `native_decide`, so it inherits a `native_decide` axiom. Every other
  theorem here is `#print axioms`-clean.

## Running the checks

```sh
./check.sh --all          # Lean 4 + Mathlib, 7 files, exits 0
python3 digitword.py      # reference implementation of the greedy word
python3 rigorous_check.py # independent numerical recomputation
python3 crosscheck.py     # Lean statements vs the Python reference
```

`check.sh` needs a Lean installation at `$LEAN_PREFIX` (default `$HOME/lean`): elan at
`$LEAN_PREFIX/elan`, Mathlib4 at `$LEAN_PREFIX/mathlib4`. The toolchain is read from
Mathlib's own `lean-toolchain`; this folder was checked against
`leanprover/lean4:v4.35.0-rc2`. Inside any Lean 4 project providing Mathlib one may
equivalently run `lake env lean Rh41/DigitWord.lean`.

## Dependencies

Everything needed is in this folder. The only external dependencies are **Mathlib**
(Lean) and the **Python standard library**; no third-party Python package is imported.

## Provenance

Produced in the programme's round `rh41`; see `research/truths.md` §2. The Lean
sources, the Python scripts and the ledgers are reproduced unmodified except that
markdown links have been re-pointed into this folder, and the item ledger
(`TRUTHS.md`) is a copy of the §2 section with its links re-pointed.
