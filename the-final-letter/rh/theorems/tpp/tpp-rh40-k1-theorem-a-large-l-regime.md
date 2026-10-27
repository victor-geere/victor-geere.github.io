# Theorem A (the large-`L` regime)

**Kind:** Theorem
**Status:** PROVED (paper argument; exhaustively machine-corroborated, 242 295 cases, 0 counterexamples; not formalised in Lean)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/K1_plateau_theorem.md`](../../research/twin-prime-parity/rounds/rh40/K1_plateau_theorem.md) — §1 "Statement"; proof in §2

## Statement

> ### Theorem A (the large-`L` regime)
>
> *For* `max(span, a_m + 1) ≤ L ≤ N − 1`*,*
>
> ```
> p(L) = min(a_m + 1, N − L + 1) + [ L ≤ N − a_m − 1 ].
> ```

The source's §3(b) records the specialisation: Theorem A with `L ≥ N − a_m` gives
`min(a_m+1, N−L+1) = N−L+1` and indicator `0`, i.e. `p(L) = N − L + 1` — register E5,
"now also proved rather than measured".

## Hypotheses and notation

- `0 ≤ a_0 < a_1 < … < a_m < N` is the support of a word `w` of length `N` (so `w` has `m+1` ones).
- `span := a_m − a_0` (equal to `0` if `m = 0`); `d_j := a_j − a_{j−1}` for `1 ≤ j ≤ m`.
- For a window start `t ∈ [0, N−L]`, `F(t) := { a − t : a ∈ {a_0,…,a_m},  t ≤ a ≤ t + L − 1 }` is the offset tuple of the length-`L` factor at `t`.
- `p(L) = #{ F(t) : 0 ≤ t ≤ N − L }` (register B1/B2).
- `[·]` is the Iverson bracket; `[ L ≤ N − a_m − 1 ]` is `1` exactly when that inequality holds.
- The hypothesis `L ≤ N − 1` bounds `L` below the truncation length.
- The source stresses that the statement is conditional on `L ≥ max(span, a_m+1)` and that it holds for *any* finitely supported 0/1 word — "the plateau law is not arithmetic, it is combinatorial".

## Proof / evidence

The source proves it in §2, in three short lemmas:

- [Lemma 1 (a window has multiplicity one, and is recognised by its last offset)](tpp-rh40-k1-lemma-1-window-multiplicity-one.md) — under `L ≥ span`, the map `t ↦ F(t)` is injective on the windows containing `a_m`.
- [Lemma 2 (how many windows contain `a_m`, and whether they are non-zero)](tpp-rh40-k1-lemma-2-windows-containing-a-m.md) — under `L ≥ a_m + 1` the count is `min(a_m + 1, N − L + 1)`, and a window avoiding `a_m` exists iff `L ≤ N − a_m − 1`, contributing the single all-zero factor.
- Lemma 3 (the earlier parameter range `span ≤ L ≤ a_m`) — the same conclusion by the same argument; it is why the hypothesis carries `max(span, a_m + 1)`.

Machine corroboration (§4): `rh40/verify/plateau_theorem.py` exhaustively checks Theorem A over **all** supports with `0 ≤ a_0 < … < a_m < N`, `1 ≤ m+1 ≤ 4`, `3 ≤ N ≤ 31`, for every `L` in `max(span, a_m+1) ≤ L ≤ N−1`:

```
supports: 36 424 ; (support, L) pairs: 242 295 ; counterexamples: 0
```

It also re-checks Theorem B and the decay law on the same corpus, and the four dialogue words at their published truncations. The regression gate carries `test_plateau_theorem_exhaustive` (`m+1 ≤ 4`, `N ≤ 22`, ~11 000 cases), `test_plateau_value_is_am_plus_2_dialogue`, `test_decay_law_is_proved_by_theorem_a`, and the `slow`-marked `test_plateau_full_dialogue_words` (`N = 13000` sweep).

## Dependencies and related results

- [Theorem B (the plateau, = C2a)](tpp-rh40-k1-theorem-b-plateau.md) — the plateau value `a_m + 2` obtained from Theorem A by putting `L ≤ N − a_m − 1`.
- [Lemma 1](tpp-rh40-k1-lemma-1-window-multiplicity-one.md), [Lemma 2](tpp-rh40-k1-lemma-2-windows-containing-a-m.md).
- [Theorem 1 (main)](tpp-rh41-truths-theorem-1-complexity-main.md) — the same formula harvested from the later round [`rounds/rh41/TRUTHS.md`](../../research/twin-prime-parity/rounds/rh41/TRUTHS.md); see Notes.
- [P1 — the factor-complexity law](tpp-dict-05-factor-complexity-law.md) — the dictionary statement of the same law.
- Register entries E7, E5, D3, D5 (the source's §5 "Upgrades from `VERIFIED` to `PROVED`" table records D3, D5, E5, E7 as upgraded to `PROVED` (K1 Theorem A)).

## Notes

- **Restatement round.** The identical formula is stated as "Theorem 1 (main)" in the later round `research/twin-prime-parity/rounds/rh41/TRUTHS.md` and is already harvested as [tpp-rh41-truths-theorem-1-complexity-main.md](tpp-rh41-truths-theorem-1-complexity-main.md). In that later round the statement was formalised in Lean (`Rh41/DigitWord.lean`, no `sorry`) and its `span` hypothesis was shown redundant; the `rh40` source makes neither claim for this result ("The proof is not formalised in Lean").
- The source explicitly records (§3(e)) that the formula is exactly `min(a_m+1, N−L+1) + [L ≤ N−a_m−1]` and **not** `min(a_m+2, N−L+1)`: register E7 records that the simpler form fails for `L` below the plateau onset.
- The statement is only claimed for `L ≥ max(span, a_m+1)`; §5 says "Theorem A says nothing for `L < max(span, a_m+1)`", and the plateau onset K2 and the C1 boundary K3 remain open.
- "`span` is inherited as an assumption": nothing here constrains the word to be the greedy digit word.
- Quantities quoted exactly as printed: `36 424` supports, `242 295` (support, L) pairs, `0` counterexamples, `3 ≤ N ≤ 31`, `1 ≤ m+1 ≤ 4`.
