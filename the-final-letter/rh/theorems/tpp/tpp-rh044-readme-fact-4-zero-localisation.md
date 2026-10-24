# Zero localisation

**Kind:** Claim
**Status:** VERIFIED (numerical; both routes agree to the `1e-44` bisection floor)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh044/README.md`](../../research/twin-prime-parity/rounds/rh044/README.md) — "The settled facts", fact 4, lines 81–87

## Statement

> **4. Zero localisation.**  With a reliable evaluator the first five zeros are
> `14.134725141734693790…, 21.022039638771554992…, 25.010857580145688763…,
> 30.424876125859513210…, 32.935061587739189690…` (both routes agree to the `1e−44`
> bisection floor).  The *sharp* partial sum cannot do this: its first roots are
> `0.303990, 0.213724, 0.163744` for `N = 10^3, 10^4, 10^5`, with `60, 102, 128` roots
> in `(0,35)` — and `Re ζ` alone also has spurious sign changes (at `0.8195, 20.654,
> 29.739, 33.624`) that are not zeros; only `Z`-based bracketing is reliable.

## Hypotheses and notation

- The zeros are the first five nontrivial zeros of `ζ` on the critical line; `Z(t)` is the Riemann–Siegel `Z`-function.
- The "sharp partial sum" roots are the first positive roots of `Re S_N(1/2+it)` for `N = 10^3, 10^4, 10^5`.
- `1e−44` is the bisection floor of the two independent routes.

## Proof / evidence

Numerical: bracketed bisection with a reliable evaluator, cross-checked by both routes to the bisection floor. The sharp-partial-sum contrast rests on root counts in `(0,35)`. The ledger's version gives the same first five zeros to 28 digits and reports the sharp-partial-sum roots `0.30398963, 0.21372367` for `N = 10^3, 10^4` only, with `60` and `102` roots in `(0,35)`.

## Dependencies and related results

- [T4 — zero localisation](tpp-rh044-truths-t4-zero-localisation.md) — the source's ledger version (T4); this file is its README restatement.
- [T5 — the zero count](tpp-rh044-truths-t5-zero-count.md) / [README fact 5](tpp-rh044-readme-fact-5-zero-count.md).
- [Theorem 3 (Riemann's theta identity)](tpp-rh044-truths-theorem-3-riemann-theta-identity.md) — the independent evaluator route.

## Notes

- Restatement of round **rh044** §4 (the ledger's T4), with one addition and one contradiction: the README reports the `N = 10^5` root `0.163744` and `128` roots in `(0,35)` as settled, while the ledger explicitly declines them — "The `N = 10^5` count `≈128` from earlier partial runs is **not** claimed here: it was omitted for runtime and is unverified — recorded as OPEN" ([T4](tpp-rh044-truths-t4-zero-localisation.md)). Both are recorded here as the sources state them; the contradiction is the source's and is not resolved.
- Status VERIFIED (numerical) is the sources' own verdict; the list is a computation, not a theorem with proof.
