# Summary-rh — the `~/workspace/rh` research corpus

Links in this folder are **relative to the file that contains them**. The research sources this annex cites are carried in the partial snapshot under [`../rh/`](../rh/), so the citations resolve inside `the-final-letter/`. A clickable HTML version is at [summary-rh/index.html](index.html).

This is a structured harvest of `/Users/victor/workspace/rh`, the programme that asks:

> **Can the greedy harmonic sine solve the parity problem for the twin prime conjecture?**

The repository’s own verdict, stated first: **no — not by this programme as it stands.** It documents the precise reasons, the barriers, the numerical evidence, and the one clean new theorem the programme produced: the **finite-prefix indeterminacy theorem** for the two-point Liouville correlation. Nothing here solves, or claims to solve, the twin prime conjecture, the parity problem, Chowla’s conjecture, Sarnak’s conjecture, or the Riemann hypothesis.

## Start here

| If you want to… | Read |
|---|---|
| See the audited list of proved results | [01 — Ledger](01-ledger/README.md) |
| Read a published paper’s statements | [02 — Published papers](02-published-papers/README.md) |
| See what is open | [03 — Open problems](03-open-problems/README.md) |
| Understand the verdict and the barriers | [04 — Programme](04-programme/README.md) |
| Check the Lean/sorry/axiom status | [05 — Lean verification](05-lean-verification/README.md) |
| Trace the rounds and journal | [06 — Archive](06-archive/README.md) |
| Look up a symbol | [GLOSSARY.md](GLOSSARY.md) |
| See every file | [TABLE-OF-CONTENTS.md](TABLE-OF-CONTENTS.md) |

## The corpus in five paragraphs

**1. The ledger is the authority.** [`research/truths.md`](../rh/research/truths.md) is a 13-section, 140-row ledger of what has been established, with the Lean proof or the paper/verification status for each result. It is the canonical layer; the 15 published papers are expositions, and the 40+ round folders are provenance.

**2. The papers.** `research/publish/001–015` contains 15 papers. This summary harvests every bold theorem-like block: **147 statements** across the papers, including definitions, propositions, corollaries, conjectures and hypotheses. 001/011 are duplicate editions; 007/014 are the same theorem, with 014 the fuller edition.

**3. The programme.** The twin-prime-parity programme (rh40–rh47) produced a proved factor-complexity law for the greedy word, exact budgets and Brown reachability, a parity lock, the balance identity, the sharp partial-sum error at a zero, the proof that smoothing cannot remove `√N`, the corrected explicit formula, the finite-prefix theorem, and the Sylvester-sparsity theorem. Its five bridges from the greedy sine to the parity problem are all refuted or disposed of; the precise missing ingredient is a sign-blind rule with a positive-density multiplicative coupling to `Ω`.

**4. The open layer.** The register has 19 items: **10 settled**, **1 impossible-as-inherited** (OP-3, replaced by OP-19), **1 refuted as stated** (OP-8), **7 open** (OP-1, OP-4, OP-9, OP-16, OP-17, OP-18, OP-19). The 36 finer-grained harvested items include 11 heuristics. The headline open target is un-averaged two-point Chowla, `Σ_{n≤x}λ(n)λ(n+2)=o(x)`.

**5. The verification.** The Lean corpus is **`sorry`-free** and has **no `axiom` declaration**. The last `sorry` was discharged by repairing its hypothesis and proving it. `Op56` is axiom-clean; `Rh41` has eight `native_decide` theorems. `CERTIFIED` finite windows (`T=15`, `T=33`) are not RH.

## The folders

| Folder | Contents | Documents |
|---|---|---|
| [00 — Scope and method](00-scope-and-method/README.md) · [TOC](00-scope-and-method/TOC.md) | What was harvested, what was excluded, status vocabulary. | 5 |
| [01 — Ledger](01-ledger/README.md) · [TOC](01-ledger/TOC.md) | 13 sections, 140 named result rows. | 15 |
| [02 — Published papers](02-published-papers/README.md) · [TOC](02-published-papers/TOC.md) | 15 papers, 147 harvested statements. | 17 |
| [03 — Open problems](03-open-problems/README.md) · [TOC](03-open-problems/TOC.md) | OP-1…OP-19, 36 harvested items, OP-19, major conjectures. | 8 |
| [04 — Programme](04-programme/README.md) · [TOC](04-programme/TOC.md) | Verdict, X1–X6, barrier ledger, shift-2 audit. | 7 |
| [05 — Lean verification](05-lean-verification/README.md) · [TOC](05-lean-verification/TOC.md) | Lean status, taxonomy, errata. | 5 |
| [06 — Archive](06-archive/README.md) · [TOC](06-archive/TOC.md) | Round map, publication map, exclusions. | 5 |

## What is actually proved

The positive ledger P1–P19 in [04 — Barrier ledger](04-programme/04-barrier-ledger.md) is the compact list. In brief:

- the factor-complexity law `p(L) = min(a_m+1, N−L+1) + [L ≤ N−a_m−1]`;
- the budgets `P = 2^{−p}ζ`, `N = (1−2^{−p})ζ−1`, `P+N = ζ−1`, `P−N = 1−η`, `P > N`;
- Brown’s criterion and the completeness thresholds;
- the parity lock and the balance identity;
- the sharp partial-sum error at a zero, `√N/|s−1|`;
- smoothing does **not** remove `√N`;
- the corrected explicit formula with the archimedean term;
- the finite-prefix indeterminacy theorem;
- `f(n)=λ(n)λ(n+2)` is not multiplicative (no Euler product);
- the greedy support is Sylvester-sparse;
- one-point Chowla is equivalent to PNT.

## What is not proved

- RH, the twin prime conjecture, Chowla for `k ≥ 2`, Sarnak, Elliott.
- The two-point Chowla statement `Σλ(n)λ(n+2)=o(x)`.
- The log-indicator barrier OP-19.
- The exact ceiling law for `nmin p` (falsified at a 451-digit `p`).
- The OP-8 term-level split in general (refuted at every certified root, open in general).

## Scope

The source is **2,029** Markdown/HTML/TeX files. The summary harvests the ledger, the 15 papers, the open register and the programme’s narrative; it indexes but does not reprint the 38,751-line research journal, the 18,706-line development log, the 39 `theorems/rh*` folders, and the 39 rendered HTML papers. The exact rule is in [00 — Scope](00-scope-and-method/scope.md).

## Provenance

- [`research/truths.md`](../rh/research/truths.md) — proved-results ledger.
- [`research/publish/`](../rh/research/publish) — 15 papers.
- [`research/open.md`](../rh/research/open.md) — OP register and 36 open items.
- [`research/twin-prime-parity/README.md`](../rh/research/twin-prime-parity/README.md) — verdict and X1–X6.
- [`research/twin-prime-parity/dictionary/05-programme-barriers-and-harvest.md`](../rh/research/twin-prime-parity/dictionary/05-programme-barriers-and-harvest.md) — barrier ledger.
- [`research/shift2-audit/REPORT.md`](../rh/research/shift2-audit/REPORT.md) — MRT correction.
- [`research-journal.md`](../rh/research-journal.md) — indexed, not reprinted.

[Master TOC](TABLE-OF-CONTENTS.md) · [Status ledger](STATUS.md) · [Glossary](GLOSSARY.md)
