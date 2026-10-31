# Normalization dictionary: CCM versus the explicit formula

> **Correction (round 45).** The dictionary is now exact: \(A_{\text{arch}}+Q=-Z'/Z(-i\xi)\) on \(\operatorname{Im}\xi>1\), and the \(n^{-1/2}\) is the contour shift \(\sigma\mapsto\sigma+\tfrac12\). See [38-rescue.md](38-rescue.md) §3.

**Status (original, superseded by the banner above):** a term-by-term comparison of the CCM functional with the standard
explicit formula. The comparison identifies the source of the overall sign
ambiguity — the \(n^{-1/2}\) weighting and the archimedean normalization — but
does not settle it. A contour-integral derivation is still required.

## 1. The two functionals

The CCM functional is

\[
N(h)=\sum_{n\ge1}\Lambda(n)h(n)
+\int_1^\infty\frac{u^2h(u)-h(1)}{u^2-1}\,d^*u+c\,h(1),
\qquad
c=\frac{\log\pi+\gamma}{2}.
\]

The standard explicit formula, for a suitable test function \(f\) on
\(\mathbb{R}\), is schematically

\[
\sum_\rho \widehat f(\rho)
=\widehat f\!\left(\frac12\right)+\widehat f\!\left(-\frac12\right)
-\sum_{n\ge1}\frac{\Lambda(n)}{\sqrt n}
\bigl(f(\log n)+f(-\log n)\bigr)
+\text{archimedean}.
\]

The precise archimedean factor depends on the Fourier convention; in the
`weil_shadow` normalization it is
\(\Omega(t)=\Re\psi(1/4+it/2)-\log\pi\).

## 2. Term-by-term

| term | CCM \(N\) | explicit formula |
|---|---|---|
| prime | \(+\sum\Lambda(n)h(n)\) | \(-\sum\frac{\Lambda(n)}{\sqrt n}(h(\log n)+h(-\log n))\) |
| archimedean | \(+\int_1^\infty\frac{u^2h(u)-h(1)}{u^2-1}d^*u+c h(1)\) | \(+\int \widehat f(t)\Omega(t)\,dt\) |
| pole/trivial | \(c h(1)\) | \(\widehat f(1/2)+\widehat f(-1/2)\), plus trivial-zero terms |

For a convolution square \(h=f*f^\#\), \(h(u)=h(1/u)\), so the prime term of
the explicit formula is \(-2\sum\Lambda(n)n^{-1/2}h(n)\).  The CCM term is
\(+\sum\Lambda(n)h(n)\).  The two differ by:

- a factor \(n^{-1/2}\), absorbed by the convolution normalization;
- an overall **minus sign**, once the \(n^{-1/2}\) is absorbed.

This is the origin of the suspected relation \(N=-W\) (up to boundary terms).

## 3. The archimedean side

The CCM archimedean integral and the explicit-formula
\(\int\widehat f\Omega\) are two representations of the same gamma-factor
contribution, but their normalizations differ.  The exact archimedean symbol
of [`23-archimedean-symbol.md`](23-archimedean-symbol.md),
\[
A_{\text{arch}}(\xi)=\frac12\left[\log\pi-\psi\!\left(-\frac{i\xi}{2}\right)\right],
\]
is the symbol of the CCM integral.  The explicit-formula \(\Omega\) uses a
different digamma argument, \(\psi(1/4+it/2)\), reflecting a different
normalization of the test function.

The sign flip experiment of
[`31-sign-convention.md`](31-sign-convention.md) is consistent with the
overall minus at low \(K\), but not decisive.

## 4. What is missing

A rigorous derivation must:

1. fix the Mellin/Fourier convention and the measure;
2. compute the contour integral
   \(\frac{1}{2\pi i}\int\frac{\xi'}{\xi}(s)\widehat h(s)ds\);
3. identify the residues at the pole and the trivial zeros;
4. match each term to the CCM integral, including the \(n^{-1/2}\) factor
   and the archimedean sign.

Until then, the relation between \(N\) and the explicit formula is a
normalization conjecture, not a theorem.

## 5. No sign claim

The dossier's Hodge-index statements are conditional on this convention.
The local and finite-algebra results have fixed signs; the CCM sign does
not.  No RH proof is claimed yet.

[Back to the dossier](../README.md) · [Research journal](../research-journal.md) ·
[The sign convention](31-sign-convention.md)
