# Lean formal core — prime-spectrum tensor

## Build

```bash
the-final-letter/topics/prime-spectrum-tensor/lean/check.sh
```

The script delegates to the shared checker and uses the local Mathlib
installation at `~/lean/mathlib4` (Lean `v4.35.0-rc2`). The committed
[`BUILD.log`](BUILD.log) records the last successful run:
`[check] OK Topic.lean`.

## What is proved

[`Topic.lean`](Topic.lean) defines the prime-current weight, a finite
truncation of `Π`, one term of Riemann's Jacobi density `Φ`, the Fourier
atom `exp(iγx)`, a finite atomic kernel, the mode sum and the finite Gram
form. It proves seven statements, all with no `sorry`, `axiom` or
`admit`:

| Name | Statement |
|---|---|
| `primeWeight_nonneg` | `0 ≤ Λ(n)/√n` for every `n`. |
| `primeCurrent_nonneg` | A finite truncation of `Π` is non-negative on a pointwise non-negative test function. |
| `jacobiTerm_pos` | Each term of the Jacobi density is positive for `n ≥ 1` and `u ≥ 0`. |
| `atom_neg` | `atom w γ (-x) = conj (atom w γ x)`. |
| `atomForm_eq` | The one-frequency Gram form equals `w · Z · conj Z`, where `Z = Σ_j a_j e^{iγu_j}`. |
| `gramForm_eq` | The finite Gram form equals `Σ_k w_k · Z_k · conj Z_k`. |
| `gramForm_re_nonneg` | If every atomic weight is non-negative, the real part of the finite Gram form is non-negative. |

The last three are the finite spectral core of `tensor.md` Theorem C(2):
on a finite set of real frequencies, a positive combination of Fourier
atoms is of positive type. The first three are the elementary positivity
facts behind Definition 3.1 and the positivity of `Φ`.

## What is not formalised

The source `tensor.html` is a speculative programme, not a proved
theorem. The companion `tensor.md` refutes its defining inequality
`(⋆)` and identifies the repair. This Lean file deliberately formalises
only the finite, elementary lemmas; the analytic statements are recorded
as source claims or open items in the [programme dossier](../README.md).

Not formalised here:

- the infinite prime current and its absolute convergence on the Weil
  cone (only finite truncations are treated);
- the infinite Jacobi series and the identity `Φ̂ = ½ Ξ_cos`;
- Lemma 2.1 (the square `ĝ = |f̂|²`), Lemma 2.2 (the archimedean
  transform), Lemma 2.3 (the prime current as a contour integral) and
  Lemma 2.4 (the explicit formula);
- Theorem A (the exact signed spectral resolution of `P = Π + Θ`);
- Theorem B (the numerical refutation of `(⋆)` with the witness `f₀`);
- Theorem C (the identity with Weil's current and the equivalence of its
  positivity with RH);
- Bochner's theorem on the cone, and any statement about zeros of `ζ`;
- the Riemann hypothesis, which is never asserted or assumed.

The numerical content of Theorem B is checked separately in
[`../tests/test_programme.py`](../tests/test_programme.py), not in Lean.
It is a computation, not a formal theorem.

[Back to the programme](../README.md) · [Topic index](../../README.md)
