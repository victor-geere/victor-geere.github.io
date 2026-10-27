# Lean core — Euler–Maclaurin layer

## Build

```bash
cd the-final-letter/topics/euler-maclaurin
./lean/check.sh
```

`check.sh` elaborates `Topic.lean` against the shared Mathlib at
`~/lean/mathlib4` through [`../../tools/check-lean.sh`](../../tools/check-lean.sh).
The canonical build of the same file is recorded in
[`../../partial-sum-plus-tail/lean/BUILD.log`](../../partial-sum-plus-tail/lean/BUILD.log)
(`[check] OK EulerMaclaurin.lean (41s)`).

## The mirror

`Topic.lean` is a byte-for-byte copy of
[`../../partial-sum-plus-tail/lean/EulerMaclaurin.lean`](../../partial-sum-plus-tail/lean/EulerMaclaurin.lean).
The test `test_lean_mirror_matches_canonical_file` fails if the two diverge, so
this dossier cannot silently document a different theorem from the one the
programme cites. The canonical file, not this copy, is the place to edit; the
copy is refreshed from it.

## What the file proves

It defines `periodicBernoulli` and a non-periodic `hurwitzZetaNP`, proves the
ordinary Hurwitz series for `Re s > 1` and differentiability away from
`s = 0, 1`, the general finite Euler–Maclaurin identity for smooth functions
and for the Hurwitz term, Fourier inversion and the Bernoulli supremum bound,
the iterated derivative formula and the integrability of every derivative, the
integral form of the S2 tail bound, and the combined S1 decomposition and S2
tail bound for `K ≥ 1`:

- `finite_eulerMaclaurin`, `finite_eulerMaclaurin_hurwitz`;
- `hasSum_periodicBernoulli_fourier`,
  `iSup_norm_periodicBernoulli_odd_le_zeta`;
- `differentiableAt_hurwitzZetaNP`, `iteratedDeriv_hurwitzTerm_eqOn`,
  `integrableOn_iteratedDeriv_hurwitzTerm`;
- `norm_integral_periodicBernoulli_mul_odd_le`;
- `hurwitzZetaNP_eq_eulerMaclaurin`,
  `hurwitzZetaNP_eulerMaclaurin_with_bound`.

The full ledger is T36–T43 in the [dossier README](../README.md#theorem-ledger)
and in [Proofs C](../../../categories/05-proofs/proofs.md#c-the-certified-evaluation-layer).

## What is not formalised

- The replay wiring: instantiating S1/S2 at the evaluator's parameters and
  connecting it to the certificate `Replay` for arbitrary `s`.
- A certified width bound.
- Any use of the enclosure as a hypothesis in a theorem about a wall.

No `sorry`, no `axiom`, no `admit`.

[Back to the dossier](../README.md) · [Topic index](../../README.md)
