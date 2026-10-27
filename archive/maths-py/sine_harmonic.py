import streamlit as st
import numpy as np
import plotly.graph_objects as go
from plotly.subplots import make_subplots
import math

st.set_page_config(layout="wide", page_title="Geometric Sine Reconstruction")

st.title("A Purely Geometric Reconstruction of the Sine Function")
st.markdown(r"""
**Trigonometric-free algorithm that reconstructs $\sin(\theta)$ using only the
Pythagorean theorem, unit circle geometry, and greedy selection of harmonic fractions of $90°$.**

### Main Theorem

Define the sequences:

$$s_0 = 0, \quad
\delta_n(x) = \Theta\!\left(\pi|x| - \sum_{j=0}^{n-1}\delta_j\frac{\pi}{j+2} - \frac{\pi}{n+2}\right) \in \{0,1\}$$

$$h_n = \mathrm{dyadic\_sin}\!\left(\frac{1}{n+2}\right), \quad
s_{n+1} = s_n + \delta_n\bigl(h_n\sqrt{1-s_n^2} + s_n\sqrt{1-h_n^2}\bigr)$$

Then for any real $x$:

$$\boxed{\sin(\pi x) = \operatorname{sgn}(x)\lim_{n\to\infty} s_n\bigl(|x| \bmod 2\bigr)}$$

The update formula is the angle-addition identity $\sin(\alpha+\beta) = \sin\alpha\cos\beta + \cos\alpha\sin\beta$,
computed using **only square roots** (Pythagorean theorem: $\cos = \sqrt{1 - \sin^2}$).

> *First published by Victor Geere in 2020.*  
> *Original JS implementation: [victorgeere.co.za/sine](https://victorgeere.co.za/sine/index.html)*
""")

# =========================================================================
# Core algorithms
# =========================================================================

def dyadic_sin(fraction, levels=20):
    """
    Compute sin(fraction * π) using only the Pythagorean theorem.
    Starts from sin(π/2) = 1 and repeatedly halves the angle using
    the half-angle formula: sin(θ/2) = √((1 - cos θ)/2).
    Then reconstructs the target via angle-addition identities.
    """
    # Build a table of sin(π / 2^k) for k = 1, 2, ..., levels
    # sin(π/2) = 1
    sin_table = [1.0]  # sin(π/2) = sin(π · 1/2)
    cos_table = [0.0]  # cos(π/2) = 0

    for k in range(1, levels + 1):
        # Half-angle: sin(θ/2) = √((1 - cosθ) / 2)
        cos_prev = cos_table[-1]
        sin_half = math.sqrt((1 - cos_prev) / 2)
        cos_half = math.sqrt((1 + cos_prev) / 2)
        sin_table.append(sin_half)
        cos_table.append(cos_half)

    # Now sin_table[k] = sin(π / 2^(k+1)) (approximately)
    # Actually: sin_table[0] = sin(π/2), sin_table[1] = sin(π/4), etc.

    # Express fraction as a binary expansion and reconstruct
    # fraction is in [0, 1], representing fraction * π
    # We greedily decompose: fraction = sum of 1/2^k terms
    target = fraction
    result_sin = 0.0
    result_cos = 1.0

    for k in range(len(sin_table)):
        power = 1.0 / (2 ** (k + 1))  # This represents π · power
        if target >= power - 1e-15:
            target -= power
            # Angle addition: sin(α + β) = sinα cosβ + cosα sinβ
            new_sin = result_sin * cos_table[k] + result_cos * sin_table[k]
            new_cos = result_cos * cos_table[k] - result_sin * sin_table[k]
            result_sin = new_sin
            result_cos = new_cos
            if target < 1e-15:
                break

    return result_sin


def greedy_sine(x, max_iterations=200, dyadic_levels=20):
    """
    Reconstruct sin(π·x) using the greedy harmonic algorithm.

    At each step n, we try to add the angle π/(n+2). If the accumulated
    angle plus π/(n+2) does not exceed the target π·|x|, we accept (δ_n = 1).

    Returns: (approximation, steps_taken, angle_accumulated, delta_history)
    """
    # Handle symmetry
    sign = 1.0 if x >= 0 else -1.0
    x_mod = abs(x) % 2.0

    # Map to [0, 1] using sin(π - θ) = sin(θ)
    if x_mod > 1.0:
        x_mod = 2.0 - x_mod
        sign *= -1.0  # sin is negative in [π, 2π]

    target_angle = x_mod  # in units of π

    s = 0.0  # current sin value
    accumulated = 0.0  # accumulated angle in units of π
    deltas = []

    for n in range(max_iterations):
        step_angle = 1.0 / (n + 2)  # angle = π/(n+2) in units of π

        if accumulated + step_angle <= target_angle + 1e-12:
            # Accept this step (δ_n = 1)
            deltas.append(1)
            h_n = dyadic_sin(step_angle, levels=dyadic_levels)
            cos_s = math.sqrt(max(0, 1 - s * s))
            cos_h = math.sqrt(max(0, 1 - h_n * h_n))

            # Angle addition: sin(α + β) = sinα cosβ + cosα sinβ
            s_new = s * cos_h + cos_s * h_n
            s = s_new
            accumulated += step_angle
        else:
            deltas.append(0)

        if abs(accumulated - target_angle) < 1e-14:
            break

    return sign * s, len(deltas), accumulated, deltas


def greedy_sine_trace(x, max_iterations=200, dyadic_levels=20):
    """Same as greedy_sine but returns full trace of s values."""
    sign = 1.0 if x >= 0 else -1.0
    x_mod = abs(x) % 2.0
    if x_mod > 1.0:
        x_mod = 2.0 - x_mod
        sign *= -1.0

    target_angle = x_mod
    s = 0.0
    accumulated = 0.0
    s_trace = [0.0]
    angle_trace = [0.0]
    deltas = []

    for n in range(max_iterations):
        step_angle = 1.0 / (n + 2)
        if accumulated + step_angle <= target_angle + 1e-12:
            deltas.append(1)
            h_n = dyadic_sin(step_angle, levels=dyadic_levels)
            cos_s = math.sqrt(max(0, 1 - s * s))
            cos_h = math.sqrt(max(0, 1 - h_n * h_n))
            s = s * cos_h + cos_s * h_n
            accumulated += step_angle
        else:
            deltas.append(0)

        s_trace.append(sign * s)
        angle_trace.append(accumulated)

    return s_trace, angle_trace, deltas


# =========================================================================
# Sidebar
# =========================================================================
st.sidebar.header("Parameters")

section = st.sidebar.selectbox("Section", [
    "1. Dyadic Sine Subroutine",
    "2. Greedy Reconstruction Step-by-Step",
    "3. Full 360° Sine Wave",
    "4. Convergence Analysis",
    "5. Harmonic Fraction Decomposition",
])


# ============================= SECTION 1 ================================
if section.startswith("1"):
    st.header("Dyadic Sine Subroutine")
    st.markdown(r"""
The `dyadic_sin` function computes $\sin(\text{fraction} \cdot \pi)$ using **only square roots**.

**Algorithm:**
1. Start from $\sin(\pi/2) = 1$, $\cos(\pi/2) = 0$.
2. Repeatedly apply the **half-angle formula**: $\sin(\theta/2) = \sqrt{(1-\cos\theta)/2}$.
3. Express the target fraction as a binary sum $\sum 1/2^k$ and compose via **angle-addition**:
   $\sin(\alpha+\beta) = \sin\alpha\cos\beta + \cos\alpha\sin\beta$, where $\cos = \sqrt{1-\sin^2}$.

No trigonometric functions are used — only $+$, $-$, $\times$, $\div$, and $\sqrt{\cdot}$.
    """)

    levels = st.sidebar.slider("Dyadic levels", 5, 30, 20)

    # Comparison table
    fractions = [1/2, 1/3, 1/4, 1/5, 1/6, 1/7, 1/8, 1/10, 1/12, 1/16, 1/20]
    st.subheader("Accuracy of dyadic_sin")

    data = []
    for f in fractions:
        ds = dyadic_sin(f, levels=levels)
        exact = math.sin(f * math.pi)
        err = abs(ds - exact)
        data.append({
            "Fraction": f"1/{int(1/f)}" if abs(1/f - round(1/f)) < 0.01 else f"{f:.4f}",
            "sin(frac·π) exact": f"{exact:.12f}",
            "dyadic_sin": f"{ds:.12f}",
            "Error": f"{err:.2e}",
        })

    import pandas as pd
    st.dataframe(pd.DataFrame(data), use_container_width=True, hide_index=True)

    # Continuous comparison
    st.subheader("Continuous Comparison: dyadic_sin vs sin")
    x_vals = np.linspace(0, 1, 500)
    dyadic_vals = [dyadic_sin(xv, levels=levels) for xv in x_vals]
    exact_vals = [math.sin(xv * math.pi) for xv in x_vals]
    errors = [abs(d - e) for d, e in zip(dyadic_vals, exact_vals)]

    col1, col2 = st.columns(2)

    with col1:
        fig1 = go.Figure()
        fig1.add_trace(go.Scatter(x=x_vals, y=exact_vals, mode='lines',
                                   name='sin(x·π)', line=dict(color='steelblue', width=2)))
        fig1.add_trace(go.Scatter(x=x_vals, y=dyadic_vals, mode='lines',
                                   name='dyadic_sin(x)', line=dict(color='red', width=2, dash='dash')))
        fig1.update_layout(title='dyadic_sin vs sin', xaxis_title='x', yaxis_title='Value', height=400)
        st.plotly_chart(fig1, use_container_width=True)

    with col2:
        fig2 = go.Figure()
        fig2.add_trace(go.Scatter(x=x_vals, y=errors, mode='lines',
                                   line=dict(color='#ef4444', width=2)))
        fig2.update_layout(title='Absolute Error', xaxis_title='x', yaxis_title='|Error|',
                          yaxis_type='log', height=400)
        st.plotly_chart(fig2, use_container_width=True)

    # Half-angle table
    st.subheader("Half-Angle Table (built by repeated halving)")
    sin_table = [1.0]
    cos_table = [0.0]
    for k in range(1, levels + 1):
        cos_prev = cos_table[-1]
        sin_half = math.sqrt((1 - cos_prev) / 2)
        cos_half = math.sqrt((1 + cos_prev) / 2)
        sin_table.append(sin_half)
        cos_table.append(cos_half)

    table_data = []
    for k in range(min(levels + 1, 15)):
        angle = math.pi / (2 ** (k + 1))
        table_data.append({
            "k": k,
            "Angle (rad)": f"π/{2**(k+1)}",
            "sin (Pythag.)": f"{sin_table[k]:.10f}",
            "sin (exact)": f"{math.sin(angle):.10f}",
            "cos (Pythag.)": f"{cos_table[k]:.10f}",
        })
    st.dataframe(pd.DataFrame(table_data), use_container_width=True, hide_index=True)


# ============================= SECTION 2 ================================
elif section.startswith("2"):
    st.header("Greedy Reconstruction Step-by-Step")
    st.markdown(r"""
At each step $n$, the algorithm decides whether to add the harmonic angle $\pi/(n+2)$:

$$\delta_n = \begin{cases} 1 & \text{if } \text{accumulated} + \frac{\pi}{n+2} \le \text{target} \\ 0 & \text{otherwise} \end{cases}$$

When $\delta_n = 1$, the update uses **only the Pythagorean theorem**:

$$s_{n+1} = s_n\sqrt{1-h_n^2} + h_n\sqrt{1-s_n^2}$$

where $h_n = \text{dyadic\_sin}(1/(n+2))$.
    """)

    x_target = st.sidebar.slider("Target x (sin(πx))", 0.0, 1.0, 0.3, step=0.01)
    max_iter = st.sidebar.slider("Max iterations", 10, 500, 100, step=10)
    dyadic_levels = st.sidebar.slider("Dyadic levels", 5, 25, 15)

    s_trace, angle_trace, deltas = greedy_sine_trace(x_target, max_iter, dyadic_levels)
    exact = math.sin(x_target * math.pi)

    col1, col2 = st.columns(2)

    with col1:
        st.subheader("Convergence of $s_n$")
        fig1 = go.Figure()
        fig1.add_trace(go.Scatter(
            x=list(range(len(s_trace))), y=s_trace, mode='lines+markers',
            marker=dict(size=3), line=dict(color='steelblue'),
            name='s_n'
        ))
        fig1.add_hline(y=exact, line_dash="dash", line_color="red",
                       annotation_text=f"sin({x_target}π) = {exact:.6f}")
        fig1.update_layout(
            title=f'Greedy reconstruction of sin({x_target}π)',
            xaxis_title='Step n', yaxis_title='s_n',
            height=400,
        )
        st.plotly_chart(fig1, use_container_width=True)

    with col2:
        st.subheader("Accumulated Angle")
        fig2 = go.Figure()
        fig2.add_trace(go.Scatter(
            x=list(range(len(angle_trace))), y=angle_trace, mode='lines+markers',
            marker=dict(size=3), line=dict(color='#22c55e'),
            name='Accumulated (units of π)'
        ))
        fig2.add_hline(y=x_target, line_dash="dash", line_color="red",
                       annotation_text=f"Target = {x_target}π")
        fig2.update_layout(
            title='Accumulated angle (units of π)',
            xaxis_title='Step n', yaxis_title='Angle / π',
            height=400,
        )
        st.plotly_chart(fig2, use_container_width=True)

    # Delta sequence
    st.subheader("Greedy Decisions δ_n")
    accepted = [i for i, d in enumerate(deltas) if d == 1]
    angles_used = [f"π/{i+2}" for i in accepted]

    fig_delta = go.Figure()
    fig_delta.add_trace(go.Bar(
        x=list(range(len(deltas))), y=deltas,
        marker_color=['#22c55e' if d == 1 else '#e5e7eb' for d in deltas],
    ))
    fig_delta.update_layout(
        title=f'δ_n sequence ({sum(deltas)} accepted out of {len(deltas)})',
        xaxis_title='Step n', yaxis_title='δ_n',
        height=250,
    )
    st.plotly_chart(fig_delta, use_container_width=True)

    st.write(f"**Angles used:** {', '.join(angles_used[:30])}{'...' if len(angles_used) > 30 else ''}")
    st.write(f"**Final s_n = {s_trace[-1]:.10f}**")
    st.write(f"**Exact sin({x_target}π) = {exact:.10f}**")
    st.write(f"**Error = {abs(s_trace[-1] - exact):.2e}**")


# ============================= SECTION 3 ================================
elif section.startswith("3"):
    st.header("Full 360° Sine Wave from Pythagoras")
    st.markdown(r"""
The complete sine wave over $[-2, 2]$ (i.e., $[-2\pi, 2\pi]$ in angle),
reconstructed using **nothing but square roots and addition**. The greedy
algorithm with harmonic fractions $\pi/(n+2)$ converges to $\sin(\pi x)$
for every $x$.

The two curves (geometric reconstruction vs `math.sin`) are visually indistinguishable.
    """)

    n_points = st.sidebar.slider("Number of points", 50, 500, 200, step=50)
    max_iter = st.sidebar.slider("Max iterations per point", 50, 500, 200, step=50)
    dyadic_levels = st.sidebar.slider("Dyadic levels", 5, 25, 15)

    x_vals = np.linspace(-2, 2, n_points)

    with st.spinner("Computing geometric sine reconstruction..."):
        geo_vals = [greedy_sine(xv, max_iter, dyadic_levels)[0] for xv in x_vals]
    exact_vals = [math.sin(xv * math.pi) for xv in x_vals]
    errors = [abs(g - e) for g, e in zip(geo_vals, exact_vals)]

    fig = make_subplots(rows=2, cols=1, row_heights=[0.7, 0.3],
                        subplot_titles=["Sine Reconstruction", "Absolute Error"],
                        vertical_spacing=0.12)

    fig.add_trace(go.Scatter(x=x_vals, y=exact_vals, mode='lines',
                              name='sin(πx) [exact]',
                              line=dict(color='steelblue', width=3)), row=1, col=1)
    fig.add_trace(go.Scatter(x=x_vals, y=geo_vals, mode='lines',
                              name='Geometric reconstruction',
                              line=dict(color='red', width=2, dash='dash')), row=1, col=1)

    fig.add_trace(go.Scatter(x=x_vals, y=errors, mode='lines',
                              name='|Error|', line=dict(color='#ef4444', width=2)), row=2, col=1)

    fig.update_layout(height=700, title='Full 360° Sine Wave from Pythagoras Alone')
    fig.update_xaxes(title_text='x', row=2, col=1)
    fig.update_yaxes(title_text='sin(πx)', row=1, col=1)
    fig.update_yaxes(title_text='|Error|', type='log', row=2, col=1)
    st.plotly_chart(fig, use_container_width=True)

    max_err = max(errors)
    avg_err = sum(errors) / len(errors)
    st.markdown(f"""
    **Max error:** {max_err:.2e}  |  **Average error:** {avg_err:.2e}  |  
    **Iterations per point:** {max_iter}  |  **Dyadic levels:** {dyadic_levels}
    """)


# ============================= SECTION 4 ================================
elif section.startswith("4"):
    st.header("Convergence Analysis")
    st.markdown(r"""
The error at step $n$ is bounded by $\pi/(n+2)$ (the remaining gap in angle).
Since the harmonic series $\sum 1/k$ diverges, the algorithm can reach any target angle.
The convergence rate is approximately $O(1/n)$.
    """)

    x_target = st.sidebar.slider("Target x", 0.01, 0.99, 0.3, step=0.01)
    max_iter = st.sidebar.slider("Max iterations", 50, 1000, 300, step=50)

    s_trace, angle_trace, deltas = greedy_sine_trace(x_target, max_iter, 20)
    exact = math.sin(x_target * math.pi)
    errors = [abs(s - exact) for s in s_trace]

    col1, col2 = st.columns(2)

    with col1:
        fig1 = go.Figure()
        fig1.add_trace(go.Scatter(
            x=list(range(len(errors))), y=errors, mode='lines',
            line=dict(color='steelblue', width=2), name='|s_n − sin(πx)|'
        ))
        # Reference 1/n decay
        n_ref = np.arange(2, len(errors) + 1)
        fig1.add_trace(go.Scatter(
            x=n_ref.tolist(), y=(1.0 / n_ref).tolist(), mode='lines',
            line=dict(color='red', dash='dash', width=1), name='1/n reference'
        ))
        fig1.update_layout(
            title=f'Error convergence (x = {x_target})',
            xaxis_title='Step n', yaxis_title='|Error|',
            yaxis_type='log', xaxis_type='log',
            height=400,
        )
        st.plotly_chart(fig1, use_container_width=True)

    with col2:
        # Angle gap
        angle_gaps = [x_target - a for a in angle_trace]
        fig2 = go.Figure()
        fig2.add_trace(go.Scatter(
            x=list(range(len(angle_gaps))), y=angle_gaps, mode='lines',
            line=dict(color='#22c55e', width=2), name='Target − accumulated'
        ))
        fig2.add_hline(y=0, line_dash="dot", line_color="gray")
        fig2.update_layout(
            title='Angle gap (target − accumulated)',
            xaxis_title='Step n', yaxis_title='Gap (units of π)',
            height=400,
        )
        st.plotly_chart(fig2, use_container_width=True)

    # Convergence across multiple targets
    st.subheader("Convergence Across Multiple Targets")
    targets = [0.1, 0.25, 0.33, 0.5, 0.7, 0.9]
    fig3 = go.Figure()
    for xt in targets:
        tr, _, _ = greedy_sine_trace(xt, max_iter, 20)
        ex = math.sin(xt * math.pi)
        errs = [abs(s - ex) for s in tr]
        fig3.add_trace(go.Scatter(
            x=list(range(len(errs))), y=errs, mode='lines',
            name=f'x = {xt}', line=dict(width=1.5)
        ))
    fig3.update_layout(
        title='Error convergence for various targets',
        xaxis_title='Step n', yaxis_title='|Error|',
        yaxis_type='log',
        height=450,
    )
    st.plotly_chart(fig3, use_container_width=True)


# ============================= SECTION 5 ================================
elif section.startswith("5"):
    st.header("Harmonic Fraction Decomposition")
    st.markdown(r"""
The algorithm decomposes any angle $\theta$ as a greedy sum of harmonic fractions:

$$\theta \approx \sum_{n : \delta_n = 1} \frac{\pi}{n+2}$$

This is analogous to the **greedy algorithm for Egyptian fractions** — expressing
a number as a sum of unit fractions. Here we express an angle as a sum of
harmonic sub-angles.
    """)

    x_target = st.sidebar.slider("Target x (sin(πx))", 0.01, 0.99, 0.5, step=0.01)
    max_iter = st.sidebar.slider("Max iterations", 50, 500, 200, step=10)

    s_trace, angle_trace, deltas = greedy_sine_trace(x_target, max_iter, 20)

    accepted_steps = [(i, 1.0/(i+2)) for i, d in enumerate(deltas) if d == 1]

    st.subheader(f"Decomposition of {x_target}π")

    # Visual decomposition
    angles = [f"π/{i+2}" for i, _ in accepted_steps]
    values = [v for _, v in accepted_steps]
    cumulative = np.cumsum(values)

    fig = go.Figure()

    # Stacked bar showing each angle contribution
    for j, (step_idx, val) in enumerate(accepted_steps[:30]):  # Show first 30
        fig.add_trace(go.Bar(
            x=[f"Step {j+1}"],
            y=[val],
            name=f"π/{step_idx+2}",
            text=f"π/{step_idx+2}",
            textposition='inside',
        ))

    fig.update_layout(
        barmode='stack',
        title=f'Greedy angle decomposition of {x_target}π',
        yaxis_title='Angle (units of π)',
        height=400,
    )
    fig.add_hline(y=x_target, line_dash="dash", line_color="red",
                  annotation_text=f"Target = {x_target}π")
    st.plotly_chart(fig, use_container_width=True)

    # List
    st.write(f"**Target:** {x_target}π")
    decomp_str = " + ".join([f"π/{i+2}" for i, _ in accepted_steps[:50]])
    st.write(f"**Decomposition:** {decomp_str}")
    st.write(f"**Sum:** {sum(v for _, v in accepted_steps):.10f}π")
    st.write(f"**Error:** {abs(x_target - sum(v for _, v in accepted_steps)):.2e}π")

    # Egyptian fraction analogy
    st.subheader("Egyptian Fraction Analogy")
    st.markdown(r"""
Just as an **Egyptian fraction** represents a rational number as a sum of distinct unit fractions
$\frac{a}{b} = \frac{1}{n_1} + \frac{1}{n_2} + \cdots$,

the geometric sine algorithm represents an angle as a sum of distinct harmonic fractions
$\frac{\theta}{\pi} = \frac{1}{k_1} + \frac{1}{k_2} + \cdots$

where $k_i = n_i + 2$ are the denominators selected by the greedy rule.
    """)

    denominators = [i + 2 for i, _ in accepted_steps]
    st.write(f"**Denominators used:** {denominators[:50]}")
    st.write(f"**Number of terms:** {len(accepted_steps)}")


st.markdown("---")
st.markdown(r"""
**Source:** *A Purely Geometric Reconstruction of the Sine Function* (Grok, 2025).
First published by Victor Geere in 2020.
Original implementation: [victorgeere.co.za/sine](https://victorgeere.co.za/sine/index.html)
""")
