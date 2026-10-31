# Why this dossier takes the intersection-form arm

**Status:** a recorded choice, not a theorem. It responds to the bridge survey
[`../../../bridge-to-weil-positivity.md`](../../../bridge-to-weil-positivity.md)
and to the two computed zeros of the `N=2` polygon.

The brief allowed either a Lee–Yang measure or an intersection form. This
folder takes the intersection form, for two reasons.

## The Lee–Yang arm is closed for the programme's polygon

The geometric programme set out to confine the zeros of the finite polygon

\[
\eta_N^{(N^2)}(s) = \sum_{m=1}^{M} c_m^{(N)} m^{-s}
\]

to a line, and the summary allowed that the most one could expect is
clustering. The finite object does not cooperate. `polygon_zero.py` certifies
two zeros of the `N = 2` polygon with real parts in disjoint intervals around
`0.57802` and `0.80014` (`C46`/`C47`; `B26`/`B28` in `BRIDGES.md`), and the
exact zero at `s = 0` is off the critical line (`T62`/`T63`). Disjoint real
parts mean the zeros are not confined to *any* single vertical line, let alone
the critical line.

That closes F.4 for this object. The finite Ising Lee–Yang theorem (`T55`)
remains a true model, but it is not the polygon. The survey records the
closure in its §6, and this dossier does not reopen it.

## A Lee–Yang measure for `ξ` would be circular

Independently of the polygon, the natural Lee–Yang target would be a positive
measure `μ` on `R` whose Stieltjes transform is the non-trivial part of the
logarithmic derivative of the completed zeta function. Since `ξ` is entire and
its zeros are the non-trivial zeros `ρ = ½ + iγ_ρ` together with the trivial
zeros at `-2, -4, …`, the precise statement separates the trivial terms:

\[
\frac{1}{i}\left(
  \frac{\xi'}{\xi}\!\left(\tfrac12 + iw\right)
  - \sum_{n\ge 1}\frac{1}{\tfrac12 + iw + 2n}
\right)
   = \int \frac{d\mu(t)}{t-w},
\qquad
\mu = \sum_{\rho} \delta_{\gamma_\rho}.
\]

The identity is true with that `μ`. But `μ` is *defined from the zeros*.
Assuming it is a positive measure is assuming the `γ_ρ` are real, which is RH.
The Lee–Yang engine (a positive measure has a Stieltjes transform with no zeros
off the support) is provable and useful, but it does not supply `μ` from
arithmetic data. The construction would have to come from outside, and the
only known candidate, the Weil distribution, is signed: the explicit formula's
prime side has negative coefficients.

The intersection form does not have this circularity. It can be written down
without knowing the zeros, and its positivity is a theorem. What it lacks is a
correspondence. That is a different and, this folder argues, more informative
obstruction.

## What is lost

The Lee–Yang arm would have given a direct spectral statement. The
intersection-form arm gives a finite linear-algebraic core and a precise
negative result: the positivity is available, the correspondence is not. The
trade is deliberate: a proved finite core plus an honest obstruction, rather
than a conditional measure with the conclusion built in.

[Back to the dossier](../README.md) · [Bridge survey](../../../bridge-to-weil-positivity.md)
