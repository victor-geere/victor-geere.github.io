# 1. The state of the Lean corpus (audit)

> Source: [`research/truths.md`](../../rh/research/truths.md), §1. Status language is the ledger’s own.

| development | location | build | `sorry` | axiom footprint |
|---|---|---|---|---|
| `Rh45` (Routes A/B/C, explicit formula) | [`twin-prime-parity/010/lean/`](../../rh/research/twin-prime-parity/010/lean) | `check.sh --all` **OK** (6/6: +`Archimedean`, +`RouteBAnalytic`) | 0 | clean |
| `Op56` (OP-5, OP-6) | [`twin-prime-parity/open/lean/`](../../rh/research/twin-prime-parity/open/lean) | `check.sh --all` **9/9 OK** (+`PhiFourth`, +`FloorAsymptotic`) | **0** | **clean** |
| `Op57` (Dirichlet L generalisation) | [`twin-prime-parity/007/lean/`](../../rh/research/twin-prime-parity/007/lean) | 5/5 OK | 0 | clean |
| `Op58` (automorphic/spectral attempt) | [`twin-prime-parity/008/lean/`](../../rh/research/twin-prime-parity/008/lean) | OK | 0 | clean |
| `Op59` (angle parity, Ω-signs) | [`twin-prime-parity/009/lean/`](../../rh/research/twin-prime-parity/009/lean) | OK | 0 | clean |
| `Rh41` (greedy digit word) | [`twin-prime-parity/rounds/rh41/lean/`](../../rh/research/twin-prime-parity/rounds/rh41/lean) | OK | 0 | 8 theorems use `native_decide` |
| `Rh42` (budgets, reachability, Tau) | [`twin-prime-parity/rounds/rh42/lean/`](../../rh/research/twin-prime-parity/rounds/rh42/lean) | OK | 0 | clean |
| `Rh43` (balance) | [`twin-prime-parity/rounds/rh43/lean/`](../../rh/research/twin-prime-parity/rounds/rh43/lean) | OK | 0 | clean |
| `Rh044` (smoothing) | [`twin-prime-parity/rounds/rh044/lean/`](../../rh/research/twin-prime-parity/rounds/rh044/lean) | OK | 0 | clean |
| `Rh46` (Chowla) | [`twin-prime-parity/rounds/rh46/lean/Rh46/Chowla.lean`](../../rh/research/twin-prime-parity/rounds/rh46/lean/Rh46/Chowla.lean) | OK (530 lines, 42 theorems; **all statements now proved** — OP-11 closed) | 0 | clean |
| `Rh47` (corrected sparse bound) | [`twin-prime-parity/rounds/rh47/lean/Rh47/Sparse.lean`](../../rh/research/twin-prime-parity/rounds/rh47/lean/Rh47/Sparse.lean) | OK (`check.sh --all`, 2/2; OP-12 closed) | 0 | clean |
| `VonMangoldtSieves` | [`publish/001-von-mangoldt-sieves/VonMangoldtSieves.lean`](../../rh/research/publish/001-von-mangoldt-sieves/VonMangoldtSieves.lean) | OK | 0 | clean |
| `ConeLean` (cone, parity obstruction) | [`../lean/ConeLean/`](../../rh/lean/ConeLean) | OK (11 modules) | 0 | clean |
| `TppLean` (three thresholds) | [`../lean/TppLean/`](../../rh/lean/TppLean) | OK | 0 | clean |

**Recorded caveats.**

1. ~~**`Op56.tailSum_integral_lower`** … a genuine `sorry`~~ — **now PROVED.** The
   lemma was **false** as written (`N + 1 ≤ M`; witness `p = 2`, `N = 0`, `M = 1`:
   LHS `0.25` vs `tailSum 2 1 = 0.16123…`). It is now a theorem under the corrected
   hypothesis **`N + 2 ≤ M`**, with the supporting helper `integral_two_mul_rpow`
   (`∫_{Ioi M} (2x)^{-p} = (2M)^{-p}·M/(p−1)`), and `#print axioms` is
   `[propext, Classical.choice, Quot.sound]`. It remains a documented, unused
   negative result (the antitone integral test is too lossy to prove completeness).
   The corpus is now **`sorry`-free**.
2. ~~**`native_decide` footprint** in `Op56`~~ — **removed (TODO item O2).** The
   `interval_cases j <;> native_decide` steps in `Op56.tsum_pow6_exp_neg_half_le` were
   replaced by `interval_cases j <;> norm_num [Nat.stirlingSecond]` /
   `[Nat.factorial]`, so **every probed `Op56` theorem now reports `#print axioms` =
   `[propext, Classical.choice, Quot.sound]`**, with no `native_decide` token anywhere in
   the development. The only remaining `native_decide` use in the whole corpus is the
   unrelated one in [`Rh41/DigitWord.lean`](../../rh/research/twin-prime-parity/rounds/rh41/lean/Rh41/DigitWord.lean)
   (eight theorems: `onset_not_determined_by_gaps`, the six `refuted_*` witnesses,
   `plateau_empty_example`, `c1_bound_gap_necessary`).

---
