# record correction: one-point Chowla is equivalent to PNT (HANDOFF)

**Kind:** Claim
**Status:** CITED (literature; the source asserts the equivalence without proof or named attribution)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh47/HANDOFF.md`](../../research/twin-prime-parity/rounds/rh47/HANDOFF.md) — closing "Record correction" block, line 180

## Statement

> **Record correction (from the research harvest at [`../../twin-prime-parity/`](../../research/twin-prime-parity/rounds/rh47/README.md)).**  The harvested files correct two items in this round's documentation: the inherited claim that one-point Chowla is open (it is **equivalent to PNT**), and this round's own barrier phrasing ("additive character in `log n`"), which the audit showed is too wide — read it as *sign-blind alphabet, no arithmetic input*, with the impossibility kept **OPEN**.

The harvested claim being corrected: the inherited statement that one-point Chowla is open. The correction is that one-point Chowla is **equivalent to PNT**.

## Hypotheses and notation

- One-point Chowla is the statement `Σ_{n≤x} λ(n) = o(x)`, with `λ(n) = (−1)^{Ω(n)}` the Liouville function.
- PNT is the prime number theorem.

## Proof / evidence

The source states the equivalence without proof and attributes the correction to the research harvest at `research/twin-prime-parity/`. No named citation is given. The source states this without proof.

## Dependencies and related results

- [The two-point Chowla statement `Σ_{n≤x} λ(n)λ(n+2) = o(x)`](tpp-dict-00-un-averaged-two-point-chowla-open.md) — the *two-point* analogue, which the sources keep **open**; the correction concerns the one-point statement only.
- [The corrected barrier](tpp-rh47-handoff-barrier-additive-character-open.md) — the second item of the same record correction.
- Restated in the README: [record correction](tpp-rh47-readme-one-point-chowla-pnt.md).

## Notes

- This is a **correction of an inherited claim** (recorded in the harvested files), not a result proved in this round. The source gives neither proof nor named attribution; the equivalence is asserted.
- The second half of the same block corrects this round's own barrier phrasing and keeps the impossibility **OPEN**; that half is recorded in the barrier file.
- The HANDOFF's own item list also carries the note under R5 that one-point Chowla's status is the correction, in contrast to the round's two-point target `(★)`, which stays open.
