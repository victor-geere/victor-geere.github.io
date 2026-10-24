# The local-factor dichotomy: Euler factors perturb the identity, greedy factors perturb zero

**Kind:** Proposition
**Status:** PROVED (paper argument; verified numerically)
**Area:** workspace
**Source:** [`research-journal.md`](../../research-journal.md) — Round 4(c), line 363; Synthesis §5, line 420; Round 5 B correction, line 467; "The ten things that stand" §8, line 621

## Statement

> **(c) Where the local factor lives, and why the greedy alphabet has none.**
>
> | p | \|1 − p^{−s}\| at s = ½+iγ₁ |
> |---|---|
> | 2 | 1.6784342 |
> | 5 | 1.3600215 |
> | 100 | 1.0664581 |
> | 10⁴ | 1.0019413 |
> | 10⁶ | 0.99912239 |
>
> Every Euler local factor is a perturbation of the **identity**. The greedy alphabet's natural local factor, 1 − 1/(n+2), telescopes: ∏_{n≤N}(1 − 1/(n+2)) = 2/(N+2) → 0, measured 0.000999 at N = 1000. **Each greedy factor is a perturbation of zero.** There is no product of greedy local factors that stays non-zero — so there is nothing in the construction to take a logarithm *of*. This is the obstruction as a computation.

The correction and the final form:

> **B's two exact corrections — both verified, both accepted.** 1. The greedy local factor telescopes to **1/(N+2)**, not 2/(N+2): ∏_{n=0}^{N}(1 − 1/(n+2)) = 1·2·…·(N+1) / 2·3·…·(N+2) = 1/(N+2), exactly 0.000998003992 at N = 1000 against my measured 0.000999. My closed form was off by an index. Conclusion unchanged: it tends to 0, so the greedy alphabet still has no non-vanishing local factor.

and with the σ = ½ boundary:

> At σ = ½ the Euler product itself is at its boundary: Σ_p|1 − L_p^{−1}| diverges like √P/log P (11.7923, 28.2725, 69.1821) with catastrophic partial-product cancellation (errors 0.0611, 0.0228, 0.0131 then 0.32 at P = 3·10⁵), confirmed at 60 dps.

## Hypotheses and notation

- Euler local factor L_p = (1 − p^{−s})^{−1}; the quantity tabulated is |1 − p^{−s}| at s = ½ + iγ₁, γ₁ = 14.1347251417.
- Greedy local factor 1 − 1/(n+2); its product telescopes to 1/(N+2) (B's exact form; the mediator first wrote 2/(N+2)).
- Σ_p|1 − L_p^{−1}| = Σ_p|1 − (1 − p^{−s})| = Σ_p p^{−σ}, the divergence diagnostic at σ = ½.

## Proof / evidence

Numerical |1 − p^{−s}| values: 1.6784342 (p=2), 1.3600215 (5), 1.0664581 (100), 1.0019413 (10⁴), 0.99912239 (10⁶). Exact telescoping: ∏_{n=0}^{N}(1 − 1/(n+2)) = 1/(N+2), exactly 0.000998003992 at N = 1000 (against the measured 0.000999). The σ = ½ boundary: |∏_{p≤P}(1−p^{−s})^{−1} − ζ(½+iγ₁)| = 0.1152 (P=10³), 0.0611 (10⁴), 0.0228 (10⁵), then 0.3204 at P = 3·10⁵ and 0.4174 at 10⁶, reproduced at 60 dps, so "not a precision artefact but genuine severe cancellation as the partial product crosses the zero"; Σ_{p≤P}|1 − (1−p^{−s})^{−1}| measured 11.7923, 28.2725, 69.1821 at P = 10³, 10⁴, 10⁵ against 2√P/log P = 9.156, 21.715, 54.934.

## Dependencies and related results

- [The product theorem: ∏(1 + a_n) converges to a finite non-zero limit iff Σ a_n converges](research-journal-product-convergence-theorem.md) — the criterion that makes this dichotomy decisive.
- [Differentiation converts the frequency k log p into the amplitude log p](research-journal-derivative-mechanism.md) — what one would do with the surviving product.
- [M = γ + Σ_p[log(1 − 1/p) + 1/p]](research-journal-mertens-euler-constant-relation.md) — the prime-indexed local-factor correction.

## Notes

- The journal's one-sentence obstruction: "**The greedy digits have no local factor at all** — there is no p-local object in the construction. That is the obstruction in one sentence, and it is sharper than 'the alphabet is wrong'."
- The source records its own off-by-one and B's correction, and states that the conclusion is unchanged.
- The Round 5 numerical update adds |∏ − ζ| = 0.0611, 0.0228, 0.0131 at x = 10³, 10⁴, 10⁵ while |ζ(½+iγ₁)| = 2.75e−11, "a ratio of ~10⁹".
