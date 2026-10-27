# §1.3 — logarithmic Chowla `(1/log x) Σ_{n≤x} λ(n)λ(n+h)/n = o(1)` (known theorem)

**Kind:** Theorem
**Status:** CITED (literature: Tao 2015/2016; Matomäki–Radziwiłł–Tao) + VERIFIED (numerical, checks to `3·10⁷`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh46/README.md`](../../research/twin-prime-parity/rounds/rh46/README.md) — §1.3 "The unconditional theorems that *are* known (VERIFIED numerically)" and §5 claim table

## Statement

> * **logarithmic Chowla** (Tao 2015/2016; Matomäki–Radziwiłł–Tao): for fixed `h`,
>   `(1/log x) Σ_{n≤x} λ(n)λ(n+h)/n = o(1)` — a true theorem.  The round *checks it
>   finitely* (main agent, sieve to `3·10⁷`):

The §5 claim table states it as: "the logarithmic average is `o(1)` | known theorem (Tao; MRT); **VERIFIED** numerically here".

## Hypotheses and notation

- `λ(n) = (−1)^{Ω(n)}` the Liouville function; `h` is a **fixed** shift.
- The average is logarithmic: each term is divided by `n`, then divided by `log x`.
- The round's numbers are for `h = 1` and `h = 2`.

## Proof / evidence

The finite check quoted in §1.3:

> | `x` | `10⁴` | `10⁵` | `10⁶` | `10⁷` |
> |---|---|---|---|---|
> | `h = 1` | −9.06·10⁻² | −7.28·10⁻² | −6.10·10⁻² | −5.23·10⁻² |
> | `h = 2` | −1.48·10⁻¹ | −1.18·10⁻¹ | −9.82·10⁻² | −8.41·10⁻² |

> The decay is **slow** (as the theorem's `o(1)` permits), so this is a consistency
> check of a known theorem, not a verification of it — the same logical caveat as
> §1.4 applies.  The un-averaged statement `Σ_{n≤x}λ(n)λ(n+h)/x = o(1)` is the open
> one.

## Dependencies and related results

- The same §1.3 also records "**Chowla for almost all shifts** in short ranges (Matomäki–Radziwiłł–Tao; Tao's entropy-decrement method): the two-point correlation vanishes for almost every `h` — a statement about `h`-averages, not about the single `h = 2`."
- The dictionary records the same theorem as "logarithmic Chowla two-point" and its all-orders analogue ([Tao–Teräväinen]).
- §4 lists the numerics script `chowla_two_point.py` ("1044 lines, **30/30 checks**, sieve to `10⁹`") as containing "the logarithmic average" among its checks.

## Notes

- **CITED (literature)**: the theorem is attributed to Tao 2015/2016 and Matomäki–Radziwiłł–Tao; the round only checks it finitely. The source says plainly that this is "a consistency check of a known theorem, not a verification of it".
- The un-averaged statement `Σ_{n≤x}λ(n)λ(n+h)/x = o(1)` is recorded as **open** in the same section.
- All four table rows for each `h` are quoted exactly (`−9.06·10⁻²`, `−7.28·10⁻²`, `−6.10·10⁻²`, `−5.23·10⁻²`; `−1.48·10⁻¹`, `−1.18·10⁻¹`, `−9.82·10⁻²`, `−8.41·10⁻²`).
