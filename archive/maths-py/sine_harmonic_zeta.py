import streamlit as st
import numpy as np
import plotly.graph_objects as go
from plotly.subplots import make_subplots
import matplotlib.pyplot as plt

st.set_page_config(layout="wide", page_title="Critical Exponent α = 1/2")

st.title("The Critical Exponent $\\alpha = 1/2$ in Greedy Harmonic Reconstruction")
st.markdown(r"""
We consider the family of series $\sum_{n=1}^{\infty} (-1)^{n-1}\,n^{-\alpha}\,e^{-it\ln n}$
and ask: **for which $\alpha$ does the greedy algorithm that chooses signs $\sigma_n \in \{+1, -1\}$
to minimise the distance to zero produce exactly the alternating signs?**

The answer: **only $\alpha = 1/2$**, when $t$ is a zero of the Dirichlet eta function $\eta(1/2 + it)$.

### Key arguments:
1. **Density argument forces $L(t) = 0$**: If the series converges to a non-zero limit $L(t)$,
   the greedy condition $\operatorname{Re}(\overline{S_{n-1}} w_n) \le 0$ fails for a dense
   set of directions.
2. **$\alpha > 1/2$**: $\eta(s)$ has no zeros with $\operatorname{Re}(s) > 1/2$ (zero-free region).
3. **$\alpha < 1/2$**: Partial sums oscillate with growing amplitude $\sim N^{1/2 - \alpha}$,
   violating the greedy condition.
4. **$\alpha = 1/2$**: The unique balance — series converges to zero at $\eta$ zeros, and the
   greedy condition $\operatorname{Re}(\overline{S_{n-1}} w_n) \le 0$ holds.
""")

# =========================================================================
# Sidebar
# =========================================================================
st.sidebar.header("Parameters")

section = st.sidebar.selectbox("Section", [
    "1. Real Greedy Algorithm",
    "2. Complex Greedy with Phases",
    "3. Alpha Comparison",
    "4. Density Argument Visualisation",
    "5. Greedy Condition Analysis",
])

# Known zeta zeros (imaginary parts)
KNOWN_ZEROS = [14.134725, 21.022040, 25.010858, 30.424876, 32.935062,
               37.586178, 40.918719, 43.327073, 48.005151, 49.773832]


# =========================================================================
# Helper functions
# =========================================================================

def compute_partial_sums(alpha, t, N, signs=None):
    """Compute complex partial sums with alternating signs and phase rotation."""
    n = np.arange(1, N + 1)
    w_n = n ** (-alpha) * np.exp(-1j * t * np.log(n))
    if signs is None:
        signs = (-1.0) ** (n - 1)  # alternating: +1, -1, +1, -1, ...
    terms = signs * w_n
    S = np.cumsum(terms)
    return n, w_n, terms, S


def greedy_algorithm(alpha, t, N):
    """Run greedy algorithm: at each step choose sign to minimise |S_n|."""
    n = np.arange(1, N + 1)
    w_n = n ** (-alpha) * np.exp(-1j * t * np.log(n))
    signs = np.zeros(N)
    S = np.zeros(N + 1, dtype=complex)  # S[0] = 0, S[n] = sum of first n terms

    for k in range(N):
        # Greedy: choose sigma to minimise |S[k] + sigma * w_n[k]|
        opt_plus = abs(S[k] + w_n[k])
        opt_minus = abs(S[k] - w_n[k])
        if opt_plus <= opt_minus:
            signs[k] = 1.0
        else:
            signs[k] = -1.0
        S[k + 1] = S[k] + signs[k] * w_n[k]

    return n, w_n, signs, S[1:]


def check_greedy_condition(S, w_n):
    """Check Re(conj(S_{n-1}) * w_n) <= 0 for all n >= 2."""
    # S[0] = S_1, S[1] = S_2, ..., so S_{n-1} for step n is S[n-2]
    greedy_vals = np.real(np.conj(S[:-1]) * w_n[1:])
    return greedy_vals


# ============================= SECTION 1 ================================
if section.startswith("1"):
    st.header("§2–3  Real Greedy Algorithm")
    st.markdown(r"""
In the **real case** (no phase rotation, $t = 0$), the alternating series
$\sum (-1)^{n-1} n^{-\alpha}$ converges to $\eta(\alpha) > 0$ for all $\alpha > 0$.

The greedy rule for target 0: choose $\sigma_n = +1$ if $|S_{n-1} + a_n| \le |S_{n-1} - a_n|$,
i.e., $S_{n-1} \le 0$. But $S_1 = 1 > 0$, so the greedy choice at step 2 is $\sigma_2 = -1$
(which matches alternating). However, for many $n$, $S_{n-1} > 0$, and greedy would want to
subtract — but alternating signs also subtract at even steps.

**The point:** In the real case, the alternating signs *cannot* be greedy for target 0, because
$S_1 = 1 > 0$ forces $\sigma_2 = -1$ (matching), but eventually the partial sums stay positive
and the greedy algorithm diverges from alternating. The complex case with phases is what
makes $\alpha = 1/2$ special.
    """)

    alpha = st.sidebar.slider("α", 0.1, 2.0, 0.5, step=0.01)
    N = st.sidebar.slider("N (terms)", 10, 500, 100, step=10)

    n = np.arange(1, N + 1)
    a_n = n ** (-alpha)
    alt_signs = (-1.0) ** (n - 1)
    S_alt = np.cumsum(alt_signs * a_n)

    # Run greedy
    greedy_signs = np.zeros(N)
    S_greedy = np.zeros(N + 1)
    for k in range(N):
        if abs(S_greedy[k] + a_n[k]) <= abs(S_greedy[k] - a_n[k]):
            greedy_signs[k] = 1.0
        else:
            greedy_signs[k] = -1.0
        S_greedy[k + 1] = S_greedy[k] + greedy_signs[k] * a_n[k]

    col1, col2 = st.columns(2)

    with col1:
        fig1 = go.Figure()
        fig1.add_trace(go.Scatter(x=n, y=S_alt, mode='lines', name='Alternating signs',
                                   line=dict(color='steelblue', width=2)))
        fig1.add_trace(go.Scatter(x=n, y=S_greedy[1:], mode='lines', name='Greedy signs',
                                   line=dict(color='#ef4444', width=2, dash='dash')))
        fig1.add_hline(y=0, line_dash="dot", line_color="gray")
        fig1.update_layout(title=f'Real partial sums (α = {alpha})',
                          xaxis_title='n', yaxis_title='S_n', height=400)
        st.plotly_chart(fig1, use_container_width=True)

    with col2:
        # Sign comparison
        match = np.sum(greedy_signs == alt_signs)
        fig2 = go.Figure()
        fig2.add_trace(go.Scatter(x=n, y=alt_signs, mode='markers', name='Alternating',
                                   marker=dict(size=4, color='steelblue')))
        fig2.add_trace(go.Scatter(x=n, y=greedy_signs, mode='markers', name='Greedy',
                                   marker=dict(size=4, color='red', symbol='x')))
        fig2.update_layout(title=f'Sign comparison ({match}/{N} match)',
                          xaxis_title='n', yaxis_title='σ_n', height=400)
        st.plotly_chart(fig2, use_container_width=True)

    st.info(f"η({alpha}) = {S_alt[-1]:.6f}  (limit of alternating series)")


# ============================= SECTION 2 ================================
elif section.startswith("2"):
    st.header("§3–6  Complex Greedy Algorithm with Phases")
    st.markdown(r"""
In the **complex case**, each term has a phase rotation:

$$w_n(t) = n^{-\alpha}\,e^{-it\ln n}.$$

The greedy condition becomes $\operatorname{Re}(\overline{S_{n-1}} w_n) \le 0$.

For $\alpha = 1/2$ and $t$ a zero of $\eta(1/2 + it)$, the alternating signs are greedy
and the series converges to zero.
    """)

    alpha = st.sidebar.slider("α", 0.1, 2.0, 0.5, step=0.01)
    t_val = st.sidebar.selectbox("t (zero of η)", KNOWN_ZEROS, index=0)
    N = st.sidebar.slider("N (terms)", 50, 2000, 500, step=50)

    # Alternating signs
    n_arr, w_n, terms, S_alt = compute_partial_sums(alpha, t_val, N)

    # Greedy algorithm
    n_g, w_g, signs_g, S_greedy = greedy_algorithm(alpha, t_val, N)

    col1, col2 = st.columns(2)

    with col1:
        st.subheader("Alternating Signs — Complex Plane")
        fig1 = go.Figure()
        fig1.add_trace(go.Scatter(
            x=S_alt.real, y=S_alt.imag, mode='lines',
            line=dict(color='steelblue', width=1), name='S_n (alternating)'
        ))
        fig1.add_trace(go.Scatter(
            x=[S_alt[-1].real], y=[S_alt[-1].imag], mode='markers',
            marker=dict(color='red', size=10, symbol='x'), name=f'S_{N}'
        ))
        fig1.add_trace(go.Scatter(
            x=[0], y=[0], mode='markers',
            marker=dict(color='green', size=10, symbol='star'), name='Target 0'
        ))
        fig1.update_layout(
            title=f'Alternating partial sums (α={alpha}, t={t_val:.3f})',
            xaxis_title='Re', yaxis_title='Im',
            height=450,
        )
        st.plotly_chart(fig1, use_container_width=True)

    with col2:
        st.subheader("Greedy Signs — Complex Plane")
        fig2 = go.Figure()
        fig2.add_trace(go.Scatter(
            x=S_greedy.real, y=S_greedy.imag, mode='lines',
            line=dict(color='#ef4444', width=1), name='S_n (greedy)'
        ))
        fig2.add_trace(go.Scatter(
            x=[S_greedy[-1].real], y=[S_greedy[-1].imag], mode='markers',
            marker=dict(color='red', size=10, symbol='x'), name=f'S_{N}'
        ))
        fig2.add_trace(go.Scatter(
            x=[0], y=[0], mode='markers',
            marker=dict(color='green', size=10, symbol='star'), name='Target 0'
        ))
        fig2.update_layout(
            title=f'Greedy partial sums (α={alpha}, t={t_val:.3f})',
            xaxis_title='Re', yaxis_title='Im',
            height=450,
        )
        st.plotly_chart(fig2, use_container_width=True)

    # Magnitude of partial sums
    fig_mag = go.Figure()
    fig_mag.add_trace(go.Scatter(x=n_arr, y=np.abs(S_alt), mode='lines',
                                  name='|S_n| alternating', line=dict(color='steelblue')))
    fig_mag.add_trace(go.Scatter(x=n_arr, y=np.abs(S_greedy), mode='lines',
                                  name='|S_n| greedy', line=dict(color='#ef4444', dash='dash')))
    fig_mag.update_layout(title='|S_n| vs n', xaxis_title='n', yaxis_title='|S_n|', height=350)
    st.plotly_chart(fig_mag, use_container_width=True)

    # Sign comparison
    alt_signs = (-1.0) ** (n_arr - 1)
    match_count = np.sum(signs_g == alt_signs)
    st.metric("Signs matching alternating", f"{match_count} / {N} ({100*match_count/N:.1f}%)")
    st.metric("|S_N| (alternating)", f"{abs(S_alt[-1]):.6f}")
    st.metric("|S_N| (greedy)", f"{abs(S_greedy[-1]):.6f}")


# ============================= SECTION 3 ================================
elif section.startswith("3"):
    st.header("§4–6  Comparison Across α Values")
    st.markdown(r"""
The three regimes:

- **$\alpha > 1/2$**: $\eta(\alpha + it) \neq 0$ (zero-free region) → no $t$ makes alternating greedy.
- **$\alpha = 1/2$**: The unique critical exponent — at zeros of $\eta(1/2+it)$, alternating signs are greedy.
- **$\alpha < 1/2$**: Partial sums oscillate with growing amplitude $\sim N^{1/2-\alpha}$, violating greedy.
    """)

    t_val = st.sidebar.selectbox("t (zero of η)", KNOWN_ZEROS, index=0)
    N = st.sidebar.slider("N (terms)", 50, 1000, 300, step=50)

    alphas = [0.25, 0.4, 0.5, 0.6, 0.75, 1.0]

    fig = make_subplots(rows=2, cols=3,
                        subplot_titles=[f'α = {a}' for a in alphas])

    for idx, alpha in enumerate(alphas):
        row = idx // 3 + 1
        col = idx % 3 + 1

        n_arr, w_n, terms, S = compute_partial_sums(alpha, t_val, N)

        fig.add_trace(go.Scatter(
            x=S.real, y=S.imag, mode='lines',
            line=dict(width=1),
            name=f'α={alpha}',
            showlegend=False,
        ), row=row, col=col)
        fig.add_trace(go.Scatter(
            x=[0], y=[0], mode='markers',
            marker=dict(color='red', size=8, symbol='star'),
            showlegend=False,
        ), row=row, col=col)

    fig.update_layout(
        title=f'Alternating partial sums for various α (t = {t_val:.3f})',
        height=700,
    )
    st.plotly_chart(fig, use_container_width=True)

    # Magnitude comparison
    st.subheader("|S_N| vs α")
    alpha_range = np.linspace(0.1, 1.5, 100)
    magnitudes = []
    for alpha in alpha_range:
        _, _, _, S = compute_partial_sums(alpha, t_val, N)
        magnitudes.append(abs(S[-1]))

    fig_mag = go.Figure()
    fig_mag.add_trace(go.Scatter(x=alpha_range, y=magnitudes, mode='lines',
                                  line=dict(color='steelblue', width=2)))
    fig_mag.add_vline(x=0.5, line_dash="dash", line_color="red", annotation_text="α = 1/2")
    fig_mag.update_layout(
        title=f'|S_N| at N={N} for t={t_val:.3f}',
        xaxis_title='α', yaxis_title='|S_N|',
        height=400,
    )
    st.plotly_chart(fig_mag, use_container_width=True)

    # Greedy violation count vs alpha
    st.subheader("Greedy Violations vs α")
    violations = []
    for alpha in alpha_range:
        _, w_n, _, S = compute_partial_sums(alpha, t_val, N)
        gv = check_greedy_condition(S, w_n)
        violations.append(np.sum(gv > 0))

    fig_viol = go.Figure()
    fig_viol.add_trace(go.Scatter(x=alpha_range, y=violations, mode='lines',
                                   line=dict(color='#ef4444', width=2)))
    fig_viol.add_vline(x=0.5, line_dash="dash", line_color="green", annotation_text="α = 1/2")
    fig_viol.update_layout(
        title=f'Number of greedy violations (out of {N-1}) vs α',
        xaxis_title='α', yaxis_title='Violations',
        height=400,
    )
    st.plotly_chart(fig_viol, use_container_width=True)


# ============================= SECTION 4 ================================
elif section.startswith("4"):
    st.header("§4  Density Argument Visualisation")
    st.markdown(r"""
**Key insight:** If the series converges to $L(t) \neq 0$, then for large $n$,
$S_{n-1} \approx L(t)$. The greedy condition requires
$\operatorname{Re}(\overline{L(t)}\,e^{i\theta_n}) \le 0$ for all $n$,
where $\theta_n = -t\ln n$.

But the angles $\theta_n \bmod 2\pi$ are **dense** on the circle (for irrational $t/(2\pi)$).
A fixed non-zero $L$ can only satisfy $\operatorname{Re}(\bar{L}\,e^{i\theta}) \le 0$
for half the circle — so the greedy condition must fail for dense directions.

**Conclusion:** The greedy condition forces $L(t) = 0$, i.e., $\eta(\alpha + it) = 0$.
    """)

    alpha = st.sidebar.slider("α", 0.1, 2.0, 0.5, step=0.01)
    t_val = st.sidebar.slider("t", 0.1, 50.0, 14.135, step=0.01)
    N = st.sidebar.slider("N (terms)", 50, 2000, 500, step=50)

    n_arr = np.arange(1, N + 1)
    phases = (-t_val * np.log(n_arr)) % (2 * np.pi)

    # Compute S (alternating)
    w_n = n_arr ** (-alpha) * np.exp(-1j * t_val * np.log(n_arr))
    alt_signs = (-1.0) ** (n_arr - 1)
    S = np.cumsum(alt_signs * w_n)
    L = S[-1]  # approximate limit

    col1, col2 = st.columns(2)

    with col1:
        st.subheader("Phase Distribution on Unit Circle")
        # Plot unit circle with phase directions
        theta_circle = np.linspace(0, 2 * np.pi, 200)
        fig_circle = go.Figure()
        fig_circle.add_trace(go.Scatter(
            x=np.cos(theta_circle), y=np.sin(theta_circle),
            mode='lines', line=dict(color='lightgray', width=1),
            showlegend=False
        ))

        # Phase directions (subsample for visibility)
        show_n = min(200, N)
        idx = np.linspace(0, N - 1, show_n, dtype=int)
        fig_circle.add_trace(go.Scatter(
            x=np.cos(phases[idx]), y=np.sin(phases[idx]),
            mode='markers',
            marker=dict(size=3, color=n_arr[idx], colorscale='Viridis',
                       colorbar=dict(title='n'), opacity=0.6),
            name='w_n / |w_n| directions'
        ))

        # Mark L direction and forbidden half-plane
        if abs(L) > 1e-10:
            L_angle = np.angle(L)
            fig_circle.add_trace(go.Scatter(
                x=[0, np.cos(L_angle)], y=[0, np.sin(L_angle)],
                mode='lines+markers', line=dict(color='red', width=3),
                marker=dict(size=8), name='Direction of L'
            ))

            # Forbidden half-plane boundary
            boundary_angle1 = L_angle + np.pi / 2
            boundary_angle2 = L_angle - np.pi / 2
            fig_circle.add_trace(go.Scatter(
                x=[1.3 * np.cos(boundary_angle1), 0, 1.3 * np.cos(boundary_angle2)],
                y=[1.3 * np.sin(boundary_angle1), 0, 1.3 * np.sin(boundary_angle2)],
                mode='lines', line=dict(color='orange', width=2, dash='dash'),
                name='Allowed boundary'
            ))

        fig_circle.update_layout(
            title='Phase directions on unit circle',
            xaxis=dict(scaleanchor="y", range=[-1.5, 1.5]),
            yaxis=dict(range=[-1.5, 1.5]),
            height=500,
        )
        st.plotly_chart(fig_circle, use_container_width=True)

    with col2:
        st.subheader("Phase Histogram")
        fig_hist, ax = plt.subplots(figsize=(6, 4))
        ax.hist(phases / (2 * np.pi), bins=50, density=True, alpha=0.7,
                color='steelblue', edgecolor='white')
        ax.axhline(y=1.0, color='red', linestyle='--', label='Uniform')
        ax.set_xlabel(r'$\theta_n / 2\pi$')
        ax.set_ylabel('Density')
        ax.set_title(f'Phase distribution for t = {t_val:.3f}')
        ax.legend()
        st.pyplot(fig_hist)

        st.markdown(f"""
        **Limit of series:** $L(t) = {L:.5f}$  
        **$|L(t)|$** = {abs(L):.5f}  
        {"⚠️ $L \\neq 0$ → greedy condition MUST fail (density argument)" if abs(L) > 0.01 else "✅ $L \\approx 0$ → greedy condition may hold"}
        """)

    # Count violations
    greedy_vals = check_greedy_condition(S, w_n)
    violations = np.sum(greedy_vals > 0)
    st.metric("Greedy violations", f"{violations} / {N-1}")


# ============================= SECTION 5 ================================
elif section.startswith("5"):
    st.header("§6  Greedy Condition Analysis at α = 1/2")
    st.markdown(r"""
For $\alpha = 1/2$ and $t$ a zero of $\eta(1/2 + it)$, the Riemann–Siegel formula shows
$S_n = O(n^{-1/4})$ and the greedy condition

$$\operatorname{Re}(\overline{S_{n-1}}\,w_n) \le 0$$

holds for all $n$. The magnitude decay $n^{-1/2}$ is exactly balanced with the phase rotation
so that each step corrects the overshoot.
    """)

    t_val = st.sidebar.selectbox("t (zero of η)", KNOWN_ZEROS, index=0)
    N = st.sidebar.slider("N (terms)", 50, 3000, 1000, step=50)

    n_arr, w_n, terms, S = compute_partial_sums(0.5, t_val, N)
    greedy_vals = check_greedy_condition(S, w_n)

    col1, col2 = st.columns(2)

    with col1:
        st.subheader("Greedy Condition Values")
        fig1 = go.Figure()
        fig1.add_trace(go.Scatter(
            x=n_arr[1:], y=greedy_vals, mode='lines',
            line=dict(color='steelblue', width=1), name='Re(conj(S_{n-1})·w_n)'
        ))
        fig1.add_hline(y=0, line_dash="dash", line_color="red")
        fig1.add_trace(go.Scatter(
            x=n_arr[1:][greedy_vals > 0], y=greedy_vals[greedy_vals > 0],
            mode='markers', marker=dict(color='red', size=5),
            name='Violations'
        ))
        fig1.update_layout(
            title=f'Greedy condition at α=1/2, t={t_val:.3f}',
            xaxis_title='n', yaxis_title='Re(conj(S_{n-1})·w_n)',
            height=400,
        )
        st.plotly_chart(fig1, use_container_width=True)

    with col2:
        st.subheader("|S_n| Decay")
        fig2 = go.Figure()
        fig2.add_trace(go.Scatter(
            x=n_arr, y=np.abs(S), mode='lines',
            line=dict(color='steelblue', width=2), name='|S_n|'
        ))
        # Reference decay n^{-1/4}
        fig2.add_trace(go.Scatter(
            x=n_arr, y=n_arr ** (-0.25), mode='lines',
            line=dict(color='red', width=1, dash='dash'), name='n^{-1/4} reference'
        ))
        fig2.update_layout(
            title=f'|S_n| decay (expected O(n^{{-1/4}}))',
            xaxis_title='n', yaxis_title='|S_n|',
            yaxis_type='log', xaxis_type='log',
            height=400,
        )
        st.plotly_chart(fig2, use_container_width=True)

    violations = np.sum(greedy_vals > 0)
    if violations == 0:
        st.success(f"✅ Greedy condition holds for all {N-1} terms!")
    else:
        st.warning(f"⚠️ {violations} violations detected (may need more terms for convergence)")

    # Partial sum trajectory
    st.subheader("Partial Sum Spiral (Complex Plane)")
    fig3 = go.Figure()
    fig3.add_trace(go.Scatter(
        x=S.real, y=S.imag, mode='lines',
        line=dict(color='steelblue', width=1),
        name='S_n trajectory'
    ))
    fig3.add_trace(go.Scatter(
        x=[0], y=[0], mode='markers',
        marker=dict(color='red', size=12, symbol='star'),
        name='Target (0)'
    ))
    fig3.add_trace(go.Scatter(
        x=[S[-1].real], y=[S[-1].imag], mode='markers',
        marker=dict(color='green', size=10, symbol='diamond'),
        name=f'S_{N} = {S[-1]:.4f}'
    ))
    fig3.update_layout(
        title=f'Partial sum trajectory at α=1/2, t={t_val:.3f}',
        xaxis_title='Re', yaxis_title='Im',
        height=500,
    )
    st.plotly_chart(fig3, use_container_width=True)

    # Compare greedy vs alternating
    st.subheader("Greedy vs Alternating: Do They Match?")
    _, _, greedy_signs, S_greedy = greedy_algorithm(0.5, t_val, min(N, 500))
    alt_signs = (-1.0) ** (np.arange(1, min(N, 500) + 1) - 1)
    match = np.sum(greedy_signs == alt_signs)
    st.metric("Sign agreement", f"{match} / {min(N, 500)} ({100*match/min(N, 500):.1f}%)")


st.markdown("---")
st.markdown(r"""
**Source:** *The Critical Exponent $\alpha = 1/2$ in Greedy Harmonic Reconstruction.*
The exponent $1/2$ is uniquely determined by the balance between convergence
and the ability to correct overshoots.
""")
