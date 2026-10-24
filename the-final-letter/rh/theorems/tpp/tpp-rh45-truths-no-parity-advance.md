# Parity problem (T4, negative)

**Kind:** Claim
**Status:** PROVED (paper argument, structural; numerical measurements included)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh45/truths.md`](../../research/twin-prime-parity/rounds/rh45/truths.md) — §6 "Parity problem (T4, negative)"

## Statement

> **Nothing here advances it.**  The explicit formula is unconditional and primes
> enter through `Λ(n)` — which is the object the parity obstruction concerns: a weight
> built from `Λ` (or `μ`, `λ`) cannot separate even from odd `Ω(n)`.  Measured:
> `λ(n)=+1` vs `−1` counts among twin-prime candidates up to `2·10^6` are `14688` vs
> `23835`, and the Chowla-type correlation `Σ λ(n)λ(n+2) = −940 = −4.7·10^{-4}x`.
> A twin-prime lower bound would need something like `Σ_{n≤x}λ(n)λ(n+2) = o(x)`, which
> no step in this round provides.

The source's §3 row C5.3 adds:

> | C5.3 (parity counts "comparable") | criterion undefined | among sieve survivors `n, n+2 ≤ 2·10^6` the ratio is `0.616`; the substantive point stands: `Σ_{n≤2·10^6} λ(n)λ(n+2) = −940 = −4.7·10^{-4}x`, and the explicit formula (unconditional, `Λ`-weighted) does not break parity |

## Hypotheses and notation

- `Ω(n)` is the number of prime factors of `n` counted with multiplicity; `λ` is the Liouville function; `μ` is the Möbius function; `Λ` is the von Mangoldt function.
- "Twin-prime candidates" are `n, n+2` with `n, n+2 ≤ 2·10^6`; the `λ(n)=+1` vs `−1` counts are `14688` vs `23835`.
- The Chowla-type correlation is `Σ λ(n)λ(n+2) = −940 = −4.7·10^{-4}x`, and the sieve-survivor ratio is `0.616`.

## Proof / evidence

- The structural part is a paper argument quoted from the parity obstruction the source describes: a sieve weight built from `Λ` (or `μ`, `λ`) cannot separate integers with an even number of prime factors from those with an odd number.
- The numerical part gives the measured counts and correlation above; the source states the explicit formula "does not break parity".
- The source states that a twin-prime lower bound would need something like `Σ_{n≤x}λ(n)λ(n+2) = o(x)`, "which no step in this round provides".

## Dependencies and related results

- [The correct explicit formula](tpp-rh45-truths-correct-explicit-formula.md) and [How the explicit formula bypasses the rh43/rh044 obstruction (T4)](tpp-rh45-truths-bypasses-sqrt-n-obstruction.md) — the round's positive results, which the source says do not touch parity.
- [No parity-problem advance](tpp-rh45-readme-no-parity-advance.md) — the README's statement of the same negative claim.

## Notes

- The parity obstruction itself is stated by the source as a known structural fact; the round does **not** prove it here, and the source explicitly disclaims any advance on it.
- The source's §3 records the C5.3 criterion as "undefined" rather than refuted, while saying "the substantive point stands"; the ratio `0.616` is quoted exactly.
- The `−4.7·10^{-4}x` correlation value appears in §3 and §6 in the same form; note it is not `−4.7·10^{-4}·x` written with a multiplication dot but `−4.7·10^{-4}x` as printed.
