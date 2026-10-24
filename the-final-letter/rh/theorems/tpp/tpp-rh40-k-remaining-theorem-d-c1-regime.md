# Theorem D — the C1 regime boundary (PROVED)

**Kind:** Theorem
**Status:** PROVED (paper argument; exhaustively verified, 399 486 cases, 0 counterexamples)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/K_remaining.md`](../../research/twin-prime-parity/rounds/rh40/K_remaining.md) — §1 "K3 — the C1 boundary. PARTIAL."

## Statement

> **Theorem D (PROVED).** If `L ≤ min( min_j d_j , a_0 , N − a_0 − 1 )` — with the convention that `min_j d_j = ∞` when `m = 0` — then
>
> ```
> p(L) = L + 1,
> ```
>
> which is the C1 law `p(L) = L + 1 + #{j : d_j < L}` in the regime where
> `#{j : d_j < L} = 0`, together with the all-zero factor.

## Hypotheses and notation

- `0 ≤ a_0 < … < a_m < N` is the support of the word; `d_j = a_j − a_{j−1}` are the consecutive gaps.
- `min_j d_j = ∞` by convention when `m = 0` (a single-one or empty-gap case).
- `p(L)` is the number of distinct length-`L` factors; the C1 law referred to is `p(L) = L + 1 + #{j : d_j < L}`.
- The conjunction `L ≤ min_j d_j`, `L ≤ a_0`, `L ≤ N − a_0 − 1` — each of the three bounds is stated to be necessary.

## Proof / evidence

The source gives the proof in full:

> *Proof.* `L ≤ min_j d_j` means the ones are at least `L` apart, so every window of length `L` contains **at most one** 1. Hence each non-zero factor is a singleton `{x}` with `0 ≤ x ≤ L−1`, and different windows give different `x` (the window is `[a_j − x, a_j − x + L − 1]`). The singleton factors are realised for exactly the offsets `x` with `a_0 − L + 1 ≤ a_0 − x ≤ min(a_0, N − L)`, i.e. the `L` values `x = 0 … L−1` when `L ≤ min(a_0, N−L)`; that is the `min_j d_j`, `a_0` and `N−a_0−1` conjunction in the statement. `L ≤ N−a_0−1` additionally makes the all-zero window available, which is the `+1`. ∎

**Verified exhaustively and unconditionally** (§1): the implication was checked on **399 486** (support, L) cases over all supports with `m+1 ≤ 4`, `N ≤ 31`, with **zero counterexamples**. The source also records the necessity of each of the three constraints:

- `L ≤ min_j d_j` — without it two ones can share a window and the singletons merge;
- `L ≤ a_0` — for `ones = (1,)`, `N = 3`, `L = 2` the offsets needed are `{0, 1}` but offset `1` would need a window starting at `0`, and `L ≤ a_0` fails (`2 > 1`); the window set is `[max(0,a_0−L+1), min(a_0, N−L)] = [1, 1]`, giving only offset `0`;
- `L ≤ N − a_0 − 1` — this is what makes the all-zero window exist, and hence what supplies the `+1`.

## Dependencies and related results

- [Theorem A (the large-`L` regime)](tpp-rh40-k1-theorem-a-large-l-regime.md) — the complementary large-`L` law; Theorem D is the source's own answer to the boundary where the C1 law still holds.
- [Theorem 5 (C1 regime)](tpp-rh41-truths-theorem-5-c1-regime.md) — the same regime statement in the later round; see Notes.
- The source's §5 upgrade table records C1 ("`p(L) = L+1` for `L ≤ min gap`") and F1 ("C1 law for `L ≤ min gap`") as upgraded `verified → PROVED` (K3 Theorem D).
- Refuted candidates recorded in the same section and **not** harvested as theorems: the two-branch equivalence `C1 holds at L ⟺ L ≤ 1 + min_j d_j or L > max_j d_j` (false on 65.6 % of 1 772 281 cases) and the single-one law `p(L) = min(L, a_0, N−L+1) + [N−L > a_0]` (false at `a = 0, N = 1, L = 1`); the corrected single-one law `p(L) = min(L, a) + [N−L > a]` away from that degenerate case was checked over all `0 ≤ a < 40`, `N < 40`.

## Notes

- **Restatement round.** The same regime is "Theorem 5 (C1 regime)" in the later round `research/twin-prime-parity/rounds/rh41/TRUTHS.md`, already harvested as [tpp-rh41-truths-theorem-5-c1-regime.md](tpp-rh41-truths-theorem-5-c1-regime.md), where it is formalised in Lean (`DigitWord.complexity_c1`, no `sorry`) with the three necessity counterexamples; the `rh40` source offers the paper argument and the exhaustive check instead.
- **Honest status (§1, source's own).** "The *regime* in which the C1 law holds is now characterised by Theorem D (proved). The **boundary** — the largest `L` at which the C1 law still holds, i.e. `span`-adjacent behaviour — remains **OPEN**". The source also states the four-examples failure-mode lesson and that register J13/F4/E4 carries six refuted candidates; §5's table records F3 ("exact C1 condition") as `verified → REFUTED`.
- K3 as a whole is labelled **PARTIAL** in the source's §0 summary.
- Quantities quoted exactly as printed: `399 486` cases, `m+1 ≤ 4`, `N ≤ 31`, `0` counterexamples, `65.6 %` of `1 772 281` cases, `26 %`, `0 ≤ a < 40`, `N < 40`.
