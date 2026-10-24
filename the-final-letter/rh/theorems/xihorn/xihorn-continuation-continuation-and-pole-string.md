# The continuation — Γ_Φ(w) = 4∫₀^∞ u^w·Φ(u)du, meromorphic with simple poles on the odd negative integers

**Kind:** Proposition
**Status:** PROVED (paper argument)
**Area:** xi-horn
**Source:** [`xi-horn/CONTINUATION.md`](../../xi-horn/CONTINUATION.md) — §1 "The continuation", equations (21)–(22)

## Statement

> The moments are already a Mellin transform. Set
>
> ```
> Γ_Φ(w) = 4 ∫₀^∞ u^w · Φ(u) du                                              (21)
> ```
>
> so that **γ(n) = Γ_Φ(2n)**. The integral converges for Re w > −1 and is holomorphic there. Split at any **U₀ with 0 < U₀ < π/4** and use Φ's Taylor series at the origin — which has only even powers, Φ(u) = Σ_k c_{2k}u^{2k}, because Φ is even —
>
> ```
> Γ_Φ(w) = 4·Σ_{k≥0} c_{2k}·U₀^{w+2k+1}/(w + 2k + 1)
>        + 4∫_{U₀}^∞ u^w Φ(u) du                                            (22)
> ```
>
> The second term is entire (Φ decays double-exponentially). So **Γ_Φ is meromorphic on ℂ with simple poles at w = −1, −3, −5, … only** — the even negative integers are regular — with residue 4c_{2k} at w = −(2k+1), which is independent of U₀ as it must be. In particular the residue at w = −1 is 4Φ(0) = 1.7867876.

The source adds, in a boxed aside, that the bound is not optional:

> **The bound U₀ < π/4 is not decoration, and this identity was first written without it — splitting at u = 1.** Φ(u) = 2e^{u/2}ω(e^{2u}) with ω built from θ, and θ has Re t = 0 as a natural boundary, so Φ is analytic exactly on |Im u| < π/4 and the Taylor series at the origin has radius **π/4 = 0.785**. At u = iπ/4 the defining sum's own terms are (2π²k⁴e^{9iπ/8} − 3πk²e^{5iπ/8})(−1)^k and do not decay at all. Integrating the series over [0, 1] is therefore not available, and Σ_k c_{2k}/(w+2k+1) diverges. Everything above survives the repair — same poles, same residues, and (23) still entire — but the split point has to be inside the disc. Measured in `rust/`: |c_m|^{1/m} runs 1.25–1.45 over 30 ≤ m ≤ 158, settling toward 4/π = 1.27324 from above, with the coefficients enclosed to 1e−118 relative. See TODO **E14** and `rust/src/series.rs`; the first four are c₀ = 0.44669690046712344, c₂ = −4.18262519367581422, c₄ = 16.92005903032133932, c₆ = −35.23314299039473380.

## Hypotheses and notation

- Φ is the horn's weight, Φ(u) = Σ_{n≥1} (2π²n⁴·e^{9u/2} − 3πn²·e^{5u/2})·e^{−πn²·e^{2u}} (README (1)); it is even, positive on ℝ and double-exponentially small.
- Γ_Φ is the Mellin transform of Φ; γ(n) = 4∫₀^∞ u^{2n}·Φ(u)du are the even moments of the horn's profile (POSITIVITY.md (7)).
- U₀ is the split point, constrained to 0 < U₀ < π/4; c_{2k} are the Taylor coefficients of the even function Φ at the origin.
- Φ is analytic exactly on |Im u| < π/4, so the Taylor series at the origin has radius π/4 = 0.785.
- ℂ, Re w, w = −(2k+1) for k ≥ 0.

## Proof / evidence

The source gives the argument in the statement: split the defining integral at U₀, expand Φ's even Taylor series on the finite piece to obtain the pole terms 4·c_{2k}·U₀^{w+2k+1}/(w+2k+1), and observe that the remaining integral over [U₀, ∞) is entire because Φ decays double-exponentially. The U₀ < π/4 restriction is defended by measurement in `rust/`: |c_m|^{1/m} runs 1.25–1.45 over 30 ≤ m ≤ 158, settling toward 4/π = 1.27324 from above, with the coefficients enclosed to 1e−118 relative (TODO E14, `rust/src/series.rs`). The first four Taylor coefficients are quoted. The source records that an earlier version split at u = 1, which is invalid because θ has Re t = 0 as a natural boundary, and that everything survives the repair with the same poles and residues.

## Dependencies and related results

- Φ and its three properties: [README.md](../../xi-horn/README.md) §1 (1).
- γ(n) = 4∫₀^∞ u^{2n}·Φ(u)du and the moment expansion ξ(½+z) = Σ γ(n)z^{2n}/(2n)!: [POSITIVITY.md](../../xi-horn/POSITIVITY.md) (7).
- The entire repackaging that cancels the pole string: [xihorn-continuation-entire-repackaging.md](xihorn-continuation-entire-repackaging.md).
- Companion notes in the same directory: [INTEGERS.md](../../xi-horn/INTEGERS.md) §3 on evaluating Φ only at |u|.

## Notes

- The residue 4Φ(0) = 1.7867876 is quoted exactly as the source gives it.
- The source presents the U₀ < π/4 repair as a correction of its own first draft; the repair does not change the poles, the residues, or the entire property of (23).
- Equation (21) also serves as a definition of Γ_Φ; only the convergence/holomorphy statement, the identity γ(n) = Γ_Φ(2n) and the pole structure are harvested here as results.
