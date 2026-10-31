# Three attacks and the wall

**Status:** synthesis and reduction. The three routes below were pursued in
parallel. Each reduces the Frobenius alternative to a single positivity, and
each positivity is equivalent to (or stronger than) Weil positivity. None of
the known structural legs forces it. No RH proof is claimed.

## 1. The three attacks

| route | object | missing lemma | status |
|---|---|---|---|
| Riemann–Roch square | square of the complex lift \(\Gamma_\mathbb{Q}^2\) | longitudinal HRR / Castelnuovo–Severi bound | local HRR proved; global open |
| arithmetic Hodge index | adelic line bundles on \(X/K\) | absolute Hodge-index realization | Yuan–Zhang does not apply; a realization would prove RH |
| Sonin / prolate | Sonin space \(S(1,1)\), prolate operator | off-diagonal positivity \(E\le\operatorname{Tr}\) | gap is central and off-diagonal; \(c=0\) is false; only archimedean |

The full details are in
[`07-riemann-roch-square.md`](07-riemann-roch-square.md),
[`06-angular-bochner-attack.md`](06-angular-bochner-attack.md) and
[`05-frobenius-alternative.md`](05-frobenius-alternative.md).

## 2. What each attack proved

### 2.1 Riemann–Roch square

- The local HRR on the periodic-orbit tori is a theorem:
  \(\chi(A,\mathcal{O}(D))=\tfrac12D^2\) on a complex torus.
- The curve-level Riemann–Roch theorem for
  \(\overline{\operatorname{Spec}\,\mathbb{Z}}\) gives **trivial**
  effectivity: a divisor is effective iff its degree is non-negative. It is
  not the missing leg.
- Its dimension is **subadditive**,
  \(h^0(D+E)\le h^0(D)+h^0(E)\), not submodular or log-concave; and its
  Serre duality is **not dimension-preserving**.
- The missing object is the global longitudinal HRR on
  \(\Gamma_\mathbb{Q}^2\), equivalently the Castelnuovo–Severi bound
  \[
  Z(f)\cdot_{\mathrm{trans}}Z(f)
  \le 2\,d(Z)d_0(Z)-\Delta\cdot\Delta\,f*f^\#(1),
  \]
  which CCM Proposition 7.2 identifies with RH.

### 2.2 Arithmetic Hodge index

- Yuan–Zhang's theorem applies to proper varieties over a number field with
  a polarization and finite-type models. \(\overline{\operatorname{Spec}\,\mathbb{Z}}\)
  is not such a variety; it is the base, of relative dimension zero. There is
  no ample class and no abelian Jacobian.
- If there were a proper surface with a polarization whose adelic
  intersection pairing computed the CCM trace, Yuan–Zhang would give the
  missing positivity, hence RH. Since Yuan–Zhang is a theorem and RH is open,
  **no such realization is known**; the realization itself is the missing
  hypothesis.
- The Fargues–Fontaine curve is local at one prime, has genus zero (wrong
  sign) and no global assembly. It does not fill the gap.

### 2.3 Sonin / prolate

- The Sonin inequality is
  \[
  W_\infty(g*g^*)\ge \operatorname{Tr}(\vartheta(g)S\vartheta(g)^*)
  -c\,|\hat g(0)|^2,
  \qquad 13<c_*<17.
  \]
- The gap is the **central value** \(|\hat g(0)|^2=\tilde f(1/2)\), not the
  \(H^0/H^2\) pole terms. It cannot be absorbed by completing \(\zeta\).
- The gap direction lies in \(L^2(I)\subset S(1,1)^\perp\), so no positive
  operator supported on \(S(1,1)\)—including the de Branges kernel—can
  dominate it. The needed inequality is **off-diagonal**, between \(S(1,1)\)
  and \(L^2(I)\).
- The inequality with \(c=0\) is false (conditional on the finite spectral
  bounds); the best constant is positive. Even \(c=0\) would only give
  archimedean Weil positivity (Yoshida's theorem), not RH; RH needs the
  semilocal extension.

## 3. The common wall

The three missing lemmas are different coordinates for the same wall:

\[
\underbrace{\chi(\Gamma_\mathbb{Q}^2,E(f))=\tfrac12s(f,f)}_{\text{longitudinal HRR}}
\quad\Longleftrightarrow\quad
\underbrace{M_f^2\le0}_{\text{absolute Hodge index}}
\quad\Longleftrightarrow\quad
\underbrace{E(g*g^*)\le\operatorname{Tr}(\vartheta(g)S\vartheta(g)^*)}_{\text{off-diagonal Sonin positivity}}.
\]

Each is equivalent to, or immediately implies, Weil positivity. None follows
from the known legs:

- the scaling correspondence and its trace formula are known;
- the degree/codegree and Fubini step are known;
- the curve-level Riemann–Roch theorem is known;
- the arithmetic Hodge index for varieties over number fields is known;
- the Sonin/prolate norm positivity is known.

What is missing is a positivity that is **off-diagonal/absolute**: it relates
two different spaces, not a single Hilbert-space norm. Diagonal positivity
cannot supply it.

## 4. Does the structure demand the legs?

Not in the sense of derivability. The known legs are consistent with the
missing positivity but do not imply it. A proof that the fourth leg is
"there"—that the longitudinal HRR holds, or that the absolute Hodge-index
realization exists, or that the off-diagonal Sonin inequality holds—would be
a proof of RH. The structure *demands* the leg only in the trivial sense that
a complete proof must contain it; it does not *produce* it.

This is the precise answer to the working hypothesis “the structure demands
that the legs are there”: the first three legs are there, the fourth is the
whole problem.

## 5. What a genuine new idea must do

A new idea must prove one of the three equivalent statements, not rearrange
the existing legs:

1. **Longitudinal HRR.** Prove the Hirzebruch–Riemann–Roch formula on
   \(\Gamma_\mathbb{Q}^2\) with topological side \(\tfrac12s(f,f)\), via the
   Connes–Skandalis index theorem and the \(L^2\)-localisation on the elliptic
   periodic orbits.
2. **Absolute Hodge index.** Construct a proper polarized arithmetic surface
   whose adelic intersection pairing computes the CCM trace and is negative
   definite on degree-zero classes. By Yuan–Zhang, this would prove RH.
3. **Off-diagonal Sonin positivity.** Prove
   \(E(g*g^*)\le\operatorname{Tr}(\vartheta(g)S\vartheta(g)^*)\) for all
   admissible \(g\), or its semilocal extension. This is an off-diagonal
   Hodge–Riemann/Serre-type positivity, not a diagonal kernel bound.

The three are not independent; a proof of one would likely give the others.
But none is a corollary of the existing theory.

## 6. Conclusion

The search did not find a proof of RH. It found the exact wall: the
Frobenius alternative is equivalent to an absolute/off-diagonal positivity
that the known structure does not force. The local HRR is proved; the
curve-level Riemann–Roch theorem is exact but linear; the arithmetic Hodge
index stops at varieties over number fields; the Sonin gap is central and
off-diagonal.

The absence of a construction is not a no-go. The remaining leg is an open
realization problem: construct the absolute polarized Hodge-index object.
A realization would be a proof of RH; none is known yet. The Riemann
hypothesis remains open.

## Source claims

- **S17.** Yuan–Zhang, *The arithmetic Hodge index theorem for adelic line
  bundles I* (Thm. 1.3). Standard; not formalised.
- **S18.** Connes–Consani, *Weil positivity and trace formula: the
  archimedean place* (2020), Thm. 1 and Thm. 6.11; the Sonin gap and its
  best constant. Standard; not formalised.
- **S19.** The synthesis of §3–§5 is this dossier's interpretation, not a
  theorem.

[Back to the dossier](../README.md) · [The Riemann–Roch square](07-riemann-roch-square.md) ·
[The Frobenius alternative](05-frobenius-alternative.md)
