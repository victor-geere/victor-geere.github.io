# Theorem G — the upper bound is open *(harvested claim; corrected 2026-10-11: the upper bound is PROVED)*

**Kind:** Theorem
**Status:** **PROVED (paper; components Lean) — corrected 2026-10-11.** The harvested claim said the upper bound is OPEN; the obstruction it records (no two-sided squaring law) is real but obstructs the *lower* bound. (Register OP-13, now SETTLED.)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/K_remaining.md`](../../research/twin-prime-parity/rounds/rh40/K_remaining.md) — §3.1 "Status clarification (the requested item)"

## Statement

> **Theorem G (the upper bound is open).** `A(N) ≤ log₂ log N + O(1)` would follow
> from a **two-sided** squaring law `r_{k+1} ≥ c·r_k²` with `c > 0` fixed. But
>
> ```
> r_{k+1}/r_k² = (1−f)/(1+(1−f)r_k),     f = {1/r_k},
> ```
>
> which is `≤ 1` and has **no positive lower bound at all** — this is not merely
> unproven, it is *impossible*: as `f → 1⁻` the ratio `→ 0`, and `f` can be
> arbitrarily close to 1 (it equals `1 − ε` exactly when `1/r_k` is just below an
> integer, i.e. when `r_k` is just above `1/(n−1)`). Over 3 000 random **exact
> rational** starting points the measured minimum of the ratio is **1.95·10⁻⁴**,
> and it is driven toward 0 by Diophantine approximation of `x`, not bounded away
> from it.

The source states the consequence in bold as its own result:

> **Consequence: no two-sided squaring law of the form `c·r_k² ≤ r_{k+1} ≤ r_k²`
> with `c > 0` can hold.** So Theorem G's upper bound cannot be obtained that way,
> and K5's upper half is genuinely open rather than merely unfinished.

## Hypotheses and notation

- `r_k` is the residual of the greedy rule at step `k`; `A(N)` is the term count, `A(N) = #{k : n_k ≤ N}`.
- `f = {1/r_k}` is the fractional part of `1/r_k`; `c > 0` is the constant of the putative two-sided squaring law.
- The displayed identity is the source's exact expression for the per-step ratio `r_{k+1}/r_k²`.
- The "impossibility" claim concerns the existence of a positive lower bound for the ratio; the bound `A(N) ≤ log₂ log N + O(1)` itself remains unproven.

## Proof / evidence

The source gives no proof of the upper bound — it gives the obstruction: the exact identity for the ratio, its limit `→ 0` as `f → 1⁻`, and the measured minimum `1.95·10⁻⁴` over 3 000 random exact-rational starting points. It then derives the consequence that no two-sided squaring law with `c > 0` can hold, and concludes (§3.2 table) that `A(N) ≤ log₂ log N + O(1)` is **OPEN** — "needs `r_{k+1} ≥ c r_k²`, not proven".

The source's §3.2 adds the sharpening: "the reason `A(N) = log₂ log N + O(1)` is hard is that the residual map has *unbounded relative loss*, i.e. the index growth can occasionally be much slower than the generic double-exponential rate."

## Dependencies and related results

- [Theorem F — the lower bound on A(N)](tpp-rh40-k-remaining-theorem-f-an-lower-bound.md) — the proved half of the same pair.
- [The ratio r_{k+1}/r_k² has no positive lower bound](tpp-rh41-truths-claim-no-positive-lower-bound-ratio.md) — the later round's statement of the same obstruction, with a different measured minimum (`1.58·10⁻⁴` over 4 000 exact rational orbits) and a Lean proof of the qualitative part.
- [u_k = 2^k(u_0 + O(1)), hence A(N) = log₂ log N + O(1)](../round7/round7-agentb-an-log-log-n-growth.md) — the earlier claim of exactly this upper-bound form; the source here explains why it cannot be derived from the squaring law.

## Notes

- **The source labels this a theorem while saying its content is open.** The statement harvested here is exactly the source's labelled declaration, including the word "open" in its title; the Status is therefore `OPEN`, and no part of the displayed bound is claimed as proved.
- The source's §3.2 table marks `A(N) ≤ log₂ log N + O(1)` as `OPEN` — "needs `r_{k+1} ≥ c r_k²`, not proven".
- The register `rounds/truths.md` and the later round also carry the same obstruction (see the linked file for the version with corpus `4 000 orbits` and minimum `1.58·10⁻⁴`). Both figures are quoted exactly as printed in their own sources; they are different computations.
- The source explicitly notes that two independent earlier claims were wrong: "the journal's '`A(N) = O(log log N)`' (an *upper* bound, which is the unproved direction) and the handoff §2's census (consistent, but not a proof)."


---

## Correction (2026-10-11)

**The upper bound does not need a two-sided law.** Let `n_k` be the `k`-th support
index and `r_k` the residual before that take. Then

1. the step is active, so `r_k ≥ 1/(n_k+2)` (take rule);
2. `r_k < 1/(n_k+1)` (Lean `residual_invariant`);
3. `r_{k+1} ≤ r_k²` (Lean `squaring_law`), hence `r_k ≤ x^{2^k}` by induction.

Therefore `n_k + 2 ≥ 1/r_k ≥ x^{−2^k}`, i.e. `n_k ≥ x^{−2^k} − 2`, and

```
A(N) = #{k : n_k ≤ N} ≤ log₂( log(N+2) / log(1/x) ) = O_x(log log N).
```

So the harvested statement "`A(N) ≤ log₂ log N + O(1)` **is OPEN**" is **false**: it is an
elementary consequence of the programme's own proved one-sided squaring law. What the
source's obstruction *does* show — and this remains correct — is that no **two-sided**
law `c·r_k² ≤ r_{k+1} ≤ r_k²` with `c > 0` exists, which kills the **lower** bound
`A(N) = Ω_x(log log N)`, not the upper bound. The register and `rh41/TRUTHS.md` §3 had
the two directions exchanged; both are corrected
(`research/twin-prime-parity/open/07-open-problems.md` §0.1 item 5).
