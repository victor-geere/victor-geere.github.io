# [O'S] (7.2) — the moment integral for ξ^(n)(½), attributed to Romik and Jensen

**Kind:** Theorem
**Status:** CITED (literature — [O'S] (7.2), attributed there to Romik and called "implicit in Jensen's formula from [Jen13, p. 189]" — 1913)
**Area:** xi-horn
**Source:** [`xi-horn/TODO.md`](../../xi-horn/TODO.md) — §E "Corrections already applied", entry E9

## Statement

> **E9. The horn is not new either, and it has a name.** [O'S] (6.1)
> defines θ(t) = Σ_{k∈ℤ} e^{−πk²t}, ω(t) = ½(3tθ′(t) + 2t²θ″(t)) and
> **Φ(x) := 2e^{x/2}ω(e^{2x})** — which expands to exactly **twice** this
> directory's Φ. And (7.2), **ξ^(n)(½) = ∫_{−∞}^{∞} Φ(y)·y^n dy**, is
> attributed to Romik and called "implicit in Jensen's formula from [Jen13,
> p. 189]" — 1913.

## Hypotheses and notation

- θ(t) = Σ_{k∈ℤ} e^{−πk²t} is the Jacobi theta series; ω(t) = ½(3tθ′(t) + 2t²θ″(t)); Φ(x) := 2e^{x/2}ω(e^{2x}) is [O'S]'s normalisation.
- The doubling: [O'S]'s Φ "expands to exactly **twice** this directory's Φ".
- ξ^(n)(½) is the n-th derivative of Riemann's ξ at the critical point; (7.2) is the moment integral.
- The attribution given by the source: Romik; and "implicit in Jensen's formula from [Jen13, p. 189]" — 1913.

## Proof / evidence

The source quotes the definitions and the identity and gives the attribution; it proves nothing. Its own check of the last line is arithmetical and recorded in H4: "**Φ(u) = e^{u/2}·ω(e^{2u})** to sixty digits on both sides of the throat (which is **E9**'s identification, in one line)".

## Dependencies and related results

- [H4 — γ(n) from two representations that are not the horn](xihorn-h-track-h4-three-representations.md) — the sixty-digit check of the identification; (7.1) is the same integral after t = e^{2u}.
- [H1 — a(n) at n = 1000](xihorn-h-track-h1-a1000-vs-os-table-1.md) — the coefficient this identity defines.

## Notes

- **Fidelity note:** this entry is a *correction of attribution*, not a new result. The source's own words: "The README's framing ('the mathematical content is classical throughout') was right; this is the specific citation it was missing, and any wording suggesting the construction originates here should go."
- Note the factor: [O'S]'s Φ is **twice** this directory's Φ — the identification is Φ(u) = e^{u/2}ω(e^{2u}) up to that normalisation, as H4 checks.
