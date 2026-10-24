# THEOREM (Landau; the parity classes have equal density 1/2)

**Kind:** Theorem
**Status:** CITED (literature; classical, equivalent to PNT)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/03-parity-problem.md`](../../research/twin-prime-parity/dictionary/03-parity-problem.md) — §1.1, after Definition 1.5

## Statement

> **THEOREM (Landau; the parity classes have equal density 1/2).** The one-point average `Σ_{n≤x} λ(n) = o(x)`, hence `#{n ≤ x : n ∈ E} = x/2 + o(x)` and likewise for `O`.

The file adds: "This is *equivalent* to PNT (see §4.1, row T1). So the parity classes are **known** to be balanced *on average* — this is not the parity problem."

## Hypotheses and notation

- `E = {n ≥ 1 : Ω(n) even} = {n : λ(n) = +1}`, `O = {n ≥ 1 : Ω(n) odd} = {n : λ(n) = −1}` are the **parity classes**, and `λ = 1_E − 1_O` is their signed indicator (Definition 1.5).
- `λ(n) = (−1)^{Ω(n)}` (Definition 1.2); `Ω` counts prime factors with multiplicity (Definition 1.1).
- `o(x)` is as `x → ∞`.

## Proof / evidence

- The source states the result and its equivalence to PNT, citing §4.1 row **T1** ("`Σ_{n≤x}λ(n) = o(x) ⟺` PNT | THEOREM | classical (Landau); stated in [1509.01545] §1, [1605.04628] §1 | **verified** (abstracts read verbatim)").
- No proof is written out in this file; the equivalence is the content of THEOREM 3.3.

## Dependencies and related results

- Definition 1.2 (`λ`); Definition 1.5 (parity classes).
- Same statement as [THEOREM 3.3 (one-point Chowla ⟺ PNT)](tpp-dict-03-one-point-chowla-iff-pnt.md) and as ledger row **T1** of §4.1.
- Related: the barrier rows of §6 (`F1`–`F9`) and the open target of OPEN 3.4.

## Notes

- This is a classical result (Landau) that the dictionary sets out as a labelled THEOREM rung of its own argument, so it is harvested with Status CITED (literature).
- The source explicitly contrasts it with the parity problem: the one-point balance is **known**; it is the two-point correlation (OPEN 3.4) that is open.
- Restatements to note: §4.1 row **T1**, and the §7 ledger row "1.5".
