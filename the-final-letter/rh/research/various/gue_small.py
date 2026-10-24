import numpy as np, math
from mpmath import mp, mpf, pi, log, gamma, zeta, zetazero
mp.dps=20
def theta(t): return mp.im(mp.loggamma(mpf(1)/4+1j*t/2))-t/2*log(pi)
def Zf(t): return float((mp.e**(1j*theta(t))*zeta(mpf(1)/2+1j*t)).real)
print("RS check:",Zf(14.1347251417),Zf(100.0),flush=True)
T0,T1,step=1500.0,1800.0,0.1
ts=np.arange(T0,T1,step); zs=np.array([Zf(t) for t in ts]); print("scanned",len(ts),flush=True)
zrs=[]
for i in range(len(ts)-1):
    if zs[i]==0 or zs[i]*zs[i+1]<0:
        lo,hi=ts[i],ts[i+1]
        for _ in range(50):
            m=(lo+hi)/2
            if Zf(lo)*Zf(m)<=0: hi=m
            else: lo=m
        zrs.append((lo+hi)/2)
zrs=np.array(zrs); print("zeros found:",len(zrs),"range",zrs[0],zrs[-1],flush=True)
np.save('/Users/victor/workspace/rh/z1500_1800.npy',zrs)
def Nsm(t): return t/(2*math.pi)*math.log(t/(2*math.pi*math.e))+7/8
u=np.array([Nsm(t) for t in zrs]); sp=np.diff(u)
print("spacings: n=%d mean=%.4f var=%.4f"%(len(sp),sp.mean(),sp.var()))
emp,edges=np.histogram(sp,bins=np.arange(0,3.01,0.2),density=True); cent=0.5*(edges[:-1]+edges[1:])
gue=(32/np.pi**2)*cent**2*np.exp(-4*cent**2/np.pi); pois=np.exp(-cent)
print("  u    emp    GUE    Pois")
for i in range(len(cent)): print(f"  {cent[i]:.2f}  {emp[i]:.3f}  {gue[i]:.3f}  {pois[i]:.3f}")
print("max|emp-GUE|=%.4f  max|emp-Pois|=%.4f"%(np.max(np.abs(emp-gue)),np.max(np.abs(emp-pois))))
for s_ in [0.1,0.2,0.5,1.0]:
    print(f"P(sp<{s_}) emp={np.mean(sp<s_):.5f} GUE={float(1-np.exp(-4*s_**2/np.pi)):.5f} Pois={1-math.exp(-s_):.5f}")
