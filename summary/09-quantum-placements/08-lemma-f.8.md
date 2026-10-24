# Lemma F.8 (Clock zeros)

| Field | Value |
|---|---|
| Type | Lemma |
| Status | Proved |
| Source | [publication.html Addendum F](publication.html#addf) · Addendum F. Quantum answers: where the physics literature sits against each gap |
| Proof in source | yes |

## Statement

Let \(N\ge2\), and for \(k\in\mathbb{Z}\setminus\{0\}\) write \(s_k=1+2\pi ik/\log N\) for the zeros of the elementary factor \(1-N^{1-s}\) (Lemma 2.2), with \(t_k=2\pi k/\log N\). There are absolute constants \(A\) and \(c_0\) such that, whenever \[
r_k=\frac{A\,(1+\lvert t_k\rvert)\log(2+\lvert t_k\rvert)}{N\log N}\le\frac{c_0}{\log(2+\lvert t_k\rvert)},
\] the disk \(\lvert s-s_k\rvert\le r_k\) contains exactly one zero of \(\eta_N^{(N^2)}\), and it is simple. On the window \(\lvert t\rvert\le N^{1/2-\varepsilon}\) the hypothesis holds for all large \(N\) and \(r_k\to0\); in particular these zeros lie outside \(S_{\delta/2}\) for large \(N\) and are never the anchors of Definition 5.4. Their number up to height \(T\) is \(\lfloor T\log N/2\pi\rfloor\).

## Proof

The Euler–Maclaurin formula of Section 4 holds for every \(\sigma\ge\sigma_0>0\), so Theorem 4.3 extends to \(\tfrac12\le\sigma\le\tfrac32\) with remainder \(O((1+\lvert t\rvert)N^{1-2\sigma})=O((1+\lvert t\rvert)/N)\) there. On the circle \(\lvert s-s_k\rvert=r_k\), with \(w=(s-s_k)\log N\) and \(\lvert w\rvert\le1\), \(\lvert1-N^{1-s}\rvert=\lvert1-e^{-w}\rvert\ge\lvert w\rvert/2=r_k\log N/2\). The circle lies in \(\sigma\ge1-c_0/\log(2+\lvert t\rvert)\), where \(\lvert\zeta(s)\rvert\ge c/\log(2+\lvert t\rvert)\) by the classical zero-free region (Titchmarsh \[1, §3.11\]; this is an Euler-product input, used here only to locate the clock zeros and nowhere in Sections 5–12). So the main term has modulus at least \(c\,r_k\log N/(2\log(2+\lvert t_k\rvert))=cA(1+\lvert t_k\rvert)/(2N)\), which exceeds the remainder \(C(1+\lvert t_k\rvert)/N\) once \(A\ge4C/c\). Rouché equates the zero counts of \(\eta\) and of \((1-N^{1-s})\zeta(s)\) in the disk; the latter has exactly the simple zero \(s_k\), \(\zeta\) being zero-free there. On the window, \(r_k\ll N^{-1/2-\varepsilon}\log N\to0\) and the hypothesis \(r_k\log(2+\lvert t_k\rvert)\le c_0\) holds for large \(N\). Part 3 of `quantum_fisher_zeros_test.py`: at \(N=10\) the nearest zero to \(s_k\) lies at distance \(0.027,\,0.021,\,0.015,\ldots\) for \(k=1,2,3\) and at most \(0.053\) over all \(21\) clock points up to height \(60\); at \(N=20\) at most \(0.017\) over \(28\); at \(N=5\) up to \(0.24\), with four of the fifteen clock zeros displaced to \(\sigma<1\). The displacement decreases with \(N\) and, at fixed \(N\), the zeros sit to the right of \(\operatorname{Re}s=1\) once it is small.
