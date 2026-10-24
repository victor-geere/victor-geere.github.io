# Lemma C.2 (Every mean-zero periodic polygon is a level-\(q\) Euler-sum combination)

| Field | Value |
|---|---|
| Type | Lemma |
| Status | Proved |
| Source | [publication.html Addendum C](../../geometric-dynamical-phase-transitions/publication.html#addc) · Addendum C. The Davenport–Heilbronn twist: sharpness of the conversion |
| Proof in source | yes |

## Statement

Let \(a\) be \(q\)-periodic. Then \(\sum_{r=1}^q a_r=0\) if and only if \(\widehat{a}_0=0\), and in that case \[
H_x^{(s)}[a]=\sum_{j=1}^{q-1}\widehat{a}_j\,H_x^{(s)}[\zeta_q^{\,j}],\qquad \zeta_q=e^{2\pi i/q}.
\] For the filter of Lemma 2.2 one has \(\widehat{c^{(N)}}_j=-1\) for every \(j\not\equiv 0\), so \[
\eta_N^{(M)}(s)=-\sum_{j=1}^{N-1}H_M^{(s)}\bigl[\zeta_N^{\,j}\bigr].
\]

## Proof

Finite Fourier inversion \(a_n=\sum_{j=0}^{q-1}\widehat{a}_j e(jn/q)\) applied termwise; \(\widehat{a}_0\) is the mean. For \(c^{(N)}\), \(\widehat{c}_j=N^{-1}\bigl(\sum_{r=1}^{N}e(-jr/N)-N\bigr)=-1\) when \(j\not\equiv0\). The displayed identity is then Lemma 3.2 read backwards, and is the precise form of the remark in the proof of Lemma 2.2 that \(c^{(N)}\) is the geometric sum over the non-trivial \(N\)-th roots of unity.
