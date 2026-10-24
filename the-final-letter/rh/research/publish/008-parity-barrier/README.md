# publish/008 — Greedy sine vs the parity barrier

Eighth published edition. This folder packages **item §8 of `research/truths.md`**: the
**Sylvester-sparsity theorem** for the greedy support, the three tested **bridges** and
their refutations, and the programme's verdict on the parity barrier.

**There is no Lean layer in this folder, and that is the item's point** — the round's
Lean directory is empty (its `R4` obligation is open). Everything here is proved on
paper, verified numerically, or recorded as open.

## What the item is

The round asks whether the greedy-harmonic-sine construction can supply the
positive-density coupling to `Ω` that the parity barrier requires. Its answer is a
sharpened **no**, with three named bridges tested and refuted.

**The new structural fact — Sylvester-sparsity (proved on paper, verified).** For the
support `A = {m_1 < m_2 < …}` of the greedy word,

```
m_{i+1} ≥ m_i (m_i − 1) + 1.
```

The support therefore has density `≈ 3.9·10⁻⁵` (measured `2.95 → 3.90` as
`N = 10² → 10⁵`), verified on **53 159 pairs with 0 violations**. By the corrected sparse
bound, a support of this density moves the correlation `S(x)` by `o(x)`: it cannot be the
positive-density witness the two-point problem would need.

**The three bridges, tested.**

| Bridge | Claim | Verdict |
|---|---|---|
| **B1** | the greedy *support* carries `λ`-parity signal | **REFUTED** — the nominal `z = −47.9` is killed by controls (`z = +0.43`, `+1.55`) |
| **B2** | the ζ budgets carry `Ω`-parity information | **REFUTED** — the twist identity `Σ λ(n)(−1)ⁿ λ(n+2)(−1)^{n+2} = Σ λ(n)λ(n+2)` is exact; index parity is invisible |
| **B3** | the `ζ`-machinery applies to the correlation | **REFUTED** — `n ↦ λ(n)λ(n+2)` is not multiplicative, `\|D(2) − model\| = 2.0144 > 1.84·10⁻⁵` |

**The corrected sparse bound.** The bound inherited from `rh46`,
`|S_A(x) − S(x)| ≤ 2·#{n ≤ x+2 : n ∈ A}`, is **false**: the witness `A = {5}`, `x = 5`
gives `|ΔS| = 4 > 2`. The correct bound is

```
|S_A(x) − S(x)| ≤ 2·#{n ≤ x : n ∈ A or n+2 ∈ A} ≤ 4·#{m ≤ x+2 : m ∈ A}.
```

**The corrected barrier.** The round's own one-sentence form — "every greedy-sine object
is an additive character in `log n`" — was **withdrawn** after audit: `n^{−it}` is
*multiplicative* on `(ℝ₊,×)`, and the sums `Σ λ(n)n^{−it}` do vanish for each fixed `t`.
The barrier must be read as **sign-blind alphabet, no arithmetic input**, and the
impossibility stays a **heuristic**, not a theorem.

## Contents

| File | What it is |
|---|---|
| [`TRUTHS.md`](TRUTHS.md) | **The item**: the §8 ledger from `research/truths.md`, links re-pointed into this folder. |
| [`ROUND-NOTES.md`](ROUND-NOTES.md) | The round's own summary: the corrected barrier, the three bridges, and the Sylvester-sparsity result. |
| [`ROUND-TRUTHS.md`](ROUND-TRUTHS.md) | The round's full prose ledger, including the two record corrections and the `rh46` defect it found, reproduced for provenance. |
| [`greedy_parity_probe.py`](greedy_parity_probe.py) | The greedy support probe: the sparsity check and the B1 signal test. |
| [`independent_check.py`](independent_check.py) | The auditor's independent recomputation, including the twist invariance (`0/10⁶` mismatches) and the sparse-bound witnesses. |
| [`logs/`](logs) | The recorded runs: `greedy_parity_probe.log`, `greedy_parity_probe.stdout`, `independent_check.log`. |

## What is proved, what is refuted, what is open

* **Proved (paper) + verified** — Sylvester-sparsity (`m_{i+1} ≥ m_i(m_i−1)+1`); the
  support density; the corrected sparse bound.
* **Checked** — none of 19 900 rational targets with denominator `≤ 200` has `|A| ≥ 20`.
* **Refuted** — B1, B2, B3, and `rh46`'s sparse bound and product tail (`1.808988` was
  mis-derived; the conclusion survives on the correct tail `1.84·10⁻⁵`).
* **Open** — `R2`, the barrier as a *theorem*: "no sign-blind `log n`-rule forces a
  multiplicative correlation". As inherited it is **not well-posed**; the well-posed
  replacement is `OP-19` (see `research/open.md` §5). Also open: `R4`, the Lean
  formalisation of the barriers — this folder has no Lean layer.
* **The programme's verdict** — the goal is **not reachable by this programme as it
  stands**: the missing ingredient is a sign-blind alphabet with a positive-density
  multiplicative coupling to `Ω`, and the greedy support, being Sylvester-sparse, cannot
  supply one.

## Running the checks

```sh
python3 greedy_parity_probe.py    # sparsity and the B1 signal test
python3 independent_check.py      # the auditor's recomputation
```

There is no `check.sh` here because there is no Lean development to build.

## Dependencies

Everything needed is in this folder. The only external dependency is **NumPy** (and
`mpmath` for the high-precision values in the probe); the rest is the Python standard
library.

## Provenance

Produced in the programme's round `rh47`; see `research/truths.md` §8. Sources are
reproduced unmodified except that markdown links have been re-pointed into this folder,
and one transient draft (`verify/_draft_probe_03h56.py.bak`) has been dropped.
