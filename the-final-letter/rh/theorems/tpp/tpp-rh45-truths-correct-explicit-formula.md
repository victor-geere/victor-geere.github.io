# The correct explicit formula

**Kind:** Theorem
**Status:** VERIFIED (numerical, ≥ 20 digits on four kernels; auditor's independent route, 20–63 digits)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh45/truths.md`](../../research/twin-prime-parity/rounds/rh45/truths.md) — §1 "The correct explicit formula (this is the round's main result)"

## Statement

The round's first draft used `F(s) = ∫_ℝ g(u)e^{−su}du` with pole terms `F(1)+F(0)`.
**That is wrong twice**, and the auditor isolated both errors numerically.  The
correct Weil form, verified to ≥ 20 digits on four kernels, is:

> ```
> φ(t) = ∫_ℝ g(u) e^{i t u} du                  (Fourier transform of g)
> Φ(s) = φ((s − 1/2)/i) = ∫_ℝ g(u) e^{(s−1/2)u} du      (shifted Laplace transform)
>
> Σ_ρ Φ(ρ)  =  Φ(1) + Φ(0)                              [the poles of ζ, at s = 1, 0]
>            − Σ_{n≥2} (Λ(n)/√n)[g(log n) + g(−log n)]  [the primes]
>            + (1/2π) ∫_ℝ φ(t) Ψ(t) dt                  [the ARCHIMEDEAN term]
> Ψ(t) = −log π + Re ψ(1/4 + it/2),      Φ(1) + Φ(0) = 2φ(i/2) for even g.
> ```

**Verification of the corrected form** (auditor, K = 100 zeros, primes ≤ 2·10⁶):

| kernel | LHS | RHS − LHS | truncation bound |
|---|---|---|---|
| Gaussian `φ(t)=e^{−t²/2}` | 8.26·10⁻⁴⁴ | 1.56·10⁻⁴⁴ | 3.19·10⁻¹²¹⁵¹ |
| modulated Gaussian (`θ=γ₁`) | 1.0000000000500 | 9.63·10⁻⁴⁶ | 5.89·10⁻¹⁰⁷⁴³ |
| narrow Gaussian (`σ=1/4`) | 0.00388829070707 | −1.10·10⁻⁶³ | 2.67·10⁻⁷⁶¹ |
| Cauchy companion `a=1`: `g=(π/2)e^{−|u|}`, `φ(t)=π/(1+t²)` | 0.125394278977 | +0.0187 (vs truncation 0.0119) | zero side converges only like `log G/G` |

So the identity holds to 20+ digits for every properly decaying Gaussian-type
kernel; the Cauchy kernel at `a=1/2` is the boundary case (its prime sum
`π Σ Λ(n)/n` diverges like `π log N`, its zero side converges like `log G/G`),
which is why the naive Cauchy test in the draft could not work at all.

## Hypotheses and notation

- `g` is an even test function; `φ(t) = ∫_ℝ g(u)e^{itu}du` is its Fourier transform; `Φ(s) = φ((s−1/2)/i) = ∫_ℝ g(u)e^{(s−1/2)u}du` is the shifted Laplace transform.
- `Σ_ρ` runs over the nontrivial zeros `ρ` of `ζ`; `Λ` is the von Mangoldt function; `ψ` is the digamma function; the prime sum runs over `n ≥ 2`.
- Pole terms: `Φ(1) + Φ(0)` (the poles of `ζ` at `s = 1, 0`), which equal `2φ(i/2)` for even `g`.
- Archimedean term: `(1/2π) ∫_ℝ φ(t) Ψ(t) dt` with `Ψ(t) = −log π + Re ψ(1/4 + it/2)`.
- Numerical setting of the table: `K = 100` zeros, primes `≤ 2·10⁶`.

## Proof / evidence

- **PROVED** by the source as the algebraic layer only (Lean `Rh45/Explicit.lean`, `./check.sh --all` exit 0, no `sorry`): kernel evenness and positivity, the `s ↔ 1−s` symmetry of the shifted kernels, the pole-pair reduction `polePair F = 2F(1/2+1/2)`, the prime-side even splitting `primeSide = 2·primeSideLog`, the monotone smoothed count `zeroSum`, the exact main term with the constant `7/8`, and `∫_ℝ (π/2)e^{−|u|/2}cos(tu)du = (π/2)·1/(1/4+t²)`.
- **VERIFIED** by the auditor on an independent route (own zero table, own `Z(t)`, own constant derivation) to 20–63 digits on the four kernels tabulated above.
- The round's own numerics script [`explicit_formula.py`](../../research/twin-prime-parity/rounds/rh45/explicit_formula.py) had its run interrupted; the source states the formula and the zero table rest on the auditor's independent route, [`verify/independent_check.py`](../../research/twin-prime-parity/rounds/rh45/verify/independent_check.py), which scored **17/21** (the 4 failures are over-strong criteria of the main agent's prompt, see §3).
- The identity itself is not formalised in Lean; the Lean development covers the algebraic layer listed above.

## Dependencies and related results

- [The counting formula (T2/T3, the robust core)](tpp-rh45-truths-counting-formula.md).
- [The first draft's explicit formula is wrong twice](tpp-rh45-truths-draft-formula-refuted.md) — the C1d decomposition of the draft's two errors.
- [C1e (Cauchy a = 1/2 to 20 digits) is refuted as stated](tpp-rh45-truths-cauchy-boundary-case-refuted.md) — the boundary kernel.
- The same corrected formula is stated in [`README.md`](../../research/twin-prime-parity/rounds/rh45/README.md) (harvested as [The instrument — and the correct form of the formula](tpp-rh45-readme-correct-explicit-formula.md)).

## Notes

- The source calls this "the round's main result" and stresses it is not a new explicit formula: "No new explicit formula, no improvement of the Riemann–Siegel formula, no new zero-free region, no RH progress."
- The source flags the Cauchy companion `a=1` as verified only at ~2 digits, limited by the zero-side tail estimate; the four-kernel ≥ 20-digit statement is for the Gaussian-type kernels.
- The source's §7 records as **OPEN** a kernel meeting all three admissibility conditions (decay at the nontrivial zeros, compactly supported `g`, decay at the trivial zeros `s = −2, −4, …`) with which the exact identity can be pushed to 20+ digits in the **zero** sum, and the archimedean term in the Lean development (only the real-integral core is formalised so far). Those open items are not harvested.
