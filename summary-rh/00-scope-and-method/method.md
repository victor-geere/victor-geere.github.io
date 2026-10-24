# Method

## Ledger

`research/truths.md` was split by its `##` section headings. Each section kept its table of results, status column, and Lean links. Links were re-pointed from the ledger’s `research/`-relative paths to workspace paths `../rh/...`. The 13 section files preserve the source text; no result row was dropped.

## Papers

Each `manuscript.md` was scanned for lines beginning with `**` and containing a theorem-like keyword in the first 140 characters. A block runs until the next theorem-like block or the next `##`/`###`/`####` heading. The bold heading became the `###` item heading; the remaining source text (statement, proof, remarks) was kept verbatim. This yields 147 statement blocks. The paper abstract and source link were added.

Limitations: the extraction is statement-level, not a semantic decomposition. A proof that follows in an unheaded paragraph is included; a proof that lives only in a linked Lean file is referenced by the source’s own Lean link, not reproduced.

## Open problems

`research/open.md` §§3–5 were copied by section and their links re-pointed. The OP register table, the 36-item tables, and the OP-5/OP-6 resolution are verbatim. OP-19 was written from `research/TODO.md` §A.1 because the register’s OP-3 is not a proposition.

## Programme

The twin-prime-parity README’s one-paragraph summary, round table, three claims, and X1–X6 corrections were extracted. The barrier ledger (P1–P19, B1–B5, N1–N3) was copied from `dictionary/05` with links re-pointed. The shift-2 audit is a summary of `REPORT.md`’s headline and exact identity.

## Verification and archive

The Lean status is a curated table from `truths.md` §1 and `open.md` §2. The errata consolidate the programme’s X1–X6, the OP-5/OP-6 corrections, the register corrections, and the paper-level corrections. The archive map indexes the rounds and journal without reprinting them.

## Status

Status labels are the programme’s own (`PROVED (Lean)`, `PROVED (paper)`, `VERIFIED`, `CHECKED`, `CERTIFIED`, `REFUTED`, `OPEN`, `CONJECTURED`, `SETTLED`, `OUT OF REACH`). Precedence: the ledger’s audited status wins over a paper’s prose; a later correction wins over the earlier round; a refutation with a witness wins over a claim. See [status taxonomy](summary-rh/00-scope-and-method/status-taxonomy.md).

[Back to folder README](summary-rh/00-scope-and-method/README.md) · [Back to the summary index](summary-rh/README.md)
