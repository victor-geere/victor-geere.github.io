# 13 — Working notes: nested spheres and the continuous cone

The two notes in [`maths/`](maths/) are linked from the canonical paper, but they are **not** part of its proof chain. Both assert a complete geometric proof of the Riemann hypothesis. The canonical paper, its changelog, and `gaps.html` do not accept that conclusion: they record the local-diagonal identity on which the notes depend as **false**, and they replace the differential-inequality route by the Euler–Maclaurin depth bound of Theorem 4.1.

This folder preserves the notes as working material, with each claim marked against the canonical text. It is the place where a reader should look if they have seen the sentence “the Riemann hypothesis follows” on one of those pages and want to know its status.

## The two notes

| Note | What it attempts | Status |
|---|---|---|
| [Nested spheres](summary/13-working-notes/nested-spheres.md) | Extends the polygon to all $N\ge2$, places it on nested Hopf fibres, and claims tightness plus support on critical-line zeros implies RH. | Definitions and exact identity are consistent with the paper; the final support and depth claims are not established. |
| [Continuous cone](summary/13-working-notes/continuous-cone.md) | Replaces integer $N$ by real $R$, derives a differential inequality for $\rho(R,s)=\lvert\eta_R(R^2)(s)\rvert$, and claims a power-saving depth bound plus RH. | The differential inequality rests on the withdrawn identity $c_1=\tfrac12$; the conclusion is not accepted. |

## The decisive correction

The continuous-cone note’s Lemma 2.1 asserts

$$
\int_{-1}^{1}(1-R\varphi(u))(-\varphi(u))\,du=-\frac12+O(R^{-1}),
$$

and uses the constant $\tfrac12$ to obtain a negative drift term. The canonical paper evaluates the same local diagonal in **Lemma 6.3** and records the correct value:

$$
\int(1-R\varphi)(-\varphi)\,du=-1+R\int\varphi^2,
$$

which is not $-\tfrac12$. The changelog states the consequence plainly:

> **D, D′ ($c_1=\frac12$ and the differential inequality).** The local integral is evaluated correctly in Lemma 6.3 and is not $-\frac12$. The differential inequality is not used. Depth of closure follows from Theorem 4.1 at zeros: $\lvert\eta\rvert=O(1+\lvert\gamma\rvert)$.

`gaps.html` lists the same item: “D local integral $=-\frac12$ — Lemma 6.3 evaluates it correctly; $c_1=\frac12$ withdrawn.” And again: “D′ differential inequality — Not used.”

## What survives

The notes are not worthless. The exact identity, the all-$N$ parity independence, the sampling error $O(N^{-1})$, the nested-fibre geometry, and the C¹ regularity of the continuous filter are consistent with the canonical treatment. The canonical paper itself cites `nested_spheres_RH.html` for the $O(N^{-1})$ sampling error. What does **not** survive is the derivation of a decay rate from the local quadratic form, and therefore the claimed proof of RH.

## How to cite these notes

Do not cite either note as a proof of the Riemann hypothesis. Cite them, if at all, as working notes / historical attempts, with the canonical correction above. The authoritative statements are:

- [Lemma 6.3 (Local diagonal)](summary/04-continuous-radius-and-mean-values/03-lemma-6.3.md)
- [Theorem 4.1 (Explicit remainder)](summary/02-exact-filter-and-remainder/04-theorem-4.1.md)
- [Corollary 12.3 (Conversion of RH)](summary/05-spectral-measures-and-tightness/13-corollary-12.3.md)
- [The withdrawn-falsehoods ledger](summary/12-open-problems/withdrawn-and-refuted.md)

[Back to the summary index](summary/README.md) · [Folder TOC](summary/13-working-notes/TOC.md)
