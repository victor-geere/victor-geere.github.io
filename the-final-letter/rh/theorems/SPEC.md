# Harvest spec — one Markdown file per theorem

This folder is a *harvest* of the theorems stated anywhere in the research
workspace `/Users/victor/workspace/rh`. Each theorem gets its own `.md` file.
Nothing here is new mathematics: every statement is copied, faithfully, from a
source file in the workspace, and every file links back to that source.

## What counts as a theorem

Harvest a result when the source **states it as a result**, i.e. one of:

* a named/labelled declaration — `**Theorem 1 (sign).**`, `### Lemma 2 (...)`,
  `> **Corollary.**`, `**THEOREM**` status rows in a ledger table,
  `T3 (the equation)`, `L1 — the tail ...`, `<div class="box thm">` blocks,
  a Lean `theorem`/`lemma` whose statement carries real mathematical content;
* a numbered/lettered proposition, corollary, claim or explicitly labelled result.

Do **not** harvest:

* prose that merely mentions a theorem ("by the identity theorem", "this is a
  theorem, not a measurement", "Hodge index theorem") unless the file also
  *states* that theorem as a result of this workspace;
* definitions, conjectures, open problems, TODO items — **unless** the source
  labels them as a theorem/lemma/proposition/corollary/claim. A statement that
  is conjectural should still be harvested if it is presented as a labelled
  result, but its **Status** must say so (e.g. `CONJECTURED`, `OPEN`);
* trivial Lean plumbing (`simp` facts, `_zero`, `_one`, arithmetic
  normalisations, `#check` lines, `example`s).

When in doubt, include it and mark the status honestly — coverage matters more
than pruning, but the status must never overstate.

## Status vocabulary (use exactly one primary term)

`PROVED (Lean)` · `PROVED (paper argument)` · `VERIFIED (numerical)` ·
`CHECKED (exhaustive finite)` · `CITED (literature)` · `CONJECTURED` ·
`REFUTED` · `OPEN`

**Required qualifier when the evidence is not in the repository.** A label that
names a script, log or sweep must be qualified `evidence absent` when that
artefact is not committed here — e.g.

    VERIFIED (numerical; source's script not in repository — evidence absent)

This is the session-003 audit's grade 3. It is *not* a demotion of the
mathematics: the claim may be perfectly true, and the qualifier records only that
the repository cannot reproduce it. The model is the archive's own disclosure in
`research/twin-prime-parity/checks/06-numerical-checks.md:378` that
`explicit_formula.log` "DOES NOT EXIST". Never write `evidence absent` about an
artefact that *is* in the tree — that is the same failure in the other direction.

Add a short qualifier in parentheses when the source gives one, e.g.
`PROVED (Lean, no sorry)` or `VERIFIED (numerical, 40 digits)`.

## File naming

`<prefix>-<slug>.md` — lowercase ASCII `[a-z0-9-]`, no spaces, no unicode.

* `<prefix>` is assigned per source file by the task (see the task list); never
  invent one.
* `<slug>` is a short kebab-case condensation of the theorem's own title or,
  failing that, of its content (3–8 words max).
* If two theorems in the same source would collide, append `-2`, `-3`, …
* **Never overwrite a file you did not create** in this task; if the name is
  taken, add a suffix.

## Required file template

    # <Title as stated in the source>

    **Kind:** Theorem | Lemma | Proposition | Corollary | Claim
    **Status:** <one term from the vocabulary, with qualifier>
    **Area:** <rh-html | xi-horn | twin-prime-parity | workspace>
    **Source:** [`<relative path from workspace root>`](<relative link from theorems/>) — <section / line anchor if known>

    ## Statement

    > <the statement, verbatim or near-verbatim, with all mathematics preserved>

    Additional prose of the statement continues here if a blockquote is awkward.

    ## Hypotheses and notation

    - <every hypothesis, quantifier and non-standard symbol the statement needs>

    ## Proof / evidence

    <how the source establishes it: proof sketch, Lean file + declaration name,
    numerical certificate and precision, exhaustive check, citation.>

    ## Dependencies and related results

    - <named results it uses; other harvested theorems it cites, linked if the
      file exists>

    ## Notes

    <caveats, corrections, the source's own hedging, anything a reader must not
    misread. Say plainly if the source flags the result as conditional,
    numerical-only, or as a correction of an earlier claim.>

## Index fragment

For every source file you process, also write `theorems/.index/<prefix>.md`
containing exactly one Markdown table, one row per harvested theorem:

    | Theorem | Kind | Status | Source | Summary |
    |---|---|---|---|---|
    | [Title](file.md) | Theorem | PROVED (Lean) | [rh42 truths](../research/.../truths.md) | one line, ≤ 120 chars |

The fragment must be *only* that table (no heading, no commentary) so that all
fragments can be concatenated into `theorems/INDEX.md`.

## Fidelity rules

1. **Do not improve the mathematics.** Keep the source's own notation,
   including unicode (`λ`, `ρ`, `Σ`, `≥`), `<sub>`/`<sup>` markup, and symbols
   like `ζ`, `ξ`, `𝒲`.
2. **Do not soften or harden.** If the source says a claim is conditional on
   IEEE-754, say so. If a source contradicts an earlier round, say so in Notes.
3. **Quote numbers exactly** (`5.45×10⁻¹¹`, not `~5e-11`).
4. **Never invent a proof or a citation.** If the source gives none, write
   "the source states this without proof" in Proof / evidence.
5. Every statement must be traceable: the Source line and the index row both
   name the file it came from.
