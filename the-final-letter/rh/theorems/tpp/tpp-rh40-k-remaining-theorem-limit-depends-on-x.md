# The residual-orbit limit depends on x (the handoff's universal limit is refuted)

**Kind:** Theorem
**Status:** REFUTED (the handoff's claim "a limit independent of `x`" — by an explicit `x`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/K_remaining.md`](../../research/twin-prime-parity/rounds/rh40/K_remaining.md) — §4.4 "The refutation"

## Statement

> **Theorem (PROVED).** Let `q_0 = 4` and `q_{k+1} = 2q_k²`. This sequence is
> Sylvester-admissible (`q_{k+1} ≥ q_k(q_k−1)+1`), so it *is* the digit sequence of
> the greedy expansion of `x = Σ_k 1/q_k ≈ 0.2817384005`. The exact backward
> relation `s_k = q_k²/(q_k + q_{k+1} − s_{k+1})` then gives
>
> ```
> s_k → 1/2,   hence   (1/K) Σ_{k<K} log c_k → log(1/2) = −0.693147… ≠ −1.
> ```

And the refutation is then stated in the source's own words:

> **the handoff's "a limit independent of `x`" is FALSE.** There is no universal
> constant, and the handoff's equivalent question — "is `Σ log c_k` bounded?" —
> also has no uniform answer: it is bounded for some `x` and unbounded for others.

## Hypotheses and notation

- `q_k` are the greedy-Egyptian-fraction digits (Sylvester/Fibonacci–Sylvester greedy expansion) of `x`; here `q_0 = 4`, `q_{k+1} = 2q_k²`, and `x = Σ_k 1/q_k ≈ 0.2817384005`.
- `s_k := q_k − u_k` with `u_k = 1/r_k`; on the fractional-part map `s_{k+1} = 1 − { q_k²/s_k }`.
- `c_k` is the squaring constant of the law `r_{k+1} = c_k r_k²`; `log c_k = log s_k − log(1 + s_k r_k)` (§4.3).
- The claim being refuted is the handoff's: that `(1/K) Σ_{k<K} log c_k` has a limit independent of `x` (equivalently the value `−1` for every `x`).

## Proof / evidence

The source's evidence: the explicit Sylvester-admissible sequence `q_{k+1} = 2q_k²` with the exact backward relation `s_k = q_k²/(q_k + q_{k+1} − s_{k+1})` gives `s_k → 1/2`, hence the orbit average tends to `log(1/2) = −0.693147… ≠ −1`. The mediator reproduced this **both** backward (exact relation) and by running the **forward** greedy map on `x` rebuilt from the sequence — "the `s_k` values 0.45060809, 0.49242604, 0.49987799, 0.49999997 agree digit for digit".

Supporting verified facts in the same section (§4.2–4.3), which are context rather than separately harvested theorems: the digit-conditional density `μ_q(s) = q(q−1)/(q−s)² = 1 + (2s−1)/q + O(1/q²) → 1` integrates to 1 to 25 digits, its `L¹` distance from the Gauss–Kuzmin density `1/((1+s) log 2)` is `0.172` at `q = 10⁶`, and `E[log s_k | q_k] = −1 + 1/(2q_k) + O(1/q_k²)` checked to 12 digits for `q ≤ 10⁶`; `log c_k = log s_k − log(1 + s_k r_k)` with `0 ≤ log(1+s_k r_k) ≤ r_k` and `Σ r_k ≤ Σ 1/(q_k−1) < ∞` by the Sylvester bound, verified to 100 digits.

## Dependencies and related results

- [Theorem F](tpp-rh40-k-remaining-theorem-f-an-lower-bound.md), [Theorem G](tpp-rh40-k-remaining-theorem-g-upper-bound-open.md) — the `A(N)` bounds in the same section.
- §4.5 of the source records what remains true after the refutation: **PROVED** — for `x` uniform on `(0,1)`, `E[(1/K)Σ log c_k] = −1 + O(1/K)` (convergence in `L¹`, hence in probability); `[CONJECTURE]` — the same limit `−1` for Lebesgue-a.e. `x` (the reduction is written out but its key correlation lemma is stated, not proved); `[CONJECTURE]` — a family of `x` for which the limit does not exist at all (prescribed digit blocks), not reproduced by the mediator.
- [u_k = 2^k(u_0 + O(1)), hence A(N) = log₂ log N + O(1)](../round7/round7-agentb-an-log-log-n-growth.md) — an earlier claim built on the squaring law whose constant is at issue here.

## Notes

- **The source's own status is PROVED for the explicit computation and REFUTED for the handoff's universal claim.** The statement harvested here is the refutation (the handoff's claim is false); the internal label "PROVED" refers to the explicit-`x` counterexample. The Status line records the outcome for the refuted target, in the vocabulary's `REFUTED` term.
- K6 is labelled `REFUTED as posed — the limit depends on `x`` in the source's §0 summary; the source says K6 "is **closed** as a question, and the answer is not the one the handoff posed".
- The source also records a **PARTIAL** stronger claim that could *not* be reproduced: the achievable limits being exactly `(−∞, 0]` via `q_{k+1} = ⌊q_k²/s*⌋` — "the cases `s* = 1/2` and `s* = 0.1` work, but `s* = 0.9` and `s* = 0.99` do not (they give ≈ 0.794 and ≈ 0.839)".
- Evidence files named by the source: `verify/k6_residual.py` (Agent B) and the mediator's independent recomputation in `verify/verify_agentK6.py`.
- Quantities quoted exactly as printed: `q_0 = 4`, `x ≈ 0.2817384005`, `log(1/2) = −0.693147…`, `25 digits`, `12 digits`, `100 digits`, `0.172`, `10⁶`, maximum deviation `0.91` (the deviation of the fractional-part map from the Gauss map `s ↦ 1 − {1/s}`), and the `s_k` values `0.45060809, 0.49242604, 0.49987799, 0.49999997`.
