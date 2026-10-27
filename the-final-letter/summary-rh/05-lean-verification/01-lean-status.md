# Lean corpus — status

**Sources:** [`research/truths.md`](../../rh/research/truths.md) §1; [`research/open.md`](../../rh/research/open.md) §2.
**Headline:** there is **no `axiom` declaration anywhere** in the corpus, and **no literal `sorry` remains**. The last one, `Op56.tailSum_integral_lower`, was discharged by repairing its hypothesis to `N + 2 ≤ M` and proving it. The corpus is `sorry`-free.

## Developments

| development | location | build | `sorry` | axiom footprint |
|---|---|---|---|---|
| `Rh45` (Routes A/B/C, explicit formula) | [`twin-prime-parity/010/lean`](../../rh/research/twin-prime-parity/010/lean) | `check.sh --all` OK (6/6) | 0 | clean |
| `Op56` (OP-5, OP-6) | [`twin-prime-parity/open/lean`](../../rh/research/twin-prime-parity/open/lean) | 9/9 OK | 0 | clean |
| `Op57` (Dirichlet L generalisation) | [`twin-prime-parity/007/lean`](../../rh/research/twin-prime-parity/007/lean) | 5/5 OK | 0 | clean |
| `Op58` (automorphic/spectral attempt) | [`twin-prime-parity/008/lean`](../../rh/research/twin-prime-parity/008/lean) | OK | 0 | clean |
| `Op59` (angle parity, Ω-signs) | [`twin-prime-parity/009/lean`](../../rh/research/twin-prime-parity/009/lean) | OK | 0 | clean |
| `Rh41` (greedy digit word) | [`rounds/rh41/lean`](../../rh/research/twin-prime-parity/rounds/rh41/lean) | OK | 0 | 8 theorems use `native_decide` |
| `Rh42` (budgets, reachability, Tau) | [`rounds/rh42/lean`](../../rh/research/twin-prime-parity/rounds/rh42/lean) | OK | 0 | clean |
| `Rh43` (balance) | [`rounds/rh43/lean`](../../rh/research/twin-prime-parity/rounds/rh43/lean) | OK | 0 | clean |
| `Rh044` (smoothing) | [`rounds/rh044/lean`](../../rh/research/twin-prime-parity/rounds/rh044/lean) | OK | 0 | clean |
| `Rh46` (Chowla) | [`rounds/rh46/lean/Rh46/Chowla.lean`](../../rh/research/twin-prime-parity/rounds/rh46/lean/Rh46/Chowla.lean) | OK (530 lines, 42 theorems) | 0 | clean |
| `Rh47` (corrected sparse bound) | [`rounds/rh47/lean/Rh47/Sparse.lean`](../../rh/research/twin-prime-parity/rounds/rh47/lean/Rh47/Sparse.lean) | OK (2/2) | 0 | clean |
| `VonMangoldtSieves` | [`publish/001-von-mangoldt-sieves`](../../rh/research/publish/001-von-mangoldt-sieves) | OK | 0 | clean |
| `ConeLean` (cone, parity obstruction) | [`lean/ConeLean`](../../rh/lean/ConeLean) | OK (11 modules) | 0 | clean |
| `TppLean` (three thresholds) | [`lean/TppLean`](../../rh/lean/TppLean) | OK | 0 | clean |

## Caveats

1. **`Op56.tailSum_integral_lower`** was false as written (`N + 1 ≤ M`; witness `p=2, N=0, M=1`: LHS `0.25` vs `tailSum 2 1 = 0.16123…`). It is now a theorem under `N + 2 ≤ M`, with helper `integral_two_mul_rpow`. It remains a documented, unused negative result.
2. **`native_decide`** was removed from `Op56` (TODO item O2); every probed `Op56` theorem reports `[propext, Classical.choice, Quot.sound]`. The only remaining use is the unrelated one in `Rh41/DigitWord.lean` (eight theorems).
3. **Named hypotheses for Mathlib gaps.** `Rh45/Archimedean.lean` has two named hypotheses (digamma series estimate; single-panel Simpson error). `Rh45/RouteBAnalytic.lean` has two (rectangle argument principle; `ξ(conj s) = conj(ξ s)`); Mathlib has no `riemannXi`.

## What the Lean layer does not do

It does not prove RH, the twin prime conjecture, Chowla, Sarnak, or Elliott. It formalises the programme’s positive results, the finite-prefix theorem, OP-5/OP-6, and the corrected sparse bound. See [STATUS.md](../STATUS.md).

[Back to folder README](README.md) · [Back to the summary index](../README.md)
