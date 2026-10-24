from mpmath import mp, mpf, pi, log, sqrt, digamma, cos, sin, quad, nstr, zetazero, exp
mp.dps=25
NZ=300
gammas=[float(zetazero(k).imag) for k in range(1,NZ+1)]
print("zeros loaded:",NZ," first:",gammas[0]," last:",gammas[-1])

def make(L):
    gh=lambda r: (L*2*(1-cos(L*r))/((L*r)**2)) if abs(r)>1e-14 else L
    return gh

def lam_sieve(N):
    lam=[0.0]*(N+1); lp=[0]*(N+1)
    for i in range(2,N+1):
        if lp[i]==0:
            for j in range(i,N+1,i):
                if lp[j]==0: lp[j]=i
    for n in range(2,N+1):
        p=lp[n]; m=n; k=0
        while m%p==0: m//=p; k+=1
        if m==1: lam[n]=log(p)
    return lam

for L in [1.0,1.5,2.0]:
    gh=make(L)
    nmax=int(exp(L))+2
    lam=lam_sieve(nmax)
    P=sum(lam[n]/sqrt(n)*(1-abs(log(n))/L) for n in range(2,nmax+1))
    Z=sum(gh(g) for g in gammas)
    # tail estimate: average of ghat^2 -> 2/(L r^2); sum over zeros beyond last with density log r/2pi
    r0=mpf(gammas[-1])
    tail=float(quad(lambda r: (2/(L*r*r))*(log(r)/(2*pi)), [r0, 4000]))
    A=quad(lambda r: float(gh(r))*(digamma(mpf(1)/4+1j*r/2)+digamma(mpf(1)/4-1j*r/2)).real,
           [-80,-1,0,1,80])
    print(f"\n=== L={L}  (n<= {nmax}) ===")
    print(f"  Z  = sum ghat(gamma)        = {float(Z):.8f}   (+tail {tail:.3e})")
    print(f"  A  = arch int               = {float(A):.8f}")
    print(f"  P  = sum Lam(n) n^-1/2 g    = {float(P):.8f}")
    for nm,val in [("A/2 - P", float(A)/2-float(P)), ("A - P", float(A)-float(P)),
                   ("A - 2P", float(A)-2*float(P)), ("(A/2 - 2P)", float(A)/2-2*float(P))]:
        if abs(val) > 1e-7:
            print(f"  Z/({nm:11s}) = {float(Z)/val:.6f}")
