from mpmath import mp, mpf, pi, log, sqrt, digamma, quad, exp, e, zetazero, nstr
mp.dps=25
T=mpf(300)
# Riemann-von Mangoldt main term
mainT = T/(2*pi)*log(T/(2*pi*e)) + mpf(7)/8
# exact count of zeros with 0<gamma<=T for T=300 : zetazero indices start at 1
k=1
while float(zetazero(k).imag)<=float(T): k+=1
Nexact=k-1
print("=== Riemann-von Mangoldt: NO PRIMES APPEAR ===")
print(f"  T=300 : exact zero count N(300) = {Nexact}")
print(f"  main term T/2pi log(T/2pi e) + 7/8 = {nstr(mainT,10)}")
print(f"  S(T) = N(T) - main = {Nexact-float(mainT):+.4f}")
print(f"  first zero gamma_1=14.1347 ; main term predicts first at "
      f"{nstr(2*pi/log(1/(2*pi*e)),6) if False else 'see below'}")
# invert main term to find gamma_1 prediction
from mpmath import findroot
f=lambda x: x/(2*pi)*log(x/(2*pi*e))+mpf(7)/8-1
print("  solving N(T)=1:", nstr(findroot(f, 14),8), " (actual 14.1347)")

print("\n=== explicit formula: zero side vs prime side, Gaussian R=4 ===")
NZ=300
gammas=[float(zetazero(j).imag) for j in range(1,NZ+1)]
import numpy as np, math
R=4.0
sh=lambda r: R*sqrt(2*pi)*e**(-(R*r)**2/2)
Z=float(sum(sh(g) for g in gammas))
print(f"  Z = sum_ghat(gamma), {NZ} zeros = {Z:.8f}")
# prime side
Nmax=10**7
spf=list(range(Nmax+1)); i=2
while i*i<=Nmax:
    if spf[i]==i:
        for j in range(i*i,Nmax+1,i):
            if spf[j]==j: spf[j]=i
    i+=1
nn=np.arange(Nmax+1,dtype=np.float64); nn[0]=1.0
ll=np.log(nn)
gv=np.exp(-ll**2/(2*R*R)); gv[0]=0.0
P=0.0
for n in range(2,Nmax+1):
    p=spf[n]; m=n
    while m%p==0: m//=p
    if m==1: P+=math.log(p)/math.sqrt(n)*gv[n]
print(f"  P = sum Lam(n) n^-1/2 g(log n), n<=1e7 = {P:.8f}")
A=float(quad(lambda r: float(sh(r))*(mp.re(digamma(mpf(1)/4+1j*r/2))+mp.re(digamma(mpf(1)/4-1j*r/2))),[-60,-1,0,1,60]))
print(f"  A = int ghat(r)[psi(1/4+ir/2)+psi(1/4-ir/2)]dr = {A:.8f}")
print(f"  Z-P = {Z-P:.8f} ; A/2 = {A/2:.8f} ; A/(2pi) = {A/(2*float(pi)):.8f}")
print(f"  Z - A/2 = {Z-A/2:.8f} ; (Z-A/2)/P = {(Z-A/2)/P:.8f}  (want -1 or -2 for a Weil-type identity)")
