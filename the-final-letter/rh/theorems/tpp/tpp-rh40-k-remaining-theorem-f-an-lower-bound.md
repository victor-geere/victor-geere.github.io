# Theorem F — the lower bound on `A(N)`

**Kind:** Theorem
**Status:** PROVED (paper argument, one-sided; the upper bound is open)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/K_remaining.md`](../../research/twin-prime-parity/rounds/rh40/K_remaining.md) — §3.1 "Status clarification (the requested item)"

## Statement

> **Theorem F (rigorous, one-sided).** Let `x ∈ (0,1)` irrational, `r_0 = x`, and
> `n_{k+1} = ⌈1/r_k⌉ − 2`. Then
>
> ```
> A(N) ≥ log₂ log N − log₂ log(1/x) − 1 ,
> ```
>
> i.e. `A(N) = Ω(log log N)` with the implied constant and additive term explicit.

## Hypotheses and notation

- `x ∈ (0,1)` irrational; `r_0 = x` is the initial residual of the greedy rule.
- The greedy digit sequence is `n_{k+1} = ⌈1/r_k⌉ − 2` (`r_{k+1} = r_k − 1/n_{k+1}`).
- `A(N)` is the term count — the number of selected digits up to `N` (§3.2 states `A(N) = #{k : n_k ≤ N}` elsewhere in the ledger); `n_k` are the active indices.
- `⌈·⌉` is the ceiling; `log₂` the base-2 logarithm. The bound is one-sided (lower bound only).

## Proof / evidence

The source gives the proof in full:

> *Proof.* `r_{k+1} = r_k − 1/n_{k+1}` and `1/n_{k+1} ≥ r_k`, so `r_{k+1} ≤ r_k − r_k = 0` is the termination case and otherwise `r_{k+1} ≤ r_k²`. Hence `r_k ≤ x^{2^k}`. Also `n_{k+1} = ⌈1/r_k⌉ − 2 ≤ 1/r_k + 1`, so `n_k ≤ (1/x)^{2^{k−1}} + 1`. Therefore every `k` with `(1/x)^{2^{k−1}} + 1 ≤ N` satisfies `n_k ≤ N`, i.e. contributes to `A(N)`, which gives the stated bound. ∎

The source's §3.2 table records the surrounding status: `A(N) ≥ log₂ log N − log₂ log(1/x) − 1` is **PROVED** (Theorem F); `log n_k / 2^k` converges to a finite positive constant is **VERIFIED** (1/π, log 2, √2−1, e−2, √3−1, log₁₀2; 14 indices each); `⌊log₂ log₂ n_k⌋ = k + O(1)` is **VERIFIED** (same six targets, first 10 indices) — "this is the empirical tightness of `A(N) = log₂ log N`"; and `A(N) ≤ log₂ log N + O(1)` is **OPEN**.

## Dependencies and related results

- [Theorem G (the upper bound is open)](tpp-rh40-k-remaining-theorem-g-upper-bound-open.md) — the matching upper bound, which the source proves *cannot* be obtained from a two-sided squaring law.
- [The ratio r_{k+1}/r_k² has no positive lower bound](tpp-rh41-truths-claim-no-positive-lower-bound-ratio.md) — the later round's sharp half `r_{k+1}/r_k² = (1−f)/(1+(1−f)r_k)`, the obstruction behind the open upper bound.
- [The squaring law r_{k+1} ≤ r_k² and the lower bound A(N) = Ω_x(log log N)](tpp-rh41-truths-claim-squaring-law-omega-lower-bound.md) — the later round's statement of the same lower bound.
- [u_k = 2^k(u_0 + O(1)), hence A(N) = log₂ log N + O(1)](../round7/round7-agentb-an-log-log-n-growth.md) — the earlier claim in the **opposite** direction, flagged by the source as an unproved half; see Notes.

## Notes

- **Restatement round.** The same lower bound appears in the later round `research/twin-prime-parity/rounds/rh41/TRUTHS.md` (harvested as [the squaring-law claim](tpp-rh41-truths-claim-squaring-law-omega-lower-bound.md)) and in the `rh41`-derived files; the `rh40` source is the round that first states the direction split in this form.
- **The source corrects the record** (§3.2): "the journal's Round-5 line 'A(N) = O(log log N)' is the unproved half; what the super-exponential index growth actually gives is the **lower** bound `A(N) = Ω(log log N)`. The two are not the same claim and the register previously carried the handoff's version without flagging the direction." The handoff's census to `N = 128 541 453` is "consistent with it, but the *proof* direction was never stated".
- K5 as a whole is labelled `PROVED (lower)` with the upper **OPEN** in the source's §0 summary.
- Quantities quoted exactly as printed: `N = 128 541 453`.
