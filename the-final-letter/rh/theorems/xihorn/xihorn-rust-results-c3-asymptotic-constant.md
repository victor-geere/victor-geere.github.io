# C3 — the phrasing does outrun the evidence, and now by a measured amount

**Kind:** Claim
**Status:** VERIFIED (numerical; extended sixteen-fold to w = 9600, |w|(R−1) reaching 3.445)
**Area:** xi-horn
**Source:** [`xi-horn/rust/RESULTS.md`](../../xi-horn/rust/RESULTS.md) — Summary, "C3 — the phrasing does outrun the evidence, and now by a measured amount"

## Statement

> **C3 — the phrasing does outrun the evidence, and now by a measured amount.**
> CONTINUATION §4 infers "R(w) − 1 ~ 4/|w|" from a creep through 2.13 … 3.19.
> Extended sixteen-fold to w = 9600, |w|(R−1) reaches only **3.445** — still 14%
> short of 4. Worse for the inference, `(4 − a)·ln w` is *not* flat: it rises to
> 5.204 near w = 300–600 and then falls to 5.091 by w = 9600. So the data are
> consistent with a → 4 but establish neither that limit nor the c/ln w model,
> and TODO C3's own suspicion is upheld. **The wording should be downgraded.**

The measured column, from the same driver:

```text
    w        10      40      80     150     300     600    1200    2400    4800    9600
 |w|(R−1)  2.126   2.652   2.834   2.967   3.088   3.187   3.269   3.337   3.395   3.445
```

## Hypotheses and notation

- R is the ratio (24) of CONTINUATION; a abbreviates |w|(R(w) − 1); the model under test is a = 4 − c/ln w.
- R needs **no Γ at all**: "the two gamma functions in C(w) = Γ_Φ(w)/Γ(w+1) cancel out of (24) into an explicit rational factor, so neither this scan nor C3 depends on anything whose own accuracy is in question."
- Driver `bin/c3_asymptote`.

## Proof / evidence

Numerical, to w = 9600. The discriminating quantity is `(4 − a)·ln w`, which "is **not** flat — it rises to 5.204 near w = 300–600 and then *falls* to 5.091 by 9600. Flat would mean a = 4 − c/ln w; falling means a → 4 faster; the observed rise-then-fall means the data are consistent with 4 and consistent with a slow logarithmic divergence, and **establish neither**."

## Dependencies and related results

- [G5 — done, and the answer is 4](xihorn-rust-results-g5-watson-constant-4.md) — the analytic derivation that supersedes this measurement: w·(R(w) − 1) = 4 − 4/(1 + W(w/π)) + O(1/w).
- [B3 — the widest scan](xihorn-rust-results-b3-widest-scan.md) — the same quantity's value at the box corner, |w|·|R − 1| = 3.031.
- [H5 — the Lambert-W asymptotic](xihorn-h-track-h5-lambert-w-asymptotic.md) — Lambert's W, later reused for G5.

## Notes

- This is a negative/downgrading result: it does not establish the limit 4, and says so. The source's verdict: "**The wording should be downgraded.**"
- Reaching 3.9 needs w ≈ 10¹⁹ and 3.99 needs 10¹⁷⁶ (stated in the G5 summary as the reason "no computation was ever going to read this off").
