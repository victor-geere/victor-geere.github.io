# Plateau value = a_m + 2

**Kind:** Claim
**Status:** VERIFIED (numerical; 255/255 N = 20 words and 744/744 random supports, zero counterexamples; the proof is recorded separately in K1_plateau_theorem.md)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/README.md`](../../research/twin-prime-parity/rounds/rh40/README.md) — §4 "Corrections established at programme open" (lines 105–110)

## Statement

> **Plateau value = a_m + 2.** On the plateau p(L) = a_m + 2 exactly: 607+2 = 609, 6069+2 = 6071, 251+2 = 253, 80+2 = 82. Agent B verified this on 255/255 N = 20 words and 744/744 random supports satisfying N ≥ 2a_m + 3, with zero counterexamples; it is a function of **a_m alone**, which is why the handoff's attempt to read it off `(m, span, N)` could not work. The `a_m + 2` form is verified but **not yet proved** — the proof is round 1's open item.

## Hypotheses and notation

- `0 ≤ a_0 < … < a_m < N` is the support of the truncation `w_N`; `a_m` is the last 1.
- `p(L)` is the number of distinct length-`L` factors; "the plateau" is the interval of `L` on which `p` is constant at its maximum.
- The positive verification requires `N ≥ 2a_m + 3`, which the README elsewhere identifies as the same eligibility condition under which the single-one law holds ("the non-degenerate regime is exactly where the plateau exists").
- The four instances 609, 6071, 253, 82 correspond to supports `{2,13,607}` at `N = 1400`, `{0,4,36,6069}` at `N = 13000`, `{1,11,251}` at `N = 2000`, and `(10,20,40,80)` at `N = 500` (the last labelled "e−2" in the source; see Notes).

## Proof / evidence

At the time this §4 item was written, the source records the law as "verified but **not yet proved**". The README's own §5.0 then records the closure: "**K1 is closed.** `max p = a_m + 2` is now a theorem, with proof in `K1_plateau_theorem.md`", corroborated "exhaustively on 242 295 (support, L) cases over 36 424 supports, with zero counterexamples". The proof itself is harvested from that file as [Theorem B (the plateau)](tpp-rh40-k1-theorem-b-plateau.md); it is cited here, not restated, and it is not formalised in Lean (the README §7 records that "**no proof in this programme is currently backed by Lean**" because invoking the Lean binary was blocked in the sandbox).

## Dependencies and related results

- [Theorem B (the plateau, = C2a)](tpp-rh40-k1-theorem-b-plateau.md) — the proof of this form, from `K1_plateau_theorem.md`.
- [Theorem A (the large-L regime)](tpp-rh40-k1-theorem-a-large-l-regime.md) — the general formula `p(L) = min(a_m + 1, N − L + 1) + [L ≤ N − a_m − 1]` that specialises to it.
- [M3 — the plateau and the decay boundary](tpp-rh40-readme-m3-plateau-and-decay-boundary.md) — the exact plateau ranges.
- [Agent B (c) — the plateau value is a_m + 2](tpp-rh40-round01-agentb-plateau-value-am-plus-2.md) — the round-1 verification this paragraph reports.
- [The plateau value is not determined by (m, span, N)](tpp-rh40-round01-agentb-plateau-not-determined-by-m-span-n.md) — the companion non-determinacy result the "function of a_m alone" claim responds to.

## Notes

- The same paragraph also states the consequence that "the handoff's 'saturation value needs its own derivation' (§3.3) is answered, and the answer does not mention the greedy rule at all" (README §5.0: "the law is combinatorial, not arithmetic — it holds for *every* finitely supported 0/1 word").
- The instance `80+2 = 82` is measured on the support `(10,20,40,80)`, which Agent B flags as mislabelled "e−2" in `probes.py`; the true greedy word for `e−2` at `N = 2000` is `(0,3,53)` (see [tpp-rh40-round01-agentb-e-minus-2-mislabel.md](tpp-rh40-round01-agentb-e-minus-2-mislabel.md)).
