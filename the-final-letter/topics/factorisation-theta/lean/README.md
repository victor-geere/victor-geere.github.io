# Lean formal core — factorisation and theta

## Build

```bash
cd the-final-letter/topics/factorisation-theta
./lean/check.sh
```

The wrapper is exactly the shared runner:

```bash
#!/usr/bin/env bash
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
exec "$HERE/../../tools/check-lean.sh" "$HERE" "$@"
```

It uses the local Mathlib installation at `~/lean/mathlib4` (Lean `v4.35.0-rc2`) and writes `Topic.olean` next to the source. The committed [`BUILD.log`](BUILD.log) records the last successful check.

## What is formalised

`Topic.lean` imports Mathlib and works in the namespace `FactorisationTheta`. It defines

- `divisorDetector k x = cos(2πk/x) + cos(2πx) − 2`;
- `finiteTheta N t = Σ_{n=0}^{N−1} exp(−πn²t)`.

It proves seven facts, all used by the reconstruction:

| Name | Statement |
|---|---|
| `divisorDetector_nonpos` | `f_k(x) ≤ 0` for every real `x` |
| `divisorDetector_eq_zero_iff` | `f_k(x) = 0 ↔ cos(2πk/x) = 1 ∧ cos(2πx) = 1` |
| `divisorDetector_neg` | `f_k(−x) = f_k(x)` (root symmetry `±d`) |
| `divisorDetector_of_dvd` | `d ∣ k`, `d ≠ 0` ⇒ `f_k(d) = 0` |
| `divisorDetector_eq_zero_iff_dvd` | for `x : ℤ`, `x ≠ 0`: `f_k(x) = 0 ↔ x ∣ k` |
| `finiteTheta_pos` | `0 < N` ⇒ `0 < Θ_N(t)` |
| `finiteTheta_antitone` | `Antitone (finiteTheta N)` |

There is no `sorry`, no `axiom`, and no `admit`. The proofs use
`Real.cos_le_one`, `Real.cos_eq_one_iff`, `Real.cos_nat_mul_two_pi`,
`Real.cos_int_mul_two_pi`, `Real.exp_pos`, `Real.exp_le_exp`,
`Finset.sum_pos`, and elementary order/field reasoning.

## What is not formalised

These are recorded as source claims or open items in the programme
[`README.md`](../README.md); they are **not** Lean theorems here.

1. **Real-root converse.** `divisorDetector_eq_zero_iff_dvd` restricts the
   input to `x : ℤ`. The reduction from a real root to an integer input
   (using `Real.cos_eq_one_iff` twice) is left as an extension.
2. **Exact multiplicity.** The source claims every divisor is a double
   zero. The Python certificate checks
   `f''(d) = −4π²((k/d)²/d² + 1) ≠ 0` for the tested cases, but the
   general Lean statement about `deriv`/`iteratedDeriv` is not present.
3. **Infinite theta.** Convergence of `Σ_{n∈ℤ} exp(−πn²t)`, its positivity,
   and the functional equation `θ(1/t) = √t θ(t)` are not formalised.
   The latter needs Poisson summation or the modular transformation.
4. **Mellin/zeta bridge.** The Mellin transform computation, the incomplete
   gamma integral, and the zeta functional equation are not formalised.
   In particular, **no Riemann-hypothesis statement is proved or assumed**.
5. **The `f_k`–`θ` dictionary.** The source says a direct expression is
   elusive; no formula is asserted, and none is formalised.

## Why the core is small

The source is a short speculative essay. It contains no labelled theorem
environments and no original analytic proof. Rather than dress the quoted
theta/zeta material as new theorems, this file formalises exactly the
elementary algebra that the essay does establish: the sign and root
behaviour of the divisor detector, and the positivity/monotonicity of the
finite theta truncation. The classical analytic statements stay on the
source-claim side of the ledger.

[Back to the programme](../README.md) · [Topic index](../../README.md) · [Scraps](../../../scraps.html)
