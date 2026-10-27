# Major conjectures in scope

These are the external conjectures the programme tests against. They are not proved here. Statements are the standard ones, with the programme’s status label.

## Chowla’s conjecture

For distinct `h₁,…,h_k`,

```
Σ_{n≤x} λ(n+h₁)⋯λ(n+h_k) = o(x).
```

- `k = 1`: **theorem**, equivalent to PNT.
- `k ≥ 2`: **OPEN** for every fixed tuple. The `k = 2`, `h = (0,2)` case is the two-point target.
- Log-averaged: known for `k = 2` (Tao) and all odd `k` (Tao–Teräväinen); log-averaged even `k ≥ 4` is open.
- Source: [harvested items](summary-rh/03-open-problems/02-harvested-open-items.md), OP-1/OP-4.

## Twin prime conjecture

```
π₂(x) := #{p ≤ x : p+2 prime} ≫ x/(log x)².
```

**OPEN.** Bounded gaps (`H₁ ≤ 246`, unrefereed `≤ 240`) do not give gap `2`; Selberg’s parity barrier is unbroken for `(n,n+2)`. Chen’s `P₂` is a theorem; the step to `P₁` is exactly the barrier. Source: OP-16.

## Hardy–Littlewood / Dickson k-tuples

The quantitative prime-tuple asymptotics; `h = (0,2)` is the twin prime conjecture. **OPEN** for every `k ≥ 2`; heuristic as a prediction. Source: OP-16.

## Sarnak’s Möbius-disjointness

For every deterministic sequence `a` of zero entropy,

```
Σ_{n≤x} μ(n)a(n) = o(x).
```

**OPEN** in general. Chowla implies Sarnak; the equivalence is only log-averaged. Source: OP-4/OP-17.

## Elliott’s conjecture

For bounded multiplicative functions `g₁,…,g_k` with `Σ|1-g_j|` divergent, the correlations vanish on average. **OPEN** un-averaged; the programme records it as context, not as a target. Source: OP-4/OP-17.

## Selberg’s parity barrier

Not a conjecture but a barrier principle: purely sieve-theoretic information cannot distinguish integers with an even number of prime factors from those with an odd number. It is the reason the twin-prime and Chowla targets are out of reach for the programme’s sign-blind objects. The programme’s own barriers are recorded in [04-programme](summary-rh/04-programme/README.md).

## What is not claimed

The workspace is named `rh`, and several papers use the Riemann zeta function and the explicit formula, but **no paper here proves the Riemann hypothesis**, the twin prime conjecture, Chowla, Sarnak, or Elliott. The strongest new theorem is the finite-prefix indeterminacy theorem for the two-point Liouville correlation: it proves that no finite computation can decide the two-point Chowla statement. See [STATUS.md](summary-rh/STATUS.md).

[Back to folder README](summary-rh/03-open-problems/README.md) · [Back to the summary index](summary-rh/README.md)
