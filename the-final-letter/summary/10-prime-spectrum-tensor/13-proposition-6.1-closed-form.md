# Proposition 6.1 (closed form)

| Field | Value |
|---|---|
| Type | Proposition |
| Status | Proved |
| Source | [`tensor.md`](../../geometric-dynamical-phase-transitions/tensor.md), §2–7 |

## Statement and proof

For all real \(\alpha,\gamma\):
\[
K(\alpha,\gamma)=\tfrac14\operatorname{Re}\,\xi\bigl(\tfrac12+\alpha+i\gamma\bigr),
\qquad
S(\alpha,\gamma)=\tfrac14\operatorname{Im}\,\xi\bigl(\tfrac12+\alpha+i\gamma\bigr).
\]
*Proof.* With \(\hat\Phi(z)=\int\Phi(u)e^{-izu}du\) and \(z=-\gamma+i\alpha\),
\[
\int_{\mathbb{R}}\Phi(u)\,e^{(\alpha+i\gamma)u}\,du=\hat\Phi(-\gamma+i\alpha)=\hat\Phi(\gamma-i\alpha)=\tfrac12\,\Xi_{\cos}(\gamma-i\alpha)=\tfrac12\,\xi\bigl(\tfrac12+\alpha+i\gamma\bigr),
\]
by evenness of \(\hat\Phi\) and Lemma 2.2 (the continuation is legitimate: \(\Phi\) decays doubly exponentially, so \(\hat\Phi\) is entire). Expanding \(e^{(\alpha+i\gamma)u}=\bigl[\cosh(\alpha u)+\sinh(\alpha u)\bigr]\bigl[\cos(\gamma u)+i\sin(\gamma u)\bigr]\), the two cross terms are odd in \(u\) and integrate to zero against the even \(\Phi\); what survives is \(2K(\alpha,\gamma)+2i\,S(\alpha,\gamma)\). Verified to \(10^{-27}\) at \((\alpha,\gamma)=(0.1,14)\) and \((0.25,2)\) (Appendix). \(\square\)
