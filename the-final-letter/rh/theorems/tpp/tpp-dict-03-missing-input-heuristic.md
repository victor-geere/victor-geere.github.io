# HEURISTIC 5.4 (the shape of the missing input)

**Kind:** Claim
**Status:** CONJECTURED (the three routes are theorems in their own problems; the necessity claim is a heuristic)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/03-parity-problem.md`](../../research/twin-prime-parity/dictionary/03-parity-problem.md) — §5.2

## Statement

> **HEURISTIC 5.4 (the shape of the missing input).** Three kinds of input are known to be able to cross a parity barrier, none of them currently available for the twin primes:
> 1. **Type-II / bilinear (Friedlander–Iwaniec asymptotic sieve, T15).** A hypothesis of the form "the sequence has a bilinear decomposition whose cross-terms are equidistributed" can yield an *asymptotic formula* (not merely an upper bound) for primes in a sieve. Prototype, and the classical demonstration that parity *can* be broken: T14 (`X² + Y⁴` captures its primes), where the factorisation `x² + y⁴ = (x + iy²)(x − iy²)` in `ℤ[i]` supplies exactly the bilinear structure.
> 2. **Equidistribution to large moduli (Bombieri–Friedlander–Iwaniec, T16).** Supplies the Type-II information at moduli beyond `x^{1/2}`, and is the engine behind 1.
> 3. **Automorphic / spectral input.** The `X²+Y⁴` proof uses Hecke `L`-functions and a spectral (harmonic-analysis) input on the lattice; equivalently, it uses the arithmetic of a number field in which the polynomial *factors*. This is the sense in which the phrase "automorphic input" is used in the rounds' summaries.
> For the twin primes the two linear forms `n` and `n+2` are *linear* and admit no such factorisation, and their Type-II data is exactly what the parity obstruction denies.

The file's status line: *Status:* HEURISTIC (the three routes are theorems *in their own problems*; the claim that some input of this kind is *necessary* for twin primes is not a theorem and is marked HEURISTIC).

## Hypotheses and notation

- Row **T15** = the Friedlander–Iwaniec asymptotic sieve: [row T15](tpp-dict-03-t15-asymptotic-sieve.md); row **T16** = Bombieri–Friedlander–Iwaniec equidistribution to large moduli: [row T16](tpp-dict-03-t16-bfi-large-moduli.md); row **T14** = `X²+Y⁴` captures its primes: [row T14](tpp-dict-03-t14-x2-y4-captures-primes.md).
- `ℤ[i]` is the Gaussian integers; `x² + y⁴ = (x + iy²)(x − iy²)` is the factorisation supplying the bilinear structure.
- "Type-II / bilinear" refers to the bilinear (Type-II) hypothesis of the asymptotic sieve.
- The twin-prime linear forms are `n` and `n+2`.

## Proof / evidence

- The source gives no proof of the necessity claim; it explicitly marks it HEURISTIC while noting that each of the three routes **is** a theorem in its own problem.
- The prototype T14 is cited as "the classical demonstration that parity *can* be broken".

## Dependencies and related results

- [THEOREM 2.1](tpp-dict-03-selberg-parity-principle.md) / [THEOREM 5.2](tpp-dict-03-no-bounded-depth-sieve-lower-bound.md) (the obstruction); [row T14](tpp-dict-03-t14-x2-y4-captures-primes.md), [row T15](tpp-dict-03-t15-asymptotic-sieve.md), [row T16](tpp-dict-03-t16-bfi-large-moduli.md) (the three routes).
- Restated in the §7 ledger row "5.4".

## Notes

- Harvested because the source labels and numbers it, with the honest HEURISTIC status: only the *existence of routes* is theorem-level, the claim that such input is *necessary* is not.
