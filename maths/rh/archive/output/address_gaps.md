# Prompt Tree: Closing All Remaining Gaps in `complete.tex`

**Goal:** Convert the current logical skeleton of `complete.tex` (and attachments 3_2a.tex, 3_2b.tex, 3_3.tex, 3_4.tex) into a fully rigorous, self-contained, referee-ready research paper proving  
\[
\mathrm{RT}_{\mathcal{C}_p}(\beta') = p^{-n}
\]  
for every prime \(p \geq 3\) and every \(n \geq 1\), with **every algebraic identity derived term-by-term**, **no placeholders**, and a **fully reproducible verification suite** that recomputes the invariant from raw periodic-orbit data.

**Master Prompt (run once at the start)**  
You are an expert in quantum topology and p-adic geometry. Starting from the provided `complete.tex` and all attached subsections, produce a revised complete paper. Eliminate the three identified gaps: (1) asserted (not derived) identities, (2) placeholder verification code, (3) non-self-contained construction. Every step must use explicit formulas, term-by-term cancellations, and a complete runnable SymPy script. Output clean AMS-LaTeX section by section. No references to “ancillary notebook”, “attachment 3_2b.tex”, or “as derived in Phase X”.

---

### Phase 1: Explicit Construction — Orbit → Braid Word → Seifert Invariants

**1.1 Deterministic Algorithm for Braid Word and Continued Fraction**  
**Prompt:** Write a fully explicit, deterministic algorithm (with pseudocode and mathematical justification) that, given any length-\(n\) periodic orbit \(\gamma = (v_0, v_1 = \sigma_p(v_0), \dots, v_{n-1})\) on \(T_p\) using the lexicographic ordering at base vertex \(v_0 = [\mathbb{Z}_p^2]\), outputs: (i) the continued-fraction expansion \([a_0; a_1, \dots, a_{n-1}]\) of the induced slope on \(\mathbb{P}^1(\mathbb{Q}_p)\), (ii) the exact braid word \(\beta' = \prod_{k=1}^n \sigma_{i_k}^{\varepsilon_k} \cdot \Delta^{f_k}\) with auxiliary framing \(f_k = +1\), and (iii) the crossing indices \(i_k\) and signs \(\varepsilon_k = \operatorname{sgn}(a_k)\). Prove independence up to conjugation in \(B_n\). Include TikZ braid diagrams for \((p=3,n=2)\) and \((p=5,n=3)\) generated from the algorithm. Output as new subsection 4.1.

**1.2 Explicit Seifert Invariants from Continued Fractions**  
**Prompt:** Using the partial quotients \(a_k\) from 1.1, derive the closed-form expressions for the Seifert invariants \((\alpha_i', \beta_i', e')\) (\(i=1,\dots,4\)) with \(e' = -\sum \beta_i'/\alpha_i' + n\). Prove that these invariants force the Verlinde fusion rules to collapse onto the single column indexed by \(\ell = (p-1)/2\). Output as new subsection 4.2 (replace all current placeholders).

**1.3 Strengthened Isotopy Lemma**  
**Prompt:** Strengthen Lemma 1.1 with an explicit sequence of Reidemeister and Kirby moves showing that any change of starting vertex or distinguished end yields isotopic framed links while preserving the corrected framing \(f_k = +1\). Output as Lemma 4.1.

---

### Phase 2: Term-by-Term Derivation of the Two Key Identities

**2.1 Surviving Sum Identity (with \(\ell = (p-1)/2\))**  
**Prompt:** Prove from first principles, using only trigonometric identities and cyclotomic arithmetic over \(\mathbb{Q}(\zeta_p)\), that  
\[
\sum_{j} d_j(p) \, \theta_j(p) \, S_{j\ell} = \tau_p \, S_{0\ell}, \qquad \ell = (p-1)/2,
\]  
where \(\tau_p = e^{\pi i/4} p^{-1/2}\). Expand all sine products via prosthaphaeresis formulas, complete the square in the resulting exponential sum over \(\mathbb{F}_p\), and apply the classical quadratic Gauss-sum evaluation. Track every phase explicitly. Move lengthy expansions to Appendix A but keep the logical flow and final equality in the main text. Output as new subsection 5.3.1.

**2.2 Full Phase Bookkeeping and Quadratic Cancellation**  
**Prompt:** Starting from the explicit \(e'\) and corrected exponents \(e_k' = e_k + 1\), expand the total phase factor  
\[
\Bigl(\prod_{k=1}^n \theta_{j_k}^{e_k'}\Bigr) \exp(2\pi i \, e' \, h(\mathbf{j})) \, D_p^{-(n-1)}
\]  
and prove it equals \(\omega \cdot D_p^{n-1} \cdot p^{-n}\) (\(\omega\) a root of unity of modulus 1). Derive the required quadratic congruence  
\[
\sum_{k=1}^n e_k' \, j(j+1) + 2e' \sum_{i=1}^4 \frac{\beta_i'}{\alpha_i'} j_i(j_i+1) \equiv 2n \cdot j(j+1) \pmod{2p}
\]  
directly from the recurrence of the partial quotients \(a_k\) (write the recurrence explicitly) and cancel every power of \(\zeta_p\) term-by-term. Output as new subsection 5.3.2 (Phase Bookkeeping).

**2.3 Appendix A: Complete Symbolic Derivations**  
**Prompt:** Create a self-contained appendix containing all intermediate cyclotomic expansions for 2.1 and 2.2, worked examples for small \(n\), and SymPy verification snippets that confirm both identities symbolically for \(p=3,5,7,11,13,17\).

---

### Phase 3: Fully Reproducible Verification Suite (No Placeholders)

**3.1 Complete Runnable SymPy Script**  
**Prompt:** Write a single self-contained Python script (using only `sympy`) that:  
1. Takes prime \(p\) and a concrete periodic orbit (given as vertex labels or p-adic points).  
2. Executes the exact algorithm from Phase 1.1 to obtain \(\beta'\) and Seifert invariants.  
3. Computes the full (or reduced) Kirby–Melvin/Verlinde sum with all framing corrections.  
4. Evaluates it exactly over \(\mathbb{Q}(\zeta_p)\) and proves equality to \(p^{-n}\).  
Include the **complete verbatim script** in Appendix C with a one-line reproduction command. Output as new subsection 6.1.

**3.2 Verification Results and Edge Cases**  
**Prompt:** Run the script for all primes \(p \leq 17\) and periods \(n \leq 8\) (including \(n=1\) fixed point). Present a clean table showing exact equality (to 50+ decimal places). Add stress tests for large \(p\) (e.g., \(p=101\)) and different base vertices. Output as subsections 6.2–6.3.

**3.3 Reproducibility & Anti-Circularity Remark**  
**Prompt:** Add a one-paragraph remark stating that the script recomputes the RT invariant directly from raw orbit data using only the definitions in §§4–5; it does **not** assume the closed-form \(p^{-n}\). Provide a GitHub Gist placeholder.

---

### Phase 4: Final Assembly and Polish

**4.1 Integrate All Material into `complete-fixed.tex`**  
**Prompt:** Merge the output of Phases 1–3 into a single revised `complete.tex`. Update the abstract, introduction, main theorem statement, and conclusion to reflect that every step is now fully explicit and self-contained. Remove all placeholder language. Ensure `latexmk -pdf` runs cleanly with zero warnings.

**4.2 Notes for the Referee**  
**Prompt:** Add a short subsection explaining: (i) why the alternative identification with auxiliary twists \(f_k=+1\) resolves the previous obstructions, (ii) the corrected S-matrix normalization, and (iii) how the paper is now logically independent of any global Riemann Hypothesis claim.

**4.3 Final Deliverables**  
**Prompt:** Produce the bundle:  
- `complete-fixed.tex` (the full revised paper),  
- `verification_suite.py` (the complete runnable script),  
- `appendix_a_gauss.tex` (expanded derivations),  
- A one-page cover letter for *Quantum Topology* highlighting the first fully explicit RT computation for this infinite family of p-adic 3-manifolds.

---

**Usage Instructions**  
Copy this entire markdown block into a new file `gap-closure-prompt-tree.md`. Work sequentially through the phases. After completing any phase, paste the resulting LaTeX or code here for immediate review. The final output will be a self-contained 22–26 page paper with a fully working verification suite that rigorously proves \(\mathrm{RT}_{\mathcal{C}_p}(\beta') = p^{-n}\) unconditionally.