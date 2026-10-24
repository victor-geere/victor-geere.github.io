# F5 — the corrected sparse-modification bound

**Kind:** Theorem
**Status:** **PROVED (paper argument; machine-checked in Lean 2026-10-11 — OP-12 closed).** `Rh47/Sparse.lean` proves `corrSparse_sub_corr_abs_le` (sharp), `corrSparse_sub_corr_abs_le_four`, `rh46_sparse_bound_false` and `corrSparse_bound_sharp`; `./check.sh --all` 2/2, axiom-clean.
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/03-parity-problem.md`](../../research/twin-prime-parity/dictionary/03-parity-problem.md) — §6, barrier table row F5

## Statement

> **F5** — the **corrected** sparse-modification bound: for a modification set `A ⊆ ℕ` (flip the sign of `λ` at every `a ∈ A`), `|S_A(x) − S(x)| ≤ 2·#{n ≤ x : n ∈ A or n+2 ∈ A} ≤ 4·#{m ≤ x+2 : m ∈ A}`. `rh46`'s quoted `≤ 2·#{n ≤ x+2 : n ∈ A}` is **false** (witness `A = {5}`, `x = 5`: the affected terms `n = 3, 5` each change `+1 → −1`, so `|ΔS| = 4 > 2`). Consequence: a **sparse** modification moves `S(x)` by `o(x)` only; a witness against `o(x)` needs **positive density**.

The file's status line: THEOREM (prose; **not** yet machine-checked — registered as OP-12). Source given as `rh47` `truths.md` §3.

## Hypotheses and notation

- `λ` is the Liouville function (Definition 1.2); `S(x) := Σ_{n≤x} λ(n) λ(n+2)`; `S_A` is the correlation built from the modified function (sign flipped at every `a ∈ A`).
- `A ⊆ ℕ` is the modification set; `ΔS := S_A(x) − S(x)`.
- The source writes the absolute-value bars escaped (`\|S_A(x) − S(x)\|`); the mathematics is `|S_A(x) − S(x)|`.
- OP-12 is the source's register entry for this statement (see [`07-open-problems.md`](../../research/twin-prime-parity/open/07-open-problems.md)).

## Proof / evidence

- Prose proof in `rh47/truths.md` §3; **machine-checked in Lean 2026-10-11** (`Rh47/Sparse.lean`, OP-12 closed).
- The counterexample to `rh46`'s quoted bound is given explicitly: `A = {5}`, `x = 5`, affected terms `n = 3, 5`, each changing `+1 → −1`, so `|ΔS| = 4 > 2`.

## Dependencies and related results

- [Corollary 6.1](tpp-dict-03-corollary-6-1-greedy-support-loglog.md) combines this with row T18 to show the greedy support is quantitatively useless here.
- [Row T18](tpp-dict-03-t18-greedy-sylvester-sparse.md) (the sparsity of the greedy support).
- Restated in the §7 ledger row "6 (F1–F5)".

## Notes

- The source flags this as a **correction** of an earlier quoted bound in `rh46`: the quoted `≤ 2·#{n ≤ x+2 : n ∈ A}` is false, and the corrected chain is `≤ 2·#{n ≤ x : n ∈ A or n+2 ∈ A} ≤ 4·#{m ≤ x+2 : m ∈ A}`.
- The source marks it "**not** yet machine-checked — registered as OP-12"; that hedge is preserved in the Status.
