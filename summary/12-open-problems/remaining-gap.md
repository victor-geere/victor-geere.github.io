# The remaining gap

**Sources:** [`truths.md`](truths.md) §15; [`tensor.md`](tensor.md) §6; [`gaps.html`](gaps.html), “The remaining gap, collapsed” and “Where that equation sits”; [`publication.html`](publication.html) §14.

The paper does not leave the gap vague. It writes the same open statement in four coordinates and proves that they are the same statement. None of them is decided.

## 1. The cosine moment

Riemann’s even positive kernel $\Phi$ satisfies

$$
\Xi_{\cos}(t):=\Xi(\tfrac12+it)=c\int_0^\infty\Phi(u)\cos(tu)\,du,
\qquad c=4
$$

for the $\Phi$ printed in truths 12.1 (the constant is fixed in `tensor.md` Lemma 2.2). Write an off-line zero as $t=\gamma-i\alpha$ with $\alpha=\sigma-\tfrac12\neq0$. Evenness of $\Phi$ gives

$$
\Xi_{\cos}(\gamma-i\alpha)
=c\int_0^\infty\Phi(u)\cosh(\alpha u)\cos(\gamma u)\,du.
$$

So an off-line zero forces the **cosine moment**

$$
K(\alpha,\gamma)=\int_0^\infty\Phi(u)\cosh(\alpha u)\cos(\gamma u)\,du
$$

to vanish. The converse is not true: the full zero condition is the joint vanishing of $K$ and its sine partner

$$
S(\alpha,\gamma)=\int_0^\infty\Phi(u)\sinh(\alpha u)\sin(\gamma u)\,du.
$$

`tensor.md` proves the exact identification

$$
K(\alpha,\gamma)=\tfrac14\operatorname{Re}\xi(\tfrac12+\alpha+i\gamma),
\qquad
S(\alpha,\gamma)=\tfrac14\operatorname{Im}\xi(\tfrac12+\alpha+i\gamma).
$$

Hence the remaining statement is:

> For every $\alpha\neq0$ and every real $\gamma$, the two real curves $K(\alpha,\gamma)=0$ and $S(\alpha,\gamma)=0$ do not meet.

That is RH, undisguised: $K$ and $S$ are $\operatorname{Re}\xi$ and $\operatorname{Im}\xi$.

## 2. What is already solved

- **The $\gamma=0$ slice.** $K(\alpha,0)=\int\Phi\cosh(\alpha u)\,du>0$ for every real $\alpha$, because the integrand is positive. In the $s$-plane this is $\Xi(\sigma)\neq0$ for real $\sigma$.
- **The $\alpha=0$ slice.** $K(0,\gamma)$ is a constant multiple of $\Xi_{\cos}(\gamma)$; it vanishes at the on-line zeros, as it should.
- **$L^2$ positivity.** Parseval gives $\int K(\alpha,\gamma)^2d\gamma\asymp\int\Phi^2\cosh^2(\alpha u)\,du>0$. This is an envelope, not a pointwise sign law; it does not prevent zeros.
- **The unique self-dual scale.** The three scales $P_N,F_N,D_N$, the last chord $H_N(s)$, and the weight $\cosh(\alpha u)$ all single out $\sigma=\tfrac12$. That uniqueness is proved. It is not the statement that every zero lies there.

## 3. Why the naive sign law fails

Truths 15.3 proposed that killing off-line zeros at a fixed $\alpha$ is the assertion that $K(\alpha,\cdot)$ does not change sign. `tensor.md` Proposition 6.3 proves this is **false for every $\alpha$**:

- Near every simple on-line zero $\gamma_0$,
  $$
  K(\alpha,\gamma)=\tfrac14\Xi_{\cos}'(\gamma_0)(\gamma-\gamma_0)+O(\alpha^2+(\gamma-\gamma_0)^2),
  $$
  so $K$ changes sign essentially at $\gamma_0$ for every tilt $\alpha$, while $S(\alpha,\gamma_0)\approx-\tfrac14\Xi_{\cos}'(\gamma_0)\alpha\neq0$ keeps the joint system away from zero.
- Globally, $\arg\xi(\tfrac12+\alpha+it)=\tfrac t2\log\tfrac{t}{2\pi e}+O(\log t)$, so $\operatorname{Re}\xi$ and hence $K(\alpha,\cdot)$ has $\gg T\log T$ sign changes in $[T,2T]$.

The correct open statement is the joint non-vanishing above, not a one-dimensional sign law.

## 4. The Jensen/Li jet

The Taylor coefficients of the cosine transform at $t=0$ are the even moments

$$
m_{2k}=\int_0^\infty\Phi(u)u^{2k}\,du<\infty.
$$

The Jensen polynomials built from $(m_{2k})$ are real-rooted for every degree iff $\Xi_{\cos}$ lies in the Laguerre–Pólya class, which is equivalent to RH. The object that would kill off-line zeros is therefore the **hyperbolicity of the whole Jensen tower** of the moment sequence. Griffin–Ono–Rolen–Zagier prove hyperbolicity for each fixed degree at sufficiently large shift; uniformity in the degree is the full tower, and is not proved.

The same jet written where the filter $1-N^{1-s}$ dies is Li’s coefficients

$$
\lambda_n=\frac{1}{(n-1)!}\frac{d^n}{ds^n}\bigl[s^{n-1}\log\Xi(s)\bigr]_{s=1}.
$$

Bombieri–Lagarias: $\lambda_n\ge0$ for all $n$ iff RH. The functional equation identifies a neighbourhood of $s=1$ with one of $s=0$, and the completed factor identifies both with $t=0$ in the cosine picture. The Li jet and the Jensen jet are two coordinates of one object. The polygon can read the moments at $t=0$; it cannot read Li’s jet at $\sigma=1$.

## 5. The four equivalent writings

`truths.md` 13.4 records that the following name one and the same remaining statement:

1. A right-half atom of the unrestricted measure $\nu$.
2. A twin pair at which one last chord tends to $0$ and the other to $\infty$.
3. A non-real zero of the cosine transform of $\Phi$.
4. Failure of Weil positivity for some test function.

`tensor.md` adds a fifth, on $\mathbb{R}$: failure of positive type for the Weil current $\mathcal{W}$. With $\mathcal{W}$ in place of the naive current $\mathcal{P}$, the spectral resolution is exactly $\sum_\rho\delta_{\gamma_\rho}$, and positivity is RH.

## 6. The de Bruijn–Newman coordinate

Let $H_\tau(z)=\int_0^\infty e^{\tau u^2}\Phi(u)\cos(zu)\,du$, the backward heat flow of $\Xi$. De Bruijn showed $H_\tau$ has only real zeros for $\tau\ge\tfrac12$; Newman showed there is a constant $\Lambda$ with real zeros exactly for $\tau\ge\Lambda$; RH is $\Lambda\le0$. Rodgers–Tao proved $\Lambda\ge0$, and Polymath15 proved $\Lambda\le0.22$. Thus $0\le\Lambda\le0.22$, and RH is $\Lambda=0$. This is the sharpest known quantitative statement about the gap. It does not close it.

## Status

Everything in §§2–6 is either proved, cited, or an exact reformulation. The joint non-vanishing of $K$ and $S$ is open. The paper’s own rule applies: writing that non-vanishing as a theorem would be lying.

[Back to folder README](summary/12-open-problems/README.md) · [Back to the summary index](summary/README.md)
