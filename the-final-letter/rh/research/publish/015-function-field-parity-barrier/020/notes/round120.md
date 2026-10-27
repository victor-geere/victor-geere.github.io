# Round 120 — consolidation and the extended audit

*Plan fixed at the start of the round (`rounds.log`, BEFORE line).*

---

## 1. The envisioned path

Rounds 118 and 119 closed the last two open questions of the synthesis. The honest next step is consolidation:
fold the two new findings into `synthesis.md`, extend the audit to the constants they introduced, and check
that the whole record still reproduces.

## 2. Wild guess 61

> **Wild guess 61.** The extended record — now thirteen rounds, twelve findings, eleven Lean modules — still
> reproduces exactly: extending the audit to the new constants finds no discrepancy.

**Why guess it.** Every number was produced by code still in the tree, and the two historical bugs were caught
and corrected when they occurred.

**Falsification test.** Extend `checks/audit.py` with the round-119 constants (`P(3,5)`, `y²P(y)` at `y = 12`,
`truncated(3,10)`) and rerun.

## 3. Results

`checks/audit.py` now checks **31 claims** — the 28 of round 117 plus `P(3,5) = 0.004037`,
`12²P(3,12) = 0.115`, and `truncated(3,10) = −2523`.

**31 / 31 pass, 0 failures. Wild guess 61 confirmed.**

## 4. The synthesis, updated

`synthesis.md` now carries twelve findings (adding the `2^dim` factor and the two-truncation distinction), the
dimensional framing of the barrier, the two newly *answered* open questions, and the extended proved-versus-
measured ledger.

## 5. Lean

`Parity.two_pow_lt_succ`: the dimension factor is strictly increasing — higher-dimensional sieves are strictly
worse. With `even_two_pow` and `two_pow_ge_two`, the parity constants are now characterised: even, at least two,
and strictly increasing in the dimension. Standard axioms.

## 6. State

* Audit: 31/31.
* Synthesis updated with rounds 118–119; open questions 3 and 4 marked answered.
* Lean: eleven modules, all standard axioms; 20 unit tests green.

## 7. Next round (121)

The phase is documented and audited. Remaining work would be either a new research direction or a fresh
external question; round 121 will re-read the objective against the record and decide whether the programme's
stated path has been exhausted.
