# The Lean layer

**61 modules, all elaborated against Lean 4 + Mathlib with only the standard axioms**
(`propext`, `Classical.choice`, `Quot.sound` — no `sorryAx`).

| phase | modules | directory |
|---|---|---|
| 018 | 45 | [`018/lean/`](018/lean) |
| 019 | 2 | [`019/lean/`](019/lean) |
| 020 | 14 | [`020/lean/`](020/lean) |

## Building

```sh
./check.sh              # every module, multi-pass; prints "[check] OK <phase>/<file>"
./check.sh 020          # one phase
./check.sh --list       # list the modules
LEAN_PREFIX=/path/to/lean ./check.sh    # if Mathlib is not at $HOME/lean
```

`check.sh` rebuilds `LEAN_PATH` from `lake env` inside Mathlib and puts the three phase directories on it, so
intra-phase imports (`import SieveLocal`) resolve. Elaboration is in place; `.olean` files are written next to
the sources.

## Phase 018 — the barrier (45 modules)

The 018 layer is the programme's original development. The modules cited by the manuscript:

| module | proves |
|---|---|
| `Separation` | the zeta cannot determine the twin count (`no_zeta_observable`), and the `𝔽₇` witness |
| `Periodic`, `NonPeriodic` | bounded-support divisor sums are periodic; the twin indicator is not |
| `DivisorSum`, `Barrier` | the multiplicative obstruction and the no-Euler-product facts |
| `Shift`, `Factorization`, `Composition`, `NegSquare`, `QSize`, `QOrbit`, `SmallCap` | the `d = 4` cap's reduction chain and its finite base |
| `TwinEven`, `Scale`, `FreeOrbit` | `T(h) = T(−h)`, the scaling law, and the free-orbit divisibility |
| `Mobius`, `Qrime` | the Möbius inversion and the qrime dictionary |

The remaining modules (`Chebotarev`, `Cubic`, `Resolvent`, `Distribution`, `Variance`, `B4`, `Curve`, …) support
the round-by-round results of phase 018; they are included so the phase is reproducible.

## Phase 019 — the identity (2 modules)

| module | proves |
|---|---|
| `Twist` | the twisted-Parseval splitting step: `2 · 1_square = 1 + χ₂` and `2 Σ_{squares} = Σ + Σ χ₂` |
| `Verify` | the axiom footprint of the five `Twist` declarations |

## Phase 020 — the mechanisms (14 modules)

| module | proves |
|---|---|
| `Grading` | every nontrivial factor has degree `≤ n/2` — the exactness of the Legendre sieve at `y = n/2` |
| `Boundary` | a residue class mod `m` with `deg m > n` contains at most one degree-`n` polynomial — boundary coefficients are `0/1` |
| `SieveLocal` | the local factor `2^k` for `k = 1, 2, 3` |
| `Dimension` | the general local factor `2^k` |
| `Shift`, `PolyShift` | local factors are shift-free for constants; `(Q−1)/(Q−2)` and its algebra for polynomial shifts |
| `Capstone` | the local-factor dichotomy `|F|−1` vs `|F|−2` in one theorem; the dimension constants `2, 4, 8` |
| `Orbit` | `h ~ −h` orbits have size two in odd characteristic |
| `Parity` | `2^k` is even, `≥ 2`, and strictly increasing |
| `LargeSieve` | the Cauchy–Schwarz step and the support size |
| `Linear` | the degree-one base case (`T(1) = q`) |
| `Window` | window sums are shifted range sums and concatenate |
| `LocalDensity` | avoiding both `0` and `−h` costs exactly two points |
| `Verify` | the axiom footprint of the 020 theorems |

## Axiom footprint

Every theorem reports the same three axioms. Each phase has a `Verify.lean` that prints the footprint; its
output (recorded in `logs/`) reads

```
'Capstone.local_factor_dichotomy' depends on axioms: [propext, Classical.choice, Quot.sound]
'Dimension.card_roots_fun' depends on axioms: [propext, Classical.choice, Quot.sound]
'PolyShift.local_factor_ratio' depends on axioms: [propext, Classical.choice, Quot.sound]
```

No module contains `sorry`, `admit`, or a custom axiom. The `olean` files are build artefacts and are not
shipped.
