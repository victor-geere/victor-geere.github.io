# Theorem 1 (sign)

**Kind:** Theorem
**Status:** PROVED (paper argument; VERIFIED with exact rational enclosures)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh42/truths.md`](../../research/twin-prime-parity/rounds/rh42/truths.md) — §1 "The sign of the ledger — the one correction the source pages need"

## Statement

> `Σ_{n≥0} (−1)^n / (n+2)^p` at `p = 1` equals
>
> ```
> 1 − ln 2 = +0.30685281944005469058…
> ```
>
> and the source page's `ln 2 − 1 = −0.30685281944005469058…` is its **negative**.

## Hypotheses and notation

- The signed/Tau alphabet (§0): `α_n = (−1)^n / (n+2)^p`, `n = 0, 1, 2, …`, with `p = 1` on the helix pages, i.e. `= +1/2, −1/3, +1/4, −1/5, …`.
- `Σ_{n≥0} (−1)^n / (n+2)^p` is the alphabet's total (its signed sum at `p = 1`).
- `ln 2` is the natural logarithm of `2`; `artanh` is the inverse hyperbolic tangent.
- `η` is the Dirichlet eta function, `η(p) = Σ_{n≥1} (−1)^{n−1} n^{−p}`, with `η(1) = ln 2` and `η(p) = (1 − 2^{1−p})ζ(p)`.
- The "source pages" are the pages of this round whose `ln 2 − 1` extraction is corrected here.

## Proof / evidence

The source gives both an argument and a numerical certificate:

> **PROVED** (the alternating harmonic series: with `m = n+2`,
> `Σ_{m≥2}(−1)^m/m = −(ln 2 − 1) = 1 − ln 2`), **VERIFIED** with exact rational
> enclosures: `ln 2` is bracketed by `2 artanh(1/3) = 2Σ_k (1/3)^{2k+1}/(2k+1)`
> with a geometric tail bound, giving an interval of width `6.3·10⁻⁴¹`, and
> `1 − ln 2 ∈ [0.3068528194400546…, 0.3068528194400547…]`. The magnitude was always
> right on the pages; only the extraction of the alphabet's total had the sign
> flipped. `η(1) = ln 2` and `η(p) = (1 − 2^{1−p})ζ(p)` are both correct and are
> used below.

## Dependencies and related results

- Dirichlet eta: `η(1) = ln 2`, `η(p) = (1 − 2^{1−p})ζ(p)` — stated as correct in §1 and used by Theorem 2 and Theorem 3.
- The refuted row [R1 — the alphabet total is ln 2 − 1](tpp-rh42-truths-r1-alphabet-total-sign.md) is the negated form of this statement.
- Handoff ledger row T17 (§11): "the alphabet total is `1 − ln 2`, not `ln 2 − 1`", was VERIFIED, now PROVED + rigorously enclosed.

## Notes

- The source presents this as "the one correction the source pages need": the magnitude was already right on the pages, only the sign of the extracted total was flipped.
- The interval `[0.3068528194400546…, 0.3068528194400547…]` is quoted above exactly as the source writes it; the enclosure width is `6.3·10⁻⁴¹`.
