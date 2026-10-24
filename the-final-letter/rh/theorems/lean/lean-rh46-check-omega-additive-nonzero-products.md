# Ω is additive on nonzero products

**Kind:** Theorem
**Status:** PROVED (Lean, no `sorry`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh46/lean/Check12.lean`](../../research/twin-prime-parity/rounds/rh46/lean/Check12.lean) — lines 9–13; declaration `Rh46.Omega_mul`

## Statement

> `theorem Omega_mul {m n : ℕ} (hm : m ≠ 0) (hn : n ≠ 0) :`
> `    Omega (m * n) = Omega m + Omega n := by`
> `  show ArithmeticFunction.cardFactors (m * n) =`
> `    ArithmeticFunction.cardFactors m + ArithmeticFunction.cardFactors n`
> `  exact ArithmeticFunction.cardFactors_mul hm hn`

with the local definition (line 6)

> `def Omega (n : ℕ) : ℕ := ArithmeticFunction.cardFactors n`

That is: for nonzero naturals `m`, `n`, the number of prime factors of `m * n`, counted with multiplicity, equals the sum of the counts for `m` and for `n`.

## Hypotheses and notation

- `Omega n = ArithmeticFunction.cardFactors n`, i.e. `Ω n = (n.primeFactorsList).length` — Mathlib's prime-factor count, counted **with multiplicity**.
- Hypotheses `hm : m ≠ 0`, `hn : n ≠ 0`; both are passed to Mathlib's lemma, and both are necessary: `Ω 0 = 0`, so at `m = 0` the identity would read `Ω n = 0`.
- The file is a scratch/tactic-probe file in namespace `Rh46` (not part of the certified module `Rh46/Chowla.lean`); it re-declares the local `Omega` (line 6) and `liouville` (`def liouville (n : ℕ) : ℤ := (-1) ^ Omega n`, line 7).

## Proof / evidence

Complete Lean proof, no `sorry`: the declaration `Rh46.Omega_mul` in `research/twin-prime-parity/rounds/rh46/lean/Check12.lean`, lines 9–13. The `show` step unfolds the local definition of `Omega`, and Mathlib's `ArithmeticFunction.cardFactors_mul hm hn` closes the goal.

The file **as a whole does not elaborate**: the second declaration of the same file, `theorem liouville_six : liouville 6 = -1` (line 15), is false (see Notes), and `Check12.lean` exits 1 with ``Tactic `rewrite` failed`` at 24:10 (inside that false declaration). I re-elaborated the file with the round's own toolchain (`leanprover/lean4:v4.35.0-rc2` + Mathlib4, `LEAN_PATH` reconstructed from `lake env` in `$HOME/lean/mathlib4`, exactly as `lean/check.sh` does); I also elaborated an isolated copy containing only the local `def Omega` together with `Omega_mul`, which exits 0 with no error and no `sorry`. So the statement is certified, but not by an elaboration of `Check12.lean` as a whole.

The same statement is proved in the round's certified development as `Rh46.Omega_mul` in [`research/twin-prime-parity/rounds/rh46/lean/Rh46/Chowla.lean`](../../research/twin-prime-parity/rounds/rh46/lean/Rh46/Chowla.lean) (lines 109–113), the module certified by `verify/lean_check.log` (`[check] OK   Rh46/Chowla.lean (23s)`) and by README §4 ("**CERTIFIED** — 456 lines, **38 theorems** … no `sorry`/`admit`/`axiom`/`native_decide`").

## Dependencies and related results

- Mathlib's `ArithmeticFunction.cardFactors_mul`; the local definition `Rh46.Omega` (`Check12.lean` line 6).
- Already harvested from the certified development under another prefix: [Ω is additive on nonzero products](lean-rh46-chowla-omega-additive-nonzero-products.md) (`Rh46/Chowla.lean`, lines 109–113); and from the scratch family: [Ω is additive on nonzero products](lean-rh46-scratch-omega-additive-nonzero-products.md) (`Scratch3.lean`, lines 21–25). This file is the third `Check*` copy of the same declaration.
- Engine of complete multiplicativity of λ: [Complete multiplicativity of λ, nonzero form](lean-rh46-chowla-liouville-completely-multiplicative.md) (`liouville_mul`, `Rh46/Chowla.lean` line 162) uses exactly `Ω(mn) = Ω(m) + Ω(n)`.
- The step `Ω(mn) = Ω(m) + Ω(n)` is also quoted verbatim in the proof of the dictionary's [Lemma 2.1 (multiplicativity)](../tpp/tpp-dict-01-liouville-completely-multiplicative.md).

## Notes

- The `Check*` family of `research/twin-prime-parity/rounds/rh46/lean/` is scratch work (tactic probes) for the round's real development `Rh46/Chowla.lean`. The source gives this declaration no prose title; the title above is the mathematical content and the Lean name is `Omega_mul`.
- **False companion in the same file, not harvested:** `theorem liouville_six : liouville 6 = -1` (`Check12.lean` line 15) is false — `Ω 6 = Ω(2 · 3) = 2`, so `λ(6) = (-1)^2 = +1`; the certified `Rh46/Chowla.lean` proves `liouville_six : liouville 6 = 1` (line 142). It is a numeral evaluation and it is wrong, so no theorem file is written for it; it is also the reason `Check12.lean` fails to elaborate. The identical error in `Scratch3.lean` (line 45) is recorded in the Notes of [Complete multiplicativity of λ, asserted without nonzero hypotheses (refuted)](lean-rh46-scratch-liouville-multiplicativity-refuted.md).
- Deliberately not harvested from this file: the definitions `Omega` (line 6) and `liouville` (line 7) (definitions are out of scope *per se*).
