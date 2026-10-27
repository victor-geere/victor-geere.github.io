# Lean formal core — transfer-operator proof

## Build

```bash
the-final-letter/topics/transfer-operator-proof/lean/check.sh
```

The script uses the shared local Mathlib installation at `~/lean/mathlib4` (Lean `v4.35.0-rc2`). It writes the check output to the terminal; the committed [`BUILD.log`](BUILD.log) records the last successful check.

## What is proved

[`Topic.lean`](Topic.lean) defines the finite objects the source actually uses:

- `TransferOperator.primeWeight p s = p^{-s}` — the transfer eigenvalue;
- `TransferOperator.fredholmDet λ = ∏ i, (1 - λ i)` — the finite Euler/Fredholm determinant;
- `TransferOperator.diagForm w x y = Σ i, w i * x i * y i` — the Euclidean diagonal pairing;
- `TransferOperator.diagEnergy w x = Σ i, w i * (x i)^2` — its quadratic energy;
- `TransferOperator.kreinForm sign x y = Σ i, sign i * x i * y i` — the finite indefinite (Krein) model of the source's Petersson pairing.

It proves:

| Name | Statement |
|---|---|
| `primeWeight_pos` | `0 < p^{-s}` for a positive prime `p` and any real `s`. |
| `primeWeight_lt_one` | `p^{-s} < 1` for `p ≥ 2` and `s > 0`. |
| `fredholmDet_pos` | If every finite eigenvalue is `< 1`, then `0 < ∏ (1 - λ_i)`. |
| `fredholmDet_eq_zero_iff` | `∏ (1 - λ_i) = 0 ↔ ∃ i, λ_i = 1`. |
| `diagForm_symm` | `Σ w_i x_i y_i = Σ w_i y_i x_i`. |
| `diagEnergy_nonneg` | `0 ≤ Σ w_i x_i²` when all `w_i ≥ 0`. |
| `kreinForm_negative_direction` | A negative sign gives a negative direction, so the form is not positive. |

No `sorry`, no `axiom`, no `admit`. The statements are the finite algebra behind the source's determinant orientation and its Caveat 2 (the pairing is indefinite). They are not claimed to be the analytic theorems.

## What is not formalised

The following are **source claims or open items** in the programme dossier, not Lean theorems here:

- the infinite Euler product `∏_p (1 - p^{-s}) = 1/ζ(s)` and its convergence for `Re s > 1`;
- the completion `ξ(s) = ½ s(s−1) π^{−s/2} Γ(s/2) ζ(s)` and its functional equation;
- the analytic operator family `L̃_s`, its trace-class or Hilbert–Schmidt determinant, and the impossibility of a trace-class realisation;
- self-adjointness on the critical line, vanishing deficiency indices, and real spectrum of the analytic operator;
- the Petersson contour integral (the finite `kreinForm` is only an algebraic model);
- Li/Weil positivity, the Riemann–von Mangoldt explicit formula, the de Bruijn–Newman constant;
- the Riemann Hypothesis and the location of the zeros of `ζ`.

The analytic continuation of the operator family into `½ < Re s ≤ 1` remains open. No row of the dossier's source-claims table is upgraded to a Lean theorem.
