# Conjecture: a family of x for which the limit does not exist

**Kind:** Claim
**Status:** **PROVED (2026-10-11 attack; constructive, OP-28).** There exist `x ∈ (0,1)` and a greedy orbit with `limsup_K (1/K)Σ_{k<K} log c_k ≥ −0.76` and `liminf_K ≤ −1.21`; the running mean has **no limit**. Construction: prescribe `α_k` alternating `1/2,1/4` in blocks `M_j = 3^j` (`α_k = (q_k²+2q_k)/q_{k+1}`), build `q_k` backwards via `u_k = n_k u_{k+1}/(n_k+u_{k+1})`, take `x = Σ_k 1/(q_k+2)`. Exact-rational witness `x = 300129656263973531720568953662090234/48845289055200132283765298144075427525`; error budget `Ση_k ≤ 1.6·10⁻³` versus block-mean gap `0.35–0.52`. `lib/tpp_no_limit_orbit.py` (self-test 5/5) and `research/attacks/OP-28-30-33.md`.
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/K_remaining.md`](../../research/twin-prime-parity/rounds/rh40/K_remaining.md) — §4.5 "What remains true"

## Statement

> * **`[CONJECTURE]`:** a family of `x` for which the limit does not exist at all
>   (prescribed digit blocks); not reproduced by the mediator.

## Hypotheses and notation

- `x ∈ (0,1)` is described by its greedy digit sequence (`q_k`, the Fibonacci–Sylvester greedy Egyptian-fraction digit map, §4.1); "prescribed digit blocks" means the construction prescribes blocks of the digit sequence.
- "The limit" is the limit of `(1/K)Σ_{k<K} log c_k` as `K → ∞`; "does not exist at all" means the orbit average fails to converge (as opposed to converging to different values for different `x`, which §4.4 already establishes).
- `c_k` is the squaring constant of `r_{k+1} = c_k r_k²`.

## Proof / evidence

No proof. The source labels it `[CONJECTURE]` and records the verification status plainly: "not reproduced by the mediator." Harvested because the source presents it as a labelled claim.

## Dependencies and related results

- [The residual-orbit limit depends on x](tpp-rh40-k-remaining-theorem-limit-depends-on-x.md) — §4.4 proves the limit is `x`-dependent; this conjecture goes further and denies convergence for some `x`.
- [L¹ convergence of the orbit average to −1 for uniform x](tpp-rh40-k-remaining-conjecture-l1-convergence-uniform-x.md) — the proved expectation statement.
- [Conjecture: the limit −1 for Lebesgue-a.e. x](tpp-rh40-k-remaining-conjecture-lebesgue-a-e-limit.md) — the companion conjecture in the same bullet list.

## Notes

- The source's §4.4 also records, as `PARTIAL`, a different unreproduced claim — that the achievable limits are exactly `(−∞, 0]` via `q_{k+1} = ⌊q_k²/s*⌋` (the cases `s* = 1/2` and `s* = 0.1` work, `s* = 0.9` and `s* = 0.99` do not, giving ≈ 0.794 and ≈ 0.839). That `PARTIAL` item is **not** harvested as a theorem; it is noted here as context.
- Per the source, this conjecture was not reproduced by the mediator; the status line carries that qualifier so the claim is not read as verified.
