# Theorem 14, even gaps: the support of the Tau greedy word is parity-locked, so its gaps are even and at least 2

**Kind:** Theorem
**Status:** PROVED (Lean, no sorry)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh42/lean/Rh42/Tau.lean`](../../research/twin-prime-parity/rounds/rh42/lean/Rh42/Tau.lean) — `support_subset_even` (lines 260–271), `support_subset_odd_of_neg` (lines 274–285), `support_gap_even_and_two_le` (lines 289–295), `support_gap_even` (lines 298–305), `support_gap_even_and_two_le_of_neg` (lines 310–316), `support_gap_even_of_neg` (lines 319–326)

## Statement

> The support of the word of a positive target consists of even indices, and the support of a negative target consists of odd indices:
>
> `0 < x → ∀ n ∈ support p x N, Even n`
>
> `x < 0 → ∀ n ∈ support p x N, Odd n`
>
> **Even gaps.** For a positive target, consecutive taken indices differ by at least `2` (they are both even, so their difference is even and nonzero), and the gap between any two taken indices is even:
>
> `0 < x → a ∈ support p x N → b ∈ support p x N → a < b → 2 ≤ b - a`
>
> `0 < x → a ∈ support p x N → b ∈ support p x N → Even (b - a)`
>
> The mirror statements hold for a negative target:
>
> `x < 0 → a ∈ support p x N → b ∈ support p x N → a < b → 2 ≤ b - a`
>
> `x < 0 → a ∈ support p x N → b ∈ support p x N → Even (b - a)`
>
> Lean statements:
>
> `support_subset_even (p : ℕ) {x : ℚ} (hx : 0 < x) (N : ℕ) : ∀ n ∈ support p x N, Even n`
>
> `support_subset_odd_of_neg (p : ℕ) {x : ℚ} (hx : x < 0) (N : ℕ) : ∀ n ∈ support p x N, Odd n`
>
> `support_gap_even_and_two_le (p : ℕ) {x : ℚ} (hx : 0 < x) {N a b : ℕ} (ha : a ∈ support p x N) (hb : b ∈ support p x N) (hab : a < b) : 2 ≤ b - a`
>
> `support_gap_even (p : ℕ) {x : ℚ} (hx : 0 < x) {N a b : ℕ} (ha : a ∈ support p x N) (hb : b ∈ support p x N) : Even (b - a)`
>
> `support_gap_even_and_two_le_of_neg (p : ℕ) {x : ℚ} (hx : x < 0) {N a b : ℕ} (ha : a ∈ support p x N) (hb : b ∈ support p x N) (hab : a < b) : 2 ≤ b - a`
>
> `support_gap_even_of_neg (p : ℕ) {x : ℚ} (hx : x < 0) {N a b : ℕ} (ha : a ∈ support p x N) (hb : b ∈ support p x N) : Even (b - a)`

## Hypotheses and notation

- `support p x N` is the support of the greedy word within the truncation `[0, N)`: the `Finset` of taken indices below `N`, `(Finset.range N).filter (fun n => tauTaken p x n)`.
- Hypotheses: `p, N : ℕ`; the target `x : ℚ` satisfies `0 < x` (positive case) or `x < 0` (negative mirror); `a, b ∈ support p x N` are taken indices, with `a < b` for the `≥ 2` gap statements.
- `support_gap_even` and `support_gap_even_of_neg` carry no ordering hypothesis; when `b ≤ a` the gap `b - a` is `0`, which is even.

## Proof / evidence

Machine-checked in `Rh42/Tau.lean` by the six `theorem`s named above.

- `support_subset_even`: every residual of a positive target is nonnegative (`tauResidual_nonneg`) and a take forces it to be positive, so the parity lock (`take_parity`) applies. `support_subset_odd_of_neg` is the mirror.
- `support_gap_even_and_two_le` writes the two taken indices as `2i` and `2j` with `i < j` and concludes `2 ≤ 2j - 2i` by `omega`; the `_of_neg` mirror is identical with odd indices.
- `support_gap_even` (and its mirror) reduces to the parity of the two indices.

No `sorry`/`admit`/`axiom`/`native_decide` occurs in the file.

## Dependencies and related results

- Uses the parity lock [`lean-rh42-tau-parity-lock.md`](lean-rh42-tau-parity-lock.md) and the residual sign [`lean-rh42-tau-residual-sign.md`](lean-rh42-tau-residual-sign.md).
- The transfer of the even-gap structure to rh41's C1 law is [`lean-rh42-tau-c1-range-gap-two.md`](lean-rh42-tau-c1-range-gap-two.md).
- The rh42 Lean README lists this row as "Theorem 14, even gaps" ↔ `support_subset_even`, `support_subset_odd_of_neg`, `support_gap_even_and_two_le`, `support_gap_even` (and the `_of_neg` mirrors).

## Notes

- All six declarations of the README's "even gaps" row are folded into this file: the support-parity statements that make the gaps even, and the gap statements themselves, for a positive and a negative target.
- The module docstring states the consequence used downstream: "the support of the signed word is parity-locked, so all of its gaps are even and at least `2`".
