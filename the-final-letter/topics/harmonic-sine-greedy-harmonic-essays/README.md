# Harmonic sine / greedy harmonic essays — research programme

**Status:** reconstructed finite formal core + exact computation layer. The source's Riemann-hypothesis claim is **archived, retracted and superseded**; it is not a theorem here, and neither are its zeta-bridge claims.  
**Source:** [`archive/essays/harmonic-sine-rh-proof.html`](../../archive/essays/harmonic-sine-rh-proof.html) — “A Formal Proof of the Riemann Hypothesis via Harmonic Sine Reconstruction” (Victor Geere, 7 March 2026), whose own header reads **“[Retracted. See: Version 2]”**.  
**Inventory:** [Scraps](../../scraps.html) item 38 · [Topic index](../README.md).

## Provenance and what this folder is

The inventory tags item 38 as *archived claim* and *superseded*; it does not describe it as a duplicate of items 15 and 17. The source is one of those essay versions: a nine-section manuscript that opens with the harmonic reconstruction of `sin`, then builds a “zeta bridge”, an energy functional, an extended Matomäki–Radziwiłł discorrelation estimate, a “harmonic sheaf”, and finally a claimed proof of the Riemann hypothesis. The first line of the document retracts the claim and points to a “Version 2”.

What is genuine and self-contained in the source is the **finite harmonic-sine core**:

- the harmonic angle sequence `α_n = π/(n+2)` and its partial-sum identity;
- the greedy selection rule `δ_n(θ) = Θ(θ − θ_n − α_n)`;
- the fusion step, i.e. the sine/cosine addition formula applied whenever `δ_n = 1`;
- the elementary invariant and residual facts that make the finite construction work.

That core is reconstructed here. The analytic limit, the zeta bridge, the discorrelation extension, the sheaf, and the RH conclusion are recorded as **source claims** (with their archived status) or as **open items**. Three of the source's own intermediate statements are false as written; the errata below record them, and the Python layer demonstrates two of them exactly.

This folder deliberately does **not** repeat the older `harmonic-sine` folder's half-angle reconstruction. It takes the angle/fusion/greedy layer from the essay version and adds the harmonic-number identity and the finite greedy recursion that the essay states but never proves.

## Reconstructed objects and notation

The target is an angle `θ ∈ [0, π]`. For exact computation it is written as `θ = π x` with `x ∈ [0, 1]`, and all comparisons are made in `ℚ`.

| Object | Definition |
|---|---|
| Harmonic angle | `α n = π / (n + 2)` |
| Scaled angle | `a n = 1 / (n + 2)`, so `α n = π · a n` |
| Partial harmonic identity | `Σ_{n=0}^{N} α n = π (H_{N+2} − 1)` |
| Selection word | `δ n ∈ {0,1}`, `δ n = 1` iff `θ − θ n ≥ α n` |
| Accumulated angle | `θ N = Σ_{n<N} δ n α n` (Lean: `greedy θ N`) |
| Residual | `r N = θ − θ N` |
| Fusion step | `(s, c) ↦ (s cos α + c sin α, c cos α − s sin α)` |
| Selection indicator (Lean) | `selected θ n = decide (α n ≤ θ − greedy θ n)` |
| Phase series | `Φ(s, θ) = Σ_n δ n(θ) (n+2)^{−s}` |

## Theorem ledger

Every row marked **Theorem** is proved in [`lean/Topic.lean`](lean/Topic.lean) with no `sorry`, `axiom` or `admit`. Every row marked **Computation** is tested in [`tests/test_programme.py`](tests/test_programme.py). The Lean namespace is `HarmonicEssays`.

| # | Kind | Statement | Lean / test name |
|---|---|---|---|
| T1 | Theorem | The harmonic angle is positive: `0 < α n` for every `n`. | `HarmonicEssays.alpha_pos` |
| T2 | Theorem | The angle sequence is strictly antitone: `k < n → α n < α k`. | `HarmonicEssays.alpha_strictAnti` |
| T3 | Theorem | The partial harmonic identity `Σ_{n=0}^{N} α n = π (H_{N+2} − 1)`. | `HarmonicEssays.sum_alpha` |
| T4 | Theorem | The greedy accumulation is non-negative: `0 ≤ greedy θ N`. | `HarmonicEssays.greedy_nonneg` |
| T5 | Theorem | The greedy accumulation never overshoots: `0 ≤ θ → greedy θ N ≤ θ`. | `HarmonicEssays.greedy_le_target` |
| T6 | Theorem | At the target `θ = α n` every earlier index is skipped, so `greedy (α n) n = 0`. | `HarmonicEssays.greedy_alpha_self` |
| T7 | Theorem | Consequently index `n` is selected at `θ = α n`: `selected (α n) n = true`. | `HarmonicEssays.selected_own_angle` |
| C1 | Computation | The exact partial-sum identity holds for `N ≤ 60`, agreeing with `sympy.harmonic(N+2) − 1`. | `test_harmonic_sum_identity_exact` |
| C2 | Computation | The corrected residual bound `0 ≤ r N/π ≤ 1/(N+1)` holds on a rational grid for `N ≤ 300`; the source's `1/(N+2)` fails at `N = 1`, `x = 2/5`. | `test_residual_bound_correct_form` |
| C3 | Computation | At `θ = α n` (i.e. `x = 1/(n+2)`) no earlier index is selected and index `n` is, for `n ≤ 12`. | `test_own_angle_selected` |
| C4 | Computation | The fusion step preserves `s² + c² = 1` and equals `(sin(θ+a), cos(θ+a))` exactly; zero rotation is the identity. | `test_fusion_preserves_unit_circle` |
| C5 | Computation | Reconstruction of `sin(π x)` from the exact greedy word at 300 terms agrees to `π/301 + 10⁻¹²` on a five-point grid including `x = 0, 1`. | `test_reconstruction_convergence` |
| C6 | Computation | Erratum: at `θ = π` the word is `1,1,0,0,1,0,…` (only indices 0, 1, 4), so `Φ(2,π) = 7/18 ≠ ζ(2) − 1`. | `test_pi_target_sparse_erratum` |
| C7 | Computation | The accumulated angle satisfies `0 ≤ θ N ≤ θ` on a 41-point grid for `N ≤ 400`. | `test_accumulated_never_overshoots` |

## Source claims (not promoted to theorems)

These are recorded with the source's own status. None is a theorem of this reconstruction.

| Claim | Source status | Reconstruction note |
|---|---|---|
| `sin θ = lim_{N→∞} s_N` for `θ ∈ [0,π]`, with `sgn`/periodic extension to all `x`. | Source Theorem 2.3, with an induction and a continuity sketch | The finite fusion identity is tested (C4) and convergence on a grid (C5); the limit theorem and the periodic extension are not formalised. |
| `0 ≤ r N ≤ π/(N+2)` (Lemma 3.1). | Source lemma | **Refuted as stated.** The correct finite bound is `r N ≤ π/(N+1) = α_{N−1}`; counterexample `θ = 2π/5`, `N = 1`. See Erratum 1 and C2. |
| `\|sin θ − s_N\| ≤ π/(N+2)` (Lemma 3.2). | Source lemma | Follows from the corrected residual bound only with `π/(N+1)`; the sharper constant is not proved. |
| Selection count `Σ_{n=0}^{N} δ_n = x log(N+2) + O(1)` for `x ∈ (0,1)` (Lemma 3.3). | Source lemma, heuristic proof | **False for targets that are finite harmonic sub-sums**, e.g. `x = 5/6 = 1/2 + 1/3`, where the word terminates and the count is constant. Not formalised. |
| `Φ(s,π) = ζ(s) − 1`, i.e. `θ = π` selects every index (Proposition 4.4). | Source proposition, called “direct verification” | **Refuted as stated.** The word for `θ = π` is finite: `α_0 + α_1 + α_4 = π/2 + π/3 + π/6 = π`, after which the residual is 0. Hence `Φ(s,π) = 2^{−s} + 3^{−s} + 6^{−s}`, not `ζ(s) − 1`. See Erratum 2 and C6. |
| `Φ(s,θ)` converges absolutely for `Re s > 1` and conditionally for `Re s > 0`. | Source Lemma 4.2 | The `Re s > 1` part is immediate (`\|Φ\| ≤ ζ(Re s) − 1`); the conditional range and uniformity are not formalised. |
| Energy at a zero: `E(ρ,π) = \|ζ(ρ) − 1\|² = 1` (Lemma 5.2). | Source lemma | Depends on the false identification `Φ(ρ,π) = ζ(ρ) − 1`; as stated it is arithmetic on an invalid premise. Not used. |
| `E(σ,T) = E(1−σ,T) + O(T^{−1/2+ε})` (Proposition 5.4). | Source proposition, sketch via the approximate functional equation | `E` is not defined precisely in the source; not formalised. |
| Van der Corput bound for `Σ_{n≤x} e(α/n)` (Lemma 6.2). | Quoted analytic estimate | The source cites Graham–Kolesnik but gives only a sketch; not formalised. |
| Extended discorrelation for `1/n` phases, outside an exceptional set (Theorem 6.3). | Source “theorem”, proof sketch | A substantial analytic statement extending Matomäki–Radziwiłł; no complete proof in the source. Open, not formalised. |
| Coherence-defect bounds, `C(ρ) ≪ \|γ\|^ε` on the line and `C(ρ) ≫ \|β−1/2\|² (log\|γ\|)^{1/5}` off it (Proposition 7.3). | Source proposition | Both parts are asserted; part (b) is essentially the desired conclusion. Not formalised. |
| `H¹(S, H_ρ) = 0 ⇔ C(ρ) = O(\|γ\|^ε)` and the acyclicity criterion (Proposition 7.4). | Source proposition | The sheaf `H` and the cohomology group are not defined precisely; the equivalence is asserted, not proved. Not formalised. |
| Riemann hypothesis (Theorem 8.1). | **Archived claim, retracted in the source itself and superseded** | Not proved. RH remains open. Nothing in this folder should be cited as a proof. |

## Open / conjecture ledger

These are precise statements that remain unresolved. None is used as a theorem.

| # | Kind | Statement | Status / note |
|---|---|---|---|
| O1 | Open / conjecture | For every `θ ∈ [0,π]`, `sin θ = lim_{N→∞} s_N`, with `\|sin θ − s_N\| ≤ π/(N+1)`. | Expected true for this greedy rule; the finite layer is proved (T4–T7) and tested (C4, C5), but the residual limit and the Lipschitz step are not formalised. |
| O2 | Open / conjecture | For `x ∈ (0,1)` that is not a finite harmonic sub-sum, `Σ_{n≤N} δ_n = x log(N+2) + O(1)`. | The source's version (Lemma 3.3) is false at `x = 5/6`; a corrected statement with an explicit exceptional set is open. |
| O3 | Open / conjecture | The sub-sums `Φ(s,θ)` for `Re s > 1` carry arithmetic information about `ζ` beyond being sub-sums of `ζ(s) − 1`. | No precise statement exists in the source; `Φ(s,π) ≠ ζ(s) − 1` (Erratum 2), so the proposed bridge is not an identity. |
| O4 | Open / conjecture | The extended Matomäki–Radziwiłł discorrelation for `1/n` phases (source Theorem 6.3). | Substantial analytic statement; no complete proof in the source. |
| O5 | Open / conjecture | A sheaf of harmonic phases whose `H¹` vanishing is equivalent to `Re ρ = 1/2`. | The sheaf and cohomology group are not defined; the source's equivalence is asserted, not constructed. |

## Errata

1. **Residual bound off by one index.** Lemma 3.1 states `0 ≤ r N ≤ π/(N+2)`. At step 1, if `θ = 2π/5 < α_0 = π/2`, nothing is selected, so `r_1 = 2π/5 > π/3 = π/(1+2)`. The correct bound is `r N ≤ α_{N−1} = π/(N+1)`, which is what the greedy rule actually enforces; C2 tests the corrected bound and the counterexample. The subsequent `π/(N+2)` error constant in Lemma 3.2 inherits the same slip.
2. **`θ = π` does not select every index.** Proposition 4.4 argues that because `Σ α_n` diverges the residual always exceeds `α_n`. That inference is invalid: the greedy rule instead stops taking once the accumulated angle reaches `π`. Exactly `α_0 + α_1 + α_4 = π/2 + π/3 + π/6 = π`, so the word is `1,1,0,0,1,0,0,…` and `Φ(s,π)` is a three-term sum. The claimed zeta bridge `Φ(s,π) = ζ(s) − 1` therefore fails at the one angle where the source claims to verify it directly. C6 checks this exactly.
3. **Selection-density lemma ignores early termination.** For `x = 5/6 = 1/2 + 1/3` the greedy word is `1,1,0,0,…` and the selection count is 2 for every `N`, contradicting `x log(N+2) + O(1)`. The lemma is plausible only for targets that are not finite harmonic sub-sums.
4. **The RH argument is non sequitur even on its own terms.** Step 4 of Theorem 8.1 infers that `H¹` *must* vanish because `ζ` is meromorphic, while the preceding step asserts `H¹ ≠ 0`. Oka–Cartan vanishing is a theorem about Stein manifolds; it does not supply the missing implication from zeta's analytic continuation to the vanishing of a cohomology group attached to an undefined sheaf. The source retracts the conclusion; the inventory marks it superseded.
5. **Superseded material.** Inventory item 38 is tagged *archived claim / superseded*. This reconstruction cites the archived essay-level file as the designated source; it is not treated as independent evidence for any claim.

## Python layer

[`python/programme.py`](python/programme.py) uses `sympy` for exact rational and trigonometric work. Targets are exact rational multiples of `π`, so no greedy decision rounds. `mpmath` (50 digits) is used only for the high-precision reconstruction check in C5, whose tolerance is stated as `π/301 + 10⁻¹²`.

| Function | Purpose |
|---|---|
| `alpha(n)`, `alpha_scaled(n)` | `α n = π/(n+2)` and `1/(n+2)` |
| `harmonic_sum_scaled(N)`, `harmonic_sum(N)` | exact `H_{N+2} − 1` and `π(H_{N+2} − 1)` |
| `greedy_word(x, n_max)` | exact selection word `δ_0 … δ_{n_max}` |
| `greedy_accumulated(x, n_max)` | accumulated angle in `π` units |
| `residual(x, N)` | `r N/π` |
| `residual_bound(x, N)`, `source_residual_bound(x, N)` | corrected and source-stated bounds |
| `fusion_step(s, c, a)` | the sine/cosine rotation |
| `reconstruct_sine(x, n_max, dps)` | `sin(πx)` from the exact word |
| `subsum(x, s, n_max)` | truncated `Φ(s, θ)` |

Run from the repository root:

```bash
cd the-final-letter/topics/harmonic-sine-greedy-harmonic-essays
python3 -m pytest -q tests
```

Recorded result: **8 passed**. The suite covers every Computation row and includes the `α(−1)` / target-range edge cases and the two refutations.

## Lean layer

[`lean/Topic.lean`](lean/Topic.lean) imports Mathlib, opens the `HarmonicEssays` namespace, and defines `alpha`, the recursive `greedy`, and `selected`. It proves T1–T7. It contains no `sorry`, `axiom` or `admit`.

```bash
cd the-final-letter/topics/harmonic-sine-greedy-harmonic-essays
./lean/check.sh
```

Recorded build: [`lean/BUILD.log`](lean/BUILD.log) — `[check] OK Topic.lean`. See [`lean/README.md`](lean/README.md) for exactly what is and is not formalised.

## Open items and gaps

1. **The reconstruction limit.** T4–T7 prove the finite greedy layer. Proving `r N → 0` and `sin θ = lim s_N` needs the full residual induction and a continuity/Lipschitz argument; neither is in Lean yet.
2. **Correct residual and rate constants.** The source's constants are off by one index (Erratum 1). A formal proof should establish `r N ≤ α_{N−1}` and record the resulting `O(1/N)` rate rather than the source's `π/(N+2)`.
3. **Selection count.** Replace Lemma 3.3 by a correct statement. Finite harmonic sub-sums are an exceptional set where the count is bounded; the logarithmic law needs a precise hypothesis excluding them.
4. **A well-posed zeta bridge.** `Φ(s,θ)` is a genuine absolutely convergent sub-sum of `ζ(s) − 1` for `Re s > 1`, but the special value at `θ = π` is not `ζ(s) − 1`. Whether the parametrised sub-sums carry any arithmetic information is open, and nothing in the source establishes a route to zeros.
5. **Analytic inputs.** The extended Matomäki–Radziwiłł discorrelation (Theorem 6.3) and the coherence-defect bounds (Proposition 7.3) are unproved analytic statements, not consequences of the finite harmonic construction.
6. **Sheaf and acyclicity.** Proposition 7.4 has no precise definitions to formalise; it should be treated as speculation unless a sheaf of harmonic phases is actually constructed.
7. **Retraction audit.** The source points to a “Version 2” that is not linked. Locating and auditing it, and reconciling items 15, 17 and 38, is a provenance task rather than a mathematical one.
8. **The RH claim.** It is retracted, archived and superseded. The Riemann hypothesis is not proved here or in the source.

## Provenance

- [`scraps.html`](../../scraps.html) — inventory entry 38.
- [`topics/README.md`](../README.md) — all topic folders.
- [`harmonic-sine`](../harmonic-sine/README.md) — the related earlier reconstruction (inventory item 15).
- [`harmonic-sine-transform`](../harmonic-sine-transform/README.md) — HST material (inventory item 17).
- [`summary/14-legacy-conjectures/`](../../summary/14-legacy-conjectures/README.md) — the deduplicated conjecture index.

[Back to the topic index](../README.md) · [Scraps](../../scraps.html) · [The Final Letter](../../index.html)
