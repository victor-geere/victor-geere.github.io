# (P6) Counting formula

**Kind:** Theorem
**Status:** CITED (literature; verified in rh45 §4)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/01-preliminaries.md`](../../research/twin-prime-parity/dictionary/01-preliminaries.md) — §3 "Prerequisites: what the programme uses from analysis", "(P6)", line 104

## Statement

> **(P6) Counting formula.**  `N(T) = θ(T)/π + 1 + S(T)` exactly, and
> `N(T) = (T/2π)log(T/2πe) + 7/8 + S(T) + O(1/T)` asymptotically, with
> `S(T) = (1/π)arg ζ(1/2+iT)`.  *Status:* THEOREM.  *Verified:* rh45 §4 (residuals
> `3.3·10⁻⁴ … 2.2·10⁻⁵` for `T = 20 … 300`).

## Hypotheses and notation

- `N(T)` is the zero-counting function; `θ` is the argument of `ζ` on the critical line (the source's §1 notation: `θ(x)` is the Jacobi theta function `Σ_{n∈ℤ} e^{−πn²x}`; here `θ(T)/π` is the standard Riemann–von Mangoldt main term as used in the source).
- `S(T) = (1/π)arg ζ(1/2+iT)`.
- The first identity is **exact**; the second is asymptotic in `T` with error `O(1/T)` and the constant term `7/8`.

## Proof / evidence

The source gives no proof; it records the status line and the numerical verification, quoted above.

## Dependencies and related results

- [(P5) The explicit formula (Riemann–von Mangoldt)](tpp-dict-01-explicit-formula-rvm.md).
- The same counting formula is ledger row E6 of [`00-dictionary.md`](../../research/twin-prime-parity/dictionary/00-dictionary.md), harvested as [the zero-counting asymptotic](tpp-dict-00-zero-counting-asymptotic.md), and appears again as [the counting function, exact and asymptotic](tpp-dict-05-counting-function-exact-and-asymptotic.md).

## Notes

- Listed by the source under **§3 "Prerequisites"**; hence **CITED (literature)**.
- The residuals `3.3·10⁻⁴ … 2.2·10⁻⁵` are finite-range numerical values for `T = 20 … 300`, quoted exactly as in the source.
- **Notation caveat:** the symbol `θ` is listed in §1 of the same source as the *Jacobi theta function*; in this counting formula `θ(T)` appears as the standard Riemann–von Mangoldt phase term. The source does not flag the clash.
