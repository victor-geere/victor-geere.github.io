# HEURISTIC 2.4 (why the slogan is nevertheless the right picture)

**Kind:** Claim
**Status:** CONJECTURED (heuristic expectation; not a proof)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/03-parity-problem.md`](../../research/twin-prime-parity/dictionary/03-parity-problem.md) — §2.2

## Statement

> **HEURISTIC 2.4 (why the slogan is nevertheless the right picture).** `λ` has mean `0` in every complete residue system mod `q` and `λ` does not "pretend to be" a Dirichlet character `n ↦ χ(n)n^{it}` in the sense of the structure theorems (§4.1 rows T7–T8); this is the modern reason to expect `Σ w(n)λ(n) = o(Σ w(n))` for the whole bounded-depth class.

The file's status line: *Status:* HEURISTIC (structurally compelling; not a proof). The corresponding *theorem* is the logarithmic/almost-all structure theory of §4, which is strictly weaker than the un-truncated statement.

## Hypotheses and notation

- `λ` is the Liouville function (Definition 1.2); `w` ranges over the bounded-depth (parity-blind) sieve weights of Definition 1.11.
- "`λ` has mean `0` in every complete residue system mod `q`" means `Σ_{a mod q} λ(a) = 0`.
- "pretend to be a Dirichlet character" is the source's pretentiousness vocabulary; the relevant structure statements are §4.1 rows T7–T8, i.e. [THEOREM 3.12](tpp-dict-03-almost-all-scales.md) and [THEOREM 3.13](tpp-dict-03-structure-theorem-correlations.md).

## Proof / evidence

- The source states this explicitly as **HEURISTIC**: "structurally compelling; not a proof".
- The nearest theorems are the logarithmic/almost-all structure theory of §4, which the source says is **strictly weaker** than the un-truncated statement.

## Dependencies and related results

- [`THEOREM 2.2`](tpp-dict-03-periodic-weight-liouville.md) (the periodic theorem); [`UNVERIFIED 2.3`](tpp-dict-03-truncated-weights-unverified.md) (the truncated case); [`THEOREM 2.1`](tpp-dict-03-selberg-parity-principle.md) (the no-go theorem).
- [`THEOREM 3.13`](tpp-dict-03-structure-theorem-correlations.md) (the structure theorem the heuristic refers to).
- Restated in the §7 ledger row "2.4".

## Notes

- Harvested because the source labels and numbers it as a statement of the file, with an honest HEURISTIC label; the status is recorded as CONJECTURED so it is not read as proved.
