# Proposition F.3 (Clock-register realisation of the polygon)

| Field | Value |
|---|---|
| Type | Proposition |
| Status | Proved |
| Source | [publication.html Addendum F](publication.html#addf) · Addendum F. Quantum answers: where the physics literature sits against each gap |
| Proof in source | yes |

## Statement

Let \(\omega=e^{2\pi i/N}\). By Lemma C.2, \[
\eta_N^{(M)}(s)=-\sum_{j=1}^{N-1}\sum_{n=1}^{M}\omega^{jn}\,n^{-s},
\] so \(Z(\beta)^{-1}\eta_N^{(M)}(\beta+it)\) is minus the sum of \(N-1\) probe signals of the type measured in [\[11\]](publication.html#ref-wei), the \(j\)-th one taken after the modular phase gate \(\lvert n\rangle\mapsto\omega^{jn}\lvert n\rangle\) on the working register. Equivalently, with a clock ancilla of dimension \(N\) prepared in the uniform state, it is the probe signal projected on the complement of the trivial Fourier mode of the ancilla — the quantum Fourier transform over \(\mathbb{Z}/N\) with the zero frequency removed. The quadratic link \(M=N^2\) is the statement that the working register holds twice as many qubits as the clock.

## Proof

Finite Fourier inversion of \(c_n^{(N)}\), as in Lemma C.2; the modular phase gate is diagonal and commutes with \(\mathcal{H}_0\), so it can be applied before or after the evolution. Resources: the protocol of [\[11\]](publication.html#ref-wei) plus one diagonal gate per \(j\), or one ancilla of \(\lceil\log_2N\rceil\) qubits; \(\lceil\log_2 N^2\rceil=2\lceil\log_2N\rceil\) up to rounding.
