# Proposition 6.3 (the sign law of 15.3 is false for every \(\alpha\))

| Field | Value |
|---|---|
| Type | Proposition |
| Status | Proved (corrects truths 15.3) |
| Source | [`tensor.md`](tensor.md), §2–7 |

## Statement and proof

Fix any \(\alpha\neq0\) (by evenness in \(\alpha\), take \(\alpha>0\)).

1. *Near every simple on-line zero.* If \(\Xi_{\cos}(\gamma_0)=0\), \(\Xi_{\cos}'(\gamma_0)\neq0\), then \(\xi(\tfrac12+\alpha+i\gamma)=-i\,\Xi_{\cos}'(\gamma_0)\bigl(\alpha+i(\gamma-\gamma_0)\bigr)+O(\alpha^2+(\gamma-\gamma_0)^2)\), so
\(K(\alpha,\gamma)=\tfrac14\Xi_{\cos}'(\gamma_0)(\gamma-\gamma_0)+O(\cdot)\): the cosine moment changes sign essentially **at** \(\gamma_0\), for every tilt \(\alpha\), while \(S(\alpha,\gamma_0)\approx-\tfrac14\Xi_{\cos}'(\gamma_0)\,\alpha\neq0\) keeps the joint system away from zero. Numerically: \(K(0.1,14.1)=+1.0\times10^{-5}\) against \(K(0.1,14.2)=-2.4\times10^{-5}\), and \(K(0.25,14.0)=+3.7\times10^{-5}\) against \(K(0.25,14.1)=-5.6\times10^{-7}\): a sign change of \(K(\alpha,\cdot)\) inside \((14.1,14.2)\) and \((14.0,14.1)\) respectively, at both tilts.
2. *Globally.* On the vertical line \(\operatorname{Re}s=\tfrac12+\alpha\), \(\arg\xi(s)=\tfrac t2\log\tfrac{t}{2\pi e}+O(\log t)\) (Stirling for \(\arg\Gamma(s/2)\), \(\arg\zeta(\sigma+it)\ll\log t\) uniformly for \(\sigma\ge\tfrac12\), Titchmarsh §9.4). The phase increases without bound, so \(\operatorname{Re}\xi\), hence \(K(\alpha,\cdot)\), has \(\gg T\log T\) sign changes in \([T,2T]\) — the same density as the zeros of \(\Xi_{\cos}\) itself.

Consequently the assertion of truths.md 15.3 — "killing off-line zeros at that \(\alpha\) is the assertion that \(K(\alpha,\cdot)\) does not change sign" — is unsatisfiable: \(K(\alpha,\cdot)\) changes sign for every \(\alpha\), off-line zeros or not. Likewise the further-research sentence quoted in tensor.html §8 ("a proof that \(\int\Phi(u)\cosh(\alpha u)\cos(\gamma u)\,du\) cannot vanish for \(\alpha\neq0\)") targets a false statement — the note was right to refuse to assert it, for a stronger reason than it gave. What remains open is exactly Corollary 6.2's joint statement: for \(\alpha\neq0\) the real curve \(K(\alpha,\cdot)=0\) and the curve \(S(\alpha,\cdot)=0\) never meet. That is the Riemann hypothesis, undisguised: \(K\) and \(S\) are \(\operatorname{Re}\xi\) and \(\operatorname{Im}\xi\).

(The solved slice 15.1 reads correctly in this notation: at \(\gamma=0\), \(S(\alpha,0)\equiv0\) identically, and \(K(\alpha,0)=\tfrac14\xi(\tfrac12+\alpha)>0\) — positivity of \(\Phi\) wins precisely where the sine partner is trivially dead.)

---
