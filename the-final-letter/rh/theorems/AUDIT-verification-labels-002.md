# AUDIT 002 — the label audit repeated, and the five findings repaired

*Session 003. Read-only with respect to mathematics: **no theorem, proof, status grade or numerical
claim was changed except where this report says so, and never in the direction of "more proved".**
Every edit is an edit to a *label*, and every edit is logged in §4 with the file, the old text and
the new text.*

Companion documents: [`AUDIT-verification-labels.md`](AUDIT-verification-labels.md) (session 002,
the audit this one repeats and repairs), [`research/twin-prime-parity/002/HANDOFF.md`](../research/twin-prime-parity/002/HANDOFF.md)
(the session-002 handoff that ordered the work), [`theorems/SPEC.md`](SPEC.md) (the label
vocabulary, now extended in §4.3).

---

## 1. What was asked, and what was done

The session-002 handoff, §6, ranked two items first:

> 1. **Repeat the label audit on a proper stratified sample** (cheap, mechanical, and the only item
>    here with a certain payoff — see §5).
> 2. **Repair the five audit findings** (mechanical).

Both are done, and doing them turned up three further defects of the same kind (a label advertising
evidence that is not in the repository), plus a structural defect in the index itself.

| item | outcome |
|---|---|
| the five audit findings | **all five repaired**, two of them by *adding the missing evidence* rather than by demoting the label — see §4 |
| the two "outright mismatches" (audit items 4) | **both repaired**, with a new enumerator and a reproduced census figure — see §4.5–§4.6 |
| repeated label audit | 200 documents (not 40), stratified, **two-stage with an adversarial second pass**; results in §5 |
| new: `evidence absent` grade | added to the vocabulary, applied to 114 documents, then **23 of those reversed** by the re-audit that checked them — see §4.3 and §6.1 |
| new: the index was not what it claimed | the summary tables disagreed with the index's own rows, one row was unparseable and three documents had no row at all — see §4.7 |
| new: the 18 residual defects | **all eighteen repaired**, each re-verified against its own source first; one flag was mis-targeted (the label was right, the quotation was not) — see §6.2a |
| new: the `CITED` class | the arXiv-cited part of it read against the primary literature: **35 distinct documents** (41 verdict rows), 13 papers, **4 misattributed, 3 overstated, 28 supported** — a 20 % defect rate (8–37 %). 130 `CITED` documents remain unread — see [`AUDIT-003-cited-sources.md`](AUDIT-003-cited-sources.md) |

**The one-line result.** The label system survives a five-times larger sample with the same shape of
failure and none of the catastrophes: `PROVED (Lean …)` held up again (19/20), the weak stratum is
still the `rh*.html` numerical prose (55 % affected), and the dominant failure mode is still *a label
that advertises an artefact the repository does not contain*. **No false mathematical claim that the
archive actually supports was found in 190 documents.** The five findings are repaired; the affected
population is now labelled rather than silent — and the repair's own mirror-image error (23 labels
saying "nothing here computes this" while a committed artefact did) was caught by the sample and
reversed.

---

## 2. Method

### 2.1 The population, counted exactly

`research/twin-prime-parity/003/audit_sample.py` walks `theorems/**` and `research/**`, reads each
document's `**Status:**` header line and reduces it to a primary grade. The census, which the
session-002 audit could only estimate from a 40-document sample:

| grade | documents |
|---|---|
| `PROVED (paper argument)` | 336 |
| `VERIFIED (numerical)` | 261 |
| `PROVED (Lean)` | 200 |
| `CITED` | 165 |
| `REFUTED` | 135 |
| `PROVED (other)` | 18 |
| `CHECKED (exhaustive finite)` | 19 |
| `CONJECTURED` | 15 |
| `OPEN` | 32 |
| `PROOF-SKETCH` | 9 |
| `VERIFIED (other)` | 20 |
| no Status line in the first 60 lines | 41 |
| neither a vocabulary term nor a header | 10 |
| **total** | **1262** |

(Counted after the repairs of §4, which is why `PROVED (paper argument)` reads 336 and `OPEN` 32: the
rh40 document of finding 1 moved between them. Before the repair the same census reads 337 and 31.)

Of the 261 `VERIFIED (numerical)` documents, **217 have an `.html` page as their Source** — the
stratum the session-002 audit named as weak.

### 2.2 The sample actually used

`audit_sample.py --seed 20251006` draws a fixed-seed stratified sample with inverse-probability
weights, heavier on the strata the first audit found weak:

| stratum | population | sampled | weight |
|---|---|---|---|
| `VERIFIED (numerical)`, non-HTML source | 180 | 60 | 3.0 |
| `VERIFIED (numerical)`, HTML source | 81 | 40 | 2.03 |
| `PROVED (paper argument)` | 337 | 60 | 5.62 |
| `PROVED (Lean)` | 200 | 20 | 10.0 |
| `CITED` | 165 | 20 | 8.25 |
| **audited total** | 963 | **200** | |

The remaining strata (`CHECKED`, `REFUTED`, `other`) were sampled in the draw (260 documents total,
`sample.json`) but not put through the audit workflow, because the session-002 audit found no
defects in them and the marginal information is low. That is a stated limit, not an accident: the
rate estimates in §5 are for the five audited strata only.

### 2.3 The audit itself

200 documents went through a two-stage workflow (`batch_NN.json`, 20 batches of 10):

* **stage 1 — extract**: enumerate every load-bearing evidence claim in the document, and the
  artefact that would have to exist to support it;
* **stage 2 — verify adversarially**: an independent agent re-does the repository lookup itself,
  corrects the extraction, may recompute numbers, and returns a per-document verdict with
  `file:line` evidence: `SUPPORTED` / `UNSUPPORTED` / `MISMATCH` / `UNVERIFIABLE`.

The second stage is not a rubber stamp: it caught extraction errors and, in at least one case
(`xihorn-todo-gor-lemma-2-3`), found a defect the first stage had passed by *reading the code the
label credits* and comparing its loop bounds with the claimed sweep. Raw output:
`sample_audit_results.json` and `sample_audit.tsv`.

---

## 3. What the session-002 audit had found

For reference, the five findings as numbered in `002/HANDOFF.md` §5, with the repair each needed:

1. `theorems/tpp-rh40-round01-agentb-i-x-repair-realisable-window-starts.md` carried
   `PROVED (paper argument)` while its own source marks the passage `[CHARITABLE]` and its `[VERDICT]`
   says *"the a_m+2 form still lacks a proof"* → **demote**.
2. `compute_rh17.py`, cited by three documents as producing "54 named checks", exists nowhere →
   **commit it or disclose its absence**.
3. `VERIFIED (numerical)` held up only 4/10, the weak stratum being the `rh*.html` prose series →
   **add a grade and re-label**.
4. Two outright mismatches, both verified by hand: the `verify/probes.py` / "239 599" credit in
   `tpp-rh40-readme-m9-single-one-word-solved.md`, and the census figure 128 541 453 attributed to
   `x = (π−3)/π` in `handoff-greedy-squaring-law.md` → **fix**.
5. Two small errors: `f(1) = +1` for `f(n) = λ(n)λ(n+2)` in
   `tpp-checks-06-not-multiplicative-no-euler-product.md` (it is −1), and an off-by-one Source line
   span in `lean-rh41-digitword-c1-bound-a0-necessary.md` → **fix**.

---

## 4. The repairs, one by one

All repairs are applied by `research/twin-prime-parity/003/repair_audit_findings.py` (idempotent,
asserting: it refuses to run if a target string is not found exactly once) and
`apply_evidence_absent.py` for finding 3. Re-running either is a no-op.

### 4.1 Finding 1 — the rh40 document is now `OPEN`

**File:** `theorems/tpp-rh40-round01-agentb-i-x-repair-realisable-window-starts.md`.

* Status: `PROVED (paper argument; …plateau injectivity… left to [OPEN])` →
  **`OPEN (the source's [VERDICT] reads "the a_m+2 form still lacks a proof" and its [OPEN] requests
  exactly the injectivity proof this statement needs; the passage is marked [CHARITABLE], i.e. a
  charitable restatement, not a proof)`**.
* The Notes bullet that asserted the old label was replaced by a dated correction citing
  `rounds/rh40/rounds/round01_agentB.md:80` and `:84`.
* Index row updated in `theorems/.index/tpp-rh40-round01-agentb.md` and `theorems/INDEX.md`.

This is the one finding that could mislead a reader about mathematics, and it was the only label in
200 sampled documents that a reader could have relied on to believe an unproved statement proved.

### 4.2 Finding 2 — `compute_rh17.py` resolved by disclosure

A search of the whole tree for any `*rh17*` artefact returns the five documents and `rh17.html`,
nothing else; the script was never committed and cannot be reconstructed (its "54 named checks"
include a bit-for-bit rh15 regression whose inputs are not in the tree either). The audit's
second option was therefore taken, in the archive's own exemplary style
(`checks/06-numerical-checks.md:378`, "DOES NOT EXIST"):

* `theorems/rh17-t1-certified-sections.md` — the sentence crediting `compute_rh17.py` now ends
  "**`compute_rh17.py` is not in this repository** … so the 54 named checks, the bit-for-bit
  regression and every constant quoted above are *asserted by the source*, not *reproducible here*".
* `theorems/rh17-t2-exact-sections.md` — same disclosure in one sentence.
* `theorems/rh17-l2-aliasing-bound.md` — the bullet "the constants are interval-evaluated by the
  accompanying script" now says the script is absent and that nothing here reproduces `ρ_D ≤
  4.2×10⁻¹⁸`.
* Index rows in `theorems/.index/rh17.md` and `theorems/INDEX.md` carry `compute_rh17.py` absent.

**The grades were not changed.** `PROVED (paper argument)` and `PROVED (computer-assisted …)` remain
correct descriptions of what the source argues; what changed is that a reader can no longer mistake
the source's assertion for a reproducible certificate.

### 4.3 Finding 3 — the `evidence absent` grade, and 114 documents re-labelled (91 after §6.1)

`theorems/SPEC.md` now requires a qualifier when the evidence a label advertises is not in the
repository:

> `VERIFIED (numerical; source's script not in repository — evidence absent)`
>
> This is not a demotion of the mathematics: the claim may be perfectly true, and the qualifier
> records only that the repository cannot reproduce it. […] Never write `evidence absent` about an
> artefact that *is* in the tree — that is the same failure in the other direction.

**Classification rule** (`numerical_evidence.py`, applied to all 261 `VERIFIED (numerical)`
documents, not just the sample). A document is `evidence-absent` when neither it nor the document its
`Source:` line points at names any computational artefact committed in this repository — where
"artefact" includes a `.py/.rs/.sh/.log/.txt/.csv/.json/.npy` name that resolves in the tree, or a
`cargo run --release --bin <name>` whose driver exists under `xi-horn/rust/src/bin/`.

| class | documents | meaning |
|---|---|---|
| `own-artefact` | 90 | the document itself names a committed evaluator — 23 of them only after the re-audit of §6.1 moved them here |
| `source-artefact` | 80 | the source document names a committed evaluator |
| **`evidence-absent`** | **91** | neither does, and the re-audit found no evaluator elsewhere in the tree either |
| total | 261 | |

**The count moved from 114 to 91** because the re-audit of §6.1 checked all 114 adversarially — *find
a committed artefact that computes these numbers* — and found 23 where one exists. Those 23 are
reversed, and the correction is recorded in the documents themselves (§6.1).

`apply_evidence_absent.py` then, for each of the 114 (each of which it rewrites only while the
qualifier survives §6.1's re-check):

1. rewrote the Status line, preserving every qualifier the harvester had recorded, e.g.
   `VERIFIED (numerical; validated dynamical model)` →
   `VERIFIED (numerical; validated dynamical model; evidence absent; the source is prose only, no committed evaluator)`;
2. inserted one dated disclosure bullet last in `## Notes`, saying exactly what is missing and stating
   that the qualifier is not a claim that the result is wrong;
3. updated the Status cell of the matching row in the document's index fragment **and** in
   `theorems/INDEX.md`, located by the row's link to the document so that the source and summary
   cells are untouched.

**Verified**: 91 documents carry the qualifier in their Status line and 91 index rows carry it too;
a second run of the pass reports "relabelled 0 documents (0 index rows), skipped 91", and the 23
reversals are held in `false_positives.json` so re-running the classifier cannot re-apply them.

**What the rule does *not* establish, stated because it bounds the repair.** `source-artefact` means
an artefact is *named and present*; it does not mean the artefact computes the stated quantity. The
session-002 audit's own worst case — `verify/probes.py`, present but not containing the check it was
credited with — would be classified `own-artefact` by this rule. That is why §4.5 *ran* the check in
question rather than trusting the name, and why the `xihorn-todo-gor-lemma-2-3` defect in §6 is
reported as a new finding rather than repaired here.

### 4.4 Finding 5 (small errors), repaired

* **`f(1) = −1`, not `+1`.** `theorems/tpp-checks-06-not-multiplicative-no-euler-product.md`: the
  Notes bullet that said the definition "gives `f(1) = λ(1)λ(3) = +1`" now says the source's
  displayed `+1` is false for the `f` it defines, machine-checked in this repository as
  `ConeLean.chowlaAF_one : chowlaAF 1 = -1`
  (`lean/ConeLean/ParityObstruction.lean:33`, definition at `:29–31`). The displayed *Statement*
  quotation is left exactly as the source writes it; the correction is the note. The document's
  claim — non-multiplicativity — is unaffected and is separately proved
  (`chowlaAF_not_multiplicative`, `:37`).
* **Source line span.** `theorems/lean-rh41-digitword-c1-bound-a0-necessary.md`: "lines 619–621" →
  "lines 620–623 … (619 is its docstring)". Verified against
  `research/twin-prime-parity/rounds/rh41/lean/Rh41/DigitWord.lean:619–623`.

### 4.5 Audit item 4a — the "239 599" claim now has the enumerator it never had

The claim: `verify/probes.py` reproduces the single-one law, and its first half is "exact on all
`a < 60, N < 120` (239 599/239 599)". **The script contains no such check** (the string `min(L` does
not occur in it) **and no enumerator existed anywhere in the repository.**

Rather than demote the claim, the missing evidence was written, in the shape the archive prefers:
[`research/twin-prime-parity/rounds/rh40/verify/single_one_law_verify.py`](../research/twin-prime-parity/rounds/rh40/verify/single_one_law_verify.py),
with its log `verify/single_one_law_verify.log`. It is independent of `code/digitword.py` and computes
`p(L)` twice by routes that share no code — the offset-tuple definition of record, and explicit
bit-string factors — then compares both against the closed form. It also records a proof of the law
on its stated range.

Result (`single_one_law_verify.log`):

| check | result |
|---|---|
| the two routes agree | 8 206 cases, exactly |
| reading A (`0 ≤ a < 60`, `a < N < 120`, `0 ≤ L ≤ N−a−1`) | **251 990** cases, 0 counterexamples |
| reading B (`1 ≤ a < 60`, `a < N < 120`, `1 ≤ L ≤ N−a−1`) | **239 599** cases, 0 counterexamples → **reproduces the register's figure exactly** |
| combined law, `1 ≤ a < 40`, `N ≥ 2a+4` | 178 425 cases, 0 counterexamples |
| every `(a, N, L)` with no regime restriction | holds except in the degenerate sliver `N < 2a+4`, as the source says |

The 239 599 figure is therefore **not** wrong — it is right under a reading (B) that the register
never stated, and the register's prose ("exact on all `a < 60, N < 120`") reads more naturally as
reading A, which gives 251 990. Both are now printed, with the reading attached.

Updated files: the M9 theorem document (evidence paragraph + note), the rh40 `README.md` §5 bullet
and file map, the regression-test comment in `rounds/rh40/tests/test_complexity.py`, and the two
index rows.

### 4.6 Audit item 4b — the census figure, reproduced and re-attributed

The claim: `A(N) = log₂ log N + O(1)` "verified by direct census to index 128 541 453
(x = (π−3)/π)". The archive's own enumerator (`verify/round7_AN_census.py:38`) lists `pi-3` among its
six targets and no `(π−3)/π` anywhere, and the census journal prints the row `π−3`.

New verifier: [`verify/census_128541453_verify.py`](../verify/census_128541453_verify.py), log
`verify/census_128541453_verify.log`. It recomputes the census for all six archive targets **plus**
`(π−3)/π`, at the same 200 dps, independently of `round7_AN_census.py`:

| target | selections | last index | `log₂log N` | `A − log₂log N` |
|---|---|---|---|---|
| 1/π | 4 | 845 027 | 3.7705 | +0.229 |
| log 2 | 5 | 144 715 219 | 4.2319 | +0.768 |
| √2−1 | 4 | 218 199 | 3.6198 | +0.380 |
| e−2 | 4 | 9 997 | 3.2032 | +0.797 |
| (√5−1)/2 | 4 | 37 984 | 3.3985 | +0.602 |
| **π−3** | **4** | **128 541 453** | 4.2228 | −0.223 |
| (π−3)/π | 3 | 443 367 | 3.7007 | −0.701 |

So the figure is confirmed **for `x = π−3`**, and the printed attribution was wrong. Both the
harvested theorem and its source line in the top-level `HANDOFF.md:40` were corrected.

**A caveat the correction exposes, recorded and not repaired.** The document's own Hypotheses fix the
orbit to `x = θ/π ∈ (0, 1)`, and under that convention `π−3 = 0.14159…` is *outside* the domain while
`(π−3)/π = 0.04507…` is inside it. The 128 541 453 census therefore belongs to a parameter the
document's own domain convention does not admit. The census arithmetic is unaffected (the rule
`n_{k+1} = ⌈1/r_k⌉ − 2` is applied to a positive real either way); what is unsupported is the claim
that this run verifies the stated model at an admissible parameter. This is written into the
document's Notes.

### 4.7 New — the index did not describe itself, and three documents had no row

Found while applying repair 3; mechanical; repaired.

* **The summary tables at the head of `theorems/INDEX.md` disagreed with the index's own rows.**
  Header vs rows: `PROVED` 564 vs 553, `VERIFIED` 316 vs 291, `CITED` 148 vs 160, `REFUTED` 127 vs
  131, `OPEN` 25 vs 28, `CHECKED` 17 vs 19, `CONJECTURED` 13 vs 15; the kind table disagreed too
  (`Claim` 457 vs 458). The header also had no row for the `evidence absent` qualifier.
  `update_index_header.py` now recomputes every table from the rows with a stated counting rule.
* **One row was unparseable and three documents had no row at all**:
  `round1-verdict-agentb-growth-exponent-one-half.md`, `round2-agentb-sum-identity-prefactor.md`
  and `xihorn-positivity-jensen-hyperbolic-to-d5.md` were harvested into files but never into the
  index; `tpp-rh40-rounds-truths-k6i-uniform-x-mean.md` had a fragment row that was never
  concatenated. All four now have rows, and the repaired rows are the ones whose link text contains
  an escaped pipe (`[The growth exponent of \|C + iS\| …]`) — the first version of the relabel script
  corrupted exactly those rows by splitting on `|`; that bug and its 3-row blast radius are recorded
  here rather than hidden, and the script now splices cells with an escape-aware splitter.
* **Index integrity now**: 1210 rows, 1210 theorem documents, 0 orphans, 0 rows pointing at a
  non-existent file, 91 rows carrying the `evidence absent` qualifier (matching the 91 documents),
  every row a five-cell table.

---

## 5. The repeated label audit (200 documents)

*This section is filled from `sample_audit_results.json`, produced by the two-stage workflow described
in §2.3. The headline numbers are in §5.1; the representative findings are in §6.*

### 5.1 Rates by stratum, weighted back to the population

190 of the 200 sampled documents returned a verdict (ten failed in transit; see §5.4).
"Affected" = the verifier judged the Status grade and its qualifier **not** fully supported by what
is in the repository (`label_ok: false`, verdict `UNSUPPORTED` or `MISMATCH`).

| stratum | audited | population | affected | rate | 95 % interval | estimated affected |
|---|---|---|---|---|---|---|
| `PROVED (Lean …)` | 20 | 200 | 1 | 5 % | 1 %–24 % | ≈ 10 |
| `VERIFIED (numerical)`, no HTML source | 60 | 180 | 15 | 25 % | 16 %–37 % | ≈ 45 |
| `VERIFIED (numerical)`, HTML source | 40 | 81 | 22 | **55 %** | 40 %–69 % | ≈ 45 |
| `PROVED (paper argument)` | 50 | 337 | 10 | 20 % | 11 %–33 % | ≈ 67 |
| `CITED (literature)` | 20 | 165 | 0 | 0 % | 0 %–16 % | ≈ 0 |
| **all five strata** | **190** | **963** | **48** | **25 %** | **20 %–32 %** | **≈ 243** |

Verdicts over the 190: `SUPPORTED` 142, `UNSUPPORTED` 30, `MISMATCH` 18.

**30 of the 48 affected documents are ones the repair of §4.3 already labelled** (`evidence absent`);
the remaining **18 are residual defects this audit found and did not repair** — they are listed in
§6.2 with the verifier's minimal fix. A further **23 relabels were themselves false** and are
reversed in §6.1, so the re-audit's total haul is **41 documents where the label needed correcting**
(30 newly declared, 23 newly undeclared, 18 unfinished). That split is the honest measure of the
repair: it converted 30 silent failures into declared ones, over-declared 23, and left 18
unexplained.

### 5.2 Comparison with the session-002 sample

| stratum | session 002 | session 003 | reading |
|---|---|---|---|
| `VERIFIED (numerical)` | 4/10 held up (60 % affected) | 37/100 affected (37 %) | same weak stratum, smaller rate on 10× the sample; the HTML-sourced half is the worst at 55 % |
| `PROVED (paper argument)` | 7/10 held up (30 % affected) | 20 % affected | same direction, smaller rate |
| `PROVED (Lean …)` | 10/10 held up | 19/20 held up | unchanged |
| `CITED` | "sampled OK" | 0/20 affected | unchanged |

The session-002 estimate — "if that rate holds across the 598 documents in those two classes, the
affected population is in the low hundreds" — is confirmed: **114 ± 30** in the two classes
(`num` + `num-html` + `paper`), estimated at 157 here before the relabel, of which 114 are now
labelled and 18 are residual.

### 5.3 What the verifiers actually did

The second stage was not a reading exercise. Across the six batches the verifiers: opened the cited
Lean file and grepped the named declarations; ran `grep -rn` for the quoted numbers across `*.log`,
`*.py`, `*.rs` and `*.txt`; recomputed figures in one-line `python3` calls (one recomputed all
eleven Turán ratios to 9–10 digits, another recomputed a σ-sieve table exactly, a third solved an
asymptotic bound by the driver's own iteration); read `Cargo` driver loop bounds and compared them
with claimed sweeps; and cross-checked the archive's own registers (`truths.md`,
`checks/06-numerical-checks.md`). Their failures to decide are reported as such rather than
smoothed over.

### 5.4 Limits of the sample

* **Ten documents are missing** from the 190 (one batch of ten returned nothing usable). Their
  stratum is `paper`; they are not in the rate table above, which is why that row reads 50, not 60.
* **One stratum was not audited at all** (`CHECKED (exhaustive finite)`, and the `other` classes);
  session 002 found nothing there and this session did not sample it.
* **`CITED` was checked for specificity and internal consistency only**, not against the primary
  literature (§7.4).
* **The verifiers are language models.** Every negative finding in §6.2 is quoted with `file:line`
  evidence so a human can re-check it in minutes; the three most consequential were re-checked by
  the session's own scripts (the numeric cross-search of §6.3).

---

## 6. What the audit found

### 6.1 The 23 documents whose `evidence absent` qualifier was itself false

The relabel rule of §4.3 produced **false positives** on a fifth of the documents it touched: it
looked at the document and its immediate source, and it compared artefact *names* rather than
searching the repository's code and logs for the numbers. **23 of the 114** qualifiers were wrong.
They were reversed, and each document now carries, in place of the disclosure bullet, a correction
bullet naming the artefact that computes its numbers:

| document | committed artefact that computes the numbers |
|---|---|
| `round1-verdict-agentb-growth-exponent-one-half.md` | `research/twin-prime-parity/rounds/rh044/verify/smoothed_zeta.log` |
| `round1-verdict-agentb-moller-squarefree-series.md` | `audit3.py`, `verify/round1_corrected.py` |
| `round1-verdict-agentb-squarefree-density-and-count.md` | `audit3.py`, `verify/round1_corrected.py` |
| `round10-agentb-squaring-law.md` | `verify/round7_squaring_verify.log` |
| `round10-agentb-sum-identity.md` | `verify/bootstrap_verification.py` |
| `round2-agentb-sum-identity-prefactor.md` | `verify/bootstrap_verification.py`, `rounds/rh044/verify/smoothed_zeta.log` |
| `round7-agentb-block-complexity-census.md` | `verify/round7_squaring_verify.log` |
| `round7-agentb-squaring-law-residual.md` | `verify/round7_squaring_verify.log` |
| `tpp-dict-00-bridge-b1-no-parity-signal.md` | `research/twin-prime-parity/rounds/rh47/verify/greedy_parity_probe.log` |
| `tpp-dict-00-bridge-b2-index-parity.md` | `research/twin-prime-parity/rounds/rh47/verify/greedy_parity_probe.log` |
| `tpp-dict-00-four-thresholds.md` | `research/twin-prime-parity/rounds/rh42/verify/helix_zeta_rerun.log` |
| `tpp-dict-00-term-level-split-fails.md` | `research/twin-prime-parity/rounds/rh43/verify/zeta_split.log` |
| `tpp-dict-00-zeros-from-zeta-evaluations.md` | `research/twin-prime-parity/rounds/rh45/verify/independent_check.py`, `research/twin-prime-parity/rounds/rh45/verify/independent_check.log` |
| `tpp-rh044-truths-consequence-1-sqrt-n-growth-universal.md` | `research/twin-prime-parity/rounds/rh044/verify/independent_check.log` |
| `tpp-rh044-truths-consequence-2-smoothing-buys-only-constant.md` | `research/twin-prime-parity/rounds/rh044/verify/independent_check.log` |
| `tpp-rh044-truths-consequence-3-residual-closed-form.md` | `research/twin-prime-parity/rounds/rh044/verify/smoothed_zeta.log` |
| `tpp-rh044-truths-t4-zero-localisation.md` | `research/twin-prime-parity/rounds/rh044/verify/independent_check.log` |
| `tpp-rh044-truths-t5-zero-count.md` | `research/twin-prime-parity/rounds/rh044/verify/independent_check.log` |
| `tpp-rh40-round01-agenta-decay-law-and-plateau-value.md` | `research/twin-prime-parity/rounds/rh40/verify/verify_agentB.output.txt` |
| `xihorn-integers-integer-shells.md` | `xi-horn/rust/src/phi.rs` |
| `xihorn-integers-positive-jensen-discriminants.md` | `xi-horn/rust/src/jensen.rs`, `xi-horn/rust/RESULTS.md` |
| `xihorn-integers-precision-rule-six-terms-float64.md` | `xi-horn/figure.html`, `xi-horn/rust/src/phi.rs` |
| `xihorn-positivity-jensen-hyperbolic-to-d5.md` | `xi-horn/rust/src/jensen.rs`, `xi-horn/rust/RESULTS.md` |

This is the same failure the audit exists to catch — a label that says "nothing here computes this"
when something here does — committed by the repair, in the opposite direction from the original
defect. It is recorded rather than quietly fixed because it is the reason `evidence absent` must be
read as a statement about the *document and its source*, not about the repository as a whole.

Two structural lessons, both cheap to apply next time:

* search **truncated** forms of the numbers (documents quote six figures of thirty-digit log values,
  so an exact-string grep misses them);
* search the **round directories** (`research/twin-prime-parity/rounds/rh40..rh47/verify`) and the
  `xi-horn` Rust corpus explicitly — 19 of the 23 were found only there.

### 6.2 The residual defects (as found — all eighteen repaired in §6.2a)

Eighteen documents whose label is not supported and which the §4.3 relabel did not cover, because
they do name an artefact — a script that exists but does not perform the check it is credited with,
or a printed figure the archive's own sources contradict. In severity order:

| document | verdict | what is wrong | minimal fix |
|---|---|---|---|
| `theorems/tpp-dict-04-attainability-of-balance.md` | MISMATCH | Status and §Proof say the fully proved part is `N = 3, 4` (Lean); the archive's rh43 sources formalise only `N = 3`, and there is no Lean declaration for `N = 4` | restrict the Lean claim to `N = 3` |
| `theorems/xihorn-h-track-h6-omega-search.md` | MISMATCH | Status claims `T` identical at 60/120/240 digits for `d = 100…1400`; the driver compares 60 vs 180 digits at `d = 100/200/400` only | narrow the claim to the driver's actual sweep |
| `theorems/xihorn-todo-gor-lemma-2-3.md` | UNSUPPORTED | source claims four properties "to 40 digits across `d = 2…12` and `n = 0…40`" (396 cells); `xi-horn/rust/src/bin/h3_onset.rs:52` tests five cells, `turan.rs:308` four `n` at `d = 2` | narrow to the tested cells, or widen the driver |
| `theorems/round10-agentb-an-log-log-with-correction.md` | MISMATCH | Status labels the invariant `PROVED`; the source only asserts it and calls the upgrade "the sharpest open problem" | demote to `OPEN`/`CONJECTURED` |
| `theorems/research-journal-growth-law-shared-prefactor.md` | MISMATCH | the shared-prefactor identity is false for the unweighted family (`1/\|1−it\|` = 0.070571, not `1/\|1/2+it\|` = 0.070704) | split the two families |
| `theorems/research-journal-decay-rate-admissibility.md` | MISMATCH | `g(x) = (1+x)^{−2}` is classified "converges slowly" although it decays slower than `e^{−x/2}`, so the prime side diverges | reclassify |
| `theorems/rh37-constraints-and-the-half-turn-floor.md` | MISMATCH | a Statement claim the Status labels `PROVED` is refuted by rh38 §4 in the same repository | qualify or demote |
| `theorems/round5-agentb-globality-not-admissibility.md` | UNSUPPORTED | globality asserted, not derived; the source calls it "essentially a truism" | restate as the source does |
| `theorems/tpp-rh40-ledger-attributed-cassaigne-repair.md` | MISMATCH | credits a mediator script with "all `L` on 5 words"; the script does all `L` for one word and samples ≈405 `L` on the other four | correct the scope |
| `theorems/tpp-rh40-rounds-truths-d3-ceiling-regime.md` | MISMATCH | "every window meets the support" fails at `L = N − a_m − 1` (the terminal window is all-zero) | add the stated hypothesis |
| `theorems/tpp-rh40-rounds-truths-f2-c1-regime-below-next-gap.md` | MISMATCH | the recorded failure witness for true `e−2` is not produced by the credited probe or test | record the correct witness |
| `theorems/tpp-rh40-rounds-truths-f5-which-gap-governs-open.md` | MISMATCH | "`d_2 + 2`" is wrong for true `e−2` (`d_2 + 1 = 51`); no file computes it | correct the figure |
| `theorems/rh24-radius-limit-and-horizon.md` | UNSUPPORTED | "59 named checks" credited to a script that does not exist | add the qualifier |
| `theorems/rh25-certified-floors-v18.md` | UNSUPPORTED | "62 named checks" likewise | add the qualifier |
| `theorems/research-journal-envelope-exponent-law.md` | UNSUPPORTED | "three significant figures" fails for `σ = 0.75` (0.232 vs 0.250, 7.1 %) | correct the qualifier |
| `theorems/tpp-rh42-truths-theorem-3-p-gt-n.md` | UNSUPPORTED | qualifier's verification list ends at `p = 8`; no file computes `P(8)` or `N(8)` | correct the list |
| `theorems/xihorn-horn-helix-adelic-translation-identity-every-fibre.md` | UNSUPPORTED | the numerical clause ("worst relative residual 1.2×10⁻³⁸") has no evaluator | add the qualifier |
| `theorems/xihorn-horn-helix-revisited-closure-ledger.md` | UNSUPPORTED | "verified from 150 zeros to 4.2×10⁻⁸" is prose only, and the doc quotes the better of two displayed rows | add the qualifier |

### 6.2a The residual defects, repaired

All eighteen of §6.2 were re-verified against their own sources (three independent verification
passes, plus the session's own recomputations where the claim was numerical) and then repaired by
`003/repair_residual_defects.py`; the sources that propagated them were repaired by
`003/repair_residual_sources.py`.  Grade changes were made only where the grade was false:

| document | verdict | repair |
|---|---|---|
| `tpp-dict-04-attainability-of-balance.md` | MISMATCH | Status narrowed to `Lean for N = 3`; `N = 4` attributed to its certified numerical enclosure |
| `xihorn-h-track-h6-omega-search.md` | MISMATCH | the sweep narrowed to the driver's — 60 vs 180 digits, `d = 100/200/400` |
| `round10-agentb-an-log-log-with-correction.md` | MISMATCH | **demoted to `CONJECTURED`**; the source asserts the identity and names the missing step as its sharpest open problem |
| `research-journal-growth-law-shared-prefactor.md` | MISMATCH | the two families' prefactors separated (`1/\|½+it\| = 0.0707035` weighted, `1/\|1−it\| = 0.070571` unweighted); the unweighted growth law corrected to `N/\|1−it\|` |
| `research-journal-decay-rate-admissibility.md` | MISMATCH | `(1+x)^{−2}` reclassified from "converges slowly" to "diverges", by the criterion the document itself states |
| `rh37-constraints-and-the-half-turn-floor.md` | MISMATCH | the "excludes" inference replaced; it is refuted by rh38 §4 and is no longer inside the `PROVED` scope |
| `round5-agentb-globality-not-admissibility.md` | UNSUPPORTED | **re-graded to `PROOF-SKETCH`** (the source's own word for it is "essentially a truism") |
| `tpp-rh40-ledger-attributed-cassaigne-repair.md` | MISMATCH | coverage restated: all `L` on one word, ≈405 sampled `L` on each of the other four |
| `tpp-rh40-rounds-truths-f2-…` / `-f5-…` | MISMATCH | the true-`e−2` witness corrected from `4` to **`51`**, and `d₂ + 2` to `d₂ + 1`; the measurement is committed (`rounds/rh40/verify/c1_first_failure.py`) |
| `rh24-radius-limit-and-horizon.md`, `rh25-certified-floors-v18.md` | UNSUPPORTED | `evidence absent` added to the numerical clause; the "59"/"62" named-check suites are not in the repository |
| `research-journal-envelope-exponent-law.md` | UNSUPPORTED | the significance claim narrowed (σ = 0.75 is 7.1 % off, one significant figure) |
| `tpp-rh42-truths-theorem-3-p-gt-n.md` | UNSUPPORTED | the verified grid corrected to the script's `p ∈ {1.01, 1.5, 2, 3, 5}`; `p = 8` was never computed |
| `xihorn-horn-helix-adelic-translation-identity-every-fibre.md` | UNSUPPORTED | the residual clause attributed to the source (prose only); the `PROVED` half kept |
| `xihorn-horn-helix-revisited-closure-ledger.md` | UNSUPPORTED | both displayed rows quoted, not the better one; no committed evaluator, said so |
| `xihorn-todo-gor-lemma-2-3.md` | **flag mis-targeted** | the `CITED` label is correct; only the *quoted sweep* overstated the shipped grid, and that quotation is what was repaired |

Sources repaired one level up: register rows F2/F5 in `rounds/rh40/rounds/truths.md`;
the hard-coded verdict line in `verify/final_adjudication.py`; the coverage comment in
`rounds/rh40/verify/verify_agentB.py`; the verified `p`-grid in `rounds/rh42/truths.md`;
`xi-horn/H_track.md` (120/240 → the driver's 180) and `xi-horn/TODO.md` (the sweep);
`verify/round3_corrections.py` (the significance claim).

### 6.3 The self-check the audit forced on the repair

Because six of the 114 relabels looked false, the whole relabelled set was re-checked by an
adversarial pass whose question was inverted — *find a committed artefact that computes these
numbers* — with instructions to grep the repository's logs and code for the quoted values, including
truncated forms, and to search the round directories and the `xi-horn` Rust corpus.

**The check found 23 false positives** (not six): the qualifier was wrong on a fifth of the
documents it was applied to. They are listed in `003/false_positives.json` and reversed by
`003/reverse_false_evidence_absent.py`, which restores each Status line to the pre-relabel value and
replaces the disclosure bullet with a correction bullet naming the artefact that does the computing.
The mechanical cross-search below had flagged only four of the 23, because a document usually quotes
six figures of a thirty-digit log value — which is precisely why the adversarial pass, not the grep,
decides each case.

*A second, purely mechanical cross-search was run as well: every 5+-decimal number in each of the 114
documents against all 378 committed `.py`/`.rs`/`.sh`/`.log` artefacts (excluding this session's own
files). It flags four documents and no others — four of the 23. The adversarial pass found the other
19, mostly by searching truncated forms of numbers and by opening the round directories' evaluators.
The lesson is recorded in §7.2.*

## 7. Limits of this repair pass

1. **The five findings are repaired; the population they came from is labelled, not repaired.** 91
   documents now say `evidence absent` — the number that survived the adversarial re-check of §6.1,
   which reversed 23 of the original 114. Nobody has re-derived their numbers, and no mathematics was
   re-checked.
2. **`evidence absent` was assigned by a rule that produced false positives, and the rule is
   existence-based in both directions.** It looks for a named artefact, so it missed evaluators that
   compute the numbers under other names or in other directories (§6.1); and it does not check
   whether a *named* artefact performs the check it is credited with, so `own-artefact` and
   `source-artefact` are name checks, not correctness checks — the `h3_onset` defect in §6.2 is that
   gap made concrete.
3. **The `paper` and `cited` strata were audited by sample only**, and the rate estimates carry the
   sampling error of §5.1.
4. **`CITED` documents were not checked against the primary literature**, by design: that is the
   protocol failure the erratum records, and it needs a fetched-and-read source, not a label audit.
   It remains the highest-value un-done check in the archive.
5. **Nothing here is a statement about mathematics.** No theorem was re-proved, disproved or
   re-graded in the mathematical sense.
