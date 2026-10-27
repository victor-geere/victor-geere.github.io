# (9) The silence — the main term cancels exactly

**Kind:** Theorem
**Status:** CITED (literature; the source calls it classical and recomputes it live)
**Area:** xi-horn
**Source:** [`xi-horn/prime-horn.html`](../../xi-horn/prime-horn.html) — §1 "The construction", theorem box "the silence, and the ring", item (9)

## Statement

> **(9)** ∫ φ<sub>1</sub>(w)e<sup>w/2</sup>dw = C(1)/2 = 0 exactly, where C(s) = ½s(s−1)π<sup>−s/2</sup>Γ(s/2). The bump arrives pre-balanced; nothing was tuned.

## Hypotheses and notation

- φ<sub>1</sub> is the horn's own bump, shell 1 of the integer horn at n = 1: φ<sub>1</sub>(u) = (2π²e<sup>9u/2</sup> − 3πe<sup>5u/2</sup>)·e<sup>−πe<sup>2u</sup></sup> (the source cites INTEGERS.md (14) at n = 1).
- C(s) = (s−1)π<sup>−s/2</sup>Γ(s/2 + 1), which equals ½s(s−1)π<sup>−s/2</sup>Γ(s/2) by s·Γ(s/2) = 2Γ(s/2 + 1), and is regular at s = 0 (source script comment). The (s−1) factor is the Riemann factor inserted to kill ζ's pole.
- The source writes the integral with no limits displayed, as ∫ φ<sub>1</sub>(w)e<sup>w/2</sup>dw.
- C(1)/2 = 0 because C(s) carries the factor (s−1).

## Proof / evidence

The source states this without proof, as one of "two facts [that] organise the picture, both classical, both computed live below"; the mechanism it gives is that "the completion factor C(s) carries the very (s−1) Riemann inserted to kill ζ's pole." The page recomputes the horn live in double precision (Λ-sieve, twenty ordinates), and its footer reports verification against mpmath at 30 digits: "the ledger to 2×10<sup>−7</sup> relative, the §3.3 table to all nine printed digits."

## Dependencies and related results

- Horn construction and the bump: [horn-helix-revisited.md](../../xi-horn/horn-helix-revisited.md) (6)–(7); [INTEGERS.md](../../xi-horn/INTEGERS.md) (14); [horn-helix.md](../../xi-horn/horn-helix.md).
- Companion statement (10) of the same theorem box: [the ring and the near field](xihorn-prime-horn-ring-and-near-field.md).

## Notes

- The abstract restates the same fact in prose: "The **main term is silent** — the prime number theorem loads e<sup>v/2</sup> of mass under the bump at depth v and it cancels to nothing, because the completion factor C(s) carries the very (s−1) Riemann inserted to kill ζ's pole."
- The source is explicit that the vanishing is not engineered: "The bump arrives pre-balanced; nothing was tuned."
- The source's §4 warning ("It is not evidence", "The agreement is consistency, not confirmation") qualifies only the numerical illustration; the statement itself is an exact identity.
