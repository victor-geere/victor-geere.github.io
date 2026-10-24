# H1 — a(1000) matches O'S Table 1 to every digit it prints

**Kind:** Claim
**Status:** VERIFIED (numerical; all 20 published digits matched, rule accurate to ~1e−133 at h = 0.002)
**Area:** xi-horn
**Source:** [`xi-horn/rust/RESULTS.md`](../../xi-horn/rust/RESULTS.md) — Summary, "H1 — a(1000) matches [O'S] Table 1 to every digit it prints"

## Statement

> **H1 — a(1000) matches [O'S] Table 1 to every digit it prints, and the rule
> has 113 digits of headroom.** O'Sullivan's γ(m) := m!/(2m)!·ξ^(2m)(½) is this
> directory's a(m) with no rescaling, so his
>
> ```
> γ(1000) = 4.8450426112725879772e−2568
> ```
>
> is the first external high-precision value of a(n) the directory has had.
> This crate returns it exactly, and returns it unchanged under h doubled, h
> halved, V₁ raised, V₀ raised, and a 90-digit run.
>
> Because [O'S] prints twenty digits the comparison saturates there, so the
> rules were compared **against each other** at 150 digits, with V₀ = −2 (the
> integrand below it is e^{−4002}, and the saddle sits 300 widths clear):

| h | nodes | digits vs the next halving |
|---|---|---|
| 0.008 | 426 | 10.72 |
| 0.004 | 851 | 40.58 |
| 0.002 | 1701 | **133.51** |
| 0.001 | 3401 | 169.80 (at the 173-digit floor) |

> **Each halving roughly triples the correct digits** — the trapezoid rule on
> this integrand converges geometrically, not algebraically. So at the standard
> h = 0.002 the quadrature error at n = 1000 is ~1e−133 against a published
> 2e−20: **the node-count heuristic understated the rule's reach by more than a
> hundred digits**, and TODO H1's "right at the edge" was wrong. See the
> correction in TODO E10.
>
> Two things worth keeping from the diagnostic anyway: the saddle of the n-th
> moment integrand sits at v\* = 0.891 for n = 1000 and reaches V₁ = 1.4 only at
> n ≈ 42 000; and a(0) = 0.49712077818831410991 is ξ(½), which is A3 again from
> the other end.

## Hypotheses and notation

- a(n) = γ(n) = Γ_Φ(2n)·n!/(2n)!; [O'S]'s γ(m) := m!/(2m)!·ξ^(2m)(½) is the same with no rescaling.
- h is the trapezoid step; V₀, V₁ the truncation limits; the rule-vs-rule comparison is at 150 digits with V₀ = −2.
- 150 digits resolves 173 digits in this arithmetic (see **E11** in TODO.md).
- Driver `bin/h1_moment`; modules `mellin`, `jensen`.

## Proof / evidence

Numerical: the crate returns 4.8450426112725879772e−2568, unchanged under h doubled, h halved, V₁ raised, V₀ raised, and a 90-digit run; the rule's own accuracy is measured by comparing rules against each other at 150 digits (table above, each halving roughly tripling the correct digits).

## Dependencies and related results

- [[H1 from H_track.md](xihorn-h-track-h1-a1000-vs-os-table-1.md) — the same result, with the same table, in the track's own account.
- [A3 — Γ_Φ near w = 0](xihorn-rust-results-a3-gamma-phi-near-zero.md) — "A3 again, from the other end" at a(0).
- [H4 — two more representations](xihorn-rust-results-h4-three-representations.md) and [H5 — the Lambert-W asymptotic](xihorn-rust-results-h5-lambert-w-asymptotic.md) — the two independent confirmations.
- [O'S] Theorem 1.4 — [harvested from H_track.md](xihorn-h-track-os-theorem-1-4.md).

## Notes

- The retraction this result carries: TODO H1's feasibility worry was wrong, and its "the binding constraint is node density" claim is retracted as **E10**. "Counting nodes across a peak estimates *algebraic* accuracy; the trapezoid rule on an analytic, doubly-exponentially decaying integrand is **geometric**."
