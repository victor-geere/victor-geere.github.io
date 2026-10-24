# The smoothing bridge: the weight defect and the smoothing law at the critical line

**First edition, packaged from this folder's `README.md` and `TRUTHS.md` (item §5 of `research/truths.md`), produced in the programme's round `rh044`. The Lean development, the numerics and their run logs are reproduced in this folder; markdown links in the reproduced sources were re-pointed into the folder and nothing else was modified.**

This programme's papers do not prove the twin prime conjecture. This folder does not either: its verdict on the parity problem is that nothing in it advances, obstructs or interacts with it, and §5 says so explicitly.

## Abstract

Replacing the sharp cutoff in a Dirichlet partial sum by a smooth weight is the standard textbook move for suppressing the fluctuation of a truncated Dirichlet series. This folder asks the precise version of the question left open by the previous item: if $S_N^\varphi(s)=\sum_{n\le N}\varphi(n/N)n^{-s}$ and $\zeta_N(s)=\sum_{n\le N}n^{-s}$ on the critical line $s=1/2+it$, can smoothing extract $\zeta(1/2+it)$ to $o(1)$ — even exponentially small — accuracy, so that a finite-$N$ condition can see a zero of $\zeta$? The folder's answer is **no**, and it records the exact law that says so. **PROVED in Lean 4** (`Rh044/Smoothing.lean`, no `sorry`, no new axiom): the weight defect identity $\zeta_N(s)-S_N^\varphi(s)=\sum_{n\le N}(1-\varphi(n/N))n^{-s}$, the triangle-inequality bound, the exact radial decay $\|n^{-(\sigma+it)}\|=n^{-\sigma}$, the summability comparison for $\sigma>1$, and the quadratic-weight closed forms. **PROVED on paper and VERIFIED numerically to 5–7 digits**: every weight obeys
$$\frac{\bigl|S_N^\varphi(1/2+it)-\zeta(1/2+it)\bigr|}{\sqrt N}\longrightarrow|M_\varphi(s)|,\qquad M_\varphi(s)=\int_0^1\varphi(u)u^{-s}\,du,$$
so every weight keeps a $\sqrt N$ term, and smoothing buys only the constant $|M_\varphi(s)|$, by up to a factor $600$ for $(u(1-u))^3$. **REFUTED**: "smoothing removes the $\sqrt N$" (the measured last-decade exponent is $0.5000$ for all six weights), and the first draft's constant $1/\sqrt{2t}$, which is wrong by a factor $2.6601139$ at $t=14.134725141734693$ (the true sharp constant is $1/|s-1|=1/\sqrt{1/4+t^2}$). Exponential accuracy is reachable only through the functional equation: Riemann's theta identity, verified to $<10^{-30}$ by the round's script and to $5.7\cdot10^{-69}$ at $s=2$ by the independent auditor (43/43 checks), with a rigorous tail bound decaying like $e^{-\pi X}$. The bridge is therefore buildable, but it is the functional equation that builds it, and a one-sided smoothed sum provably cannot.

## 1. Introduction and goal

The preceding item of the programme ended on an explicit gap. At the critical abscissa $\operatorname{Re}(S)=1/2$ the finite-$N$ balance condition $\operatorname{Re}S_N(1/2+it)=0$ *does* have roots, but they are generic oscillations of the Dirichlet polynomial, not zeros of $\zeta$, because the sharp partial sum differs from $\zeta$ by an unbounded amount:
$$S_N(1/2+it)-\zeta(1/2+it)=O(\sqrt N)\qquad(\text{sharp cutoff}).$$
The question of this folder is whether a smoothing or summation method can replace the sharp cutoff and extract $\zeta$ to $o(1)$ — even exponentially small — accuracy, so that a finite-$N$ condition can see a zero.

The answer, in the round's one line: **no — smoothing does not remove the $\sqrt N$.** The exact law, verified to 5–7 digits against the closed form, is
$$\frac{\bigl|S_N^\varphi(1/2+it)-\zeta(1/2+it)\bigr|}{\sqrt N}\longrightarrow|M_\varphi(s)|,\qquad M_\varphi(s)=\int_0^1\varphi(u)u^{-s}\,du,$$
so every weight grows like $\sqrt N$; smoothing buys only the constant $|M_\varphi(s)|$. Exponential accuracy requires the functional equation, not smoothing: Riemann's theta route reaches $e^{-\pi X}$ with $O(\sqrt t)$ terms.

In scope: the exact weight defect identity and its error bound, the radial decay and the $\sigma>1$ summability comparison, the smoothing law with its numerical corroboration and its four consequences, the sharp-cutoff law as the Euler–Maclaurin main term, the theta/functional-equation route, zero localisation and the zero count, and the four corrections the round had to make to its own first draft. Out of scope, as the sources state: any new bridge, any improvement of the zero-free region, of zero-counting bounds or of the Riemann–Siegel formula, and any connection to the parity obstruction beyond the statement that the required input is analytic rather than algebraic.

## 2. Setup and definitions

* **The term.** For $n\ge1$ and $s\in\mathbb{C}$, `zetaTerm s n` $=n^{-s}=\exp(-s\log n)$ with the principal branch; `zetaTerm s 1 = 1`.
* **The sharp partial sum.** $\zeta_N(s)=\sum_{n=1}^{N}n^{-s}$ (`zetaSum N s`), an ordinary finite sum over the index range $1\le n\le N$.
* **The smoothed partial sum.** For a weight $\varphi:\mathbb{R}\to\mathbb{R}$, $S_N^\varphi(s)=\sum_{n=1}^{N}\varphi(n/N)n^{-s}$ (`smoothedSum N φ s`), sampled at the normalised abscissae $n/N$.
* **The weight defect.** $1-\varphi(n/N)$, one factor per index $n$.
* **The error.** $E=S_N^\varphi(s)-\zeta(s)$, and its scaled form $E/\sqrt N$.
* **The Mellin transform of the weight.** $M_\varphi(s)=\int_0^1\varphi(u)u^{-s}\,du$, equal to $J(\varphi)$ in the scripts' notation. The law of the round is a statement about $|E|/\sqrt N$, not about $|E|$.
* **The sharp case.** $\varphi\equiv1$ gives $M_\varphi(s)=\int_0^1u^{-s}du=1/(s-1)$ for $\operatorname{Re}(s)<1$, hence $|M_\varphi(1/2+it)|=1/|s-1|=1/\sqrt{1/4+t^2}$; this is the case in which the weight does not vanish at the right endpoint and the limit constant is $1/|s-1|$.
* **The weights tested** (the round's ladder, all with $\varphi(0)$ and $\varphi(1)$ as noted): $\varphi\equiv1$ (sharp, $\varphi(0)=\varphi(1)=1$); $u(1-u)$ ($0$ at both ends); $(u(1-u))^3$; the raised cosine $(1-\cos 2\pi u)/2$; $e^{-u}$ (summed to $N$); and $e^{-u}$ summed to convergence (a different object, see §3.5).
* **The Riemann–von Mangoldt main term.** $\dfrac{T}{2\pi}\log\dfrac{T}{2\pi e}+\dfrac78$, the smooth count to compare $N(T)$ against.
* **Notation in the Lean file.** The definitions `zetaTerm`, `zetaSum`, `smoothedSum` and `quadWeight` live in the namespace `Rh044` in `Rh044/Smoothing.lean`; `quadWeight u = u(1-u)`.

## 3. Results

### 3.1 The weight defect identity and its bounds

**Theorem 1** (weight defect identity). For every $N\ge1$, every weight $\varphi:\mathbb{R}\to\mathbb{R}$ and every $s\in\mathbb{C}$,
$$\zeta_N(s)-S_N^\varphi(s)=\sum_{n=1}^{N}\Bigl(1-\varphi\Bigl(\frac nN\Bigr)\Bigr)n^{-s}.$$
**PROVED** (Lean, `Rh044/Smoothing.lean` L121, `weighted_decomposition`); the proof is pure algebra, term by term, with no estimate involved. Degenerate cases: $\varphi\equiv1$ recovers the sharp sum (`smoothedSum_one`), and $\varphi\equiv0$ on the sampled points gives $S_N^\varphi=0$, so the identity returns $\zeta_N$ (`smoothedSum_zero_of_weight_eq_zero`, `zetaSum_eq_sum_defect_of_weight_eq_zero`) — **PROVED** (Lean).

**Theorem 2** (triangle-inequality bound). With the defect written as $1-\varphi(n/N)$,
$$\bigl\|\zeta_N(s)-S_N^\varphi(s)\bigr\|\le\sum_{n=1}^{N}\Bigl\|1-\varphi\Bigl(\frac nN\Bigr)\Bigr\|\cdot\bigl\|n^{-s}\bigr\| .$$
**PROVED** (Lean, L193 `norm_zetaSum_sub_smoothedSum_le`, with the equivalent forms `norm_smoothedSum_sub_smoothedSum_le` (L166), `norm_smoothedSum_sub_zetaSum_le` (L184) and `norm_smoothedSum_sub_zetaSum_le'` (L204)); it follows from the identity by the triangle inequality and multiplicativity of the norm. The file's header states this as the estimate that the numerical round refines into the error laws $O(\sqrt N)$ (sharp) versus $O(N^{-\sigma})$ (smooth).

**Theorem 3** (radial decay). For $n\ge1$ and $s=\sigma+it$,
$$\bigl\|n^{-(\sigma+it)}\bigr\|=n^{-\sigma},$$
exactly, and $\|n^{-(\sigma+it)}\|\le n^{-\sigma}$ in the expression used for comparison. **PROVED** (Lean, L215, `abs_zetaTerm`; also `abs_zetaTerm_ofReal`, `norm_zetaTerm_le_rpow`, `abs_cpow_neg_eq`).

**Theorem 4** (summability comparison). For $\sigma>1$ the tail $\sum_n\|n^{-\sigma}\|$ is summable — $\sum_{n}\|\text{zetaTerm}(\sigma)(n+1)\|$ converges — by comparison with the real $p$-series. **PROVED** (Lean, L249, `summable_norm_zetaTerm`, using `Real.summable_nat_rpow`), and consequently `norm_zetaSum_sub_smoothedSum_le_rpow` gives the bound with the radial factors $n^{-\sigma}$ inserted. So for $\sigma>1$ the defect sum is summable; at $\sigma=1/2$, the case of this round, it is not.

**Theorem 5** (quadratic-weight identities). With $\varphi(u)=u(1-u)$, the defect has the closed form
$$1-\frac nN\Bigl(1-\frac nN\Bigr)=\frac{N^2-nN+n^2}{N^2}\qquad(N\ne0),$$
and the weighted decomposition holds with this defect: $\zeta_N(s)-S_N^{\mathrm{quad}}(s)=\sum_{n\le N}\frac{N^2-nN+n^2}{N^2}n^{-s}$. **PROVED** (Lean, L336 `quadWeight_defect_eq`, L365 `zetaSum_sub_smoothedSum_quadWeight`, L372 `weighted_decomposition_quadWeight_defect`; also `quadWeight_apply`, `quadWeight_one`, `quadWeight_zero`, `quadWeight_nonneg`, `quadWeight_div`, `smoothedSum_quadWeight`, `smoothedSum_quadWeight_split`).

> **A correction kept visible inside the Lean file.** The brief's rearranged numerator $((N-n)^2+n(N-n))/N^2$ is *not* the defect of $u(1-u)$: it simplifies to $(N-n)/N=1-n/N$, the defect of the *linear* weight $u$ (the two agree only at $n=0$). The file records the brief's expression as its own theorem `linearWeight_defect_eq`, and states the correct $u^2$-completing numerator as $(N-n)^2+n(N-n)+n^2=N^2-nN+n^2$ in `quadWeight_defect_eq'`. Both forms stay in the source.

### 3.2 The sharp cutoff is the Euler–Maclaurin main term

**Theorem 6** (sharp-cutoff law). For $s=1/2+it$ and fixed $t$, as $N\to\infty$
$$S_N(s)-\zeta(s)=\frac{N^{1-s}}{1-s}+\frac12N^{-s}-\frac{s}{12}N^{-s-1}+\cdots,$$
hence $|S_N(s)-\zeta(s)|=\sqrt N/|s-1|+O(1)$ and
$$\frac{|S_N(1/2+it)-\zeta(1/2+it)|}{\sqrt N}\longrightarrow\frac{1}{|s-1|}=\frac{1}{\sqrt{1/4+t^2}} .$$
**PROVED** (Euler–Maclaurin) + **VERIFIED**. Measured, $t=14.134725141734693$: $0.0709386$, $0.0707218$, $0.07070530$, $0.07070370$ at $N=10^2,10^3,10^4,10^5$, against $1/\sqrt{1/4+t^2}=0.0707035277318$; at $t=21.022039638771555$: $0.0477615$, $0.0475684$, $0.04755687$, $0.04755579$ against $0.0475556741611$. Each coefficient is checked exactly in `smoothed_zeta.py` §1: at $N=102400$, $|R_1|\sqrt N=0.49999959$ against $1/2$, and $|R_2|N^{3/2}=1.178630488$ against $|s|/12=1.178630487$; the phase also matches, $|S_N|\sqrt{1/4+t^2}/\sqrt N\to1$ with $|S_N|\sqrt{1/4+t^2}/\sqrt N=1.00000244219815$ at $N=102400$ and $\arg S_N+t\log N-\arctan(2t)\to-6.9\cdot10^{-5}$.

At a zero, where $\zeta(1/2+it)=0$, the partial sum is therefore $\approx\sqrt N/|s-1|$: it never "sees" the zero, and the zero appears only after the cancellation $\zeta-S_N=-\sqrt N/|s-1|+O(N^{-1/2})$.

**Correction recorded here (R1).** An earlier draft of this round claimed the sharp constant is $1/\sqrt{2t}$. That is **REFUTED**: $1/\sqrt{2t}=0.1880794379435$ at $t=14.134725141734693$, against the measured $0.07070353$ — a factor $2.66011391478$. The true constant is $1/|s-1|=1/\sqrt{1/4+t^2}=0.0707035277318$; normalised, $|S_N-\zeta|\cdot|s-1|/\sqrt N=1.0000025$ at $N=10^5$. The related first-draft statement $|S_N|\sqrt{2t}/\sqrt N\to1$ is likewise **REFUTED** (R3): the measured value is $0.37592469$ at $t=14.1347247$ and $0.30835845$ at $t=21.0220$, against the true limit $\sqrt{2t}/\sqrt{1/4+t^2}=0.37592375065$ and $0.30835768$.

### 3.3 The smoothing law — the round's main result

**Theorem 7** (weight law). For a bounded weight $\varphi:[0,1]\to\mathbb{R}$ whose Mellin transform $M_\varphi(s)=\int_0^1\varphi(u)u^{-s}du$ converges,
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

### 3.4 The four consequences

1. **The $\sqrt N$ growth is universal (VERIFIED).** No bounded weight removes it; the last-decade log–log exponent ($N=10^4\to10^5$) is $0.5000$ for every weight tested: sharp $0.5000$, $u(1-u)$ $0.5000$, $(u(1-u))^3$ $0.5000$, raised cosine $0.5000$, $e^{-u}$ $0.5000$, $e^{-u}-1/e$ $0.5000$. The round's cleanest counterexample to the proposed removal law is $\varphi(u)=u(1-u)$, which has $\varphi(1)=0$: $|E|=0.095247354$ at $N=400$ and $1.5684034$ at $N=102400$, against $|J|\sqrt N=0.098024487$ and $1.5683918$ — the error doubles when $N$ quadruples.
2. **Smoothing buys only a constant (MEASURED).** Best of the tested weights, $(u(1-u))^3$: $|M_\varphi|=1.18\cdot10^{-4}$ against the sharp $7.07\cdot10^{-2}$ — a factor $600$. The maximum of $|E|\sqrt N$ over $N=10^2,\dots,10^5$ is $7070$ (sharp), $490$ ($u(1-u)$), $11.8$ ($(u(1-u))^3$), $797$ (raised cosine), $2614$ ($e^{-u}$), $184.8$ ($e^{-u}-1/e$). The measured constants at $N=10^5$ are $|J|=0.0707036$ (sharp), $0.0261424$ ($e^{-u}$), $0.0079730$ (raised cosine), $0.0049012$ ($u(1-u)$), $0.0018482$ ($e^{-u}-1/e$), $0.000117718$ ($(u(1-u))^3$).
3. **The residual has a closed form (VERIFIED).** $S_N^\varphi-\zeta=N^{1-s}J(\varphi)+\varphi(0)\zeta(s)+R_N$ with $|R_N|\sqrt N$ bounded by a weight-dependent constant: $0.5$ exactly for the sharp cutoff ($R_N=\frac12N^{-s}$), $0.0386$ ($u(1-u)$), $1.25\cdot10^{-3}$ (raised cosine), $3.3\cdot10^{-7}$ ($(u(1-u))^3$), $0.192$ ($e^{-u}$), with fitted residual slopes $-0.50,-1.00,-2.00,-3.00,-0.49$ respectively; the run's own fitted slopes are $-0.499989$ (sharp), $-0.999426$ ($u(1-u)$), $-2.0$ (raised cosine), $-3.00351$ ($(u(1-u))^3$), $-0.486895$ ($e^{-u}$ summed to $N$). Equivalently: the residual decays like $N^{-1/2}$ for the sharp cutoff and faster for vanishing weights — $N^{-1}$ when $\varphi'(0)\ne0$, $N^{-2}$ when $\varphi'(0)=0$ (raised cosine), $N^{-3}$ for $(u(1-u))^3$; $O(N^{-\sigma})$ holds in every case.
4. **Bounded error would need $M_\varphi(s)=0$ (PROVED).** For a *nonnegative* weight this is impossible, since $\int_0^1\varphi(u)u^{-1/2-it}du$ cannot vanish when $\varphi\ge0$ is not identically zero (the integrand has constant argument $-t\log u$ and the modulus integral is strictly positive). A sign-changing $\varphi$ could in principle make the integral vanish at isolated $t$; making it vanish identically in $t$ would need the measure $\varphi(u)u^{-1/2}du$ to annihilate every $u^{-it}$, which forces $\varphi\equiv0$. Either way the one-sided route cannot reach $o(1)$ for all $t$. The corresponding **REFUTED** first-draft claim (R2) is that the smoothed error is $O(N^{-1/2})$: the measured exponent is $+0.5$ for every weight, and $|E|\sqrt N$ grows without bound.

### 3.5 The exponential weight summed to convergence

The source records a case that must be distinguished from the law of Theorem 7. If the exponential weight is *summed to convergence* (i.e. one evaluates $\sum_{n\ge1}e^{-n/N}n^{-s}=Li_s(e^{-1/N})$, not the finite $S_N^\varphi$), then one has instead
$$E=\Gamma(1-s)N^{1-s}+O(1/N),\qquad |\Gamma(1-s)|=\sqrt{\frac{\pi}{\cosh\pi t}}=5.7\cdot10^{-10},$$
exponentially small in $t$ — but the hidden $\sqrt N$ term takes over only beyond $N>|\zeta(s-1)/\Gamma(1-s)|^2=4.6\cdot10^{18}$. The run records the fitted slope $-0.99851893$ over $N=10^2,\dots,1.024\cdot10^5$ and the comparison $|\Gamma(1-s)|N^{1/2}$ vs $|\zeta(s-1)|/N$ at $N=10^5$: $1.80529\cdot10^{-7}$ vs $1.22546\cdot10^{-5}$, with the verdict line that *the $1/N$ decay seen here is NOT a removal of the $\sqrt N$ term*. **MEASURED** with its own bound; the polylogarithmic evaluation agrees with the truncated direct sum at $N=1000$ to $4.864\cdot10^{-13}$ against a tail bound of $5.403\cdot10^{-13}$.

### 3.6 Exponential accuracy needs the functional equation

**Theorem 8** (Riemann's theta identity).
$$\pi^{-s/2}\Gamma(s/2)\zeta(s)=\frac{1}{s(s-1)}+\frac12\bigl[A(s)+A(1-s)\bigr],\qquad A(s)=\int_1^\infty x^{s/2-1}(\theta(x)-1)\,dx,$$
with $\theta(x)=\sum_{n\in\mathbb{Z}}e^{-\pi n^2x}$ and the modular transformation $\theta(1/x)=\sqrt x\,\theta(x)$; equivalently with $\psi(x)=\sum_{n\ge1}e^{-\pi n^2x}=(\theta(x)-1)/2$. **PROVED** (classical; Riemann 1859) + **VERIFIED** by the auditor's independent route (own theta and own incomplete gamma, nothing imported from the round): agreement with $\zeta$ to $5.7\cdot10^{-69}$ ($s=2$), $1.8\cdot10^{-68}$ ($s=4$), $1.0\cdot10^{-64}$ ($s=1/2+it_1$). The round's own script, at 120 dps with $X=40$, reports the differences $2.6708\cdot10^{-55}$ ($s=2$), $3.3698\cdot10^{-53}$ ($s=4$), $3.3105\cdot10^{-52}$ ($s=1/2+it_1$), $6.0056\cdot10^{-50}$ ($s=1/2+it_2$), $2.2357\cdot10^{-48}$ ($s=1/2+it_3$). The rigorous tail bound decays like $e^{-\pi X}$: the ledger records $B(X)=7.9\cdot10^{-7},1.6\cdot10^{-12},1.2\cdot10^{-23},1.0\cdot10^{-45},1.9\cdot10^{-48}$ at $X=4,8,16,32,34$; the script's own table (for $s=1/2+it_1$) gives $bound(X)=2.57109\cdot10^{-15},4.18772\cdot10^{-18},1.17698\cdot10^{-23}$ at $X=10,12,16$, with $X_{\min}=25$ for a rigorous bound below $10^{-30}$, and reports that the bound is tight ($1\le bound/tail\le10$ for every tabulated $X$).

**Correction recorded here (R4).** The first draft's form of the identity, $\zeta(s)=1/(s-1)+1/s+\int(\cdots)(\theta-1)dx$, is **REFUTED**: at $s=2$ it returns $1.547197551$, i.e. $\zeta(2)$ minus $0.0977365$; it is off by exactly $1/s$, and it also omits the prefactor $\pi^{-s/2}/\Gamma(s/2)$ and the factor $\frac12$ on the kernel. The script checks this explicitly (`T3[BRIEF-FORMULA]`), with the auditor giving the same verdict at $s=4$ and at the zero. The corrected identity is the display above.

**The bridge, therefore, exists — but it is the functional equation that builds it.** A one-sided smoothed sum has error $\sqrt N\,|M_\varphi(s)|$; the theta route is $e^{-\pi X}$-accurate with $O(\sqrt t)$ terms. The gap of the previous item is closed in the sense that the mechanism is identified, and *not* closed in the sense of a new bridge: the route is Riemann's (1859) and Riemann–Siegel's (1932), and this round adds no new analytic input.

### 3.7 Zero localisation and the zero count

**Theorem 9** (zero localisation). **VERIFIED.** With a reliable $\zeta$ evaluator (mpmath's `mp.zeta`, cross-checked by the auditor's theta route), bracketed bisection gives the first five zeros
$$14.1347251417346937904572519836,\quad 21.0220396387715549926284795939,\quad 25.0108575801456887632137909926,$$
$$30.4248761258595132103118975306,\quad 32.9350615877391896906623689641,$$
the two routes agreeing to the $10^{-44}$ bisection floor.

In contrast, the **sharp partial sum cannot do this** (VERIFIED): for $N=10^3,10^4$ the first positive roots of $\operatorname{Re}S_N(1/2+it)$ are $0.30398963,0.21372367$, with $60$ and $102$ roots in $(0,35)$ (stable under scan refinement $0.05$ vs $0.02$) — generic oscillations, $t_1\log N=2.0999,1.9685$, an effective $t_1\sim(\log N)^{-p}$ with $p=1.22465$ from the two-point fit (drifting to the model $\pi/2$), and $|\zeta(1/2+it_1)|=1.26,1.35$, i.e. no root within $10^{-3}$ of a true zero. The $N=10^5$ count $\approx128$ from earlier partial runs is **not claimed** here: the ledger records it as **OPEN** because it was omitted for runtime and is unverified. Two independent calculations ($\operatorname{Re}S_N$ and $Z(t)$) confirm that the sharp partial sum's roots are not zeta zeros; and $\operatorname{Re}\zeta$ alone also has spurious sign changes (at $0.8195$, $20.654$, $29.739$, $33.624$) that are not zeros, so only $Z$-based bracketing is reliable.

**Theorem 10** (zero count). **VERIFIED with caveat.** $N(30)=3$, $N(35)=5$, counted via $Z$-sign changes. The Riemann–von Mangoldt main term is $(T/2\pi)\log(T/2\pi e)+7/8=3.5647$ at $T=30$ (the auditor computes $3.56465638149708$), so $N(30)-\text{main}=-0.5647=S(30)/\pi$, inside the expected oscillation; the main term alone rounds to $4$ and does **not** determine the count. For context, at $T=35$: $N(35)=5$, main term $4.87161693872$, difference $0.128383$.

### 3.8 The corrections the round had to make to its own first draft

The ledger keeps four refuted first-draft claims with their witnesses. R1–R3 were caught by the round's auditor; R4 by the main agent before the audit.

| # | wrong claim | witness / correction |
|---|---|---|
| R1 | the sharp fluctuation constant is $1/\sqrt{2t}$ | false by a factor $2.6601139$ at $t=14.1347$: $1/\sqrt{2t}=0.1880794$ vs the measured $0.07070353$. The true constant is $1/\lvert s-1\rvert=1/\sqrt{1/4+t^2}=0.0707035277318$; normalised, $\lvert S_N-\zeta\rvert\cdot\lvert s-1\rvert/\sqrt N=1.0000025$ at $N=10^5$. |
| R2 | "smoothing removes the $\sqrt N$ fluctuation; the smoothed error is $O(N^{-1/2})$" | false. $\lvert S_N^\varphi-\zeta\rvert\sqrt N\to\infty$ for **every** weight; the measured exponents are $0.5000$ (last decade, $N=10^4\to10^5$) for all six weights tested. Smoothing changes only the constant $\lvert M_\varphi(s)\rvert$. |
| R3 | "$\lvert S_N\rvert\sqrt{2t}/\sqrt N\to1$" | false: measured $0.37592469$ ($t=14.1347$), $0.30835845$ ($t=21.0220$); the limit is $\sqrt{2t}/\sqrt{1/4+t^2}=0.37592375$ / $0.30835768$. |
| R4 | theta identity $\zeta(s)=1/(s-1)+1/s+\cdots$ | false (off by exactly $1/s$: at $s=2$ it returns $1.547197551$). The classical identity is $\pi^{-s/2}\Gamma(s/2)\zeta(s)=1/(s(s-1))+\frac12[A(s)+A(1-s)]$, $A(s)=\int_1^\infty x^{s/2-1}(\theta(x)-1)dx$. |

### 3.9 Open

* Whether some non-positive or oscillating weight has $M_\varphi(1/2+it)=0$ identically in $t$ (which would give bounded error without the functional equation). The Mellin transform of a real weight cannot vanish identically by the positivity argument of §3.4(4), but a complex-valued weight is not excluded by this round. **OPEN**.
* An explicit $N$–$t$ trade-off for the smoothed route in the $o(1)$ regime. **OPEN**.
* The sharp partial sum's $N=10^5$ root count in $(0,35)$: unverified, recorded as **OPEN**.

### 3.10 Verdict for the gap and for the parity problem

* The gap of the previous item is **closed in the sense that the mechanism is identified**: the sharp cutoff's $O(\sqrt N)$ is the Euler–Maclaurin main term $N^{1-s}/(1-s)$; smoothing rescales its constant by $|M_\varphi(s)|/|1/(s-1)|$; and $o(1)$ accuracy is available only via the functional equation, at $e^{-\pi X}$.
* It is **not** closed in the sense of a new bridge: the route is Riemann's (1859) / Riemann–Siegel's (1932), and this round adds no new analytic input.
* **Parity problem: unchanged and untouched.** Every object here is an additive character in $\log n$; the round's one genuinely new statement (Theorem 7) is a statement about the *weight*, not about multiplicative structure, and nothing in it turns the sign of $\cos(t\log n)$ into divisor information. The parity obstruction is exactly the absence of such an input.

## 4. Verification and evidence

Everything below was run in this folder by the packaging pass unless marked otherwise; the recorded logs are also in the folder.

**Lean.** `./check.sh --all` elaborates `Rh044/Smoothing.lean` and `Rh044.lean` against Lean 4 + Mathlib (elan at `$HOME/lean`, toolchain `leanprover/lean4:v4.35.0-rc2`, Mathlib4 at `$HOME/lean/mathlib4`). Observed:

```
[check] OK   Rh044/Smoothing.lean (212s)
[check] OK   Rh044.lean (148s)
real 365.87
EXIT=0
```

The folder's recorded run `logs/lean_check.log` shows the same two lines (18s and 7s on the recording machine). The file's header states that everything is proved from Mathlib alone, with no `sorry`, no extra axiom and no computation by reflection.

**Main numerics.** `python3 smoothed_zeta.py` exits 0 iff every check passes; `mpmath` precision (dps) is raised per section and reported with every claim, and stdout carries the results. Observed in the packaging pass, exit status 0, total wall time 1108.4 s:

```
------------------------------------------------------------------------------
59 checks pass, 0 fail
------------------------------------------------------------------------------
```

The recorded run `logs/smoothed_zeta.log` ends with the same `59 checks pass, 0 fail` (302.5 s on the recording machine). Representative observed lines from the recorded run:

```
PASS  T1: |S_N-zeta|/sqrt(N) -> 1/sqrt(1/4+t^2) at t=14.134725141734693   |  fitted slope 0.49968393 (target 0.5)
PASS  T1: brief normalisation sqrt(2t) gives sqrt(2t)/sqrt(1/4+t^2) = 0.3759237506, not 1   |  measured 0.37592466873
PASS  T2[sharp  phi=1]: |E|/sqrt(N) -> |J(phi)| = 0.07070352773   |  observed/predicted = 1.000002442 at N=102400
PASS  T2[(u(1-u))^3]: |E|/sqrt(N) -> |J(phi)| = 0.0001177184488   |  observed/predicted = 1.0 at N=102400
PASS  T2(a) verdict: the sqrt(N) term survives for phi(1)=0 weights (witness u(1-u), N=400 -> 102400)   |  |E|(1.024e5)/|E|(400) = 16.4666 vs sqrt(N) factor 16.0
PASS  T2[exp-conv]: leading sqrt(N) coefficient is Gamma(1-s) = sqrt(pi/cosh(pi t))   |  |Gamma(1-s)| = 5.708835887e-10
PASS  T3[BRIEF-FORMULA]: the brief's formula fails (witness s=2, error > 1e-3)   |  |brief - zeta(2)| = 0.0977365
PASS  T3: |zeta_theta(s)-zeta(s)| < 1e-30 at s = 2  (dps=120, X=40)   |  error 2.6708e-55
PASS  T3: rigorous tail bound gives < 1e-30 for X >= 25, and the script uses X = 40   |  X_min = 25, X = 40
PASS  T4(ii): none of the first five sharp zeros lies within 1e-3 of a true zero
PASS  T4(iii): |zeta(1/2+i*root_k)| < 1e-20 at the located zero k=1   |  |zeta| = 3.0139e-34
```

**Independent auditor.** `python3 verify/independent_check.py` is self-contained: it imports only the standard library, NumPy and mpmath, asserts at runtime that it imports nothing from the round, uses `mp.zeta` as method 1 and its own theta/functional-equation evaluator as method 2, and recomputes all partial sums, Mellin constants, tail bounds and root searches. Observed in the packaging pass, exit status 0, total wall time 398.8 s, and on stderr:

```
43/43 auditor checks pass
runtime 398.8 s ; final N/M = 43/43 ; exit code 0
```

The recorded run `logs/independent_check.log` ends `runtime 88.3 s ; final N/M = 43/43 ; exit code 0`. Its claim-level verdicts are the ones kept in this manuscript:

```
C1 REFUTED as stated   (constant wrong by 2.66x at t1; the O(sqrt N) structure is right)
C2 REFUTED as stated   (|E|sqrt(N) unbounded; sharp-divergence sub-claim true)
C3 REFUTED as stated   (identity off by 1/s; corrected identity VERIFIED < 1e-40)
C4 VERIFIED
C5 VERIFIED (caveat: the main term does not round to the true count)
```

Representative observed check lines: `|S_N-zeta|*|s-1|/sqrt(N) <= EM bound for every N=1e2..1e5 (N=1e5: measured 1.00000250083 <= bound 1.00021217095)`; `1/sqrt(2t) = 0.188079437943 vs true 0.0707035277318 : relative error 1.66011 (>0.5), factor 2.6601139`; `[C2-const-law phi2=(u(1-u))^3] measured 0.000117718448844 vs exact 0.000117718448844 (rel.diff 8.348e-14)`; `[C2-const-law phiE0=exp(-u)-1/e] measured 0.00184817349315 vs exact 0.00184821051147 (rel.diff 2.003e-5)`; `[C2-same-exponent] every weight ... has the SAME exponent ~ +1/2 in the last decade; no weight shows the claimed -1/2 (local slopes: ... 0.5000 ...)`; `[C3-claimed-identity-REFUTED] the identity as stated is FALSE: at s=2 it returns 1.547197551197 (= zeta(2) - 0.097736515650)`; `[C3-tail-tolerance-X34] at X=34 the rigorous tail bound is below 1e-40 at all three points (s=2: 4.11e-47, s=4: 4.4e-45, zero: 1.06e-43)`; `[C5-count-vs-main] N(30) = 3 and the Riemann-von Mangoldt main term = 3.564656381 differ by -0.564656 = S(30)/pi ... Note the main term does NOT round to the true count`.

**Scripts not run in the packaging pass, and why.** The folder contains exactly two Python scripts (`smoothed_zeta.py` and `verify/independent_check.py`) plus the Lean driver `check.sh`; all three were run, and their outputs are recorded above. No other script exists in this folder to run. The deliverables of this packaging pass (`manuscript.md`, `paper.json`) were not executed; they are documents.

## 5. What is not claimed

* **No new bridge.** The route through the functional equation is Riemann's (1859) and Riemann–Siegel's (1932). The round identifies the mechanism of the gap and confirms it numerically; it adds no new analytic input.
* **No improvement** of the zero-free region, of zero-counting bounds, or of the Riemann–Siegel formula.
* **No parity/twin-prime claim.** Nothing in this round turns the sign of $\cos(t\log n)$ into multiplicative or divisor information; the required input is analytic (an error term), not algebraic, and the parity obstruction is untouched.
* **The main law is a paper result with numerical corroboration, not a Lean theorem.** The Lean layer formalises the algebraic and analytic part of the bridge (the defect identity, the triangle bound, the radial decay, the summability comparison, the quadratic-weight identities); the limit statement $|E|/\sqrt N\to|M_\varphi(s)|$ is marked **PROVED (paper) + VERIFIED** and is not machine-checked here.
* **The $e^{-u}$ summed-to-convergence case is a different object** from the finite smoothed sum $S_N^\varphi$ and is not a counterexample to the law; its $1/N$ decay is not a removal of the $\sqrt N$ term.
* **Numerical agreement is 5–7 digits, not a proof of the limit.** The auditor records that the empirical agreement of the sharp constant is capped at 5.60 digits at $N=10^5$ by the $O(N^{-1/2})$ oscillating correction; the constant itself is exact.
* **Corrections stay visible.** R1–R4 are kept with their witnesses, and the two tail-bound number sets (the ledger's $B(X)$ and the script's $bound(X)$) are reported as each source gives them; neither is adjusted here.
* **One count is not claimed:** the $N=10^5$ root count $\approx128$ for the sharp partial sum is recorded as unverified and is not asserted above.

## 6. Value and significance

The folder answers a question that a reader of any textbook smoothing argument would ask, and it answers it in the negative with an exact law rather than an estimate. That is its first value: *smoothing does not remove the $\sqrt N$*, and the precise statement is that the residual constant is the Mellin transform of the weight, $|M_\varphi(s)|$. The law is then checked against six weights at five to seven digits, and the sharp case is identified as the Euler–Maclaurin main term with the exact constant $1/|s-1|$ — so a tactic that is usually described qualitatively ("smoothing the cutoff improves the error") is here pinned down quantitatively, including the fact that a vanishing weight changes only the constant, by at most a factor $600$ among the tested weights.

Second, the folder corrects the record in a way that is itself useful. Four first-draft statements are refuted with witnesses: the wrong constant $1/\sqrt{2t}$ (off by a factor $2.66$), the claim that smoothing gives $O(N^{-1/2})$ error, the normalisation $|S_N|\sqrt{2t}/\sqrt N\to1$, and a mis-stated theta identity off by $1/s$. Each has an explicit numerical witness and a corrected statement, and both the wrong claim and the correction remain visible. The same care is applied inside the Lean development, where the brief's rearranged numerator for the quadratic-weight defect is kept as its own theorem (`linearWeight_defect_eq`) alongside the corrected form.

Third, the folder locates the boundary of the one-sided method precisely and says what lies beyond it: bounded error would need $M_\varphi(s)=0$, impossible for a nonnegative weight and forced to $\varphi\equiv0$ if required for all $t$; exponential accuracy needs the functional equation, at $e^{-\pi X}$ with $O(\sqrt t)$ terms. That boundary is the honest content of the "bridge": the bridge exists, but it is built by the functional equation, not by smoothing. And the round is explicit that this yields no new analytic input for the programme's wider obstruction — the missing ingredient there is an error term, exactly what this folder shows a one-sided smoothed sum cannot supply.

## Sources

All paths are relative to this folder. Quoted files were read in the packaging pass; SHA-256 digests are given below for the sources whose content is quoted.

| source | what was used from it | locator |
|---|---|---|
| `README.md` | the item statement, the defect identity and smoothing law as displayed, the refutation, the contents table, the proved/not-proved list, the run recipe, the provenance | whole file |
| `TRUTHS.md` | the §5 ledger: the seven result rows with statuses and Lean line links | whole file |
| `ROUND-NOTES.md` | the round's write-up: the question, the one-line answer, settled facts 1–6 (sharp cutoff, smoothing law and its five-weight table, theta route, zero localisation, zero count, consequence), the file table, the reproduce block, the not-claimed list | whole file |
| `ROUND-TRUTHS.md` | the prose ledger: the R1–R4 corrections table, §1 (T1, Euler–Maclaurin), §2 (T2, the weight law and its four consequences), §3 (T3, theta identity and tail bounds), §4 (T4, zero localisation and the sharp partial sum), §5 (T5, zero count), §6 (verdict and parity), §7 (open) | whole file |
| `Rh044/Smoothing.lean` | the definitions `zetaTerm`, `zetaSum`, `smoothedSum`, `quadWeight`; `weighted_decomposition` (L121), `norm_smoothedSum_sub_smoothedSum_le` (L166), `norm_smoothedSum_sub_zetaSum_le` (L184), `norm_zetaSum_sub_smoothedSum_le` (L193), `norm_smoothedSum_sub_zetaSum_le'` (L204), `abs_zetaTerm` (L215), `summable_norm_zetaTerm` (L249), `quadWeight_defect_eq` (L336), `linearWeight_defect_eq` (L358), `zetaSum_sub_smoothedSum_quadWeight` (L365), `weighted_decomposition_quadWeight_defect` (L372); the file header | 383 lines, 32 `theorem`/`lemma` declarations by grep |
| `Rh044.lean` | root module importing `Rh044.Smoothing` | whole file |
| `check.sh` | the build driver: `--all` = `Rh044/Smoothing.lean`, `Rh044.lean`; `LEAN_PREFIX` convention | whole file |
| `smoothed_zeta.py` | the numerics: §1 sharp-cutoff law, §2 smoothing laws (master form $S_N^\varphi-\zeta=N^{1-s}J(\varphi)+\varphi(0)\zeta(s)+R_N$, the weight ladder, the residual slopes, the verdicts (a)/(b)), §3 theta identity and tail bound, §4 zero localisation, §5 summary table | §§1–5; 838 lines |
| `verify/independent_check.py` | the auditor: C1 (sharp cutoff), C2 (smoothed sums), C3 (theta identity), C4 (zero localisation), C5 (zero count), and the claim-level verdicts; the weight set and the two evaluators | whole file; 899 lines |
| `logs/smoothed_zeta.log` | the recorded main run: 59 checks, 0 fail, with the quoted `PASS` lines and the tabulated constants | whole file |
| `logs/independent_check.log` | the recorded audit: 43/43, with the C1–C5 verdicts and the quoted check lines | whole file |
| `logs/lean_check.log` | the recorded Lean run: two `[check] OK` lines | whole file |

Local-only sources: every file in the table is local to this folder. The item is reproduced from `research/truths.md` §5, the programme-level ledger this folder packages; it is not part of this folder and was not read here (the folder's `TRUTHS.md` is its in-folder copy, and `ROUND-NOTES.md`/`ROUND-TRUTHS.md` are the round's own prose).

SHA-256 of the sources whose content is quoted (computed in the packaging pass with `shasum -a 256`):

| source | SHA-256 |
|---|---|
| `README.md` | `5a586cea201abd7647822cd749f1f9554fd546691d5905a8b15fc99f48e9e27b` |
| `TRUTHS.md` | `5794523505c4d559d947a604a0fa6957851ab758c6a75029441b1c8418aabfd4` |
| `ROUND-NOTES.md` | `1091e4de934e85a379b3a924d034a607c24ff7cf254208afd5a7f43f4cfb79ca` |
| `ROUND-TRUTHS.md` | `7a2528e94ae27b75a6abddcc32860bf833b830c63a8871d6bde8eb3aeaad59cd` |
| `Rh044/Smoothing.lean` | `e43f78a857a962347d51bf4f93d1b57fe2b1770de31fbdc5e7d2d4e23e50f87c` |
| `Rh044.lean` | `66901d0b114b49cf6c79c71b8f98b466adad8132315327a321c73b3798d08a7f` |
| `check.sh` | `3e801908e30f30bf301de37c748e1dbc119a6d932b11165e796407dc00cd80f3` |
| `smoothed_zeta.py` | `53b3007c42d0179baa95c4c39bc9e00bec30eb44f90ac66a93909b1da21bf85e` |
| `verify/independent_check.py` | `fe0b4fd3224c317e3ba59ce5a5f63e225e83ea72fdb1791d8505b6930a16f7b5` |
| `logs/smoothed_zeta.log` | `370d7bead4925e5c9bad65fedd5327947abc40e64a90efcc98b563ec50518a08` |
| `logs/independent_check.log` | `778b51afca3add10fb4a86b5b88cce469b874af1090be564f91005274a9147ec` |
| `logs/lean_check.log` | `d4e4289b2b4ce428e91609665bb51fc74858eefa88c2c297583372a27f9f1ab1` |

**Version / provenance.** The folder is `publish/005-smoothing-bridge`, round `rh044` of the programme. The Lean toolchain used for the recorded and re-run checks is `leanprover/lean4:v4.35.0-rc2` with Mathlib4 from `$HOME/lean/mathlib4`; the numerics used `mpmath 1.3.0` with the precision raised per section (60 dps for §§1–2, 120 dps for §3, 60 dps for §§4–5, as reported in the run output).
