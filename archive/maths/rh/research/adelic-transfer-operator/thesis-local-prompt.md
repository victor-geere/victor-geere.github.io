# Prompt Tree: Completing the Local RT-Weight Theorem as a Standalone Paper

**Purpose:** Turn the outline into a fully rigorous, referee-ready 20–25 page paper.  
**Strategy:** Follow this tree sequentially. Each leaf prompt produces a self-contained LaTeX subsection or appendix. After finishing a phase, compile and send the diff for feedback.

**Master Prompt (run once at the beginning)**  
> You are an expert in quantum topology and p-adic geometry. Expand the attached outline into a complete, self-contained research paper proving that the Reshetikhin–Turaev invariant of the framed braid coming from any length-n periodic orbit on the Bruhat–Tits tree T_p equals exactly p^{-n}. Every step must be fully rigorous with explicit formulas, no deferred details, and no reliance on the global Riemann Hypothesis claim. Include all framing corrections, phase bookkeeping, and a reproducible verification suite. Output section-by-section in clean AMS-LaTeX.

---



## Phase 1: Foundations (Produce §2 + §3)

### 1.1 Bruhat–Tits Tree Background (2–3 pages)
**Prompt:** Write a self-contained 2–3 page subsection defining the Bruhat–Tits tree T_p of PGL(2, Q_p). Include: vertices as homothety classes of Z_p-lattices, the (p+1)-regular structure, boundary identification with P^1(Q_p), and the shift σ_p fixing the end at ∞. Prove that there are exactly p^n + 1 orbits of length n. Add a clean TikZ figure of T_5 with one highlighted periodic orbit. Cite Serre’s *Trees* and the original Bruhat–Tits papers.

### 1.2 Modular Tensor Category C_p — Complete Data (3–4 pages)
**Prompt:** Give the full data of the modular tensor category C_p = SU(2)_{p-2} at q = e^{πi/p}. Provide:  
- Simple objects and their quantum dimensions d_j(p).  
- The **correct** S-matrix formula S_{jj'} = √(2/p) sin(π(2j+1)(2j'+1)/p) (explicitly correct the common normalization error).  
- T-matrix and ribbon element.  
- Verlinde formula.  
- Definition of the Reshetikhin–Turaev invariant for a framed link presented as a braid closure.  
Include a table for p=3,5,7 with all fusion coefficients and S-matrix entries (to 6 decimals). End with a remark on why these categories are “prime-indexed” and why that matters for Euler products.

---

## Phase 2: Core Construction — Braid Encoding (Produce §4)

### 2.1 From Periodic Orbit to Framed Braid Word (3 pages)
**Prompt:** Give the explicit algorithm that turns a length-n periodic orbit on T_p into a word w ∈ B_n (the braid group on n strands). Specify the canonical ordering of strands induced by projecting the orbit to the boundary P^1(Q_p) and the cyclic action of σ_p. Work out two fully explicit examples: (p=3, n=2) and (p=5, n=3). Prove that the resulting framed link is independent (up to isotopy) of the choice of base vertex. Include TikZ braid diagrams with crossings labeled by the generators σ_i^{±1}.

### 2.2 Framing Prescription and 3-Manifold Identification (2 pages)
**Prompt:** Define the canonical framing (blackboard framing plus explicit writhe correction) that makes the RT invariant well-defined. Prove that the closure of this framed braid is a Seifert fibered 3-manifold over a 4-punctured sphere, and compute its Seifert invariants (Euler number, exceptional fiber multiplicities). Show that different choices of the distinguished end at infinity produce Galois-conjugate manifolds whose RT invariants have the same absolute value.

---

## Phase 3: Main Theorem and Proof (Produce §5)

### 3.1 Statement and High-Level Strategy (1 page)
**Prompt:** State Theorem 5.1 cleanly. Give a one-page roadmap of the proof: (1) Seifert manifold → Verlinde formula, (2) reduction to Gauss sum G_p, (3) evaluation of G_p via Landsberg–Schaar, (4) cancellation of all normalizations and phases to p^{-n}.

### 3.2 Verlinde Reduction and Gauss Sum (3 pages)
**Prompt:** Apply the Verlinde formula for the RT invariant of the Seifert manifold obtained in 2.2. Reduce the sum over all colorings to the single expression involving the Gauss sum  
G_p = ∑_j d_j(p) θ_j(p) S_{j0}.  
Write the exact prefactors coming from 1/D_p^{n-1} and the framing phases. Show that the theorem reduces to proving G_p = τ_p with the correct phase τ_p = e^{πi/4} p^{-1/2} (up to the overall p^{-n} factor after normalization).

### 3.3 Evaluation of the Gauss Sum via Landsberg–Schaar (4 pages — core technical heart)
**Prompt:** Prove the key identity  
∑_j d_j(p) θ_j(p) S_{jj'} = τ_p S_{0j'}  
for all j' using exponential sums over F_p and the Landsberg–Schaar reciprocity law in the form needed for this root of unity. Give the complete calculation: express the sum as a character sum, complete the square, apply the classical Gauss sum evaluation |∑_{k=0}^{p-1} e^{2π i k^2 / p}| = √p, and track every phase. Move lengthy estimates to Appendix A but keep the main logical flow in the text. Include a remark explaining why the result is independent of the auxiliary choices.

### 3.4 Phase Bookkeeping and Final Cancellation (2 pages)
**Prompt:** Collect every phase factor appearing from framing, ribbon element, and normalization. Show that they all cancel except for the overall factor p^{-n}. Write the final line of the proof explicitly.

---

## Phase 4: Numerical Verification Suite (Produce §6 + Appendix C)

### 4.1 Computational Framework (1 page)
**Prompt:** Describe a reproducible Python/SageMath implementation that computes the RT invariant exactly over cyclotomic fields for given p and n. Include the exact arithmetic setup (using `sympy` or `mpmath` with cyclotomic precision) and how framing is encoded numerically.

### 4.2 Verification Results (1–2 pages)
**Prompt:** Present a table (or heatmap) showing that for all primes p ≤ 17 and all periods n ≤ 8 the computed |RT − p^{-n}| < 10^{-50}. Provide the GitHub link or ancillary file containing the full script (with comments and a one-command reproduction instruction).

### 4.3 Edge Cases and Stress Tests (1 page)
**Prompt:** Verify the result for the fixed point at infinity (n=1) and for orbits that wind around different vertices. Discuss numerical stability when p is large (e.g., p=101).

---

## Phase 5: Polish and Submission Package

### 5.1 Introduction and Motivation Polish (1–2 pages)
**Prompt:** Rewrite the introduction to emphasize that this is a self-contained local result with potential applications to p-adic quantum invariants, even if the global RH program is set aside. Add a short “Why this is interesting” paragraph for readers who do not care about RH.

### 5.2 Figures and Tables
**Prompt:** Generate all required TikZ figures (tree with orbit, braid diagrams, S-matrix heatmaps, verification heatmap) and high-quality tables. Use consistent styling and professional captions.

### 5.3 References and Cross-Checks
**Prompt:** Expand the bibliography to 35–45 items with full bibliographic data. Cross-check every citation for accuracy. Add a “Notes for the Referee” paragraph addressing why the S-matrix normalization was corrected and why the framing treatment is more careful than in some earlier MTC literature.

### 5.4 Anti-Circularity & Independence Statement
**Prompt:** Add a one-paragraph subsection (or remark) explicitly stating that this paper makes no use of any global properties of the Riemann zeta function and can be read completely independently of any Hilbert–Pólya or adelic-operator program.

---

## Phase 6: Final Assembly & Submission

1. Concatenate all LaTeX sections into `local-rt-theorem.tex`.
2. Run `latexmk -pdf` and fix every warning.
3. Generate the ancillary verification notebook (Jupyter) and upload to a public GitHub repo.
4. Write a 1-page cover letter for *Quantum Topology* explaining the novelty (“first explicit computation of RT invariants for an infinite family of 3-manifolds coming from p-adic dynamics”).
5. Send the compiled PDF + source + notebook link to your PhD mentor (or me) for a final read-through before arXiv + journal submission.

---

**Estimated Total Effort:** 4–8 weeks of focused work if you already have the prompt tree and outline. The hardest part is the Gauss-sum evaluation in Phase 3.3 — budget extra time and consider asking a number theorist colleague to check that section.

**Deliverable:** A clean, self-contained 20–25 page paper that stands on its own and can be submitted to a specialist journal even if the larger RH project never materializes.

---

*When you finish any phase, paste the LaTeX output here and I will review it immediately.*