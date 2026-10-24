# Lean formal core — harmonic sine

## Build

```bash
the-final-letter/topics/harmonic-sine/lean/check.sh
```

The wrapper calls the shared checker [`../../tools/check-lean.sh`](../../tools/check-lean.sh), which elaborates this folder against the local Mathlib installation at `~/lean/mathlib4` (Lean `v4.35.0-rc2`). The last successful run is recorded in [`BUILD.log`](BUILD.log).

## What is defined

`Topic.lean` works in the `HarmonicSine` namespace and defines:

- `eps n = π / (n + 2)`, the harmonic step;
- `Point = ℝ × ℝ`, a rotation pair `(s, c)`;
- `rotate (s,c) h ch = (s*ch + c*h, c*ch - s*h)`, the source's Pythagorean fusion rule;
- `residStep r n = r - (if eps n ≤ r then eps n else 0)`, the one-step greedy residual.

## What is proved

| Name | Statement |
|---|---|
| `eps_pos` | `0 < eps n` |
| `eps_strictAnti` | `eps` is strictly antitone |
| `eps_tendsto_zero` | `eps n → 0` |
| `scaled_eps` | `(n + 2) * eps n = π` |
| `rotate_unit` | two unit vectors rotated together give a unit vector |
| `rotate_trig` | rotating `(sin θ, cos θ)` by `(sin ε, cos ε)` gives `(sin(θ+ε), cos(θ+ε))` |
| `residStep_bounds` | `0 ≤ r ≤ eps n` implies `0 ≤ residStep r n ≤ eps n` |

No `sorry`, no `axiom`, no `admit`, no `rfl`-only padding. All seven facts are used by the programme: T1–T4 fix the step sequence, T5–T6 are the geometric rotation lemma, and T7 is the induction step of the greedy residual bound.

## What is not formalised

- **The greedy recursion over `n`.** `residStep_bounds` is a single step. The full finite sequence `θ n` and the induction proving `0 ≤ r n ≤ π/(n+1)` are not in Lean.
- **The reconstruction limit.** The source's boxed identity `sin(πx) = sgn(x) lim s_n(|x| mod 2)` is not proved. It needs the limit of the residual, a sine Lipschitz estimate, and the reflection/periodic reduction.
- **The half-angle erratum.** The source's `h n = √((1 − cos ε n)/2)` is `sin(ε n/2)`, not the `sin ε n` required by the rotation. Lean uses the correct pair `(sin ε, cos ε)`; the discrepancy itself is checked in Python, not Lean.
- **The zeta and RH material.** Harmonic-sheaf acyclicity, the claimed Matomäki–Radziwiłł extension to `1/n` phases, the off-line energy bound, and the conclusion that RH follows are *archived claims* of the source. They are not stated or assumed here, and this file does not depend on them.

The programme README records these as source claims or open items. They are not Lean theorems.

## Why the core is small

The source is a short ebook, not a proof paper: its geometric construction is stated with a proof sketch, and its RH half is speculative. The honest formal core is therefore the finite rotation geometry that the construction actually uses, not a formalised RH pathway. `rotate_unit` and `rotate_trig` are the genuinely source-relevant facts; `eps_*` are the arithmetic of the harmonic step; `residStep_bounds` is the only part of the greedy argument that is local enough to prove without a full recursion setup.

[Back to the programme](../README.md) · [Topic index](../../README.md)
