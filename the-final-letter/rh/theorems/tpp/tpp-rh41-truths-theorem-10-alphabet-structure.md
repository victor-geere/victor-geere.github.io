# Theorem 10 (structure, corrected)

**Kind:** Theorem
**Status:** PROVED (paper argument; Lean with an added hypothesis)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh41/TRUTHS.md`](../../research/twin-prime-parity/rounds/rh41/TRUTHS.md) — §4 "Alphabets `α_n = (n+2)^{−p}` and the inverse problem"

## Statement

> **Theorem 10 (structure, corrected).** For `α_n = (n+2)^{−p}`, `x = 1`, `p > 1`, with `S = ζ(p) − 1`:
>
> | case | word | halts? | gaps |
> |---|---|---|---|
> | `S < 1` (`p > p*`) | `1^∞` | never | all 1 |
> | `S = 1` (`p = p*`) | `1^∞` | at the limit | all 1 |
> | `S > 1` (`1 < p ≤ p*`) | `1^{N−1} 0… 1 0… 1 …` | **never** | **unbounded** |
>
> *Proof of the third row.* After the initial segment ends at `N = min{n : Σ_{k<n} α_k ≥ 1}`, the residual `r = 1 − Σ_{k<N−1} α_k` is a fixed positive number, while `α_k → 0`; so `{k : α_k ≤ r}` is an infinite tail, each member is taken, and the residual never reaches 0. ∎
>
> Concretely for `p = 3/2`: taken `= {0,…,8, 34, 954, 77716, …}` with max gap 76 762.

## Hypotheses and notation

- `α_n = (n+2)^{−p}` with `p > 1`; target `x = 1`; `S = ζ(p) − 1`.
- `p*` is the root of `ζ(p) = 2` of [Theorem 9](tpp-rh41-truths-theorem-9-halting-criterion.md): the cases are `p > p*` (`S < 1`), `p = p*` (`S = 1`) and `1 < p ≤ p*` (`S > 1`).
- `N = min{n : Σ_{k<n} α_k ≥ 1}` is the length of the initial segment `1^{N−1}`; the residual after it is `r = 1 − Σ_{k<N−1} α_k`.
- "Halts? at the limit" is the source's own phrase for the borderline case `S = 1`.

## Proof / evidence

The source gives a written proof of the third row (quoted verbatim above). No proof text is given for the first two rows.

Machine-checked in `Rh41/Alphabet.lean`:
- rows 1 and 2 shape: `taken_all_of_bounded_partial_sums_mono`, `partial_sums_iff`;
- row 3: `exists_taken_ge`, `never_halts_of_tendsto_zero`, `powerAlpha_never_halts`, `powerAlpha_infinitely_many_taken`, where `powerAlpha` is `(n+2)^{-p}` for natural `p ≥ 1`.

## Dependencies and related results

- [Theorem 9 (halting criterion)](tpp-rh41-truths-theorem-9-halting-criterion.md) — supplies `p*` and the (refuted) printed criterion.
- [Theorem 11 (dichotomy false)](tpp-rh41-truths-theorem-11-dichotomy-false.md).
- [Refuted — `α_n = (n+2)^{−3/2}` has bounded gaps](tpp-rh41-truths-refuted-power-alpha-bounded-gaps.md) — the §5 row for the concrete `p = 3/2` data.
- [Correction 3 — Theorem 10 row 3 needs an extra hypothesis](tpp-rh41-lean-readme-correction-3-theorem-10-row-3.md).

## Notes

- The title "(structure, corrected)" is the source's own: it already labels the result as corrected.
- The round's Lean README records that **row 3 needs an extra hypothesis**: "the residual never reaches `0`" is not automatic; it needs "no finite sub-sum of the alphabet equals `x`". `Alphabet.never_halts_of_tendsto_zero` states the theorem with this hypothesis made explicit; for `α_n = (n+2)^{-p}`, `x = 1` it holds by irrationality of the sub-sums (not formalised).
- The concrete orbit data (`taken = {0,…,8, 34, 954, 77716, …}`, max gap `76 762`) is listed by the Lean README under "Not formalised", as is the decimal `p*`.
