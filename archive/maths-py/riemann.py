import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
from mpmath import zeta, mpc
import warnings
warnings.filterwarnings("ignore")

# =============================================================================
#  Riemann Helix vs Twin Zero-Cones in Euclidean Geometric Space
# =============================================================================

t_min, t_max = 0.0, 60.0
n_points = 1500
t = np.linspace(t_min, t_max, n_points)

# First 5 imaginary parts of zeros
gamma_list = np.array([14.134725, 21.022040, 25.010858, 30.424876, 32.935062])

# =============================================================================
# Compute Riemann helix ζ(1/2 + i t)
# =============================================================================
print("Computing Riemann helix ζ(1/2 + i t) ...")
re_zeta = np.zeros_like(t, dtype=float)
im_zeta = np.zeros_like(t, dtype=float)
for i, tt in enumerate(t):
    z = zeta(mpc(0.5, tt))
    re_zeta[i] = float(z.real)
    im_zeta[i] = float(z.imag)

# =============================================================================
# Create figure
# =============================================================================
fig = plt.figure(figsize=(14, 10))
ax = fig.add_subplot(111, projection='3d')

# Riemann helix (blue ribbon)
ax.plot(t, re_zeta, im_zeta, color='blue', linewidth=2.8, label='Riemann helix ζ(1/2 + it)')

# Twin zero-cones
colors = ['darkorange', 'forestgreen', 'crimson', 'purple', 'teal']
for idx, gamma in enumerate(gamma_list):
    r = np.exp(t / 2) / np.sqrt(0.25 + gamma**2)          # conical envelope
    
    # Positive rotation
    v_pos = r * np.cos(gamma * t)
    w_pos = r * np.sin(gamma * t)
    ax.plot(t, v_pos, w_pos, color=colors[idx], linestyle='-', linewidth=1.4,
            label=f'γ≈{gamma:.2f} (pos)')
    
    # Negative rotation (mirror)
    w_neg = -r * np.sin(gamma * t)
    ax.plot(t, v_pos, w_neg, color=colors[idx], linestyle='--', linewidth=1.4,
            label=f'γ≈{gamma:.2f} (neg)')

# Intersection points (red dots)
intersections = []
for gamma in gamma_list:
    m_max = int(np.ceil(t_max * gamma / np.pi)) + 1
    for m in range(-m_max, m_max + 1):
        tm = m * np.pi / gamma
        if t_min <= tm <= t_max:
            r = np.exp(tm / 2) / np.sqrt(0.25 + gamma**2)
            v = r * np.cos(gamma * tm)   # w = 0 at intersections
            intersections.append([tm, v, 0.0])

intersections = np.array(intersections)
if len(intersections) > 0:
    ax.scatter(intersections[:,0], intersections[:,1], intersections[:,2],
               color='red', s=18, zorder=10, label='Twin-cone intersections (w=0)')

# =============================================================================
# Styling
# =============================================================================
ax.set_xlabel('t = ln x   (arithmetic generator axis)', fontsize=13)
ax.set_ylabel('v (real part)', fontsize=13)
ax.set_zlabel('w (imag part)', fontsize=13)
ax.set_title('Riemann Helix vs Twin Zero-Cones\n'
             'Zero Density Encoded in Variable-Pitch Ribbon + Quadratic Intersection Lattice',
             fontsize=15, pad=25)

ax.legend(loc='upper left', fontsize=10, bbox_to_anchor=(1.05, 1.0))
ax.grid(True, alpha=0.25)

plt.tight_layout()
plt.show()

print("Visualization complete!")