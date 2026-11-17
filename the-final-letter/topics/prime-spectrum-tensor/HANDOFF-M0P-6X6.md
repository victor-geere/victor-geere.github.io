# M0′ at 6×6 — formal status and next steps

> **Closed 2026-11-15.** The rung is now unconditional:
> `gaussianGram6_posDef` in [`lean/Closure6.lean`](lean/Closure6.lean), with a
> clean axiom audit.  This file is kept as the *route record* up to the closure;
> the live handoff is [`HANDOFF-M0P-NEXT.md`](HANDOFF-M0P-NEXT.md).  The
> "what blocks" section below is the state before the certificate-size fix —
> the widths quoted there were real, but the conclusion that finer partitions
> were unaffordable was a consequence of the old generator, not of the machine.

This note records the state of the 6×6 Gaussian Weil–Gram rung after the work
of November 2026.  It is the successor of [`HANDOFF-M0P-5X5.md`](HANDOFF-M0P-5X5.md).

## What is proved

* **Transfer infrastructure** — [`GaussianGram6.lean`](lean/GaussianGram6.lean):
  `centre6 = (0,1/5,2/5,3/5,4/5,1)`, `gaussianGram6`, the rational Toeplitz
  centre `gramCentre6`, margin `gramMargin6 = 1/70`, the exact `LDLᵀ`
  factorisation `gramCentre6 − (1/70)·I = L6·D6·L6ᵀ` with all six pivots
  positive, and the transfer lemma
  `gaussianGram6_posDef_of_entry_bound` (`ε·6 < 1/70`).
* **Assembly** — [`Assembly6.lean`](lean/Assembly6.lean):
  `gaussianGram6_posDef_of_density_bands` (entry budget `ε = 2·10⁻³`,
  `6ε = 0.012 < 1/70`) plus the vector-level form.  With the six certified
  bands of [`DensityBands6.lean`](lean/DensityBands6.lean) it closes in
  [`Closure6.lean`](lean/Closure6.lean).  (The earlier conditional
  `gaussianGram6_posDef_of_density_enclosure` / `_fine` theorems fixed the
  interval numbers in advance; those numbers were stale and are superseded.)
* **Separation wall** — [`SeparationWall.lean`](lean/SeparationWall.lean):
  `six_centres_separation_wall` — six distinct centres cannot have all pairwise
  distances among `{0,1/5,2/5,3/5,4/5}`; a 6×6 certificate needs a new
  separation.
* **Lower rungs** — [`SubmatrixRungs.lean`](lean/SubmatrixRungs.lean),
  [`DetPos.lean`](lean/DetPos.lean): every principal submatrix and every
  principal minor of the certified 4×4 and 5×5 matrices is positive.

## What blocks the unconditional 6×6

The transfer needs `ε < 1/(70·6) ≈ 0.002381`.  The density term enters the entry
directly, so its band half-width must be below that.  Measured half-widths:

| `c` | certificate | density half-width |
|---|---|---:|
| 0, 1/5, 2/5, 3/5 | 1305-panel | 0.0035 |
| 4/5 | 1305-panel | 0.003173 |
| 1 | 1970-panel (`h0=1/200`, `h1=1/30`) | 0.002055 |

The `c = 1` slot is fine with the finer partition; the other five are not.
Generating all five at the finer resolution (and then a still finer one to get
below `0.0024` for them — another factor two) exceeds the machine's disk budget:
the partial 14-chunk `c = 1` chain filled the disk to 100% and was restarted
after cleanup.

## Next steps (superseded — see [`HANDOFF-M0P-NEXT.md`](HANDOFF-M0P-NEXT.md) §4)

1. Finish the running 1970-panel `c = 1` chain and rebuild the `c = 1` density
   certificate; record `densityTerm 1 (1/20) ∈ [−0.01311, −0.00900]`.
2. Generate the five remaining separations at `h0 = 1/400`, `h1 = 1/60`
   (≈ 8000 panels each, ~4× the current chain), freeing disk between chains.
3. Discharge the six hypotheses of
   `gaussianGram6_posDef_of_density_enclosure_fine`; the result is then
   unconditional.
4. Alternatively, find a better-conditioned 6-centre family (larger smallest
   eigenvalue) whose separations are already certified — impossible at spacing
   `1/5` by the separation wall.

Nothing here asserts the infinite Weil cone or the Riemann hypothesis.
