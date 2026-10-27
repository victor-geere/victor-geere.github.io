# [O'S] Lemma 3.4 — (3.5) is the reciprocal Jensen family of Φ·Ω

**Kind:** Lemma
**Status:** CITED (literature — O'Sullivan, arXiv:2007.13582v2; statement recorded in the source's words, not quoted verbatim)
**Area:** xi-horn
**Source:** [`xi-horn/uniformity-in-the-jensen-degree-d.md`](../../xi-horn/uniformity-in-the-jensen-degree-d.md) — §5 "The criterion is the free parameter — and what it cannot buy"

## Statement

> **Lemma 3.4.** *Let Φ and Ω be two formal power series with Φ(z) = Σ_{j≥0} c_j z^j/j!. Then for all d ≥ 0, g*_d(Φ·Ω; x) = Σ_{j=0}^{d} C(d,j)·c_j·g*_{d−j}(Ω; x).* — the paper's proof: "This is an easy exercise."
>
> Here g*_d(Ω; x) is the reciprocal Jensen polynomial of Ω, and the identity is what identifies (3.5) as g*_d(Φ·Ω; x) — the observation the source draws from it is its own gloss: **every choice of Ω is the classical Jensen family of the product Φ·Ω**, and multiplying by an LP factor neither adds nor removes real-zero content.

## Hypotheses and notation

- (3.5) is the family of [O'S] Theorem 3.5: Σ_{j=0}^{d} C(d,j) · c_j · g*_{d−j}(Ω; x), for Φ(z) = Σ_{j≥0} c_j·z^j/j! real entire of genus 1\* and Ω in the Laguerre–Pólya class.
- g*_d(·; x) is the reciprocal Jensen polynomial; Φ·Ω is the pointwise product of the two entire functions.
- LP factors "neither add nor remove real-zero content" — the **source's gloss** on why every dial setting is equivalent to RH; it is the reading the source takes from the identity, not a sentence of the paper's Lemma 3.4.

## Proof / evidence

The source states the identification as [O'S]'s, without reproducing [O'S]'s proof. The source's use of it is the dial picture of §5: "every choice of Ω is the classical Jensen family of the product Φ·Ω"; with Ω = 1 returning J_{d,n} and Ω = e^{−z²} returning P_{d,n}.

## Dependencies and related results

- [O'S] Theorem 3.5 ([harvested](xihorn-uniformity-osullivan-theorem-35.md)) is the theorem it serves; [O'S] Theorem 3.9 ([harvested](xihorn-uniformity-osullivan-theorem-39.md)) is a further setting.

## Notes

- The source does not print Lemma 3.4's own wording; the statement above is the source's rendering ("Lemma 3.4 identifies (3.5) as g*_d(Φ·Ω; x): …"). It is harvested because the source sets it out as a labelled rung of the dial argument, with content; the phrase "every choice of Ω is the classical Jensen family of the product Φ·Ω" is the source's, not necessarily [O'S]'s.
- No proof is reproduced in the source.

- **Primary-source correction (2025-10-06, session 003 citation audit).** The lemma was presented as carrying a substantive claim about real zeros. The paper's Lemma 3.4 is a **bare algebraic identity** — "Let Φ and Ω be two formal power series with `Φ(z) = Σ_{j≥0} c_j z^j/j!`. Then for all `d ≥ 0`, `g*_d(Φ·Ω;x) = Σ_{j=0}^{d} C(d,j) c_j g*_{d−j}(Ω;x)`" — and its proof is "This is an easy exercise." The real-zero reading belongs to the *use* the paper makes of it in Theorem 3.5, and to the archive's source's gloss; the statement above now gives the identity as the paper states it and marks the gloss as the source's.
