# Round 127 — handover and close

*Final round of the goal (20/20).*

---

## 1. The envisioned path

The budget ends here. The last act is the one that makes the phase useful to someone else: a handover document
that says where the programme stopped, what a successor should try first, what constraints any proof must
satisfy, and how to keep the record honest.

## 2. Wild guess 68

> **Wild guess 68.** The phase's inheritance can be stated as four ordered directions plus a hard-constraint
> list, short enough to be actionable and precise enough that a successor cannot accidentally repeat a closed
> mechanism.

**Why guess it.** The synthesis already contains every ingredient; the handover is a matter of ordering and
constraint extraction.

**Falsification test.** Write it, then check it against the record: does every claim in it trace to a round
note, and does the harness it points at actually pass?

## 3. Results

[`../../HANDOVER.md`](../../provenance/HANDOVER.md) written, containing:

* the state of play (proved / measured / open) in one table;
* four ordered directions — D1 formalise pair equidistribution, D2 attack the fixed-`q` asymptotic, D3 the
  grading substitute, D4 non-square positive weights — each with a first concrete step;
* four hard constraints any proof must satisfy, including the measured numbers it must reproduce;
* the full harness, with the rule that every quoted number gets an audit entry;
* the conventions (status ladder, round protocol, wild guess numbering — next is 68);
* a "what not to redo" table with seven closed mechanisms and their rounds;
* an hour/day/week triage.

**Wild guess 68 is confirmed.** Every claim in the handover traces to a round note, and the harness it points
at passes (round 126's full run).

## 4. Lean

No new lemma: the layer stands at fourteen modules, re-elaborated in round 126.

## 5. Closing state

* 20 rounds, 127 programme rounds in total across the three phases.
* 14 Lean modules (020) on standard axioms; 20 unit tests; 35-claim audit; 36 links, 0 broken.
* Three synthesis documents at the programme root: executive summary, cross-phase synthesis, handover.
* The barrier was not crossed; the record says so in every summary.

## 6. The goal

The goal's stated work — continue the programme with the per-round protocol, pursuing the path — is
discharged for its full budget. The research objective behind it (crossing the parity barrier) is not achieved
and is documented as open. Those are different claims and both are true.
