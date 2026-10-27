# [O'S] Lemma 3.4 (3.3) — the product rule for reciprocal Jensen polynomials

**Kind:** Lemma
**Status:** CITED (literature — O'Sullivan, arXiv:2007.13582v2)
**Area:** xi-horn
**Source:** [`xi-horn/H_track.md`](../../xi-horn/H_track.md) — §H6 "searching Ω for the criterion with the earliest onset"

## Statement

> [O'S] §3 defines, for a formal power series Φ(z) = Σ c_j z^j/j!, the Jensen
> polynomial and its reciprocal, and proves a product rule for them:
>
> ```text
> g_d(Φ; x)  := Σ_{j=0}^{d} C(d,j)·c_j·x^j
> g*_d(Φ; x) := x^d·g_d(Φ; 1/x) = Σ_{j=0}^{d} C(d,j)·c_j·x^{d−j}
> g*_d(Φ·Ω; x) = Σ_{j=0}^{d} C(d,j)·c_j·g*_{d−j}(Ω; x)      Lemma 3.4, (3.3)
> ```

## Hypotheses and notation

- Φ(z) = Σ_{j≥0} c_j z^j/j! is a formal power series; g_d is its Jensen polynomial and g*_d its reciprocal; Ω is a second such series.
- C(d,j) is the binomial coefficient; the sum ranges j = 0…d.
- The source applies it twice: once as (3.3), and once with Ω replaced by e^{−z²} to write g*_d(Ψ; x) = Σ_j C(d,j)·χ_j·H_{d−j}(x/2), χ := Ψ·e^{+z²}.

## Proof / evidence

The source quotes the rule and calls it "Lemma 3.4, (3.3)", attributing the proof to [O'S] §3; it gives no proof itself. It uses the rule as the mechanism that avoids converting bases (and so avoids manufacturing cancellation), and validates the resulting formula against `turan.rs`, "a `turan.rs` that never touches Lemma 3.4", to 6.05e−77 / 8.39e−69 over 50 cells each.

## Dependencies and related results

- [[O'S] Theorem 3.5](xihorn-h-track-os-theorem-3-5.md) — the criterion the product rule makes expressible.
- [H6 — searching Ω for the criterion with the earliest onset](xihorn-h-track-h6-omega-search.md) — the search built on it.
- Harvested from the same family elsewhere in the workspace as [[O'S] Lemma 3.4](xihorn-uniformity-osullivan-lemma-34.md).

## Notes

- The reciprocal convention here is g*_d(Φ; x) := x^d·g_d(Φ; 1/x); the source's H6 formula for the criterion uses this normalisation throughout.
