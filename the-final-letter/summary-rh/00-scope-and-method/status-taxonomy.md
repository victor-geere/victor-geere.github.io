# Status taxonomy

| Label | Meaning |
|---|---|
| **PROVED (Lean)** | machine-checked; axiom footprint `[propext, Classical.choice, Quot.sound]` |
| **PROVED (Lean + native_decide)** | machine-checked but inherits a `native_decide` axiom |
| **PROVED (paper)** | written proof, no Lean formalisation |
| **VERIFIED** | independently recomputed by a route that does not re-run the source |
| **CHECKED** | exhaustively verified over a stated finite class |
| **CERTIFIED** | rigorous interval certificate with a recorded log |
| **REFUTED** | counterexample/disproof with a witness |
| **WITHDRAWN** | retracted; correction recorded |
| **OPEN** | neither proved nor refuted |
| **CONJECTURED** | recorded heuristic/expectation, not a committed target |
| **SETTLED** | in the OP register: proved, refuted, or made precise |
| **OUT OF REACH** | a literature reassessment found no current route |

## Precedence

1. The audited ledger status wins over a paper’s prose.
2. A later correction wins over an earlier round.
3. A refutation with a witness wins over a claim.
4. A finite certificate never upgrades to an asymptotic theorem.
5. `CONJECTURED` is not a target; it is a recorded expectation.

## Edge cases

- `CERTIFIED` finite windows (`T=15`, `T=33`) are not RH.
- `PROVED (paper)` can still be wrong if a hypothesis is wrong; see the OP-5 `O(1/p)` and ceiling-law corrections.
- `REFUTED` statements are kept, with witnesses.
- The 36 harvested open items include 11 heuristic models; they are not committed targets.

[Back to folder README](README.md) · [Back to the summary index](../README.md)
