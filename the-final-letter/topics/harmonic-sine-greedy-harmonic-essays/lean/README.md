# Lean formal core — harmonic sine / greedy harmonic essays

## Build

```bash
cd the-final-letter/topics/harmonic-sine-greedy-harmonic-essays
./lean/check.sh
```

The wrapper calls the shared `topics/tools/check-lean.sh`, which uses the local Mathlib installation under `~/lean/mathlib4` (Lean `v4.35.0-rc2`). The committed [`BUILD.log`](BUILD.log) records the last successful check.

## What is proved

`Topic.lean` imports Mathlib and opens the `HarmonicEssays` namespace. It defines

- `HarmonicEssays.alpha n = π / (n + 2)`;
- `HarmonicEssays.greedy θ N` — the accumulated angle after processing indices `0 … N−1`, with the source's rule “add `α n` iff `α n ≤ θ − θ n`”;
- `HarmonicEssays.selected θ n` — the indicator `δ n` as a `Bool`.

It proves:

| Name | Statement |
|---|---|
| `alpha_pos` | `0 < alpha n` |
| `alpha_strictAnti` | `alpha` is strictly antitone |
| `sum_alpha` | `∑_{n=0}^{N} alpha n = π (H_{N+2} − 1)` |
| `greedy_nonneg` | `0 ≤ greedy θ N` |
| `greedy_le_target` | `0 ≤ θ → greedy θ N ≤ θ` |
| `greedy_alpha_self` | `greedy (alpha n) n = 0` |
| `selected_own_angle` | `selected (alpha n) n = true` |

There is no `sorry`, no `axiom`, and no `admit`. The proofs are elementary order, field and induction arguments; the harmonic identity is proved by induction from Mathlib's `harmonic_succ`.

## What is not formalised, and why

- **The full residual bound.** The source states `0 ≤ r N ≤ π/(N+2)`. That statement is false (see the programme README, Erratum 1); the true bound is `r N ≤ π/(N+1)`. We did not formalise either bound because the honest one is a different theorem from the source's, and the finite Lean core already records the part of Lemma 3.1 that is true (`greedy_le_target`).
- **The limit `sin θ = lim s_N`.** This needs a formal residual limit plus a sine-Lipschitz argument. The finite fusion identity is checked symbolically in Python (C4); the limit is not in Lean.
- **The selection-density lemma.** It is false for targets that are finite harmonic sub-sums (e.g. `θ = 5π/6`), so there is nothing faithful to formalise as stated.
- **The zeta bridge.** Proposition 4.4's special case `Φ(s,π) = ζ(s) − 1` is refuted by the finite word `1,1,0,0,1,0,…` (Python C6). A corrected statement would be a statement about sparse sub-sums of `ζ(s) − 1` for `Re s > 1`; it would not use the `greedy` recursion beyond its definition.
- **The energy functional, the extended Matomäki–Radziwiłł theorem, the harmonic sheaf, and the Riemann-hypothesis argument.** These are undefined or unproved in the source and are recorded as source claims/open items, not as Lean theorems. The source itself is marked retracted.

## Relation to the source

The source is `archive/essays/harmonic-sine-rh-proof.html`, an essay version whose header reads “[Retracted. See: Version 2]” and whose inventory status is *archived claim superseded*. This Lean file deliberately formalises only the finite geometric/harmonic layer that survives the retraction.
