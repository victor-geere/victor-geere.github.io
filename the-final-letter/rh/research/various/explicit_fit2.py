from mpmath import mp, mpf, pi, log, sqrt, digamma, cos, quad, exp, zetazero
import numpy as np
mp.dps=25
NZ=300
gammas=[float(zetazero(k).imag) for k in range(1,NZ+1)]

def lam_sieve(N):
    """von Mangoldt: Lambda(n)=log p if n=p^k, else 0"""
    spf=list(range(N+1))
    i=2
    while i*i<=N:
        if spf[i]==i:
            for j in range(i*i,N+1,i):
                if spf[j]==j: spf[j]=i
        i+=1
    lam=[0.0]*(N+1)
    for n in range(2,N+1):
        p=spf[n]; m=n
        while m%p==0: m//=p
        if m==1: lam[n]=log(p)
    return lam
lam=lam_sieve(200)
print("Lambda check: L(2)=%.4f L(3)=%.4f L(4)=%.4f L(8)=%.4f L(6)=%.4f L(9)=%.4f  (log2=%.4f log3=%.4f)"
      %(lam[2],lam[3],lam[4],lam[8],lam[6],lam[9],log(2),log(3)))

def fit_for(L):
    gh=lambda r: (L*2*(1-cos(L*r))/((L*r)**2)) if abs(r)>1e-14 else L
    nmax=int(exp(L))+2; lamL=lam_sieve(max(nmax,200))
    P=float(sum(lamL[n]/sqrt(n)*(1-abs(log(n))/L) for n in range(2,nmax+1)))
    Z=float(sum(gh(g) for g in gammas))
    A=float(quad(lambda r: float(gh(r))*(mp.re(digamma(mpf(1)/4+1j*r/2))+mp.re(digamma(mpf(1)/4-1j*r/2))),[-80,-1,0,1,80]))
    return Z,A,P,float(gh(0))
rows=[fit_for(L) for L in [1.0,1.5,2.0,2.5,3.0]]
for L,(Z,A,P,G0) in zip([1.0,1.5,2.0,2.5,3.0],rows):
    print(f"L={L}: Z={Z:.6f}  A={A:.6f}  P={P:.6f}  P/Z={P/Z:+.4f}  A/Z={A/Z:+.2f}  A/(2pi*Z)={A/(2*float(pi)*Z):+.4f}")
M=np.array([[r[1],r[2],r[3]] for r in rows]); z=np.array([r[0] for r in rows])
coef,*_=np.linalg.lstsq(M,z,rcond=None)
print("\nfit Z = a*A + b*P + c*ghat(0):  a=%.6f b=%.6f c=%.6f"%(coef[0],coef[1],coef[2]))
print("a*2pi=%.6f  1/(2pi)=%.6f"%(coef[0]*2*float(pi),1/(2*float(pi))))
pred=M@coef; print("rel residuals:",[f"{abs(p-z_)/abs(z_):.2e}" for p,z_ in zip(pred,z)])
