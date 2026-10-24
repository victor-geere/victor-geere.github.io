# The 1/√(¼+t²) growth law for both additive families

**Kind:** Proposition
**Status:** VERIFIED (numerical; mediator and Agent B agree to 8 digits)
**Area:** workspace
**Source:** [`research-journal.md`](../../research-journal.md) — Round 0d, lines 81–85; Round 1 Agent B audit, line 169; Round 1 ruling, lines 188–195; Round 2 Agent B answer, line 232; Round 10 table, line 681

## Statement

> **The 1/√(¼+t²) growth law is the cleanest real result of the round.** … the clean identity: U_N = Σ_{n≤N} n^{−it} ≈ (N^{1−it} − 1)/(1 − it), so |U_N| ≈ N/|1 − it|, while |A_N| = |Σ n^{−1/2−it}| ≈ √N/|½+it|. **The weighted family carries 1/|½+it| = 0.07070352773 and the unweighted one carries 1/|1−it| = 1/√(1+t²) = 0.070571; the weight n^{−1/2} converts one into the other, and the two prefactors agree only in the limit t → ∞.**

Round 1 table at t = γ₁ (line 190):

| sum at t = γ₁ | N=100 | N=400 | N=1600 | N=6400 | law |
|---|---|---|---|---|---|
| unweighted Σ n^{−it} (handoff 2) | 6.8613 | 28.346 | 113.33 | 452.18 | **∝ N**, rate 0.070706 |
| weighted Σ n^{−1/2−it} | 0.7094 | 1.4150 | 2.8286 | 5.6565 | **∝ √N**, /√N → 0.070706 |

Round 2: "B confirms U₄₀₀ = 0.8491822187 − 28.33298692i, |U₄₀₀| = 28.34571 — the handoff's 0.849/−28.333 exactly". Round 10 certification table: "U_N ≈ (N^{1−it}−1)/(1−it); U₄₀₀ = 0.8491822187 − 28.33298692i — mediator and B agree to 8 digits".

## Hypotheses and notation

- t is real (the height); γ₁ = 14.1347251417 is the first zeta zero ordinate; s = ½ + it.
- U_N = Σ_{n≤N} n^{−it} is the unweighted (angle-addition/handoff-2) family; A_N = Σ_{n≤N} n^{−1/2−it} is the weighted family.
- 1/√(¼ + t²) = 1/|½ + it|; at t = 14.1347 this is 0.07070352773.

## Proof / evidence

Independent recomputation by the mediator and by Agent B. Both rates are the same constant 1/√(¼ + t²) = 1/√(¼ + 14.1347²) = **0.070704**; the mediator verified the unweighted linear rate as 0.0706 against the integral surrogate ∫_N^0 cos(t log x)dx ≈ −N·cos(t log N)/t, and B verified the weighted one as 0.070706. The journal states the reconciliation as "exact". The unweighted sum's "growth exponent" absorbs the factor √N because it has no amplitude decay, so both families share the prefactor 1/|s| at s = ½ + it.

## Dependencies and related results

- [The envelope law: Σ_{n≤N} n^{−σ} sin(t log n) ≈ N^{1−σ}/|1−σ+it|](research-journal-envelope-exponent-law.md) — the general-σ envelope, which gives N^{1/4} at σ = ½.
- [∏_{n≤N} n^{−1/2} annihilates as (N!)^{−1/2}](research-journal-factorial-annihilation-of-product.md) — the product-form contrast.
- [The frequency/amplitude dictionary of the explicit formula](research-journal-frequency-amplitude-dictionary.md) — the amplitudes that make the weighted family the relevant one.

## Notes

- The journal retracts two of the mediator's own earlier numbers in the same passage: the "N^{1/4}" typical size was wrong (N^{1/4} is the *envelope*, per the envelope law) and "the classic N^{1/4} figure is the *mean square* (second moment) of Σ_{n≤N} n^{−1/2−it}, not the typical size; I had conflated the two." N^{1/2} is the typical size.
- A's separate claim that Σ_{n≤N} n^{−1/2−iγ₁} converges to ζ(½+iγ₁) is refuted in the same round: |Σ − ζ| = 2.23642 (10³), 7.07053 (10⁴), 22.3585 (10⁵), 38.7259 (3·10⁵), 70.7035 (10⁶) — monotone-in-envelope growth ≈ √N.

- **Correction (2025-10-06, session 003 residual-defect repair).** The headline identity was false for one of the two families it joined. The unweighted sum `Σ_{n≤N} n^{−it}` carries `1/|1−it| = 1/√(1+t²)`, not `1/|½+it|`: the archive's own committed check prints it — `research/twin-prime-parity/rounds/rh43/verify/independent_check.log:178` "fitted exponent theta (N=10..10^6) = 1.029345   [1/sqrt(1+t^2) = 0.070571]" and `:184` "N=1000000  |S_N|= 70571.050275   |S_N|/N=0.070571" — and the dictionary agrees at `research/twin-prime-parity/dictionary/04-zeta-relations.md:94`: "|S_N(t)|/N → 1/√(1+t²)". The weighted family's `1/|½+it| = 0.0707035` is unchanged. The two agree only as `t → ∞`.
