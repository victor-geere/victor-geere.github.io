# Lean package — build notes, module list, axiom footprint

Requested by the referee of version 1 ("attaches the Lean package (lakefile, toolchain, module list,
`#print axioms` output)"). This file is that record.

## Toolchain

* Lean 4: `leanprover/lean4:v4.35.0-rc2`
* Mathlib4 at `$LEAN_PREFIX/mathlib4` (default `$HOME/lean`), built with `lake`.
* There is **no lakefile**: `check.sh` reconstructs `LEAN_PATH` from `lake env` inside the Mathlib checkout and
  elaborates the modules against it. That is the whole build. Nothing else is required.

## Build

```sh
./check.sh              # all 61 modules, multi-pass, incremental (.olean next to sources)
./check.sh 020          # one phase
./check.sh --list       # the module list
```

Expected output: 61 lines of `[check] OK`, exit 0. The recorded run is `logs/lean-build.log`.

## Module list (61)

| phase | count | modules |
|---|---|---|
| 018 | 45 | ArtinSchreier, Axioms, B4, Barrier, Chebotarev, Collision, Composition, Crit, CubeSym, Cubic, Cubing, Curve, DepressedQuartic, DerivativeQ, Distribution, DivisorSum, Doubling, EvenQuartic, ExtremalQuartic, Factorization, Fiber, FourClass, FreeOrbit, Gap, HalfInteger, JInvariant, JZero, Mobius, NegSquare, NonPeriodic, Periodic, QOrbit, QSize, Qrime, Quad, QuadFiber, QuarticPoly, Resolvent, Scale, Separation, Shift, SmallCap, TwinEven, ValueSet, Variance |
| 019 | 2 | Twist, Verify |
| 020 | 14 | Boundary, Capstone, Dimension, Grading, LargeSieve, Linear, LocalDensity, Orbit, Parity, PolyShift, Shift, SieveLocal, Verify, Window |

## Axiom footprint

`logs/axioms.txt` records the `#print axioms` output for every named theorem in the three `Verify`/`Axioms`
modules: **71 declarations, all on `[propext, Classical.choice, Quot.sound]`**, and **no `sorryAx`** anywhere in
the tree. Example lines:

```
'Capstone.local_factor_dichotomy' depends on axioms: [propext, Classical.choice, Quot.sound]
'Dimension.card_roots_fun' depends on axioms: [propext, Classical.choice, Quot.sound]
'PolyShift.local_factor_ratio' depends on axioms: [propext, Classical.choice, Quot.sound]
'Twist.twisted_parseval_step' depends on axioms: [propext, Classical.choice, Quot.sound]
```

## What each module proves (the ones the paper cites)

| module | theorem | statement |
|---|---|---|
| `018/lean/Separation` | `no_zeta_observable`, `separation_F7` | the zeta datum does not determine the twin count; the F_7 witness |
| `018/lean/Periodic` | `divisor_sum_periodic` | bounded-support divisor sums are periodic |
| `018/lean/NonPeriodic` | `twinInd_not_periodic`, `twinInd_not_divisor_sum` | the twin indicator is neither |
| `020/lean/Grading` | `exists_two_mul_le` | a nontrivial factor has degree <= n/2 |
| `020/lean/Boundary` | `unique_of_deg_lt` | boundary coefficients are 0/1 |
| `020/lean/Dimension` | `card_roots_fun` | local factor 2^k |
| `020/lean/Capstone` | `local_factor_dichotomy`, `parity_constants` | \|F\|-1 vs \|F\|-2; the dimension constants |
| `020/lean/PolyShift` | `ratio_gt_one`, `local_factor_ratio` | the (Q-1)/(Q-2) correction and its algebra |
| `019/lean/Twist` | `twisted_parseval_step` | the combinatorial splitting step |
