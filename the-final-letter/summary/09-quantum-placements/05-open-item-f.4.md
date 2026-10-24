# Open item F.4 (A Lee–Yang property for the polygon)

| Field | Value |
|---|---|
| Type | Open item |
| Status | Open problem |
| Source | [publication.html Addendum F](../../geometric-dynamical-phase-transitions/publication.html#addf) · Addendum F. Quantum answers: where the physics literature sits against each gap |
| Proof in source | no separate proof block |

> **Editorial note.** A Lee–Yang/confinement property for the polygon. It passes the Davenport–Heilbronn litmus and is the main open placement in Addendum F.

## Statement

Is there a ferromagnetic spin system whose finite-volume partition functions are \(\eta_N^{(N^2)}\), or whose zeros are confined to a line for every \(N\)? The classical facts set the boundary conditions. For the plain partial sum \(H_X^{(s)}\) the answer is no: Montgomery [\[40\]](../../geometric-dynamical-phase-transitions/publication.html#ref-partialsums) showed that \(H_X\) has zeros with \(\sigma>1\) for large \(X\), reaching \(\sigma=1+\Omega(\log\log X/\log X)\), and Gonek–Ledoan [\[40\]](../../geometric-dynamical-phase-transitions/publication.html#ref-partialsums) showed that \(H_X\) has \((T/2\pi)\log X+O(X)\) zeros up to height \(T\), none with \(\sigma\ge1+2\log\log X/\log X\), with \(O(TX^{1-2\sigma}\log^6T)\) zeros of real part \(\ge\sigma\) for \(\sigma\ge\tfrac12+1/\log T\), so that almost all zeros satisfy \(\beta\le\tfrac12+c_1\log\log T/\log X\). The finite zeros cluster to the line without lying on it. For the filtered polygon the same estimates transfer (they are mean-value estimates in the additive basis), so the most one can expect is clustering, and Part 2 of `quantum_fisher_zeros_test.py` records what happens at small \(N\) (Section F.7).

## Proof

_No separate proof is given in the source. The statement is either a definition, a remark, a cited result, or is argued inline in the surrounding section._
