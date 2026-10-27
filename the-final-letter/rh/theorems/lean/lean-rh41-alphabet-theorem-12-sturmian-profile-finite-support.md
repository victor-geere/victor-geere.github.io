# Theorem 12 (impossibility, Sturmian form) — p(L) = L + 1 on 1 ≤ L ≤ N is impossible for finite support

**Kind:** Theorem
**Status:** PROVED (Lean, no sorry)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh41/lean/Rh41/Alphabet.lean`](../../research/twin-prime-parity/rounds/rh41/lean/Rh41/Alphabet.lean) — lines 676–681, declaration `Rh41.no_sturmian_complexity_of_finite_support`

## Statement

> **Theorem 12 (impossibility), Sturmian form.** A finite support cannot realise the Sturmian profile `p(L) = L + 1` on `1 ≤ L ≤ N`: at `L = N` the complexity is `1`, not `N + 1`.

Formally (Lean 4 / Mathlib):

```lean
theorem no_sturmian_complexity_of_finite_support (S : Finset ℕ) (hne : S.Nonempty)
    (N : ℕ) (hS : S ⊆ range N) (hN : 2 * S.max' hne + 2 ≤ N)
    (hprof : ∀ L, 1 ≤ L → L ≤ N → complexity S N L = L + 1) : False
```

## Hypotheses and notation

- `S : Finset ℕ`, `S.Nonempty`, `S ⊆ range N`; `2 * S.max' hne + 2 ≤ N`.
- `hprof` — the Sturmian profile is assumed for all `L` with `1 ≤ L ≤ N`.
- Conclusion `False`.

## Proof / evidence

Complete Lean proof, no `sorry`/`admit`, no new axioms, no `native_decide` — declaration `Rh41.no_sturmian_complexity_of_finite_support` in `Rh41/Alphabet.lean` (lines 679–685). It combines `p(N) = 1` (`complexity_eq_one_of_le`) with `hprof N`, giving `1 = N + 1`, impossible.

## Dependencies and related results

- [Corollary 3 (decay) — the endpoint p(N) = 1](lean-rh41-digitword-decay-corollary.md).
- [The Sturmian profile p(L) = L + 1 is not realised by any finite support](lean-rh41-impossibility-no-sturmian-profile.md) — the same conclusion in `Rh41/Impossibility.lean`, proved via the affine impossibility.

## Notes

- Sturmian words are exactly the words satisfying `p(L) = L + 1` for all `L ≥ 1` (Morse–Hedlund); the theorem says the finite-support words of this workspace are not Sturmian.
- The candidate `hprof` is stated as an equality of natural numbers (`complexity S N L = L + 1`), unlike the finite-support linear form which is stated over `ℚ`.
