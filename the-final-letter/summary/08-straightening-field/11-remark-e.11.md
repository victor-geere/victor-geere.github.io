# Remark E.11 (What this buys, and what it does not)

| Field | Value |
|---|---|
| Type | Remark |
| Status | Remark (assessment) |
| Source | [publication.html Addendum E](../../geometric-dynamical-phase-transitions/publication.html#adde) · Addendum E. The straightening field: rays, holonomy, and finite-data zero detection |
| Proof in source | no separate proof block |

## Statement

*What it buys.* Three things, and they are modest but real. (a) A normalisation. Lemma E.6 pins the terminal vertex at \(s\) and makes the three scales of Definition 4.4 dimensionless, read against \(\lvert s\rvert\); a closure event becomes the statement that the polygon resists straightening, which is a geometric reading of a numerical threshold. (b) An integer-valued observable. Theorem E.7 extracts \(Z_\zeta(\Gamma)\) from the finite Euler sums with a certified threshold, and the numerics of Section E.3 show the count surviving a relative amplitude error above \(200\%\) — a stability the modulus tests do not have, and the one place where the change of coordinates yields something a computation can use. (c) An independent confirmation. The holonomy of the Davenport–Heilbronn twist is \(+1\) about \(\rho_{\mathrm{DH}}\), certified from \(N=200\), which reproves Theorem C.9 from the phase rather than the modulus.

*What it does not buy.* The barrier is exactly where it was. Condition (E.1) requires \(C(1+T_\Gamma)N^{1-2\sigma_0}<m_\Gamma(N)\), and \(m_\Gamma(N)\asymp N^{1-\sigma_0}\min_\Gamma\lvert\zeta\rvert\), so the admissible periods begin at \[
N \;\gg\; \Bigl(\frac{C(1+T_\Gamma)}{\min_\Gamma\lvert\zeta\rvert}\Bigr)^{1/\sigma_0},
\] which is harmless — but the contour must be held at distance from the critical line, and as \(\sigma_0\downarrow\tfrac12\) the quantity \(\min_\Gamma\lvert\zeta\rvert\) collapses, since a contour hugging \(\sigma=\tfrac12\) passes arbitrarily close to critical-line zeros. No admissible \(\Gamma\) reaches the line, and the holonomy criterion says nothing about zeros on it. This is the fifth appearance of the same wall: the polar-cancellation window of Proposition 4.2, the depth scale of Definition 4.4, the sharpness of Corollary C.10, the absent Hecke theory of Remark D.9, and now the Rouché threshold.

More fundamentally, Corollary E.5 makes the situation transparent rather than tractable. The punctures of the straightening field *are* the zeros. Making the rays visible is not the same as forbidding a puncture from sitting off the line, and no property of a field can exclude its own singularities. The straightening picture is a faithful change of coordinates, and a faithful change of coordinates transports a problem without solving it.

## Proof

_No separate proof is given in the source. The statement is either a definition, a remark, a cited result, or is argued inline in the surrounding section._
