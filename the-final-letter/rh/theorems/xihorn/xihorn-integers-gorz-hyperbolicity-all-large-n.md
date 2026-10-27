# [GORZ] For each fixed d, J^{d,n} is hyperbolic for all but finitely many n

**Kind:** Theorem
**Status:** CITED (literature; the source flags the attribution from memory — "verify before citing")
**Area:** xi-horn
**Source:** [`xi-horn/INTEGERS.md`](../../xi-horn/INTEGERS.md) — §5 "Beat it in topological space, then bring it back"

## Statement

> **What is actually open**, then, is not margin decay. Griffin–Ono–Rolen–Zagier proved that for each fixed d, J^{d,n} is hyperbolic for all but finitely many n (from memory — verify before citing). The gap is those finitely many small-n exceptions at each d, with no uniform-in-d control of how many. Genuine, and invisible in any margin table.

## Hypotheses and notation

- J^{d,n}(X) = Σ_{j=0}^{d} C(d,j)·a(n+j)·X^j is the Jensen polynomial of the Laguerre–Pólya sequence a(n) = γ(n)·n!/(2n)! (POSITIVITY.md (13)).
- d is fixed; the statement is for all but finitely many shifts n.
- Hyperbolic means all roots real.

## Proof / evidence

The source states the result and immediately flags the attribution as from memory ("verify before citing"); it gives no proof and reproduces no citation details beyond the author list. It notes that the remaining gap — the finitely many small-n exceptions at each d, with no uniform-in-d control of how many — is "genuine, and invisible in any margin table".

## Dependencies and related results

- The Jensen polynomial definition and the LP criterion: [xihorn-positivity-jensen-laguerre-polya-criterion.md](xihorn-positivity-jensen-laguerre-polya-criterion.md).
- The same classical theorem harvested from the sibling source: [xihorn-gorz-gap-gorz19-theorem-1.md](xihorn-gorz-gap-gorz19-theorem-1.md) ([gorz-gap.md](../../xi-horn/gorz-gap.md), [GORZ19] Theorem 1).
- The scale-free flat-margin measurement: [xihorn-integers-jensen-margins-are-flat.md](xihorn-integers-jensen-margins-are-flat.md).

## Notes

- The open gap — "those finitely many small-n exceptions at each d, with no uniform-in-d control of how many" — is described as open and is not labelled a theorem; it is recorded here rather than harvested.
- The source also retracts a conflation: the Jensen-degree gap is "not the wall rh28/rh29 measured" (their decaying quantity is a Weil-positivity floor against support/window depth).
