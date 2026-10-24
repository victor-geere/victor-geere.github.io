# 008 — Greedy Sine vs the Parity Barrier

| Field | Value |
|---|---|
| Source | [`research/publish/008-parity-barrier/manuscript.md`](../../rh/research/publish/008-parity-barrier/manuscript.md) |
| Status | Published; truths ledger §8. No Lean layer. |
| Harvested statements | 1 |

## Abstract

This folder records one round of the twin-prime-conjecture project (math.solveathome.org) that asked whether the *greedy harmonic sine* can supply the positive-density coupling to $\Omega$ that the parity barrier requires. The answer is a sharpened **no**, and the round's own goal is **not achieved**: nothing here solves, or claims to solve, the twin prime conjecture or the parity problem, and $\sum_{n\le x}\lambda(n)\lambda(n+2)=o(x)$ remains **open**. The new structural fact is **Sylvester-sparsity**: for the support $A=\{m_1<m_2<\cdots\}$ of the greedy word, $m_{i+1}\ge m_i(m_i-1)+1$ — proved on paper and verified numerically with $0$ violations. It makes the specified test's domain empty and forces the support density to $\approx 3.9\cdot10^{-5}$. Three bridges from the greedy construction to $\lambda$-parity are tested and **refuted**, a false sparse bound inherited from `rh46` is corrected (with an explicit witness), and the round's own one-sentence barrier phrasing is **withdrawn** as too wide after audit. The impossibility statement stays a **heuristic, open**. There is deliberately **no Lean layer** in this folder: the round's Lean directory is empty and its formalisation obligation `R4` is open.

## Harvested theorem-like statements

### Theorem (Sylvester-sparsity).

Let $A(x)=\{m_1<m_2<\cdots\}$ be the support of the greedy word. Then
$$m_{i+1}\ \ge\ m_i(m_i-1)+1 .$$

*Proof sketch (as the sources carry it).* After taking $1/m_i$ the residual satisfies $r<1/\bigl(m_i(m_i-1)\bigr)$, so no index below $m_i(m_i-1)+1$ can be taken. $\square$

*Consequences.*

1. $|A|\ge 20$ forces $\max A\ge s_{20}$, an integer with **106 721 decimal digits**. Computing $\lambda$ at such an element would mean factoring a 106 721-digit integer, so the class of targets the specification's $|A|\ge20$ test asks for is empty of objects whose parity class exists for us.
2. The support density is $\approx 3.9\cdot10^{-5}$: measured $\overline{|A|}=2.95,3.25,3.60,3.90$ for $N=10^2,10^3,10^4,10^5$, i.e. density $2.95\cdot10^{-2},3.25\cdot10^{-3},3.60\cdot10^{-4},3.90\cdot10^{-5}$. The number of takes is $O(\log\log N)$ (`rh41`).

*Verification.* The current `greedy_parity_probe.py` reports **0 violations in 53 159 consecutive pairs** of the 20 320 computed supports. The shipped run log `logs/greedy_parity_probe.log` records the earlier revision's count, **0 violations in 52 969 consecutive pairs of the 20 300 computed supports**; both are reproduced in §4. The README and `TRUTHS.md` quote 53 159, the current script's number.

## Source

[`manuscript.md`](../../rh/research/publish/008-parity-barrier/manuscript.md) · [`README.md`](../../rh/research/publish/008-parity-barrier/README.md)
