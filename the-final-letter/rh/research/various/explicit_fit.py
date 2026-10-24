from mpmath import mp, mpf, pi, log, sqrt, digamma, cos, quad, exp
mp.dps=25
NZ=300
gammas=[float(zetazero(k).imag) for k in range(1,NZ+1)] if False else None
from mpmath import zetazero
gammas=[float(zetazero(k).imag) for k in range(1,NZ+1)]
print("psi real part sample:", [round(float(mp.re(digamma(mpf(1)/4+1j*r/2))).real,3) for r in [0,5,14.13,50]])

def make(L):
    gh=lambda r: (L*2*(1-cos(L*r))/((L*r)**2)) if abs(r)>1e-14 else L
    return gh
def lam_sieve(N):
    lp=[0]*(N+1)
    for i in range(2,N+1):
        if lp[i]==0:
            for j in range(i,N+1,i):
                if lp[j]==0: lp[j]=i
    lam=[0.0]*(N+1)
    for n in range(2,N+1):
        p=lp[n]; m=n
        while m%p==0: m//=p
        if m==1: lam[n]=log(p)
    return lam

rows=[]
for L in [1.0,1.5,2.0,2.5]:
    gh=make(L); nmax=int(exp(L))+2; lam=lam_sieve(nmax)
    P=float(sum(lam[n]/sqrt(n)*(1-abs(log(n))/L) for n in range(2,nmax+1)))
    Z=float(sum(gh(g) for g in gammas))
    A=float(quad(lambda r: float(gh(r))*(mp.re(digamma(mpf(1)/4+1j*r/2))+mp.re(digamma(mpf(1)/4-1j*r/2))),[-80,-1,0,1,80]))
    G0=float(gh(0))
    rows.append((L,Z,A,P,G0))
    print(f"L={L}: Z={Z:.6f} A={A:.6f} P={P:.6f} ghat(0)={G0:.4f}  P/Z={P/Z:.4f} A/Z={A/Z:.4f}")

# least squares: find (alpha,beta,gamma) with Z = alpha*A + beta*P + gamma*G0
import numpy as np
M=np.array([[r[2],r[3],r[4]] for r in rows]); z=np.array([r[1] for r in rows])
coef,res,rank,sv=np.linalg.lstsq(M,z,rcond=None)
pred=M@coef
print("\nbest fit Z = %.6f*A + %.6f*P + %.6f*ghat(0)"%tuple(coef))
print("   residuals:", [f"{p-z_:.2e}" for p,z_ in zip(pred,z)])
print("   relative:", [f"{abs(p-z_)/abs(z_):.2e}" for p,z_ in zip(pred,z)])
print("\n   candidate identifications: 1/(2pi)=",1/(2*pi),"  1/pi=",1/pi,"  1=",1.0,"  2=",2.0,"  1/4=",0.25)
print("   alpha*2pi =",coef[0]*2*pi,"  beta =",coef[1],"  gamma =",coef[2])
