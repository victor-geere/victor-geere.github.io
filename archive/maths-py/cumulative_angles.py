import streamlit as st
import numpy as np
import matplotlib.pyplot as plt
import plotly.graph_objects as go

st.set_page_config(layout="wide")
st.title("Cumulative Unwrapped Phase of Dirichlet Eta Terms")
st.markdown(r"""
Each iota term is $v_n = (-1)^{n-1} n^{-s}$.
The **cumulative turning angle** $\Theta_n$ tracks how much the direction
of the spiral has rotated from the positive real axis up to step $n$.

At each step the incremental turning $\delta_n$ is the signed angle between
successive chords $v_n - v_{n-1}$ and $v_{n-1} - v_{n-2}$.
The cumulative angle is $\Theta_n = \sum_{k=3}^{n}\delta_k$, which grows
monotonically when the spiral consistently winds in one direction.
""")

# Sidebar controls
st.sidebar.header("Parameters")
sigma = st.sidebar.slider(r"$\sigma$ (real part)", min_value=0.0, max_value=1.0, value=0.5, step=0.01)
t = st.sidebar.slider("$t$ (imaginary part)", min_value=0.0, max_value=50.0, value=14.13, step=0.01, format="%.2f")
N_start = st.sidebar.slider("Start $N$", min_value=1, max_value=1998, value=1, step=1)
N_end = st.sidebar.slider("End $N$", min_value=N_start + 2, max_value=2000, value=max(N_start + 2, 200), step=1)

N = N_end  # total terms to compute (always from 1)

# Compute iota terms from 1..N
n_all = np.arange(1, N + 1)
r_n = n_all ** (-sigma)
Phi_n = np.pi * (n_all - 1) - t * np.log(n_all)
v_n = r_n * np.exp(1j * Phi_n)

# Compute successive chord vectors: c_k = v_k - v_{k-1}, for k >= 2
chords = np.diff(v_n)  # length N-1, chords[0] = v_2 - v_1

# Incremental turning angle between consecutive chords
chord_ratios = chords[1:] / chords[:-1]  # length N-2
delta = np.angle(chord_ratios)  # signed incremental turns, length N-2

# Cumulative turning angle
Theta = np.cumsum(delta)
Theta_unwrapped = np.unwrap(Theta)

# Indices for cumulative angle: n = 3, 4, ..., N
n_theta = n_all[2:]

# Slice to user-selected range
mask = (n_theta >= N_start) & (n_theta <= N_end)
n_view = n_theta[mask]
Theta_view = Theta_unwrapped[mask]

# Also slice iota points for spiral plot
mask_v = (n_all >= N_start) & (n_all <= N_end)
n_v = n_all[mask_v]
v_view = v_n[mask_v]

# Wrapped phase for histogram
if len(Theta_view) > 0:
    wrapped = (Theta_view % (2 * np.pi)) / (2 * np.pi)
else:
    wrapped = np.array([])

# Complex terms and partial sums
S_n = np.cumsum(v_n)

# -------------------- Single Column Layout --------------------
st.subheader("Cumulative Turning Angle")
fig1, ax1 = plt.subplots(figsize=(10, 5))
if len(n_view) > 0:
    sc = ax1.scatter(n_view, Theta_view, c=n_view, cmap='viridis', s=8, edgecolors='none')
    ax1.plot(n_view, Theta_view, 'k-', lw=0.5, alpha=0.5)
    plt.colorbar(sc, ax=ax1, label='n')

# Add rotated copies for n < 10 (only those present in n_theta, i.e., n >= 3)
early_mask = n_theta < 10
early_n = n_theta[early_mask]
early_Theta = Theta_unwrapped[early_mask]
for n_val, theta_val in zip(early_n, early_Theta):
    ax1.scatter(n_val, theta_val, color='black', s=30, zorder=5)
    for k in range(-5, 6):
        ax1.scatter(n_val, theta_val + k * 2 * np.pi, 
                    color='gray', s=15, alpha=0.3, zorder=4)

ax1.set_xlabel("n")
ax1.set_ylabel(r"$\Theta_n$ (radians)")
ax1.set_title(f"Cumulative turning angle (n = {N_start}..{N_end})\nEarly terms (n<10) shown with ±5×2π rotations")
ax1.grid(True, alpha=0.3)
st.pyplot(fig1)

st.subheader("Cumulative Turning Angle by Parity")
fig1b, ax1b = plt.subplots(figsize=(10, 5))
# Separate odd and even n in the view range
odd_mask = (n_view % 2 == 1)
even_mask = (n_view % 2 == 0)
# Plot combined data lightly for reference
ax1b.plot(n_view, Theta_view, 'k-', lw=0.5, alpha=0.2, label='All n')
# Plot odd n
ax1b.scatter(n_view[odd_mask], Theta_view[odd_mask], 
             c='blue', s=10, alpha=0.8, label='Odd n')
ax1b.plot(n_view[odd_mask], Theta_view[odd_mask], 'b-', lw=0.8, alpha=0.6)
# Plot even n
ax1b.scatter(n_view[even_mask], Theta_view[even_mask], 
             c='red', s=10, alpha=0.8, label='Even n')
ax1b.plot(n_view[even_mask], Theta_view[even_mask], 'r-', lw=0.8, alpha=0.6)
ax1b.set_xlabel("n")
ax1b.set_ylabel(r"$\Theta_n$ (radians)")
ax1b.set_title(f"Cumulative turning angle separated by parity (n = {N_start}..{N_end})")
ax1b.legend()
ax1b.grid(True, alpha=0.3)
st.pyplot(fig1b)

st.subheader("Turning Angle Distribution (mod 2π)")
fig2, ax2 = plt.subplots(figsize=(10, 4))
if len(wrapped) > 0:
    ax2.hist(wrapped, bins=40, density=True, alpha=0.7, color='steelblue', edgecolor='white')
ax2.axhline(1.0, color='red', linestyle='--', label='Uniform')
ax2.set_xlabel(r"$\Theta_n / (2\pi)$ mod 1")
ax2.set_ylabel("Density")
ax2.legend()
st.pyplot(fig2)

st.subheader("3D Iota Spiral")
fig3d = go.Figure(data=[
    go.Scatter3d(
        x=v_view.real, y=v_view.imag, z=n_v.astype(float),
        mode='markers+lines',
        marker=dict(size=3, color=n_v, colorscale='Viridis', opacity=0.8),
        line=dict(color='gray', width=1),
        name='Iota points'
    )
])
fig3d.update_layout(
    scene=dict(
        xaxis_title='Re(v_n)',
        yaxis_title='Im(v_n)',
        zaxis_title='n',
        aspectmode='data'
    ),
    margin=dict(l=0, r=0, b=0, t=30),
    height=600
)
st.plotly_chart(fig3d, use_container_width=True)

st.subheader("Complex Plane: Partial Sum")
S_view = S_n[mask_v]
n_s = n_all[mask_v]
fig3, ax3 = plt.subplots(figsize=(10, 10))
ax3.plot(S_view.real, S_view.imag, 'b-', alpha=0.7, lw=1)
ax3.scatter(S_view.real, S_view.imag, c=n_s, cmap='viridis', s=5, alpha=0.6)
ax3.scatter(S_view[-1].real, S_view[-1].imag, color='red', s=50, marker='X', zorder=5, label=f'$S_{{{N_end}}}$')
ax3.axhline(0, color='gray', lw=0.5)
ax3.axvline(0, color='gray', lw=0.5)
ax3.set_aspect('equal')
ax3.set_xlabel('Real')
ax3.set_ylabel('Imag')
ax3.set_title(f'Partial sum $S_{{{N_end}}} = {S_n[N_end-1]:.4f}$')
ax3.grid(True, alpha=0.3)
ax3.legend()
st.pyplot(fig3)

st.subheader("Unwrapped Phase of Terms $\\Phi_n$")
fig_phi, ax_phi = plt.subplots(figsize=(10, 5))
ax_phi.plot(n_all, Phi_n, 'g-', lw=1, alpha=0.7)
ax_phi.scatter(n_all, Phi_n, c=n_all, cmap='viridis', s=5)
ax_phi.set_xlabel('$n$')
ax_phi.set_ylabel('$\\Phi_n$ (radians)')
ax_phi.set_title('Unwrapped Phase of $v_n$')
ax_phi.grid(True, alpha=0.3)
st.pyplot(fig_phi)

st.markdown("---")
st.markdown(r"""
**Observations:**
- The cumulative turning angle $\Theta_n$ tracks the total angular rotation of the spiral path.
- Each increment $\delta_n$ is the signed angle between consecutive chords, so
  $\Theta_n$ grows monotonically when the spiral winds consistently.
- At $t = 0$ the alternating series zig-zags along the real axis ($\delta \approx \pi$).
- As $t$ increases the logarithmic phase $-t\ln n$ modulates the turning rate.
- The histogram shows the distribution of $\Theta_n$ mod $2\pi$, indicating how uniformly the winding covers the circle.
- For $n<10$, rotated copies (gray) illustrate how shifting by full rotations would align the early points with the main trend.
- The parity plot reveals that odd and even $n$ follow nearly identical turning trajectories, confirming the smoothness of the spiral independent of the alternating sign.
""")