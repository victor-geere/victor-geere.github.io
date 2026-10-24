# record correction: one-point Chowla is equivalent to PNT

**Kind:** Claim
**Status:** CITED (literature; the source asserts the equivalence without proof or named attribution)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh47/README.md`](../../research/twin-prime-parity/rounds/rh47/README.md) — closing "Record correction" block, line 100

## Statement

> **Record correction (from the research harvest at [`../../twin-prime-parity/`](../../research/twin-prime-parity/rounds/rh47/README.md)).**  The harvested files correct two items in this round's documentation: the inherited claim that one-point Chowla is open (it is **equivalent to PNT**), and this round's own barrier phrasing ("additive character in `log n`"), which the audit showed is too wide — read it as *sign-blind alphabet, no arithmetic input*, with the impossibility kept **OPEN**.

The harvested claim being corrected: the inherited statement that one-point Chowla is open. The correction is that one-point Chowla is **equivalent to PNT**.

## Hypotheses and notation

- One-point Chowla is the statement `Σ_{n≤x} λ(n) = o(x)` with `λ(n) = (−1)^{Ω(n)}` the Liouville function.
- PNT is the prime number theorem.

## Proof / evidence

The source states the equivalence without proof and attributes the correction to the research harvest at `research/twin-prime-parity/`. No named citation is given. The source states this without proof.

## Dependencies and related results

- [The two-point Chowla statement `Σ_{n≤x} λ(n)λ(n+2) = o(x)`](tpp-dict-00-un-averaged-two-point-chowla-open.md) — the *two-point* analogue, which the sources keep **open**; the correction here concerns the one-point statement only.
- [The corrected barrier](tpp-rh47-truths-corrected-barrier-open.md) — the second item of the same record correction.
- Restated in HANDOFF: [record correction](tpp-rh47-handoff-one-point-chowla-pnt.md).

## Notes

- This is a **correction of an inherited claim** (recorded in the harvested files), not a result proved in this round. The source gives neither proof nor named attribution; the equivalence is asserted.
- The second half of the same block corrects this round's own barrier phrasing and keeps the impossibility **OPEN**; that half is recorded in the barrier file.
