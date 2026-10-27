# Status taxonomy

The programme uses a precise status vocabulary. This is the ledger’s own table, with the additions used in this summary.

| status | meaning |
|---|---|
| **PROVED (Lean)** | machine-checked; `#print axioms` = `[propext, Classical.choice, Quot.sound]` only |
| **PROVED (Lean + native_decide)** | machine-checked, but the proof inherits a `native_decide` axiom |
| **PROVED (paper)** | written proof; no Lean formalisation |
| **VERIFIED** | independently recomputed by a route that does not re-run the source |
| **CHECKED** | exhaustively verified over a stated finite class |
| **CERTIFIED** | interval/rigorous numerical certificate, with a recorded log |
| **REFUTED** | counterexample or disproof exists, with a witness |
| **WITHDRAWN** | the statement or its proof was retracted; correction recorded |
| **OPEN** | neither proved nor refuted |
| **CONJECTURED** | recorded expectation/heuristic, not a committed target |
| **SETTLED** | in the OP register: resolved (proved, refuted, or made precise) |
| **OUT OF REACH** | a literature reassessment found no route with current methods |

## Edge cases

- **`CONJECTURED` is not a target.** Eleven of the 36 harvested open items are heuristic models; the source explicitly says they are recorded expectations, not proposals the programme is committed to proving.
- **`CERTIFIED` is not a proof of an asymptotic.** The `T=15` and `T=33` Turing windows are unconditional finite-window statements; they say nothing about RH.
- **`PROVED (paper)` can still be wrong if a hypothesis is wrong.** The OP-5 `O(1/p)` error was false and was corrected to `O(1)`; the exact ceiling law was falsified at a 451-digit `p`.
- **`REFUTED` statements are kept.** The programme stores witnesses; do not delete them when summarising.

[Back to folder README](summary-rh/05-lean-verification/README.md) · [Back to the summary index](summary-rh/README.md)
