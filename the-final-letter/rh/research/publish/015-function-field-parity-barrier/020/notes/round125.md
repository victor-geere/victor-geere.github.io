# Round 125 — the write-up

*Plan fixed at the start of the round (`rounds.log`, BEFORE line).*

---

## 1. The envisioned path

Two rounds remain. The phase's content is complete; what is left is presentation and verification: a one-page
executive summary at the programme root, a mechanical link check across all phase documents, and a
reconciliation of `objectives.json` against the actual record.

## 2. Wild guess 66

> **Wild guess 66.** Every relative link in the phase's documents resolves, and a one-page summary can carry
> the whole result without distortion.

**Why guess it.** The documents were written with relative paths throughout and cross-referenced as they were
built.

**Falsification test.** Crawl every `.md` under `020/` and the programme root; follow every relative link.

## 3. Results

* **Link check:** 25 documents, 35 relative links, **1 broken** — round 124's link to the cross-phase synthesis
  pointed one level too high. Fixed; re-run: **0 broken**.
* **Executive summary** written: [`../../EXECUTIVE-SUMMARY.md`](../../provenance/EXECUTIVE-SUMMARY.md) — one page with the
  five findings, the single conclusion, the proved-versus-measured split, the file map, and the one-command
  verification.
* **`objectives.json` reconciled:** O1–O5 now all `complete` (the transfer demand was stated in rounds 111 and
  124), with eighteen rounds recorded.

**Wild guess 66 is confirmed** (after fixing the one link it found — which is the point of the test).

## 4. Lean

`Capstone.parity_constants`: `2^1 = 2 ∧ 2^2 = 4 ∧ 2^3 = 8`, the dimension constants of the phase in one
statement. Standard axioms; thirteen modules green.

## 5. State

* Links: 0 broken across 25 documents.
* Executive summary written; objectives reconciled.
* 20 unit tests, 35-claim audit, thirteen Lean modules — all green.

## 6. Next round (126)

The final round of the goal's budget. It will re-read the objective against the record, run the complete
verification suite one last time, append the closing log line, and state plainly what was achieved and what
was not.
