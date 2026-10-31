# The symbol-sign theorem

> **Correction (round 45).** Only the implication \(M\le0\Rightarrow s\le0\) is proved. The converse is not available: the prime half is a measure on the log-lattice, not a boundary value, and the symbol is tested only on the cone \(\{|\widehat F|^2\}\). The pointwise formulation is withdrawn. See [38-rescue.md](38-rescue.md) §2.1.

**Status (original, superseded by the banner above):** a rigorous reduction of the Hodge-index sign to the sign of the
full CCM symbol. The archimedean part of the symbol is exact; the prime part
is a distribution. Determining the sign of \(M\) is the remaining analytic
problem, and it is exactly the explicit-formula/zero-sum content.

## 1. The multiplier form

In log coordinates \(x=\log u\), write \(F(x)=f(e^x)\) and
\(F_-(x)=F(-x)\).  The CCM quadratic form is

\[
s(F,F)=N(F*F_-).
\]

Since \(\widehat{F_-}=\overline{\widehat F}\) for real \(F\),

\[
\widehat{F*F_-}=|\widehat F|^2.
\]

If the CCM functional is represented by a symbol \(M\), then

\[
\boxed{
s(F,F)=\bigl\langle M,\,|\widehat F|^2\bigr\rangle.
}
\]

Here \(M\) is the sum of the prime distribution and the archimedean symbol:

\[
M=\widehat{\mu_{\text{prime}}}+A_{\text{arch}}.
\]

## 2. The theorem

**Theorem.** *Let \(M\) be a real tempered distribution on \(\mathbb{R}\).  If
\(M\le0\) in the distributional sense, i.e.
\(\langle M,\phi\rangle\le0\) for every \(\phi\ge0\), then*

\[
s(F,F)\le0
\]

*for every real \(F\in C_c^\infty(\mathbb{R})\) satisfying the degree-zero
conditions.*

*Proof.*  For real \(F\), \(|\widehat F|^2\ge0\) is a nonnegative Schwartz
function.  Hence \(\langle M,|\widehat F|^2\rangle\le0\). ∎

The degree-zero conditions are linear constraints on \(F\); they do not
affect the sign implication.  Thus the Hodge-index inequality is **exactly**
the negativity of the full symbol \(M\).

## 3. The two halves

- **Archimedean.**  Exact:

  \[
  A_{\text{arch}}(\xi)
  =\frac12\left[\log\pi-\psi\!\left(-\frac{i\xi}{2}\right)\right].
  \]

  This is a function, not a distribution; its sign and poles are explicit.

- **Prime.**  The distribution

  \[
  \widehat{\mu_{\text{prime}}}(\xi)
  =\sum_{n\ge1}\Lambda(n)n^{i\xi},
  \]

  whose continuation is expected to be \(-\zeta'/\zeta(1/2-i\xi)\).  The
  naive cutoff fails at \(\Re(s)=1/2\); a regularization is required.

## 4. Why this is the right formulation

The finite compressions of notes 14–21 cannot decide the sign of \(M\):
they test finite matrices, not the distribution.  The symbol formulation:

- removes the truncation ambiguity;
- separates the exact archimedean half from the arithmetic prime half;
- identifies the Hodge-index sign with the sign of the explicit-formula
  symbol, hence with the zero sum.

The zeros of \(\zeta\) are the spectral data of \(M\).  The sign of \(M\) is
the Hodge-index/Weil positivity statement.

## 5. What remains

1. **Regularize the prime symbol** and prove
   \(\widehat{\mu_{\text{prime}}}=-\zeta'/\zeta(1/2-i\xi)\) on a suitable
   domain.
2. **Determine the sign of \(M\)** distributionally, or pass to the zero-sum
   form.
3. **Relate the sign to the zeros** and the explicit formula.
4. **Pass to the Bost–Connes crossed product** at \(\beta=1\).

No RH proof is claimed yet; the theorem is a reduction, not a proof of the sign.

## 6. Numerical checks

The archimedean symbol is checked in
[`../python/arch_symbol.py`](../python/arch_symbol.py) against its digamma
series.  The prime cutoff failure is recorded in
[`24-prime-symbol.md`](24-prime-symbol.md).  There is no numerical check of
the sign of \(M\) yet.

[Back to the dossier](../README.md) · [Research journal](../research-journal.md) ·
[The prime symbol](24-prime-symbol.md)
