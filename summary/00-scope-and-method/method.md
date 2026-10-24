# Method

## Extraction

The canonical paper is a single HTML file with consistent theorem environments (`<div class="theorem">`, `lemma`, `corollary`, `proposition`, `definition`, `proof`, `remark`). A Python `HTMLParser` walk recorded each top-level environment with its raw source span, its title, and its enclosing `<h2>` section. The raw fragment was converted to Markdown with Pandoc, with inline and display LaTeX masked before conversion and restored afterwards, so the mathematics is preserved exactly.

Proofs are separate `<div class="proof">` blocks. Each proof was attached to the immediately preceding statement. A statement with no following proof block is marked “no separate proof block”; it is a definition, remark, cited result, or an argument given inline in the surrounding section.

The extraction produced 170 blocks: 104 statements and 66 proofs. The statement count includes definitions, remarks, and open items, not only theorems.

## Curation

The automated output gives faithful text but not judgement. The following were added by hand:

- **Folder taxonomy.** The paper’s own section order is the primary spine; where a section mixes definitions, geometry, and measures, it is split by mathematical role (e.g. §4 into folder 02 for the remainder and folder 03 for the speed/closure geometry).
- **Status.** A default per type (definition/theorem/lemma/…) was overridden for conditional, limitative, or equivalence results. The overrides are visible in the item metadata and explained in [STATUS.md](summary/STATUS.md).
- **Editorial notes.** Added only where the source has a non-obvious status: Corollary 12.3 (conversion, not proof), Theorem 12.6 (vanishing aperture), Corollary C.10 (limitative), Theorem E.7 (Rouché condition), Open item F.4 (open), Identity L (speed bound, not envelope).
- **Link normalisation.** Source links point back to the canonical HTML section (`publication.html#sec4`, `#addc`, etc.); internal references in the body were rewritten from `#ref-…` to the canonical reference anchor. Code spans were converted from raw `<span class="code-link">` to backticks.
- **READMEs and TOCs.** Written from the canonical text, not from the archived summaries. Each folder README states the logical role of its items and the status caveats.

## Truths, tensor, and working notes

- **Truths.** Parsed by `<h2>` section and by the bold numbered headings (`**1.1.**`, `**3.1 (Theorem 4.1).**`). Each section became one file; each truth kept its number. The three corrections from `tensor.md` are recorded in the folder README and in the tensor status ledger.
- **Tensor.** Parsed by bold named-result headings, with the proof text kept in the same block. The defining equation, §8 status ledger, and §9 numerical appendix are separate files.
- **Working notes.** Audited manually against the canonical Lemma 6.3 and changelog. Each note’s claims are tabulated with a status and a “what survives” section. The decisive correction is quoted verbatim.
- **Legacy.** Searched the archive for explicitly labelled `Conjecture`/`Hypothesis` statements, collapsed duplicates, and recorded the exact statement, the named equivalence/reduction, and the programme-level status. Claimed proofs are marked as archived claims, not adopted.

## Verification

- Every generated item file was checked for a title, type, status, source link, and statement body.
- The 104 publication statements were checked against the source list; no environment is unmapped.
- The 90 truths were checked against the fifteen section counts (15+8+4+8+4+3+2+6+5+2+6+7+5+5+10 = 90).
- Links were normalised to workspace-root paths; code spans and HTML entities were cleaned.
- The two working-note claims that conflict with the canonical paper were traced to the exact changelog entries and the correct Lemma 6.3 evaluation.

## Known limitations

- **Paraphrase in READMEs.** The item files are source text; the folder READMEs are curated prose and may compress an argument. The source link is authoritative.
- **Proof completeness.** A proof block is reproduced, not re-verified. Long proofs (e.g. Theorem 9.1) depend on cited lemmas; the folder README names the dependencies.
- **Archive selection.** The legacy folder is a curated index, not a complete reprint. The selection rule is label-based and stated in its README.
- **MathJax rendering.** The Markdown uses `\(...\)` and `\[...\]`. A viewer without MathJax will show the TeX source; that is intentional, so the mathematics is not lost.

[Back to folder README](summary/00-scope-and-method/README.md) · [Back to the summary index](summary/README.md)
