# Lean formal core — harmonic sine and the eta function

## Build

```bash
cd the-final-letter/topics/harmonic-sine-eta
./lean/check.sh 2>&1 | tee lean/BUILD.log
```

The wrapper calls the shared [`../../tools/check-lean.sh`](../../tools/check-lean.sh), which elaborates against the local Mathlib installation at `~/lean/mathlib4` (Lean `v4.35.0-rc2`). The committed [`BUILD.log`](BUILD.log) records the last successful check.

## What is proved

`Topic.lean` defines the finite objects of the fragment:

| Name | Definition |
|---|---|
| `HarmonicEta.weight α n` | `(n + 1)^(-α)` |
| `HarmonicEta.etaTerm α n` | `(-1)^n * weight α n` |
| `HarmonicEta.etaPartial α N` | `Σ_{n<N} etaTerm α n`, the truncation of `Σ_{n≥1} (-1)^(n-1) n^(-α)` |
| `HarmonicEta.cosPartial α θ N` | `Σ_{n<N} (-1)^n (n+1)^(-α) cos(θ log(n+1))` |
| `HarmonicEta.sinPartial α θ N` | `Σ_{n<N} (-1)^n (n+1)^(-α) sin(θ log(n+1))` |

It proves seven public theorems:

| Name | Statement |
|---|---|
| `weight_pos` | `0 < weight α n` for `α > 0` |
| `weight_lt_succ` | `weight α (n+1) < weight α n` for `α > 0` |
| `sign_period_two` | `(-1)^(n+2) = (-1)^n` |
| `etaPartial_two_mul` | `etaPartial α (2N) = Σ_{k<N} (weight α (2k) − weight α (2k+1))` |
| `etaPartial_even_factor` | `etaPartial α (2N) = H_{2N}(α) − 2^(1−α) H_N(α)` |
| `etaPartial_even_pos` | `0 < etaPartial α (2N)` for `α > 0`, `N > 0` |
| `cos_sin_at_zero` | `cosPartial α 0 N = etaPartial α N ∧ sinPartial α 0 N = 0` |

Two `private` helper lemmas split a `2N`-term sum into even and odd indices (`sum_range_pair`) and factor `2^(-α)` out of the odd-index weights (`sum_range_odd_weight`). They are proof infrastructure, not programme claims.

No `sorry`, no `axiom`, no `admit`. The file compiles with the shared checker.

## Why this is the honest core

The archived source is a **fragment**, not a complete proof. Its finite content is genuine and elementary: a positive strictly decreasing weight, a period-two sign, and the pairing/factorisation of the alternating partial sums. Those are exactly the facts the programme's computations use, and they are the facts formalised here.

The source's headline assertion — that `α = 1/2` is the unique exponent for which `η(α+iθ) = 0` can coexist with the greedy angular condition — is **not** formalised, because the source does not prove it. The argument contains an unsupported step: it invokes a “classical zero-free region” for `Re(s) > 1/2`, whereas the classical zero-free region is `Re(s) > 1`. A zero-free half-plane `Re(s) > 1/2` would already imply the Riemann hypothesis.

## What is not formalised

- Convergence of `S_α` and `C_α`, and the identification with `η(α+iθ)`.
- Analytic continuation of `η`, the functional equation, and the zero-free region.
- The Riemann–Siegel formula and estimates for partial sums at zeros.
- The greedy-condition characterisation and the uniqueness of `α = 1/2`.
- Any statement about the Riemann hypothesis, twin primes, Chowla, Sarnak, or Elliott.

These are recorded in the programme [README](../README.md) as source claims or open items; they are not Lean theorems.

[Back to the programme](../README.md) · [Topic index](../../README.md)
