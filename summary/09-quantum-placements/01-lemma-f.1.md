# Lemma F.1 (The averaged accumulated phase factor is the period-two polygon)

| Field | Value |
|---|---|
| Type | Lemma |
| Status | Proved |
| Source | [publication.html Addendum F](publication.html#addf) · Addendum F. Quantum answers: where the physics literature sits against each gap |
| Proof in source | yes |

## Statement

For every \(M\ge1\) and every \(s=\beta+it\), \[
Z(\beta)\,\mathcal{L}(\beta,t)=-\,\eta_2^{(M)}(s)=-\bigl(H_M^{(s)}-2^{1-s}H_{\lfloor M/2\rfloor}^{(s)}\bigr),
\] and the thermodynamic limit quoted in [\[11\]](publication.html#ref-wei) is Lemma 2.2 at \(N=2\). The quadratic link of Section 4 places the observable of [\[11\]](publication.html#ref-wei) at \(M=4\) levels; the paper's \(\eta_N^{(N^2)}\) is the \(N\)-level generalisation of the same observable, with the probe's parity \((-1)^{n+1}\) replaced by the mean-zero clock weights \(c_n^{(N)}\).

## Proof

\(c_n^{(2)}=1-2\cdot\mathbf 1_{2\mid n}=(-1)^{n+1}\), so \(\sum_{n\le M}(-1)^{n+1}n^{-s}=\eta_2^{(M)}(s)\) by Lemma 3.2, and \((1-2^{1-s})\zeta(s)=-(2^{1-s}-1)\zeta(s)\). Verified to \(10^{-25}\) at \(M=4,100,10^4\) by `quantum_fisher_zeros_test.py`, Part 1.
