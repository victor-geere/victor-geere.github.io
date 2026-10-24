# A gap of exactly 2 forces rh41's C1 minimum-gap parameter to satisfy `L ≤ 2`

**Kind:** Theorem
**Status:** PROVED (Lean, no sorry)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh42/lean/Rh42/Tau.lean`](../../research/twin-prime-parity/rounds/rh42/lean/Rh42/Tau.lean) — `c1_range_le_two_of_gap_eq_two` (lines 347–351); `GapsAtLeast` (lines 336–337); `two_le_of_even_pos` (lines 340–342)

## Statement

> If a support has a gap equal to `2`, then rh41's C1 hypothesis `GapsAtLeast S L` forces `L ≤ 2`. Combined with `support_gap_even`, this is the honest structural consequence of the parity lock for the complexity law.
>
> Lean statement (`c1_range_le_two_of_gap_eq_two`):
>
> `(S : Finset ℕ) {a b : ℕ} (ha : a ∈ S) (hb : b ∈ S) (hab : a < b) (hg : b - a = 2) {L : ℕ} (hgap : GapsAtLeast S L) : L ≤ 2`
>
> with the hypothesis predicate (`GapsAtLeast`):
>
> `def GapsAtLeast (S : Finset ℕ) (L : ℕ) : Prop := ∀ a ∈ S, ∀ b ∈ S, a < b → L ≤ b - a`

## Hypotheses and notation

- `S : Finset ℕ` is a finite support (in the application, the parity-locked support of the signed greedy word) and `L : ℕ` is rh41's C1 range parameter.
- Hypotheses: `a, b ∈ S` with `a < b` (`ha`, `hb`, `hab`), the gap is exactly two (`hg : b - a = 2`), and every pair of support points is at distance `≥ L` (`hgap : GapsAtLeast S L`).
- `Rh41.complexity` and `Rh41.complexity_c1` are the factor-complexity law of the rh41 development, imported by `Rh42/Tau.lean` (`import Rh41.DigitWord`); the law itself is stated in the rh41 source, not here.

## Proof / evidence

Machine-checked in `Rh42/Tau.lean` as the `theorem` `c1_range_le_two_of_gap_eq_two`: `hgap a ha b hb hab` gives `L ≤ b - a`, and `hg : b - a = 2` closes the goal by `omega`. No `sorry`/`admit`/`axiom`/`native_decide` occurs in the file.

## Dependencies and related results

- Uses the parity-lock gap structure [`lean-rh42-tau-even-gaps.md`](lean-rh42-tau-even-gaps.md): the module docstring states that for a support with a gap of exactly `2` the C1 minimum-gap hypothesis can only hold for `L ≤ 2`.
- The concrete instance of the law on `{2, 4}` is [`lean-rh42-tau-c1-example-support-2-4.md`](lean-rh42-tau-c1-example-support-2-4.md).
- The rh42 Lean README lists this row as "the C1 regime" ↔ `GapsAtLeast`, `two_le_of_even_pos`, `c1_range_le_two_of_gap_eq_two`, `complexity_c1_example`.

## Notes

- The helper `two_le_of_even_pos` ("an even positive natural number is at least `2`", proved from `Even d` and `0 < d` by `omega`) is an elementary arithmetic fact and is not harvested separately; it is not used by the statement above.
- This declaration concerns rh41's C1 hypothesis only; it does not state or reprove the C1 law itself.
