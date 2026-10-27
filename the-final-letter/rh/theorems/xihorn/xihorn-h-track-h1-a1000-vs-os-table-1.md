# H1 — a(n) at n = 1000, against [O'S] Table 1

**Kind:** Claim
**Status:** VERIFIED (numerical; every one of the 20 published digits matched, quadrature error ~10⁻¹³³ at h = 0.002)
**Area:** xi-horn
**Source:** [`xi-horn/H_track.md`](../../xi-horn/H_track.md) — §H1 "a(n) at n = 1000, against [O'S] Table 1"

## Statement

> [O'S] Theorem 1.4's table prints γ(1000) = 4.8450426112725879772 × 10⁻²⁵⁶⁸. The crate returns
>
> ```text
> a(1000) = 4.8450426112725879772e-2568
> ```
>
> — **every digit they print** — and the value is unchanged under h doubled, h
> halved, V₁ raised, V₀ raised, and a 90-digit run. It is the first external
> high-precision check this directory has ever had of its own a(n).
>
> The comparison is saturated by *their* precision, not ours. The rule's actual
> accuracy, measured by comparing rules against each other at 150 digits:

The statement continues with the source's table:

| h | nodes | correct digits vs the next halving |
|---|---|---|
| 0.008 | 426 | 10.72 |
| 0.004 | 851 | 40.58 |
| 0.002 | 1701 | **133.51** |
| 0.001 | 3401 | 169.80 (at the 173-digit floor) |

> Each halving roughly **triples** the correct digits. At the standard h = 0.002
> the quadrature error at n = 1000 is ~10⁻¹³³.
>
> Also: a(0) = 0.49712077818831410991 = ξ(½), which is item A3 arriving from the
> other end.

## Hypotheses and notation

- γ(n) is this directory's coefficient, γ(n) = n!/(2n)!·ξ^{(2n)}(½); a(n) = γ(n) = Γ_Φ(2n)·n!/(2n)!; [O'S] uses the same normalisation with no rescaling.
- h is the trapezoid step; V₀ and V₁ are the truncation limits of the rule; the rule-vs-rule comparison is run at 150 digits with V₀ = −2.
- Driver `rust/src/bin/h1_moment.rs`; modules `mellin`, `jensen`.

## Proof / evidence

Numerical: the driver `bin/h1_moment` returns `a(1000) = 4.8450426112725879772e-2568`, equal to [O'S] Theorem 1.4's published table value to every digit printed, and stable under h doubled, h halved, V₁ raised, V₀ raised, and a 90-digit run. The rule's own accuracy is established by comparing rules against each other at 150 digits (table above); the source notes the agreement column is capped at the 173-digit floor implied by the arithmetic (E11).

## Dependencies and related results

- [A3 — Γ_Φ near w = 0](xihorn-rust-results-a3-gamma-phi-near-zero.md) — the same closed form, "arriving from the other end" at a(0) = ξ(½).
- [H5 — the Lambert-W asymptotic](xihorn-h-track-h5-lambert-w-asymptotic.md) — reproduces the same twenty digits from an independent direction.
- [H4 — γ(n) from two representations that are not the horn](xihorn-h-track-h4-three-representations.md) — the three-route cross-check.
- [O'S] Theorem 1.4 — [harvested](xihorn-h-track-os-theorem-1-4.md).

## Notes

- The source records two corrections that came out of H1: **E10** (a retracted feasibility claim — "the binding constraint is node density" was wrong by a hundred digits; the trapezoid on this integrand converges geometrically, not algebraically) and **E11** (`prec_digits()` is not what the scalar resolves — astro-float rounds the requested precision up to whole 64-bit words, so 60 requested digits imply 77 resolvable ones).
- Both are corrections of this directory's own earlier claims, not of [O'S].
