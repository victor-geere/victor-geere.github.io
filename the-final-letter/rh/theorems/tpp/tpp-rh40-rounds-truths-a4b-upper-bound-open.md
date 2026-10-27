# A4b — the matching upper bound A(N) ≤ log₂ log N + O(1)

**Kind:** Claim
**Status:** **PROVED (paper; components Lean) — corrected 2026-10-11.** The entry was harvested as OPEN; the upper bound does *not* need a two-sided squaring law. (Register OP-13, now SETTLED.)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md) — §A "The object", register row A4b

## Statement

> The matching **upper** bound `A(N) ≤ log₂ log N + O(1)`

## Hypotheses and notation

- `A(N) = #{n ≤ N : δ_n = 1}`.
- The missing hypothesis is a two-sided squaring law: `r_{k+1} ≥ c·r_k²` with `c > 0`.

## Proof / evidence

Register row A4b's status cell reads: "`OPEN` — needs `r_{k+1} ≥ c·r_k²` with `c > 0`, unproven; measured ratios as low as 0.028". The source states this without proof.

## Dependencies and related results

- Register row A4 (the proved lower bound `Ω(log log N)`).
- Register row A4c (empirically tight `⌊log₂ log₂ n_k⌋ = k + O(1)`).
- [Theorem G — the upper bound is open](tpp-rh40-k-remaining-theorem-g-upper-bound-open.md).
- Register row D6 (the squaring law `r_{k+1} = (1−f)r_k²/(1+(1−f)r_k)`), verified numerically but not proved symbolically.

## Correction (2026-10-11)

At the `k`-th taken index the take rule gives `r_k ≥ 1/(n_k+2)` (the step is active), while `r_{k+1} ≤ r_k²` (the Lean `squaring_law`) iterates to `r_k ≤ x^{2^k}`. Hence `n_k + 2 ≥ 1/r_k ≥ x^{−2^k}`, so `n_k ≥ x^{−2^k} − 2` and

```
A(N) = #{k : n_k ≤ N} ≤ log₂( log(N+2) / log(1/x) ) = O_x(log log N).
```

So the `O` bound is an elementary consequence of the **one-sided** law already proved in Lean. The measured small ratios (`0.028`, and the minimum `1.58·10⁻⁴` of the later round) obstruct the *lower* bound `A(N) = Ω_x(log log N)`, not this upper bound; the register's and `rh41` §3's original direction was inverted and is corrected in `research/twin-prime-parity/open/07-open-problems.md` §0.1 item 5 and `rh41/TRUTHS.md` §3.

## Notes

- Harvested because the source labels it a register entry with an explicit status. **The harvested status was `OPEN`; it is now `PROVED`.**
- The measured ratios as low as `0.028` are the source's own obstacle to any `c·r_k²` lower bound — which is the correct obstruction to the *matching lower* bound, not to this upper bound.
- No two-sided law `c·r_k² ≤ r_{k+1} ≤ r_k²` with `c > 0` exists (Lean `no_positive_lower_bound`), and that is consistent with the corrected picture: the lower bound on `A(N)` is the failing side.
