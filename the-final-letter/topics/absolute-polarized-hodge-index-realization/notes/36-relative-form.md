# The relative modular form is indefinite

> **Correction (round 45).** The relative form is a difference of positive operators; its indefiniteness is expected and does not close the renormalization route. This obstruction is withdrawn. See [38-rescue.md](38-rescue.md) §2.3.

**Status (original, superseded by the banner above):** a precise obstruction to the naive relative renormalization. The
relative Hamiltonian \(H_{\varphi|\psi}=\log\rho_\varphi-\log\rho_\psi\)
does not inherit the Hodge-index sign: the relative form is indefinite for
random states. The modular positivity is specific to the modular Hamiltonian
of a single state, not to a relative difference.

## 1. The relative form

For two faithful states \(\varphi,\psi\) on \(M_n(\mathbb{C})\), with
densities \(\rho_\varphi,\rho_\psi\), define

\[
H_{\varphi|\psi}
=\log\rho_\varphi-\log\rho_\psi,
\qquad
B_{\varphi|\psi}(a,a)
=\operatorname{Re}\varphi\bigl(a^*[H_{\varphi|\psi},a]\bigr).
\]

This is the natural finite analogue of the relative modular operator.

## 2. The numerical result

| \(n\) | seed | min | max | indefinite |
|---|---|---|---|---|
| 2 | 0 | \(-0.1829\) | \(0\) | no |
| 2 | 1 | \(-1.1616\) | \(0\) | no |
| 2 | 2 | \(0\) | \(+0.1557\) | no |
| 3 | 0 | \(-3.1049\) | \(0\) | no |
| 3 | 1 | \(-1.5922\) | \(0\) | no |
| 3 | 2 | \(-1.8042\) | \(+0.0630\) | yes |

The form can be negative, positive, or mixed depending on the two states.
It is **not** nonnegative in general.

## 3. Why

The modular theorem used

\[
B_\varphi(a,a)
=\operatorname{Re}\operatorname{Tr}\bigl(\rho_\varphi a^*[-\log\rho_\varphi,a]\bigr)
\ge0.
\]

For the relative form,

\[
B_{\varphi|\psi}
=B_\varphi-\operatorname{Re}\operatorname{Tr}\bigl(\rho_\varphi a^*[\log\rho_\psi,a]\bigr).
\]

The second term is evaluated with \(\varphi\), not \(\psi\), so it is not
\(-B_\psi\).  There is no reason for the difference to be nonnegative, and
numerically it is not.

## 4. Symmetrization does not fix it

A natural repair is the symmetrized form

\[
B_{\text{sym}}(a,a)
=\tfrac12\bigl(B_{\varphi|\psi}(a,a)+B_{\psi|\varphi}(a,a)\bigr).
\]

Numerically:

- \(n=2\): nonpositive for the tested seeds;
- \(n=3\): positive values appear, up to \(+0.0343\);
- \(n=4\): positive values up to \(+0.1084\).

So the symmetrized form is **also indefinite**.  Symmetrization does not
restore the Hodge-index sign.  Both the naive and the symmetrized relative
forms are ruled out as renormalizations.

## 5. Consequence

The naive relative renormalization does **not** solve the uniform-bound
problem of [`35-uniform-bound.md`](35-uniform-bound.md):

- it removes the divergent absolute normalization,
- but it loses the Hodge-index sign.

A successful renormalization must preserve positivity, for example a
symmetrized relative form or a Connes–Consani critical weight with a
positivity theorem.  Neither is constructed here.

This is a precise obstruction, not a no-go for every renormalization.

## 6. Numerical check

[`../python/relative_form.py`](../python/relative_form.py) computes the
relative form and its sign.  The tests in
[`../tests/test_relative_form.py`](../tests/test_relative_form.py) assert the
negative, positive, and mixed cases.

No RH proof is claimed yet.

[Back to the dossier](../README.md) · [Research journal](../research-journal.md) ·
[The uniform bound fails](35-uniform-bound.md)
