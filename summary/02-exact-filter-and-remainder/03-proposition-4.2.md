# Proposition 4.2 (Geometric distinction of the quadratic link)

| Field | Value |
|---|---|
| Type | Proposition |
| Status | Proved |
| Source | [publication.html §4](publication.html#sec4) · 4. Quadratic scaling and the explicit remainder |
| Proof in source | yes |

## Statement

Fix the filter period \(N\) and consider the one-parameter family of Euler-sum pairs \[
Q_\alpha(s)=H_{N^\alpha}^{(s)}-N^{1-s}H_N^{(s)},\qquad\alpha>1.
\] (i) \(Q_\alpha\) coincides with the coherent sum \(\eta_N^{(\lfloor N^\alpha\rfloor)}\) of Definition 3.1 for every \(N\ge 2\) precisely when \(\alpha=2\): the inner Euler sum removes the multiples of \(N\) up to \(N^\alpha\) exactly when \(\lfloor N^\alpha/N\rfloor=N\). (ii) The polar terms of the two Euler–Maclaurin expansions cancel if and only if \((N^\alpha)^{1-s}=N^{1-s}\cdot N^{1-s}\), that is \(\alpha=2\); otherwise the comparison with \((1-N^{1-s})\zeta(s)\) carries the uncancelled pole term \(\bigl(N^{\alpha(1-s)}-N^{2(1-s)}\bigr)/(1-s)\). (iii) At \(\alpha=2\) the two remainders are \(O((1+\lvert s\rvert)N^{-2\sigma})\) and \(N^{1-\sigma}\,O((1+\lvert s\rvert)N^{-\sigma})\), so on \(\sigma=\tfrac12\) the error is \(O(1+\lvert t\rvert)\) while the prefactor of \(\zeta\) has size \(N^{1/2}\).

## Proof

\(i\) \(N^{1-s}H_N^{(s)}=N\sum_{j\le N}(Nj)^{-s}\) is the sum over the multiples of \(N\) up to \(N^2\) (Lemma 3.2); for \(\alpha>2\) the multiples of \(N\) up to \(N^\alpha\) are more numerous, for \(\alpha<2\) fewer, for every \(N\ge 2\). (ii) and (iii) are the displayed Euler–Maclaurin formula applied to each Euler sum, as in the proof of Theorem 4.1.
