# Theorem C.8 (Transfer)

| Field | Value |
|---|---|
| Type | Theorem |
| Status | Proved |
| Source | [publication.html Addendum C](publication.html#addc) · Addendum C. The Davenport–Heilbronn twist: sharpness of the conversion |
| Proof in source | yes |

## Statement

Replace \((\eta_N^{(N^2)},\zeta,\Xi)\) throughout Sections 5 and 8–12 by \((\eta_N^{\mathrm{DH},(N^2)},f,f)\). Every definition and every proof goes through verbatim, yielding tempered measures \(\mu_N^{\mathrm{DH}}\) (balanced) and \(\nu_N^{\mathrm{DH}}\) (unrestricted) on \(S_\delta\), tight, with every weak-star limit pure-point and supported on zeros of \(f\).

## Proof

The inputs used are: the pair structure of Definition 3.1 (Definition C.5); the main-term comparison of Theorem 4.3 (Theorem C.7, with the same exponents and no half-term); the three scales of Definition 4.4, unchanged since \(P_N\) depends only on \(N\) and \(s\); Jensen's formula for the zero count of Lemma 9.2, which needs only that the polygon is a Dirichlet polynomial of length \(N^2\) with coefficients \(O(N)\), true here with the bound \(\lVert a\rVert_\infty\) in place of \(N-1\); Rouché and the minimum principle in Lemma 9.5, which need only holomorphy of \(\eta^{\mathrm{DH}}/(1-N^{1-s})\) for \(\sigma<1\); and a classical floor for the limit function off its zeros. For the last, \(f\) is a finite combination of Dirichlet \(L\)-functions by Lemma C.4(ii), so the Titchmarsh §9.6 argument of Lemma 9.4 applies to each summand and to \(f\) with a modified constant. Riemann–von Mangoldt for \(f\) is classical. One step requires comment, since it is the only place where an Euler-product input could enter unnoticed. The trapping in Lemma 9.5(ii) needs the barrier circle to remain inside \(\delta/4\le\sigma\le1-\delta/4\), which bounds \(\beta\) away from \(1\). This is now obtained from the strip membership of \(s\) together with \(c_\delta\le\delta/84\), an elementary argument valid for any limit function; it is *not* obtained from the zero-free region of de la Vallée Poussin, which is a consequence of the Euler product and is false for \(f\). With that substitution no step invokes an Euler product, a zero-free region derived from one, or the location of the zeros of the limit.
