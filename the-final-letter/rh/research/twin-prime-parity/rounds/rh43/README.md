# `rh43` — the partial sums of ζ at `Re(S) = 0`: the equal split

**Question of the round.**  For a complex input `S` with `Re(S) = 0` (`S = i t`),
take a finite partial sum of the zeta Dirichlet series,
`S_N(t) = Σ_{n=1}^{N} n^{-it}`, and split every term into its positive real part
`P_N(t) ≥ 0` and its negative real part `M_N(t) ≤ 0`.  Can the partial sum be
separated into **two equal positive parts and two equal negative parts**, using only
the positive parts and the negative parts with ordinary summation?

**Answer: yes — for every `N ≥ 2`.**  The split is an identity,
`P_N + M_N = Re S_N(t)`, and the requested separation is exactly the single
equation `Re S_N(t) = 0`, which is attained at every `N ≥ 2`:

| N | how it is attained | status |
|---|---|---|
| 1 | `Re S_1 ≡ 1`: one positive part, no negative part — the only degenerate case | **PROVED** |
| 2 | `t = π/log 2` exactly: the terms are `+1` and `−1`; the zero is *tangential* | **PROVED** (Lean) + **VERIFIED** |
| 3 | `t = 5/2` has `Re S_3(5/2) = −0.084335758298… < 0` while `Re S_3(0) = 3 > 0`; IVT gives the root | **PROVED** (Lean) |
| 4 | `Re S_4(12/5) = −0.950677206742… < 0`, same route | **PROVED** (certified) |
| 3 … 50 | certified 47-digit root brackets (auditor's independent engine) | **VERIFIED** |
| every `N ≥ 3` | by equidistribution of `(t log 2, …, t log N)` | **PROOF-SKETCH** + **VERIFIED** to `N = 200` |

**Read at the level of the terms, the answer flips.**  If "two equal positive parts"
means *the positive terms partition into two subsets of equal sum*, that is strictly
stronger than `P = |M|` and it is **false** at the balance points: the first term
`cos(t log 1) = 1` exceeds `P/2` whenever `P < 2` (true at the smallest positive root
for every `N` tested), and an exhaustive subset-sum gives the exact defect
`0.16996…` at `N = 6`.  The numeric pieces `P/2, M/2` do pair up perfectly; the
term-level partition does not.  Both readings are recorded in
[`truths.md`](truths.md) §0.2/§3.

Three traps are part of the answer and are recorded, not hidden: the `N = 2` zero is
**tangential** (a sign-change scan misses it); the *complex* partial sum is a
different question (`S_2(π/log 2) = 0` exactly, while `S_3(t) ≠ 0` for **every** `t`,
proved in Lean); and the infinite series does **not** converge in the ordinary sense
at `Re(S) = 0` — `|S_N(t)| ~ N/√(1+t²)` grows **linearly**, so only finite partial
sums make the question well posed.

---

## The files

| file | what it is |
|---|---|
| [`truths.md`](truths.md) | the ledger: what is PROVED / VERIFIED / REFUTED / OPEN, with witnesses and the refutation list |
| [`HANDOFF.md`](HANDOFF.md) | the round narrative: the object, the answer, the traps, the corrections banked, and the open items |
| [`zeta_split.py`](zeta_split.py) | the main numerics (the split, the witnesses, the roots, the four-part split, the divergence) |
| [`ivmath.py`](ivmath.py) | the rigorous engine: `Num` = value + guaranteed error at 400 dps; π by Machin, `log n = 2 atanh((n−1)/(n+1))` over the prime factors of `n`, `cos`/`sin` by Taylor series with explicit remainder bounds |
| [`verify/independent_check.py`](verify/independent_check.py) | the auditor's independent recomputation (own engine, nothing imported from the round) |
| [`positive_only_N20.png`](positive_only_N20.png) | the positive-values-only two-set split: the best `A, B` at `N=20, t=1/2` (gap `1.52e-5`) |
| [`verify/positive_only_split.py`](verify/positive_only_split.py) | the positive-only criterion: `P >= 2` at the top level, exact equality blocked by completeness at the last index |
| [`partition_N20.png`](partition_N20.png) | the picture of a balanced partition: the terms, the two cumulative sums, and the total cumulative difference, at the certified `N = 20` root | 
| [`verify/`](verify) | the recorded run logs, the independent auditor script, and the PNG renderer |
| [`lean/`](lean) | the Lean 4 + Mathlib development, `Rh43/Balance.lean`: 38 theorems, no `sorry`, no new axiom |

---

## Reproduce

```
cd /Users/victor/workspace/rh
python3 rh43/zeta_split.py                    # main numerics    -> verify/zeta_split.log
python3 rh43/verify/independent_check.py      # the auditor      -> verify/independent_check.log
cd rh43/lean && ./check.sh --all              # the Lean proofs  -> verify/lean_check.log
```

The Lean installation is the shared one at `$HOME/lean`
(`LEAN_PREFIX`, elan + Mathlib4); `check.sh` is the same driver as `rh42/lean`'s,
with the `--all` list pointed at this round's modules.

---

## What this folder does *not* claim

* No relation is claimed between the roots of `Re S_N(t)` tabulated here and the
  zeros of `ζ(1/2 + it)` or `ζ(it)`.  The round answers a question about the
  **partial sums** on the critical line.
* Theorem "root for every `N ≥ 3`" is not proved here without equidistribution; it is
  verified numerically through `N = 200` (see [`truths.md`](truths.md) §6).
* Exact complex vanishing for `N ≥ 4` is open (`N = 2` yes, `N = 3` no).
* The answer depends on the split convention: splitting by the **imaginary** part
  instead gives the condition `Im S_N(t) = 0`, which also has positive roots, at
  different heights (`N = 2` at `π/log 2`, `N = 3` at `2π/log 6`).  The mirror is
  implemented and certified in [`im_balance.py`](im_balance.py) (see
  [`truths.md`](truths.md) §1.5, T17); the real-part convention is the one answered
  here, and it is stated explicitly everywhere.
