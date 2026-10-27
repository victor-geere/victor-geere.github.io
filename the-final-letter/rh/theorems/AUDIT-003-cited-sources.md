# AUDIT 003 — the primary sources behind the archive's `CITED` labels

*Session 003, second task. The archive labels 165 documents `CITED (literature)`: their content is an
external theorem, restated here. The session-002 audit sampled that class and reported it "OK" — it
had checked that the citations were **specific**, without fetching one of them. That is the check that
failed to catch the MRT misattribution, so this pass does the other thing: it fetches the papers and
reads them.*

**Result.** 38 distinct documents were read: 35 that name an arXiv work (across 41 verdict rows — one
document is checked against three of the papers) plus 3 that carry a DOI or URL. All 13 arXiv papers
were read in full text (11 from arXiv HTML, 1 from PDF, 1 cross-checked against its LaTeX source).
**30 documents are supported, 5 are misattributed, 3 are overstated** — 8 defects in 38 documents,
21 % (95 % interval 10 %–37 %). The worst finding is the same class of error as the MRT erratum and
was found the same way — by reading the source:

> **`theorems/tpp-dict-03-tao-teravainen-log-all-orders.md`**, and the dictionary section it comes
> from, present "log-averaged Chowla for **all orders**" as a theorem and credit the general case to
> Tao–Teräväinen's almost-all-scales paper. **No such result exists.** Log-averaged Chowla is proved
> for **odd** `k` (Tao–Teräväinen 2017/2019) and for **`k = 2`** (Tao 2016); even `k ≥ 4` is open, and
> the paper the archive credits says so in as many words.

---

## 1. Why this pass exists

The MRT erratum (`research/twin-prime-parity/cone/ERRATUM-mrt-misattribution.md`) established the rule
the archive now runs on: *no load-bearing external citation goes into a document until someone has
fetched the source and read it.* The session-002 audit honoured the rule for one paper (MRT) and for
none of the others: its `CITED` pass checked specificity, not content, and said so. This pass applies
the rule to the part of the class where it is cheap and decisive — the documents that name an arXiv
identifier — and reports exactly how far it got.

## 2. Method

`research/twin-prime-parity/003/citation_inventory.py` enumerates every `CITED` document and extracts
the external references it makes. 165 documents:

| evidence of an external source | documents |
|---|---|
| an arXiv identifier | 35 |
| a DOI | 1 |
| a URL | 5 |
| a journal-shaped citation only | 7 |
| an author–year mention only | 8 |
| "classical" with no specific attribution | 68 |
| no reference of any kind detected | 25 |

The 35 arXiv-cited documents resolve to **13 distinct works** — one of them (`arXiv:2007.13582`,
O'Sullivan) accounts for 21 documents — so the work was batched **by paper, not by document**: 15
batches, one agent per batch, each of which fetched the paper and then checked every dependent
document against it. The agents were instructed to read the full text in preference to the abstract,
to quote the paper's own sentence for every verdict, and to say `UNVERIFIABLE` rather than guess
(they returned no `UNVERIFIABLE`: all 13 papers were readable). Agent output, with the quotations:
`003/cited_result_00..14.json`, aggregated in `003/citation_audit_results.json`.

**What counts as a defect here.** `MISATTRIBUTED` — the paper does not say it (wrong result, wrong
scope, dropped hypothesis, or the numbered statement does not exist). `OVERSTATED` — the paper says
something weaker or narrower.

## 3. The verdicts

Counted by row, then deduplicated by document (the only document audited more than once is
`tpp-dict-03-tao-teravainen-log-all-orders.md`, flagged by three batches): **35 arXiv-cited
documents, 28 supported, 3 overstated, 4 misattributed** — a defect rate of **7/35 = 20 %** (95 %
interval 8 %–37 %), of which the hard misattribution rate is **4/35 = 11 %**. Three further documents
with an identifier but no arXiv id were checked afterwards (§4.8), bringing the audited total to 38
documents and 8 defects (**21 %**).

| arXiv | paper | docs | supported | misattributed | overstated |
|---|---|---|---|---|---|
| 2007.13582 | Ó'Sullivan, *Zeros of Jensen polynomials…* | 21 | 18 | 3 | 2 |
| 1809.02518 | Tao–Teräväinen, *…almost all scales* | 3 | 2 | 1 | — |
| 1708.02610 | Tao–Teräväinen, *…logarithmically averaged correlations* | 2 | 1 | — | 1 |
| 1710.02112 | Tao–Teräväinen, *odd order cases* | 1 | — | — | 1 |
| 1503.05121 | Matomäki–Radziwiłł–Tao, *averaged form of Chowla* | 1 | — | — | 1 |
| 1501.04585 | Matomäki–Radziwiłł, *…short intervals* | 3 | 3 | — | — |
| 1605.04628 | Tao, *…Chowla and Sarnak* | 3 | 3 | — | — |
| 1509.05422 | Tao, *log-averaged Chowla…two-point* | 1 | 1 | — | — |
| 1509.01545 | Matomäki–Radziwiłł–Tao, *…one-point* | 1 | 1 | — | — |
| 1407.4897 | Polymath8b | 2 | 2 | — | — |
| 1311.4600 | Maynard, *small gaps* | 1 | 1 | — | — |
| 0903.1627 | Cassaigne, *complexity and periodic words* | 1 | 1 | — | — |
| 2008.07206 | Farmer, *…Jensen polynomials* | 1 | 1 | — | — |
| **arXiv-cited subtotal (rows)** | | **41** | **32** | **4** | **5** |
| *(3 further documents with a DOI or URL — §4.8)* | | **3** | **2** | **1** | — |
| **total (rows)** | | **44** | **34** | **5** | **5** |
| **total (distinct documents)** | | **38** | **30** | **5** | **3** |

## 4. The findings

### 4.1 MISATTRIBUTED — "log-averaged Chowla for all orders" does not exist

`theorems/tpp-dict-03-tao-teravainen-log-all-orders.md`, sourced from
`research/twin-prime-parity/dictionary/03-parity-problem.md` §3.4, states "Definition 3.7 holds for
every fixed `k` and every fixed admissible affine data" and attributes the general case to
`arXiv:1809.02518` "via the almost-all-scales structure theorem".

What the sources say:

* `arXiv:1809.02518` (abstract): *"we establish the `k`-point Chowla conjecture … for `k` odd or equal
  to `2` for all scales `X` outside of a set of zero logarithmic density"* — this is the
  **unweighted** conjecture at almost all scales, not the log-averaged one, and the paper's own text
  states the log-averaged state of the art: *"the logarithmically averaged Chowla conjecture has been
  established for `k = 2` in [29] and for all odd values of `k` in [32]"*, with even `k ≥ 4` open.
* `arXiv:1710.02112` Theorem 1.1: *"Let `k ≥ 1` be an odd natural number …"* — odd orders only.
* `arXiv:1708.02610` Theorem 1.1(i): the logarithmically averaged conjecture for an **odd** number of
  shifts; its affine form (eq. 8) is stated *"if `k` is even"*, i.e. again an odd number of Liouville
  factors.
* `arXiv:1509.05422` (Tao 2016, **never cited by the document**) is where the `k = 2` log-averaged
  case is proved; it is the paper the archive's own §2 already relies on for the cone residue.

So the claim is wrong twice over: **the scope is wrong** (`k` even `≥ 4` is open) and **the paper is
wrong** (the almost-all-scales theorem proves no log-averaged statement at all). Three independent
batches flagged the same document. The archive contradicts itself elsewhere — the same dictionary's
`tpp-dict-03-almost-all-scales.md`, harvested two rows away, quotes `1809.02518` correctly as
"`k` odd or equal to `2`".

**Status: repaired.** The document and the dictionary row now state the odd-`k` and `k = 2` cases,
cite `1710.02112`/`1708.02610` for odd orders and `1509.05422` for `k = 2`, and record that even
`k ≥ 4` is open.

### 4.2 MISATTRIBUTED — Ó'Sullivan's Theorem 3.9 parameter range

`theorems/xihorn-uniformity-osullivan-theorem-39.md` states the Bessel/Laguerre criterion for
"all real `ν > −2`". The paper (both v1 and v2) reads **`α ≥ −2`**, closed, and its own `d = 2`
discriminant computation confirms the endpoint is included. A boundary excluded where the paper
includes it.

**Status: repaired.**

### 4.3 MISATTRIBUTED — Ó'Sullivan's Corollary 3.2: `Θ⁽ⁿ⁾`, not `ξ⁽ⁿ⁾`

`theorems/xihorn-uniformity-osullivan-corollary-32.md` states the all-`d` criterion as
"`ξ^(n)` is hyperbolic ⟺ `J_{d,n}` is hyperbolic for every `d ≥ 1`", with the note "`ξ` is the Riemann
xi function". The paper's Corollary 3.2 is about **`Θ^(n)`**, the `n`-th derivative of
`Θ(z) = ξ(½ + √z)` — and the distinction is not cosmetic: `ξ` is complex on the real axis, so
"`ξ^(n)` is hyperbolic" is not a statement the paper makes or that the criterion needs. Two batches
flagged this independently (one from the paper's HTML, one while checking Farmer's paper).

**Status: repaired** — the document now writes `Θ^(n)` and defines it, keeping the equivalence the
source intends.

### 4.4 MISATTRIBUTED — Ó'Sullivan's Lemma 3.4 is an algebraic identity

`theorems/xihorn-uniformity-osullivan-lemma-34.md` presents the lemma as carrying the substantive
claim that "every choice of `Ω` is the classical Jensen family of the product `Φ·Ω`, and multiplying
by an LP factor neither adds nor removes real-zero content". The paper's Lemma 3.4 is a bare
generating-function identity ("This is an easy exercise"), and that real-zero reading belongs to
Theorem 3.5's *use* of it, not to the lemma.

**Status: repaired** — the identity is attributed as the paper states it, and the LP-freedom reading
is attributed to Theorem 3.5.

### 4.5 OVERSTATED — "never the converse" added to Corollary 3.8 (twice)

`theorems/xihorn-todo-os-corollary-3-8.md` and `theorems/xihorn-uniformity-osullivan-corollary-38.md`
both add a strictness claim: "`J_{d,n}` hyperbolic ⟹ `P_{d,n}` hyperbolic, **never the converse**".
Ó'Sullivan's Corollary 3.8 is the one-way implication and nothing more; neither "never" nor
"strict" appears in the paper. (`xihorn-h-track-os-corollary-3-8.md`, the third document on the same
corollary, states it correctly and passed.)

**Status: repaired** — the one-way implication is kept, the strictness clause is removed where the
paper does not support it.

### 4.6 OVERSTATED — MRT's error terms dropped

`theorems/tpp-dict-03-mrtt-almost-all-shifts.md` states the averaged Chowla theorem and the modulated
short-interval bound with `o(·)` only. Both statements in the paper come with explicit error terms
(`log log H / log H` and `log^{−1/3000} X` for the first; `log^{−1/700} X` for the second) which are
part of the paper's advertised content. The document's scope warning — that the result is about the
*average*, and says nothing about a single shift — is correct and is the part that matters most after
the MRT erratum.

**Status: recorded** — the missing error terms are noted in the document; the scope warning stays.

### 4.7 MISATTRIBUTED — the large-sieve document cites the wrong paper

`theorems/research-journal-large-sieve-inequality.md` (source: `research-journal.md:572`) states the
analytic large sieve correctly — as an upper bound, which is the document's whole point — and attaches
a zbMATH identifier. That identifier, **`0283.10024`, is not Montgomery's book**: it is Tijdeman,
*On the maximal distance between integers composed of small primes*, Compos. Math. **28** (1974)
159–162, a different subject. Montgomery's *Topics in multiplicative number theory* is LNM **227**
(1971), zbMATH **0216.03501**. Separately, "the Montgomery large sieve" credits the wrong author for a
classical inequality (Linnik 1941, Rényi, Roth, Bombieri, Selberg–Gallagher; Montgomery's book is an
expositor).

**Status: repaired** — the identifier is corrected in the document and in its source, with a note
recording both the wrong id and the misattribution. The inequality and its direction needed no change.

### 4.8 The three further documents that carry an identifier, and the counting

The 3 `CITED` documents whose own text carries a DOI or a URL — but no arXiv id, so no batch collected
them — were checked after this report's first draft. Leaving them out made the "35 of 35 arXiv-cited
documents" claim true while the "everything with an identifier was read" claim was false. Results:
Chen (1973) and Friedlander–Iwaniec (`a² + b⁴`, EMIS Annals 148(3)) are `SUPPORTED` — with one dead
DOI/cdn link found and repaired in the Chen document — and the large-sieve document is
`MISATTRIBUTED` (§4.7).

**Corrected totals.** 38 distinct documents read (35 arXiv-cited + 3 identifier-carrying): **30
supported, 5 misattributed, 3 overstated** — a defect rate of **8/38 = 21 %** (95 % interval 10–37 %),
of which the hard misattribution rate is **5/38 = 13 %**.

### 4.9 What the unread tail would cost to check — the part of the earlier claim that was wrong

An earlier draft of this report said the unread tail "is where the next misattribution is most likely
hiding — and it is the cheapest stratum to check". The first clause is unsupported (§5.2) and the
second is **false as stated**. The 38 documents audited here were cheap because they are *batchable*:
13 papers behind 35 documents, each paper read once and checked against every dependent document. The
127 unread documents do not batch that way. By the inventory's own classification they are 66 bare
"classical" mentions, 46 with no machine-matched citation (of which 35 do name a person), 7 journal
citations and 8 author–year citations — that is **112 documents whose source has to be identified by a
literature search before it can even be fetched**, one at a time. The remaining 15 carry enough to
find (a journal, an author and year). So the tail is large and *per-document expensive*, not cheap.

The one cheap signal available is inbound links between harvested documents: 101 of the 127 are linked
from at least one other document, and the most-linked are `rh10-weil-positivity-criterion.md` (9),
`xihorn-gorz-gap-gorplus-corollary-13.md` (9) and `tpp-rh044-truths-theorem-3-riemann-theta-identity.md`
(8). That ranks by how often the archive *restates* a result, which is a proxy for how much of the
archive depends on it — not a measurement of it.

### 4.10 OVERSTATED / dropped hypotheses elsewhere (recorded, not repaired)

* `tpp-dict-03-almost-all-scales.md` — supported, but the abstract it quotes omits the paper's
  requirement that the shifts be **distinct** (Corollary 1.14 is false with a repeated shift).
* `tpp-dict-03-structure-theorem-correlations.md` — supported, but the paper's `f` is built from a
  generalised limit functional; the document writes a plain `lim` and calls the display verbatim.
* `tpp-rh40-round01-agentb-cassaigne-extendable-language.md` — supported, with the `Status` giving a
  wrong journal/volume/pages for Cassaigne's `Zbl 0921.68065`, and Exercise 8's "factorial"
  hypothesis dropped.
* `tpp-dict-03-t8-polymath8b-bounded-gaps.md` — supported; the quoted abstract sentence is v1 wording
  (v2–v4 reword it).

## 5. What this pass did **not** do

1. **The rest of the `CITED` class.** This pass read the part of the class that names an arXiv work:
   **35 distinct documents** (41 verdict rows, one document checked against three papers). The other
   **127 `CITED` documents were not read.** Their citations, classified by what the inventory script
   can see in the document text:

   | what the document carries | documents |
   |---|---|
   | a journal, volume and year | 7 |
   | an author and a year | 8 |
   | the word "classical" and no name | 66 |
   | no machine-matched citation (35 of these do name an author — checked by hand) | 46 |
   | **total unread** | **127** |

   The other 3 documents in the "unread" bucket carried an identifier a reader could follow (one DOI,
   two URLs); they were audited after this report's first draft (§4.8) and are no longer unread.
   **So 127 `CITED` documents remain unread, and 112 of them name an author or call the result
   classical and give nothing a fetch can resolve without a literature search per document.** The
   inventory script's "no reference detected" label understates them: 35 of the 46 name a specific
   person (Fermat, Mertens, Goldfeld, Brown, Zhang, Bombieri–Friedlander–Iwaniec, Mayer, the GPY
   team, …); the script simply does not treat a bare name as a citation.

2. **How much is riding on an unread citation is not measured.** The ~20 % defect rate is measured on
   the 38 documents read. Nothing here supports a claim about the rate in the other 127 — the interval
   on 8/38 is 10 %–37 %, and the non-arXiv strata may be better or worse. A per-document "how much
   depends on this citation" count would be needed to rank the remaining work; this pass did not
   compute one, so it does not claim to know where the next misattribution is most likely to be. The
   one signal available is inbound links between harvested documents (101 of the 127 are linked from
   at least one other document; `rh10-weil-positivity-criterion.md`,
   `xihorn-gorz-gap-gorplus-corollary-13.md` and `tpp-rh044-truths-theorem-3-riemann-theta-identity.md`
   lead with 8–9), which ranks by *how often the archive restates the result*, not by how much any
   argument depends on it.

3. **`CITED` is not the only class that cites.** Documents labelled `PROVED (paper argument)` lean on
   external results too (the cone residue note rests on Tao 2016). Only `CITED` labels were audited.

4. **No claim about mathematics was re-proved.** The verdicts are about what the papers say, not
   about whether the papers are right.
