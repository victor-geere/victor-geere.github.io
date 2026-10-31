# Lean formal core — sin(x)/x with the greedy harmonic sine

## Build

```bash
the-final-letter/topics/sin-x-over-x/lean/check.sh
```

The wrapper calls the shared checker [`../../tools/check-lean.sh`](../../tools/check-lean.sh), which
elaborates this folder against the local Mathlib installation at `~/lean/mathlib4`. The last
successful run is recorded in [`BUILD.log`](BUILD.log).

## What is defined

`Topic.lean` works in the `SinXOverX` namespace and defines the finite greedy reconstruction:

| Name | Definition |
|---|---|
| `eps n` | `1 / (n + 2)`, the harmonic step in units of `π` |
| `step r n` | `r - (if eps n ≤ r then eps n else 0)`, one greedy step |
| `resid y n` | the residual after `n` steps |
| `delta y n` | the angle selected at step `n` |
| `theta y N` | the accumulated angle after `N` steps |
| `greedySine θ` | `sin (π θ)` |
| `reconSine y N` | `greedySine (theta y N)` |
| `reconSinc y N` | `reconSine y N / (π y)` |

The period-two odd extension used by the Python layer is not formalised: `reconSinc` is the
formula on the branch where the greedy angle is measured directly. The extension is an
elementary reduction and is checked in Python (C8).

## What is proved

| Name | Statement |
|---|---|
| `eps_pos` | `0 < eps n` |
| `eps_strictAnti` | `eps` is strictly antitone |
| `eps_le_eps_of_le` | `n ≤ m → eps m ≤ eps n` |
| `step_le_self` | `step r n ≤ r` |
| `resid_le` | `resid y n ≤ y` |
| `delta_eq_zero_of_resid_lt` | `resid y n < eps n → delta y n = 0` |
| `theta_eq_zero_of_forall_lt` | if every step with `n < N` exceeds `y`, then `theta y N = 0` |
| `theta_eq_zero_of_lt_eps` | `y < eps N → theta y (N+1) = 0` |
| `greedySine_zero` | `greedySine 0 = 0` |
| `greedySine_int` | `greedySine k = 0` for `k : ℤ` |
| `greedySine_eq_zero_iff` | `greedySine θ = 0 ↔ ∃ k : ℤ, θ = k` |
| `greedySine_pos` | `0 < θ < 1 → 0 < greedySine θ` |
| `greedySine_five_six` | `greedySine (5/6) = 1/2` |
| `reconSine_error` | `|theta y N - y| ≤ 1/(N+1) → |reconSine y N - sin(πy)| ≤ π/(N+1)` |
| `reconSine_eq_zero_of_lt_eps` | `y < eps N → reconSine y (N+1) = 0` |
| `reconSinc_eq_zero_of_lt_eps` | `y < eps N → reconSinc y (N+1) = 0` |
| `theta_one_two` | `theta 1 2 = 5/6` |
| `theta_one_five` | `theta 1 5 = 1` |
| `reconSine_one_two` | `reconSine 1 2 = 1/2` |
| `reconSine_one_five` | `reconSine 1 5 = 0` |
| `step_zero` | `step 0 n = 0` |
| `resid_half` | `resid (1/2) (N+1) = 0` |
| `delta_half_zero` | `delta (1/2) (N+1) = 0` |
| `theta_half` | `theta (1/2) (N+1) = 1/2` |
| `reconSine_half` | `reconSine (1/2) (N+1) = 1` |
| `reconSinc_half` | `reconSinc (1/2) (N+1) = 2/π` |

No `sorry`, no `axiom`, no `admit`. The file contains genuine finite-stage facts, not padding:
T1–T8 are the arithmetic and the vanishing-zone induction, T9–T14 are the elementary structure
of the reconstructed sine and the conditional error bound, T15–T20 pin the finite-stage
behaviour at the first integer, where the reconstruction has `1/2` instead of `0`, and T21–T26
show that the Wallis point `x=1/2` is exact at every stage.

## What is not formalised

- **The reconstruction limit.** `theta y N → y` and hence `reconSine y N → sin(πy)` are not
  proved. This is the inherited source claim of `harmonic-sine`; it is tested numerically in
  both topics and recorded as open.
- **The pointwise limit of the quotient.** The one-point defect at the origin
  (`sinc_N(0) = 0` while `sinc(0) = 1`) and the non-uniformity of convergence are not proved in
  Lean; the vanishing-zone theorem T16 is their finite-stage content.
- **The period-two odd extension.** Only the direct branch is defined in Lean. The extension
  used in the Python layer (C8) is elementary but not formalised.
- **The zeros of `sinc_N` as a set.** T10–T11 describe the zeros of `greedySine` in angle
  units. The zero set of `reconSinc` on `R`, including its intervals of zeros, is not described.
- **The integral.** Nothing about `∫₀^∞ sinc_N` is formalised. The numerical values and the
  tail expansion live in the Python layer.
- **Bandlimitedness and Paley–Wiener.** The argument that no finite stage is bandlimited is
  stated in the dossier but not formalised; it would require the Fourier transform of `sinc_N`.
- **The Euler product.** The dossier's no-product obstruction (an interval of zeros versus a
  discrete factorization) is a paper argument. Only the interval-of-zeros theorem T16 is
  formalised; the infinite-product statement is not.
- **The RH material.** The archived harmonic-sine claim is neither stated nor assumed here.
  This file says nothing about `ζ`, primes, or the Riemann hypothesis.

## Why the core is small

The quotient `S_N(x)/(πx)` inherits all of its finite-stage content from the greedy angle: the
residual arithmetic, the vanishing zone, and the exact values at the first integer. Those are
exactly the facts that can be proved without a convergence theorem for the greedy expansion.
The analytic statements that make the topic interesting — the lost value at the origin, the
non-uniformity, the failure of bandlimitedness, and the integral — all take `N → ∞` or require
the Fourier transform, and are therefore recorded as computations or open items rather than
silently formalised.

[Back to the programme](../README.md) · [Topic index](../../README.md)
