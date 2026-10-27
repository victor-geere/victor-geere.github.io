# Status of the claims in tensor.html and truths.md

> Source: [`tensor.md`](../../geometric-dynamical-phase-transitions/tensor.md) §8. This is the authoritative correction ledger.

## 8. Status of the claims in tensor.html and truths.md

- tensor.html §4, \((\star)\ge0\): **false** (Theorem B; witness \(f_0\), value \(-0.6773\)).
- §4, "equivalently \(K(u,v)=\mathcal{P}(u-v)\) is positive semi-definite": **false**; the tuple form fails already for the density part (\(\Phi\) not of positive type, Proposition 5.1).
- §4, "If \((\star)\) holds, Bochner's theorem ... supplies a unique even tempered positive measure": antecedent false; also \(\mathcal{P}\) is not tempered and its resolution has mass off \(\mathbb{R}\) (Remark 3.2). The true resolution is Theorem A.
- §4, Definition 4.1 ("the prime spectrum is the Bochner measure of \(\mathcal{P}\)"): empty as defined. The object that exists is the spectrum of \(\mathcal{W}\), which is \(\sum_\rho\delta_{\gamma_\rho}\) unconditionally, positive iff RH (Corollary 7.2).
- §4/abstract, "\((\star)\) replaces the Riemann hypothesis": **no**. \((\star)\) is false while RH is open, so they are not equivalent. The statement on \(\mathbb{R}\) that is equivalent to RH is Weil positivity, \(\langle\mathcal{W},f*\check f\rangle\ge0\) (Theorem C).
- §5, "the \(\gamma=0\) slice ... positivity of \(\Phi\) solves that slice": on low-frequency test functions the positivity of \(\langle\mathcal{P},f*\check f\rangle\) is carried by the pole term \(\lvert\hat f(i/2)\rvert^2\), not by \(\Phi\) (the density \(W\) is negative near \(0\): \(W(0)=-2.4375\)). The \(K(\alpha,0)>0\) slice itself is fine (truths.md 15.1) but is about \(\operatorname{Re}\xi\) on the real axis, not about positive type.
- §6, "Passing from \(c_m^{(N)}\) to \(\Lambda\) ... is \((\star)\)": the completed statement is Weil positivity, and the sign of the prime side flips on the way (Remark 7.3).
- §8, "If \((\star)\) fails ... the Laplace picture will show poles off the line": non sequitur; \((\star)\) fails unconditionally with no off-line consequence (Remark 4.2).
- §8, further research ("\(K(\alpha,\gamma)\) cannot vanish for \(\alpha\neq0\)"): the target statement is **false for every \(\alpha\)** (Proposition 6.3); the surviving open statement is the joint non-vanishing of \((K,S)\), i.e. RH (Corollary 6.2).
- truths.md 12.3, "a zero ... is exactly the vanishing of this moment": "exactly" should be "in particular"; the zero condition is \(K=S=0\) jointly (Corollary 6.2).
- truths.md 15.3, the sign law: unsatisfiable for every \(\alpha\) (Proposition 6.3). 15.1, 15.2, 15.4–15.10 are untouched.
- truths.md 12.1: the unspecified constant is \(c=4\) for the \(\Phi\) as printed, i.e. \(\hat\Phi=\tfrac12\Xi_{\cos}\) (Lemma 2.2).

What this file does **not** do: prove or disprove the Riemann hypothesis, or diminish the reformulation programme. It relocates the programme onto the current for which the reformulation is true — \(\mathcal{W}\), where it is Weil's — and closes \((\star)\), the \(K\)-sign law, and the kernel form as dead ends, with proofs.

---
