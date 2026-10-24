# 8. Greedy sine vs the parity barrier — `rh47`

> Source: [`research/truths.md`](../../rh/research/truths.md), §8. Status language is the ledger’s own.

Prose ledger: [`rounds/rh47/truths.md`](../../rh/research/twin-prime-parity/rounds/rh47/truths.md).
The round's Lean layer is no longer empty: [`Rh47/Sparse.lean`](../../rh/research/twin-prime-parity/rounds/rh47/lean/Rh47/Sparse.lean)
proves the corrected sparse bound, its sharpness witness and the falsity of the
inherited `2·#{n ≤ x+2 : n ∈ A}` form (item OP-12), in the `rh47/lean` layer
(`check.sh --all` 2/2, exit 0, axiom-clean).

| result | statement | status |
|---|---|---|
| **Sylvester-sparsity theorem** | for the support `A = {m₁<m₂<…}` of the greedy word, `m_{i+1} ≥ m_i(m_i−1)+1` | PROVED (paper) + VERIFIED (53 159 pairs, 0 violations) |
| support density | `≈ 3.9·10⁻⁵` (sizes `2.95 → 3.90` as `N = 10² → 10⁵`) | VERIFIED |
| `\|A\| ≥ 20` empty domain | none of 19 900 rational targets with denominator ≤ 200 has `\|A\| ≥ 20` | CHECKED |
| **B1** (support carries `λ`-parity) | nominal `z = −47.9` killed by controls: `z = +0.43`, `+1.55` | **REFUTED** |
| **B2** (budgets carry `Ω`-parity) | index parity invisible to the correlation: twist identity exact | **REFUTED** |
| **B3** (ζ-machinery applies) | `f(n)=λ(n)λ(n+2)` not multiplicative; `\|D(2) − model\| = 2.0144 > 1.84·10⁻⁵` | **REFUTED** |
| correct sparse bound | `\|S_A−S\| ≤ 2·#{n≤x: n∈A ∨ n+2∈A} ≤ 4·#{m≤x+2: m∈A}` | **PROVED (Lean, OP-12)**; rh46's `2·#{…}` is **REFUTED** (`A={5}`, `x=5`, `\|ΔS\|=4`) |
| R2 (barrier as a theorem) | no sign-blind `log n`-rule forces a multiplicative correlation | **OPEN — not well-posed as inherited; repaired into OP-19 (still open)** |
| R4 (Lean barrier formalisation) | — | **PARTIAL — `Rh47/Sparse.lean` done (OP-12); Brown/parity-lock port and R2 open** |
| **OP-16 / OP-17 / OP-18** | twin primes / Sarnak / sign-blind coupling | **out of reach** (2026 reassessment); **OP-18 is ⚠️ not well-posed as phrased** — its well-posed restriction is the existential dual of OP-19. See [`open/OP-01-04-16-17-18-tractability.md`](../../rh/research/twin-prime-parity/open/OP-01-04-16-17-18-tractability.md) |

The programme's verdict: the goal is **not reachable by this programme as it
stands** ([`rounds/rh47/truths.md`](../../rh/research/twin-prime-parity/rounds/rh47/truths.md)).

---
