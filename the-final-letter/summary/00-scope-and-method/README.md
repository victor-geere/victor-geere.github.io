# 00 — Scope and method

This folder explains what the summary contains, what it deliberately leaves out, and how each statement was classified. It is the audit trail for the rest of the library.

## In one page

- **Canonical corpus.** The current live mathematical programme: [`publication.html`](../../geometric-dynamical-phase-transitions/publication.html), its companions [`gaps.html`](../../geometric-dynamical-phase-transitions/gaps.html), [`truths.md`](../../geometric-dynamical-phase-transitions/truths.md), [`tensor.md`](../../geometric-dynamical-phase-transitions/tensor.md), [`todo.md`](../../geometric-dynamical-phase-transitions/todo.md), [`publication-addendum-A.html`](../../geometric-dynamical-phase-transitions/publication-addendum-A.html), and the two working notes under [`maths/`](../../geometric-dynamical-phase-transitions/maths).
- **Archive.** Every explicitly labelled `Conjecture` or `Hypothesis` in a mathematical research page, the named result that makes it precise, and one entry per programme-level claimed proof. Duplicates and successive versions are collapsed.
- **Excluded.** Finance/trading/philosophy material, visualisation code, styling, and repeated draft versions.
- **Status.** Each item is marked proved, conditional, equivalent, open, refuted/withdrawn, or archived claim. The definitions are in [STATUS.md](../STATUS.md).

## The files

| File | Purpose |
|---|---|
| [Scope](scope.md) | The exact inclusion/exclusion rule, the corpus inventory, and the counts. |
| [Method](method.md) | How the theorem environments were extracted, converted, paired with proofs, and verified. |
| [Status taxonomy](status-taxonomy.md) | The six status labels and the evidence required for each. |

## Why the archive is not exhaustive

The archive has more than two hundred maths files. Many are the same note in versions `v2`–`v8`, `thesis copy`, `deepseek-checked1`–`6`, or duplicate filenames (`proof.html` and `ghd-proof.html`). Harvesting every file would produce dozens of copies of the same lemma and would present withdrawn claims as live. The canonical paper is the authority; the archive is provenance.

The archive selection rule is stated in [14 — Legacy conjectures](../14-legacy-conjectures/README.md): every explicitly labelled conjecture/hypothesis, its named equivalence/reduction, and one entry per claimed proof. That is a curated index, not a reprint.

## How to audit a statement

1. Open the item file; it names its type, status, source section, and whether a proof block is attached.
2. Follow the source link to `publication.html` (or the relevant companion).
3. If the item is cited, conditional, or refuted, check the corresponding ledger in [12 — Open problems](../12-open-problems/README.md).
4. If an archived page disagrees, the [withdrawn/refuted ledger](../12-open-problems/withdrawn-and-refuted.md) records which statement wins and why.

[Back to the summary index](../README.md) · [Folder TOC](TOC.md)
