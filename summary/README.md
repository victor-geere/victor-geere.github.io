# Summary — the mathematical programme of victorgeere.co.za

Links in this folder are written **workspace-root-relative** (for example `summary/02-exact-filter-and-remainder/README.md`), so they resolve from the repository root in the DSH viewer.

A clickable HTML version of the full index is at [summary/index.html](summary/index.html).

This folder is a structured harvest of the mathematical research on the site: every theorem-like environment in the canonical paper, every frozen truth in its self-audit, every named result in the prime-spectrum tensor companion, the open items and conditional layers, and the explicitly labelled conjectures and hypotheses of the major archived research programmes. It is organised by mathematical theme, with a table of contents and a README in each folder.

The site is a research programme around the Riemann hypothesis, not a proof of it. The canonical paper, [`publication.html`](publication.html) (21 August 2026), proves a **conversion theorem**: RH is equivalent to the equality of the supports of two families of spectral measures. It also proves that its own additive toolbox cannot prove RH, by running the construction on the Davenport–Heilbronn function and correctly reporting a false RH. The remaining gap is stated precisely in several equivalent coordinates. Two working notes under [`maths/`](maths/) claim a complete proof; the canonical changelog records the identity on which they depend as false, and this summary treats them as historical working notes.

## Start here

| If you want to… | Read |
|---|---|
| Understand the whole programme in one sitting | **This README**, then [STATUS.md](summary/STATUS.md) |
| See the logical spine | [02 — Exact filter and remainder](summary/02-exact-filter-and-remainder/README.md) · [TOC](summary/02-exact-filter-and-remainder/TOC.md) → [03 — Path closures and Identity L](summary/03-geometry-and-identity-l/README.md) → [05 — Measures and the limit](summary/05-spectral-measures-and-tightness/README.md) · [TOC](summary/05-spectral-measures-and-tightness/TOC.md) |
| Understand why the paper is not a proof of RH | [05 — Corollary 12.3](summary/05-spectral-measures-and-tightness/13-corollary-12.3.md) and [06 — Davenport–Heilbronn](summary/06-davenport-heilbronn/README.md) · [TOC](summary/06-davenport-heilbronn/TOC.md) |
| See the exact remaining statement | [12 — The remaining gap](summary/12-open-problems/remaining-gap.md) |
| Audit a claimed proof of RH | [13 — Working notes](summary/13-working-notes/README.md) · [TOC](summary/13-working-notes/TOC.md) and [12 — Withdrawn and refuted](summary/12-open-problems/withdrawn-and-refuted.md) |
| Trace an idea back to the archive | [14 — Legacy conjectures](summary/14-legacy-conjectures/README.md) · [TOC](summary/14-legacy-conjectures/TOC.md) |
| Look up a symbol | [GLOSSARY.md](summary/GLOSSARY.md) |
| Find every conjecture, lemma, or proof by kind | [TYPE-INDEX.md](summary/TYPE-INDEX.md) |

The complete **file-level** index — every document in every folder, with a link — is in [TABLE-OF-CONTENTS.md](summary/TABLE-OF-CONTENTS.md).

## The programme in five paragraphs

**1. The object.** The paper compares two exact finite Euler sums at the quadratic link $M=N^2$:

$$
\eta_N^{(N^2)}(s)=H_{N^2}^{(s)}-N^{1-s}H_N^{(s)}
=\sum_{m\le N^2}c_m^{(N)}m^{-s},
\qquad
c_m^{(N)}=\begin{cases}1,&N\nmid m,\\1-N,&N\mid m.\end{cases}
$$

No infinite series is truncated. The coefficients carry a mean-zero root-of-unity filter, and their infinite sum is exactly $(1-N^{1-s})\zeta(s)$ for $\operatorname{Re}s>1$. The polygon is the path in $\mathbb{C}$ traced by the partial sums.

**2. The comparison.** Euler–Maclaurin applied to each Euler sum separately gives, throughout any closed substrip,

$$
\eta_N^{(N^2)}(s)=(1-N^{1-s})\zeta(s)+O\bigl((1+\lvert s\rvert)N^{1-2\sigma}\bigr),
$$

and on the critical line the error improves to $O(1+\lvert t\rvert)$. The prefactor has size $N^{1/2}$ there. The unmatched boundary term is the last chord

$$
H_N(s)=\tfrac12(1-N)N^{-2s},
\qquad
H_N(s)H_N(1-s)=\frac{(N-1)^2}{4N^2}\to\tfrac14.
$$

**3. The geometry.** A path-closure is a near-return of the polygon to the origin. A closure is **balanced** if it is relatively small, slow, and has a prefactor of size at least $N^{1/2-\varepsilon/2}$; otherwise it is **unrestricted**. Balanced closures are confined to $\sigma\le\tfrac12+\varepsilon/2$, and every critical-line zero produces one for large $N$. A simple off-line zero below the line is too fast to be balanced (Identity L / Lemma 4.5.2); a multiple zero is excluded by the jet (Lemma 4.5.3). A right-half zero remains an unrestricted closure. That asymmetry is the whole conversion.

**4. The measures.** The balanced and unrestricted families are tight; every weak-star limit is pure-point and supported on zeros of $\Xi$; the residual continuous spectrum vanishes. The central statement is

$$
\operatorname{supp}\mu=\operatorname{supp}\nu
\quad\Longleftrightarrow\quad
\text{every non-trivial zero of }\Xi\text{ lies on }\operatorname{Re}s=\tfrac12.
$$

This is Corollary 12.3. It is an equivalence, not a proof. The left-hand side is open.

**5. The limitative result.** Addendum C runs the same construction on the Davenport–Heilbronn function $f$, which has a functional equation and no Euler product. The framework transfers verbatim and reports a false RH at Spira’s off-line zero. Hence no theorem provable from the additive toolbox alone can be RH (Corollary C.10). The missing input must be multiplicative: hypothesis (M), no zeros in $\sigma>1$, characterises $P(s)L(s,\chi)$ among periodic Dirichlet series by Saias–Weingartner. Under (M) the obstruction lapses, but (M) still does not prove RH; the gap between what multiplicativity delivers and what the conversion needs is the critical strip.

## The folders

| Folder | Contents | Items |
|---|---|---|
| [00 — Scope and method](summary/00-scope-and-method/README.md) · [TOC](summary/00-scope-and-method/TOC.md) | What was harvested, what was excluded, and how status is assigned. | — |
| [01 — Foundations](summary/01-foundations/README.md) · [TOC](summary/01-foundations/TOC.md) | Definitions: $\Xi$, filters, Euler sums, the polygon. | 5 |
| [02 — Exact filter and remainder](summary/02-exact-filter-and-remainder/README.md) · [TOC](summary/02-exact-filter-and-remainder/TOC.md) | The exact identity, Theorem 4.1/4.3, depth and floor corollaries, scales, optional refinement. | 12 |
| [03 — Geometry and Identity L](summary/03-geometry-and-identity-l/README.md) · [TOC](summary/03-geometry-and-identity-l/TOC.md) | Last chord, jets, speed, Marty speed, closure criteria, Rouché localisation. | 16 |
| [04 — Continuous radius and mean values](summary/04-continuous-radius-and-mean-values/README.md) · [TOC](summary/04-continuous-radius-and-mean-values/TOC.md) | C¹ interpolation, the *correct* local diagonal, Montgomery–Vaughan. | 6 |
| [05 — Measures and the limit](summary/05-spectral-measures-and-tightness/README.md) · [TOC](summary/05-spectral-measures-and-tightness/TOC.md) | Tightness, no spurious atoms, residual vanishing, the conversion, atoms on the line. | 17 |
| [06 — Davenport–Heilbronn](summary/06-davenport-heilbronn/README.md) · [TOC](summary/06-davenport-heilbronn/TOC.md) | Transfer, sharpness, the limitative result, hypothesis (M). | 15 |
| [07 — Modular shadow](summary/07-modular-shadow/README.md) · [TOC](summary/07-modular-shadow/TOC.md) | Finite Euler sums mod $p$, Fermat quotients, no transfer to complex zeros. | 10 |
| [08 — Straightening field](summary/08-straightening-field/README.md) · [TOC](summary/08-straightening-field/TOC.md) | Holonomy as zero count, finite-data argument principle, (M) as puncture-freeness. | 11 |
| [09 — Quantum placements](summary/09-quantum-placements/README.md) · [TOC](summary/09-quantum-placements/TOC.md) | DQPT, free-energy density, Lee–Yang, the open item F.4, and the quantum dictionary. | 13 |
| [10 — Prime-spectrum tensor](summary/10-prime-spectrum-tensor/README.md) · [TOC](summary/10-prime-spectrum-tensor/TOC.md) | The refutation of $(\star)$, the exact spectrum, and the Weil-current repair. | 22 |
| [11 — Frozen truths](summary/11-frozen-truths/README.md) · [TOC](summary/11-frozen-truths/TOC.md) | All 90 numbered truths in 15 sections, with the corrections from `tensor.md`. | 90 truths / 17 docs |
| [12 — Open problems](summary/12-open-problems/README.md) · [TOC](summary/12-open-problems/TOC.md) | The remaining gap, (M), open items, RH equivalences, withdrawn statements, Addendum A. | 7 |
| [13 — Working notes](summary/13-working-notes/README.md) · [TOC](summary/13-working-notes/TOC.md) | The nested-spheres and continuous-cone notes, audited claim by claim. | 2 |
| [14 — Legacy conjectures](summary/14-legacy-conjectures/README.md) · [TOC](summary/14-legacy-conjectures/TOC.md) | Deduplicated conjectures/hypotheses from the archive, and the archived claimed proofs. | 17 |

Counts are documents in the folder, not lemmas; the 90 truths are grouped into 15 section files.

## What is actually proved

The unconditional core:

- the exact filter identity and the Euler–Maclaurin comparison ([Lemma 2.2](summary/02-exact-filter-and-remainder/01-lemma-2.2.md), [Theorem 4.1](summary/02-exact-filter-and-remainder/04-theorem-4.1.md));
- Identity L as a speed bound ([Lemma 4.5.2](summary/03-geometry-and-identity-l/05-lemma-4.5.2.md)) and the jet exclusion ([Lemma 4.5.3](summary/03-geometry-and-identity-l/06-lemma-4.5.3.md));
- Marty speed and the removal of the left half-strip ([Lemma 4.8](summary/03-geometry-and-identity-l/10-lemma-4.8.md));
- tightness, purity of limits, and the residual vanishing ([Theorem 9.1](summary/05-spectral-measures-and-tightness/08-theorem-9.1.md), [Theorem 10.1](summary/05-spectral-measures-and-tightness/09-theorem-10.1.md), [Theorem 11.1](summary/05-spectral-measures-and-tightness/10-theorem-11.1.md));
- the conversion [Corollary 12.3](summary/05-spectral-measures-and-tightness/13-corollary-12.3.md);
- the Davenport–Heilbronn sharpness and [Corollary C.10](summary/06-davenport-heilbronn/10-corollary-c.10.md);
- the modular shadow ([Addendum D](summary/07-modular-shadow/README.md));
- the straightening identities and finite-data theorem under (E.1) ([Addendum E](summary/08-straightening-field/README.md)).

The conditional or optional layers:

- Addenda A/B (Bourgain subconvexity, optional): [refined theorem](summary/12-open-problems/addendum-a-refined-theorem.md), [refined remainder](summary/02-exact-filter-and-remainder/12-refined-remainder.md);
- [Corollary C.14](summary/06-davenport-heilbronn/14-corollary-c.14.md) and [Corollary E.9](summary/08-straightening-field/09-corollary-e.9.md) under (M);
- [Theorem 12.6](summary/05-spectral-measures-and-tightness/16-theorem-12.6.md) under a vanishing aperture;
- the GUE/pair-correlation input in [Addendum F](summary/09-quantum-placements/README.md).

The open statement:

- the absence of a right-half atom of $\nu$ ([Corollary 12.3](summary/05-spectral-measures-and-tightness/13-corollary-12.3.md));
- equivalently the [joint non-vanishing of $K=\tfrac14\operatorname{Re}\xi$ and $S=\tfrac14\operatorname{Im}\xi$](summary/12-open-problems/remaining-gap.md);
- equivalently $0\le\Lambda\le0.22$ with $\Lambda=0$, or [positivity of the Weil current](summary/10-prime-spectrum-tensor/17-theorem-c-weil-criterion.md), or the [Jensen tower](summary/12-open-problems/remaining-gap.md).

## What is refuted or withdrawn

Do not quote any of these as live:

- [the integral $\int(1-R\varphi)(-\varphi)\,du=-\tfrac12$](summary/12-open-problems/withdrawn-and-refuted.md) — false; the integral is $-1+R\int\varphi^2$.
- the local diagonal $c_1=\tfrac12$ — false; see [Lemma 6.3](summary/04-continuous-radius-and-mean-values/03-lemma-6.3.md).
- [the envelope $\lvert\eta(\rho)\rvert\ge cD_N$ on the tightness band](summary/12-open-problems/withdrawn-and-refuted.md) — false.
- the tensor inequality $(\star)\ge0$ — false, unconditionally ([Theorem B](summary/10-prime-spectrum-tensor/08-theorem-b-star-is-false.md)).
- $\Phi$ is of positive type — false ([Proposition 5.1](summary/10-prime-spectrum-tensor/12-proposition-5.1-phi-not-positive-type.md)).
- the sign law for $K(\alpha,\cdot)$ — false for every $\alpha$ ([Proposition 6.3](summary/10-prime-spectrum-tensor/15-proposition-6.3-sign-law-false.md)).
- the claim that the two [`maths/` notes](maths/) prove RH — not accepted; see the [working-notes audit](summary/13-working-notes/README.md).

The full ledger is [12 — Withdrawn and refuted](summary/12-open-problems/withdrawn-and-refuted.md).

## Scope and method

**Harvested exhaustively.**

- `publication.html`: all 104 numbered definitions, lemmas, propositions, corollaries, theorems, remarks and open items, plus the 66 attached proof blocks, converted to Markdown with LaTeX preserved. The conversion was automated from the HTML and then curated; the statement and proof text is the source text, not a paraphrase.
- `truths.md`: all 90 numbered truths in 15 sections, verbatim.
- `tensor.md`: all 19 named lemmas/theorems/propositions/corollaries/definitions/remarks, plus the defining equation, the status ledger and the numerical appendix.
- `gaps.html`, `todo.md`, `publication-addendum-A.html`: the open items, conditional results, and the refined-remainder theorem with its seven-step proof.
- `maths/nested_spheres_RH.{md,html}` and `maths/continuous_cone_RH_solution.{md,html}`: every labelled claim, audited.
- `archive/`: the explicitly labelled **Conjecture** or **Hypothesis** statements of the major archived research programmes, the named result that states each equivalence, and one entry per programme-level claimed proof. Duplicate versions are collapsed; the selection rule is stated in folder 14.

**Excluded deliberately.**

- Finance, trading, and philosophy ebooks/essays (`archive/ebooks`, most of `archive/essays`), which contain no mathematical conjectures of this programme.
- Interactive visualisations and their JavaScript, except where a page is cited as the geometric picture (`viz.html`, `projection.html`).
- Successive archived versions of the same note, and `deepseek-checked1`–`6` variants, which repeat the same results.
- Raw HTML styling, MathJax configuration, and navigation.

**Status language.**

- **Proved** — a complete argument is in the canonical source, modulo cited classical theorems.
- **Conditional** — an explicit hypothesis is stated and the conclusion follows from it.
- **Equivalent** — a reformulation of RH, not a proof.
- **Open** — no proof is known here.
- **Refuted / withdrawn** — false or invalid; corrected in the folder.
- **Archived claim** — a historical claim in `archive/`, not accepted by the canonical paper.

## A note on the two working notes

The pages `maths/continuous_cone_RH_solution.html` and `maths/nested_spheres_RH.html` are linked from the canonical paper and conclude “the Riemann hypothesis follows.” They are not part of the proof chain. The continuous-cone note uses the local-diagonal identity that the canonical Lemma 6.3 corrects; the nested-spheres note inherits that bound and additionally claims support only on the critical line, which is stronger than the canonical Theorem 10.1/12.2. The canonical changelog says the differential inequality is not used and that depth comes from Theorem 4.1. The audit is in [13 — Working notes](summary/13-working-notes/README.md) · [TOC](summary/13-working-notes/TOC.md). If you have seen one of those pages in isolation, read the audit before citing it.

## Provenance

Every item file carries a source link and a section reference. The canonical source is:

- [`publication.html`](publication.html) — main paper, 21 August 2026.
- [`publication-addendum-A.html`](publication-addendum-A.html) — refined remainder.
- [`gaps.html`](gaps.html) — gap inventory and closed identities.
- [`truths.md`](truths.md) — frozen truths.
- [`tensor.md`](tensor.md) — prime-spectrum tensor resolution.
- [`todo.md`](todo.md) — strengthening list.
- [`maths/`](maths/) — the two working notes.
- [`archive/`](archive/) — legacy programmes.

The summary is a derivative index, not a replacement for the sources. Where a statement here and a source disagree, the source wins; where two sources disagree, the [withdrawn/refuted ledger](summary/12-open-problems/withdrawn-and-refuted.md) records the precedence and the reason.

[Master TOC](summary/TABLE-OF-CONTENTS.md) · [Status ledger](summary/STATUS.md) · [Glossary](summary/GLOSSARY.md)
