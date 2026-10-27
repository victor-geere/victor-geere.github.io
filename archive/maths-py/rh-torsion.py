import numpy as np
import matplotlib.pyplot as plt
from scipy.interpolate import PchipInterpolator
from mpmath import zetazero, findroot, zeta, gamma, log, pi, arg

# ------- Riemann-Siegel theta (mpmath) --------
def theta_mp(t):
    return arg(pi**(-1j*t/2) * gamma(0.25 + 0.5j*t))

# ------- Compute first N zeros (using mpmath) --------
N = 50
gammas = [float(zetazero(n).imag) for n in range(1, N+1)]
print(f"First zero: {gammas[0]:.4f}, last: {gammas[-1]:.4f}")

# ------- Build phi(t) that makes zeros exactly at 2π n --------
phi_target = 2 * np.pi * np.arange(1, N+1)
# Use a smooth monotonic interpolator (Pchip)
phi_interp = PchipInterpolator(gammas, phi_target, extrapolate=False)

# ------- Define the curve and its derivatives --------
def phi_spl(t):
    # add linear extrapolation beyond last zero (with slight smoothing)
    return phi_interp(t)

# numerical derivatives (simple finite difference if needed, or use spline derivatives)
def phi_prime(t):
    return phi_interp.derivative()(t)

def phi_double(t):
    return phi_interp.derivative(2)(t)

def phi_triple(t):
    return phi_interp.derivative(3)(t)

# torsion formula (2)
def torsion(t):
    a = phi_prime(t)
    a2 = phi_double(t)
    a3 = phi_triple(t)
    num = a**5 - a**2 * a3 + 3 * a * a2**2
    den = a**4 + a2**2 + a**6
    return num / den

# ------- Plot helix and zeros --------
t_vals = np.linspace(gammas[0], gammas[-1], 2000)
phi_vals = phi_spl(t_vals)
x = np.cos(phi_vals)
y = np.sin(phi_vals)
z = t_vals

fig = plt.figure(figsize=(12,7))
ax = fig.add_subplot(111, projection='3d')
ax.plot(x, y, z, lw=0.6, color='steelblue', label='Helix $C(t)$')
# mark zeros
zero_phi = phi_spl(gammas)
ax.scatter(np.cos(zero_phi), np.sin(zero_phi), gammas,
           c='crimson', s=30, label='Zeta zeros')
# highlight the generator line
gen_t = np.linspace(gammas[0], gammas[-1], 50)
ax.plot(np.ones_like(gen_t), np.zeros_like(gen_t), gen_t,
        '--', lw=0.5, color='gray')
ax.set_xlabel('x'); ax.set_ylabel('y'); ax.set_zlabel('t')
ax.set_title('Zeta zeros aligned on the unit helix (one zero per turn)')
ax.legend()
plt.show()

# ------- Torsion plot --------
t_dense = np.linspace(gammas[0]+0.1, gammas[-1]-0.1, 1000)
tau_vals = [torsion(t) for t in t_dense]
plt.figure(figsize=(10,4))
plt.plot(t_dense, tau_vals, 'k', lw=0.8)
plt.xlabel('t')
plt.ylabel(r'$\tau(t)$')
plt.title('Torsion of the zero‑aligned helix')
plt.grid(alpha=0.3)
plt.show()