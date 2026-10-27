# The Final Letter

**Two walls, one kind of missing input: a unified research programme from the Riemann hypothesis to the parity barrier.**

This folder rewrites the two research corpora — [`summary/`](summary/README.md) (geometric DQPT/spectral measures for RH) and [`summary-rh/`](summary-rh/README.md) (greedy harmonic sine/twin-prime parity) — into a single programme, and adds the certified computation layer they need. It states the two walls, the hypotheses, the conjectures, the proofs, the findings, the significance, the novelty, the further research, the bridges, and a final note on what has been achieved and the futility of it all.

The programme does **not** prove the Riemann hypothesis, the twin-prime conjecture, Chowla for `k ≥ 2`, Sarnak’s conjecture, or Elliott’s conjecture. It sets out a conversion, a sharpness theorem, a finite-prefix indeterminacy theorem, a five-bridge refutation, and a Lean spine, at five different levels of evidence. The final note argues that the failure is structural, not accidental.

| Result | Evidence level |
|---|---|
| RH conversion; Davenport–Heilbronn sharpness (C.10) | Written proof in the accompanying paper; not machine-checked, not peer-reviewed |
| Finite-prefix indeterminacy theorem | Lean-checked (`FinalLetter/Synthesis.lean`) |
| Certified evaluator: rational cell, certificate replay, transcendental enclosures, Euler–Maclaurin S1–S2 | Lean-checked (`topics/partial-sum-plus-tail/lean`); S1–S2 are proved for `K ≥ 1` |
| Sylvester-sparsity theorem; five-bridge refutation | Argument about this programme's own proposed routes, not a survey of the literature |
| Lean spine | Lean-checked, but covers only the finite layer and the wall definitions |

## The third objective

The two walls are the programme's negative results. The **third objective** is positive: a certified partial-sum-plus-tail evaluator for `ζ`, `ζ(s,a)` and `L(s,χ)`. It supplies a rational interval layer, an independent certificate checker, a kernel-checked Lean replay of every rational operation, kernel-checked enclosures for `π`, `exp`, `log`, `sin` and `cos`, a concrete ζ(2) replay with every atom discharged, and a Lean-proved Euler–Maclaurin identity and explicit tail bound. It is the computation layer the walls need, not a bridge across either. In the letter it is integrated as Objective III: it is described in [01 — Description](categories/01-description/description.md), recorded in the [proof ledger](categories/05-proofs/proofs.md#c-the-certified-evaluation-layer), and carried into the findings, significance, novelty and further research. It is an instrument, not a hypothesis: no theorem about either wall uses a certified enclosure as a premise yet. The dossier is [topics/partial-sum-plus-tail](topics/partial-sum-plus-tail/README.md), with a focused annex at [topics/euler-maclaurin](topics/euler-maclaurin/README.md).

## Read the programme

The numbered sections are grouped under [categories/](categories/README.md); the table below links directly to each file.

| Section | File |
|---|---|
| Description | [categories/01-description/description.md](categories/01-description/description.md) |
| Abstract | [categories/02-abstract/abstract.md](categories/02-abstract/abstract.md) |
| Table of contents | [TABLE-OF-CONTENTS.md](TABLE-OF-CONTENTS.md) |
| Evidence layout | [EVIDENCE.md](EVIDENCE.md) |
| Hypotheses | [categories/03-hypotheses/hypotheses.md](categories/03-hypotheses/hypotheses.md) |
| Conjectures | [categories/04-conjectures/conjectures.md](categories/04-conjectures/conjectures.md) |
| Proofs | [categories/05-proofs/proofs.md](categories/05-proofs/proofs.md) |
| Findings | [categories/06-findings/findings.md](categories/06-findings/findings.md) |
| Significance | [categories/07-significance/significance.md](categories/07-significance/significance.md) |
| Novelty | [categories/08-novelty/novelty.md](categories/08-novelty/novelty.md) |
| Further research | [categories/09-further-research/further-research.md](categories/09-further-research/further-research.md) |
| Walls | [categories/10-walls/walls.md](categories/10-walls/walls.md) |
| Bridges | [categories/11-bridges/bridges.md](categories/11-bridges/bridges.md) |
| Final note | [categories/12-final-note/final-note.md](categories/12-final-note/final-note.md) |
| Scraps — unharvested programmes | [scraps.html](scraps.html) |
| Third objective — certified evaluation | [topics/partial-sum-plus-tail](topics/partial-sum-plus-tail/README.md) · [Euler–Maclaurin annex](topics/euler-maclaurin/README.md) · [proof ledger C](categories/05-proofs/proofs.md#c-the-certified-evaluation-layer) |
| Research status — walls, bridges, roadmap | [status.html](status.html) |
| Topic folders | [topics/](topics/index.html) · [status](topics/STATUS.md) |
| Paper bundle | [geometric-dynamical-phase-transitions/](geometric-dynamical-phase-transitions/README.md) |

The single-page HTML version is [`index.html`](index.html); it is the canonical reading artefact, and the Markdown files in this folder are the source text. The status ledger is [`STATUS.md`](STATUS.md); the live research status, including the wall-by-wall application of Objective III, the outstanding items and the bridge requirements, is [`status.html`](status.html). The gap ledger is [`GAP-LEDGER.md`](GAP-LEDGER.md).

## The thesis in five sentences

1. The Riemann hypothesis is converted into the equality of the balanced and unrestricted supports; the additive toolbox is proved unable to close it by the Davenport–Heilbronn twist.
2. The twin-prime/Chowla wall is converted into a parity/coupling problem; the finite-prefix theorem shows that a finite correlation does not determine its limit, and the five-bridge refutation disposes of the programme’s proposed routes.
3. Both walls are missing a global arithmetic positivity, not a local estimate.
4. Finite prefixes, additive characters, sign-blind rules, and density statements cannot manufacture that object.
5. The programme’s achievement is the map of the wall; its futility is that the wall is still there.

## What is established, and how

- The RH conversion: Corollary 12.3 of the geometric programme — a written proof, not Lean-checked.
- The Davenport–Heilbronn sharpness and the limitative consequence C.10 — written proofs.
- The finite-prefix indeterminacy theorem, Lean-certified.
- The Sylvester-sparsity theorem and the five-bridge refutation — arguments over the programme's own proposed routes.
- The one clean parity theorem and the barrier ledger P1–P19, B1–B5, N1–N3.
- The Lean spine: `FinalLetter/Chowla.lean`, `FinalLetter/Synthesis.lean`, `FinalLetter.lean`, all `[check] OK` — the finite layer only.
- The rational interval/certificate core of the third objective, with the eta cos/sin split, the `π`/`exp`/`log`/`sin`/`cos` enclosures, the integer zeta bound, eta identity and `L`-reduction, and the Euler–Maclaurin identity and explicit tail bound for `K ≥ 1`, all `[check] OK`.

## What is not proved

RH, twin primes, Chowla for `k ≥ 2`, Sarnak, Elliott, `(M)`, OP-19, F.4, `Λ=0`, the Jensen/Li tower, uniform slow passage. The evaluator's Euler–Maclaurin identity and explicit tail bound are Lean theorems for `K ≥ 1`, and they now yield a closed rectangle enclosure for `Re s > 1`; no wall theorem consumes the evaluator, and only the target-width certificate format, not a symbolic width bound, is proved.

## Lean

```
cd the-final-letter/lean
./check.sh --all
# [check] OK FinalLetter/Chowla.lean
# [check] OK FinalLetter/Synthesis.lean
# [check] OK FinalLetter.lean
```

The same Lean 4 + Mathlib installation as `~/workspace/rh` is used (`~/lean`, `v4.35.0-rc2`). The recorded build log is [`the-final-letter/lean/BUILD.log`](lean/BUILD.log). The development has no `sorry` and no `axiom`; the open statements are `def`s, not axioms.

## Evidence

The evidence annexes are:

- [`summary/`](summary/README.md) — the Riemann programme: 104 canonical statements, 90 frozen truths, the tensor refutation, the working notes, the archive.
- [`summary-rh/`](summary-rh/README.md) — the parity programme: 13 ledger sections, 15 papers, 19 OPs, 36 open items, the Lean audit.

The letter also carries local copies of both annexes and of the archived sources it cites, so the whole folder can be read, served, or archived without the rest of the site. The layout and its caveats are recorded in [EVIDENCE.md](EVIDENCE.md).

## A note on the final note

The final note is deliberately called “the futility of it all”. It is not nihilism. It is the claim that a certain class of attack — more computation, more local estimates, more finite prefixes, more sign-blind rules — cannot close these walls. The map is real. The wall is real. The door is not in this house.

[Back to index](index.html) · [Master TOC](TABLE-OF-CONTENTS.md) · [Status](STATUS.md)
