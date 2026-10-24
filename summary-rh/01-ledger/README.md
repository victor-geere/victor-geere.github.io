# 01 — The proved-results ledger

This folder reproduces [`research/truths.md`](../rh/research/truths.md), the programme’s canonical ledger of what has actually been established and where the Lean proof lives. It is the single most important layer of the repository: the 15 published papers are expositions, the rounds are provenance, but the ledger is the audited list of results.

The ledger has 13 sections and 140 named result rows. Each section file preserves the source table, including its status column and its links to the Lean declarations.

## What the ledger covers

| Section | Subject |
|---|---|
| 1 | The state of the Lean corpus: builds, `sorry`, axiom footprints |
| 2 | The greedy digit word and the complexity law (`rh41`) |
| 3 | Budgets, reachability and the Tau alphabet (`rh42`) |
| 4 | Partial sums at `Re S = 0` and the equal split (`rh43`) |
| 5 | The smoothing bridge (`rh044`) |
| 6 | The explicit formula and Routes A/B/C (`rh45` / `010`) |
| 7 | Two-point Chowla and the finite-prefix theorem (`rh46`) |
| 8 | Greedy sine vs the parity barrier (`rh47`) |
| 9 | OP-5 and OP-6, resolved |
| 10 | Generalisations and attempts (`007`, `008`, `009`) |
| 11 | von Mangoldt sieves (`publish/001`) |
| 12 | Cone, shift-2 core and the three thresholds |
| 13 | The programme’s positive ledger in one line each |

## The status vocabulary

The ledger uses `PROVED (Lean)`, `PROVED (Lean + native_decide)`, `PROVED (paper)`, `VERIFIED`, `CHECKED`, `REFUTED`, `OPEN`. See [the status taxonomy](summary-rh/05-lean-verification/02-status-taxonomy.md). A `CERTIFIED` finite window is not an asymptotic theorem; a `PROVED (paper)` statement is not machine-checked.

## The one clean new theorem

The programme’s headline result is the **finite-prefix indeterminacy theorem** for the two-point Liouville correlation (section 7): two functions can agree on `[1,10⁸]` and still have opposite correlation asymptotics, so no finite computation can decide two-point Chowla. It is Lean-certified (`Rh46/Chowla.lean`, 42 theorems). The two-point Chowla statement itself remains **OPEN**.

## What is not here

The ledger does not prove the Riemann hypothesis, the twin prime conjecture, Chowla, Sarnak, or Elliott. It records the programme’s positive results and its finite certificates. The open layer is in [03 — Open problems](summary-rh/03-open-problems/README.md).

[Back to the summary index](summary-rh/README.md) · [Folder TOC](summary-rh/01-ledger/TOC.md)
