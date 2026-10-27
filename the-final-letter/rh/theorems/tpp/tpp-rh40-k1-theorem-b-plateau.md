# Theorem B (the plateau, = C2a)

**Kind:** Theorem
**Status:** PROVED (paper argument; exhaustively machine-corroborated; not formalised in Lean)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/K1_plateau_theorem.md`](../../research/twin-prime-parity/rounds/rh40/K1_plateau_theorem.md) — §1 "Statement"; proof in §2 "Proof of Theorem B"

## Statement

> ### Theorem B (the plateau, = C2a)
>
> *For* `max(span, a_m + 1) ≤ L ≤ N − a_m − 1`*, in particular for every `L` in the plateau range,*
>
> ```
> p(L) = a_m + 2.
> ```

The source adds: "Hence `max_L p(L) ≥ a_m + 2`, and by Theorem A no larger value occurs in the large-`L` regime. The plateau **value** is a function of `a_m` alone, which is exactly the phenomenon register entry E3 recorded as an obstruction to any `(m, span, N)` formula."

## Hypotheses and notation

- `0 ≤ a_0 < a_1 < … < a_m < N` is the support of a word `w` of length `N`; `span := a_m − a_0`.
- `F(t) = { a − t : a ∈ {a_0,…,a_m}, t ≤ a ≤ t + L − 1 }`, `p(L) = #{ F(t) : 0 ≤ t ≤ N − L }` for a truncation of length `N`.
- The hypothesis is read together with the lower end of the plateau range: the theorem needs `max(span, a_m + 1) ≤ N − a_m − 1` to be satisfiable for some `L`; the source records that "the dialogue words all satisfy `a_m + 1 ≤ N − a_m − 1`, i.e. `N ≥ 2a_m + 2`, and `span ≤ a_m − 1` when `a_0 ≥ 1`".
- The result is the closure of register entry K1 and, with it, sub-target C2a of HANDOFF.md §4.

## Proof / evidence

> ### Proof of Theorem B
>
> Put `L ≤ N − a_m − 1`. Then the indicator in Theorem A is 1, and `min(a_m + 1, N − L + 1) = a_m + 1` because `N − L + 1 ≥ a_m + 2`. Sum: `a_m + 2`. For the **lower** end of the plateau range we need `max(span, a_m + 1)` to be ≤ `N − a_m − 1` for some `L`; the dialogue words all satisfy `a_m + 1 ≤ N − a_m − 1`, i.e. `N ≥ 2a_m + 2`, and `span ≤ a_m − 1` when `a_0 ≥ 1`. ∎

The source also records §3(a): "**K1 and C2a are closed.** `max p = a_m + 2` on the plateau is now a theorem, not a measurement. The proof is three short lemmas, and its crux is one line: *the maximum offset of a factor containing `a_m` is `a_m − t`, which recovers `t`*."

Machine corroboration (§4): `rh40/verify/plateau_theorem.py` "also re-checks Theorem B (the `a_m + 2` corollary) and the decay law `p(L) = N − L + 1` on the same corpus" of 242 295 (support, L) pairs over 36 424 supports. The regression gate carries `test_plateau_value_is_am_plus_2_dialogue` and `test_plateau_full_dialogue_words` (marked `slow`, N = 13000 sweep).

## Dependencies and related results

- [Theorem A (the large-`L` regime)](tpp-rh40-k1-theorem-a-large-l-regime.md) — the general formula this specialises.
- [Corollary 2 (plateau)](tpp-rh41-truths-corollary-2-plateau.md) — the same plateau statement in the later round; see Notes.
- [Corollary 4](tpp-rh41-truths-corollary-4-max-complexity.md) — turns the plateau value into `max_L p(L) = a_m + 2` when `N ≥ 2a_m + 2`.
- Register upgrades recorded in the source's §5 table: E1 (`max p = a_m + 2`, verified → **PROVED** (K1)), E6 (plateau ends at `N−a_m−1`, verified → **PROVED** (K1)).

## Notes

- **Restatement round.** The same statement is "Corollary 2 (plateau)" in the later round `research/twin-prime-parity/rounds/rh41/TRUTHS.md`, already harvested as [tpp-rh41-truths-corollary-2-plateau.md](tpp-rh41-truths-corollary-2-plateau.md). That later round formalised it in Lean as `DigitWord.complexity_plateau` (no `sorry`); the `rh40` source asserts no Lean formalisation here.
- **Honest boundary (source's own).** Theorem B proves `p(L) = a_m + 2` on `[max(span, a_m+1), N−a_m−1]`, but "the *measured* plateau for the dialogue words starts slightly **earlier**", on an interval of length `≤ span` below `a_m + 1`. The source's table gives, for each word, proven vs measured plateau: 1/π `(2,13,607), N=1400`, `a_m = 607`, `span = 605`, proven `[608, 792]` (185 values), measured `[605, 792]` (188); log 2 `(0,4,36,6069), N=13000`, `a_m = 6069`, `span = 6069`, proven `[6070, 6930]` (861), measured `[6065, 6930]` (866); √2−1 `(1,11,251), N=2000`, `a_m = 251`, `span = 250`, proven `[252, 1748]` (1497), measured `[250, 1748]` (1499); `(10,20,40,80), N=500`, `a_m = 80`, `span = 70`, proven `[81, 419]` (339), measured `[60, 419]` (360); true e−2 `(0,3,53), N=2000`, `a_m = 53`, `span = 53`, proven `[54, 1946]` (1893), measured `[53, 1946]` (1894). "That is register **K2** (the plateau onset), which remains open; the theorem above deliberately does not claim it."
- §3(c): "The plateau end is proved. `L = N − a_m − 1` is exactly where the indicator in Theorem A flips, so the plateau **cannot** extend past it."
