# Numerical appendix

> Source: [`tensor.md`](../../geometric-dynamical-phase-transitions/tensor.md) §9. The script is the code block in the source.

## 9. Numerical appendix

Environment: Python 3 with mpmath 1.3.0, `mp.dps = 25`. Two structurally independent evaluations of \(\langle\mathcal{P},f_0*\check f_0\rangle\) (prime sum + \(\Phi\)-integral, with no zero data; versus Theorem A's pole/atoms/density, with no prime data) agree to \(6\times10^{-25}\). The zeros used are \(\gamma_1,\dots,\gamma_{12}\) from `mpmath.zetazero`; the tail beyond them contributes \(<10^{-400}\) to the atom sum for this witness, and hypothetical off-line zeros (which would have \(\lvert\operatorname{Re}\gamma_\rho\rvert>3\times10^{12}\), Platt–Trudgian) are annihilated by the Gaussian decay of \(\hat g_0\).

```python
# Numerical companion to tensor.md: verification of Theorems A and B,
# the normalisation \hat Phi = Xi/2, the tilt identities, and the
# failure of positive type for Phi.  Requires mpmath (tested: 1.3.0).
from mpmath import (mp, mpf, mpc, exp, cos, cosh, sin, sinh, sqrt, pi, log,
                    gamma, zeta, digamma, re, im, quad, zetazero, fabs)

mp.dps = 25
g1 = im(zetazero(1))                      # gamma_1 = 14.134725...
print("gamma_1 =", g1)

# ---- witness f0 and g0 = f0 * f0 ----
def f0(u):   return (2/sqrt(pi))*exp(-u**2)*cos(g1*u)
def fhat(z): return exp(-(z - g1)**2/4) + exp(-(z + g1)**2/4)
def ghat(z): return fhat(z)**2            # f0 real and even
def g0(v):   return sqrt(2/pi)*exp(-v**2/2)*(cos(g1*v) + exp(-g1**2/2))

conv = quad(lambda u: f0(u)*f0(mpf('0.7')-u), [-8, mpf('0.35'), 8])
print("closed form of g0: resid =", conv - g0(mpf('0.7')))

# ---- Pi(g0): sum over prime powers ----
X = 60000
sieve = bytearray([1])*(X+1); sieve[0] = sieve[1] = 0
for i in range(2, int(X**0.5)+1):
    if sieve[i]:
        for j in range(i*i, X+1, i): sieve[j] = 0
Pg = mpf(0)
for p in range(2, X+1):
    if sieve[p]:
        lp = log(p); pk = p
        while pk <= X:
            Pg += lp*g0(log(mpf(pk)))/sqrt(mpf(pk)); pk *= p
print("Pi(g0)    =", Pg)

# ---- Phi (truths.md 12.1) and Xi_cos ----
def Phi(u):
    u = fabs(u); e2u = exp(2*u); s = mpf(0)   # Phi is even (Jacobi)
    for n in range(1, 14):
        s += (2*pi**2*n**4*exp(mpf(9)*u/2) - 3*pi*n**2*exp(mpf(5)*u/2))*exp(-pi*n**2*e2u)
    return s
def Xi(t):
    s = mpc(mpf(1)/2, t)
    return re(mpf(1)/2*s*(s-1)*pi**(-s/2)*gamma(s/2)*zeta(s))

for t in [0, 3, 15]:                       # hatPhi(t) / Xi_cos(t) = 1/2
    hp = 2*quad(lambda u: Phi(u)*cos(t*u), [0, 1, 2, mpf('3.8')])
    print("t=%2s  hatPhi/Xi =" % t, hp/Xi(mpf(t)))

# ---- Theta(g0), two independent ways ----
pts = [0, 8, 11, mpf(g1), 17, 20, 26, 45]
Tg  = 2*quad(lambda u: Phi(u)*g0(u), [0, mpf('0.5'), 1, mpf('1.5'), 2, mpf('2.6'), mpf('3.8')])
TgP = (1/(2*pi))*quad(lambda t: Xi(t)*ghat(t), pts)
print("Theta(g0) =", Tg, "  Parseval resid =", Tg - TgP)

LHS = Pg + Tg
print("<P, f0*f0> =", LHS)

# ---- explicit-formula side (Theorem A) ----
def Om(t): return re(digamma(mpc(mpf(1)/4, t/2))) - log(pi)
pole  = re(ghat(mpc(0, mpf(1)/2)))         # |fhat(i/2)|^2
zsum  = sum(2*re(ghat(im(zetazero(k)))) for k in range(1, 13))
archW = (1/pi)*quad(lambda t: ghat(t)*(Xi(t)/2 + Om(t)/2), pts)
archO = (1/pi)*quad(lambda t: ghat(t)*Om(t), pts)
print("pole      =", pole)
print("atoms     =", -zsum/2)
print("density   =", archW)
print("Theorem A resid  =", LHS - (pole - zsum/2 + archW))
print("Lemma 2.4 resid  =", Pg - (2*pole - zsum + archO)/2)
print("W(0)      =", Xi(mpf(0))/2 + Om(mpf(0))/2)
print("hatPhi(15)=", Xi(mpf(15))/2)

# ---- tilt identities K, S = (1/4) Re, Im xi ----
def xi_s(s): return mpf(1)/2*s*(s-1)*pi**(-s/2)*gamma(s/2)*zeta(s)
for (a, gg) in [(mpf('0.1'), mpf(14)), (mpf('0.25'), mpf(2))]:
    K = quad(lambda u: Phi(u)*cosh(a*u)*cos(gg*u), [0, 1, 2, mpf('3.8')])
    S = quad(lambda u: Phi(u)*sinh(a*u)*sin(gg*u), [0, 1, 2, mpf('3.8')])
    v = xi_s(mpc(mpf(1)/2 + a, gg))
    print("K,S(%s,%s) resids =" % (a, gg), K - re(v)/4, S - im(v)/4)

# ---- sign changes of K(alpha, .) near gamma_1 ----
for a in ['0.1', '0.25']:
    for gg in ['14.0', '14.1', '14.2']:
        print("K(%s,%s) =" % (a, gg), re(xi_s(mpc(mpf(1)/2 + mpf(a), mpf(gg))))/4)

# ---- the kernel/tuple form: Phi is not of positive type ----
mp.dps = 15
delta = mpf('0.05'); M = 600               # u_j = j/20, |j| <= M
for th in [0, 15]:
    Q = sum((2*M+1-abs(d))*cos(mpf(th)*d*delta)*Phi(d*delta) for d in range(-80, 81))
    print("tuple form  theta=%2s :  Q = %s" % (th, Q))
```

Output, verbatim:

```text
gamma_1 = 14.13472514173469379045725
closed form of g0: resid = -1.292469707114105741986576e-26
Pi(g0)    = -0.6776451473031691521911752
t= 0  hatPhi/Xi = 0.5
t= 3  hatPhi/Xi = 0.5
t=15  hatPhi/Xi = 0.5
Theta(g0) = 0.0003426691864130141412320551   Parseval resid = 0.0
<P, f0*f0> = -0.6773024781167561380499432
pole      = 1.599008958749348880465888e-43
atoms     = -1.000000000050072433413045
density   = 0.3226975219333162953631013
Theorem A resid  = 5.94536065272488641313825e-25
Lemma 2.4 resid  = 5.94536065272488641313825e-25
W(0)      = -2.437531320518675736160092
hatPhi(15)= -0.0003528489794107737103153125
K,S(0.1,14.0) resids = -3.944304526105059027058643e-30 2.366582715663035416235186e-30
K,S(0.25,2.0) resids = 0.0 1.514612938024342666390519e-27
K(0.1,14.0) = 0.00004812761579292214804889591
K(0.1,14.1) = 0.00001019550231964752534767062
K(0.1,14.2) = -0.0000236369122442162997556447
K(0.25,14.0) = 0.00003661507924554092885701267
K(0.25,14.1) = -0.0000005603368740259796883543041
K(0.25,14.2) = -0.0000336673540507255384833635
tuple form  theta= 0 :  Q = 5953.27220454455
tuple form  theta=15 :  Q = -5.93840474582715
```

Error accounting. The prime-power tail beyond \(6\times10^4\) is \(<10^{-22}\) (bound in the proof of Theorem B); the atom tail beyond \(\gamma_{12}\) is \(<10^{-400}\); the \(5.0\times10^{-11}\) excess of the atom term over \(1\) is \(2\hat g_0(\gamma_2)=2e^{-(\gamma_2-\gamma_1)^2/2}(1+o(1))\), as it should be; all quadratures are adaptive at 25 significant digits and every quantity is confirmed by a second, independent route (convolution vs closed form; direct vs Parseval; direct vs explicit formula; \(K,S\) integrals vs \(\xi\)).

---

## References

- B. Riemann, *Über die Anzahl der Primzahlen unter einer gegebenen Grösse* (1859) — the \(\Xi\) integral representation.
- A. Weil, *Sur les "formules explicites" de la théorie des nombres premiers*, Comm. Sém. Math. Lund (1952) — the explicit-formula pairing and the positivity criterion.
- E. Bombieri, *Remarks on Weil's quadratic functional in the theory of the Riemann zeta-function*, Rend. Mat. Acc. Lincei (2000) — Theorem C(3) in full rigour.
- H. Davenport, *Multiplicative Number Theory*, §17 — the contour estimates in Lemma 2.4.
- E. C. Titchmarsh, *The Theory of the Riemann Zeta-Function*, §9.4 (argument bounds), §10.1 (the \(\Phi\) expansion); H. M. Edwards, *Riemann's Zeta Function*, §1.8.
- H. Iwaniec, E. Kowalski, *Analytic Number Theory*, ch. 5 — the explicit formula in the even normalisation used here.
- D. Platt, T. Trudgian, *The Riemann hypothesis is true up to \(3\cdot10^{12}\)*, Bull. LMS (2021) — used only in the error accounting of §9.
- truths.md §§12, 15; publication.html Lemma 7.2; tensor.html — the objects under examination.

*20 August 2026. Written as the resolution of the request to prove \((\star)\): it cannot be proved, because it is false; what is true in its place is Weil's criterion, and the distance between the two is measured exactly by Theorem A.*
