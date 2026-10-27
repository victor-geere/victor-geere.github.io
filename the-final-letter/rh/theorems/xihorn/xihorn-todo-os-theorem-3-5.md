# [O'S] Theorem 3.5 — the Ω-family criterion

**Kind:** Theorem
**Status:** CITED (literature — O'Sullivan, arXiv:2007.13582v2)
**Area:** xi-horn
**Source:** [`xi-horn/TODO.md`](../../xi-horn/TODO.md) — §H6 "Search over Ω ∈ LP for the criterion with the earliest onset"

## Statement

> [O'S] Theorem 3.5: for Φ(z) = Σ c_j z^j/j! real entire of genus 1\* and
> **any** Ω in the Laguerre–Pólya class,
>
> ```text
> Φ hyperbolic  ⟺  Σ_{j=0}^{d} C(d,j)·c_j·g*_{d−j}(Ω; x)  hyperbolic for all d ≥ 1
> ```
>
> Ω = 1 gives J^{d,n}; Ω = e^{−z²} gives P^{d,n}(x/2). **That single substitution
> took the effective bound from e^{0.96d} to d^{3/4}log²n**, so the free
> parameter is not the degree and not w — it is Ω, and H3 supplies the cost
> function.

## Hypotheses and notation

- Φ(z) = Σ c_j z^j/j! is real entire of genus 1\*; Ω is **any** member of the Laguerre–Pólya class LP.
- g*_d is the reciprocal Jensen polynomial; the quantifier is all d ≥ 1.
- Ω = 1 gives J^{d,n}; Ω = e^{−z²} gives P^{d,n}(x/2).
- The source's reading of the effective bounds: "e^{0.96d}" for the Ω = 1 choice and "d^{3/4}log²n" for Ω = e^{−z²}.

## Proof / evidence

The source quotes the theorem without proof. Its role here is to reframe C2: "**That single substitution took the effective bound from e^{0.96d} to d^{3/4}log²n**, so the free parameter is not the degree and not w — it is Ω, and H3 supplies the cost function." The H6 search built on it validates against both published criteria — ν = 0, μ = 0, σ = 1, g* form reproduces [O'S] (8.2) to 6.05e−77, and Ω = 1, σ = Δ/ρ, τ = −1/Δ, g form reproduces [GOR⁺] (2.9) to 8.39e−69, 50 cells each.

## Dependencies and related results

- [H6 — searching Ω for the criterion with the earliest onset](xihorn-h-track-h6-omega-search.md) — the measured cost across Ω.
- [[O'S] Theorem 3.5 from H_track.md](xihorn-h-track-os-theorem-3-5.md).
- [H3 — where the Turán criteria actually start to hold](xihorn-h-track-h3-turan-onset.md) — the cost function, and E19's qualification.

## Notes

- The source's caveat in H6 applies to this theorem's use: the shifted Ω = e^{−z²−μz} is legal "for Theorem 3.5 — Ω … is in LP and is fixed across d, as the theorem requires; μ depends on n only, which [GOR⁺]'s own renormalisation (depending on both n and d) does not manage."
