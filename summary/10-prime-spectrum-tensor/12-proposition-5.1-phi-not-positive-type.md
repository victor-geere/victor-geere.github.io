# Proposition 5.1

| Field | Value |
|---|---|
| Type | Proposition |
| Status | Proved |
| Source | [`tensor.md`](tensor.md), §2–7 |

## Statement and proof

\(\Phi\) is positive, even, integrable — and not of positive type. Indeed \(\hat\Phi(t)=\tfrac12\Xi_{\cos}(t)\) (Lemma 2.2) changes sign at every simple on-line zero; numerically
\(\hat\Phi(15)=-3.5284897941\times10^{-4}<0\), and \(\hat\Phi<0\) throughout \((\gamma_1,\gamma_2)\). By Bochner's theorem the kernel \(\Phi(u-v)\) is not positive-semidefinite; explicitly, with \(u_j=j/20\), \(\lvert j\rvert\le600\), \(a_j=e^{15iu_j}\),
\[
\sum_{j,k}a_j\bar a_k\,\Phi(u_j-u_k)=-5.9384\ldots<0
\qquad(\text{the same form at frequency }0\text{ is }+5953.27).
\]

So the finite-tuple version of \((\star)\) fails at exactly the tuples where tensor.html declares the pairing defined, and it fails for a reason one step shallower than Theorem B: it does not even need the primes. This also settles the sentence in tensor.html §5 — "positivity of \(\Phi\) solves that slice" — in the intended direction only for the constant mode. Positivity of a function and positivity of its type are transverse properties (truths.md 12.4 already knew this for the zero-location question; the same distinction kills the kernel form of \((\star)\)).

Note the irony made precise by Lemma 2.2: \(\Theta\) *is* \(\xi\). Pairing against the Jacobi density is pairing against \(\Xi_{\cos}\) on the spectral side, so tensor.html's "no entire function is named" is not achieved by \(\mathcal{P}\) — the named function \(\xi\) rides inside \(\Theta\) as its transform.

---
