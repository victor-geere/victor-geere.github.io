# `008/lean` — Lean 4 core of the automorphic/spectral attempt

Machine-checked arithmetic core of `research/twin-prime-parity/008/`: the exact
reduction of the shift-2 Liouville correlation to a sum of `λ` over the quadratic
polynomial `4k² − 1`.

Toolchain: Lean `v4.35.0-rc2`, Mathlib at `$HOME/lean/mathlib4`. No `lake`
project file; `check.sh` rebuilds `LEAN_PATH` from `lake env` inside Mathlib
(copied from `../../006/lean/check.sh`).

## Building

```
cd research/twin-prime-parity/008/lean
./check.sh --all              # Defs, Split, root -> 3/3 OK
./check.sh Op58/Split.lean
```

## Status

`./check.sh --all` → **3/3 `[check] OK`**. **0 `sorry`**, **0 `axiom`**.
`#print axioms` on every theorem gives exactly
`[propext, Classical.choice, Quot.sound]` — no `native_decide`.

| file | contents |
|---|---|
| `Op58/Defs.lean` | **`liouville_mul`** (complete multiplicativity of Mathlib's `ArithmeticFunction.liouville`, no coprimality), `liouville_two`, `liouville_sq`, **`liouville_pair`** (R3), **`poly_identity`**, **`even_shift`** (`λ(2m)λ(2m+2)=λ(m)λ(m+1)`) |
| `Op58/Split.lean` | `Sh`, `Ccore`; **`sum_range_even_odd`**; **`Ccore_eq_poly`** (R2: `C(K)=Σ λ(4k²−1)`); **`Sh2_split`** (R1: `S_2(x)=S_1(⌊x/2⌋)+C(⌊(x+1)/2⌋)`) |
| `Op58.lean` | root module |

## In words

`λ = ArithmeticFunction.liouville` is completely multiplicative, so
`λ((2k−1)(2k+1)) = λ(2k−1)λ(2k+1)` with no coprimality hypothesis, and
`(2k−1)(2k+1) = 4k²−1`. Splitting the sum over even and odd indices and using
`λ(2m)λ(2m+2) = λ(m)λ(m+1)` yields

```
Σ_{n≤x} λ(n)λ(n+2) = Σ_{m≤⌊x/2⌋} λ(m)λ(m+1) + Σ_{k≤⌊(x+1)/2⌋} λ(4k²−1).
```

Hence the whole open content of `S_2(x) = o(x)` is `Σ_{k≤K} λ(k²−1)` up to the
dilate — a quadratic-polynomial Mertens sum.

## Axiom check

```lean
import Op58
#print axioms Op58.Sh2_split
#print axioms Op58.Ccore_eq_poly
```

## Not formalised here

The analytic content of the note — Weil/Deligne bounds, the `𝔽_q[T]`
Sawin–Shusterman theorems, the level-of-distribution data, and the conditional
linear-sieve transfer — is outside this file. See `../notes/` and `../verify/`.
