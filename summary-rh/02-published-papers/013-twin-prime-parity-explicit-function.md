# 013 — Twin-Prime Parity: the Complete Registry and the Explicit-Function Programme

| Field | Value |
|---|---|
| Source | [`research/publish/013-twin-prime-parity-explicit-function/manuscript.md`](../rh/research/publish/013-twin-prime-parity-explicit-function/manuscript.md) |
| Status | Published synthesis; 013. |
| Harvested statements | 10 |

## Abstract

This folder is the programme's own registry — 3 objectives, 27 tasks, a 263-round log, an
18-entry harvest and a 29-node Lean dependency map — together with every artefact the
registry names: 97 Lean modules, a Python interval-arithmetic module, 38 deterministic
probe scripts, 13 verification logs and five HTML papers. The manuscript reports the three
objectives it declares.

**O3 (η/Euler route).** Everything is classical and re-measured: $\eta=(1-2^{1-s})\zeta$
converges for $\operatorname{Re}s>0$ by odd/even cancellation, Euler's transformation makes
the tail geometric, and the route is an *evaluator*, not a certification. It is not proved
here that any $\zeta(1/2+i\gamma)=0$.

**O1 (Dirichlet generalisation).** The Route A/B/C theorem cores are *already* general in
Lean; the Dirichlet instantiation is closed except for two classical inputs. Certified:
the normalisation $h(1-s)=\varepsilon h(s)$, the log-derivative reflection, conjugation
reality $\Lambda_\chi(\overline s)=\overline{\Lambda_\chi(s)}$ for every real character,
$\text{rootNumber}\in\{\pm1\}$, the composite-modulus Gauss-sum square, the analytic
hypotheses, a Turing window $1/2<\operatorname{Im}s<10$ for $\chi_3$, and a compiled
conditional Riemann–von Mangoldt count from $h_L,h_H$. **Open:** the sharp archimedean rate
$\|\Gamma(\sigma+it)\|\le 2\sqrt{2\pi}|t|^{\sigma-1/2}e^{-(\pi/2)|t|}$ is *mathematically
complete and verified* (sup ratio 0.559) but its Lean formalisation is one lemma short.

**O2 (decomposition lab).** A negative verdict, recorded so it is not retried: the harmonic
tier cannot see zeros.

The tally is 19 done · 3 refuted · 3 blocked · 2 open. Nothing is proved about twin primes
or the parity obstruction: $\sum_{n\le x}\lambda(n)\lambda(n+2)=o(x)$ remains **OPEN**.

## Harvested theorem-like statements

### Proposition 3.1 (exact algebraic relation; O3.T1, `done`).

$$E_N(s)=2^{-s}S_{\lfloor N/2\rfloor}(s),\qquad
O_N=S_N-2^{-s}S_{\lfloor N/2\rfloor},\qquad
\eta_N=S_N-2^{1-s}S_{\lfloor N/2\rfloor}.$$
*Status:* the paper's status table records this as **PROVED** (exact algebra)
(`html/eta-euler-acceleration.html`, §9 row 2; §2.1). This is the identity the whole route
rests on (`objectives.json`, `O3.T1`).

### Proposition 3.2 (why the growing parts cancel; O3.T2, `done`).

By Euler–Maclaurin, for
$s\ne1$,
$$S_N(s)=\zeta(s)+\frac{N^{1-s}}{1-s}+\tfrac12N^{-s}+O(N^{-s-1}).$$
Substituting $N\to\lfloor N/2\rfloor$ and multiplying by $2^{1-s}$ gives
$2^{1-s}(N/2)^{1-s}/(1-s)=N^{1-s}/(1-s)$: the two $N^{1-s}$ terms are identical and cancel,
leaving
$$\eta_N(s)=(1-2^{1-s})\zeta(s)+O(N^{-\sigma})=\eta(s)+O(N^{-\sigma}).$$
On $\sigma=1/2$ the error is $O(N^{-1/2})$; measured at $t=\gamma_1$ the constant is $0.5$
($N^{1/2}|\eta_N|\to0.5000$, Table 5.1). *Status:* **PROVED** (exact algebra + Euler–Maclaurin)
(§9 row 2).

### Proposition 3.3 (evolution of the two sums; O3.T5, `done`).

$$|O_N|\approx|E_N|\approx\frac{\sqrt N}{2|1-s|},\qquad |S_N|\approx\frac{\sqrt N}{|1-s|},
\qquad |\eta_N|\approx\frac{0.5}{\sqrt N}.$$
At $N=400$, $t=\gamma_1$: $|O_N|=0.7072$, $|E_N|=0.7081$, $|\eta_N|=2.499\cdot10^{-2}$,
$|S_N|=1.4150$, against the guides $\sqrt N/(2|1-s|)=0.7070$ and $0.5/\sqrt N=2.50\cdot10^{-2}$
(§2.3). *Status:* **NUMERICAL** (matches the Euler–Maclaurin prediction) (§9 row 3).

### Proposition 3.4 (Euler's transformation and its operator derivation; O3.T3, `done`).

With
$E$ the shift $Ea_n=a_{n+1}$ and $\Delta=1-E$,
$$(1+E)^{-1}=(2-(1-E))^{-1}=(2-\Delta)^{-1}=\tfrac12(1-\Delta/2)^{-1}
=\sum_{k\ge0}\frac{\Delta^k}{2^{k+1}},$$
whence $\sum(-1)^na_n=\sum_k\Delta^ka_0/2^{k+1}$. On $a_n=1/(n+1)$ the check is
$\sum_m1/(m2^m)=\ln2$. *Status:* **THEOREM** (Euler, classical) (§9 row 4).

The Hausdorff form is recorded in §3.1: for $a_n=\int_0^1t^nd\mu(t)$,

$$\sum_{n\ge0}(-1)^na_n=\int_0^1\frac{d\mu(t)}{1+t},\qquad
\Delta^ka_0=\int_0^1(1-t)^kd\mu(t),$$

with tail $\int_0^1(1-t)^{K+1}2^{-(K+1)}(1+t)^{-1}d\mu(t)$; the $(1-t)^{K+1}$ concentrates the
integral near $t=0$, "which is why convergence is geometric once the mass has localized — the
transient identified in §4.3."

### Proposition 3.5 (accuracy, measured; O3.T5/T6/T7, `done`).

At $t=\gamma_1$, in high
precision so that only truncation survives (Table 5.2):

| $K$ | 8 | 16 | 24 | 32 | 40 | 48 | 56 | 64 | 80 | 96 | 128 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| $|\text{error}|$ | 7.3e−1 | 4.1e−2 | 6.3e−4 | 5.2e−6 | 3.3e−8 | 1.8e−10 | 8.6e−13 | 4.0e−15 | 7.5e−20 | 1.3e−24 | 3.5e−34 |

The decay is geometric with an effective ratio $\approx1/2$ per added difference order over
this range (errors track $2^{-(K-17)}$), i.e. about one decimal digit per $3.3$ added orders,
far better than the raw $N^{-1/2}$. *Status:* **NUMERICAL** (§9 row 6).

### Proposition 3.6 (the transient and the cost in $t$; O3.T5).

The transformed terms
$T_k=\Delta^ka_1/2^{k+1}$ are not monotone: at $\gamma_1$ they dip to about $4.9\cdot10^{-2}$
near $k=4$, rise to about $1.74\cdot10^{-1}$ near $k=7$, and only then turn down. The first
difference order at which $|T_k|<10^{-13}$:

| $t$ | 14.13 | 30 | 50 | 100 | 200 | 500 |
|---|---|---|---|---|---|---|
| first $k$ with $|T_k|<10^{-13}$ | 59 | 79 | 101 | 152 | 243 | 488 |

"So the term count grows roughly linearly in $t$ (about $0.9t+45$ over this range), i.e.
$O(t)$ terms and $O(t^2)$ work for the difference table." *Status:* **NUMERICAL** (fitted over
$t\le500$) (§9 row 8).

### Proposition 3.7 (the difference table, and why the weights are needed; O3.T6, `done`).

For $a_n=n^{-1/2-i\gamma_1}$:

| $k$ | 0 | 3 | 7 | 12 | 20 | 28 | 34 |
|---|---|---|---|---|---|---|---|
| $|\Delta^ka_1|$ | 1.000 | 1.170 | 4.457e+1 | 6.135e+2 | 5.087e+3 | 1.485e+4 | 2.438e+4 |
| $|T_k|$ | 5.00e−1 | 7.31e−2 | 1.74e−1 | 7.49e−2 | 2.43e−3 | 2.77e−5 | 7.10e−7 |

The raw differences grow by four orders of magnitude; "the $2^{-(k+1)}$ weight reverses the
trend. This is also the source of the double-precision floor." *Status:* **NUMERICAL**
(§5.3, §9 row 5 "for the identity" is **THEOREM**; the table itself is numerical).

### Proposition 3.8 (the IEEE-double floor and the optimal $K$; O3.T7, `done`).

In IEEE double
at $\gamma_1$:

| $K$ | 48 | 56 | 64 | 72 | 96 | 128 | 192 | 256 |
|---|---|---|---|---|---|---|---|---|
| $|\text{euler}_K|$ | 1.76e−10 | 8.60e−13 | 3.95e−15 | 1.75e−15 | 2.51e−15 | 3.60e−15 | 4.91e−15 | 5.80e−15 |

Because $\eta(1/2+i\gamma_1)=0$ exactly, $|\text{euler}_K|$ is the error. The optimum is near
$K\approx72$; the floor $\approx2\cdot10^{-15}$ is the green reference line of the paper's
Figure 2. Round-off arises because $\Delta^ka_1$ is a difference of nearly equal numbers, and a
perturbation $\varepsilon$ can grow like $2^k\varepsilon$ through $k$ levels of subtraction;
the weight $2^{-(k+1)}$ compensates exactly, so the propagated error is $O(\varepsilon)$ and
does not explode — "but it does set a floor." *Status:* **NUMERICAL** (§5.4, §9 row 7).

### Proposition 3.9 (the zero information is in the tail).

The raw partial sum at a zero is
**not** zero (Table 5.1):

| $N$ | 10 | 100 | 300 | 1 000 | 10 000 | 30 000 |
|---|---|---|---|---|---|---|
| $|\eta_N(1/2+i\gamma_1)|$ | 1.955e−1 | 5.000e−2 | 2.885e−2 | 1.581e−2 | 5.000e−3 | 2.887e−3 |
| $N^{1/2}|\eta_N|$ | 0.618 | 0.500 | 0.500 | 0.500 | 0.500 | 0.500 |

At $K=128$, by contrast, the Euler transform at the same zeros reads

| $t$ | 14.134725 ($\gamma_1$) | 21.022040 ($\gamma_2$) | 25.010858 ($\gamma_3$) |
|---|---|---|---|
| raw $|O_{300}-E_{300}|$ | 2.89e−2 | 2.89e−2 | 2.89e−2 |
| $|\eta|$ (Euler, 128 terms) | 3.95e−15 | 1.70e−12 | 3.70e−11 |

and off a zero (at $\gamma_i+0.5$) the Euler value is $9.29e-1$, $1.22e+0$, $9.86e-1$
respectively. Note that $128$ terms is not always enough: $\gamma_3$ "would prefer
$\approx162$" (§2.4). *Status:* **NUMERICAL**; §6 of the paper draws the consequence.

### Proposition 3.10 (verdict of the objective; O3.T8, `done`).

The route is an *evaluator*.
A small value of $|\eta|$ at some $t$ is evidence, not proof, that $\zeta(1/2+it)=0$; the
function could be small without vanishing, and floating-point error can mask a small non-zero
value. To certify a zero one needs Route A (interval arithmetic, a sign change of
$Z(t)=e^{i\theta(t)}\zeta(1/2+it)$ on a rational bracket plus a root-isolation argument),
Route B (Turing's method: a rigorous count $N(T)$ plus matching sign changes) or Route C (a
validated explicit formula). The paper's status table records "certifying a zero (interval
$Z(t)$, Turing's method)" as **OUT OF SCOPE**, and "evaluating $\zeta(1/2+it)$" as
**NUMERICAL — not a proof of any zero** (§9, last two rows).

**O3's failure modes, as recorded** (`html/eta-euler-acceleration.html` §7): the
$\operatorname{Re}s=1$ factor zeros (at $\sigma=1.000$ the reference line reads zero at
$t\approx9.0647k$ for the wrong reason); division near $\sigma=1$ loses precision as
$1-2^{1-s}\to0$; a fixed $K=128$ is "ample at $\gamma_1$ but marginal at $\gamma_3$ and
useless at $t=200$"; at large $t$ the raw differences overflow double precision before the
transient ends (at $t=800$, circa $k\approx1000$); Euler's transformation accelerates a
convergent series, it does not create convergence; and it cannot be applied to $\zeta$'s own
Dirichlet series.

**The selector data (a companion artefact).** `html/eta_selectors.html` rewrites the phase
$e^{-it\log n}$ as $\sin(t\log n)=\varepsilon_n\sin\bigl(\pi\sum_{k\in A_n}1/(k+2)\bigr)$
with the greedy boolean selectors $\delta_k\in\{0,1\}$; at $t=\gamma_1=14.134725\ldots$,
$\sigma=1/2$ it reproduces `data/eta_selectors.tsv`. Its own caveat is explicit: "The greedy
word $(\delta_k)$ is a function of the phase $t\log n$ alone, so $\sigma$ does not change the
squares — it only sets the amplitude $n^{-\sigma}$. The selectors are index/phase data; the
vanishing needs the weighted sum. Zeros here are found by bisection on $\eta$
(Euler-transformed), not from the selectors." The measured gap between the direct and
digit-map curves is the greedy truncation, $\approx3\cdot10^{-6}$
(`html/eta-euler-acceleration.html` §8).

## Source

[`manuscript.md`](../rh/research/publish/013-twin-prime-parity-explicit-function/manuscript.md) · [`README.md`](../rh/research/publish/013-twin-prime-parity-explicit-function/README.md)
