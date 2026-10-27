# Theorem 1.4 (rational termination)

**Kind:** Theorem
**Status:** PROVED (paper argument; source labels it THEOREM)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/02-greedy-harmonic-sine.md`](../../research/twin-prime-parity/dictionary/02-greedy-harmonic-sine.md) — §1 "The unsigned greedy word", "Theorem 1.4 (rational termination)", line 41

## Statement

> **Theorem 1.4 (rational termination).**  Every rational `x ∈ (0,1)` has a finite greedy
> expansion; for `x = 1` the support is `{0,1,4}`.

## Hypotheses and notation

- `x ∈ (0,1)` is a rational target for the greedy rule of Definition 1.1 (the rule is a definition and is not harvested).
- "finite greedy expansion" = the support `A(x) = {n : δ_n = 1}` of Definition 1.1 is finite.
- The second clause concerns `x = 1`, which lies outside the stated interval `(0,1)` but is covered by the same sentence in the source.
- Support indices are in the `n`-labelling of Definition 1.1; the source also uses the shifted alphabet `m = n+2`.

## Proof / evidence

The source gives no proof text; its status line reads:

> *Status:* THEOREM.  *Source:* rh41 Theorems 7–8.

The chapter states the result and attributes it to **rh41** Theorems 7–8; no proof or numerical certificate is given here.

## Dependencies and related results

- Definition 1.1 (the greedy rule) and Definition 1.2 (factor complexity) — definitions, not harvested.
- [Theorem 1.3 (the factor-complexity law)](tpp-dict-02-factor-complexity-law.md) — the companion §1 result.
- The existing harvest file [R5 — rational termination for general p](tpp-rh42-truths-r5-rational-termination-general-p.md) records the later, general-`p` **rh42** version of the termination statement.

## Notes

- Ledger entry: the theorem restates **rh41** (Theorems 7–8), as the source states. The dictionary itself supplies neither proof nor numerical evidence, and the status "THEOREM" is the source's own.
- The two clauses have different domains (`x ∈ (0,1)` rational, and `x = 1`); this asymmetry is in the source and is not repaired.
