# Conjecture 1.8 (Hardy–Littlewood / Dickson prime `k`-tuples)

**Kind:** Claim
**Status:** OPEN (for every `k ≥ 2`; HEURISTIC as a prediction)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/03-parity-problem.md`](../../research/twin-prime-parity/dictionary/03-parity-problem.md) — §1.2

## Statement

> **Conjecture 1.8 (Hardy–Littlewood / Dickson prime `k`-tuples).** For an admissible `h`, `#{n ≤ x : n+h_1, …, n+h_k all prime} ~ 𝔖(h) x/(log x)^k`.

> The case `h = (0,2)` is the **twin prime conjecture** in quantitative form: `π₂(x) := #{p ≤ x : p+2 prime} ~ 2C₂ x/(log x)²`; in particular `π₂(x) → ∞`.

The file's status line: *Status:* **OPEN** for every `k ≥ 2` (for `k = 1` it *is* PNT, a theorem). The value `𝔖(0,2) = 1.3203236316…` is *verified numerically* in the sense of the finite product converging; the asymptotic itself is **HEURISTIC** (a conjecture, with no proof).

## Hypotheses and notation

- `h = (h_1, …, h_k)` is an **admissible** `k`-tuple: distinct integers with `h_1 < … < h_k` such that for every prime `p` the residues `h_1, …, h_k mod p` do not cover all of `{0, …, p−1}`; equivalently, with `ν_p(h) = #{h_i mod p}`, `ν_p(h) < p` for every `p` (Definition 1.6).
- `𝔖(h_1, …, h_k) = Π_p (1 − 1/p)^{−k} (1 − ν_p(h)/p)` is the **singular series** (Definition 1.7); with this normalisation `𝔖(0) = 1` (`k = 1`) and `𝔖(0, 2) = 2 Π_{p>2} (1 − 1/(p−1)²) = 1.3203236316… = 2C₂`, the twin-prime constant.
- `π₂(x) = #{p ≤ x : p+2 prime}`.

## Proof / evidence

- The source states this as a conjecture with **no proof**; it is labelled `Conjecture 1.8` and its status is recorded as **OPEN** for every `k ≥ 2`.
- The file notes the case `k = 1` *is* PNT (a theorem), and that the numerical convergence of the finite product `𝔖(0,2)` does not prove the asymptotic.

## Dependencies and related results

- Definition 1.6 (admissible tuple); Definition 1.7 (singular series).
- The twin-prime case is restated as OPEN 2.7 (`π₂(x) ≫ x/(log x)²`) and listed among the open statements in OPEN 4.2.
- The upper bound that *is* available is THEOREM 2.5 (Brun) and THEOREM 2.6 (Chen, `P₂`); the exact relation to the Chowla target is THEOREM 5.1.
- Restated in this file's own §7 ledger row "1.8".

## Notes

- Labelled as a conjecture, so it is harvested with Status **OPEN**, exactly as the source records it (the source also calls it HEURISTIC as a prediction).
- The source's numerical remark concerns only the convergence of the constant `1.3203236316…`, not the asymptotic.
