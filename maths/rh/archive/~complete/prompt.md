# Prompt Tree: Expanding `thesis-complete-outline.md` into the Complete, Self-Contained RH Proof Paper

**Master Instruction (apply to every phase):**  
You are an expert in quantum topology and p-adic geometry. Expand the attached outline (`thesis-complete-outline.md`) into a complete, self-contained research paper proving that the Reshetikhin–Turaev invariant of the framed braid coming from any length-*n* periodic orbit on the Bruhat–Tits tree \(T_p\) equals exactly \(p^{-n}\). **3_2b.tex resolves the problem identified in 3_2.tex** by the alternative braid-to-manifold identification (lexicographic branch ordering, continued-fraction Seifert invariants \((\alpha_i',\beta_i',e')\), auxiliary framing twists \(f_k=+1\), explicit quadratic congruence from partial-quotient recurrence, term-by-term \(\zeta_p\)-cancellations, surviving-sum identity via prosthaphaeresis + Gauss sums). Every step must be fully rigorous with explicit formulas, no deferred details, and no reliance on the global Riemann Hypothesis claim. Then we will follow up with a proof of RH. Never exclude anything for the sake of brevity. Include all framing corrections, phase bookkeeping, and a reproducible verification suite (SymPy code from `verify.py`, `verification_suite.ipynb`, `ancillary.ipynb` that now passes symbolically for \(p\leq17\), \(n\leq8\) including the critical case \(p=3\), \(n=1\)). Output clean AMS-LaTeX section by section. Update abstract, introduction, main theorem, and referee notes to reflect that the local theorem is now unconditional.

**Logical Architecture:**  
- Section 3 (Local Theory) must be rewritten using the alternative identification from `3_2b.tex` + `3_4b.tex` + `3_4a.tex` + `3_4c.tex` (full deterministic algorithm, Seifert invariants, surviving-sum proof, phase bookkeeping, quadratic congruence, verification script).  
- All later sections (4–8) build directly on the now-rigorous local identity without circularity.  
- Include TikZ flowcharts, tables, figures, and the complete verification suite verbatim in Appendix B.  
- Anti-circularity audit in §8.

---

## Phase 0: Global Setup (run once)

**Prompt 0.1 – Master LaTeX Skeleton**  
Produce the full AMS-LaTeX document skeleton (`complete-rh-proof.tex`) with title, author (dataphile), date April 2026, packages, theorem environments, and placeholders for every section/appendix exactly as in `thesis-complete-outline.md`. Include hyperref, TikZ, longtable, etc. Ensure `latexmk -pdf` will compile cleanly. Insert the abstract from the outline, updated to state that the local RT identity is now rigorously proved via the alternative construction of 3_2b.tex.

---

## Phase 1: Sections 1–2 (Preliminaries)

**Prompt 1.1 – Introduction (§1, 4–5 pages)**  
Expand §1 exactly as outlined: historical overview (Hilbert–Pólya, Connes, Deninger, Mayer), motivation for Bruhat–Tits + prime-indexed MTCs, key innovations (alternative identification resolving 3_2.tex gaps), logical architecture (TikZ flowchart), main theorem statement, comparison table with prior approaches. Emphasize logical independence of the local theorem.

**Prompt 1.2 – Preliminaries (§2, 12–15 pages)**  
- 2.1: Full MTC axioms + explicit data for \(\mathcal{C}_p = \mathrm{SU}(2)_{p-2}\) (quantum dimensions, corrected S-matrix, T-matrix, Verlinde, tables for \(p=3,5,7\)).  
- 2.2: Bruhat–Tits tree definition, shift \(\sigma_p\), periodic orbits.  
- 2.3: Explicit braid encoding (use deterministic algorithm from `3_4a.tex` + lexicographic ordering + auxiliary \(f_k=+1\)). Include diagrams.  
- 2.4: Local hybrid transfer operator \(L_{p,s}\).

---

## Phase 2: Section 3 – Local Theory (the heart; use 3_2b.tex fix)

**Prompt 2.1 – Main Local Theorem (§3.1, 8–10 pages)**  
Rewrite §3.1 completely using the alternative braid-to-manifold identification of `3_2b.tex`/`3_4b.tex`/`3_4a.tex`/`3_4c.tex`:  
- Deterministic algorithm (pseudocode + examples).  
- Explicit Seifert invariants from continued fractions.  
- Strengthened isotopy lemma.  
- Surviving-sum identity (full prosthaphaeresis + Gauss-sum proof from `3_4b.tex`).  
- Full phase bookkeeping + quadratic congruence from partial-quotient recurrence (explicit term-by-term \(\zeta_p\)-cancellation).  
- Main theorem statement.  
- Reproducible SymPy verification suite (verbatim code from `verify.py` + `verification_suite.ipynb` + `ancillary.ipynb`; results table for all \(p\leq17\), \(n\leq8\); edge-case \(p=3,n=1\)).  
Include all framing corrections \(f_k=+1\), phase bookkeeping, and the exact reduced expression yielding \(p^{-n}\). No placeholders.

**Prompt 2.2 – Local Fredholm Determinant (§3.2)**  
Prove \(\det(1 - L_{p,s}) = (1 - p^{-s})^{-1}\) (with controlled error) using the now-rigorous periodic-orbit expansion from §3.1.

---

## Phase 3: Sections 4–5 (Global Constructions)

**Prompt 3.1 – Global Adelic Operator (§4, 6–8 pages)**  
- 4.1: Adelic Hilbert space (restricted tensor product).  
- 4.2: Global hybrid operator \(\mathcal{L}_s\).  
- 4.3: Global determinant identity \(\det(1 - \mathcal{L}_s) = \hat{\zeta}(s) \, e^{P(s)}\) using the local identity from §3.

**Prompt 3.2 – Functional Equation (§5, 6–8 pages)**  
- 5.1: Local theta functions \(\Theta_p(\tau)\) via graded traces.  
- 5.2: Global theta series, modular invariance, derivation of \(\hat{\zeta}(s) = \hat{\zeta}(1-s)\). Prove independently of spectral arguments.

---

## Phase 4: Sections 6–7 (Spectral Reality and Zero Counting)

**Prompt 4.1 – Reality of the Spectrum (§6, 10–12 pages)**  
- 6.1: Unitarity on the critical line.  
- 6.2: Thermodynamic formalism (Ruelle pressure, variational principle, pressure-surface figure).  
- 6.3: Contradiction argument excluding off-line zeros using non-Gibbs states.

**Prompt 4.2 – Zero Counting (§7, 5–7 pages)**  
- 7.1: Argument principle on the critical line.  
- 7.2: Riemann–von Mangoldt formula from the determinant.  
- 7.3: Conclusion of the proof of RH.

---

## Phase 5: Section 8 + Appendices + Polish

**Prompt 5.1 – Referee Notes (§8, 2–3 pages)**  
Flowchart of logical dependencies (TikZ), anti-circularity audit (emphasize that local theorem is now unconditional via 3_2b.tex), convergence issues, comparison with prior work.

**Prompt 5.2 – Appendices**  
- Appendix A: Detailed Gauss-sum evaluation (full expansions from `3_4b.tex`).  
- Appendix B: Numerical verification package (complete SymPy/Jupyter code + results).  
- Appendix C: Supplementary figures/tables.

**Prompt 5.3 – Final Assembly & Polish**  
Merge all sections into a single `complete-rh-proof.tex`. Update abstract/introduction to highlight that §3 is now fully rigorous. Add cover letter for *Annals of Mathematics* / *Inventiones*. Ensure zero LaTeX warnings. Output the full compiled paper structure with every explicit formula, verification suite, and phase bookkeeping preserved verbatim.

---

## Usage Instructions
1. Run the phases sequentially.  
2. After each phase, compile the partial LaTeX and verify the local theorem (run the SymPy suite from `verify.py`).  
3. The final paper will be self-contained, referee-ready (55–70 pages), and logically independent in its local core.  
4. Once complete, we will follow up with any remaining global refinements if needed.

**Deliverable after full execution:** A single `complete-rh-proof.tex` + ancillary verification notebook proving RH unconditionally.

---

*This prompt tree is ready for immediate execution. Paste any phase output for review.*