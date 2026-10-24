# 11 — Frozen truths

`truths.md` is the paper’s self-audit: ninety numbered statements that are true independently of how path-closures, balanced families, or measures are later named. It is deliberately **not** a proof of the Riemann hypothesis. Anything that holds only after a definition of “balanced” or “unrestricted” is restated there as an inequality, or omitted.

This folder reproduces all fifteen sections and all ninety truths, preserving the original numbering. Use [TOC.md](TOC.md) to jump to a section.

## What the file is for

The paper has been revised many times. `truths.md` freezes the identities that survived the revisions, so that renaming Identity L, changing the balanced/unrestricted checklist, or rewriting the Hilbert-zoom prose cannot reopen them. It opens with three **withdrawn falsehoods**:

- $\int(1-R\varphi)(-\varphi)\,du=-\tfrac12$ is false; the integral is $-1+R\int\varphi^2$.
- The local diagonal of Section 6 is $c_1=\tfrac12$ times $\rho^2$ is false.
- At an off-line zero, $\lvert\eta_N^{(N^2)}(\rho)\rvert\ge cN^{1/2-\varepsilon}$ on the tightness range is false if such a zero exists; Corollary 4.3.1 gives the opposite upper bound.

Those withdrawals are the key to reading the archived working notes in [folder 13](../13-working-notes/README.md).

## The sections

1. **Classical facts** (1.1–1.15): $\Xi$, Euler–Maclaurin, Montgomery–Vaughan, Gallagher, Riemann–von Mangoldt, stereographic projection, Marty speed, the approximate functional equation, Speiser.
2. **The integer filter and the Dirichlet polynomial** (2.1–2.8): exact coefficients, exact identity, size of the spikes, entireness, boundary term.
3. **Euler–Maclaurin for η** (3.1–3.4): Theorems 4.1 and 4.3, Proposition 4.2, Lemma 4.5.
4. **Size of η at zeros** (4.1–4.8): depth, uniform threshold, strip bound, floor, three scales, relative remainder.
5. **Derivatives at zeros** (5.1–5.4): speed, last-chord cancellation, jets, exclusion of slow passage.
6. **Mean values** (6.1–6.3).
7. **Local diagonal** (7.1–7.2): what the continuous filter actually is.
8. **Stereographic comparison** (8.1–8.6): Marty speed at zeros and twin lifts.
9. **Arithmetic about prefactors** (9.1–9.5): no measures.
10. **Rouché** (10.1–10.2): $\eta$ versus $(1-N^{1-s})\zeta$.
11. **Last-chord pairing** (11.1–11.6): the product identity, twins, dichotomy, north/south lifts.
12. **First principles of the cosine kernel** (12.1–12.7): Riemann’s $\Phi$, hyperbolic-cosine moments, what positivity does and does not give, seven RH equivalences.
13. **The sieve** (13.1–13.5): the same gap in four writings.
14. **What is true because it is** (14.1–14.5): the self-dual scale is proved; the occupation of any other scale is not.
15. **Where the solution sits** (15.1–15.10): the $K(\alpha,\gamma)$ slices, the Jensen tower of moments, Li’s jet at $s=1$.

## Corrections

`tensor.md` corrects three specific claims in `truths.md`; the corrections are authoritative:

- **12.3** says an off-line zero is *exactly* the vanishing of the cosine moment. It is necessary but not sufficient. The zero condition is the **joint** vanishing of $K(\alpha,\gamma)$ and its sine partner $S(\alpha,\gamma)$ (Corollary 6.2 of `tensor.md`).
- **15.3** proposes a sign law for $K(\alpha,\cdot)$ at $\alpha\neq0$. That law is **false for every $\alpha$**: $K(\alpha,\cdot)$ changes sign near every simple on-line zero and infinitely often (Proposition 6.3 of `tensor.md`).
- **12.1** leaves the constant unspecified. For the printed $\Phi$, the constant is $c=4$, i.e. $\hat\Phi=\tfrac12\Xi_{\cos}$ (Lemma 2.2 of `tensor.md`).

The rest of §15 stands, including the location of the remaining statement in the Jensen/Li jet. The corrections are indexed in [the tensor status ledger](../10-prime-spectrum-tensor/20-status-ledger.md).

## Status

These are proved identities, classical citations, and explicit non-claims. They define the object and locate the gap; they do not force $\Phi$ into the class that kills non-real zeros. The source’s own rule is worth repeating: if a later edit of `publication.html` contradicts this file, the later edit is wrong — except where `tensor.md` records a correction above.

[Back to the summary index](../README.md) · [Folder TOC](TOC.md)
