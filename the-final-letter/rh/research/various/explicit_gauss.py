from mpmath import mp, mpf, pi, log, sqrt, digamma, quad, exp, e, zetazero
import numpy as np, math
mp.dps=25
NZ=300
gammas=[float(zetazero(k).imag) for k in range(1,NZ+1)]
R=0.5
gh=lambda r: R*sqrt(2*pi)*e**(-(R*r)**2/2)
# verify FT convention: g(u)=e^{-u^2/(2R^2)}; ghat(r)=int g e^{iru}=R sqrt(2pi) e^{-R^2r^2/2}
print("FT check: ghat(0)=%.6f  R*sqrt(2pi)=%.6f"%(float(gh(0)),float(R*sqrt(2*pi))))
print("ghat at first zero: %.6e"%(float(gh(gammas[0]))))
Z=float(sum(gh(g) for g in gammas))
print("Z = sum ghat(gamma) over %d zeros = %.10f"%(NZ,Z))

# archimedean term
V=lambda r: mp.re(digamma(mpf(1)/4+1j*r/2))+mp.re(digamma(mpf(1)/4-1j*r/2))
A=float(quad(lambda r: float(gh(r))*V(r), [-40,-1,0,1,40]))
print("A = int ghat(r)[psi(1/4+ir/2)+psi(1/4-ir/2)]dr = %.10f"%A)
print("A/2 = %.10f ; A/(2pi)=%.10f"%(A/2,A/(2*float(pi))))

# prime side up to Nmax
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
Nmax=2*10**6
lam=lam_sieve(Nmax)
n=np.arange(Nmax+1,dtype=np.float64); n[1:]=np.arange(1,Nmax+1)
gvals=np.where(n>=1, np.exp(-(np.log(np.maximum(n,1.0)))**2/(2*R*R)), 0.0)
term=np.where(lam>0, lam/np.sqrt(np.maximum(n,1.0))*gvals, 0.0)
P=float(term[2:].sum())
print("P = sum_{2<=n<=2e6} Lam(n) n^-1/2 g(log n) = %.10f"%P)
# tail estimate for prime side
print("   crude tail scale: Lambda(n)n^-1/2 g(log n) ~ log n * n^-1/2 * exp(-(log n)^2/2R^2); negligible past 2e6")
print()
print("Z - P = %.6f"%(Z-P))
print("A/2 + P = %.6f"%(A/2+P))
print("A + P  = %.6f"%(A+P))
print("Z + P  = %.6f ; Z - A/2 = %.6f"%(Z+P, Z-A/2))
for nm,val in [("A/2+P",A/2+P),("A+P",A+P),("(A/2+P)/2",(A/2+P)/2)]:
    if abs(val)>1e-9: print("   Z/(%s) = %.8f"%(nm, Z/val))
