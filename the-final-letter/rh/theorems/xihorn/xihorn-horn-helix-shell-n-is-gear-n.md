# Shell *n* is gear *n* — the correspondence, term by term

**Kind:** Theorem
**Status:** PROVED (paper argument; Riemann's 1859 kernel, verified numerically to 3.2×10⁻²⁹)
**Area:** xi-horn
**Source:** [`xi-horn/horn-helix.md`](../../xi-horn/horn-helix.md) — §2 "Shell *n* is gear *n* — the correspondence, term by term", equation (5) (dictionary term "shell n is gear n")

## Statement

> For every *n* and every *s*:
>
> 2 ∫_{−∞}^{∞} φ_n(u)·e^{(s−½)u} du  =  ½·s(s−1)·π^{−s/2}·Γ(s/2) · n^{−s}    (5)
>
> Read (5) right to left: **the n-th gear of the helix, `n^{−s}`, dressed by the completion factor `½s(s−1)π^{−s/2}Γ(s/2)`, is the n-th shell of the horn.** That is the whole relationship in one identity.

The shells are those of INTEGERS.md §1: `Φ(u) = Σ_{n≥1} φ_n(u)`, with

`φ_n(u) = (2π²n⁴e^{9u/2} − 3πn²e^{5u/2})·e^{−πn²e^{2u}}`    (4)

## Hypotheses and notation

- φ_n(u) is the n-th integer shell of the horn (equation (4) of the source, from INTEGERS.md §1); Φ(u) is the horn's radial profile.
- The horn's value is 2∫_{−∞}^{∞} Φ(u)·e^{itu} du = ξ(½ + it) (source (2)).
- The left side is the two-sided transform with kernel e^{(s−½)u}; ½·s(s−1)·π^{−s/2}·Γ(s/2) is the completion factor.
- The identity is claimed for every *n* and every *s* (no restriction to the critical line).

## Proof / evidence

The source gives the derivation in one sentence: "It is Riemann's 1859 derivation — `∫₀^∞ e^{−πn²x}x^{s/2−1}dx = π^{−s/2}Γ(s/2)n^{−s}` — with the horn's variable `x = e^{2u}` and the s(s−1)/2 from the two integrations by parts that turn ω into Φ." It is "Verified — the left side by quadrature, the right in closed form", with relative errors 0, 0, 2.0e−41 at s = 2 for n = 1, 2, 3; 2.0e−30, 1.1e−29, 3.2e−29 at s = ½ + iγ₁; 9.7e−30, 4.8e−29, 1.2e−28 at s = 0.3 + 5i. §12 and §13 quote the worst as 3.2×10⁻²⁹.

## Dependencies and related results

- Riemann's 1859 integral ∫₀^∞ e^{−πn²x}x^{s/2−1}dx = π^{−s/2}Γ(s/2)n^{−s}.
- INTEGERS.md §1 for the shell decomposition (equation (14) there).
- Consequences harvested separately: [shell 1 is the place at infinity](xihorn-horn-helix-shell-1-is-the-place-at-infinity.md), [the non-summable correspondence](xihorn-horn-helix-non-summable-correspondence.md).
- Restated as an identity in *u* with the σ = ½ weight in [horn-helix-revisited.md](../../xi-horn/horn-helix-revisited.md) (6)–(7) → [the translation identity](xihorn-horn-helix-revisited-translation-identity.md).

## Notes

- The source's own framing: "§2–§3 are Riemann 1859 read backwards"; (5) is presented as "the whole relationship in one identity" between the two figures.
- Consequence (a) in the source corrects README §8.1: the integers survive *individually and identifiably*, one shell per gear — not merely "the integers are gone" being wrong.
- The identity is exact term by term but non-summable at σ = ½; the summed form diverges (see the companion file). §11.4 warns against reading the horn as containing "everything the helix knows".
