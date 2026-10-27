# The greedy on a finite list: its total is a sub-sum and it never overshoots a non-negative target

**Kind:** Theorem
**Status:** PROVED (Lean, no sorry)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh42/lean/Rh42/Reachable.lean`](../../research/twin-prime-parity/rounds/rh42/lean/Rh42/Reachable.lean) — `greedySum_mem_subSums` (lines 217–225) and `greedySum_le` (lines 229–241)

## Statement

> For a list `l` of rationals and a target `x`:
>
> - the greedy total `greedySum l x` is a sub-sum: `greedySum l x ∈ subSums l`;
> - if every entry of `l` is non-negative and `0 ≤ x`, then the greedy never overshoots: `greedySum l x ≤ x`.
>
> Lean statements:
>
> `greedySum_mem_subSums (l : List ℚ) (x : ℚ) : greedySum l x ∈ subSums l`
>
> `greedySum_le {l : List ℚ} (h : ∀ a ∈ l, 0 ≤ a) : ∀ x : ℚ, 0 ≤ x → greedySum l x ≤ x`

## Hypotheses and notation

- `greedySum : List ℚ → ℚ → ℚ` is the greedy total: "walk the list and take a term whenever it fits", i.e. `greedySum [] x = 0` and `greedySum (a :: t) x = if a ≤ x then a + greedySum t (x - a) else greedySum t x`.
- `subSums` is the sub-sum set of the list.
- `greedySum_le` requires all entries of `l` to be `≥ 0` and the target to satisfy `0 ≤ x`.

## Proof / evidence

Machine-checked in `Rh42/Reachable.lean` by the two `theorem`s named above, both by induction on the list following the `greedySum` recursion. The file header states: "there is no `sorry`, no `admit`, no new axiom and no `native_decide`."

## Dependencies and related results

- The definitional companions `greedySum`, `greedySum_nil` and `greedySum_cons` (`rfl`) are not harvested separately.
- The optimality step relating the greedy to the completeness criterion is [`lean-rh42-reachable-brown-sufficiency-step.md`](lean-rh42-reachable-brown-sufficiency-step.md) (`greedy_step_optimal`).
- The rh42 Lean README lists this row as "the greedy on a list" ↔ `greedySum`, `greedySum_cons`, `greedySum_mem_subSums`, `greedySum_le`.

## Notes

- The two declarations state feasibility (`∈ subSums l`) and the non-overshoot bound separately; they are the two halves of "the greedy is feasible and never overshoots" and are folded into this one file.
