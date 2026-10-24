# Proofs

This is the proof ledger of the unified programme. It separates four things that are often conflated:

1. **Proved in the source** — a written proof in a paper or ledger.
2. **Machine-checked** — a Lean proof in the source repository.
3. **Conversion** — a proved equivalence that does not prove either side.
4. **Sharpness/litmus** — a proved negative result showing that a class of methods cannot close the wall.

## A. The Riemann side

### A1. The conversion theorem

**Statement.** The following are equivalent:

1. every non-trivial zero of `Ξ` lies on the critical line;
2. every unrestricted path-closure is balanced for all sufficiently large `N`;
3. every weak-star limit of the unrestricted measures is supported on the critical line;
4. the balanced and unrestricted limiting measures coincide, with common support the non-trivial zeros.

**Status:** proved equivalence; it does not prove RH.

Source: [`summary/05`](../../summary/05-spectral-measures-and-tightness/13-corollary-12.3.md), `publication.html` Corollary 12.3.

### A2. The Davenport–Heilbronn sharpness theorem

**Statement.** At Spira’s off-line zero `ρ_DH = 0.80851718… + 85.69934849… i`, the relative test fires and the prefactor test fails, so the DH measures have different supports. The conversion returns the correct verdict where RH is false.

**Status:** proved. It shows the conversion is sharp.

Source: [`summary/06`](../../summary/06-davenport-heilbronn/09-theorem-c.9.md).

### A3. The limitative consequence

**Statement.** No theorem deducible from the additive toolbox (Euler-sum pair, Euler–Maclaurin, Jensen, Rouché, minimum principle, Riemann–von Mangoldt, classical floor) can imply RH. Any such theorem would apply verbatim to the DH twist and contradict A2.

**Status:** proved. This is the formal version of “the additive toolbox cannot prove RH.”

Source: [`summary/06`](../../summary/06-davenport-heilbronn/10-corollary-c.10.md).

### A4. The tensor refutation and repair

**Statement.** The proposed inequality `(★)` is false; the witness gives `−0.677302…`. The correct positive statement is Weil positivity for the repaired current `W`; its spectral resolution is exactly the zero measure.

**Status:** proved (Theorem B and Theorem C in `tensor.md`).

Source: [`summary/10`](../../summary/10-prime-spectrum-tensor/README.md).

### A5. The modular shadow and straightening field

**Statement.** The modular shadow is exact at positive integer weight and has no transfer to complex zeros. The straightening field’s holonomy is the zero count; under the Rouché condition (E.1), the count is computable from two finite Euler sums.

**Status:** proved, with (E.1) as an explicit hypothesis.

Source: [`summary/07`](../../summary/07-modular-shadow/README.md), [`summary/08`](../../summary/08-straightening-field/README.md).

## B. The parity side

### B1. The factor-complexity law

**Statement.** For the greedy word, with `L ≥ max(span, a_m+1)`,

```
p(L) = min(a_m+1, N−L+1) + [L ≤ N−a_m−1].
```

**Status:** proved; Lean-certified in `Rh41`.

Source: [`summary-rh/01/02`](../../summary-rh/01-ledger/02-the-greedy-digit-word-and-the-complexity-law-rh41.md).

### B2. Budgets, Brown reachability, parity lock

**Statement.** `P = 2^{−p}ζ`, `N = (1−2^{−p})ζ−1`, `P+N = ζ−1`, `P−N = 1−η`, `P > N`; Brown’s criterion; the signed support is parity-locked.

**Status:** proved; Lean at `p=2,4`.

Source: [`summary-rh/01/03`](../../summary-rh/01-ledger/03-budgets-reachability-and-the-tau-alphabet-rh42.md).

### B3. Balance and the equal split

**Statement.** `P_N + M_N = Re S_N`; balance is equivalent to `Re S_N = 0`; balance is attained for every `N ≥ 2`; `S_3(t) ≠ 0` for all `t`; `S_2(π/log 2) = 0`.

**Status:** proved; Lean-certified.

Source: [`summary-rh/01/04`](../../summary-rh/01-ledger/04-partial-sums-at-re-s-0-and-the-equal-split-rh43.md).

### B4. Smoothing does not remove `√N`

**Statement.**

```
|S_N^φ(1/2+it) − ζ(1/2+it)| / √N → |M_φ(s)|,
```

with `M_φ(s)=∫₀¹ φ(u)u^{−s}du`.

**Status:** proved (paper) + verified numerically.

Source: [`summary-rh/01/05`](../../summary-rh/01-ledger/05-the-smoothing-bridge-rh044.md).

### B5. The corrected explicit formula

**Statement.** The Weil explicit formula with the archimedean term; `N(T)=θ(T)/π+1+S(T)`; finite-window certificates `T=15`, `T=33`.

**Status:** proved (paper) + verified; the `T=15/33` certificates are unconditional finite-window statements, not RH.

Source: [`summary-rh/01/06`](../../summary-rh/01-ledger/06-the-explicit-formula-and-routes-a-b-c-rh45-010.md).

### B6. Finite-prefix indeterminacy

**Statement.** For every `a ≠ 0` and every `h`, there is a function `g` that agrees with `λ` below `a`, differs from `λ`, and reproduces `corr h N` on every prefix with `N+h<a`. The slice perturbation at the flipped index is

```
corrSlice h a a − corr h a = −2λ(a)λ(a+h) − 2λ(a−h)λ(a).
```

**Status:** proved; Lean-certified.

Source: [`summary-rh/01/07`](../../summary-rh/01-ledger/07-two-point-chowla-and-the-finite-prefix-theorem-rh46.md).

### B7. Sylvester sparsity and no Euler product

**Statement.** The greedy support satisfies `m_{i+1} ≥ m_i(m_i−1)+1`, density `≈3.9·10⁻⁵`; `f(n)=λ(n)λ(n+2)` is not multiplicative; no Euler product.

**Status:** proved + verified; `shiftProd` non-multiplicativity Lean-certified.

Source: [`summary-rh/01/08`](../../summary-rh/01-ledger/08-greedy-sine-vs-the-parity-barrier-rh47.md).

### B8. One-point Chowla is PNT

**Statement.** `Σ_{n≤x}λ(n)=o(x)` is equivalent to PNT.

**Status:** theorem (classical). Correction X1.

Source: [`summary-rh/04/03`](../../summary-rh/04-programme/03-corrections-x1-x6.md).

## C. The Lean spine

The `the-final-letter/lean/` development builds against the same Lean 4 + Mathlib installation as `~/workspace/rh`:

```
cd the-final-letter/lean
./check.sh --all
# [check] OK FinalLetter/Chowla.lean
# [check] OK FinalLetter/Synthesis.lean
# [check] OK FinalLetter.lean
```

- `FinalLetter/Chowla.lean` is the vendored, `sorry`-free finite-prefix development from `rh46`.
- `FinalLetter/Synthesis.lean` defines `RiemannHypothesis`, `TwinPrimeConjecture`, `ChowlaTwoPoint`, `corrOf`, `AgreesBelow`, and proves `finite_prefix_indeterminacy`, `slice_perturbation`, `finite_prefix_witness`, `corr_abs_le`, `corr_zero`, `corrAsymptotic_zero_false`, `shiftProd_not_completely_multiplicative`, and `slice_l2_mass`.
- The open statements are `def`s, not `axiom`s. The build contains no `sorry` and no new axiom.

See [Lean formalisation](lean.md) for the theorem inventory and build instructions.

## D. What is not proved

RH, the twin-prime conjecture, Chowla for `k ≥ 2`, Sarnak, Elliott, `(M)`, OP-19, F.4, `Λ=0`, the Jensen/Li tower, and uniform slow passage. The proof ledger is not a proof of the walls; it is a proof of the map.

[Back to README](README.md) · [Back to index](../../index.html)
