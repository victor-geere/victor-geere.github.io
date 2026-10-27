# Euler–Maclaurin decomposition and tail bound

**Status.** This is the human-readable proof of S1 and S2. The Lean
counterpart is [`../lean/EulerMaclaurin.lean`](../lean/EulerMaclaurin.lean),
which proves the finite identity, Fourier inversion, the Bernoulli supremum
bound, differentiability, the integral tail bound and the combined S1/S2
statement for `K ≥ 1` (T36–T43). The written argument below is retained as
commentary, not as the source of record. The elementary claims S3–S5 are
proved in [`../lean/SourceClaims.lean`](../lean/SourceClaims.lean).

We use the standard Bernoulli conventions
\[
B_0=1,\qquad B_1=-\tfrac12,\qquad B_{2j+1}=0\ (j\ge1),
\]
the Bernoulli polynomials \(B_n(x)=\sum_{k=0}^n \binom nk B_k x^{n-k}\), and
the periodic functions
\[
\tilde B_n(x)=B_n(\{x\})\quad (x\notin\mathbb Z),
\]
with any fixed value at the integers; changing the value at finitely many
points does not change an integral. Then
\[
B_n(0)=B_n(1)=B_n\quad(n\ge2),\qquad
B_n'(x)=nB_{n-1}(x),\qquad
\tilde B_n(x+1)=\tilde B_n(x).
\]

## Statement

Let \(a>0\), \(M\ge1\), \(b=a+M\), \(K\ge1\), and \(s=\sigma+it\) with
\(\sigma>0\) and \(s\ne1\). Put \((s)_n=s(s+1)\cdots(s+n-1)\), \((s)_0=1\).
Then
\[
\zeta(s,a)=\sum_{k=0}^{M-1}(a+k)^{-s}
+\frac{b^{1-s}}{s-1}+\frac{b^{-s}}2
+\sum_{j=1}^{K}\frac{B_{2j}}{(2j)!}(s)_{2j-1}b^{-s-2j+1}
+R_K(s),
\tag{S1}
\]
where
\[
R_K(s)=-\frac{(s)_{2K+1}}{(2K+1)!}
\int_0^\infty \tilde B_{2K+1}(x)\,(b+x)^{-s-2K-1}\,dx,
\]
and
\[
|R_K(s)|\le \frac{|(s)_{2K+1}|}{(2K+1)!}\,
\|\tilde B_{2K+1}\|_\infty\,
\frac{b^{-\sigma-2K}}{\sigma+2K}.
\tag{1}
\]
Since
\[
\|\tilde B_{2K+1}\|_\infty
\le \frac{2(2K+1)!}{(2\pi)^{2K+1}}\zeta(2K+1),
\tag{2}
\]
one obtains the explicit source bound
\[
|R_K(s)|\le |(s)_{2K+1}|\,
\frac{2\zeta(2K+1)}{(2\pi)^{2K+1}}\,
\frac{b^{-\sigma-2K}}{\sigma+2K}.
\tag{S2}
\]
Using \(\zeta(m)\le1+1/(m-1)\) for \(m\ge2\) gives the rational input used by
the Python evaluator. (The zeta bound follows from
\(\zeta(m)=1+\sum_{n\ge2}n^{-m}\le1+\int_1^\infty x^{-m}\,dx=1+1/(m-1)\).)
\[
|R_K(s)|\le |(s)_{2K+1}|\,
\frac{2\bigl(1+\frac1{2K}\bigr)}{(2\pi)^{2K+1}}\,
\frac{b^{-\sigma-2K}}{\sigma+2K}.
\tag{3}
\]

## 1. The finite Euler–Maclaurin formula

Let \(f\in C^{2K+1}([M,N])\). We first prove the standard form
\[
\sum_{k=M}^{N} f(k)
=\int_M^N f(x)\,dx+\frac{f(M)+f(N)}2
+\sum_{j=1}^{K}\frac{B_{2j}}{(2j)!}
\left(f^{(2j-1)}(N)-f^{(2j-1)}(M)\right)
+\frac{1}{(2K+1)!}\int_M^N \tilde B_{2K+1}(x)f^{(2K+1)}(x)\,dx.
\tag{4}
\]
The sum \(\sum_{k=M}^{N-1}\) is obtained by subtracting \(f(N)\).

For \(x\in[k,k+1]\), \(\tilde B_1(x)=x-k-\tfrac12\). Integration by parts on
\([k,k+1]\) gives
\[
\int_k^{k+1} f(x)\,dx
=\frac{f(k)+f(k+1)}2
-\int_k^{k+1}\tilde B_1(x)f'(x)\,dx.
\]
Summing over \(k=M,\dots,N-1\), the interior values occur once and the
endpoints occur with coefficient \(\tfrac12\); adding the endpoint values
\(f(M)\) and \(f(N)\) gives
\[
\sum_{k=M}^{N}f(k)
=\int_M^N f(x)\,dx+\frac{f(M)+f(N)}2
+\int_M^N \tilde B_1(x)f'(x)\,dx.
\tag{5}
\]

For \(n\ge1\), put
\[
I_n=\int_M^N \tilde B_n(x)f^{(n)}(x)\,dx.
\]
Since \(\tilde B_n=\frac{1}{n+1}\tilde B_{n+1}'\), integration by parts gives
\[
I_n=\frac{1}{n+1}\left(
B_{n+1}\bigl(f^{(n)}(N)-f^{(n)}(M)\bigr)-I_{n+1}
\right).
\tag{6}
\]
Here we used \(\tilde B_{n+1}(M)=\tilde B_{n+1}(N)=B_{n+1}\) for \(n+1\ge2\);
for \(n+1=1\) the first step (5) is used instead.

Starting from (5), apply (6) successively for \(n=1,2,\dots,2K-1\). Using
\(B_{2j+1}=0\) for \(j\ge1\), the boundary terms at odd indices vanish. The
coefficients accumulate as
\[
\frac1{2\cdot3\cdots(2j)}=\frac1{(2j)!},
\]
and the signs combine so that the remainder enters with a plus sign. This leaves
the boundary terms through \(B_{2K}\) and the integral \(I_{2K}\). One further
integration by parts with \(B_{2K+1}=0\) leaves
\[
\frac{1}{(2K+1)!}\int_M^N \tilde B_{2K+1}(x)f^{(2K+1)}(x)\,dx.
\]
This is exactly (4). (For \(K=1\), the formula reads
\(\sum f=\int f+\frac{f(M)+f(N)}2+\frac{B_2}{2!}(f'(N)-f'(M))
+\frac1{3!}\int \tilde B_3 f'''\), which is the first step above followed by
two integrations by parts.)

## 2. Passing to the Hurwitz zeta

Take \(f(x)=(a+x)^{-s}\). For \(\sigma>1\), the series
\(\sum_{k=M}^{\infty}f(k)\) converges absolutely, and
\[
\zeta(s,a)=\sum_{k=0}^{M-1}(a+k)^{-s}+\sum_{k=M}^{\infty}(a+k)^{-s}.
\]
Apply (4) on \([M,N]\) to the sum \(\sum_{k=M}^{N}\), then subtract
\(f(N)\). For \(r\ge0\),
\[
f^{(r)}(x)=(-1)^r(s)_r(a+x)^{-s-r},
\]
so \(f^{(r)}(N)\to0\) as \(N\to\infty\) because \(\sigma+r>0\). Also
\[
\int_M^\infty (a+x)^{-s}\,dx=\frac{b^{1-s}}{s-1},
\qquad
-f^{(2j-1)}(M)=(s)_{2j-1}b^{-s-2j+1},
\]
and
\[
f^{(2K+1)}(x)=-(s)_{2K+1}(a+x)^{-s-2K-1}.
\]
Letting \(N\to\infty\) in (4) gives (S1) with the stated \(R_K(s)\); the
subtracted endpoint \(f(N)\) tends to \(0\).

The same formula holds for \(0<\sigma\le1\), \(s\ne1\), by analytic
continuation. Indeed, the finite sum, the pole term
\(b^{1-s}/(s-1)\), and the Bernoulli terms are meromorphic on
\(\{\sigma>0\}\), with the only possible pole at \(s=1\). The integral
defining \(R_K(s)\) converges absolutely and locally uniformly on
\(\{\sigma>0\}\), because
\[
|(b+x)^{-s-2K-1}|=(b+x)^{-\sigma-2K-1}
\]
and \(\sigma+2K+1>1\). Hence the right-hand side of (S1) is analytic on
\(\{\sigma>0\}\setminus\{1\}\). It agrees with the Hurwitz zeta on
\(\{\sigma>1\}\), so by the identity theorem it agrees on the whole
half-plane. This proves S1 in the stated domain.

## 3. The Fourier bound for the periodic Bernoulli functions

For \(n\ge2\) and \(m\ne0\), let
\[
\widehat B_n(m)=\int_0^1 B_n(x)e^{-2\pi i m x}\,dx.
\]
Since \(B_n(0)=B_n(1)\), integration by parts and \(B_n'=nB_{n-1}\) give
\[
\widehat B_n(m)=\frac{n}{2\pi i m}\,\widehat B_{n-1}(m).
\]
For \(n=1\),
\[
\widehat B_1(m)=\int_0^1\left(x-\frac12\right)e^{-2\pi i m x}\,dx
=-\frac1{2\pi i m}.
\]
Iterating,
\[
\widehat B_n(m)=-\frac{n!}{(2\pi i m)^n}\qquad(n\ge2,\ m\ne0).
\tag{7}
\]
The function \(\tilde B_n\) is piecewise polynomial, hence piecewise \(C^1\), and
periodic. Dirichlet's theorem for piecewise \(C^1\) periodic functions therefore
gives pointwise convergence of its Fourier series at every non-integer \(x\):
\[
\tilde B_n(x)=-\frac{n!}{(2\pi i)^n}\sum_{m\ne0}\frac{e^{2\pi i m x}}{m^n}.
\tag{8}
\]
For \(n=2K+1\) odd, pairing \(m\) and \(-m\) turns (8) into a sine series; in
absolute value,
\[
|\tilde B_{2K+1}(x)|
\le \frac{(2K+1)!}{(2\pi)^{2K+1}}
\sum_{m\ne0}\frac1{|m|^{2K+1}}
=\frac{(2K+1)!}{(2\pi)^{2K+1}}\,2\zeta(2K+1).
\]
This is (2).

## 4. The tail bound

From the integral formula for \(R_K\),
\[
|R_K(s)|
\le \frac{|(s)_{2K+1}|}{(2K+1)!}\,
\|\tilde B_{2K+1}\|_\infty
\int_0^\infty (b+x)^{-\sigma-2K-1}\,dx.
\]
The integral is
\[
\int_0^\infty (b+x)^{-\sigma-2K-1}\,dx
=\frac{b^{-\sigma-2K}}{\sigma+2K},
\]
because \(\sigma+2K>0\). This gives (1). Substituting (2) gives (S2), and
using \(\zeta(2K+1)\le1+1/(2K)\) gives (3).

## 5. What is and is not proved

The argument proves S1 and S2 as ordinary mathematical theorems under the
stated hypotheses: \(a>0\), \(M\ge1\), \(K\ge1\), \(\sigma>0\), \(s\ne1\).
The proof uses the standard theory of Bernoulli polynomials, periodic
Bernoulli functions and their Fourier series, and the analytic continuation
of the Hurwitz zeta function.

It is **not** a Lean proof. The remaining Lean formalisation would need, at
minimum:

1. Bernoulli polynomials and the periodic functions \(\tilde B_n\), with the
   derivative and periodicity identities;
2. the finite Euler–Maclaurin formula (4) for \(C^{2K+1}\) functions,
   including the integration-by-parts induction;
3. the Fourier coefficients (7), Fourier inversion for piecewise \(C^1\)
   periodic functions, and the absolute bound (2);
4. a non-periodic Hurwitz zeta function on \(a>0\) (Mathlib's
   `HurwitzZeta.hurwitzZeta` is periodic in \(a\)) and the identity theorem
   step.

Items 1–3 are the substantive formalisation; item 4 is the definition choice.
All four are now in place in `EulerMaclaurin.lean`, and S1–S2 are Lean theorems
for `K ≥ 1` (T42–T43). What remains is the replay wiring recorded as R13, not
the analytic content.

[Back to the dossier](../README.md)
