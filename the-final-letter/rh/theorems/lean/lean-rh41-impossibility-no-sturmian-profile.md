# The Sturmian profile p(L) = L + 1 is not realised by any finite support

**Kind:** Theorem
**Status:** PROVED (Lean, no sorry)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh41/lean/Rh41/Impossibility.lean`](../../research/twin-prime-parity/rounds/rh41/lean/Rh41/Impossibility.lean) — lines 95–98, declaration `Rh41.no_sturmian_profile`

## Statement

> In particular the Sturmian profile `p(L) = L + 1` is not realised by any finite support (i.e. by any terminating process).

Formally (Lean 4 / Mathlib):

```lean
theorem no_sturmian_profile (S : Finset ℕ) :
    ¬ (∀ N L : ℕ, 1 ≤ L → L ≤ N → (complexity S N L : ℚ) = L + 1)
```

## Hypotheses and notation

- `S : Finset ℕ` — an arbitrary finite support (the file's reading: a terminating process has finite support).
- The profile `p(L) = L + 1` is required for all `N` and all `L` with `1 ≤ L ≤ N`.
- `complexity S N L = p(L)` as in `Rh41.DigitWord`.

## Proof / evidence

Complete Lean proof, no `sorry`/`admit`, no new axioms — declaration `Rh41.no_sturmian_profile` in `Rh41/Impossibility.lean` (lines 97–102). It applies `no_affine_profile S 1 1` and rewrites `1 * L + 1` to `L + 1`.

## Dependencies and related results

- [No affine complexity profile](lean-rh41-impossibility-no-affine-profile.md) — the theorem applied here (with `a = 1`, `b = 1`).
- [No linear complexity profile (quantitative form)](lean-rh41-impossibility-no-linear-growth.md).
- On the Sturmian side, the same conclusion is reached by a different route in `Rh41/Alphabet.lean`: `no_sturmian_complexity_of_finite_support` uses `p(N) = 1` at `L = N`.

## Notes

- Sturmian words are exactly the words with `p(L) = L + 1` for all `L`; the theorem says the profinite/terminating greedy words are not Sturmian.
- The statement is a direct corollary of `no_affine_profile`; it is recorded here separately because the source states it as its own result ("In particular …").
