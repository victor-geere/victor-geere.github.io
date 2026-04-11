import streamlit as st
import numpy as np
import plotly.graph_objects as go
from plotly.subplots import make_subplots
import matplotlib.pyplot as plt
import math

st.set_page_config(layout="wide", page_title="Quaternion-Lifted Geometric RH")

st.title("Quaternion-Lifted Geometric Riemann Hypothesis")
st.markdown(r"""
**Complete Reformulation & Analytic Bridging**

This interactive explorer implements the geometric framework from the paper
*Quaternion-Lifted Geometric Riemann Hypothesis*. The key idea: a cosine-based
divisor detector is lifted into the quaternion algebra $\mathbb{H}$, producing
an energy functional whose vanishing characterises integer divisors. The framework
is then extended to the critical strip via a warping factor derived from the
functional equation of $\zeta(s)$.

> **Disclaimer.** This is a *research exposition* presenting a heuristic geometric
> framework. It does **not** constitute a proof of RH.
""")

# ---------------------------------------------------------------------------
# Sidebar controls
# ---------------------------------------------------------------------------
st.sidebar.header("Parameters")

section = st.sidebar.selectbox("Section", [
    "1. Cosine Divisor Detector",
    "2. Quaternion Lifting & Energy",
    "3. Approximate Functional Equation",
    "4. Hardy Z-function",
    "5. Warping & Critical Strip",
    "6. Spectral Energy",
])

# ============================= SECTION 1 ================================
if section.startswith("1"):
    st.header("§2  The Classical Cosine Divisor Detector")
    st.markdown(r"""
For a fixed positive integer $p$, the function

$$f(x) = \cos\!\left(2\pi \frac{p}{x}\right) + \cos(2\pi x) - 2, \qquad x > 0$$

satisfies $f(x) = 0$ if and only if both arguments are integers, i.e., precisely
when $x$ divides $p$.  This is because $\cos(2\pi\theta) = 1$ iff $\theta \in \mathbb{Z}$.

**Divisor Detector Property.** Let $D_p = \{ d \in \mathbb{Z}^+ : d \mid p \}$. Then
$f(x) = 0 \iff x \in D_p$.
    """)

    p = st.sidebar.slider("Integer p", 1, 120, 12)
    x_range = st.sidebar.slider("x range", 0.5, float(p + 5), (0.5, float(p + 2)))

    x = np.linspace(x_range[0], x_range[1], 2000)
    f_x = np.cos(2 * np.pi * p / x) + np.cos(2 * np.pi * x) - 2

    # Find divisors of p
    divisors = [d for d in range(1, p + 1) if p % d == 0]

    fig = go.Figure()
    fig.add_trace(go.Scatter(x=x, y=f_x, mode='lines', name='f(x)', line=dict(color='steelblue', width=2)))
    fig.add_hline(y=0, line_dash="dash", line_color="gray")

    # Mark divisors
    for d in divisors:
        if x_range[0] <= d <= x_range[1]:
            fig.add_trace(go.Scatter(
                x=[d], y=[0], mode='markers+text',
                marker=dict(color='red', size=12, symbol='diamond'),
                text=[f'd={d}'], textposition='top center',
                name=f'Divisor {d}', showlegend=False
            ))

    fig.update_layout(
        title=f'Cosine Divisor Detector for p = {p}  (divisors: {divisors})',
        xaxis_title='x',
        yaxis_title='f(x)',
        height=500,
    )
    st.plotly_chart(fig, use_container_width=True)

    # Heatmap view
    st.subheader("Divisor Detector Heatmap")
    st.markdown(r"Heatmap of $|f(x)|$ for various $p$ and $x$.  Dark spots mark divisors.")

    p_vals = np.arange(1, 31)
    x_vals = np.linspace(0.5, 30.5, 600)
    Z = np.zeros((len(p_vals), len(x_vals)))
    for i, pv in enumerate(p_vals):
        Z[i, :] = np.abs(np.cos(2 * np.pi * pv / x_vals) + np.cos(2 * np.pi * x_vals) - 2)

    fig2 = go.Figure(data=go.Heatmap(
        z=Z, x=x_vals, y=p_vals,
        colorscale='Viridis', reversescale=True,
        colorbar=dict(title='|f(x)|'),
    ))
    fig2.update_layout(
        title='|f(x)| — dark = zero = divisor',
        xaxis_title='x',
        yaxis_title='p',
        height=450,
    )
    st.plotly_chart(fig2, use_container_width=True)


# ============================= SECTION 2 ================================
elif section.startswith("2"):
    st.header("§3–4  Quaternion Lifting & Energy Functional")
    st.markdown(r"""
The two cosine terms are separated into orthogonal imaginary directions of $\mathbb{H}$:

$$\phi_p(x) := \cos(2\pi x)\,\mathbf{i} + \cos\!\left(2\pi \frac{p}{x}\right)\,\mathbf{j} \in \operatorname{Im}\mathbb{H}.$$

The quaternion norm recovers the classical detector:

$$\|\phi_p(x) - (\mathbf{i} + \mathbf{j})\|^2 = 2f(x) + 4.$$

The **quaternion energy functional** is:

$$E_p(x) := \|\phi_p(x) - (\mathbf{i} + \mathbf{j})\|^2 = 2\bigl[(1 - \cos(2\pi x))^2 + (1 - \cos(2\pi p/x))^2\bigr].$$

It vanishes exactly on the divisor set $D_p$.
    """)

    p = st.sidebar.slider("Integer p", 1, 60, 12)
    N_pts = st.sidebar.slider("Resolution", 200, 2000, 800, step=100)

    x = np.linspace(0.3, p + 2, N_pts)
    cos_x = np.cos(2 * np.pi * x)
    cos_px = np.cos(2 * np.pi * p / x)
    E_x = 2 * ((1 - cos_x)**2 + (1 - cos_px)**2)

    divisors = [d for d in range(1, p + 1) if p % d == 0]

    col1, col2 = st.columns(2)

    with col1:
        st.subheader("Energy Functional $E_p(x)$")
        fig_e = go.Figure()
        fig_e.add_trace(go.Scatter(x=x, y=E_x, mode='lines', name='E_p(x)', line=dict(color='#3b82f6')))
        for d in divisors:
            fig_e.add_trace(go.Scatter(
                x=[d], y=[0], mode='markers',
                marker=dict(color='red', size=10, symbol='circle'),
                name=f'd={d}', showlegend=False
            ))
        fig_e.update_layout(
            title=f'Quaternion Energy E_p(x) for p={p}',
            xaxis_title='x', yaxis_title='E_p(x)',
            height=450,
        )
        st.plotly_chart(fig_e, use_container_width=True)

    with col2:
        st.subheader("3D Quaternion Field $\\phi_p(x)$")
        # Plot the i- and j-components of phi_p(x) with x as z-axis
        i_comp = cos_x
        j_comp = cos_px
        k_comp = np.zeros_like(x)  # k-component is always zero

        fig_3d = go.Figure()
        fig_3d.add_trace(go.Scatter3d(
            x=i_comp, y=j_comp, z=x,
            mode='lines+markers',
            marker=dict(size=2, color=E_x, colorscale='Hot', cmin=0, cmax=8, colorbar=dict(title='E_p')),
            line=dict(color='gray', width=1),
            name='φ_p(x)'
        ))
        # Mark target point (1, 1) at each divisor
        for d in divisors:
            fig_3d.add_trace(go.Scatter3d(
                x=[1], y=[1], z=[d],
                mode='markers', marker=dict(size=6, color='green', symbol='diamond'),
                name=f'Target at d={d}', showlegend=False
            ))
        fig_3d.update_layout(
            scene=dict(
                xaxis_title='cos(2πx)  [i]',
                yaxis_title='cos(2πp/x)  [j]',
                zaxis_title='x',
            ),
            title='Quaternion Field φ_p(x) in Im(ℍ)',
            height=500,
        )
        st.plotly_chart(fig_3d, use_container_width=True)

    # Phase portrait
    st.subheader("Phase Portrait: cos(2πx) vs cos(2πp/x)")
    fig_phase = go.Figure()
    fig_phase.add_trace(go.Scatter(
        x=cos_x, y=cos_px, mode='lines',
        line=dict(color='steelblue', width=1),
        name='Trajectory'
    ))
    fig_phase.add_trace(go.Scatter(
        x=[1], y=[1], mode='markers',
        marker=dict(color='red', size=14, symbol='star'),
        name='Target (1,1)'
    ))
    fig_phase.update_layout(
        title=f'Phase Portrait for p={p}',
        xaxis_title='cos(2πx)', yaxis_title='cos(2πp/x)',
        height=450,
        xaxis=dict(range=[-1.2, 1.2]),
        yaxis=dict(range=[-1.2, 1.2]),
    )
    st.plotly_chart(fig_phase, use_container_width=True)


# ============================= SECTION 3 ================================
elif section.startswith("3"):
    st.header("§5  Approximate Functional Equation")
    st.markdown(r"""
For $s = \sigma + it$ with $t > 0$, the approximate functional equation is:

$$\zeta(s) = \sum_{n \le N} \frac{1}{n^s} + \chi(s)\sum_{m \le M} \frac{1}{m^{1-s}} + R(s),$$

where $NM = t/(2\pi)$ (hyperbolic constraint), and $\chi(s) = 2^s \pi^{s-1}\sin(\pi s/2)\,\Gamma(1-s)$.

**Critical-line symmetry:** On $\sigma = 1/2$, $|\chi(1/2+it)| = 1$ exactly — the two partial sums
enter with equal amplitude.

**Off-line asymmetry:** For $\sigma \neq 1/2$:
$$|\chi(\sigma+it)| \sim \left(\frac{t}{2\pi}\right)^{1/2-\sigma}.$$
    """)

    t_val = st.sidebar.slider("t (imaginary part)", 5.0, 100.0, 30.0, step=0.5)
    sigma_val = st.sidebar.slider("σ (real part)", 0.01, 0.99, 0.5, step=0.01)

    N_afe = int(np.sqrt(t_val / (2 * np.pi)))
    M_afe = int(t_val / (2 * np.pi * N_afe)) if N_afe > 0 else 1

    # Compute partial sums
    n_arr = np.arange(1, N_afe + 1)
    s_val = sigma_val + 1j * t_val
    sum1 = np.cumsum(n_arr ** (-s_val))

    m_arr = np.arange(1, M_afe + 1)
    sum2 = np.cumsum(m_arr ** (-(1 - s_val)))

    # Chi modulus for various sigma
    sigma_range = np.linspace(0.01, 0.99, 200)
    chi_mod = (t_val / (2 * np.pi)) ** (0.5 - sigma_range)

    col1, col2 = st.columns(2)

    with col1:
        st.subheader("Partial Sum Trajectories")
        fig_ps = go.Figure()
        fig_ps.add_trace(go.Scatter(
            x=sum1.real, y=sum1.imag, mode='lines+markers',
            marker=dict(size=3, color='blue'), line=dict(width=1),
            name=f'Sum 1 (N={N_afe})'
        ))
        if len(sum2) > 0:
            fig_ps.add_trace(go.Scatter(
                x=sum2.real, y=sum2.imag, mode='lines+markers',
                marker=dict(size=3, color='orange'), line=dict(width=1),
                name=f'Sum 2 (M={M_afe})'
            ))
        fig_ps.update_layout(
            title=f'Partial sums at s = {sigma_val} + {t_val}i  (N={N_afe}, M={M_afe})',
            xaxis_title='Real', yaxis_title='Imag',
            height=450,
        )
        st.plotly_chart(fig_ps, use_container_width=True)

    with col2:
        st.subheader("Amplitude Asymmetry |χ(σ+it)|")
        fig_chi = go.Figure()
        fig_chi.add_trace(go.Scatter(
            x=sigma_range, y=chi_mod, mode='lines',
            line=dict(color='#8b5cf6', width=2), name='|χ(σ+it)|'
        ))
        fig_chi.add_hline(y=1, line_dash="dash", line_color="red", annotation_text="Balance (σ=1/2)")
        fig_chi.add_vline(x=0.5, line_dash="dot", line_color="gray")
        fig_chi.update_layout(
            title=f'|χ(σ+it)| ≈ (t/2π)^(1/2−σ)  for t={t_val}',
            xaxis_title='σ', yaxis_title='|χ|',
            height=450,
            yaxis_type='log',
        )
        st.plotly_chart(fig_chi, use_container_width=True)

    st.markdown(f"""
    **Hyperbolic constraint:** $NM = t/(2\\pi)$ → $N = {N_afe}$, $M = {M_afe}$, product $= {N_afe * M_afe}$, target $= {t_val/(2*np.pi):.1f}$
    """)


# ============================= SECTION 4 ================================
elif section.startswith("4"):
    st.header("§5.4  Hardy Z-function")
    st.markdown(r"""
The Hardy $Z$-function is:

$$Z(t) = e^{i\vartheta(t)}\,\zeta\!\left(\tfrac{1}{2} + it\right), \qquad
\vartheta(t) = \arg\!\bigl[\pi^{-it/2}\,\Gamma(\tfrac{1}{4} + \tfrac{it}{2})\bigr].$$

$Z(t)$ is **real-valued** and its sign changes correspond to zeros of $\zeta$ on the critical line.
The Riemann–Siegel formula gives:

$$Z(t) = 2\!\sum_{n \le \sqrt{t/2\pi}} \frac{\cos\bigl(\vartheta(t) - t\log n\bigr)}{\sqrt{n}} + O(t^{-1/4}).$$
    """)

    from scipy.special import gamma as gamma_fn

    t_min = st.sidebar.slider("t min", 0.5, 50.0, 1.0, step=0.5)
    t_max = st.sidebar.slider("t max", 10.0, 100.0, 50.0, step=1.0)
    n_points = st.sidebar.slider("Resolution", 500, 5000, 2000, step=500)

    t_arr = np.linspace(t_min, t_max, n_points)

    def riemann_siegel_theta(t):
        """Approximate Riemann-Siegel theta function."""
        return (t / 2) * np.log(t / (2 * np.pi)) - t / 2 - np.pi / 8 + 1 / (48 * t)

    def hardy_z_approx(t, n_terms=None):
        """Approximate Hardy Z-function via Riemann-Siegel formula."""
        if t < 2:
            return 0.0
        N = int(np.sqrt(t / (2 * np.pi)))
        if n_terms is not None:
            N = min(N, n_terms)
        if N < 1:
            return 0.0
        theta = riemann_siegel_theta(t)
        z_val = 0.0
        for n in range(1, N + 1):
            z_val += np.cos(theta - t * np.log(n)) / np.sqrt(n)
        return 2 * z_val

    Z_vals = np.array([hardy_z_approx(tv) for tv in t_arr])

    # Find sign changes (approximate zeros)
    sign_changes = []
    for i in range(len(Z_vals) - 1):
        if Z_vals[i] * Z_vals[i + 1] < 0:
            # Linear interpolation
            t_zero = t_arr[i] - Z_vals[i] * (t_arr[i + 1] - t_arr[i]) / (Z_vals[i + 1] - Z_vals[i])
            sign_changes.append(t_zero)

    fig_z = go.Figure()
    fig_z.add_trace(go.Scatter(
        x=t_arr, y=Z_vals, mode='lines',
        line=dict(color='steelblue', width=2), name='Z(t)'
    ))
    fig_z.add_hline(y=0, line_dash="dash", line_color="gray")

    for tz in sign_changes:
        fig_z.add_trace(go.Scatter(
            x=[tz], y=[0], mode='markers',
            marker=dict(color='red', size=8, symbol='circle'),
            name=f't≈{tz:.2f}', showlegend=False
        ))

    fig_z.update_layout(
        title='Hardy Z-function (Riemann-Siegel approximation)',
        xaxis_title='t',
        yaxis_title='Z(t)',
        height=500,
    )
    st.plotly_chart(fig_z, use_container_width=True)

    # Known first few zeta zeros
    known_zeros = [14.134725, 21.022040, 25.010858, 30.424876, 32.935062,
                   37.586178, 40.918719, 43.327073, 48.005151, 49.773832]
    zeros_in_range = [z for z in known_zeros if t_min <= z <= t_max]

    col1, col2 = st.columns(2)
    with col1:
        st.markdown("**Approximate zeros found (sign changes):**")
        for tz in sign_changes:
            st.write(f"  t ≈ {tz:.4f}")
    with col2:
        st.markdown("**Known non-trivial zeros (first 10):**")
        for z in zeros_in_range:
            st.write(f"  t = {z:.6f}")

    # Riemann-Siegel terms at a specific t
    st.subheader("Riemann-Siegel Terms at Selected t")
    t_sel = st.slider("Select t", float(t_min), float(t_max), float(known_zeros[0]) if known_zeros[0] >= t_min else float(t_min), step=0.01)
    N_rs = int(np.sqrt(t_sel / (2 * np.pi)))
    if N_rs >= 1:
        theta_sel = riemann_siegel_theta(t_sel)
        ns = np.arange(1, N_rs + 1)
        terms = np.cos(theta_sel - t_sel * np.log(ns)) / np.sqrt(ns)
        cumsum_terms = np.cumsum(terms) * 2

        fig_terms = make_subplots(rows=1, cols=2, subplot_titles=["Individual terms", "Cumulative sum → Z(t)"])
        fig_terms.add_trace(go.Bar(x=ns, y=terms, marker_color='steelblue', name='cos(θ-t·ln n)/√n'), row=1, col=1)
        fig_terms.add_trace(go.Scatter(x=ns, y=cumsum_terms, mode='lines+markers',
                                       marker=dict(size=4), name='2·Σ terms'), row=1, col=2)
        fig_terms.update_layout(height=350, title=f'N = {N_rs} terms at t = {t_sel:.4f}')
        st.plotly_chart(fig_terms, use_container_width=True)


# ============================= SECTION 5 ================================
elif section.startswith("5"):
    st.header("§6–7  Warping Factor & Critical Strip")
    st.markdown(r"""
The **warping factor** encodes the functional equation's reflection $s \mapsto 1-s$:

$$w(\sigma) = \frac{1}{2\sigma - 1} \qquad (\sigma \neq 1/2).$$

The **generalised quaternion energy** in the critical strip is:

$$E(t,\sigma;x) = 2\bigl[1 - \cos(2\pi x)\bigr]^2 + 2\bigl[1 - \cos(2\pi t\,w(\sigma)/x)\bigr]^2.$$

On the critical line ($\sigma = 1/2$), $w = 1$ and the energy reduces to the original detector.
Off the critical line, the warping mismatch breaks the hyperbolic balance.
    """)

    t_val = st.sidebar.slider("t (imaginary part)", 5.0, 100.0, 14.135, step=0.01)
    sigma_val = st.sidebar.slider("σ (real part)", 0.01, 0.99, 0.5, step=0.01)
    x_max = st.sidebar.slider("x range max", 5.0, 50.0, 20.0, step=1.0)

    x = np.linspace(0.3, x_max, 2000)

    # Warping factor
    if abs(sigma_val - 0.5) < 1e-6:
        w_val = 1.0
    else:
        w_val = 1.0 / (2 * sigma_val - 1)

    E_x = 2 * (1 - np.cos(2 * np.pi * x))**2 + 2 * (1 - np.cos(2 * np.pi * t_val * w_val / x))**2

    col1, col2 = st.columns(2)

    with col1:
        st.subheader(f"Generalised Energy E(t,σ;x)")
        fig_e = go.Figure()
        fig_e.add_trace(go.Scatter(x=x, y=E_x, mode='lines', line=dict(color='#3b82f6', width=2)))
        fig_e.update_layout(
            title=f'E({t_val:.3f}, {sigma_val}, x)   w(σ) = {w_val:.3f}',
            xaxis_title='x', yaxis_title='E(t,σ;x)',
            height=450,
        )
        st.plotly_chart(fig_e, use_container_width=True)

    with col2:
        st.subheader("Warping Factor w(σ)")
        sigma_range = np.linspace(0.01, 0.99, 500)
        sigma_range = sigma_range[np.abs(sigma_range - 0.5) > 0.005]  # avoid pole
        w_range = 1.0 / (2 * sigma_range - 1)

        fig_w = go.Figure()
        fig_w.add_trace(go.Scatter(x=sigma_range, y=w_range, mode='lines',
                                    line=dict(color='#8b5cf6', width=2), name='w(σ)'))
        fig_w.add_vline(x=0.5, line_dash="dot", line_color="red", annotation_text="σ = 1/2")
        fig_w.add_hline(y=1, line_dash="dash", line_color="gray")
        fig_w.update_layout(
            title='Warping Factor w(σ) = 1/(2σ−1)',
            xaxis_title='σ', yaxis_title='w(σ)',
            height=450,
            yaxis=dict(range=[-10, 10]),
        )
        st.plotly_chart(fig_w, use_container_width=True)

    # Energy landscape heatmap: sigma vs x
    st.subheader("Energy Landscape: σ vs x")
    sigma_grid = np.linspace(0.01, 0.99, 200)
    x_grid = np.linspace(0.5, x_max, 400)
    E_grid = np.zeros((len(sigma_grid), len(x_grid)))

    for i, sig in enumerate(sigma_grid):
        if abs(sig - 0.5) < 0.005:
            w = 1.0
        else:
            w = 1.0 / (2 * sig - 1)
        E_grid[i, :] = 2 * (1 - np.cos(2 * np.pi * x_grid))**2 + \
                        2 * (1 - np.cos(2 * np.pi * t_val * w / x_grid))**2

    fig_heat = go.Figure(data=go.Heatmap(
        z=np.log1p(E_grid), x=x_grid, y=sigma_grid,
        colorscale='Viridis', colorbar=dict(title='log(1+E)'),
    ))
    fig_heat.add_hline(y=0.5, line_dash="dash", line_color="red",
                       annotation_text="Critical line σ=1/2")
    fig_heat.update_layout(
        title=f'log(1 + E(t={t_val:.2f}, σ, x))  — dark = low energy',
        xaxis_title='x', yaxis_title='σ',
        height=500,
    )
    st.plotly_chart(fig_heat, use_container_width=True)


# ============================= SECTION 6 ================================
elif section.startswith("6"):
    st.header("§9  Spectral Energy")
    st.markdown(r"""
The **spectral energy** is derived from the full approximate functional equation:

$$\mathcal{E}_{\mathrm{spec}}(t,\sigma) = \left|\sum_{n \le N} \frac{1}{n^{\sigma+it}} +
\chi(\sigma+it)\sum_{m \le M} \frac{1}{m^{1-\sigma-it}}\right|^2, \quad NM = \frac{t}{2\pi}.$$

This vanishes if and only if $\zeta(\sigma+it) = 0$ (up to the remainder $R$). The
amplitude asymmetry $|\chi(\sigma+it)| \sim (t/2\pi)^{1/2-\sigma}$ for $\sigma \neq 1/2$
makes cancellation between the two sums progressively harder.

The **Tao–Yang–Guth density hypothesis** (proved April 2026):
$$N(\sigma,T) \ll T^{2(1-\sigma)+o(1)} \quad \text{for all } \sigma > 1/2.$$
    """)

    t_val = st.sidebar.slider("t", 10.0, 100.0, 30.0, step=1.0)
    sigma_val = st.sidebar.slider("σ", 0.1, 0.9, 0.5, step=0.01)

    N_afe = max(1, int(np.sqrt(t_val / (2 * np.pi))))
    M_afe = max(1, int(t_val / (2 * np.pi * N_afe)))

    s_val = sigma_val + 1j * t_val

    # Sum 1
    n_arr = np.arange(1, N_afe + 1)
    sum1_val = np.sum(n_arr ** (-s_val))

    # Chi approximation
    chi_mod = (t_val / (2 * np.pi)) ** (0.5 - sigma_val)
    chi_arg = -(t_val / 2) * np.log(t_val / (2 * np.pi)) + t_val / 2 + np.pi / 8
    chi_val = chi_mod * np.exp(1j * chi_arg)

    # Sum 2
    m_arr = np.arange(1, M_afe + 1)
    sum2_val = chi_val * np.sum(m_arr ** (-(1 - s_val)))

    spectral_energy = abs(sum1_val + sum2_val) ** 2

    st.metric("Spectral Energy 𝓔_spec", f"{spectral_energy:.6f}")
    st.write(f"Sum 1 = {sum1_val:.5f}")
    st.write(f"|χ| = {chi_mod:.5f}")
    st.write(f"Sum 2 (with χ) = {sum2_val:.5f}")

    # Sweep sigma for fixed t
    st.subheader("Spectral Energy vs σ")
    sigmas = np.linspace(0.1, 0.9, 200)
    e_spec = []
    for sig in sigmas:
        s = sig + 1j * t_val
        N_local = max(1, int(np.sqrt(t_val / (2 * np.pi))))
        M_local = max(1, int(t_val / (2 * np.pi * N_local)))
        n_a = np.arange(1, N_local + 1)
        s1 = np.sum(n_a ** (-s))
        chi_m = (t_val / (2 * np.pi)) ** (0.5 - sig)
        chi_a = -(t_val / 2) * np.log(t_val / (2 * np.pi)) + t_val / 2 + np.pi / 8
        chi_v = chi_m * np.exp(1j * chi_a)
        m_a = np.arange(1, M_local + 1)
        s2 = chi_v * np.sum(m_a ** (-(1 - s)))
        e_spec.append(abs(s1 + s2) ** 2)

    fig_spec = go.Figure()
    fig_spec.add_trace(go.Scatter(x=sigmas, y=e_spec, mode='lines',
                                   line=dict(color='#ef4444', width=2)))
    fig_spec.add_vline(x=0.5, line_dash="dot", line_color="gray", annotation_text="σ=1/2")
    fig_spec.update_layout(
        title=f'Spectral Energy at t = {t_val}',
        xaxis_title='σ', yaxis_title='𝓔_spec(t,σ)',
        height=450,
    )
    st.plotly_chart(fig_spec, use_container_width=True)

    # Zero density bound
    st.subheader("Tao–Yang–Guth Zero-Density Bound")
    T_val = st.slider("T (height)", 100, 10000, 1000, step=100)
    sigmas2 = np.linspace(0.51, 0.99, 200)
    N_bound = T_val ** (2 * (1 - sigmas2))

    fig_den = go.Figure()
    fig_den.add_trace(go.Scatter(x=sigmas2, y=N_bound, mode='lines',
                                  line=dict(color='#22c55e', width=2),
                                  name='N(σ,T) bound'))
    fig_den.update_layout(
        title=f'Zero-density bound N(σ,T) ≪ T^(2(1−σ))  for T = {T_val}',
        xaxis_title='σ', yaxis_title='N(σ,T)',
        height=400,
        yaxis_type='log',
    )
    st.plotly_chart(fig_den, use_container_width=True)


st.markdown("---")
st.markdown(r"""
**Source:** *Quaternion-Lifted Geometric Riemann Hypothesis — Complete Reformulation & Analytic Bridging* (April 2026).
This framework is a research exposition, not a proof of RH.
""")
