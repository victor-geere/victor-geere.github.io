# Archive — harvested handoffs and ledgers of the individual rounds

This folder does **not** duplicate the round artefacts (they would go stale).  It is a
pointer index: for each round, the files that carry its handoff, its ledger, its
numerics and its Lean development, with a one-line summary of what to read there.

**Folder map (the directories are not uniformly named):**

| round label | actual folder | handoff | ledger | numerics | Lean |
|---|---|---|---|---|---|
| rh40 | `rh40/` | — | [`rh40/rounds/truths.md`](../rounds/rh40/rounds/truths.md) | — | — |
| rh41 | `rh41/` | — | [`rh41/TRUTHS.md`](../rounds/rh41/TRUTHS.md) | `rh41/*.py` | [`rh41/lean/`](../rounds/rh41/lean) |
| rh42 | `rh42/` | [`HANDOFF.md`](../rounds/rh42/HANDOFF.md) | [`truths.md`](../rounds/rh42/truths.md) | [`reachable.py`](../rounds/rh42/reachable.py), [`helix_zeta.py`](../rounds/rh42/helix_zeta.py) | [`lean/`](../rounds/rh42/lean) |
| rh43 | `rh43/` | [`HANDOFF.md`](../rounds/rh43/HANDOFF.md) | [`truths.md`](../rounds/rh43/truths.md) | [`zeta_split.py`](../rounds/rh43/zeta_split.py), [`ivmath.py`](../rounds/rh43/ivmath.py) | [`lean/`](../rounds/rh43/lean) |
| **rh044** | `rh044/` | [`HANDOFF.md`](../rounds/rh044/HANDOFF.md) | [`truths.md`](../rounds/rh044/truths.md) | [`smoothed_zeta.py`](../rounds/rh044/smoothed_zeta.py) | [`lean/`](../rounds/rh044/lean) |
| **rh45** | `rh45/` | [`HANDOFF.md`](../rounds/rh45/HANDOFF.md) | [`truths.md`](../rounds/rh45/truths.md) | [`explicit_formula.py`](../rounds/rh45/explicit_formula.py) | [`lean/`](../rounds/rh45/lean) |
| rh46 | `rh46/` | [`README.md`](../rounds/rh46/README.md) | (README §1–5) | [`chowla_two_point.py`](../rounds/rh46/chowla_two_point.py) | [`lean/Rh46/Chowla.lean`](../rounds/rh46/lean/Rh46/Chowla.lean) |
| rh47 | `rh47/` | [`HANDOFF.md`](../rounds/rh47/HANDOFF.md) | [`truths.md`](../rounds/rh47/truths.md) | [`greedy_parity_probe.py`](../rounds/rh47/greedy_parity_probe.py) | `rh47/lean/` (**empty**) |

One-line summaries: rh40 the complexity law's K1 plateau and C1 regime (computed);
rh41 the law closed (Theorems 1–12) with the original Lean development; rh42 the signed
Tau alphabet with budgets, Brown's criterion, thresholds `p*, q`, the parity lock and
the helix; rh43 the balance split at `Re(S)=0`; rh044 smoothing (does not remove `√N`);
rh45 the explicit formula with the archimedean term; rh46 two-point Chowla is **open**,
with the certified finite-prefix theorem; rh47 the harvest, the Sylvester-sparsity
theorem and the refuted bridges.

## The verified evidence streams (summary)

| stream | result | log |
|---|---|---|
| rh42 budgets/reachability | 80/80 and 70/70 checks | `rh42/verify/helix_zeta_rerun.log`, `rh42/verify/reachable.log` |
| rh43 balance split | 64/64 checks; independent audit 102/102 | `rh43/verify/zeta_split.log`, `rh43/verify/independent_check.log` |
| rh044 smoothing | 59/59 checks | `rh044/verify/smoothed_zeta.log` |
| rh45 explicit formula | 19/21, **2 retired** (`C4.1` over-strong; `C1e` unsatisfiable as stated and restated as `C1f`), **no failures** — `010/verify/DISPOSITIONS.md` | `rh45/verify/independent_check.log`, `010/verify/DISPOSITIONS.md` |
| rh46 two-point Chowla | 30/30 checks; independent audit 25/26 (the 1 failure is a stale reconnaissance value, corrected to `S(10⁷) = 1246`) | `rh46/verify/*.log` |
| rh47 parity probes | 23/23 checks; independent audit 31/31 (an audit *of the barrier claim*) | `rh47/verify/*.log` |
| Lean | rh42 4/4, rh43 2/2, rh044 2/2, rh45 2/2, rh46 2/2 modules OK, no `sorry` | the rounds' `verify/lean_check.log` |

## Notable corrections kept on the record (do not re-propose)

1. `Σ_{n≤x}λ(n)λ(n+2) = o(x)` is **open**; no computation decides it (rh46).
2. The correlation `n ↦ λ(n)λ(n+2)` is **not multiplicative**; no Euler product (rh46).
3. Smoothing cannot beat `√N` on the critical line (rh044).
4. The sharp constant is `1/|s−1|`, not `1/√(2t)` (rh044 §0 R1).
5. The explicit formula needs the **archimedean term** and poles `2φ(i/2)` (rh45).
6. The finite-`N` balance condition sees generic roots, not zeta zeros (rh43 §7.6).
7. The budgets separate *index* parity, not `Ω`-parity (rh47 §2).
8. The sparse-modification bound is `4·#{m ≤ x+2 : m ∈ A}`, not `2·#{n ≤ x+2 : n ∈ A}`
   (rh47 §3, witness `A = {5}`, `x = 5`).
9. The greedy support is Sylvester-sparse; it cannot be a positive-density witness
   (rh47 `truths.md` §1).
