# The exact structural characterisation of the greedy digit word

**Kind:** Theorem
**Status:** CHECKED (exact enumeration; §3.2)
**Area:** workspace
**Source:** [`HANDOFF.md`](../../research/various/HANDOFF.md) — §3.2 "The exact structural characterisation (B's, corrected)", lines 77–93

## Statement

> **The correct statement.** A factor is determined by the **set of offsets** of the 1s it contains:
>
> ```
> factor at window start t  <->  { a − t : a ∈ ones, t <= a <= t + L − 1 }.
> ```
>
> Two windows give the same factor **iff** these offset-tuples agree. Hence
>
> ```
> p(L) = # { {a − t : a ∈ ones, t <= a <= t+L−1} : 0 <= t <= N − L }.
> ```
>
> This is **exact by construction** and is what all verification must use as ground truth.

## Hypotheses and notation

- The word is the greedy digit word w = w(x) of §2: for θ ∈ (0, π), x = θ/π ∈ (0, 1), r₀ = x, and for n = 0, 1, 2, …: if r<sub>n</sub> ≥ 1/(n+2) then δ<sub>n</sub> = 1 and r<sub>n+1</sub> = r<sub>n</sub> − 1/(n+2), else δ<sub>n</sub> = 0 and r<sub>n+1</sub> = r<sub>n</sub>.
- `ones` is the support of the word, i.e. the set of positions a with δ<sub>a</sub> = 1.
- p(L) := #{ distinct factors of length L occurring in w } (§2); the count is read from a finite truncation of length N (`w_N` = the first N symbols) and N must be stated with every reported number.

## Proof / evidence

The source states the characterisation without proof; it calls the formula "exact by construction" and says it "is what all verification must use as ground truth." It is indeed immediate from the definition — a length-L factor is a window of L consecutive symbols, and since the word is binary the pattern of a window is determined by the positions of its 1s relative to the window start t.

The section also records the refutation of the earlier classification: B's original formulation "— factors classified by the triple (index of the first 1, its offset, number of further 1s) — **overcounts** and is refuted: my implementation gave 4 at L = 1 for the word with ones {19, 50, 83} where the truth is 2, and 3693 mismatches in 5173 tested cases."

The source exercises the characterisation explicitly at x = 1/π, L = 20: 24 distinct factors, decomposed as () the all-zero factor from 1347 windows; (0,)…(10,) 11 factors each from exactly 2 windows; (11,)…(19,) 9 factors each from exactly 1 window; (0,11) (1,12) (2,13) 3 pair factors each from 1 window — total 24 ✓. It notes this is why the naive "L + 1 + Σ(L − d_j)" count fails (it predicts 30 at L = 20).

## Dependencies and related results

- [handoff-cassaigne-first-difference](handoff-cassaigne-first-difference.md) — the first-difference identity; the source calls this enumeration its ground truth for such checks.
- [handoff-greedy-squaring-law](handoff-greedy-squaring-law.md) — the residual law that generates the support positions.
- §3.3 measures the saturation of p(L) on this enumeration; §4 states the open problem of finding p(L) in closed form.

## Notes

- The status is CHECKED rather than PROVED: the source offers no separate proof and grounds the formula in exact enumeration (plus the "exact by construction" remark). Its framing is that this is the definition of record for verification, not a theorem with an independent proof.
- The source marks this as a *correction* of an earlier claim by Agent B, whose triple-based classification it refutes; the correction is part of the claim's status, not a later revision of it.
