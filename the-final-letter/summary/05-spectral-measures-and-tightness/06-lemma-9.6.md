# Lemma 9.6 (Tail localisation)

| Field | Value |
|---|---|
| Type | Lemma |
| Status | Proved |
| Source | [publication.html §9](../../geometric-dynamical-phase-transitions/publication.html#sec9) · 9. Tightness |
| Proof in source | yes |

## Statement

There are \(C(\delta,\varepsilon)\) and \(N_1(\delta,\varepsilon)\) such that for all \(N\ge N_1\) and every \(A\ge 3\), \[
\nu_N^{\mathrm{pp}}\bigl(\{A\le\lvert t\rvert\le(\log N)^2\}\bigr)\le C\,\frac{(\log A)^2}{A},
\qquad
\nu_N^{\mathrm{pp}}\bigl(\{\lvert t\rvert>(\log N)^2\}\bigr)\le\frac{C}{\log N}.
\] The same bounds hold for \(\mu_N^{\mathrm{pp}}\).

## Proof

Every atom with \(A\le\lvert t\rvert\le(\log N)^2\) lies within \(\omega(t)<1\) of a zero \(\rho\) of \(\Xi\) (Lemma 9.5 (i)); its component is trapped in \(D(\rho,r)\) and contains its own zero of \(\eta\) (Lemma 9.5 (ii)); distinct components contain distinct zeros, so the number of atoms attached to \(\rho\) is at most the number of zeros of \(\eta\) in \(D(\rho,r)\), which is at most \(C\log(2+\lvert\gamma\rvert)\) (Lemma 9.5 (iii)). Riemann–von Mangoldt gives at most \(C\log(2+k)\) zeros with \(\lvert\gamma\rvert\in[k,k+1]\), whence \[
\nu_N^{\mathrm{pp}}\bigl(\{A\le\lvert t\rvert\le(\log N)^2\}\bigr)
\le\sum_{k\ge A-1}\frac{C\bigl(\log(2+k)\bigr)^2}{1+k^2}\le C\,\frac{(\log A)^2}{A}.
\] Above height \((\log N)^2\), the anchoring of Definition 5.4 attaches to each atom a zero of \(\eta\) in its component within unit distance, distinct for distinct atoms, so Lemma 9.2 bounds the number of atoms with \(\lvert t-T\rvert\le\tfrac12\) by \(3(20\log N+2)\), and \[
\nu_N^{\mathrm{pp}}\bigl(\{\lvert t\rvert>(\log N)^2\}\bigr)\ll\log N\sum_{k\ge(\log N)^2-1}\frac{1}{1+k^2}\ll\frac{1}{\log N}.
\] Balanced closures are unrestricted closures with further conditions, so both bounds hold for \(\mu_N^{\mathrm{pp}}\). (Isolation packing alone gives the cruder \(O(N^{3\varepsilon-1/2}\log N)\) beyond the window \(\lvert t\rvert>N^{1/2-\varepsilon}\), the form quoted in Lemma 4.3.3.)
