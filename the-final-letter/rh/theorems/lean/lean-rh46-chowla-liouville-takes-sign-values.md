# λ n is 1 or −1 for every n ≥ 1

**Kind:** Theorem
**Status:** PROVED (Lean, no `sorry`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh46/lean/Rh46/Chowla.lean`](../../research/twin-prime-parity/rounds/rh46/lean/Rh46/Chowla.lean) — `liouville_mem`, lines 173–177

## Statement

> `theorem liouville_mem {n : ℕ} (hn : n ≠ 0) : liouville n = 1 ∨ liouville n = -1`

The file's docstring states it as: "`λ n` is `1` or `-1` for every `n ≥ 1`."

## Hypotheses and notation

- `liouville n = (-1) ^ Omega n : ℤ`, `Omega n = ArithmeticFunction.cardFactors n`.
- Hypothesis `hn : n ≠ 0`; the statement also holds at `n = 0` (`λ 0 = 1`), and the file's own proof does not use `hn` (the certified check logs an unused-variable warning for `hn` at line 174).

## Proof / evidence

Lean declaration `liouville_mem` in `research/twin-prime-parity/rounds/rh46/lean/Rh46/Chowla.lean` (lines 174–177). The proof is complete, with no `sorry`: it splits on `Nat.even_or_odd (Omega n)` and evaluates `(-1)^k` by `Even.neg_one_pow` / `Odd.neg_one_pow`. Round certification: `[check] OK   Rh46/Chowla.lean (23s)` in `verify/lean_check.log` (the only diagnostics are linter warnings).

## Dependencies and related results

- Uses only Mathlib (`Nat.even_or_odd`).
- The file immediately derives `liouville_ne_zero` (lines 180–181) from it; that corollary is **not** harvested separately here because its content is already carried by this statement.
- Strongest companion: [λ n is a sign: λ n ^ 2 = 1 at every n](lean-rh46-chowla-liouville-square-is-one.md), which holds at every `n` including `0`.

## Notes

- The source gives no numbered theorem name; the docstring sentence is reproduced above as the title.
- The declaration is `theorem`, hence Kind Theorem.
