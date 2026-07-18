import streamlit as st
import numpy as np
import plotly.graph_objects as go
from plotly.subplots import make_subplots
from scipy.special import gamma as gamma_fn
import math

st.set_page_config(layout="wide", page_title="Quantum-Egyptian Functional Equation")

st.title("The Quantum-Egyptian Functional Equation — v8")
st.markdown(r"""
**Functional equation of Riemann-zeta type for Dirichlet series from modular tensor categories.**

For an integral MTC $\mathcal{C}$ with simple objects $\{X_i\}$ and total quantum dimension $D$,
define Egyptian denominators $m_i = D^2/d_i^2$. The Galois action on the modular $S$-matrix yields
a character $\chi$. The categorical Dirichlet series $\Psi_{\mathcal{C},\chi}(s) = \sum_i \chi(m_i)\,m_i^{-s}$
satisfies:

$$\Psi_{\mathcal{C},\chi}(s)=\varepsilon\!\left(\frac{D^2}{\pi}\right)^{\!s-\frac12}\,
\frac{\Gamma\!\left(\frac{1-s+a}{2}\right)}{\Gamma\!\left(\frac{s+a}{2}\right)}\,
\overline{\Psi_{\mathcal{C}^{\sigma},\overline{\chi}}(1-s)},$$

where $a \in \{0,1\}$ is a parity from the $T$-matrix, and $\varepsilon = \pm 1$ is a root number.
""")

# =========================================================================
# MTC data definitions
# =========================================================================

MTCS = {
    "Ising": {
        "objects": ["1", "σ", "ψ"],
        "d_sq": [1, 2, 1],
        "D_sq": 4,
        "chi_vals": [1, -1, 1],
        "a": 0,
        "epsilon": 1,
        "description": r"""
**Ising MTC** has 3 simple objects: $\mathbf{1}, \sigma, \psi$.
- $D^2 = 4$, $D = 2$
- $S$-matrix contains $\sqrt{2}$; Galois automorphism $\sigma: \sqrt{2} \mapsto -\sqrt{2}$
- Egyptian denominators: $m = (4, 2, 4)$
- Character: $\chi(4)=1$, $\chi(2)=-1$
- Parity $a=0$, root number $\varepsilon=1$
        """,
        "S_matrix": np.array([
            [1, np.sqrt(2), 1],
            [np.sqrt(2), 0, -np.sqrt(2)],
            [1, -np.sqrt(2), 1],
        ]) / 2,
    },
    "SU(2)_4": {
        "objects": ["1", "2", "3", "4", "5"],
        "d_sq": [1, 3, 4, 3, 1],
        "D_sq": 12,
        "chi_vals": [1, -1, 1, -1, 1],
        "a": 1,
        "epsilon": 1,
        "description": r"""
**$\mathrm{SU}(2)_4$** has 5 simple objects labelled $a = 2j+1 \in \{1,2,3,4,5\}$.
- $D^2 = 12$
- $S_{ab} = \frac{1}{\sqrt{3}}\sin(\pi ab/6)$
- Egyptian denominators: $m = (12, 4, 3, 4, 12)$
- Galois automorphism $\sigma_{13}$ swaps objects 2 and 4
- Character: $\chi(12)=1$, $\chi(4)=-1$, $\chi(3)=1$
- Parity $a=1$, root number $\varepsilon=1$
        """,
        "S_matrix": np.array([
            [np.sin(np.pi * a * b / 6) for b in range(1, 6)]
            for a in range(1, 6)
        ]) / np.sqrt(3),
    },
}


# Sidebar
st.sidebar.header("Parameters")

section = st.sidebar.selectbox("Section", [
    "1. MTC Data & Egyptian Denominators",
    "2. Twisted Theta Function",
    "3. Categorical Dirichlet Series",
    "4. Functional Equation Verification",
    "5. SU(2)_k → ζ(2s) Limit",
])

mtc_choice = st.sidebar.selectbox("MTC", list(MTCS.keys()))
mtc = MTCS[mtc_choice]

d_sq = np.array(mtc["d_sq"])
D_sq = mtc["D_sq"]
D = np.sqrt(D_sq)
m_vals = D_sq // d_sq  # Egyptian denominators
chi = np.array(mtc["chi_vals"])
a_parity = mtc["a"]
eps = mtc["epsilon"]


# ============================= SECTION 1 ================================
if section.startswith("1"):
    st.header("§2  MTC Data & Egyptian Denominators")
    st.markdown(mtc["description"])

    # Data table
    st.subheader("Simple Objects")
    import pandas as pd
    df = pd.DataFrame({
        "Object": mtc["objects"],
        "d²": d_sq.tolist(),
        "d": [f"√{v}" if v != int(np.sqrt(v))**2 else str(int(np.sqrt(v))) for v in d_sq],
        "m = D²/d²": m_vals.tolist(),
        "χ(m)": chi.tolist(),
    })
    st.dataframe(df, use_container_width=True, hide_index=True)

    st.markdown(f"**Total quantum dimension:** $D^2 = {D_sq}$, $D = {D:.4f}$")

    # Egyptian fraction identity
    egyptian_sum = sum(1.0 / m_vals[1:])
    target = 1 - 1.0 / D_sq
    st.markdown(f"""
**Egyptian fraction identity:**
$$\\sum_{{i \\neq 0}} \\frac{{1}}{{m_i}} = {egyptian_sum:.6f} \\quad \\stackrel{{?}}{{=}} \\quad 1 - \\frac{{1}}{{D^2}} = {target:.6f}$$
{"✅ Verified!" if abs(egyptian_sum - target) < 1e-10 else "❌ Mismatch!"}
    """)

    # S-matrix visualisation
    st.subheader("Modular $S$-matrix")
    S = mtc["S_matrix"]
    fig_s = go.Figure(data=go.Heatmap(
        z=S, x=mtc["objects"], y=mtc["objects"],
        colorscale='RdBu', zmid=0,
        text=np.round(S, 4), texttemplate="%{text:.3f}",
        colorbar=dict(title="S_ij"),
    ))
    fig_s.update_layout(
        title=f"{mtc_choice} Normalised S-matrix (S/D)",
        height=400, width=500,
    )
    st.plotly_chart(fig_s)

    # Verify unitarity
    SS = S @ S.T
    st.markdown("**$S$-matrix unitarity check:** $\\tilde{S}\\tilde{S}^T \\approx$")
    st.dataframe(pd.DataFrame(
        np.round(SS, 6),
        columns=mtc["objects"],
        index=mtc["objects"]
    ))


# ============================= SECTION 2 ================================
elif section.startswith("2"):
    st.header("§2.4  Twisted Theta Function")
    st.markdown(r"""
The twisted theta function is:

$$\Theta_{\mathcal{C},\chi}(\tau) = \sum_{i=0}^{r} \chi(m_i)\,e^{-\pi (m_i/D)^2 \tau}.$$

Its Mellin transform yields the categorical Dirichlet series $\Psi(s)$.
    """)

    tau_max = st.sidebar.slider("τ max", 1.0, 20.0, 10.0, step=0.5)

    tau = np.linspace(0.01, tau_max, 1000)

    # Compute theta
    theta_vals = np.zeros_like(tau)
    for i in range(len(m_vals)):
        theta_vals += chi[i] * np.exp(-np.pi * (m_vals[i] / D) ** 2 * tau)

    # Individual terms
    fig_theta = go.Figure()
    for i in range(len(m_vals)):
        term = chi[i] * np.exp(-np.pi * (m_vals[i] / D) ** 2 * tau)
        fig_theta.add_trace(go.Scatter(
            x=tau, y=term, mode='lines',
            name=f'{mtc["objects"][i]}: χ={chi[i]}, m={m_vals[i]}',
            line=dict(dash='dot', width=1),
        ))
    fig_theta.add_trace(go.Scatter(
        x=tau, y=theta_vals, mode='lines',
        name='Θ(τ)', line=dict(color='red', width=3),
    ))
    fig_theta.update_layout(
        title=f'Twisted Theta Function for {mtc_choice}',
        xaxis_title='τ', yaxis_title='Θ(τ)',
        height=500,
    )
    st.plotly_chart(fig_theta, use_container_width=True)

    # Modular transformation check
    st.subheader("Modular Transformation Check")
    st.markdown(r"""
**Lemma:** $\Theta_{\mathcal{C},\chi}(1/\tau) = \varepsilon\,\tau^{1/2}\,\overline{\Theta_{\mathcal{C}^{\sigma},\overline{\chi}}(\tau)}$.
    """)

    tau_check = np.linspace(0.1, 5.0, 500)
    lhs = np.zeros_like(tau_check)
    rhs = np.zeros_like(tau_check)

    for i in range(len(m_vals)):
        lhs += chi[i] * np.exp(-np.pi * (m_vals[i] / D) ** 2 / tau_check)
        # For self-conjugate MTC, Θ_σ,χ̄ = Θ_χ (same data)
        rhs += chi[i] * np.exp(-np.pi * (m_vals[i] / D) ** 2 * tau_check)
    rhs = eps * np.sqrt(tau_check) * rhs

    fig_mod = go.Figure()
    fig_mod.add_trace(go.Scatter(x=tau_check, y=lhs, mode='lines', name='Θ(1/τ)', line=dict(width=2)))
    fig_mod.add_trace(go.Scatter(x=tau_check, y=rhs, mode='lines', name='ε·√τ·Θ̄(τ)',
                                  line=dict(width=2, dash='dash')))
    fig_mod.update_layout(
        title='Modular Transformation Verification',
        xaxis_title='τ', height=400,
    )
    st.plotly_chart(fig_mod, use_container_width=True)

    residual = np.max(np.abs(lhs - rhs))
    if residual < 1e-6:
        st.success(f"Modular transformation verified! Max residual = {residual:.2e}")
    else:
        st.warning(f"Max residual = {residual:.2e} — may need more terms or different MTC.")


# ============================= SECTION 3 ================================
elif section.startswith("3"):
    st.header("§2.4 & §3  Categorical Dirichlet Series")
    st.markdown(r"""
The categorical Dirichlet series is:

$$\Psi_{\mathcal{C},\chi}(s) = \sum_{i} \chi(m_i)\,m_i^{-s}.$$

For the **Ising MTC**: $\Psi(s) = 2 \cdot 4^{-s} - 2^{-s}$

For **$\mathrm{SU}(2)_4$**: $\Psi(s) = 2 \cdot 12^{-s} - 2 \cdot 4^{-s} + 3^{-s}$
    """)

    s_real_range = st.sidebar.slider("σ range", -2.0, 4.0, (-1.0, 3.0))
    t_imag = st.sidebar.slider("t (imaginary part)", -20.0, 20.0, 0.0, step=0.1)

    sigma_arr = np.linspace(s_real_range[0], s_real_range[1], 500)

    psi_vals = np.zeros(len(sigma_arr), dtype=complex)
    for i in range(len(m_vals)):
        s_arr = sigma_arr + 1j * t_imag
        psi_vals += chi[i] * m_vals[i] ** (-s_arr)

    col1, col2 = st.columns(2)

    with col1:
        fig_re = go.Figure()
        fig_re.add_trace(go.Scatter(x=sigma_arr, y=psi_vals.real, mode='lines',
                                     line=dict(color='steelblue', width=2), name='Re Ψ(s)'))
        fig_re.add_hline(y=0, line_dash="dash", line_color="gray")
        fig_re.update_layout(title=f'Re Ψ(σ + {t_imag}i)', xaxis_title='σ',
                             yaxis_title='Re Ψ(s)', height=400)
        st.plotly_chart(fig_re, use_container_width=True)

    with col2:
        fig_im = go.Figure()
        fig_im.add_trace(go.Scatter(x=sigma_arr, y=psi_vals.imag, mode='lines',
                                     line=dict(color='#ef4444', width=2), name='Im Ψ(s)'))
        fig_im.add_hline(y=0, line_dash="dash", line_color="gray")
        fig_im.update_layout(title=f'Im Ψ(σ + {t_imag}i)', xaxis_title='σ',
                             yaxis_title='Im Ψ(s)', height=400)
        st.plotly_chart(fig_im, use_container_width=True)

    # |Ψ(s)| in the complex plane
    st.subheader("|Ψ(s)| in the complex plane")
    sigma_grid = np.linspace(s_real_range[0], s_real_range[1], 200)
    t_grid = np.linspace(-10, 10, 200)
    S_grid, T_grid = np.meshgrid(sigma_grid, t_grid)
    Psi_grid = np.zeros_like(S_grid, dtype=complex)
    for i in range(len(m_vals)):
        Psi_grid += chi[i] * m_vals[i] ** (-(S_grid + 1j * T_grid))

    fig_heat = go.Figure(data=go.Heatmap(
        z=np.log1p(np.abs(Psi_grid)), x=sigma_grid, y=t_grid,
        colorscale='Viridis', colorbar=dict(title='log(1+|Ψ|)'),
    ))
    fig_heat.add_vline(x=0.5, line_dash="dash", line_color="red", annotation_text="σ=1/2")
    fig_heat.update_layout(
        title=f'log(1+|Ψ(s)|) for {mtc_choice}',
        xaxis_title='σ', yaxis_title='t',
        height=500,
    )
    st.plotly_chart(fig_heat, use_container_width=True)


# ============================= SECTION 4 ================================
elif section.startswith("4"):
    st.header("§3 & §5  Functional Equation Verification")
    st.markdown(r"""
**Theorem (Quantum-Egyptian Functional Equation):**

$$\Psi(s)=\varepsilon\!\left(\frac{D^2}{\pi}\right)^{\!s-\frac12}\,
\frac{\Gamma\!\left(\frac{1-s+a}{2}\right)}{\Gamma\!\left(\frac{s+a}{2}\right)}\,
\overline{\Psi_{\mathcal{C}^{\sigma},\overline{\chi}}(1-s)}.$$

We verify this numerically by computing both sides independently.
    """)

    sigma_test = st.sidebar.slider("σ", -2.0, 3.0, 0.5, step=0.01)
    t_test = st.sidebar.slider("t", -10.0, 10.0, 0.0, step=0.1)

    s_test = sigma_test + 1j * t_test

    # LHS: Psi(s)
    psi_s = sum(chi[i] * m_vals[i] ** (-s_test) for i in range(len(m_vals)))

    # RHS components
    psi_1ms = sum(chi[i] * m_vals[i] ** (-(1 - s_test)) for i in range(len(m_vals)))
    psi_1ms_conj = np.conj(psi_1ms)

    gamma_num = gamma_fn((1 - s_test + a_parity) / 2)
    gamma_den = gamma_fn((s_test + a_parity) / 2)
    gamma_ratio = gamma_num / gamma_den

    prefactor = (D_sq / np.pi) ** (s_test - 0.5)

    rhs = eps * prefactor * gamma_ratio * psi_1ms_conj

    st.markdown(f"**Testing at $s = {sigma_test} + {t_test}i$**")

    col1, col2, col3 = st.columns(3)
    with col1:
        st.metric("LHS: Ψ(s)", f"{psi_s:.6f}")
    with col2:
        st.metric("RHS", f"{rhs:.6f}")
    with col3:
        diff = abs(psi_s - rhs)
        st.metric("| LHS − RHS |", f"{diff:.2e}")

    if diff < 1e-8:
        st.success("✅ Functional equation verified!")
    elif diff < 1e-4:
        st.info(f"🔍 Close match (error = {diff:.2e})")
    else:
        st.warning(f"⚠️ Mismatch (error = {diff:.2e}) — may be at a pole of Γ")

    # Sweep verification
    st.subheader("Sweep Verification: |LHS − RHS| across σ")
    sigma_sweep = np.linspace(-1.5, 2.5, 500)
    errors = []
    for sig in sigma_sweep:
        s = sig + 1j * t_test
        lhs = sum(chi[i] * m_vals[i] ** (-s) for i in range(len(m_vals)))
        psi_1 = sum(chi[i] * m_vals[i] ** (-(1 - s)) for i in range(len(m_vals)))
        try:
            gr = gamma_fn((1 - s + a_parity) / 2) / gamma_fn((s + a_parity) / 2)
            pf = (D_sq / np.pi) ** (s - 0.5)
            r = eps * pf * gr * np.conj(psi_1)
            errors.append(abs(lhs - r))
        except:
            errors.append(np.nan)

    fig_err = go.Figure()
    fig_err.add_trace(go.Scatter(x=sigma_sweep, y=errors, mode='lines',
                                  line=dict(color='#ef4444', width=2)))
    fig_err.update_layout(
        title=f'|LHS − RHS| for t = {t_test}  (should be ≈ 0 everywhere)',
        xaxis_title='σ', yaxis_title='|error|',
        yaxis_type='log',
        height=400,
    )
    st.plotly_chart(fig_err, use_container_width=True)

    # Detailed breakdown
    with st.expander("Detailed computation"):
        st.latex(rf"""
        \Psi(s) = \sum_i \chi(m_i)\,m_i^{{-s}} = {psi_s:.6f}
        """)
        st.latex(rf"""
        \Psi(1-s) = \sum_i \chi(m_i)\,m_i^{{-(1-s)}} = {psi_1ms:.6f}
        """)
        st.latex(rf"""
        \frac{{\Gamma((1-s+a)/2)}}{{\Gamma((s+a)/2)}} = \frac{{{gamma_num:.6f}}}{{{gamma_den:.6f}}} = {gamma_ratio:.6f}
        """)
        st.latex(rf"""
        \left(\frac{{D^2}}{{\pi}}\right)^{{s-1/2}} = \left(\frac{{{D_sq}}}{{\pi}}\right)^{{{s_test-0.5:.4f}}} = {prefactor:.6f}
        """)


# ============================= SECTION 5 ================================
elif section.startswith("5"):
    st.header("§9  Riemann Zeta Limit: $\\mathrm{SU}(2)_k \\to \\zeta(2s)$")
    st.markdown(r"""
Consider the tower $\mathcal{C}_k = \mathrm{SU}(2)_k$. As $k \to \infty$, the quantum dimensions
$d_j = \frac{\sin(\pi(j+1)/(k+2))}{\sin(\pi/(k+2))}$ approach the classical dimensions $2j+1$.

The Dirichlet series then approximates:
$$\Psi_k(s) \sim \sum_{j=0}^{k} \frac{1}{(2j+1)^{2s}} \left(\frac{k^3}{3\pi^2}\right)^{-s} \cdot (\text{Galois signs}).$$

If the Galois signs average to 1, after normalising:
$$\frac{\Psi_k(s)}{\Psi_k(1/2)} \longrightarrow \frac{\zeta(2s)}{\zeta(1)}.$$
    """)

    k_val = st.sidebar.slider("Level k", 2, 100, 20, step=2)
    s_real = st.sidebar.slider("σ range for Ψ_k", 0.1, 3.0, (0.5, 2.0))

    # SU(2)_k data
    j_vals = np.arange(0, k_val + 1)
    d_j = np.sin(np.pi * (j_vals + 1) / (k_val + 2)) / np.sin(np.pi / (k_val + 2))
    d_j_sq = d_j ** 2
    D_k_sq = np.sum(d_j_sq)
    m_j = D_k_sq / d_j_sq

    # Simple Galois signs: alternating for demonstration
    chi_j = np.ones(len(j_vals))  # trivial character for limit

    st.subheader(f"SU(2)_{k_val} Data")
    col1, col2 = st.columns(2)

    with col1:
        st.write(f"**Number of simple objects:** {k_val + 1}")
        st.write(f"**$D^2 = $ {D_k_sq:.4f}**")
        st.write(f"**$D^2$ (asymptotic $k^3/(3\\pi^2)$):** {k_val**3 / (3 * np.pi**2):.4f}")

        # Quantum dimensions plot
        fig_d = go.Figure()
        fig_d.add_trace(go.Bar(x=j_vals.tolist(), y=d_j.tolist(), name='d_j (quantum)', marker_color='steelblue'))
        fig_d.add_trace(go.Scatter(x=j_vals.tolist(), y=(2 * j_vals + 1).tolist(), mode='lines+markers',
                                    name='2j+1 (classical)', line=dict(color='red', dash='dash')))
        fig_d.update_layout(title=f'Quantum vs Classical Dimensions for SU(2)_{k_val}',
                            xaxis_title='j', yaxis_title='d_j', height=350)
        st.plotly_chart(fig_d, use_container_width=True)

    with col2:
        # Egyptian denominators
        fig_m = go.Figure()
        fig_m.add_trace(go.Bar(x=j_vals.tolist(), y=m_j.tolist(), name='m_j', marker_color='#22c55e'))
        fig_m.update_layout(title=f'Egyptian Denominators m_j = D²/d_j²',
                            xaxis_title='j', yaxis_title='m_j', height=350)
        st.plotly_chart(fig_m, use_container_width=True)

    # Dirichlet series comparison with zeta(2s)
    st.subheader("$\\Psi_k(s)$ vs $\\zeta(2s)$ (normalised)")
    sigma_arr = np.linspace(s_real[0], s_real[1], 300)

    psi_k = np.zeros(len(sigma_arr))
    for i, sig in enumerate(sigma_arr):
        psi_k[i] = np.sum(chi_j * m_j ** (-sig)).real

    # Normalise by value at s=1
    psi_k_norm = psi_k / psi_k[0] if abs(psi_k[0]) > 1e-10 else psi_k

    # zeta(2s) approximation (partial sum)
    def zeta_approx(s, n_terms=10000):
        return np.sum(np.arange(1, n_terms + 1, dtype=float) ** (-s))

    zeta_2s = np.array([zeta_approx(2 * sig) for sig in sigma_arr])
    zeta_2s_norm = zeta_2s / zeta_2s[0] if abs(zeta_2s[0]) > 1e-10 else zeta_2s

    fig_lim = go.Figure()
    fig_lim.add_trace(go.Scatter(x=sigma_arr, y=psi_k_norm, mode='lines',
                                  line=dict(color='steelblue', width=2),
                                  name=f'Ψ_{k_val}(s) (normalised)'))
    fig_lim.add_trace(go.Scatter(x=sigma_arr, y=zeta_2s_norm, mode='lines',
                                  line=dict(color='red', width=2, dash='dash'),
                                  name='ζ(2s) (normalised)'))
    fig_lim.update_layout(
        title=f'Normalised Ψ_{k_val}(σ) vs ζ(2σ)',
        xaxis_title='σ', yaxis_title='Value (normalised)',
        height=450,
    )
    st.plotly_chart(fig_lim, use_container_width=True)

    # Convergence with k
    st.subheader("Convergence as $k \\to \\infty$")
    k_range = [4, 8, 16, 32, 64]
    sigma_fixed = 1.0

    fig_conv = go.Figure()
    for k in k_range:
        j_v = np.arange(0, k + 1)
        d_v = np.sin(np.pi * (j_v + 1) / (k + 2)) / np.sin(np.pi / (k + 2))
        D2 = np.sum(d_v ** 2)
        m_v = D2 / d_v ** 2

        sig_range = np.linspace(0.6, 2.5, 200)
        psi_v = np.array([np.sum(m_v ** (-s)).real for s in sig_range])
        psi_v_n = psi_v / psi_v[0] if abs(psi_v[0]) > 1e-10 else psi_v

        fig_conv.add_trace(go.Scatter(x=sig_range, y=psi_v_n, mode='lines',
                                       name=f'k={k}', line=dict(width=1)))

    zeta_ref = np.array([zeta_approx(2 * s, 5000) for s in sig_range])
    zeta_ref_n = zeta_ref / zeta_ref[0]
    fig_conv.add_trace(go.Scatter(x=sig_range, y=zeta_ref_n, mode='lines',
                                   name='ζ(2s)', line=dict(color='black', width=3, dash='dash')))
    fig_conv.update_layout(
        title='Convergence of Ψ_k(s) → ζ(2s) as k → ∞',
        xaxis_title='σ', yaxis_title='Normalised value',
        height=450,
    )
    st.plotly_chart(fig_conv, use_container_width=True)


st.markdown("---")
st.markdown(r"""
**Source:** *The Quantum-Egyptian Functional Equation — v8* (March 2026).
Functional equation for Dirichlet series from integral modular tensor categories.
""")
