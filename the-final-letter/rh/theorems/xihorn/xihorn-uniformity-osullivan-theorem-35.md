# [O'S] Theorem 3.5 — the Ω-family criterion

**Kind:** Theorem
**Status:** CITED (literature — O'Sullivan, arXiv:2007.13582v2)
**Area:** xi-horn
**Source:** [`xi-horn/uniformity-in-the-jensen-degree-d.md`](../../xi-horn/uniformity-in-the-jensen-degree-d.md) — §5 "The criterion is the free parameter — and what it cannot buy", quoted theorem box

## Statement

> **[O'S] Theorem 3.5.** *Let Φ(z) = Σ_{j≥0} c_j·z^j/j! be a real entire function of genus 1\* and let Ω(z) be in the Laguerre–Pólya class. Then Φ(z) is hyperbolic if and only if the polynomials*
>
> ```
> Σ_{j=0}^{d} C(d,j) · c_j · g*_{d−j}(Ω; x)                             (3.5)
> ```
>
> *are hyperbolic for all d ≥ 1.*

## Hypotheses and notation

- Φ(z) = Σ_{j≥0} c_j·z^j/j! is real entire of genus 1\*; Ω lies in the Laguerre–Pólya class LP.
- g*_d(Ω; x) is the reciprocal Jensen polynomial of Ω ([O'S] Lemma 3.4 identifies (3.5) as g*_d(Φ·Ω; x)).
- Hyperbolic = all zeros real; the quantifier is all d ≥ 1.
- Source's reading: "So the criterion has one genuine dial, Ω ranging over the Laguerre–Pólya class; every setting is equivalent to RH".

## Proof / evidence

The source quotes it without proof and states its role: "The most consequential thing in [O'S] is not Theorem 1.3 but the theorem that explains why a Theorem 1.3 was available at all". Settings of the dial recorded by the source: "Ω = 1 returns J_{d,n}. Ω = e^{−z²} — whose Jensen polynomials are Hermite: g*_d(e^{−z²}; x) = H_d(x/2) — returns P_{d,n}. Ω = 𝒥_ν (Bessel) returns a Laguerre family with a *continuous* parameter" ([O'S] Theorem 3.9).

The §7 reconciliation of the Hermite case: "**g\*_d(e^{−z²}; x) = H_d(x/2):** e^{−z²} = Σ_i (−1)^i·(2i)!/i!·z^{2i}/(2i)!, so g*_d = Σ_i C(d,2i)·(−1)^i·(2i)!/i!·x^{d−2i} = d!·Σ_i (−1)^i·x^{d−2i}/(i!·(d−2i)!) = H_d(x/2)."

## Dependencies and related results

- [O'S] Lemma 3.4 ([harvested](xihorn-uniformity-osullivan-lemma-34.md)); [O'S] Theorem 3.9 ([harvested](xihorn-uniformity-osullivan-theorem-39.md)); [O'S] Theorem 1.1 ([harvested](xihorn-uniformity-osullivan-theorem-11.md)) as the Ω = 1 case.
- Its fixed-shift consequence is [the Ω-dial invariance](xihorn-uniformity-omega-dial-invariance.md).
- The source charts the dial's effect: "one turn of it — 1 to e^{−z²} — moved the effective threshold from e^{0.9634d} to d^{3/4}log²n."

## Notes

- The source's framing: "every setting is equivalent to RH; … what differs between settings is never content, only cost of verification" (called "**H6**'s reframing of C2").
- The Ω = 𝒥_ν setting is quoted separately as [O'S] Theorem 3.9; the source records the parameter range "all real ν > −2" there.
