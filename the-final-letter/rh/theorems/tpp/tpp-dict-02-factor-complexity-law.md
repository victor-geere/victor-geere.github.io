# Theorem 1.3 (the factor-complexity law — rh41, closed and formalised)

**Kind:** Theorem
**Status:** PROVED (Lean, no `sorry`; `rh41/lean`, 7 modules, 144 declarations)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/02-greedy-harmonic-sine.md`](../../research/twin-prime-parity/dictionary/02-greedy-harmonic-sine.md) — §1 "The unsigned greedy word", "Theorem 1.3 (the factor-complexity law — rh41, closed and formalised)", line 29

## Statement

> **Theorem 1.3 (the factor-complexity law — rh41, closed and formalised).**  For a
> finite support `0 ≤ a_0 < … < a_m < N` and `L ≥ a_m + 1`,
> ```
> p(L) = min(a_m+1, N−L+1) + [L ≤ N−a_m−1] .
> ```
> *Corollaries:* plateau `a_m+2` on `max(span, a_m+1) ≤ L ≤ N−a_m−1`; decay `N−L+1`
> afterwards; `p(N) = 1`, `p(N−1) = 2`; `max_L p(L) = a_m+2` once `N ≥ 2a_m+2`; and
> always `p(L) ≤ a_m+2`.  The C1 regime `p(L) = L+1` holds for
> `L ≤ min(min gap, a_0, N−a_0−1)`, each bound sharp.

## Hypotheses and notation

- `p(L)` is the factor complexity of Definition 1.2: "the number of distinct length-`L` factors occurring in a length-`N` truncation of `w(x)`" (Definition 1.2 is a definition and is not harvested).
- `0 ≤ a_0 < … < a_m < N` is a finite support (the support `A(x) ⊂ ℕ` of Definition 1.1, shifted by the alphabet `m = n+2`).
- Range: `L ≥ a_m + 1`.
- `[L ≤ N−a_m−1]` is printed in the source as a bracket; the chapter does not define it further.
- `span`, `min gap`, `C1 regime` are the source's terms in the corollary list; the chapter does not define them here.

## Proof / evidence

The source's status line, verbatim:

> *Status:* THEOREM (proved; formalised in `rh41/lean`, 7 modules, 144 declarations, no
> `sorry`).  *Source:* rh41 `TRUTHS.md` Theorems 1–5, 12.

The dictionary gives no proof text; the evidence is the formalisation in `rh41/lean` (7 modules, 144 declarations, no `sorry`).

## Dependencies and related results

- Definition 1.1 (the greedy rule) and Definition 1.2 (factor complexity) of the same chapter — definitions, not harvested.
- [Theorem 1.4 (rational termination)](tpp-dict-02-rational-termination.md) — the companion §1 result.

## Notes

- Ledger entry: the theorem restates **rh41** (`rh41/TRUTHS.md` Theorems 1–5, 12), as the source states.
- The corollary list is printed as part of this theorem's own block and is reproduced here rather than harvested as separate files; the corollaries have no independent numbering.
