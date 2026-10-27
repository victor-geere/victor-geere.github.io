# (27) Every Jensen degree simultaneously — Σ_{d≥0} J^{d,n}(X)·t^d/d! = e^t·F_n(X·t)

**Kind:** Proposition
**Status:** PROVED (paper argument; verified to machine precision at three sample points, relative error 0, 2.2e−16, 1.1e−16)
**Area:** xi-horn
**Source:** [`xi-horn/CONTINUATION.md`](../../xi-horn/CONTINUATION.md) — §8.2 "What does work: one function of two complex variables", equation (27)

## Statement

> The whole Jensen family collapses into a single generating function. Summing (13) against t^d/d! and exchanging the order:
>
> ```
> Σ_{d≥0} J^{d,n}(X)·t^d/d!  =  e^t · F_n(X·t),     F_n(y) = Σ_{j≥0} a(n+j)·y^j/j!   (27)
> ```
>
> Verified to machine precision at three sample points (relative error 0, 2.2e−16, 1.1e−16). **Every Jensen degree simultaneously** is a Taylor coefficient of one function of two variables — *d* has become a coordinate without leaving ℂ.

## Hypotheses and notation

- J^{d,n}(X) = Σ_{j=0}^{d} C(d,j)·a(n+j)·X^j is the Jensen polynomial of POSITIVITY.md (13), with a(n) = γ(n)·n!/(2n)!.
- t is the generating variable conjugate to the degree d; F_n(y) = Σ_{j≥0} a(n+j)·y^j/j! is the degree-generating function at index n.
- The identity holds for every n ≥ 0.

## Proof / evidence

The source gives the derivation: sum (13) against t^d/d! and exchange the order of summation; the binomial C(d,j) and the 1/d! produce e^t together with the y^j/j! of F_n, with y = X·t. It reports machine-precision verification at three sample points (relative error 0, 2.2e−16, 1.1e−16).

## Dependencies and related results

- The Jensen polynomial J^{d,n} and the Laguerre–Pólya sequence a(n): [xihorn-positivity-jensen-laguerre-polya-criterion.md](xihorn-positivity-jensen-laguerre-polya-criterion.md) (12)–(13).
- The two-variable continuation that uses (27): [xihorn-continuation-two-variable-f-object.md](xihorn-continuation-two-variable-f-object.md).

## Notes

- The source presents (27) as the answer to "why not a quaternionic axis": slice-regular functions are determined on every slice by their values on one (the representation formula (26)), so a d-dependence installed on a quaternionic axis would be a rigid shadow of the w-dependence; the generating function instead makes d an ordinary complex coordinate.
- The machine-precision verification is at three sample points only; the source states "Verified to machine precision at three sample points".
