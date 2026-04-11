import streamlit as st
import numpy as np
import matplotlib.pyplot as plt
import plotly.graph_objects as go
from fractions import Fraction
import math

st.set_page_config(layout="wide")
st.title("Iota Function: Diophantine Properties & Exponential Sums")
st.markdown(r"""
The **iota function** encodes $s = \sigma + i t$ as a 3D spiral:
$$
P_n = \bigl(n^{-\sigma}\cos\Phi_n,\; n^{-\sigma}\sin\Phi_n,\; n\bigr), \quad
\Phi_n = \pi(n-1) - t\ln n.
$$
The unwrapped phase $\Phi_n$ contains the sequence $t\ln n \bmod 2\pi$, whose Diophantine properties govern the behavior of exponential sums $\sum n^{-s}$.
""")

# Sidebar controls
st.sidebar.header("Parameters")
t = st.sidebar.slider("$t$ (imaginary part)", min_value=0.0, max_value=50.0, value=14.134725, step=0.01, format="%.3f")
sigma = st.sidebar.slider("$\\sigma$ (real part)", min_value=0.0, max_value=1.0, value=0.5, step=0.01)
N = st.sidebar.slider("Number of terms $N$", min_value=50, max_value=2000, value=500, step=50)

# Rational approximation of t/(2π)
alpha = t / (2 * np.pi)
frac = Fraction(alpha).limit_denominator(1000)
st.sidebar.markdown(f"**$t/(2\\pi)$ ≈ {alpha:.6f}**")
st.sidebar.markdown(f"Best rational approx (denom ≤ 1000): `{frac.numerator}/{frac.denominator}` = {frac.numerator/frac.denominator:.6f}")

# Compute data
n = np.arange(1, N+1)
r_n = n**(-sigma)
Phi_n_unwrapped = np.pi * (n - 1) - t * np.log(n)
x_n = r_n * np.cos(Phi_n_unwrapped)
y_n = r_n * np.sin(Phi_n_unwrapped)
z_n = n

# Complex terms and partial sums
v_n = x_n + 1j * y_n
S_n = np.cumsum(v_n)

# Phase modulo 2π (for histogram)
phase_mod = (Phi_n_unwrapped % (2*np.pi)) / (2*np.pi)  # in [0,1)

# -------------------- Layout --------------------
col1, col2 = st.columns(2)

with col1:
    st.subheader("3D Iota Spiral")
    fig_3d = go.Figure(data=[
        go.Scatter3d(
            x=x_n, y=y_n, z=z_n,
            mode='markers+lines',
            marker=dict(size=2, color=z_n, colorscale='Viridis', opacity=0.8),
            line=dict(color='gray', width=1),
            name='Iota points'
        )
    ])
    fig_3d.update_layout(
        scene=dict(
            xaxis_title='Re(v_n)',
            yaxis_title='Im(v_n)',
            zaxis_title='n',
            aspectmode='data'
        ),
        margin=dict(l=0, r=0, b=0, t=30),
        height=500
    )
    st.plotly_chart(fig_3d, width='stretch')

    st.subheader("Phase Distribution (mod 2π)")
    fig_hist, ax_hist = plt.subplots(figsize=(6, 3))
    ax_hist.hist(phase_mod, bins=50, density=True, alpha=0.7, color='steelblue', edgecolor='white')
    ax_hist.axhline(y=1.0, color='red', linestyle='--', label='Uniform density')
    ax_hist.set_xlabel(r'$\frac{t}{2\pi}\ln n \;\mathrm{mod}\; 1$')
    ax_hist.set_ylabel('Density')
    ax_hist.legend()
    ax_hist.set_title(f'Equidistribution for N={N}')
    st.pyplot(fig_hist)

with col2:
    st.subheader("Complex Plane: Terms and Partial Sums")
    fig_comp, ax_comp = plt.subplots(figsize=(7, 7))
    # Terms as scatter
    ax_comp.scatter(x_n, y_n, c=n, cmap='viridis', s=5, alpha=0.6, label='Terms $v_n$')
    # Partial sum trajectory
    ax_comp.plot(S_n.real, S_n.imag, 'r-', linewidth=1, label='Partial sum $S_N$')
    ax_comp.scatter(S_n[-1].real, S_n[-1].imag, color='red', s=50, marker='X', zorder=5, label=f'$S_{{{N}}}$')
    ax_comp.axhline(0, color='gray', lw=0.5)
    ax_comp.axvline(0, color='gray', lw=0.5)
    ax_comp.set_aspect('equal')
    ax_comp.set_xlabel('Real')
    ax_comp.set_ylabel('Imag')
    ax_comp.set_title('Exponential sum trajectory')
    ax_comp.legend(loc='upper right')
    ax_comp.grid(True, alpha=0.3)
    st.pyplot(fig_comp)

    # Additional info
    st.markdown(f"""
    **Current partial sum**: $S_{{{N}}} = {S_n[-1]:.5f}$  
    **Magnitude**: $|S_{{{N}}}| = {abs(S_n[-1]):.5f}$
    """)

    # Greedy condition check (pointwise)
    st.subheader("Greedy Condition (pointwise)")
    # For each N, compute Re( conj(S_{N-1}) * v_N )
    if N > 1:
        greedy_vals = np.real(np.conj(S_n[:-1]) * v_n[1:])
        greedy_fails = np.sum(greedy_vals > 0)
        fig_greedy, ax_greedy = plt.subplots(figsize=(6, 3))
        ax_greedy.plot(n[1:], greedy_vals, 'b-', alpha=0.7)
        ax_greedy.axhline(0, color='k', linestyle='--')
        ax_greedy.fill_between(n[1:], 0, greedy_vals, where=(greedy_vals>0), color='red', alpha=0.3, label='Violations')
        ax_greedy.set_xlabel('n')
        ax_greedy.set_ylabel(r'$\operatorname{Re}(\overline{S_{n-1}} v_n)$')
        ax_greedy.set_title(f'Greedy violations: {greedy_fails} out of {N-1}')
        ax_greedy.legend()
        st.pyplot(fig_greedy)
        if greedy_fails > 0:
            st.warning(f"Greedy condition violated at {greedy_fails} indices.")
        else:
            st.success("Greedy condition holds for all n (pointwise).")
    else:
        st.info("Increase N to see greedy condition.")

st.markdown("---")
st.markdown(r"""
**Interpretation**:
- The **3D spiral** shows the geometric encoding. The $z$-coordinate is the index $n$.
- The **phase histogram** reveals Diophantine effects: for rational $t/(2\pi)$, phases cluster; for typical irrationals, they are uniform.
- The **complex plane** shows the terms $v_n$ (colored by $n$) and the cumulative sum $S_N$.
- The **greedy condition** checks whether $\operatorname{Re}(\overline{S_{n-1}} v_n) \le 0$ for all $n$. For $\sigma=1/2$ and a true zeta zero $t$, this should hold (if RH true).
""")