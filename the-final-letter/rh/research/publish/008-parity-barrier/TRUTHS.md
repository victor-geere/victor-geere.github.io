## 8. Greedy sine vs the parity barrier — `rh47` (no Lean)

Prose ledger: [`rounds/rh47/truths.md`](ROUND-TRUTHS.md).
The round's Lean layer is **empty** (`lean/Rh47/` has no module).

| result | statement | status |
|---|---|---|
| **Sylvester-sparsity theorem** | for the support `A = {m₁<m₂<…}` of the greedy word, `m_{i+1} ≥ m_i(m_i−1)+1` | PROVED (paper) + VERIFIED (53 159 pairs, 0 violations) |
| support density | `≈ 3.9·10⁻⁵` (sizes `2.95 → 3.90` as `N = 10² → 10⁵`) | VERIFIED |
| `\|A\| ≥ 20` empty domain | none of 19 900 rational targets with denominator ≤ 200 has `\|A\| ≥ 20` | CHECKED |
| **B1** (support carries `λ`-parity) | nominal `z = −47.9` killed by controls: `z = +0.43`, `+1.55` | **REFUTED** |
| **B2** (budgets carry `Ω`-parity) | index parity invisible to the correlation: twist identity exact | **REFUTED** |
| **B3** (ζ-machinery applies) | `f(n)=λ(n)λ(n+2)` not multiplicative; `\|D(2) − model\| = 2.0144 > 1.84·10⁻⁵` | **REFUTED** |
| correct sparse bound | `\|S_A−S\| ≤ 2·#{n≤x: n∈A ∨ n+2∈A} ≤ 4·#{m≤x+2: m∈A}` | PROVED (paper); rh46's `2·#{…}` is **REFUTED** (`A={5}`, `x=5`, `\|ΔS\|=4`) |
| R2 (barrier as a theorem) | no sign-blind `log n`-rule forces a multiplicative correlation | **OPEN — not yet well-posed** |
| R4 (Lean barrier formalisation) | — | **OPEN — rh47 Lean layer empty** |

The programme's verdict: the goal is **not reachable by this programme as it
stands** ([`rounds/rh47/truths.md`](ROUND-TRUTHS.md)).
