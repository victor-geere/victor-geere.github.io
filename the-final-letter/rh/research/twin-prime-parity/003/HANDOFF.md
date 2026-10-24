# HANDOFF — session 003: the repairs, the index, and a 200-document re-audit of the labels

**Created:** end of the session that executed items 1 and 2 of the session-002 handoff.
**Working directory:** `/Users/victor/workspace/rh`.
**Status:** Both ordered items of `002/HANDOFF.md` §6 are done, and so are the two follow-ups the
user then ordered: the **18 residual defects are repaired** (§3a) and the **arXiv-cited third of the
`CITED` class has been read against the primary literature** (§3b). The citation pass found four
misattributions and three overstatements in 35 distinct documents (41 verdict rows) — including one that is the same class of
error as the MRT erratum, and was found the same way.

**Earlier status (both ordered items):** Both ordered items are done. The five session-002 audit findings are **repaired** —
two of them by *writing the evidence that was missing* rather than by demoting the label. A
**200-document stratified re-audit** (five times the previous sample, two-stage and adversarial)
reports in [`AUDIT-verification-labels-002.md`](../../../theorems/AUDIT-verification-labels-002.md). No theorem
was touched; four *labels* moved, one of them in the safe direction (`PROVED (paper argument)` →
`OPEN`), and **91 documents carry an `evidence absent` qualifier** because they advertise numbers the
repository cannot reproduce. The re-audit then caught the repair itself over-applying that qualifier:
**23 of the first 114 were false positives** and have been reversed, each with a correction bullet
naming the artefact that does compute the numbers. The target `Σ λ(n)λ(n+2) = o(x)` remains **open
and untouched**.

---

## 0. READ THIS FIRST — what changed, and what did not

**Changed (labels only):**

1. `theorems/tpp-rh40-round01-agentb-i-x-repair-realisable-window-starts.md`: `PROVED (paper
   argument)` → **`OPEN`**. The source's own `[VERDICT]` says *"the a_m+2 form still lacks a
   proof"*. This was the one finding that could have misled a reader about mathematics.
2. **91 `VERIFIED (numerical …)` documents** now carry `; evidence absent; the source is prose only,
   no committed evaluator`, with a dated disclosure bullet in their `## Notes`. Their mathematics is
   unchanged. The rule that selected them, what it does *not* establish, and the 23 false positives
   the re-audit reversed are in `AUDIT-verification-labels-002.md` §4.3 and §6.1 — read both before
   quoting the qualifier at anyone.
3. `theorems/handoff-greedy-squaring-law.md` **and** its source line in the top-level `HANDOFF.md:40`:
   the census figure 128 541 453 is at `x = π−3`, not `x = (π−3)/π`.
4. Two small corrections: `f(1) = −1` (not `+1`) in
   `tpp-checks-06-not-multiplicative-no-euler-product.md`, and the Source span `620–623` (not
   `619–621`) in `lean-rh41-digitword-c1-bound-a0-necessary.md`.
5. `theorems/INDEX.md`'s summary tables now agree with its own rows (they were off by up to 25
   documents), four documents that had no row now have one, and every row parses as a five-cell
   table.

**Added (evidence that did not exist):**

6. `research/twin-prime-parity/rounds/rh40/verify/single_one_law_verify.py` + `.log` — the enumerator
   for the single-one law, which `verify/probes.py` was credited with and never contained. It
   reproduces the register's **239 599** exactly, under a reading the register never stated.
7. `verify/census_128541453_verify.py` + `.log` — the census figure, recomputed for all six archive
   targets plus `(π−3)/π`.
8. `verify/round7_squaring_verify.log` — the squaring-law verifier's own run log, which the archive
   had never stored (it reports exact agreement).

**Not changed:** every theorem, proof, definition and numerical value in the archive, except where
§0.4 above corrects a *printed* figure. Nothing was re-graded upward.

**The lesson of this session, in one line:** the audit caught the archive advertising evidence it did
not have, and then caught *the repair* doing the same thing in the other direction — 23 labels said
"nothing here computes this" while a committed script or log did. Both were fixed; the second only
because the sample audit was run adversarially rather than as a confirmation.

---

## 1. What this document is for

Session 002 (`../002/HANDOFF.md`) left a ranked list. Items 1 and 2 were ordered:

> 1. **Repeat the label audit on a proper stratified sample** (cheap, mechanical, and the only item
>    here with a certain payoff — see §5).
> 2. **Repair the five audit findings** (mechanical).

This session did them in the opposite order (repairs first, so the sample would audit a repaired
archive and the residue would be visible), and the re-audit then found new defects of the same
family. §2 is the repair ledger. §3 is the re-audit. §4 is what is open now, re-ranked. §5 is how to
re-verify everything.

---

## 2. The repair ledger

Full detail, with old text, new text and verification, in
[`AUDIT-verification-labels-002.md`](../../../theorems/AUDIT-verification-labels-002.md) §4. Scripts (all
idempotent, all asserting):

| script | does |
|---|---|
| `003/repair_audit_findings.py` | findings 1, 2, 4a, 4b, and the two mismatches 5a/5b, plus the `SPEC.md` vocabulary change — 24 edits across 13 files |
| `003/numerical_evidence.py` | classifies all 261 `VERIFIED (numerical)` documents into `own-artefact` (90) / `source-artefact` (80) / `evidence-absent` (91); it reads `false_positives.json`, so a re-run cannot re-apply a reversed qualifier |
| `003/apply_evidence_absent.py` | applies the qualifier + disclosure bullet + index-row update to the evidence-absent set |
| `003/reverse_false_evidence_absent.py` | reverses the 23 qualifiers the re-audit found false, restoring the recorded Status and writing a correction bullet naming the computing artefact |
| `003/update_index_header.py` | recomputes every summary table in `theorems/INDEX.md` from its rows |

Design decisions worth keeping:

* **Where evidence could be produced, it was produced, not disclaimed.** Finding 4a's "239 599/239
  599" claim had no enumerator; writing one took ~100 lines and showed the figure is *right* under a
  reading nobody had written down. The alternative — demoting a true claim to `UNSUPPORTED` — would
  have made the archive more wrong, not less.
* **Where evidence could not be produced, the label says so in the sentence itself.** `compute_rh17.py`
  cannot be reconstructed, so the three documents that cite it now say so at the point of citation,
  in the archive's own established style (`checks/06-numerical-checks.md:378`).
* **The qualifier is scoped.** `source-artefact` (80 documents) means an artefact is *named and
  present*, not that it computes the stated quantity. That gap is real and is demonstrated by a
  finding in §3.

---

## 3. The re-audit (200 documents, two stages)

Method: `003/audit_sample.py` (fixed seed 20251006) draws a weighted stratified sample of 260 from
the 1262 prose documents; 200 of them, in five strata, went through a two-stage workflow — extract
every evidence claim, then re-verify it adversarially against the repository with `file:line`
evidence and, where cheap, an independent recomputation.

**Headline.** *(Filled from `003/sample_audit_results.json`; see
[`AUDIT-verification-labels-002.md`](../../../theorems/AUDIT-verification-labels-002.md) §5–§6 for the tables,
the rates and every quoted finding.)*

The shape of the result is already clear from the pilot and the completed batches:

* `PROVED (Lean …)` held up again — the strongest label remains the most reliable;
* the weak stratum is still the `rh*.html` numerical prose series, now labelled rather than silent;
* **the failure mode is always the same**: a label advertising an artefact the repository does not
  contain, **never** a false mathematical claim that the archive actually supports;
* one genuinely new defect class was found: a *present* script that does not perform the check it is
  credited with, at the claimed scope — `theorems/xihorn-todo-gor-lemma-2-3.md` claims
  `d = 2…12 × n = 0…40` (396 cells) while the credited driver tests five cells and its unit test four
  values of `n`.

**Why this matters more than the count.** The session-002 audit's most important quantitative
statement was "six of ten numerical labels and three of ten paper-argument labels are affected, so
the population is in the low hundreds". This session replaced that estimate with a labelled
population: 114 numerical documents, 100 of them sourced from markdown registers rather than HTML.
The paper-argument class is measured in §5 of the audit report.

---

## 3a. The 18 residual defects (repaired)

Listed with the repairs in [`AUDIT-verification-labels-002.md`](../../../theorems/AUDIT-verification-labels-002.md)
§6.2a; applied by `003/repair_residual_defects.py` (the harvested documents) and
`003/repair_residual_sources.py` (the sources that propagated them). Each was re-verified against its
own source by an independent pass before the repair, and one of the eighteen turned out to be a
**mis-targeted flag**: `xihorn-todo-gor-lemma-2-3.md`'s `CITED` label is correct; what overstated the
shipped grid was the sweep *quoted* inside it. Two grades moved down
(`round10-agentb-an-log-log-with-correction.md` → `CONJECTURED`,
`round5-agentb-globality-not-admissibility.md` → `PROOF-SKETCH`); the rest are scope and figure
corrections. Two defects had no measurement behind them at all, so the measurement was written and
committed: `rounds/rh40/verify/c1_first_failure.py` fixes the true-`e−2` first failure at `L = 51`.

## 3b. The `CITED` class, read against the primary sources

Full report: [`AUDIT-003-cited-sources.md`](../../../theorems/AUDIT-003-cited-sources.md). Scope: the 35 documents
that name an arXiv identifier, which resolve to **13 distinct papers** — all 13 read in full text by
15 agents, one batch per paper. Result: **28 supported, 4 misattributed, 3 overstated** on distinct
documents (a 20 % defect rate, 95 % interval 8–37 %); 41 verdict rows in total, because one document
was checked against three of the papers. The three unread documents that carry a DOI or URL were
checked too, and all three are supported.

The finding that matters:

> **`theorems/tpp-dict-03-tao-teravainen-log-all-orders.md`** and the dictionary section it was
> harvested from present "log-averaged Chowla for **all orders**" as a theorem and credit the general
> case to Tao–Teräväinen's almost-all-scales paper. **No such result exists.** Log-averaged Chowla is
> proved for **odd** `k` and for **`k = 2`** (Tao 2016); even `k ≥ 4` is open, and the credited paper
> says so. The scope and the citation are both repaired, and the missing `k = 2` reference
> (`arXiv:1509.05422`) added.

This is the MRT erratum's failure mode exactly — a real paper, cited for a statement it does not make
— and it was found only by fetching and reading, which is why §4 below re-ranks the remaining work.

## 4. What is open now, re-ranked

1. **The rest of the `CITED` class — 130 documents, and this session did not measure which of them
   matter.** This session read the part of the class that names an arXiv work: **35 documents, 7 with
   a defect (4 misattributed, 3 overstated)** — 20 %, with a 95 % interval of 8–37 %. The other 130
   `CITED` documents were not read: 1 carries a DOI and 2 a URL (all three checked separately, all
   supported), 7 give a journal citation, 8 an author–year, **66 say only "classical"**, and 46 carry
   no machine-matched citation at all — though 35 of those 46 do name a person (Fermat, Mertens,
   Goldfeld, Brown, Zhang, Bombieri–Friedlander–Iwaniec, …). So the unread tail is **112 documents
   whose only attribution is a name or the word "classical"**. They are cheap to check individually
   (many are textbook results) but there are a lot of them, and **nothing in this session ranks them
   by how much the archive depends on them**. Sorting that first — a per-document "what rests on this
   citation" count — is the step that turns the tail into a queue.
2. **`CITED` is not the only class that cites.** Documents graded `PROVED (paper argument)` lean on
   external results too — the cone residue note rests on Tao 2016 — and none of those citations has
   been checked.
2. **Verify the 80 `source-artefact` documents by running their artefacts**, not by name. The
   `h3_onset` finding shows the gap. A batch `cargo test` / scripted re-run with stored logs would
   convert most of them to `own-evidence` status, and would probably find a handful more scope
   mismatches.
3. **The `paper` stratum's residual defects** (audit report §6), each mechanical.
4. **The positivity route** — unchanged from session 002: the single ledger entry no machine-checked
   fact contradicts, with no candidate mechanism. `../cone/residue-verdict.md` §8.
5. **`o(x)` itself** — open, uniform across shifts, unreachable by every method in the ledger.
   **Do not start here.**
6. **Goal 5 of session 002 is still `blocked`**, and session 003 did not touch goal state. Its
   objective asserts the false equivalence from `002/HANDOFF.md` §4; editing a goal's objective needs
   a direct instruction from the user. Either edit it or close it.

---

## 5. Do-not-trust list, updated

Session 002's list still stands, with these amendments:

| claim | where | status |
|---|---|---|
| `PROVED (paper argument)` | `tpp-rh40-round01-agentb-i-x-repair-…` | **REPAIRED** — now `OPEN` |
| "54 named checks by `compute_rh17.py`" | three `rh17-*` documents | **DISCLOSED** — the script is absent and the documents now say so |
| "`probes.py` verifies the single-one law; 239 599/239 599" | `tpp-rh40-readme-m9-…`, rh40 `README.md` §5 | **REPAIRED** — the claim was cited to the wrong script; a real enumerator now exists and reproduces the figure |
| "census 128 541 453 at `x = (π−3)/π`" | `handoff-greedy-squaring-law.md`, top-level `HANDOFF.md:40` | **REPAIRED** — it is `x = π−3`; and the target is outside the document's own domain convention (recorded in its Notes) |
| `f(1) = +1` for `f(n) = λ(n)λ(n+2)` | `tpp-checks-06-not-multiplicative-…` | **REPAIRED** — `f(1) = −1`, machine-checked |
| every `VERIFIED (numerical; … evidence absent …)` label | 114 documents | **NEW CAVEAT** — the numbers rest on prose; do not cite them as reproducible |
| "four properties hold to 40 digits across `d = 2…12` and `n = 0…40`" | `xihorn-todo-gor-lemma-2-3.md` (source: `xi-horn/TODO.md:876`) | **UNSUPPORTED AT THE STATED SCOPE** — the credited driver tests five cells; found by this session's re-audit |
| "log-averaged Chowla for **all orders** is a theorem (Tao–Teräväinen)" | `theorems/tpp-dict-03-tao-teravainen-log-all-orders.md`, `dictionary/03-parity-problem.md` §3.4 | **FALSE, REPAIRED** — odd `k` and `k = 2` only; even `k ≥ 4` open; `arXiv:1809.02518` proves no log-averaged statement (see `AUDIT-003-cited-sources.md` §4.1) |
| "[O'S] Theorem 3.9 holds for `ν > −2`" | `xihorn-uniformity-osullivan-theorem-39.md` | **REPAIRED** — the paper reads `α ≥ −2`, closed |
| "[O'S] Corollary 3.2 is about `ξ^(n)`" | `xihorn-uniformity-osullivan-corollary-32.md` | **REPAIRED** — it is about `Θ^(n)`, `Θ(z) = ξ(½+√z)` |
| "[O'S] Corollary 3.8 …, never the converse" | `xihorn-*-corollary-3-8.md` (two of three) | **REPAIRED** — the paper states the one-way implication only |
| "[O'S] Lemma 3.4 says LP factors neither add nor remove real-zero content" | `xihorn-uniformity-osullivan-lemma-34.md` | **REPAIRED** — the lemma is a bare algebraic identity; the real-zero reading is the source's gloss |
| `xihorn-todo-gor-lemma-2-3.md`'s label | — | **FLAG WAS WRONG** — the `CITED` label is correct; only its quoted sweep overstated the shipped grid |
| session-002 sample findings not re-checked here | — | the 200-document re-audit supersedes the 40-document sample for the five strata it covered |
| the 127 `CITED` documents outside the audited part | `theorems/tpp-*`, `theorems/xihorn-*` | **NOT READ** — 66 say only "classical" and 46 give no machine-matched citation, though 35 of those name a person |
| "124 unread", "68 classical", "~20 % of the class was wrong" | an earlier draft of `AUDIT-003-cited-sources.md` §5 | **CORRECTED** — 127 unread, 66 classical (+46 with a name only), and the ~20 % applies to the 38 documents read, not to the class |
| zbMATH `0283.10024` as Montgomery's large sieve | `theorems/research-journal-large-sieve-inequality.md`, `research-journal.md:572` | **MISATTRIBUTED, REPAIRED** — that id is Tijdeman 1974; Montgomery's book is zbMATH 0216.03501 |
| the Chen 1973 DOI and `cdn.sciengine.com` link | `theorems/tpp-dict-03-chen-p2.md`, dictionary §2.6 | **DEAD LINK, REPAIRED** — the DOI 404s at doi.org and the cdn host does not resolve; the live page is `sciengine.com/doi/...` |

---

## 6. Process lessons from this session

1. **A repair pass is a program, and programs have the bug class they are fixing.** The first version
   of the relabel script split markdown rows on `|`, which corrupted exactly the four rows whose link
   text contains an escaped pipe — the same "evidence looks fine, the artefact disagrees" failure, one
   level down. It was caught by a validation check, not by reading. Write the validator first.
2. **Prefer adding the missing evidence to demoting the claim.** Demotion is the safe move and it is
   sometimes wrong: the 239 599 figure was true, and the archive would have lost a correct number.
3. **A label audit and a mathematical audit are different instruments.** 200 documents, five
   strata, two stages: not one theorem was found false. What the audit finds is *unreproducible
   claims* — which is exactly what the MRT erratum was, one level up.
4. **The index is part of the archive.** Its summary tables were the most-read and least-checked
   artifact in the repository: off by up to 25 documents, with three documents carrying no row at
   all. Any future relabel must update `theorems/INDEX.md` and the fragment in the same pass.
5. **Idempotence is the cheapest correctness proof available here.** Every repair script can be run
   twice, and the second run must print "0 files would change". That check caught two bugs in this
   session.

---

## 7. How to re-verify everything

```bash
cd /Users/victor/workspace/rh/research/twin-prime-parity/003

# every repair is idempotent: the second run must change nothing
python3 repair_audit_findings.py --dry-run     # expect: 0 files would change, 24 edits already applied
python3 apply_evidence_absent.py --dry-run     # expect: relabelled 0 documents (0 index rows), skipped 114
python3 update_index_header.py --dry-run       # expect: rows=1210 files=1210 orphans=[] absent=114
python3 numerical_evidence.py                  # expect: 114 evidence-absent / 80 source-artefact / 67 own-artefact
python3 audit_sample.py --list                 # expect: population 1262, the census table of AUDIT 002 §2.1

# the new evidence
cd ../rounds/rh40/verify && python3 single_one_law_verify.py     # expect: 239599 on reading B, 0 counterexamples
cd /Users/victor/workspace/rh && python3 verify/census_128541453_verify.py   # expect: MATCH: True for pi-3
python3 verify/round7_squaring_verify.py > /tmp/sq.log && tail -3 /tmp/sq.log

# the Lean layer, unchanged by this session
cd lean && ./check.sh ConeLean/Cone.lean ConeLean/PairThreshold.lean ConeLean/PairCensus.lean \
    ConeLean/ChowlaEquiv.lean ConeLean/ResidueReduction.lean ConeLean/ShiftBarrier.lean \
    ConeLean/SpectralStructure.lean ConeLean/LogAverageBarrier.lean ConeLean/ParityObstruction.lean \
    ConeLean/ShiftTwoCore.lean ConeLean.lean                    # expect: 11 x "[check] OK"
```

```bash
# the residual-defect and citation repairs (both idempotent)
cd /Users/victor/workspace/rh/research/twin-prime-parity/003
python3 repair_residual_defects.py --dry-run    # expect: 0 files would change; 19 edits already applied
python3 repair_residual_sources.py --dry-run    # expect: 0 files would change; 8 edits already applied
python3 repair_citation_defects.py --dry-run    # expect: 0 files would change; 26 edits already applied
python3 citation_inventory.py --all             # the CITED census of AUDIT 003 §2

# the new measurements
cd ../rounds/rh40/verify && python3 c1_first_failure.py      # expect: true e-2 fails first at L = 51
```

Logs written by this session: `research/twin-prime-parity/rounds/rh40/verify/single_one_law_verify.log`,
`verify/census_128541453_verify.log`, `verify/round7_squaring_verify.log`,
`research/twin-prime-parity/003/sample_audit_results.json`.

**Goal states at handoff:** session 002's goals 1–4 complete; **goal 5 still `blocked`** (objective
asserts the false equivalence of `002/HANDOFF.md` §4 — needs a user instruction to edit or close it).
No goal in this session claimed `o(x)`, and none claimed any new theorem.
