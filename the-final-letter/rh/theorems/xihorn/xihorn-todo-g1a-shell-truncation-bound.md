# (G1a) — the shell-truncation bound

**Kind:** Lemma
**Status:** PROVED (paper argument; derivation in `rust/src/jet.rs` and `rust/src/bounds.rs`, used to certify 35/35 P^{d,n})
**Area:** xi-horn
**Source:** [`xi-horn/TODO.md`](../../xi-horn/TODO.md) — §G1 "Turn B1 into a theorem: bound γ(n) instead of measuring it", bound (a)

## Statement

> **(a) the shell truncation.** For u ≥ 0 the head of φ_k lies in
> [0, 2π²k⁴e^{9u/2}], each u-derivative costs at most a factor 5πk²e^{2u}, and
> consecutive majorants fall by 2⁸e^{−3π} = 0.021 — so the geometric sum is
> under 2 and, for every N ≥ 0 and j ≤ 2,
>
> ```text
> Σ_{k>N} |φ_k^(j)(u)|  ≤  (5π(N+1)²e^{2u})^j · T_N(u),
> T_N(u) := 4π²·e^{9u/2}·(N+1)⁴·e^{−π(N+1)²e^{2u}}                      (G1a)
> ```
>
> The loop stops on T_N rather than on the terms.

## Hypotheses and notation

- u ≥ 0; N ≥ 0 an integer truncation index; j ≤ 2 the order of the u-derivative.
- φ_k is the k-th shell of the horn's weight Φ, whose head lies in [0, 2π²k⁴e^{9u/2}].
- T_N(u) is the majorant in the display; "consecutive majorants fall by 2⁸e^{−3π} = 0.021".
- G1's four bounds replace four estimates so that the coefficients arrive as intervals **proved** to contain a(n); the derivation is in `rust/src/jet.rs` and `rust/src/bounds.rs`.

## Proof / evidence

The source gives the argument in prose: each u-derivative costs at most a factor 5πk²e^{2u}, consecutive majorants fall by 2⁸e^{−3π} = 0.021, so the geometric sum is under 2, giving the displayed bound for every N ≥ 0 and j ≤ 2. It records the practical use — the loop stops on T_N rather than on the terms — and that the certified run at V₀ = −14, h = 2⁻¹⁴, V₁ ≈ 1.4, 252,317 nodes, 63,079 jet blocks, 60 digits, four minutes certifies **35 of 35** P^{d,n} for d = 2…6, n = 0…30 and **15 of 35** J^{d,n}.

## Dependencies and related results

- [(G1b) — the trapezoid remainder bound](xihorn-todo-g1b-trapezoid-remainder-bound.md) — the term that binds at every n.
- [(G1c) — the piece below V₀](xihorn-todo-g1c-piece-below-v0.md) and [(G1d) — the piece above V₁](xihorn-todo-g1d-piece-above-v1.md) — the other two bounds.
- [G1 — B1 without its conditional](xihorn-rust-results-g1-b1-without-conditional.md) — the certificate these four bounds support.

## Notes

- The source's own remark: "(G1a) at N = 0 majorises Φ" — that instantiation is what bound (G1d) uses.
- **E13** corrected an earlier recipe for the below-V₀ piece ((G1c)); the source says the corrected route "needs neither" Φ′ nor Φ″.
