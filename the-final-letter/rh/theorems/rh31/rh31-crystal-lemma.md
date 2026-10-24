# The crystal lemma

**Kind:** Lemma
**Status:** PROVED (paper argument; verified to machine zero)
**Area:** rh-html
**Source:** [`rh31.html`](../../html/rh31.html) — §6 "The position laws", lines 1467–1471; labelled as "the crystal lemma of §6" in the front-matter box at line 300

## Statement

> The crystal first, because it has a one-line law. m equispaced atoms on (0, π), mirrored, are 2m equispaced points on the circle, so E(k) = 0 for every 0 &lt; k &lt; 2m — verified to machine zero — and T<sub>n</sub> is the mass times the identity out to n = 2m. The crystal's law is a step function: λ/mass = 1, then nothing.

## Hypotheses and notation

- The crystal is m equispaced atoms on (0, π), mirrored, i.e. 2m equispaced points on the circle, all of equal weight.
- E(k) is the k-th Toeplitz moment; T<sub>n</sub> is the Toeplitz section; m = 300 in the source's figure.
- λ/mass is the smallest eigenvalue as a fraction of the total mass.

## Proof / evidence

One line, as the source says: the off-diagonal moments of a full lattice of 2m equispaced points vanish for 0 &lt; k &lt; 2m, so T<sub>n</sub> = mass·I out to n = 2m. The source records "verified to machine zero". The source's front-matter states that this lemma is elementary and does not depend on RH.

## Dependencies and related results

- [rh32-crystal-atom-sum-identity](../rh32/rh32-crystal-atom-sum-identity.md) — the same exactness proved as an atom-sum identity, the form rh32 needs.
- [rh32-void-identity](../rh32/rh32-void-identity.md) — what happens to this law when atoms are deleted.
- [rh31-emptiest-arc-law](rh31-emptiest-arc-law.md) — the crystal is one of §6's three reference geometries.

## Notes

- The label comes from the source's own front-matter box ("the crystal lemma of §6 is elementary") and from the figure text ("The crystal lemma is one line"); the body states the law in prose.
- The source uses the crystal as the reference against which jittered crystals, Poisson draws and the wrapped ordinates are compared.
