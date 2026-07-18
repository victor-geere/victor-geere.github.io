# Action Plan for the Research Programme  
**A Greedy Harmonic Substitution in the Geometric Framework for the Riemann Hypothesis**

## Objective  
The programme aims to substitute the smooth trigonometric functions in the geometric approach to the Riemann Hypothesis with their greedy harmonic sine (and cosine) reconstructions, thereby transforming the Riemann helix into a polygonal curve. This substitution renders the torsion singularities explicit and Dirac-delta supported, allowing the Geometric Explicit Formula (GEF) to be recast as a combinatorial identity between the correlation kernel of the greedy harmonic decomposition and the prime distribution. Successful completion of the programme will establish the GEF in the distributional sense and, conditionally, prove the Riemann Hypothesis.  

The plan is structured around the five core steps identified in the research programme, augmented by preparatory, numerical, and validation activities to ensure rigour and verifiability.

## Phase 1: Foundational Verification of the Greedy Harmonic Sine Reconstruction  
1. Implement the recurrence relation (3) in a high-precision computational environment to compute the sequence of thresholds \(\{\theta_n^*\}_{n=0}^N\) for sufficiently large \(N\). Verify that only active indices \(n \in \mathcal{A}\) satisfy \(\theta_n^* < \pi\).  
2. Confirm uniform convergence of \(S_N(\theta)\) to \(\sin\theta\) on \([0,\pi]\) and quantify the \(O(1/N)\) error bound numerically and, where possible, analytically.  
3. Derive and compute the explicit correlation kernel  
   \[
   K(n,m) = \int_0^\pi \bigl(\delta_n(\theta) - \tfrac{\theta}{\pi}\bigr)\bigl(\delta_m(\theta) - \tfrac{\theta}{\pi}\bigr)\,d\theta
   \]  
   for active pairs \((n,m)\). Establish closed-form expressions or efficient recursive formulae for \(K(n,m)\).  
4. Extend the construction to the cosine approximation via the shift \(\theta \mapsto \pi/2 - \theta\) and verify consistency of the pair \((\cos_G, \sin_G)\).  

**Deliverable:** A documented software library (Python/SageMath or equivalent) with validated threshold sequences, kernel matrix, and convergence diagnostics.

## Phase 2: Derivation of the Explicit Torsion Formula for Polygonal Helices  
1. Develop a rigorous Frenet–Serret analysis for piecewise-linear space curves \(C(t) = (\cos\Phi(t),\sin\Phi(t),t)\) where \(\Phi\) is a non-decreasing step function. Derive the precise coefficients \(c_k\) of the Dirac singularities in the torsion measure at each vertex \(t_k\) where \(\Phi\) jumps or its derivative jumps.  
2. Specialise the general formula to the greedy phase function \(\phi_G(t)\) and express the singular part of \(\tors_{\widetilde{C}_1}\) in terms of the jump heights \(\alpha_{a_k}\) and the local scaling \(\Delta t_k\).  
3. Identify the smooth interpolation component that will contribute to the archimedean background \(\tau_{\mathrm{arch}}\).  

**Deliverable:** A self-contained manuscript section (or preprint appendix) containing the torsion formula together with complete proofs of all limiting arguments used in the piecewise-linear setting.

## Phase 3: Construction and Asymptotic Analysis of the Greedy Phase Function  
1. Define the scaled greedy phase \(\phi_G(t)\) (or \(\Phi(t)\)) by coupling the zero-counting function \(N(t)\) (via \(u(t) = \pi N(t)\)) with the greedy reconstruction \(S_N\), choosing the scaling parameter \(R\) to enforce the zero-locking condition \(\Phi(\gamma_n) = 2\pi n\) asymptotically.  
2. Prove that \(\Phi\) is strictly increasing and that its derivative jumps occur precisely at the rescaled active thresholds \(t_k\). Establish the relation between jump sizes and the harmonic weights \(\alpha_n\).  
3. Obtain explicit asymptotic expansions for the locations \(t_k\) and the cumulative step sum \(\sum_{t_k \le T} \Delta\Phi(t_k)\) using the known density of \(N(t)\).  

**Deliverable:** Rigorous construction of \(\Phi(t)\) and verification that it satisfies the necessary monotonicity and locking properties.

## Phase 4: Proof of the Kernel-Weighted Prime Correspondence and Archimedean Remainder  
1. Demonstrate that the correlation kernel \(K(n,m)\), when summed against the greedy weights, reproduces the von Mangoldt-weighted prime distribution:  
   \[
   \sum_{t_k \le T} \frac{\alpha_{a_k}}{\Delta t_k} \;\delta(t-t_k) \quad \text{corresponds to}\quad \tau_{\mathrm{prime}}(t) + O(\text{controlled error}).
   \]  
   This step replaces the classical Weil explicit formula with the combinatorial identity arising from the uniform convergence \(S_N \to \sin\theta\).  
2. Isolate and identify the smooth archimedean contribution \(\tau_{\mathrm{arch}}(t)\) arising from the continuous part of \(\Phi\) and the background density of \(u(t)\).  
3. Control all error terms using the \(O(1/N)\) convergence rate of the greedy approximation and standard zero-density estimates.  

**Deliverable:** Complete proof of the central identity linking the greedy thresholds to the prime powers, together with explicit bounds on the remainder.

## Phase 5: Distributional Limit, Convergence, and Final Assembly  
1. Pass to the distributional limit as \(N \to \infty\) (greedy width) and mollifier width \(\varepsilon \to 0\), establishing  
   \[
   \tors_{\widetilde{C}_1} = \tau_{\mathrm{prime}} + \tau_{\mathrm{arch}}
   \]  
   in \(\dist(\R)\).  
2. Verify that the two major conjectures (Greedy-Prime Correspondence and Polygonal Torsion Limit) are resolved by the preceding steps.  
3. Assemble the full proof of the GEF and discuss conditional implications for the Riemann Hypothesis.  

**Deliverable:** Comprehensive research manuscript ready for internal review and eventual submission.

## Cross-Cutting Activities  
- **Numerical Validation:** Perform large-scale simulations for finite \(N\), comparing computed torsion singularities directly with explicit prime-power locations \(m\log p\). Generate visualisations of the discrete helix and torsion measure for diagnostic purposes.  
- **Literature and Peer Review Integration:** Maintain continuous consultation with the Geometric Framework literature; schedule periodic internal reviews of each phase by team members.  
- **Computational Resources:** Utilise high-precision arithmetic libraries and parallel computing for kernel and threshold computations; archive all code and data for reproducibility.  
- **Risk Mitigation:** Identify potential obstacles (e.g., exact matching of thresholds to primes, control of error terms) and maintain contingency sub-plans, including fallback to weaker asymptotic correspondences if full equality proves intractable.

## Success Criteria  
- All five programmatic steps completed with peer-verified proofs.  
- Numerical experiments confirm the correspondence to machine precision for large finite \(N\).  
- The resulting manuscript provides a self-contained, combinatorial route to the GEF, independent of heavy analytic number theory beyond standard zero-density estimates.

This action plan provides a clear, sequential, and measurable pathway to execute the proposed research programme. It emphasises explicit computations, rigorous derivations, and iterative numerical checks to maximise the probability of success while maintaining full traceability at every stage. Progress will be tracked against the defined phases, with adjustments made only upon documented justification.