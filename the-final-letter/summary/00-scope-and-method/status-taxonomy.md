# Status taxonomy

Six labels are used throughout. The label is a claim about the evidence in the sources, not about the truth of the statement in a wider sense.

| Label | Meaning | Evidence required | Examples |
|---|---|---|---|
| **Proved** | A complete argument is in the canonical source, modulo cited classical theorems. | A proof block or a self-contained argument; dependencies named. | Theorem 4.1, Lemma 4.5.2, Theorem 9.1, Theorem C.9 |
| **Conditional** | An explicit hypothesis is stated and the conclusion follows from it. | The hypothesis is displayed; the proof uses it; the source says so. | Addendum A, Theorem 12.6 (vanishing aperture), Corollary C.14 (M), Theorem E.7 (E.1), Corollary F.9 (Bourgain) |
| **Equivalent** | A reformulation of RH, not a proof. | An iff statement whose one side is RH or an equally open statement. | Corollary 12.3, Corollary E.5, Corollary E.8, `tensor.md` Theorem C |
| **Open** | No proof is known here. | The source explicitly says open, or the item is a question. | F.4, (M), joint non-vanishing of $K,S$, $\Lambda=0$, uniform slow passage |
| **Refuted / withdrawn** | False, invalid, or superseded. | A counterexample, a corrected computation, or an explicit changelog withdrawal. | $(\star)$, $\Phi$ positive type, K sign law, $c_1=\tfrac12$, the envelope $|\eta|\ge cD_N$ |
| **Archived claim** | A historical claim in `archive/`, not accepted by the canonical paper. | The archive asserts it; the canonical paper does not use it; no independent verification is recorded here. | GDST, harmonic-sine, GHF/proof-99 |

## Edge cases

- **Definition.** Always a definition, never “proved”. Definitions can be inconsistent or badly motivated, but they are not true/false in the same way.
- **Remark.** A remark may be an assessment, a warning, or a non-claim. It is labelled **Remark**, with a parenthetical if it is an assessment. Remarks are not counted as proved results.
- **Cited result.** A theorem quoted from the literature (e.g. Saias–Weingartner, Montgomery–Vaughan) is **Proved** in the source only in the sense “cited”; the item metadata and the folder README name the citation. If the citation is the load-bearing step, the status says “Cited”.
- **Identity L.** A named identity that is a speed bound, not an envelope. Its status is **Proved (Lemma 4.5.2)**; the geometric reading is explanatory, not an extra proof.
- **Theorem 12.6.** Proved from a vanishing-aperture sequence, which is a definitional choice rather than an unproved arithmetic hypothesis. It is marked **Proved, conditionally on a vanishing aperture sequence** to make the dependency visible.
- **Corollary 12.3.** An equivalence. It is not marked “Proved” as a proof of RH, and it is not marked “Open” as a statement: the equivalence is proved, the left-hand side is open. The status string says exactly that.

## Precedence

If sources conflict:

1. The canonical paper’s changelog and `gaps.html` override older drafts.
2. `tensor.md` overrides `truths.md` where it explicitly corrects it (12.3, 15.3, 12.1 constant).
3. The canonical paper overrides the two `maths/` working notes.
4. The canonical paper overrides archived claims.
5. Within the canonical paper, an explicit “not a theorem” / “open” statement overrides a suggestive theorem title.

The [withdrawn/refuted ledger](../12-open-problems/withdrawn-and-refuted.md) is the operational form of this precedence.

[Back to folder README](README.md) · [Back to the summary index](../README.md)
