# (17) The topological statement — LP is closed, and RH ⟺ Ξ ∈ LP ⟺ every Jensen polynomial is hyperbolic

**Kind:** Theorem
**Status:** CITED (literature)
**Area:** xi-horn
**Source:** [`xi-horn/INTEGERS.md`](../../xi-horn/INTEGERS.md) — §5 "Beat it in topological space, then bring it back", equation (17)

## Statement

> **The topological statement.** The Laguerre–Pólya class LP — entire functions that are locally uniform limits of real-rooted polynomials — is **closed** in the topology of uniform convergence on compact sets. And
>
> ```
> RH  ⟺  Ξ ∈ LP  ⟺  every Jensen polynomial J^{d,n} is hyperbolic            (17)
> ```
>
> So RH is a *closedness* assertion: exhibit Ξ as a limit of hyperbolic polynomials and you are done. No analytic continuation, no zero-counting, no contour.

## Hypotheses and notation

- LP is the Laguerre–Pólya class: entire functions that are locally uniform limits of real-rooted polynomials; closed in the topology of uniform convergence on compact sets.
- Ξ(t) = ξ(½ + it) is the completed zeta function (README §2).
- J^{d,n}(X) = Σ_{j=0}^{d} C(d,j)·a(n+j)·X^j are the Jensen polynomials of Ξ's Laguerre–Pólya sequence a(n) = γ(n)·n!/(2n)! (POSITIVITY.md (13)).
- Hyperbolic means all roots real.

## Proof / evidence

The source states LP's closedness and the equivalence chain (17) without proof, as the classical Pólya/Jensen criterion; it uses them to argue that RH is a closedness assertion decidable from enclosures of coefficients (a sign is a topological fact) and that this is "precisely the technique rh19–rh27a already run".

## Dependencies and related results

- The Jensen/Laguerre–Pólya criterion of POSITIVITY.md (12)–(13): [xihorn-positivity-jensen-laguerre-polya-criterion.md](xihorn-positivity-jensen-laguerre-polya-criterion.md).
- Hyperbolicity as a sign of the discriminant: [xihorn-integers-hyperbolicity-is-a-sign.md](xihorn-integers-hyperbolicity-is-a-sign.md).
- The positive discriminants computed as evidence: [xihorn-integers-positive-jensen-discriminants.md](xihorn-integers-positive-jensen-discriminants.md).

## Notes

- The source's §5 records what remains open after (17): "Griffin–Ono–Rolen–Zagier proved that for each fixed d, J^{d,n} is hyperbolic for all but finitely many n (from memory — verify before citing). The gap is those finitely many small-n exceptions at each d, with no uniform-in-d control of how many. Genuine, and invisible in any margin table." This open gap is not itself labelled a theorem and is not harvested.
- The source also retracts a conflation: this is "not the wall rh28/rh29 measured", since their decaying quantity is a Weil-positivity floor against support/window depth while Jensen degree d is a different axis.
- The source frames (17) as classical ("Jensen/Laguerre–Pólya is classical", POSITIVITY.md §6) and claims no discovery.
