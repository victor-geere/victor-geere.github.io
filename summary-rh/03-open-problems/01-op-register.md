# OP register — OP-1 … OP-19

> Source: [`research/open.md`](../rh/research/open.md) §4. The register is the programme-level list; the 36 finer-grained harvested items are in [02](summary-rh/03-open-problems/02-harvested-open-items.md).

## 4. The register: current status of OP-1 … OP-19

Statuses as written in [`07-open-problems.md`](../rh/research/twin-prime-parity/open/07-open-problems.md) Part A, with the
corrections noted.

| id | statement (short) | status |
|---|---|---|
| **OP-1** | un-averaged two-point Chowla `Σ_{n≤x} λ(n)λ(n+2) = o(x)` | **OPEN — out of reach (2026 survey)**; finite-prefix indeterminacy proved in Lean; all 2020–2026 progress is log-averaged/conditional |
| **OP-2** | one-point `Σ_{n≤x} λ(n) = o(x)` | **SETTLED (theorem)** — equivalent to PNT; `rh46` §1.3 and `rh47` §5.1 mislabel it OPEN |
| **OP-3** | "R2": no sign-blind `log n`-rule forces a multiplicative correlation | **OPEN → IMPOSSIBLE-AS-STATEMENT as inherited**; the precise version is OPEN |
| **OP-4** | `k`-point Chowla and Sarnak | **OPEN** for `k ≥ 2`; `k = 1` settled — **out of reach (2026 survey)**: equivalence only log-averaged, and log even `k ≥ 4` open |
| **OP-5** | asymptotic of `n_min(p)` | **SETTLED** — [`OP-05-nmin-asymptotic.md`](../rh/research/twin-prime-parity/open/OP-05-nmin-asymptotic.md), Lean `op5_nmin_asymptotic` |
| **OP-6** | order of `measure(S_1)/P(p) → 0` | **SETTLED** — [`OP-06-reachable-fraction.md`](../rh/research/twin-prime-parity/open/OP-06-reachable-fraction.md), Lean `op6_reachable_fraction` |
| **OP-7** | self-contained root existence for `Re S_N`, all `N ≥ 3` | **SETTLED (B.2 pass)** — uniform height `t_N = π/log N`, elementary proof for `N ≥ 20`, certified explicit rational heights for `N = 3..19`; no equidistribution (`op07_root_existence.py`) |
| **OP-8** | the term-level two-and-two split at a balance point | **REFUTED at every certified root (`N = 3…76`, extended 2026-10-11); OPEN in general** |
| **OP-9** | exact complex vanishing `S_N(t) = 0`, `N ≥ 4` | **OPEN**, but zero-free certified on `[0,10^4]` for `N = 4..10` (extended 2026-10-11; `N = 2` yes, `N = 3` provably no) |
| **OP-10** | an explicit-formula kernel with `O(1)` LHS and fast zero sum | **SETTLED (T6)** — see [`KERNEL_FINDINGS.md`](../rh/research/publish/006-explicit-formula-routes-abc/rigorous/KERNEL_FINDINGS.md) |
| **OP-11** | `corrSlice_sub_corr_self_eq` (Finset perturbation identity) | **SETTLED (B.2 pass)** — proved in [`rh46/lean/Rh46/Chowla.lean`](../rh/research/twin-prime-parity/rounds/rh46/lean/Rh46/Chowla.lean) (`corrSlice_sub_corr_self_eq`, `slice_term_sub`, `exists_corrSlice_ne_corr`); the register's hypothesis needed the correction `0 < h < a` |
| **OP-12** | `rh47`'s empty Lean layer + corrected sparse bound | **SETTLED (B.2 pass)** — machine-checked in [`rh47/lean/Rh47/Sparse.lean`](../rh/research/twin-prime-parity/rounds/rh47/lean/Rh47/Sparse.lean); the `rh46` form is **REFUTED** (witness `A={5}`, `x=5`) |
| **OP-13** | matching upper bound `A(N) = O(log log N)` | **SETTLED (B.2 pass), direction corrected**: the take rule + the proved squaring law give `n_k ≥ x^{−2^k} − 2`, hence `A(N) ≤ log₂(log(N+2)/log(1/x)) = O_x(log log N)`; the `Ω` lower bound is the side that fails (`op13_almost_everywhere.py`) |
| **OP-14** | residue of the `rh44` smoothing barrier; `M_φ ≡ 0`? | **SETTLED (B.2 pass)** — identically-zero is IMPOSSIBLE (analyticity/Mellin injectivity); explicit `φ = u(1−u)³` has `inf_{[0,50]}\|M_φ\| = 9.52·10⁻⁷`; see [`op14_complex_weights.py`](../rh/research/twin-prime-parity/open/op14_complex_weights.py) |
| **OP-15** | non-monotone alphabets realising `p(L) = cL` | **SETTLED — impossibility direction (B.2 pass)**: no halting alphabet of any kind realises `p(L) = cL` (finite support + rh41 Thm 1/Cor 4); the `L < 20` sub-claim is refuted by `[1/6,1,1/3,1/6]`, `x=1` |
| **OP-16** | twin primes and Selberg's parity barrier | **OPEN — out of reach (2026 survey, unchanged)**; `H₁ ≤ 246`/`240` are bounded-gap statements, not twins; parity unbroken for `(n,n+2)` |
| **OP-17** | Sarnak's Möbius-disjointness conjecture | **OPEN — out of reach in general (2026 survey)**: log-Sarnak holds for broad classes, un-averaged only for special classes; the Cesàro gap blocks the general case |
| **OP-18** | positive existence of a sign-blind positive-density coupling to `Ω` | **OPEN (heuristic) — ⚠️ not well-posed as phrased (2026 reassessment)**: "coupling" collapses to non-vanishing of `Σ1_Aλ`, so on a fixed class it is the existential dual of `OP-19`; periodic and finite-exponential-sum classes are settled **negative**; verified by [`op18_coupling_equivalence.py`](../rh/research/twin-prime-parity/open/op18_coupling_equivalence.py) |
| **OP-19** | **the log-indicator barrier** — the well-posed replacement for OP-3: is `C_I(x) = Σ_{n≤x} 1_{A_I}(n)λ(n) = o(x)` for every *log-arc rule* `A_I = {n ≥ 1 : log n mod 2π ∈ I}` (`I` a finite union of intervals with endpoints in a fixed countable field, `0 < \|I\| < 2π`)? | **OPEN** — and now **well-posed** (definite truth value; countable class; falsifiable by one arc and one window). The single arc `I = [0,π)` is the `rh43` set `{n : cos(log n) ≥ 0}`. Full definitions, the refutation of the unrestricted reading, and the known finite-exponential-sum sub-case: [`TODO.md`](../rh/research/TODO.md) §A.1 |

**Tally (as the table now stands, after the B.2-ranking pass):** 19 items — 10 SETTLED
(OP-2, OP-5, OP-6, **OP-10** as of item `T6`, and OP-7, OP-11, OP-12, OP-13, OP-14,
OP-15 as of the pass) · 1 IMPOSSIBLE-AS-STATEMENT as inherited (OP-3, whose well-posed
replacement is the new **OP-19**) · 1 REFUTED as stated (OP-8; the inherited sparse form
inside OP-12 is separately refuted) · 7 OPEN (OP-1, OP-4, OP-9, OP-16, OP-17, OP-18,
**OP-19**).

> **Summary tally (corrected at the source).** The "Summary" line of
> `07-open-problems.md` read *"18 items — 1 SETTLED, 1 IMPOSSIBLE-AS-STATEMENT,
> 1 PARTIAL, 2 REFUTED (as stated), 13 OPEN"* — a count predating the resolution of
> OP-5 and OP-6 (both marked SETTLED in the same file's own table). It now reads the
> tally above, which the B.2-ranking pass has updated to 10 SETTLED.

Known internal corrections the register already records (§0.1): `X1` one-point
Chowla is a theorem, not open; `X2` the `2·#{n≤x+2}` sparse bound is false; `X3`
the `1.808988` product tail is mis-derived; `X4` `rh47`'s barrier is over-wide and
stays heuristic.

---
