import streamlit as st
import numpy as np
import matplotlib.pyplot as plt
import plotly.graph_objects as go

st.set_page_config(layout="wide")
st.title("Straightened / Unwound Iota Spiral")
st.markdown(r"""
Linearise the iota spiral $P_n = n^{-\sigma}e^{i\Phi_n}$ by computing successive
chord lengths $d_n = |v_n - v_{n-1}|$ and laying the points along a line at
cumulative arc-length positions.
""")

# Sidebar controls
st.sidebar.header("Parameters")
t = st.sidebar.slider("$t$ (imaginary part)", 0.0, 50.0, 14.134725, step=0.01, format="%.3f")
sigma = st.sidebar.slider(r"$\sigma$ (real part)", 0.0, 1.0, 0.5, step=0.01)
N = st.sidebar.slider("Number of terms $N$", 50, 2000, 500, step=50)
k = st.sidebar.slider("Tail window $k$ (show $N{-}k$ to $N$)", 1, max(1, N - 2), min(N - 2, 200), step=1)

# Compute iota terms
n = np.arange(1, N + 1)
r_n = n ** (-sigma)
Phi_n = np.pi * (n - 1) - t * np.log(n)
v_n = r_n * np.exp(1j * Phi_n)

# Compute chord lengths and cumulative linear position
d_n = np.abs(v_n[1:] - v_n[:-1])
x_cum = np.concatenate(([0], np.cumsum(d_n)))

# Slice to tail window [N-k, N]
i_start = N - k
n_tail = n[i_start:]
v_tail = v_n[i_start:]
d_tail = d_n[max(0, i_start - 1):]
x_tail = x_cum[i_start:]

# Plot linearized sequence (matplotlib)
st.subheader(f"Linearised Iota Sequence  (n = {i_start + 1} … {N})")
fig_linear, ax_linear = plt.subplots(figsize=(12, 3))
ax_linear.plot(x_tail, np.zeros_like(x_tail), 'k-', lw=0.5)
sc = ax_linear.scatter(x_tail, np.zeros_like(x_tail), c=n_tail, cmap='viridis', s=5)
ax_linear.set_xlabel('Cumulative chord length')
ax_linear.set_title('Points laid along cumulative arc length')
ax_linear.set_yticks([])
plt.colorbar(sc, ax=ax_linear, label='n')
st.pyplot(fig_linear)

# Interactive Plotly version
st.subheader("Chord Lengths $d_n = |v_n - v_{n-1}|$")
n_chord_tail = n[max(1, i_start):]
d_chord_tail = d_n[max(0, i_start - 1):]
fig_chords = go.Figure()
fig_chords.add_trace(go.Scatter(x=n_chord_tail, y=d_chord_tail, mode='lines',
                                 line=dict(color='steelblue', width=1)))
fig_chords.update_layout(xaxis_title='n', yaxis_title='d_n', height=350)
st.plotly_chart(fig_chords, width='stretch')

# Original spiral for comparison
st.subheader("Original Iota Spiral (complex plane)")
fig_spiral = go.Figure()
fig_spiral.add_trace(go.Scatter(
    x=v_tail.real, y=v_tail.imag, mode='lines+markers',
    marker=dict(size=2, color=n_tail, colorscale='Viridis', colorbar=dict(title='n')),
    line=dict(color='gray', width=0.5),
))
fig_spiral.update_layout(
    xaxis_title='Re', yaxis_title='Im',
    height=500, xaxis=dict(scaleanchor='y'),
)
st.plotly_chart(fig_spiral, width='stretch')

st.markdown(f"**Total arc length:** {x_cum[-1]:.4f}  |  **Mean chord:** {np.mean(d_n):.6f}")