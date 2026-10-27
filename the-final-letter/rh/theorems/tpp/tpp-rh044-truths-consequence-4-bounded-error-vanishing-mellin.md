# Consequence 4 — bounded error would need `M_φ(s) = 0`

**Kind:** Corollary
**Status:** PROVED (paper argument)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh044/truths.md`](../../research/twin-prime-parity/rounds/rh044/truths.md) — §2 "Consequences", item 4, lines 100–107

## Statement

> 4. **Bounded error would need `M_φ(s) = 0`** for the relevant heights `t`.  For a
>    *nonnegative* weight this is impossible, since `∫_0^1 φ(u)u^{−1/2−it}du` cannot
>    vanish when `φ ≥ 0` is not identically zero (the integrand has constant argument
>    `−t log u`, and the modulus integral is strictly positive).  A sign-changing
>    `φ` could in principle make the integral vanish at isolated `t`; making it vanish
>    identically in `t` would need the measure `φ(u)u^{−1/2}du` to annihilate every
>    `u^{−it}`, which forces `φ ≡ 0`.  Either way the one-sided route cannot reach
>    `o(1)` for all `t`.

## Hypotheses and notation

- A consequence of [Theorem 2 (weight law)](tpp-rh044-truths-theorem-2-weight-law.md): `|S_N^φ(1/2+it) − ζ|/√N → |M_φ(s)|` with `M_φ(s) = ∫_0^1 φ(u)u^{−s}du`.
- `φ ≥ 0` on `[0,1]`, not identically zero; `s = 1/2 + it`.
- The "one-sided route" is the smoothed partial sum of Theorem 2, as opposed to the functional-equation route of [Theorem 3](tpp-rh044-truths-theorem-3-riemann-theta-identity.md).
- The argument uses that `u^{−1/2−it}` has constant argument `−t log u` on `(0,1)`.

## Proof / evidence

The source gives the argument inline: for `φ ≥ 0` not identically zero the integral `∫_0^1 φ(u)u^{−1/2−it}du` cannot vanish because the integrand has constant argument `−t log u` and the modulus integral is strictly positive; a sign-changing `φ` could vanish at isolated `t`, but vanishing identically in `t` would require the measure `φ(u)u^{−1/2}du` to annihilate every `u^{−it}`, forcing `φ ≡ 0`. No further proof is given.

## Dependencies and related results

- [Theorem 2 (weight law)](tpp-rh044-truths-theorem-2-weight-law.md) — the result this consequence follows from.
- [Consequence 1 — the `√N` growth is universal](tpp-rh044-truths-consequence-1-sqrt-n-growth-universal.md).
- [Theorem 3 (Riemann's theta identity)](tpp-rh044-truths-theorem-3-riemann-theta-identity.md) — the route that does reach `o(1)`.

## Notes

- Status PROVED (paper argument) records the source's inline written argument, not a formal or Lean proof.
- The source leaves open whether a *complex-valued* weight could have `M_φ(1/2+it) = 0` identically in `t`; §7 of the source records this as an OPEN item, not as a result.
