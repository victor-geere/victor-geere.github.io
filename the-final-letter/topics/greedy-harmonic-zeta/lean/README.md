# Lean formal core — greedy harmonic zeta

## Build

```bash
cd the-final-letter/topics/greedy-harmonic-zeta
./lean/check.sh 2>&1 | tee lean/BUILD.log
```

The script wraps the shared `../../tools/check-lean.sh` and elaborates `Topic.lean` against the local Mathlib installation (`~/lean/mathlib4`, Lean `v4.35.0-rc2`). The committed `BUILD.log` records the last successful check.

## What is proved

`Topic.lean` defines, in the namespace `GreedyZeta`:

- `term σ n = (n+1)^(-σ)`;
- `zetaPartial σ N` and `etaPartial σ N`, the finite Dirichlet and eta sums;
- `corr S w = Re(S * conj w)`, the real correlation used by the greedy step.

It proves:

| Name | Statement |
|---|---|
| `term_pos` | `0 < term σ n` |
| `term_strictAnti` | for `σ > 0`, `term σ` is strictly decreasing |
| `eta_zeta_even` | `etaPartial σ (2m) = zetaPartial σ (2m) − 2·2^(−σ)·zetaPartial σ m` |
| `eta_zero_even` | `etaPartial 0 (2m) = 0` |
| `eta_zero_odd` | `etaPartial 0 (2m+1) = 1` |
| `normSq_add_corr` | `normSq (S+w) = normSq S + normSq w + 2·corr S w` |
| `greedy_closer` | `corr S w ≤ 0 → normSq (S+w) ≤ normSq (S−w)` |

The finite eta–zeta identity is the truncation of `η(s) = (1 − 2^(1−s)) ζ(s)`. The last two results are the genuine quadratic content of the source's greedy step.

Every declaration is fully proved. The file contains no unfinished proof, no extra axiom, and no placeholder.

## What is not formalised

- The complex identity `η(s) = (1 − 2^(1−s)) ζ(s)` and the analytic continuation of the eta series.
- The Riemann–Siegel formula, the approximate functional equation, and any uniform error bounds.
- The source's claimed equivalence between the greedy condition and the critical line (Theorem 4.1), and hence the claimed reformulation of RH (Theorem 5.1). RH is not proved here.
- The critical-exponent theorem of the v3 paper. Its `α > 1/2` step assumes a zero-free half-plane, which is essentially the conclusion; the file does not formalise or validate that argument.
- The density-of-phases lemma, the energy monotonicity of the addendum, and the v2 conjecture.

## A note on the source's greedy condition

Definition 2.1 of the primary source asks for `Re(conj(S_{N-1}) w_N) ≤ 0` for all `N`, while the alternating series subtracts `w_N` at even `N`. The condition for the alternating sign itself to be greedy is the signed version `(-1)^(N-1) Re(conj(S_{N-1}) w_N) ≤ 0`. The Lean theorem `greedy_closer` proves the unsigned comparison `|S+w|² ≤ |S−w|²` under `corr S w ≤ 0`; it does **not** assert that the source's condition is equivalent to the alternating choice.

The Python layer computes both readings at the first zeta zero: the raw condition first fails at `N = 4`, and the sign-corrected condition fails at `N = 2`. These are recorded as computations, not as Lean theorems, and they are not a disproof of RH.

## Relation to the programme

The programme dossier is [`../README.md`](../README.md); the browser version is [`../index.html`](../index.html). The archived source and its companions are under `archive/maths/rh/research/greedy-harmonic-zeta/`.

[Back to the programme](../README.md) · [Topic index](../../README.md)
