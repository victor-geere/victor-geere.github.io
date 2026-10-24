# Round 117 — the phase audit and the synthesis

*Plan fixed at the start of the round (`rounds.log`, BEFORE line).*

---

## 1. The envisioned path

Phase 020 has produced a long chain of numeric constants, each verified once in its own round. The risk is
familiar from the programme's own history (round 109's `ω` bug): a number quoted in a note and never re-checked
can drift. The closure of a phase should therefore be an **audit**: one script that recomputes every cheap
constant and compares it with what the notes claim, plus a consolidated synthesis document.

## 2. Wild guess 58

> **Wild guess 58.** Every numeric constant quoted in the phase-020 notes is reproducible from the checked-in
> code; the audit finds no stale or wrong value.

**Why guess it.** Each value was produced by code that is still present, and the two known bugs (round 109's
`ω`, round 108's truncation) were fixed and re-derived at the time.

**Falsification test.** Recompute and compare; any mismatch is a failure.

## 3. Results

`checks/audit.py` checks **28 claims**, including:

* `S(3), S(5), S(7)` to six decimals;
* the eight 018 oracle counts;
* the exact expansion against brute force for three `(q,n)`;
* `c(3,1) = 1/7`, `c(3,2) = 0.050360`, `c(3,3) = 0.029727`;
* the parity ratio at `n = 8` (`3.76`);
* the `q = 7, n = 3` shift table (`21, 35, 28`);
* five orbit counts;
* the recorded `T(13) = 3747` and `T(14) = 9510`.

Result: **28 / 28 pass, 0 failures.**

**Wild guess 58 is confirmed.** The phase's numeric record is self-consistent and reproducible.

## 4. The synthesis

[`synthesis.md`](synthesis.md) consolidates the phase: the model, the ten findings with statuses and rounds, the
four failure modes (`4`, undefined, position-dependent, `n`), the transfer demand, the proved-versus-measured
ledger, reproduction instructions, and four open questions carried forward.

## 5. Lean

`Window.window_shift` (a window sum is a shifted range sum) and `Window.window_concat` (windows concatenate) —
the formal definition of the "segmented window" the phase is named after. Standard axioms.

## 6. State

* Audit: 28/28 claims verified.
* Synthesis written: `notes/synthesis.md`.
* Lean layer: nine modules (`Window.lean` added), all standard axioms; 20 unit tests green.

## 7. Next round (118)

With the phase documented, the remaining substantive question is the one flagged in the synthesis: the
connection between the parity factor `4` of round 110 and the `χ₂(2)` correction of 019. Round 118 will test
whether the `4` decomposes as `2·2` with one factor `2` carrying the `χ₂(2)` sign — i.e. whether the
twisted-Parseval identity and the sieve cap are two faces of the same local obstruction.
