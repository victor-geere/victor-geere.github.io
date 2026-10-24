# RH ⟺ the Schur sequence never leaves the open unit disc

**Kind:** Corollary
**Status:** PROVED (paper argument, chaining P1–P3; the hypothesis itself remains open)
**Area:** rh-html
**Source:** [`rh15.html`](../../html/rh15.html) — §6 "What is proven, what is certified, what is not"

## Statement

> Chain them and the reading is exactly as strong as advertised: **RH ⟺ |ρ<sub>k</sub>(Δ)| &lt; 1 for every k and every Δ**, where the ρ are computed from the primes and the Γ-factor by a finite recursion with no zero consulted. That is question (iii)'s answer in one line, and it is a theorem.

## Hypotheses and notation

- ρ<sub>k</sub>(Δ) are the Schur/Levinson–Durbin reflection coefficients of the kernel E at mesh Δ (see the P1 box for the recursion and notation).
- The chain is P1 (finite sections positive definite ⟺ σ<sub>k</sub>² > 0 ⟺ |ρ<sub>k</sub>| &lt; 1) + P2 (grid windows dense; E positive-definite on Δℤ for every Δ > 0 ⟺ Weil's form nonnegative on every compactly supported window) + P3 (Weil's criterion, cited).
- The dictionary row of the page states the same equivalence in smallest form: "RH ⟺ the Schur sequence of E never leaves the open unit disc".

## Proof / evidence

The source chains the three labelled boxes: P1 gives the finite-section equivalence, P2 passes from the grid to the line, P3 supplies Weil's cited criterion; the corollary is the composition. The page's §7 adds the honest limit: "And the reading of a slice is one recursion, support-independent, quadrature-stable to 10⁻⁶, whose margin *widens* from 0.403 to 0.698 as the mesh refines." The recursion's computed margins are max|ρ| = 0.5966 (Δ = 0.06), 0.3769 (Δ = 0.03), 0.3018 (Δ = 0.015), i.e. margins 0.403, 0.623, 0.698.

## Dependencies and related results

- [P1 — Schur/Levinson–Durbin equivalence](rh15-p1-schur-levinson-durbin-equivalence.md), [P2 — grid windows are dense](rh15-p2-grid-windows-dense-equivalence.md), [P3 — Weil's positivity criterion](rh15-p3-weil-positivity-criterion.md) — the three links of the chain.
- [RH ⟺ E is positive-definite on every interval](../rh14/rh14-bochner-reading-of-rh.md) — rh14's equivalent statement, which this one sharpens to one scalar inequality per node.
- [The widest positivity certificate](rh15-widest-positivity-certificate.md) — a finite prefix of the sequence, certified.
- rh16 §2 uses the same recursion constructively (the inverse map) and §4 uses ρ-sequences as a diagnostic.

## Notes

- The equivalence is a theorem; RH is not proved by it. The source is explicit: "What no finite computation reaches is the conjunction. Every certificate here is a prefix — of one sequence, at one mesh. RH is the assertion that all of them, at all meshes, run forever."
- The page's own reading of the chain: "That is question (iii)'s answer in one line, and it is a theorem."
