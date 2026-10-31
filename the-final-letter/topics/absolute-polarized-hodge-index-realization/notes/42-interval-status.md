# Interval certification: what exists, what is measured, what is missing

**Status:** the priority item — an interval-certified analytic Gram entry — is
**not achieved**. This note records the exact obstruction with measurements,
so the next round can attack it directly. No RH proof yet.

## 1. What exists

The sibling dossier has a rigorous enclosure of the archimedean density:

```python
programme.omega_interval(t, h, delta, U)  # mp.iv enclosure of Ω(t)
```

and an interval-PSD routine in
[`../../prime-spectrum-tensor/python/certify_gram.py`](../../prime-spectrum-tensor/python/certify_gram.py)
(center plus operator-norm slack, rational leading minors). Its
[`WEIL-GRAM.md`](../../prime-spectrum-tensor/WEIL-GRAM.md) records a
four-point Gaussian certificate with an explicit tail bound.

I attempted a fresh run of `certify_gram.py` in this session. It produced no
output after several minutes and was stopped; the certificate is **not
reproduced here**. The script is documented as a long computation, and the
Gaussian basis is not the compact-support basis of this dossier.

## 2. Measured widths of the certified Ω enclosure

Default parameters (`h=0.005`, `delta=0.01`, `U=10`):

| \(t\) | interval width |
|---|---|
| 0.5 | \(2.86\cdot10^{-3}\) |
| 1 | \(3.76\cdot10^{-3}\) |
| 2 | \(1.51\cdot10^{-3}\) |
| 5 | \(2.77\cdot10^{-4}\) |
| 10 | \(7.08\cdot10^{-5}\) |

Tightened to `h=5e-4`, `delta=5e-3`, `U=20`, the width at \(t=1\) is
\(2.12\cdot10^{-4}\) (11 s). This is the central obstruction: the exact
cosh \(+\Omega\) compact-support Gram has eigenvalues

\[
0,\quad 1.1\cdot10^{-7},\quad 9.98\cdot10^{-5},\quad 1.67\cdot10^{-3},
\]

so the smallest positive margin is of order \(10^{-4}\). A certified
enclosure of the integral therefore needs both

1. Ω widths well below \(10^{-4}\) at every quadrature node, and
2. a rigorous bound on the panel quadrature error of
   \(\int \widehat F_i\widehat F_j\Omega\).

The current Ω enclosure satisfies (1) only after tightening, and (2) is not
implemented at all in this dossier.

## 3. What is formalised, and what is not

New in [`../lean/Shadow.lean`](../lean/Shadow.lean):

| theorem | content |
|---|---|
| `two_by_two_pos` | if \(a>0\) and \(ac-b^2>0\), then \(a x^2+2bxy+cy^2\ge0\) for all \(x,y\). |

This is the algebraic core of the leading-minor interval certificates. It
does **not** certify any analytic entry; it certifies the final rational
step once interval entries are available.

Not formalised: the interval quadrature, the Ω enclosure, and the analytic
Gram entries.

## 4. The precise next computation

1. **Panel-wise interval bound.** On each panel \([a,b]\), bound
   \(\Omega(t)\) by `omega_interval(mid)` plus a Lipschitz term
   \(L\cdot(b-a)/2\), with \(L\) a certified bound on
   \(|\Omega'|=\tfrac12|\operatorname{Im}\psi'(1/4+it/2)|\). A certified
   bound for \(\psi'\) is the missing analytic input.
2. **Quadrature error.** Use the midpoint rule with the same Lipschitz bound
   for the product \(\widehat F_i\widehat F_j\Omega\), whose derivative
   includes \(\widehat F_i'\widehat F_j\Omega\), etc. The transforms are
   explicit, so their derivatives are explicit.
3. **Tail.** Bound \(\int_T^\infty|\widehat F_i\widehat F_j\Omega|\) using
   \(|\Omega(t)|\le C\log(t+2)\) and the explicit decay of the transforms.
4. **Assemble and certify.** Feed the interval Gram to the rational
   leading-minor test (`two_by_two_pos` for the \(2\times2\) block, a
   Cholesky shadow for \(4\times4\)).

Until step 1 has a certified \(\psi'\) bound, no interval Gram entry is
claimed.

## 5. Round 10: the two certified inputs, and why they are still too coarse

**Certified \(\psi'\) bound.** From
\(\psi'(z)=\sum_{k\ge0}1/(z+k)^2\) and the integral comparison,
`psi_prime_abs_bound(t)` in [`../python/rescue_probe.py`](../python/rescue_probe.py)
returns a valid upper bound for \(|\psi'(1/4+it/2)|\):

| \(t\) | bound | numerical |
|---|---|---|
| 0.5 | 20.0 | 8.39 |
| 1 | 5.41 | 3.24 |
| 2 | 2.27 | 1.11 |
| 5 | 0.747 | 0.403 |
| 10 | 0.344 | 0.200 |

The bound dominates the numerical value at every tested point (test
`test_psi_prime_bound_dominates_numerical`).

**Certified panel enclosure.** `omega_panel_interval(a,b)` evaluates the
sibling's point enclosure at the midpoint and inflates it by
\(\tfrac12\,\text{bound}\cdot(b-a)/2\). Measured radii:

| panel | radius |
|---|---|
| \([0,0.1]\) | 0.5 |
| \([0.4,0.6]\) | 1.0 |
| \([1.0,1.2]\) | 0.271 |

The enclosures contain the sampled values (test
`test_omega_panel_contains_samples`).

**Why this is still not a certificate.** The exact cosh \(+\Omega\) Gram
has a \(2\times2\) leading block with eigenvalues
\(2.49\cdot10^{-5}\) and \(5.34\cdot10^{-4}\). The margin is
\(2.5\cdot10^{-5}\), smaller than the point-enclosure width
\(2.1\cdot10^{-4}\) at \(h=5\cdot10^{-4}\), and the panel radii above are
\(0.27\)–\(1.0\). To certify the block, the \(\Omega\) enclosure must be
tightened by an order of magnitude (roughly \(h=5\cdot10^{-5}\), about
\(10\) times the cost, \(\sim100\) s per point) and the panel quadrature
must be second-order with a bound on the integrand's second derivative. That
is a dedicated long computation, not a one-line tightening.

## 6. Round 11: the perturbation step formalised

The interval certificate has two algebraic steps: leading minors for the
centre, and a perturbation/slack step for the interval widths. The second is
now Lean-checked in [`../lean/Shadow.lean`](../lean/Shadow.lean):

| theorem | content |
|---|---|
| `quadForm_add` | `Q(G + E, v) = Q(G, v) + Q(E, v)`. |
| `quadForm_perturb` | if `Q(G,v) ≥ t∑vᵢ²` and `Q(E,v) ≥ −t∑vᵢ²`, then `Q(G+E,v) ≥ 0`. |

This is the exact step used by the sibling certificate's
`interval_psd_certificate` (centre plus operator-norm slack). It does not
supply the interval entries.

The certified Gaussian run in the sibling dossier was restarted uncapped in
this session; after more than ten minutes it had produced no output and was
left running. It is **not** claimed as reproduced.

## 7. Bottom line

- The exact sign question is closed on the compact-support rung: cosh
  \(+\Omega\) is the PSD convention (note 41).
- Interval certification is not done: the certified Ω widths are
  \(10^{-4}\)–\(10^{-3}\), and no rigorous panel quadrature bound is
  implemented.
- No RH proof yet.

[Back to the dossier](../README.md) · [Quadrature correction](41-quadrature-correction.md) ·
[Lean core](../lean/README.md) · [Research journal](../research-journal.md)
