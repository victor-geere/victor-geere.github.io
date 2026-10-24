# Theorem 7 (maps)

**Kind:** Theorem
**Status:** PROVED (Lean; exact rational identities)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh41/TRUTHS.md`](../../research/twin-prime-parity/rounds/rh41/TRUTHS.md) — §3 "The support: greedy orbits"

## Statement

> **Theorem 7 (maps).** With `u = 1/r`, `q = ⌈u⌉`, `s = q − u`, the orbit satisfies exactly
>
> ```
> u' = q²/s − q        and        s' = 1 − { q²/s }.
> ```
>
> The induced map on `s` is **not** the Gauss map (max deviation 0.85). The relevant density is Lebesgue, not Gauss–Kuzmin.

## Hypotheses and notation

- `r` is the residual of the greedy rule of the source's Object paragraph; `u = 1/r`, `q = ⌈u⌉`, `s = q − u` (so `s ∈ [0,1)`); `{·}` is the fractional part; prime denotes the next active step.
- The identities hold **while the step does not terminate**, i.e. under the strict hypothesis `1/(n+2) < r` at the current index; the second identity additionally needs `{q²/s} ≠ 0` (see Notes).
- "The induced map on `s` is not the Gauss map" is a measured statement (max deviation `0.85`), described by the round's Lean README as an `F3` measurement over 12 orbit steps.

## Proof / evidence

The source states the identities as exact and gives no proof text.

Machine-checked as the exact rational identities `Harmonic.u_map`, `Harmonic.induced_map` (non-integral case `{q²/s} ≠ 0`) and `Harmonic.induced_map_int` (terminating integral case) in `Rh41/GreedyResidual.lean`, namespace `Rh41.Harmonic`; the file uses no `native_decide`. The "not the Gauss map" measurement and the density claim are **not** formalised and the source's Lean README lists them under "Not formalised".

## Dependencies and related results

- [Theorem 8 (rational termination)](tpp-rh41-truths-theorem-8-rational-termination.md) — the termination theory that supplies the terminating case.
- [The squaring law and the lower bound A(N) = Ω_x(log log N)](tpp-rh41-truths-claim-squaring-law-omega-lower-bound.md) — the sibling §3 result on the same orbit.
- [Correction 5 — Theorem 7 needs strict hypotheses](tpp-rh41-lean-readme-correction-5-theorem-7-strict-hypotheses.md).

## Notes

- The source's Lean README records two hypotheses worth noting: `Harmonic.u_map` needs `1/(n+2) < r` strictly (at equality the residual vanishes and `s = q − 1/r` becomes `0`), and `Harmonic.induced_map` covers the non-integral case `{q²/s} ≠ 0` with the terminating integral case proved separately as `Harmonic.induced_map_int`.
- The deviation figure `0.85` and the Gauss–Kuzmin remark are quoted exactly as printed and are measurements, not proved statements.
