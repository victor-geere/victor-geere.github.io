from fractions import Fraction as F
print("=== (4) 3-term unit-fraction decompositions of 1: algebraic, exact ===")
# 1/a+1/b+1/c=1, a<b<c  =>  c = ab/(ab-a-b); c>b requires b>2a/(a-2); c<3b/2
sols=[]; LIM=200000
a=2
while True:
    if F(1,a)*3>1: break   # need 1/a+1/b+1/c<=1 with b,c>a => 3/a>1 needed
    b=a+1
    while True:
        den= a*b-a-b
        if den<=0: b+=1; continue
        num=a*b
        if num%den==0:
            c=num//den
            if c>b: sols.append((a,b,c))
        # c>b  <=> num/den>b <=> ab > b(ab-a-b) <=> a > ab-a-b <=> b(a-1)>a
        if b*(a-1)>a and num%den==0: pass
        if F(1,a)+F(1,b)+F(1,b+1) < 1: break
        b+=1
        if b>LIM and F(1,a)+F(1,b)>1: break
        if b>LIM: break
    a+=1
print("  3-term solutions with a<b<c<=%d:"%LIM, sols)
print("  unique:",sols==[(2,3,6)])
# 4-term count
def four(lim):
    out=[]
    for a in range(2,lim):
        for b in range(a+1,lim):
            s=F(1,a)+F(1,b)
            if s>=1: break
            for c in range(b+1,lim):
                s2=s+F(1,c)
                if s2>=1: break
                rem=1-s2
                if rem.numerator==1 and rem.denominator>c and rem.denominator<=10**9:
                    out.append((a,b,c,rem.denominator))
    return out
f=four(60)
print("  4-term solutions with a,b,c<60:",len(f),"e.g.",f[:4])

print("\n=== (1) exact complexity of a finitely supported word ===")
def word_from_ones(ones,N):
    w=bytearray(N)
    for p in ones: w[p]=1
    return bytes(w)
def plist(ones,N,Lmax):
    w=word_from_ones(ones,N)
    out=[]
    for L in range(1,Lmax+1):
        s=set()
        for i in range(0,N-L+1):
            s.add(w[i:i+L])
        out.append(len(s))
    return out
cases={"1/pi":([2,13,607,845027],845027+20),
       "log2":([0,4,36,6069],6069+20),
       "sqrt2-1":([1,11,251,218199],218199+20),
       "e-2":([0,3,53,9997],9997+20)}
for nm,(ones,N) in cases.items():
    p=plist(ones,N,13)
    print(f"  {nm:9s} p(1..13) = {p}")
print("  mediator: 1/pi [2,3,4,5,6,7,8,9,10,11,12,14] p(11,12,13)=12,14,16")
print("\n  structural formula test: p(L) = L+1 + #{i<j: a_j-a_i<=L} (A's guess)")
for nm,(ones,N) in cases.items():
    for L in [11,12,13]:
        pairs=sum(1 for i in range(len(ones)) for j in range(i+1,len(ones)) if ones[j]-ones[i]<=L)
        print(f"   {nm:9s} L={L}: L+1+pairs={L+1+pairs}  measured={plist(ones,N,L)[-1]}")
