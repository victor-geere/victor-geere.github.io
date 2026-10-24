# 005 — The Smoothing Bridge

| Field | Value |
|---|---|
| Source | [`research/publish/005-smoothing-bridge/manuscript.md`](../rh/research/publish/005-smoothing-bridge/manuscript.md) |
| Status | Published; truths ledger §5. |
| Harvested statements | 10 |

## Abstract

Replacing the sharp cutoff in a Dirichlet partial sum by a smooth weight is the standard textbook move for suppressing the fluctuation of a truncated Dirichlet series. This folder asks the precise version of the question left open by the previous item: if $S_N^\varphi(s)=\sum_{n\le N}\varphi(n/N)n^{-s}$ and $\zeta_N(s)=\sum_{n\le N}n^{-s}$ on the critical line $s=1/2+it$, can smoothing extract $\zeta(1/2+it)$ to $o(1)$ — even exponentially small — accuracy, so that a finite-$N$ condition can see a zero of $\zeta$? The folder's answer is **no**, and it records the exact law that says so. **PROVED in Lean 4** (`Rh044/Smoothing.lean`, no `sorry`, no new axiom): the weight defect identity $\zeta_N(s)-S_N^\varphi(s)=\sum_{n\le N}(1-\varphi(n/N))n^{-s}$, the triangle-inequality bound, the exact radial decay $\|n^{-(\sigma+it)}\|=n^{-\sigma}$, the summability comparison for $\sigma>1$, and the quadratic-weight closed forms. **PROVED on paper and VERIFIED numerically to 5–7 digits**: every weight obeys
$$\frac{\bigl|S_N^\varphi(1/2+it)-\zeta(1/2+it)\bigr|}{\sqrt N}\longrightarrow|M_\varphi(s)|,\qquad M_\varphi(s)=\int_0^1\varphi(u)u^{-s}\,du,$$
so every weight keeps a $\sqrt N$ term, and smoothing buys only the constant $|M_\varphi(s)|$, by up to a factor $600$ for $(u(1-u))^3$. **REFUTED**: "smoothing removes the $\sqrt N$" (the measured last-decade exponent is $0.5000$ for all six weights), and the first draft's constant $1/\sqrt{2t}$, which is wrong by a factor $2.6601139$ at $t=14.134725141734693$ (the true sharp constant is $1/|s-1|=1/\sqrt{1/4+t^2}$). Exponential accuracy is reachable only through the functional equation: Riemann's theta identity, verified to $<10^{-30}$ by the round's script and to $5.7\cdot10^{-69}$ at $s=2$ by the independent auditor (43/43 checks), with a rigorous tail bound decaying like $e^{-\pi X}$. The bridge is therefore buildable, but it is the functional equation that builds it, and a one-sided smoothed sum provably cannot.

## Harvested theorem-like statements

### Theorem 1

(weight defect identity). For every $N\ge1$, every weight $\varphi:\mathbb{R}\to\mathbb{R}$ and every $s\in\mathbb{C}$,
$$\zeta_N(s)-S_N^\varphi(s)=\sum_{n=1}^{N}\Bigl(1-\varphi\Bigl(\frac nN\Bigr)\Bigr)n^{-s}.$$
**PROVED** (Lean, `Rh044/Smoothing.lean` L121, `weighted_decomposition`); the proof is pure algebra, term by term, with no estimate involved. Degenerate cases: $\varphi\equiv1$ recovers the sharp sum (`smoothedSum_one`), and $\varphi\equiv0$ on the sampled points gives $S_N^\varphi=0$, so the identity returns $\zeta_N$ (`smoothedSum_zero_of_weight_eq_zero`, `zetaSum_eq_sum_defect_of_weight_eq_zero`) — **PROVED** (Lean).

### Theorem 2

(triangle-inequality bound). With the defect written as $1-\varphi(n/N)$,
$$\bigl\|\zeta_N(s)-S_N^\varphi(s)\bigr\|\le\sum_{n=1}^{N}\Bigl\|1-\varphi\Bigl(\frac nN\Bigr)\Bigr\|\cdot\bigl\|n^{-s}\bigr\| .$$
**PROVED** (Lean, L193 `norm_zetaSum_sub_smoothedSum_le`, with the equivalent forms `norm_smoothedSum_sub_smoothedSum_le` (L166), `norm_smoothedSum_sub_zetaSum_le` (L184) and `norm_smoothedSum_sub_zetaSum_le'` (L204)); it follows from the identity by the triangle inequality and multiplicativity of the norm. The file's header states this as the estimate that the numerical round refines into the error laws $O(\sqrt N)$ (sharp) versus $O(N^{-\sigma})$ (smooth).

### Theorem 3

(radial decay). For $n\ge1$ and $s=\sigma+it$,
$$\bigl\|n^{-(\sigma+it)}\bigr\|=n^{-\sigma},$$
exactly, and $\|n^{-(\sigma+it)}\|\le n^{-\sigma}$ in the expression used for comparison. **PROVED** (Lean, L215, `abs_zetaTerm`; also `abs_zetaTerm_ofReal`, `norm_zetaTerm_le_rpow`, `abs_cpow_neg_eq`).

### Theorem 4

(summability comparison). For $\sigma>1$ the tail $\sum_n\|n^{-\sigma}\|$ is summable — $\sum_{n}\|\text{zetaTerm}(\sigma)(n+1)\|$ converges — by comparison with the real $p$-series. **PROVED** (Lean, L249, `summable_norm_zetaTerm`, using `Real.summable_nat_rpow`), and consequently `norm_zetaSum_sub_smoothedSum_le_rpow` gives the bound with the radial factors $n^{-\sigma}$ inserted. So for $\sigma>1$ the defect sum is summable; at $\sigma=1/2$, the case of this round, it is not.

### Theorem 5

(quadratic-weight identities). With $\varphi(u)=u(1-u)$, the defect has the closed form
$$1-\frac nN\Bigl(1-\frac nN\Bigr)=\frac{N^2-nN+n^2}{N^2}\qquad(N\ne0),$$
and the weighted decomposition holds with this defect: $\zeta_N(s)-S_N^{\mathrm{quad}}(s)=\sum_{n\le N}\frac{N^2-nN+n^2}{N^2}n^{-s}$. **PROVED** (Lean, L336 `quadWeight_defect_eq`, L365 `zetaSum_sub_smoothedSum_quadWeight`, L372 `weighted_decomposition_quadWeight_defect`; also `quadWeight_apply`, `quadWeight_one`, `quadWeight_zero`, `quadWeight_nonneg`, `quadWeight_div`, `smoothedSum_quadWeight`, `smoothedSum_quadWeight_split`).

> **A correction kept visible inside the Lean file.** The brief's rearranged numerator $((N-n)^2+n(N-n))/N^2$ is *not* the defect of $u(1-u)$: it simplifies to $(N-n)/N=1-n/N$, the defect of the *linear* weight $u$ (the two agree only at $n=0$). The file records the brief's expression as its own theorem `linearWeight_defect_eq`, and states the correct $u^2$-completing numerator as $(N-n)^2+n(N-n)+n^2=N^2-nN+n^2$ in `quadWeight_defect_eq'`. Both forms stay in the source.

### Theorem 6

(sharp-cutoff law). For $s=1/2+it$ and fixed $t$, as $N\to\infty$
$$S_N(s)-\zeta(s)=\frac{N^{1-s}}{1-s}+\frac12N^{-s}-\frac{s}{12}N^{-s-1}+\cdots,$$
hence $|S_N(s)-\zeta(s)|=\sqrt N/|s-1|+O(1)$ and
$$\frac{|S_N(1/2+it)-\zeta(1/2+it)|}{\sqrt N}\longrightarrow\frac{1}{|s-1|}=\frac{1}{\sqrt{1/4+t^2}} .$$
**PROVED** (Euler–Maclaurin) + **VERIFIED**. Measured, $t=14.134725141734693$: $0.0709386$, $0.0707218$, $0.07070530$, $0.07070370$ at $N=10^2,10^3,10^4,10^5$, against $1/\sqrt{1/4+t^2}=0.0707035277318$; at $t=21.022039638771555$: $0.0477615$, $0.0475684$, $0.04755687$, $0.04755579$ against $0.0475556741611$. Each coefficient is checked exactly in `smoothed_zeta.py` §1: at $N=102400$, $|R_1|\sqrt N=0.49999959$ against $1/2$, and $|R_2|N^{3/2}=1.178630488$ against $|s|/12=1.178630487$; the phase also matches, $|S_N|\sqrt{1/4+t^2}/\sqrt N\to1$ with $|S_N|\sqrt{1/4+t^2}/\sqrt N=1.00000244219815$ at $N=102400$ and $\arg S_N+t\log N-\arctan(2t)\to-6.9\cdot10^{-5}$.

At a zero, where $\zeta(1/2+it)=0$, the partial sum is therefore $\approx\sqrt N/|s-1|$: it never "sees" the zero, and the zero appears only after the cancellation $\zeta-S_N=-\sqrt N/|s-1|+O(N^{-1/2})$.

**Correction recorded here (R1).** An earlier draft of this round claimed the sharp constant is $1/\sqrt{2t}$. That is **REFUTED**: $1/\sqrt{2t}=0.1880794379435$ at $t=14.134725141734693$, against the measured $0.07070353$ — a factor $2.66011391478$. The true constant is $1/|s-1|=1/\sqrt{1/4+t^2}=0.0707035277318$; normalised, $|S_N-\zeta|\cdot|s-1|/\sqrt N=1.0000025$ at $N=10^5$. The related first-draft statement $|S_N|\sqrt{2t}/\sqrt N\to1$ is likewise **REFUTED** (R3): the measured value is $0.37592469$ at $t=14.1347247$ and $0.30835845$ at $t=21.0220$, against the true limit $\sqrt{2t}/\sqrt{1/4+t^2}=0.37592375065$ and $0.30835768$.

### Theorem 7

(weight law). For a bounded weight $\varphi:[0,1]\to\mathbb{R}$ whose Mellin transform $M_\varphi(s)=\int_0^1\varphi(u)u^{-s}du$ converges,
$$\frac{\bigl|S_N^\varphi(1/2+it)-\zeta(1/2+it)\bigr|}{\sqrt N}\longrightarrow|M_\varphi(s)| .$$
**PROVED on paper + VERIFIED numerically to 5–7 digits** at $N=10^5$, $t=14.134725141734693$, for the tested weights:

| weight $\varphi(u)$ | measured $\lvert E\rvert/\sqrt N$ at $N=10^5$ | $\lvert M_\varphi(s)\rvert$ | ratio |
|---|---|---|---|
| $1$ (sharp) | 0.070703705 | $\lvert 1/(s-1)\rvert=0.070703528$ | 1.0000025 |
| $u(1-u)$ | 0.0049012629 | 0.0049012243 | 1.00001 |
| $(u(1-u))^3$ | 0.00011771845 | 0.00011771845 | 1.000000 |
| $(1-\cos2\pi u)/2$ | 0.0079729835 | 0.0079729835 | 1.000000 |
| $e^{-u}$ | 0.026142297 | 0.026142378 | 0.999997 |

The script's master form of the law, derived from Abel summation plus Euler–Maclaurin and checked term by term, is
$$S_N^\varphi-\zeta=N^{1-s}J(\varphi)+\varphi(0)\zeta(s)+R_N,\qquad J(\varphi)=\int_0^1\varphi(u)u^{-s}du,\qquad R_N=O(N^{-\sigma}),$$
so the $\sqrt N$ term is governed by $u=0$ through $J(\varphi)$, **not** by $\varphi(1)$. The status markers the ledger attaches to each part are: the law itself **VERIFIED**; the residual statement "the residual is $O(N^{-\sigma})$ with a weight-dependent constant" **VERIFIED**; and the law "every weight with $\varphi(1)=0$ removes the $O(\sqrt N)$ fluctuation" **REFUTED**.

### Theorem 8

(Riemann's theta identity).
$$\pi^{-s/2}\Gamma(s/2)\zeta(s)=\frac{1}{s(s-1)}+\frac12\bigl[A(s)+A(1-s)\bigr],\qquad A(s)=\int_1^\infty x^{s/2-1}(\theta(x)-1)\,dx,$$
with $\theta(x)=\sum_{n\in\mathbb{Z}}e^{-\pi n^2x}$ and the modular transformation $\theta(1/x)=\sqrt x\,\theta(x)$; equivalently with $\psi(x)=\sum_{n\ge1}e^{-\pi n^2x}=(\theta(x)-1)/2$. **PROVED** (classical; Riemann 1859) + **VERIFIED** by the auditor's independent route (own theta and own incomplete gamma, nothing imported from the round): agreement with $\zeta$ to $5.7\cdot10^{-69}$ ($s=2$), $1.8\cdot10^{-68}$ ($s=4$), $1.0\cdot10^{-64}$ ($s=1/2+it_1$). The round's own script, at 120 dps with $X=40$, reports the differences $2.6708\cdot10^{-55}$ ($s=2$), $3.3698\cdot10^{-53}$ ($s=4$), $3.3105\cdot10^{-52}$ ($s=1/2+it_1$), $6.0056\cdot10^{-50}$ ($s=1/2+it_2$), $2.2357\cdot10^{-48}$ ($s=1/2+it_3$). The rigorous tail bound decays like $e^{-\pi X}$: the ledger records $B(X)=7.9\cdot10^{-7},1.6\cdot10^{-12},1.2\cdot10^{-23},1.0\cdot10^{-45},1.9\cdot10^{-48}$ at $X=4,8,16,32,34$; the script's own table (for $s=1/2+it_1$) gives $bound(X)=2.57109\cdot10^{-15},4.18772\cdot10^{-18},1.17698\cdot10^{-23}$ at $X=10,12,16$, with $X_{\min}=25$ for a rigorous bound below $10^{-30}$, and reports that the bound is tight ($1\le bound/tail\le10$ for every tabulated $X$).

**Correction recorded here (R4).** The first draft's form of the identity, $\zeta(s)=1/(s-1)+1/s+\int(\cdots)(\theta-1)dx$, is **REFUTED**: at $s=2$ it returns $1.547197551$, i.e. $\zeta(2)$ minus $0.0977365$; it is off by exactly $1/s$, and it also omits the prefactor $\pi^{-s/2}/\Gamma(s/2)$ and the factor $\frac12$ on the kernel. The script checks this explicitly (`T3[BRIEF-FORMULA]`), with the auditor giving the same verdict at $s=4$ and at the zero. The corrected identity is the display above.

**The bridge, therefore, exists — but it is the functional equation that builds it.** A one-sided smoothed sum has error $\sqrt N\,|M_\varphi(s)|$; the theta route is $e^{-\pi X}$-accurate with $O(\sqrt t)$ terms. The gap of the previous item is closed in the sense that the mechanism is identified, and *not* closed in the sense of a new bridge: the route is Riemann's (1859) and Riemann–Siegel's (1932), and this round adds no new analytic input.

### Theorem 9

(zero localisation). **VERIFIED.** With a reliable $\zeta$ evaluator (mpmath's `mp.zeta`, cross-checked by the auditor's theta route), bracketed bisection gives the first five zeros
$$14.1347251417346937904572519836,\quad 21.0220396387715549926284795939,\quad 25.0108575801456887632137909926,$$
$$30.4248761258595132103118975306,\quad 32.9350615877391896906623689641,$$
the two routes agreeing to the $10^{-44}$ bisection floor.

In contrast, the **sharp partial sum cannot do this** (VERIFIED): for $N=10^3,10^4$ the first positive roots of $\operatorname{Re}S_N(1/2+it)$ are $0.30398963,0.21372367$, with $60$ and $102$ roots in $(0,35)$ (stable under scan refinement $0.05$ vs $0.02$) — generic oscillations, $t_1\log N=2.0999,1.9685$, an effective $t_1\sim(\log N)^{-p}$ with $p=1.22465$ from the two-point fit (drifting to the model $\pi/2$), and $|\zeta(1/2+it_1)|=1.26,1.35$, i.e. no root within $10^{-3}$ of a true zero. The $N=10^5$ count $\approx128$ from earlier partial runs is **not claimed** here: the ledger records it as **OPEN** because it was omitted for runtime and is unverified. Two independent calculations ($\operatorname{Re}S_N$ and $Z(t)$) confirm that the sharp partial sum's roots are not zeta zeros; and $\operatorname{Re}\zeta$ alone also has spurious sign changes (at $0.8195$, $20.654$, $29.739$, $33.624$) that are not zeros, so only $Z$-based bracketing is reliable.

### Theorem 10

(zero count). **VERIFIED with caveat.** $N(30)=3$, $N(35)=5$, counted via $Z$-sign changes. The Riemann–von Mangoldt main term is $(T/2\pi)\log(T/2\pi e)+7/8=3.5647$ at $T=30$ (the auditor computes $3.56465638149708$), so $N(30)-\text{main}=-0.5647=S(30)/\pi$, inside the expected oscillation; the main term alone rounds to $4$ and does **not** determine the count. For context, at $T=35$: $N(35)=5$, main term $4.87161693872$, difference $0.128383$.

## Source

[`manuscript.md`](../rh/research/publish/005-smoothing-bridge/manuscript.md) · [`README.md`](../rh/research/publish/005-smoothing-bridge/README.md)
