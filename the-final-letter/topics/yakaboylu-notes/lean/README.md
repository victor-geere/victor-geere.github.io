# Lean formal core — Yakaboylu notes

## Build

```bash
cd the-final-letter/topics/yakaboylu-notes
./lean/check.sh 2>&1 | tee lean/BUILD.log
```

The wrapper calls the shared `../../tools/check-lean.sh`, which elaborates the file against the local Mathlib installation at `~/lean/mathlib4`. The committed [`BUILD.log`](BUILD.log) records the last successful check.

## What is proved

[`Topic.lean`](Topic.lean) imports `Mathlib`, opens the namespace `Yakaboylu`, and defines

- `S σ N = Σ_{n=2..N} n^(-σ)` — the amplitude bound;
- `R σ t N = Σ_{n=2..N} (-1)^n n^(-σ) cos(t log n)` — the truncated cosine sum;
- `weight t = t * exp t / (1 + exp t)^2` — Yakaboylu's weight.

It proves:

| Name | Statement | Role in the source |
|---|---|---|
| `abs_R_le_S` | `|R σ t N| ≤ S σ N` | The amplitude estimate behind the truncation argument. |
| `R_ne_one_of_S_lt_one` | `S σ N < 1 → R σ t N ≠ 1` | No truncated real zero below the threshold. |
| `S_lt_S` | `σ₁ < σ₂ → S σ₂ N < S σ₁ N` (for `2 ≤ N`) | `S_N` is strictly decreasing, so the threshold is unique. |
| `S_pos` | `0 < S σ N` (for `2 ≤ N`) | Each amplitude is a positive power. |
| `S_zero` | `S 0 N = N - 1` (for `1 ≤ N`) | At `σ = 0` the bound is `N - 1 ≥ 1`, so a threshold exists. |
| `weight_odd` | `weight (-t) = -weight t` | Symmetry of the weight function. |
| `weight_pos` | `0 < t → 0 < weight t` | Positivity of the weight on the positive axis. |

No `sorry`, no `axiom`, no `admit`. The file contains no `rfl`-only padding: each theorem is a genuine estimate, order fact, finite identity, or symmetry about objects defined in the source.

## What is not formalised

The following are recorded as source claims or open items in the [programme README](../README.md); they are **not** Lean theorems here.

- The meromorphic continuation of `η`, the functional equation `η(s) = M(s) η(1-s)`, and the factor `M(s)`. Formalising these would require a serious development of the zeta/eta functions in Mathlib.
- The existence and uniqueness of the threshold `σ_N` as a real root, and the limit `σ_N → σ_0`. The file proves the monotonicity and the boundary value `S_N(0) = N - 1`, which are the order-theoretic inputs; the root and the limit are computed in Python (C4) but not proved in Lean.
- The zero curves `C_Re`, `C_Im`, the argument foliation, and the harmonic-measure/extremal-length argument (condition C4). These are the notes' geometric programme, and the companion `05-lemmas-02.html` itself retracts the argument-principle route.
- Yakaboylu's operator `ℛ`, its spectrum, and the intertwiner `Ŵ`. These are source claims imported from arXiv:2408.15135, not constructions available in this folder.
- The positivity `Ŵ ≥ 0` (condition C7). This is the central unproved step; it is not available and is not assumed.

In particular, **no Riemann-hypothesis statement is formalised or proved here**, and none of the source's RH/GRH claims is used as an axiom.

## Why the core is small

The archived notes are a literature synthesis rather than a proof programme. The part that is genuinely elementary and self-contained is the finite-`N` eta geometry: the sign identity `U_N = 1 - R_N`, the amplitude bound `|R_N| ≤ S_N`, the monotonicity of `S_N`, the boundary value `S_N(0) = N - 1`, and the elementary symmetry/positivity of the weight `ω`. Those are exactly the facts formalised above. Everything analytic or operator-theoretic is left as a source claim or an open item.

[Back to the programme](../README.md) · [Topic index](../../README.md)
