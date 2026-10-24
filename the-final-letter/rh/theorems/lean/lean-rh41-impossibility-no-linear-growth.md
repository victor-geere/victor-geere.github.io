# Theorem 12 (impossibility half), quantitative form — no linear complexity profile

**Kind:** Theorem
**Status:** PROVED (Lean, no sorry)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh41/lean/Rh41/Impossibility.lean`](../../research/twin-prime-parity/rounds/rh41/lean/Rh41/Impossibility.lean) — lines 18–22, declaration `Rh41.no_linear_growth`

## Statement

> **Theorem 12 (impossibility half), quantitative form.** For every finite support `S` and every `c > 0` there are `N`, `L` with `1 ≤ L ≤ N` and `p(L) < c·L`: a linear profile is impossible.

Formally (Lean 4 / Mathlib):

```lean
theorem no_linear_growth (S : Finset ℕ) (c : ℚ) (hc : 0 < c) :
    ∃ N L : ℕ, 1 ≤ L ∧ L ≤ N ∧ (complexity S N L : ℚ) < c * L
```

where `complexity S N L = p(L)` is the number of distinct length-`L` factors of the length-`N` truncation of the word with support `S`.

## Hypotheses and notation

- `S : Finset ℕ` — a **finite** support (the set of positions carrying a `1`); no other hypothesis on `S` (it may be empty).
- `c : ℚ` with `0 < c` — the putative linear slope.
- `complexity S N L` — the factor complexity `p(L)`, defined in `Rh41.DigitWord` as `((range (N - L + 1)).image (fun t => factor S L t)).card`.
- The truncation `N` is allowed to depend on `c`; this is the reading under which the claim is true (the literal reading with a fixed `N` is discussed in the source's caveats).

## Proof / evidence

Complete Lean proof, no `sorry`/`admit` and no new axioms. The declaration `Rh41.no_linear_growth` is in `Rh41/Impossibility.lean` (lines 21–55).

- Empty support: `complexity S N L ≤ 1` for all `N, L`, then choose `L` with `1 < c·(L+1)`.
- Nonempty support: `complexity_le_max_add_two` (in `Rh41.DigitWord`) gives `p(L) ≤ a_m + 2` with `a_m = S.max' hne`, then choose `L` with `a_m + 2 < c·(L+1)`.

## Dependencies and related results

- [`Rh41.DigitWord.complexity_le_max_add_two`](lean-rh41-digitword-complexity-upper-bound.md) — the bound `p(L) ≤ a_m + 2` used for nonempty support.
- [No affine complexity profile](lean-rh41-impossibility-no-affine-profile.md) — the strictly stronger statement proved in the same file; the present result is its `b = 0` case.
- [No Sturmian profile `p(L) = L + 1`](lean-rh41-impossibility-no-sturmian-profile.md) — the specialisation `a = 1`, `b = 1`.

## Notes

- The file header explains the intended reading: "A terminating process has a *finite* support `S` … and for every finite support the complexity `p(L) = complexity S N L` is bounded by the constant `a_m + 2` … An unbounded profile such as `p(L) = c·L` (or the Sturmian profile `p(L) = L+1`) therefore cannot be realised."
- `Rh41/Alphabet.lean` flags the same point about the literal phrasing ("Theorem 12's literal `c·L` phrasing needs care"): "For every `c > 0` there is `L` with `complexity S N L < c·L`" is false once `c·N ≤ a_m + 2`, since every complexity is `≥ 1`. The statement above is the version actually proved: `N` and `L` are both existentially quantified.
