# Lemma C.6 (Exact filter form)

| Field | Value |
|---|---|
| Type | Lemma |
| Status | Proved |
| Source | [publication.html Addendum C](publication.html#addc) · Addendum C. The Davenport–Heilbronn twist: sharpness of the conversion |
| Proof in source | yes |

## Statement

If \(N\equiv1\pmod 5\) then \[
\eta_N^{\mathrm{DH},(N^2)}(s)=\sum_{m\le N^2}c_m^{(N)}a^{\mathrm{DH}}_m\,m^{-s},
\] so the twisted pair is literally the coherent polygon of Section 3 with steps reweighted by \(a^{\mathrm{DH}}\). For \(N\not\equiv1\pmod5\) the identity fails.

## Proof

\(N^{1-s}H_N^{(s)}[a]=N\sum_{j\le N}a_j(Nj)^{-s}\), and for \(m=Nj\le N^2\) one has \(m\equiv j\pmod 5\) exactly when \(N\equiv1\pmod 5\), whence \(a_j=a_m\) and the subtracted sum is \(N\sum_{N\mid m,\;m\le N^2}a_m m^{-s}\). Otherwise the two indexings disagree. Numerically the discrepancy is \(0\) to \(10^{-21}\) at \(N=11,16,21\) and of size \(0.77\)–\(4.9\) at \(N=12,13,14\).
