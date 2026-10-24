# publish/005 — The smoothing bridge

Fifth published edition. This folder packages **item §5 of `research/truths.md`**: the
**smoothing bridge** — what changes when the sharp cutoff in a Dirichlet partial sum is
replaced by a smooth weight — and the exact law for the residual.

## What the item is

Let `φ` be a weight and `S_N^φ(s) = Σ_{n≤N} φ(n/N) n^{−s}` the smoothed partial sum,
against the sharp `ζ_N(s) = Σ_{n≤N} n^{−s}`. The round asks how much of the difference
is structural and how much can be smoothed away.

**The weight defect identity (proved).**

```
ζ_N(s) − S_N^φ(s) = Σ_{n≤N} (1 − φ(n/N)) · n^{−s},
```

with the triangle-inequality bound `‖ζ_N − S_N^φ‖ ≤ Σ ‖1 − φ(n/N)‖·‖n^{−s}‖` and the
radial decay `‖n^{−(σ+it)}‖ = n^{−σ}`. For `σ > 1` the defect sum is summable.

**The smoothing law (the round's main result, paper + verified).**

```
|S_N^φ(1/2 + it) − ζ(1/2 + it)| / √N  ⟶  |M_φ(s)|,     M_φ(s) = ∫₀¹ φ(u) u^{−s} du.
```

**The refutation that matters.** "Smoothing removes the `√N`" is **false**: the `√N`
growth is universal, and smoothing buys only a *constant*. A first draft's constant
`1/√(2t)` was wrong.

## Contents

| File | What it is |
|---|---|
| [`TRUTHS.md`](TRUTHS.md) | **The item**: the §5 ledger from `research/truths.md`, links re-pointed into this folder. |
| [`ROUND-NOTES.md`](ROUND-NOTES.md) | The round's own write-up of the smoothing law, the sharp cutoff as the Euler–Maclaurin main term, zero localisation, and what the first draft got wrong. |
| [`ROUND-TRUTHS.md`](ROUND-TRUTHS.md) | The round's prose ledger, reproduced for provenance. |
| [`Rh044/Smoothing.lean`](Rh044/Smoothing.lean) | The Lean development (32 theorems): the weight defect identity, the triangle bound, radial decay, summability, the quadratic-weight identities. |
| [`Rh044.lean`](Rh044.lean), [`check.sh`](check.sh) | Root module and build script. |
| [`smoothed_zeta.py`](smoothed_zeta.py) | The numerics: the smoothing law and the residual's order. |
| [`verify/independent_check.py`](verify/independent_check.py) | Independent recomputation. |
| [`logs/`](logs) | The recorded runs: `smoothed_zeta.log`, `independent_check.log`, `lean_check.log`. |

## What is proved, and what is not

* **Proved in Lean** — `weighted_decomposition` (the defect identity);
  `norm_smoothedSum_sub_zetaSum_le` (the triangle bound); `abs_zetaTerm` (radial decay);
  `summable_norm_zetaTerm` (the `σ > 1` comparison); and the quadratic-weight identities
  `quadWeight_defect_eq`, `zetaSum_sub_smoothedSum_quadWeight`.
* **Proved on paper and verified numerically** — the main smoothing law
  (to 5–7 digits), and the four consequences: the `√N` growth is universal; smoothing
  buys only a constant; the residual has a closed form; bounded error would require
  `M_φ(s) = 0`.
* **Refuted** — "smoothing removes the `√N`" (false), and the earlier constant `1/√(2t)`.

The Lean layer formalises the *algebraic and analytic* part of the bridge; the limit
statement itself is a paper result with numerical corroboration, and is marked as such.

## Running the checks

```sh
./check.sh --all                    # Lean 4 + Mathlib, 2 files, exits 0
python3 smoothed_zeta.py            # the smoothing law and the residual
python3 verify/independent_check.py # independent recomputation
```

See `publish/002-greedy-digit-word/README.md` for the `LEAN_PREFIX` convention.

## Dependencies

Everything needed is in this folder. The only external dependencies are **Mathlib**
(Lean) and **NumPy/mpmath** (the two Python scripts).

## Provenance

Produced in the programme's round `rh044`; see `research/truths.md` §5. Sources are
reproduced unmodified except that markdown links have been re-pointed into this folder.
