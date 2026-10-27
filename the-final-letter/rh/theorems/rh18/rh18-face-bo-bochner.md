# (Bo) — Bochner

**Kind:** Proposition
**Status:** OPEN (equivalent to the Riemann Hypothesis by Weil's criterion, cited not reproven)
**Area:** rh-html
**Source:** [`rh18.html`](../../html/rh18.html) — §2 "The functional, and the identity", theorem box "The three faces"

## Statement

> For every Δ &gt; 0, E<sub>Δ</sub> is a positive-definite function on ℝ: every finite real node set, every real coefficient vector.

## Hypotheses and notation

- E<sub>Δ</sub> is the arc's kernel on the mesh Δ &gt; 0.
- Positive-definite function in Bochner's sense: for every finite real node set and every real coefficient vector, Σ<sub>j,k</sub> c<sub>j</sub>c<sub>k</sub>E<sub>Δ</sub>(t<sub>j</sub> − t<sub>k</sub>) ≥ 0.
- The source's reading: "positive-definite functions; the reading behind (Bo)" — S. Bochner, *Vorlesungen über Fouriersche Integrale*, Leipzig (1932), cited.

## Proof / evidence

Not proved here. In [T — P2, closed](rh18-t-p2-closed.md) the source proves (Bo) ⟹ (L) by restriction to lattice nodes and (W) ⟹ (Bo) by the identity (2) at arbitrary nodes, giving (L) ⟺ (W) ⟺ (Bo); each is equivalent to RH by the cited Weil criterion (rh15's P3). The source stresses: "The equivalence is closed; the quantifier is the hypothesis."

## Dependencies and related results

- [(L) — lattice](rh18-face-l-lattice.md), [(W) — windows](rh18-face-w-windows.md).
- [T1a — the Weil identity at arbitrary nodes](rh18-t1a-weil-identity.md) is what makes (W) ⟹ (Bo) immediate.
- Cited: S. Bochner (1932); A. Weil (1952).

## Notes

- Harvested because the source labels it inside a theorem box as one of the three faces; it is an open statement and the Status says so.
- The source's figure labels this arrow "(W)⇒(Bo): T1a at arbitrary nodes".
