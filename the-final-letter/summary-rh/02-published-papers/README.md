# 02 — Published papers

The repository’s `research/publish/` series contains 15 papers, `001` to `015`. This folder harvests every bold theorem, lemma, proposition, corollary, conjecture, hypothesis and definition block from each `manuscript.md`: **147 statements** in total, with the source text and proof/argument that follows each statement.

## The papers

| # | Paper | Statements | Notes |
|---|---|---|---|
| 001 | Sieves for the von Mangoldt Function | 14 | first edition, Lean companion |
| 002 | The Greedy Digit Word and the Complexity Law | 15 | truths §2 |
| 003 | Budgets, Reachability and the Tau Alphabet | 17 | truths §3 |
| 004 | Partial Sums at Re S = 0 and the Equal Split | 18 | truths §4 |
| 005 | The Smoothing Bridge | 10 | truths §5 |
| 006 | The Explicit Formula and Routes A/B/C | 6 | corrected normalisation |
| 007 | Two-Point Chowla and the Finite-Prefix Theorem | 10 | 014 is fuller |
| 008 | Greedy Sine vs the Parity Barrier | 1 | paper + numerics; no Lean |
| 009 | OP-5 and OP-6, Resolved | 9 | truths §9 |
| 010 | Generalisations: Character Weights, Shift-2, Angle Parity | 8 | truths §10 |
| 011 | Sieves for the von Mangoldt Function (packaged) | 14 | duplicate of 001 |
| 012 | Cone, Shift-2 Core and the Three Thresholds | 3 | sources in workspace `lean/` |
| 013 | Twin-Prime Parity: the Complete Registry and the Explicit-Function Programme | 10 | synthesis of O1–O3 |
| 014 | The Finite-Prefix Indeterminacy Theorem | 10 | fuller than 007 |
| 015 | Parity Barrier in Primes over Function Field Zeta | 2 | correction notice C0/C1 |

## How to read a paper file

Each file has:

1. a metadata table with the source path and status;
2. the paper’s abstract;
3. every harvested theorem-like statement as a `###` heading, followed by the source text and its proof/argument;
4. a source link to the manuscript and README.

The extraction is statement-level, not a paraphrase: the text under each heading is the manuscript’s own text for that block, ending at the next theorem-like block or heading.

## Duplicates and editions

- **001 / 011** are the same paper; 011 is the packaging of truths §11.
- **007 / 014** are the same theorem; 014 is the fuller edition.
- **013** is the registry/synthesis and overlaps the earlier papers but adds the explicit-function programme.

## What “published” does not mean

It does not mean every claim is proved. 007/014 explicitly leave two-point Chowla open; 008 has no Lean layer; 015 carries a correction notice (C0 retracts its own dimension law; C1 corrects the character-sum identity). See [errata](../05-lean-verification/03-errata.md).

[Back to the summary index](../README.md) · [Folder TOC](TOC.md)
