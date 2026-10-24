# `009/lean` — Lean 4 core of the angle-parity tests

Machine-checked core of `research/twin-prime-parity/009/`: the sparse-pair lemma
for a `±1` twist of the shift-2 correlation, and the crossing-count bound that
makes an angle-type sign invisible to it.

Toolchain: Lean `v4.35.0-rc2`, Mathlib at `$HOME/lean/mathlib4`. No `lake`
project file; `check.sh` rebuilds `LEAN_PATH` from `lake env` inside Mathlib
(copied from `../../006/lean/check.sh`).

## Building

```
cd research/twin-prime-parity/009/lean
./check.sh --all              # Sparse, Phase, root -> 3/3 OK
./check.sh Op59/Phase.lean
```

## Status

`./check.sh --all` → **3/3 `[check] OK`**. **0 `sorry`**, **0 `axiom`**.
`#print axioms` gives exactly `[propext, Classical.choice, Quot.sound]`.

| file | contents |
|---|---|
| `Op59/Sparse.lean` | `crossingSet`; `pair_prod_eq`; **`sparse_pair_bound`** — `\|Σ a n (w n w (n+2) − 1)\| ≤ 2·#crossings` for `\|w\|=1`, `\|a\|≤1` |
| `Op59/Phase.lean` | `phaseCrossing`; **`phaseCrossing_card_le_of_le`**, **`phaseCrossing_card_le`** — `#crossings ≤ 2(⌊θ(N+2)/c⌋+1)` for `StrictMono θ`, `c>0`; **`angle_twist_invisible`** — the twist moves the correlation by `≤ 4(⌊θ(N+2)/c⌋+1)` |
| `Op59.lean` | root module |

## In words

* **Sparse-pair.** The symmetric twist `w(n)w(n+2)` equals `1` except on the
  crossing set, and each exceptional term contributes at most `2`. Hence the pair
  correlation changes by at most `2·#crossings`.
* **Crossing count.** For strictly increasing `θ`, the intervals
  `(θ n, θ(n+2))` overlap at most twice, so each multiple of `c` accounts for at
  most two fibres `{n : θ n < kc < θ(n+2)}`; summing over `k ≤ ⌊θ(N+2)/c⌋` gives
  the bound. For `θ n = t log n`, `c = π`, this is `O(t log N)`.
* **Consequence.** Any `±1` weight whose pair crossings are phase crossings
  changes `Σ λ(n)λ(n+2)` by `O(t log N)` — the angle sign is pair-invisible.

## Axiom check

```lean
import Op59
#print axioms Op59.sparse_pair_bound
#print axioms Op59.angle_twist_invisible
```

## Not formalised here

The substitution `θ n = t log n`, `c = π` (a `StrictMono`/monotonicity instance
from real analysis) and the `Ω`-sign numerics; see `../notes/` and `../verify/`.
