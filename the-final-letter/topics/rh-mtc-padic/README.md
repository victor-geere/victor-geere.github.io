# RH-MTC / p-adic MTC — reconstructed research programme

**Status:** archived claim, duplicate of the adelic programme; finite MTC/RT bookkeeping reconstructed as a formal core, the global RH argument left archived.  
**Source:** [`archive/maths/rh/research/rh-mtc/padic-mtc.html`](../../archive/maths/rh/research/rh-mtc/padic-mtc.html), with the companion [`thesis.html`](../../archive/maths/rh/research/rh-mtc/thesis.html), the prompt/obstruction notes [`resolve-obstructions.md`](../../archive/maths/rh/research/rh-mtc/resolve-obstructions.md), and the LaTeX fragments in `proof-part-1/` and `proof-part-2/`.  
**Inventory:** [Scraps](../../scraps.html) item 21 · [Topic index](../README.md).

## What the programme is

The archived source proposes a proof of the Riemann hypothesis by combining three ingredients:

1. the Bruhat–Tits tree `T_p` of `PGL(2, Q_p)`, with a shift `σ_p` induced by multiplication by `p` on the boundary `P¹(Q_p)`;
2. a prime-indexed family of modular tensor categories `C_p = SU(2)_{p-2}` at `q = exp(π i / p)`, used to colour framed braids attached to periodic orbits of `σ_p`;
3. a restricted tensor product of local transfer operators whose Fredholm determinant is asserted to be the completed zeta function.

The source's central local assertion is that the Reshetikhin–Turaev invariant of the braid attached to a length-`n` periodic orbit equals `p^{-n}`; the local determinant is then asserted to be `(1 - p^{-s})^{-1}`. The global argument then claims the functional equation, a self-adjointness/entropy argument, a vanishing winding number, and the Riemann hypothesis.

The source is **fragmentary and internally incomplete**. The main page states the global claims without full proofs. The companion `thesis.html` is a skeleton whose sections are marked `TODO`. The prompt tree in `resolve-obstructions.md` explicitly records two unfinished obstructions: the missing explicit Seifert invariants of the braid closure and the mismatch `G_p ≠ τ_p` in the Gauss-sum evaluation. Most importantly, the appendix identity

\[
\sum_j d_j^{(p)}\,\theta_j^{(p)}\,S_{jj'} \stackrel{?}{=} \tau_p\,S_{0j'},
\qquad \tau_p = e^{\pi i/4}p^{-1/2}
\]

is **false for small primes**: the reconstruction's own high-precision test finds residuals of order one (for example `1.014` at `p = 3` and `1.905` at `p = 5`). This is consistent with the archived obstruction note's admission that `G_p ≠ τ_p`. The identity is therefore recorded as a failed source claim, not used as a theorem.

This folder reconstructs the finite part that can be stated and checked: the `SU(2)_{p-2}` quantum dimensions and Verlinde matrix, the proposed normalised RT weight `p^{-n}`, and the exact local Euler-factor bookkeeping. It does **not** claim the geometric RT invariance `RT(β) = p^{-n}`, the existence of the global operator, or any consequence for the zeta function.

## Reconstructed objects and notation

| Object | Definition / reconstruction |
|---|---|
| Prime | `p` an odd prime, `p ≥ 3` (the source's domain). |
| Category | `C_p = SU(2)_{p-2}`, with `q = exp(π i / p)`. |
| Simple objects | Spins `j = 0, 1/2, 1, …, (p-2)/2`; there are `p - 1` of them. |
| Quantum dimension | `d_j = sin((2j+1)π/p) / sin(π/p)`. |
| Total quantum dimension | `D_p² = Σ_j d_j² = p / (2 sin²(π/p))`. |
| Verlinde matrix | `S_{jj'} = sqrt(2/p) sin((2j+1)(2j'+1)π/p)`. |
| Twist | `θ_j = exp(π i (j(j+1) - 1/4)/p)`, with `T_{jj'} = δ_{jj'} θ_j`. |
| Orbit weight | `w_p(n) = p^{-n}`, the source's proposed normalised local RT weight. |
| Local Euler factor | `1 - w_p(1) = 1 - 1/p`. |
| Local determinant at `s = 1` | `(1 - p^{-1})^{-1} = p/(p-1)`. |

The Lean definition `PadicMTC.rtWeight p n` is exactly `w_p(n) = p^{-n}`. The theorems below concern this explicitly defined bookkeeping object. They do not assert that a geometrically defined Reshetikhin–Turaev invariant evaluates to it.

## Theorem ledger

Every row marked **Theorem** is proved in [`lean/Topic.lean`](lean/Topic.lean) with no `sorry`, `axiom`, or `admit`. Every row marked **Computation** is exercised in [`tests/test_programme.py`](tests/test_programme.py). Source claims and open items are not theorems of this reconstruction.

| # | Kind | Statement | Lean / test evidence |
|---|---|---|---|
| T1 | Theorem | `w_p(n) > 0` for every prime `p > 0` and every `n`. | `PadicMTC.rtWeight_pos` |
| T2 | Theorem | `w_p(n+m) = w_p(n) w_p(m)`: concatenating orbits multiplies weights. | `PadicMTC.rtWeight_mul` |
| T3 | Theorem | For `p > 1`, `n ↦ w_p(n)` is strictly decreasing. | `PadicMTC.rtWeight_strictAnti` |
| T4 | Theorem | `w_p(n) ≤ 1` for `p ≥ 1`. | `PadicMTC.rtWeight_le_one` |
| T5 | Theorem | Finite Euler bookkeeping: `(1 - w_p(1)) Σ_{k<N} w_p(k) = 1 - w_p(N)`. | `PadicMTC.partial_sum_bookkeeping` |
| T6 | Theorem | The local weights sum to the Euler value: `Σ_n w_p(n) = p/(p-1)` for `p > 1`. | `PadicMTC.hasSum_rtWeight` |
| T7 | Theorem | `w_p(n) → 0` as `n → ∞` for `p > 1`. | `PadicMTC.rtWeight_tendsto_zero` |
| C1 | Computation | `w_p(n) = 1/p^n` exactly, is multiplicative in `n`, positive, and strictly decreasing for `p ≤ 23`, `n, m ≤ 8`. | `test_rt_weight_is_exact_multiplicative_and_positive` |
| C2 | Computation | The exact partial sums satisfy `Σ_{k<N} p^{-k} = (1 - p^{-N})/(1 - p^{-1})`, and `(1 - p^{-1}) · p/(p-1) = 1`. | `test_local_determinant_bookkeeping_is_exact` |
| C3 | Computation | The exact sine sum `Σ_{r=1}^{p-1} sin²(rπ/p) = p/2` and hence `D_p² = p/(2 sin²(π/p))` to `10⁻⁴⁰` for `p ≤ 23`. | `test_total_quantum_dimension_identity_exactly_and_numerically` |
| C4 | Computation | `C_p` has `p - 1` simple objects; `d_0 = d_{(p-2)/2} = 1`. | `test_simple_object_count_and_quantum_dimension_edge_values` |
| C5 | Computation | `S` is symmetric and `S² = I` to `10⁻³⁰` for `p ≤ 13`. | `test_verlinde_s_matrix_is_a_symmetric_involution` |
| C6 | Computation | The archived Gauss-sum identity fails, with residual `> 0.1`, for `p ∈ {3,5,7,11}`. | `test_archived_gauss_sum_identity_fails` |
| C7 | Computation | Out-of-domain primes (`2, 4, 9, 15`), negative lengths, and out-of-range spins are rejected. | `test_out_of_domain_primes_and_spins_are_rejected` |
| S1 | Source claim | The RT invariant of the braid from any length-`n` periodic orbit equals `p^{-n}`. | Archived claim; proof only sketched. Not formalised. |
| S2 | Source claim | The tree shift has `p^n + 1` length-`n` periodic orbits. | Archived claim; not established here. |
| S3 | Source claim | The local Fredholm determinant is `(1 - p^{-s})^{-1}` for `Re(s) > 1`. | Archived claim; only the `s = 1` arithmetic bookkeeping is reconstructed. |
| S4 | Source claim | The global determinant equals `ζ̂(s) e^{P(s)}`. | Archived claim; no operator is constructed here. |
| S5 | Source claim | The functional equation follows from modular invariance of a product theta series. | Archived claim; not formalised. |
| S6 | Source claim | The entropy/Perron–Frobenius argument excludes zeros off the critical line. | Archived claim; not formalised. |
| S7 | Source claim | The winding number vanishes and the Riemann hypothesis follows. | Archived claim; RH is **not** proved here. |
| S8 | Source claim | The Gauss-sum identity `Σ_j d_j θ_j S_{jj'} = τ_p S_{0j'}` holds. | Archived claim contradicted by C6; obstruction notes concede `G_p ≠ τ_p`. |
| O1 | Open / conjecture | Give a precise construction of the framed braid and its Seifert invariants from a tree orbit. | Open; missing in the source. |
| O2 | Open / conjecture | Prove or repair the periodic-orbit count `p^n + 1`. | Open; the boundary map `z ↦ pz` appears to have only the fixed points `0` and `∞`. |
| O3 | Open / conjecture | Derive `RT(β) = p^{-n}` from the Verlinde/Kirby–Melvin formula. | Open; the source's Gauss-sum route fails. |
| O4 | Open / conjecture | Define the local operator and prove its Fredholm determinant. | Open; only its proposed weight series is reconstructed. |
| O5 | Open / conjecture | Construct the restricted tensor product and prove the global determinant identity. | Open; no such operator is defined in the source. |
| O6 | Open / conjecture | Establish any bridge from this categorical data to the zeros of `ζ`. | Open; the archived RH conclusion is unsupported. |

### Source claims, with their archived status

| Claim | Source status | Reconstruction note |
|---|---|---|
| Complete proof of RH via adelic transfer operators and prime-indexed MTCs | Archived claim, stated as a theorem in the source | Not a theorem here. The source's own companion materials are incomplete, and the Gauss-sum step fails. |
| Exact local RT weight `p^{-n}` | Source "Theorem 4" with a proof sketch | Only the arithmetic weight `w_p(n) = p^{-n}` is formalised (T1–T7); its geometric realisation is open (O3). |
| `p^n + 1` periodic orbits | Source claim in §3 | Not formalised; the stated count is not derived from the boundary dynamics. |
| Local determinant `(1 - p^{-s})^{-1}` | Source claim in §5 | The `s = 1` Euler-factor sum is proved (T5–T6); the Fredholm determinant itself is not defined. |
| Global determinant `ζ̂(s) e^{P(s)}` | Source claim in §5 | Not formalised. |
| Functional equation from modular invariance | Source claim in §6 | Not formalised. |
| Reality of the spectrum/entropy exclusion | Source proposition in §7 | Not formalised. |
| Vanishing winding number and RH | Source claim in §8 | Not formalised; recorded as an archived claim, never as a theorem. |
| Appendix Gauss-sum identity | Source claim | Fails numerically (C6); explicitly flagged by the archived obstruction notes. |

## Open items and known gaps

1. **The source is not a proof.** The main HTML advertises a complete unconditional proof, but the companion thesis is a `TODO` skeleton, the prompt tree lists unresolved obstructions, and the appendix identity is false for small `p`. Treat the whole document as an archived claim.
2. **The braid-to-manifold construction is missing.** No explicit braid word, framing, or Seifert data is supplied, so `RT(β)` is not even defined in the source.
3. **The local weight is assumed, not derived.** The formal core defines `w_p(n) = p^{-n}` and proves its bookkeeping properties. It does not prove that a Reshetikhin–Turaev invariant equals it.
4. **The global operator does not exist in the source.** The restricted tensor product, its domain, self-adjointness, and the determinant identity are all asserted without construction.
5. **No RH consequence is established.** The entropy and winding-number arguments are sketches; even if the local determinant were correct, the passage to the zeros of `ζ` would remain open.

## Python layer

[`python/programme.py`](python/programme.py) implements:

- `simple_spins(p)`, `simple_object_count(p)`, `quantum_dimension(p, j)`, `total_quantum_dimension_sq(p)`;
- `sine_square_sum_exact(p)` (exact cyclotomic computation);
- `rt_weight(p, n)`, `local_partial_sum`, `local_partial_sum_closed`, `local_factor`, `local_determinant_limit`;
- `verlinde_s(p, j, jp)`, `verlinde_s_squared_error(p)`;
- `archived_gauss_sum_residual(p)`, which records the failure of the archived Gauss-sum identity;
- `is_source_prime(p)` for the source's domain.

Exact arithmetic uses `fractions.Fraction` and `sympy`; the `S`-matrix and Gauss-sum checks use `mpmath` at 40 decimal digits. The tolerance is `10⁻³⁰` for `S² = I` and `10⁻⁴⁰` for the quantum-dimension identity.

```bash
cd the-final-letter/topics/rh-mtc-padic
python3 -m pytest -q tests
```

Current result: **7 passed** (about 3.5 s).

## Lean layer

[`lean/Topic.lean`](lean/Topic.lean) imports Mathlib, works in the namespace `PadicMTC`, defines `rtWeight p n = 1 / p^n`, and proves T1–T7. The proofs use only elementary order, power, geometric-series, and field facts. There is no `sorry`, `axiom`, or `admit`.

```bash
cd the-final-letter/topics/rh-mtc-padic
./lean/check.sh 2>&1 | tee lean/BUILD.log
```

The recorded build is [`lean/BUILD.log`](lean/BUILD.log). See [`lean/README.md`](lean/README.md) for the precise boundary between the formal core and the archived claims.

## Provenance and links

- Source page: [`padic-mtc.html`](../../archive/maths/rh/research/rh-mtc/padic-mtc.html) — inventory item 21, marked *archived claim* and *duplicate*.
- Companion thesis: [`thesis.html`](../../archive/maths/rh/research/rh-mtc/thesis.html) — incomplete, section-by-section `TODO`.
- Obstruction notes: [`resolve-obstructions.md`](../../archive/maths/rh/research/rh-mtc/resolve-obstructions.md) — records the missing Seifert invariants and `G_p ≠ τ_p`.
- Prompt tree: [`RH_Prompt_Tree_Padic_MTC.md`](../../archive/maths/rh/research/rh-mtc/RH_Prompt_Tree_Padic_MTC.md).
- Overlapping programme: [adelic transfer operator](../adelic-transfer-operator/README.md).
- Inventory: [`scraps.html`](../../scraps.html) · [Topic index](../README.md).

[Back to the topic index](../README.md) · [Scraps](../../scraps.html) · [The Final Letter](../../index.html)
