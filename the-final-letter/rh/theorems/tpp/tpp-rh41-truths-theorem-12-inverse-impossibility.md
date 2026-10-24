# Theorem 12 (inverse problem, impossibility half)

**Kind:** Theorem
**Status:** PROVED (paper argument; Lean) — **strengthened 2026-10-11 (register OP-15):** the impossibility is **alphabet-independent for every halting alphabet** (halting ⟹ finitely many ones ⟹ finite support ⟹ `max_L p(L) = a_m+2` by the complexity law), so no halting alphabet of any kind realises `p(L)=cL`; the search `open/op15_nonmonotone.py` also refutes the sub-claim that non-monotonicity cannot help below `L = 20`.
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh41/TRUTHS.md`](../../research/twin-prime-parity/rounds/rh41/TRUTHS.md) — §4 "Alphabets `α_n = (n+2)^{−p}` and the inverse problem"

## Statement

> **Theorem 12 (inverse problem, impossibility half).** Any alphabet with `Σ α_n ≥ x` halts (Theorem 9) and therefore has finitely many ones. By Theorem 4 its complexity satisfies `max_L p(L) = a_m + 2`, a number. Hence **no halting alphabet realises `p(L) = cL`** for any `c > 0`, and in particular not the Sturmian profile `p(L) = L + 1`. Exact termination and linear complexity growth are impossible.
>
> *Open:* non-monotone alphabets, where the taken set need not be an initial segment and richer profiles may occur.

## Hypotheses and notation

- An alphabet `α_n` with `Σ α_n ≥ x`; "halts" means the residual reaches `0` at a finite step, so the taken set is finite and the support is `0 ≤ a_0 < … < a_m`.
- `p(L)` is the factor complexity of the word, with `max_L p(L) = a_m + 2` from [Corollary 4](tpp-rh41-truths-corollary-4-max-complexity.md) (the source writes "Theorem 4"; see Notes).
- `c > 0` is the slope in the forbidden linear profile; the Sturmian profile is `p(L) = L + 1`.
- The source's final sentence extends the impossibility to "exact termination and linear complexity growth".

## Proof / evidence

The source's written argument is quoted in full above: any halting alphabet has finitely many ones, a finite support has bounded complexity `a_m + 2`, hence no linear profile. The source states it without a longer proof text.

Machine-checked in `Rh41/Alphabet.lean` and `Rh41/Impossibility.lean`:
- `max_complexity_of_finite_support`, `no_linear_complexity_of_finite_support`, `no_sturmian_complexity_of_finite_support`, `max_complexity_of_halting`, `no_linear_complexity_of_halting`;
- process-independent core: `Impossibility.no_linear_growth`, `Impossibility.no_affine_profile`, `Impossibility.no_sturmian_profile` — no finite support has a linear/affine (in particular Sturmian) profile, with `N` allowed to grow with `L`.

## Dependencies and related results

- [Theorem 9 (halting criterion)](tpp-rh41-truths-theorem-9-halting-criterion.md) — cited by the statement (its printed `iff` is refuted; see Notes).
- [Corollary 4](tpp-rh41-truths-corollary-4-max-complexity.md) — the bound `max_L p(L) = a_m + 2`, cited by the source as "Theorem 4".
- [Correction 6 — the literal phrasing of Theorem 12](tpp-rh41-lean-readme-correction-6-theorem-12-literal-phrasing.md).

## Notes

- **Citation slip in the source:** the step `max_L p(L) = a_m + 2` is attributed to "Theorem 4"; the result with that content in this round is [Corollary 4](tpp-rh41-truths-corollary-4-max-complexity.md). The wording is preserved verbatim above.
- **Conditional step:** the first sentence invokes Theorem 9, whose printed `iff` the round's Lean README refutes. The finite-support half (and therefore the impossibility) is separately formalised by the `Impossibility.*` declarations, which do not depend on the printed criterion.
- The round's Lean README (correction 6) records that the **literal phrasing** "For every `c > 0` there is `L` with `p(L) < c·L`" is false for a *fixed* truncation `N` once `c·N ≤ a_m+2`; the correct version, `Impossibility.no_linear_growth`, allows the truncation `N` to grow with `L`.
- The source itself flags the **open** case of non-monotone alphabets; it is not harvested as a theorem.
