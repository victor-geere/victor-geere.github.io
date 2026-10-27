
### 2026-10-27 — Phase I.271: `ζ′` enclosure building block validated

Probed the atom that the `ζ′` (hence `h1`, hence `hC`) enclosure rests on:

    derivAtom n = cpowBox 20 16 48 24 n S14  ×  logIvRat 20 n

In Lean: width `≤ 10⁻³` per coordinate at `n = 2, 10, 20`, and the box contains
`log n · n^{-s14}` (checked against `10⁻³` windows at `n = 10, 20`).  So
multiplying a `CpowBox` atom by a `logIvRat` box is tight and correct — the
`log` factor costs nothing measurable.  This is the piece that could have
silently failed, as the 2D-region enclosure did in round 16.

Two of my probe attempts failed first, both my own fault: a guessed window with
the wrong sign, then windows within `10⁻⁷` of the true value (too tight to
distinguish "box is wrong" from "my rational is above the true value").  The
probe was still cheap and decisive; the lesson is to pick windows at the scale
of the tolerance being claimed, not at the scale of the value.

Gap identified for the next step: Mathlib has no `HasDerivAt (fun s => b ^ s)`.
It must be assembled from `Complex.cpow_def` + `HasDerivAt.exp` + chain rule.
