from mpmath import mp, mpf, pi, log, sqrt, digamma, quad, exp, e, zetazero
import numpy as np, math
mp.dps=30
NZ=300
gammas=[float(zetazero(k).imag) for k in range(1,NZ+1)]

def lam_sieve(N):
    spf=list(range(N+1)); i=2
    while i*i<=N:
        if spf[i]==i:
            for j in range(i*i,N+1,i):
                if spf[j]==j: spf[j]=i
        i+=1
    lam=np.zeros(N+1)
    for n in range(2,N+1):
        p=spf[n]; m=n
        while m%p==0: m//=p
        if m==1: lam[n]=math.log(p)
    return lam
Nmax=10**7
lam=lam_sieve(Nmax)
nn=np.arange(Nmax+1,dtype=np.float64); nn[0]=1.0
logn=np.log(nn)

print(f"{'R':>5} {'Z':>16} {'A':>14} {'P':>12} {'Z-P':>12} {'Z/(A/2+P)':>12} {'Z/(A/4+P)':>12}")
for R in [4.0,6.0,8.0,10.0]:
    sh=lambda r: R*sqrt(2*pi)*e**(-(R*r)**2/2)
    Z=float(sum(sh(g) for g in gammas))
    gvals=np.exp(-logn**2/(2*R*R)); gvals[0]=0.0
    P=float(np.sum(np.where(lam>0, lam/np.sqrt(nn)*gvals, 0.0)))
    A=float(quad(lambda r: float(sh(r))*(mp.re(digamma(mpf(1)/4+1j*r/2))+mp.re(digamma(mpf(1)/4-1j*r/2))),[-60,-1,0,1,60]))
    print(f"{R:>5} {Z:>16.8f} {A:>14.6f} {P:>12.6f} {Z-P:>12.6f} "
          f"{Z/(A/2+P) if abs(A/2+P)>1e-9 else float('nan'):>12.6f} "
          f"{Z/(A/4+P) if abs(A/4+P)>1e-9 else float('nan'):>12.6f}")
print()
print("candidates: 1/(2pi)=0.159155, 1/pi=0.318310, 1, 2, 1/(4pi)=0.079577")
