# The sign convention

> **Correction (round 45).** The sign is not open. With \(s=-N\) the probe's positive directions are the expected sign of the Weil functional; the real defect is that the recorded normalization is indefinite on exact tests. See [38-rescue.md](38-rescue.md) §2.4 and §4.

**Status (original, superseded by the banner above):** a fundamental convention issue. The computed CCM functional \(N\)
has a positive symmetric direction on the finite degree-zero probe. If
\(N=s\) and the criterion is \(s\le0\), this would contradict RH. The likely
resolution is that \(N\) as written is the **Weil form** \(W\ge0\), with the
self-intersection \(s=-N\), or that the quotation of the criterion carries
the opposite sign. The dossier's “negative definite” objective is therefore
convention-dependent.

## 1. The evidence

From the probe matrix of
[`10-hermitian-ccm-pairing.md`](10-hermitian-ccm-pairing.md), the symmetric
part \(S\) has eigenvalues

\[
\{-2.59\cdot10^{-4},\,-1.81\cdot10^{-6},\,
7.67\cdot10^{-4},\,2.90\cdot10^{-3}\}.
\]

The two positive eigenvalues are larger in magnitude than the negative ones.
On the exact degree-zero projection, the \(2\times2\) restriction had
eigenvalues approximately

\[
\{-1.0\cdot10^{-4},\,1.56\cdot10^{-3}\}.
\]

So the computed quadratic form has a **positive direction** on the
degree-zero subspace.

## 2. The two readings

- **Reading A: \(N=s\).**  The CCM criterion is \(s(f,f)\le0\).  The positive
  direction would then be a counterexample, which is implausible.  It would
  mean either the probe's projection is invalid or the formula's sign is
  wrong.
- **Reading B: \(N=W\).**  The functional with the plus signs in formula (13)
  is the Weil form, which is expected to be **nonnegative**:
  \(W(f)\ge0\).  The self-intersection is \(s=-W\) (up to boundary terms).
  The positive direction is then consistent with Weil positivity.

The 2018 paper's formula (13) writes \(N\) with a plus prime sum and a plus
archimedean term, and the text states RH \(\iff s(f,f)\le0\).  These are in
tension unless a sign is carried by the definition of \(s\) or by the
archimedean normalization.  The extraction and the normalized formula must be
checked against the original.

## 3. Consequence for the dossier

The objective says “negative definite on degree-zero classes.”  If Reading B
is correct, the correct statement is **positive definite** (Weil positivity),
and the Hodge-index sign is the opposite of the one used in the local model.
The local polarized surface has \(6D^2\le(A\cdot D)^2\), which is negative
definite on \(A^\perp\); the Weil form is positive definite.  The two are
related by the sign of the intersection pairing, not by an error.

This does not affect:

- the local Hodge index (a fixed sign convention);
- the finite KMS/Hodge–Riemann algebra (a fixed sign);
- the exact archimedean symbol (a formula);
- the symbol-sign theorem (the sign of \(M\) is whatever the convention
  dictates).

It does affect the interpretation of every “positive/negative” statement
about the CCM probe.

## 4. The archimedean sign flip

A direct test: on the same degree-zero subspace, compare

\[
M_+=M_{\text{prime}}+M_{\text{arch}},
\qquad
M_-=M_{\text{prime}}-M_{\text{arch}}.
\]

The symmetric-part eigenvalues are:

| \(K\) | \(M_+\) | \(M_-\) |
|---|---|---|
| 4 | \(+0.000549,+0.000771\) | \(-1.002,-0.493\) |
| 6 | \(-0.004104,+0.000117,+0.001048,+0.001602\) | \(-1.124,-0.618,-0.232,-0.0696\) |
| 8 | mostly negative, two positive | mostly negative, two positive (\(0.084,0.300\)) |
| 10 | mostly negative, several positive | mostly negative, several positive |

At \(K=4,6\) the **minus** convention is negative definite on the
degree-zero subspace, while the plus convention is positive or mixed.  At
\(K=8,10\) the minus convention develops positive directions, but these are
the same truncation artefacts documented in notes 14–21 (the sharp basis and
the compression error).

The low-\(K\) sharp-basis data favored the **minus** convention.  A
smooth, well-conditioned poly\(_2\) check gives a mixed result:

| \(K\) | \(M_+\) | \(M_-\) |
|---|---|---|
| 4 | \(+0.0010,+0.0015\) | \(-0.7146,-0.3693\) |
| 6 | all positive | \(-0.8510,-0.4552,-0.1035,+0.0572\) |
| 8 | mostly positive | \(-0.9198,-0.4974,-0.1390,+0.0126,+0.2214,+0.4290\) |

At \(K=4\) the minus convention is negative definite; at \(K=6\) it has a
positive direction (\(+0.0572\)).  The sharp-basis all-negative \(K=6\)
result was therefore **basis-dependent**, not a settled sign.

The sign convention is **not settled**.  The data lean toward subtracting
the archimedean term at the smallest truncation, but the positive directions
at \(K=6,8\) prevent a conclusion.  Formula (13) must be re-derived with all
signs before any sign claim is final.

The experiment is in
[`../python/sign_flip_probe.py`](../python/sign_flip_probe.py); the tests are
in [`../tests/test_sign_flip_probe.py`](../tests/test_sign_flip_probe.py).

## 5. How to settle it

1. Re-derive formula (13) from the explicit formula, keeping every sign and
   normalization.
2. Compare \(N\) with a known positive-definite Weil certificate on a common
   test function.
3. Fix the convention in one place and propagate it through the dossier.

Until then, no sign claim about the CCM form should be treated as final.

## 5. What is not in doubt

The **magnitude** structure — antisymmetric dominance, the near-degeneracies,
the archimedean sign change, the Abel and zero-sum obstructions — is
convention-independent up to an overall sign.  The unresolved question is
which overall sign is the Hodge-index sign.

No RH proof is claimed yet.

[Back to the dossier](../README.md) · [Research journal](../research-journal.md) ·
[Status](30-status.md)
