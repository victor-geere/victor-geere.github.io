# Sylvester–monotonicity link

**Programme:** greedy harmonic decomposition / HST correlation kernel.
**Sources:** [`ghd-complete.md`](archive/maths/ghd-correlation-kernel/ghd-complete.md), Conjecture 6.4; [`hst-sylvester-sequence.html`](archive/maths/ghd-correlation-kernel/hst-sylvester-sequence.html), Conjecture 6.1.
**Status:** conjectural route; no proof.

## Statement

The monotonicity inequality

$$
\frac{d}{dt}\arg\Delta_\chi(t)\ge0
$$

can be proved combinatorially by showing that the filtration $\{\mathcal{S}(\theta)\}$ preserves a positivity property under continuous deformation of the density parameter $\theta$, with the extremal (Sylvester) case providing the base of the induction. The Sylvester constant $E$ controls the rate at which new integers enter the filtration in the extremal case.

## Context

The greedy Egyptian-fraction expansion of a rational $r\in(0,1]$ produces the Sylvester sequence in the extremal case $r=1$. The archived programme identifies this with the greedy harmonic filtration and proposes the Sylvester case as the induction base for the monotonicity of the argument of the correlation determinant $\Delta_\chi(t)$. The monotonicity is what would make the correlation kernel’s phase well behaved.

## Status

A conjecture and a proof strategy, not a theorem. It is not used by the current canonical paper. The canonical paper’s positivity statements are the min/max kernel of `tensor.md` Remark 7.3 and the Weil current, not this monotonicity.

[Back to folder README](summary/14-legacy-conjectures/README.md) · [Back to the summary index](summary/README.md)
