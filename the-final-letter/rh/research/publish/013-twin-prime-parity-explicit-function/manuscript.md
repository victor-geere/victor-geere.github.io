# Twin-prime parity: the complete registry and the explicit-function programme

**Thirteenth published edition — a reorganised, self-contained snapshot of the
twin-prime-parity programme as recorded in `objectives.json` (schema 1.0, generated
2026-10-16T06:17:19 by `research/build_objectives.py`). Every statement, status, constant
and round number below is read from a file in this folder; where the folder's own entries
disagree, the disagreement is reported rather than resolved silently.**

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

## 1. Introduction and goal

### 1.1 What this folder is

This is the programme's **complete registry snapshot**: it is not a single round but the
self-describing ledger of every round. `README.md` gives the layout; `objectives.json` is
the machine-readable registry (`schema_version` 1.0); `truths.md` is the harvested ledger of
what the programme holds to be established, with Lean locators; `research-journal.md` is the
project-wide journal (677 sections, ~2 MB) compacted to its outcome-relevant content;
`html/objectives.html` is the human-readable chronicle of the same registry; and
`html/{eta-euler-acceleration,decomposition_lab,dirichlet-011,eta_selectors}.html` are the
four substantive papers. `lean/` consolidates 97 modules under one root with a single
`check.sh`; `python/` consolidates the interval engine (`ivmath`, `eta_interval`,
`dirichlet_interval`), the 38 probe scripts and the per-round verifiers; `notes/` holds the
proof notes and handoffs; `logs/`, `data/` and `assets/` hold the evidence and the three
figures.

The registry's own workflow rules are part of the record and constrain how the results may
be read (`objectives.json`, `workflow`):

> * **round rule** — every round adds or updates exactly one task: increment `attempts`, set
>   `last_attempt`, refresh `status`, append to `evidence`.
> * **maths rule** — do the mathematics in Python first (the script must run and be
>   reproducible), then state and prove the Lean theorem.
> * **formalisation rule** — no `sorry`, no `admit`, no `axiom`, no `native_decide`; every
>   declaration's `#print axioms` must be exactly
>   `[propext, Classical.choice, Quot.sound]`.
> * **dependency rule** — the module graph and every task's theorem → module link live in the
>   registry under `lean_dependencies` and `tasks[].lean`.

The status vocabulary is `open, in_progress, done, refuted, blocked, withdrawn`
(`objectives.json`, `workflow.status_vocabulary`); the ranking rule is
`priority = tractability_index * value_index`, and the goal works the highest-priority
open/in-progress task (`objectives.json`, `ranking_rule`).

### 1.2 The three objectives

`README.md` §"The three objectives" and `objectives.json` name them:

| id | title | source | T · E · V |
|---|---|---|---|
| **O1** | Can Routes A, B, C be generalised? | `html/dirichlet-011.html` | 3 · 4 · 4 |
| **O2** | Decomposition-lab §2–§3 and the zeta series: what the harmonic tier can and cannot do | `notes/decomposition-lab-notes.md` | 5 · 1 · 3 |
| **O3** | The η/Euler route to ζ on the critical line: alternation, the odd/even split, and convergence acceleration | `html/eta-euler-acceleration.html` | 4 · 3 · 3 |

(T, E, V are `tractability_index`, `effort_index`, `value_index`; `objectives.json`,
`objectives[i]`.)

**Why the programme cares.** The three certification routes of round 010 — Route A (a sign
change plus a one-signed derivative pins one simple on-line zero), Route B (a rigorous count
plus matching certificates closes a whole window), Route C (a validated error budget for the
explicit formula) — were built for $\zeta$. O1 asks whether they are a zeta-specific trick or
a reusable instrument. O3 asks whether the alternating series gives a cheaper *evaluation* of
$\zeta$ on the critical line, and where evaluation stops and certification begins. O2 asks
whether a term-level harmonic decomposition of $\zeta$ can see a zero at all.

**What is in scope; what is not.** In scope: the three objectives' mathematics, their statuses
as the registry records them, their evidence, and their open obligations. Out of scope, and
never claimed anywhere in this folder: any statement about twin primes, and any statement
about the parity obstruction. The registry's `harvest.not_done` field is one sentence: *"Nothing
has been proved about twin primes or the parity obstruction: Σ_{n≤x} λ(n)λ(n+2) = o(x) remains
OPEN."*

**The parity barrier, stated as the folder states it.** The programme's positive results are
methodological — identities, thresholds, sieve bounds, an explicit formula, an archimedean
rate. `truths.md` §13 puts the point in one line: "And the one thing it did not do: prove
anything about twin primes or the parity obstruction."

## 2. Setup and definitions

### 2.1 The two series (O3)

Following `html/eta-euler-acceleration.html` §1, Definition 1.1:

$$\zeta(s)=\sum_{n\ge1}n^{-s}\quad(\operatorname{Re}s>1),\qquad
\eta(s)=\sum_{n\ge1}(-1)^{n-1}n^{-s}\quad(\operatorname{Re}s>0),$$
$$\eta(s)=(1-2^{1-s})\zeta(s),\qquad \eta(1)=\ln 2 .$$

The identity extends to $\operatorname{Re}s>0$ because both sides are analytic there; the
pole of $\zeta$ at $s=1$ is cancelled by the zero of the prefactor. On the critical strip,
$1-2^{1-s}$ never vanishes, so $\eta(\sigma+it)=0\iff\zeta(\sigma+it)=0$; but
$1-2^{1-s}=0$ on the whole line $\operatorname{Re}s=1$, at $t=2\pi k/\log 2\approx9.0647k$,
where $\eta$ has zeros that are *not* zeros of $\zeta$ (the trap recorded in
`html/eta-euler-acceleration.html` §1.2 and §7).

Odd/even partial sums (Definition 2.1):

$$S_N(s)=\sum_{n\le N}n^{-s},\qquad O_N(s)=\sum_{\substack{n\le N\\ n\ \text{odd}}}n^{-s},
\qquad E_N(s)=\sum_{\substack{n\le N\\ n\ \text{even}}}n^{-s},$$
$$S_N=O_N+E_N,\qquad \eta_N:=O_N-E_N=\sum_{n\le N}(-1)^{n-1}n^{-s}.$$

Forward differences and Euler's transformation (Definition 3.1):

$$\Delta a_n=a_n-a_{n+1},\qquad \Delta^ka_n=\Delta(\Delta^{k-1}a_n),\qquad
\sum_{n\ge0}(-1)^na_n=\sum_{k\ge0}\frac{\Delta^ka_0}{2^{k+1}} .$$

The accelerator family is Aitken $\Delta^2$,
$\hat s_n=s_n-(\Delta s_n)^2/\Delta^2s_n$; Shanks' $e_k$ (a ratio of Hankel determinants and
the $[n+k/k]$ Padé approximant of the term-generating function); Wynn's
$\varepsilon$ recursion
$\varepsilon_{-1}^{(n)}=0,\ \varepsilon_0^{(n)}=s_n,\
\varepsilon_{k+1}^{(n)}=\varepsilon_{k-1}^{(n+1)}+1/(\varepsilon_k^{(n+1)}-\varepsilon_k^{(n)})$;
and Richardson, Levin, Weniger, Borwein and Cohen–Rodriguez Villegas–Zagier
(`html/eta-euler-acceleration.html` §§3.2–3.5).

The **evaluation formula** (Algorithm 4.1) is: for $s=\sigma+it$, $\sigma>0$, $\sigma\ne1$,

$$\eta(s)=\sum_{k\ge0}\frac{\Delta^ka_1}{2^{k+1}},\quad a_n=n^{-s};
\qquad \zeta(s)=\frac{\eta(s)}{1-2^{1-s}} .$$

On $\sigma=1/2$ the division is harmless ($|1-2^{1-s}|>0.58$).

### 2.2 Certification: Routes A, B, C

As stated in `html/dirichlet-011.html` §§3–5 and available in `lean/Rh45/`:

* **Route A** (`lean/Rh45/Routes.lean:37`):
  $f$ continuous on $[a,b]$, $f'>0$ on $(a,b)$, $f(a)<0<f(b)$
  $\Longrightarrow$ a unique simple root in $(a,b)$. The enclosure form is
  `certified_root_of_enclosures` (`lean/Rh45/Routes.lean:71`).
* **Route B, combinatorial layer** — `turing_reduction` for an arbitrary finite type:
  `certified ⊆ zeros` and `zeros.card ≤ certified.card` $\Longrightarrow$ `zeros = certified`
  (`lean/Rh45/Routes.lean:95`). **Route B, analytic layer** (`routeB_reduction`,
  `lean/Rh45/RouteBAnalytic.lean:227`): for an analytic $f:\mathbb C\to\mathbb C$ with a
  functional equation $f(1-s)=f(s)$, conjugation reality $f(\overline s)=\overline{f(s)}$ and
  zero data $(Z,m)$, $\operatorname{Im}\bigl(\text{rightPath}(\operatorname{logDeriv}f)\bigr)
  =\pi\sum_{z\in Z}m(z)$.
* **Route C** (`validated_truncation_bound`, `lean/Rh45/Routes.lean:106`): the residual is
  bounded by the sum of the three tails.

### 2.3 The Dirichlet instantiation

With $\chi$ a Dirichlet character mod $N$, $\Lambda_\chi$ Mathlib's
`completedLFunction χ`, $\varepsilon=\texttt{rootNumber }\chi$, and
$h(s)=N^{s/2}\Lambda_\chi(s)$ (`lean/Generic.lean`, and `notes/generality-lean.md` §3):

$$h(1-s)=\varepsilon\,h(s),\qquad
\operatorname{logDeriv}h(1-s)=-\operatorname{logDeriv}h(s)\ (\varepsilon\ne0),$$
$$\texttt{dirichletCompleted}\ \chi\ s=N^{s/2}\,\Lambda_\chi(s).$$

The **interface** whose discharge is the point of O1 (`lean/DirichletZeroCounting.lean:480`,
quoted in `notes/handoff-013.md` §1):

$$\texttt{CriticalStripLogDerivBound}\ \chi:\quad
\exists C>0,\ \forall t_0<t_1,\ T\ge\max(|t_0|,|t_1|):$$
$$\int_{1/2}^{1}\!\|\Lambda_\chi'(x+it_0)/\Lambda_\chi(x+it_0)\|dx
+\int_{t_0}^{t_1}\!\|\Lambda_\chi'(1+iy)/\Lambda_\chi(1+iy)\|dy
+\int_{1/2}^{1}\!\|\Lambda_\chi'(x+it_1)/\Lambda_\chi(x+it_1)\|dx
\ \le\ C\,\bigl(1+\log(N(T+2))\bigr)\bigl(1+|t_1-t_0|\bigr).$$

**Note the object is the integral, not the integrand.** A pointwise bound on
$\|\Lambda'/\Lambda\|$ over the strip is false: `deriv Λ / Λ` is unbounded *near* a zero while
defined there (`notes/handoff-013.md` §1, citing journal §117). The integral bound is what the
argument-principle count consumes.

The two named inputs are
$$h_L:\quad \|\operatorname{logDeriv}L(\chi,\cdot)(1+iy)\|\le C_L\,(1+\log(|y|+2)),$$
$$h_H:\quad \text{a uniform horizontal-edge bound, in its }\textit{integrable}\ \text{case only,}$$
both PNT-strength (`objectives.json`, `O1.T5`/`O1.T9`/`O1.T11` `blocked_reason`).

### 2.4 The sharp archimedean rate (O1.T6 / O1.T12)

Final target, fully specified (`objectives.json`, `O1.T12`; `notes/sharp-gamma-rate.md`):

$$\|\Gamma(\sigma+it)\|\ \le\ 2\sqrt{2\pi}\,|t|^{\sigma-1/2}e^{-(\pi/2)|t|},
\qquad |t|\ge2,\quad \sigma\in[0.25,2].$$

The route is the **GammaSeq product form** (Euler's product):

$$\|\Gamma(s)\|=\lim_{n\to\infty}\|\texttt{GammaSeq}\ s\ n\|,\qquad
\log\|\texttt{GammaSeq}\ s\ n\|=\sigma\log n+\log n!-\sum_{j=0}^{n}\tfrac12\log\bigl((\sigma+j)^2+t^2\bigr),
\quad s=\sigma+it .$$

The missing Lean ingredient is the **Euler–Maclaurin endpoint term**
(`notes/sharp-gamma-rate.md` §1):

$$\sum_{j=0}^nf(j)=\int_0^nf+\tfrac12\bigl(f(0)+f(n)\bigr)+\tfrac1{12}\bigl(f'(n)-f'(0)\bigr)+R_n,
\qquad f(x)=\tfrac12\log\bigl((\sigma+x)^2+t^2\bigr).$$

$f$ is convex on $[0,n]$ exactly when $n\le|t|-\sigma$
($f''(x)=\bigl(t^2-(\sigma+x)^2\bigr)/\bigl((\sigma+x)^2+t^2\bigr)^2$), so there the trapezoidal
rule gives $\sum_{j=0}^nf(j)\ge\int_0^nf+\tfrac12(f(0)+f(n))$; the concave tail needs the
bounded remainder $R_n$.

### 2.5 The interval engine

`python/ivmath.py` implements rigorous real arithmetic: a `Num` is
$[v-e,\,v+e]$ with `v, e` `mpf` at `WORK = 400` decimal digits and `EPS = 1e-320` of blanket
rounding slack; the transcdentals are not taken from mpmath — $\pi$ is Machin's formula
$\pi=16\arctan(1/5)-4\arctan(1/239)$ with an alternating-remainder bound, $\log n$ is
$2\,\mathrm{atanh}((n-1)/(n+1))$ over the prime factors, and $\cos$ is reduction mod $2\pi$
plus a Taylor series with the alternating-series bound (`python/ivmath.py:1–30`). The
programme's intent is that a sign decided from a `Num` is a proof.

`python/eta_interval.py` and `python/dirichlet_interval.py` build the $\zeta$ and Dirichlet
$L$ enclosures on top: $\zeta(s,a)$, $\zeta'$, $\zeta''$, $L$, $L'/L$, $(L'/L)'$,
$\Lambda_\chi'/\Lambda_\chi$, $(\log\Lambda_\chi)''$ on boxes, by Euler–Maclaurin with a
periodic-Bernoulli remainder and no mpmath in the rigorous path.

### 2.6 Registry vocabulary and the two legends that differ

Three different status legends appear in the folder, and the manuscript keeps them apart:

* **`objectives.json` task statuses**: `open | in_progress | done | refuted | blocked | withdrawn`.
* **`truths.md` statuses**: **PROVED (Lean)**, **PROVED (Lean + `native_decide`)**, **PROVED (paper)**,
  **VERIFIED**, **CHECKED**, **REFUTED**, **OPEN**, each defined in `truths.md:8–19`.
* **`notes/decomposition-lab-notes.md:11–13`**: **PROVED**, **VERIFIED**, **NUMERICAL**, **HEURISTIC**,
  **OPEN**, **REFUTED (with witness)**.

Where this manuscript writes "PROVED", "VERIFIED", "MEASURED", "REFUTED" or "OPEN" it is
quoting one of these legends, and it says which.

## 3. Results

Statuses below are the registry's. Distinct proved results keep distinct statuses.

### 3.1 O3 — the η/Euler route: an evaluator, and only an evaluator

O3 has 8 tasks, **all `done`** (`objectives.json`, objective O3; `html/objectives.html` §2.3).
The mathematics is classical and is re-derived and re-measured in
`html/eta-euler-acceleration.html`. The paper's own "Honest headline" is explicit: "Everything
here is classical. […] Nothing here proves that any $\zeta(1/2+i\gamma)=0$."

**Proposition 3.1 (exact algebraic relation; O3.T1, `done`).**
$$E_N(s)=2^{-s}S_{\lfloor N/2\rfloor}(s),\qquad
O_N=S_N-2^{-s}S_{\lfloor N/2\rfloor},\qquad
\eta_N=S_N-2^{1-s}S_{\lfloor N/2\rfloor}.$$
*Status:* the paper's status table records this as **PROVED** (exact algebra)
(`html/eta-euler-acceleration.html`, §9 row 2; §2.1). This is the identity the whole route
rests on (`objectives.json`, `O3.T1`).

**Proposition 3.2 (why the growing parts cancel; O3.T2, `done`).** By Euler–Maclaurin, for
$s\ne1$,
$$S_N(s)=\zeta(s)+\frac{N^{1-s}}{1-s}+\tfrac12N^{-s}+O(N^{-s-1}).$$
Substituting $N\to\lfloor N/2\rfloor$ and multiplying by $2^{1-s}$ gives
$2^{1-s}(N/2)^{1-s}/(1-s)=N^{1-s}/(1-s)$: the two $N^{1-s}$ terms are identical and cancel,
leaving
$$\eta_N(s)=(1-2^{1-s})\zeta(s)+O(N^{-\sigma})=\eta(s)+O(N^{-\sigma}).$$
On $\sigma=1/2$ the error is $O(N^{-1/2})$; measured at $t=\gamma_1$ the constant is $0.5$
($N^{1/2}|\eta_N|\to0.5000$, Table 5.1). *Status:* **PROVED** (exact algebra + Euler–Maclaurin)
(§9 row 2).

**Proposition 3.3 (evolution of the two sums; O3.T5, `done`).**
$$|O_N|\approx|E_N|\approx\frac{\sqrt N}{2|1-s|},\qquad |S_N|\approx\frac{\sqrt N}{|1-s|},
\qquad |\eta_N|\approx\frac{0.5}{\sqrt N}.$$
At $N=400$, $t=\gamma_1$: $|O_N|=0.7072$, $|E_N|=0.7081$, $|\eta_N|=2.499\cdot10^{-2}$,
$|S_N|=1.4150$, against the guides $\sqrt N/(2|1-s|)=0.7070$ and $0.5/\sqrt N=2.50\cdot10^{-2}$
(§2.3). *Status:* **NUMERICAL** (matches the Euler–Maclaurin prediction) (§9 row 3).

**Proposition 3.4 (Euler's transformation and its operator derivation; O3.T3, `done`).** With
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

**Proposition 3.5 (accuracy, measured; O3.T5/T6/T7, `done`).** At $t=\gamma_1$, in high
precision so that only truncation survives (Table 5.2):

| $K$ | 8 | 16 | 24 | 32 | 40 | 48 | 56 | 64 | 80 | 96 | 128 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| $|\text{error}|$ | 7.3e−1 | 4.1e−2 | 6.3e−4 | 5.2e−6 | 3.3e−8 | 1.8e−10 | 8.6e−13 | 4.0e−15 | 7.5e−20 | 1.3e−24 | 3.5e−34 |

The decay is geometric with an effective ratio $\approx1/2$ per added difference order over
this range (errors track $2^{-(K-17)}$), i.e. about one decimal digit per $3.3$ added orders,
far better than the raw $N^{-1/2}$. *Status:* **NUMERICAL** (§9 row 6).

**Proposition 3.6 (the transient and the cost in $t$; O3.T5).** The transformed terms
$T_k=\Delta^ka_1/2^{k+1}$ are not monotone: at $\gamma_1$ they dip to about $4.9\cdot10^{-2}$
near $k=4$, rise to about $1.74\cdot10^{-1}$ near $k=7$, and only then turn down. The first
difference order at which $|T_k|<10^{-13}$:

| $t$ | 14.13 | 30 | 50 | 100 | 200 | 500 |
|---|---|---|---|---|---|---|
| first $k$ with $|T_k|<10^{-13}$ | 59 | 79 | 101 | 152 | 243 | 488 |

"So the term count grows roughly linearly in $t$ (about $0.9t+45$ over this range), i.e.
$O(t)$ terms and $O(t^2)$ work for the difference table." *Status:* **NUMERICAL** (fitted over
$t\le500$) (§9 row 8).

**Proposition 3.7 (the difference table, and why the weights are needed; O3.T6, `done`).**
For $a_n=n^{-1/2-i\gamma_1}$:

| $k$ | 0 | 3 | 7 | 12 | 20 | 28 | 34 |
|---|---|---|---|---|---|---|---|
| $|\Delta^ka_1|$ | 1.000 | 1.170 | 4.457e+1 | 6.135e+2 | 5.087e+3 | 1.485e+4 | 2.438e+4 |
| $|T_k|$ | 5.00e−1 | 7.31e−2 | 1.74e−1 | 7.49e−2 | 2.43e−3 | 2.77e−5 | 7.10e−7 |

The raw differences grow by four orders of magnitude; "the $2^{-(k+1)}$ weight reverses the
trend. This is also the source of the double-precision floor." *Status:* **NUMERICAL**
(§5.3, §9 row 5 "for the identity" is **THEOREM**; the table itself is numerical).

**Proposition 3.8 (the IEEE-double floor and the optimal $K$; O3.T7, `done`).** In IEEE double
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

**Proposition 3.9 (the zero information is in the tail).** The raw partial sum at a zero is
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

**Proposition 3.10 (verdict of the objective; O3.T8, `done`).** The route is an *evaluator*.
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

### 3.2 O1 — the Dirichlet generalisation

O1 has 12 tasks: **7 `done`, 3 `blocked`, 2 `open`** (`objectives.json`; `html/objectives.html`
§2.1, §8). This is the substantive campaign of the folder.

#### 3.2.1 The audit: the cores already are general

**Result 3.11 (O1.T1, `done`; status **AUDITED**).** The theorem cores quantify over arbitrary
objects, not over $\zeta$ (`html/dirichlet-011.html` §2, §10 "Status"):

| route | theorem | quantifies over | function-specific inputs |
|---|---|---|---|
| A | `exists_unique_root_of_sign_change` | $f:\mathbb R\to\mathbb R$ | an interval evaluator for $f$ and $f'$ |
| A | `certified_root_of_enclosures` | same | the enclosures themselves |
| B | `turing_reduction` | `Finset α`, any `α` | nothing — pure combinatorics |
| B | `routeB_reduction_general` | $f:\mathbb C\to\mathbb C$ | functional equation, reality, zero data, log-deriv evaluator |
| C | `validated_truncation_bound` | any three real tails | the explicit formula and a bound per tail |

The paper's answer to its own title question is "the cores already are; the work is in the
instantiation" (§2). Route C's $n$-tail generalisation is *new* here
(`validated_truncation_bound_finset`, `lean/Generic.lean`; `notes/generality-lean.md` §2),
proved by `Finset.induction_on` using `abs_add_le` and `Finset.sum_insert`; the 010 3-tail
statement is recovered as the `Finset (Fin 3)` instance
(`validated_truncation_bound_three`). The verification interface is packaged
(`notes/generality-lean.md` §1):

```lean
structure SelfDualReal (F : ℂ → ℂ) : Prop where
  selfDual : ∀ s, F (1 - s) = F s
  conjSymm : ∀ s, F (conj s) = conj (F s)
```

**Caveat, recorded by the source.** Route A "generalises to simple transversal zeros only":
the theorem concludes $0<\operatorname{deriv}f\,x$, so it certifies exactly the zeros that are
simple and crossing; a double zero on the line would be invisible to a sign change, and an
even-order zero off the line is invisible to this route entirely. "That is a genuine
limitation of the statement, not of the formalisation, and it does not go away by generalising
the function" (`html/dirichlet-011.html` §3).

#### 3.2.2 The instantiation: what is closed

All statements in this subsection are **PROVED (Lean)** with `#print axioms` exactly
`[propext, Classical.choice, Quot.sound]`; the registry gives each task the Lean file cited
in `lean_dependencies.task_to_module` and the axioms list
`["propext","Classical.choice","Quot.sound"]`.

**Result 3.12 (normalisation; O1.T2, `done`).** `dirichletL_normalised_one_sub`
(`lean/Generic.lean`, `notes/generality-lean.md` §3):
$$N^{(1-s)/2}\Lambda_\chi(1-s)=\varepsilon\,N^{s/2}\Lambda_\chi(s),\qquad
\text{whence } \texttt{dirichletCompleted}\ \chi\,(1-s)=\varepsilon\,\texttt{dirichletCompleted}\ \chi\,s .$$
The exponent bookkeeping is $(1-s)/2+(s-1/2)=s/2$; the derivation uses `Complex.cpow_add`,
`IsPrimitive.completedLFunction_one_sub` and `ring`. Module:
`lean/DirichletCompletedSymmetry.lean`.

**Result 3.13 (Route B needs only the log-derivative reflection; O1.T3, `done`).**
`logDeriv_one_sub_of_const_mul` (`notes/generality-lean.md` §1): for $\varepsilon\ne0$ and
$h(1-s)=\varepsilon h(s)$,
$$\operatorname{logDeriv}h\,(1-s)=-\operatorname{logDeriv}h\,(s).$$
*Proof:* differentiating gives $-h'(1-s)=\varepsilon h'(s)$, so
$\operatorname{logDeriv}h(1-s)=h'(1-s)/h(1-s)=(-\varepsilon h'(s))/(\varepsilon h(s))
=-\operatorname{logDeriv}h(s)$; the factor $\varepsilon$ cancels and never has to be $\pm1$.
This removes $\varepsilon\ne1$ as an apparent obstruction. The honest interface is the
`logDeriv` one; and $h(1-s)=-h(s)$ *does* give the reflection even though it cannot be
repaired to $h(1-s)=h(s)$ by rescaling, since $\operatorname{logDeriv}(c\cdot h)=
\operatorname{logDeriv}h$. Module: `lean/DirichletRouteB.lean`;
`routeB_general_of_logDeriv`, `routeB_of_selfDualRealUpToSign`.

**Result 3.14 (conjugation reality; O1.T4, `done` — "the substantive Mathlib gap").**
`DirichletCharacter.completedLFunction_conj` (`lean/DirichletConj.lean`; `notes/generality-lean.md` §7):
$$\forall n,\ \overline{\chi(n)}=\chi(n)\ \Longrightarrow\
\Lambda_\chi(\overline s)=\overline{\Lambda_\chi(s)}\quad\text{for all } s .$$
Proved "for every character with real values — nontrivial or trivial, primitive or not, any
modulus. No primitivity, parity or extra hypothesis on $N$ is needed." The trivial-character
case $N=1$ *is* the completed Riemann zeta function, so the same theorem yields
`completedRiemannZeta_conj`, "also a genuine Mathlib gap". The route is worth recording
(`html/dirichlet-011.html` §7.3): series conjugation $LSeries\_conj$; the half-plane identity
on $1<\operatorname{Re}s$ via `LFunction_eq_LSeries` and `gammaFactor_conj`; then the identity
theorem applied not to $\Lambda_\chi$ (which has a pole at $s=1$ for the trivial character)
but to the entire normalisation `ZMod.completedLFunction₀ χ`, with
$\Lambda_0=\Lambda+N^{-z}\chi(0)/z+N^{-z}(\sum\chi)/(1-z)$, the two correction terms commuting
with conjugation because $N$ is nonnegative real (`conj_cpow_ofReal`) and $\chi$ is real.
"No case is left open."

**Result 3.15 (root-number sign, and the correction the statement needed; `notes/generality-lean.md` §8).**
`rootNumber χ = 1 ∨ rootNumber χ = -1` is now proved for nontrivial quadratic *primitive*
$\chi$ (`lean/RootNumber.lean`, `rootNumber_eq_one_or_neg_one`,
`rootNumberSign_of_isQuadratic`, `rootNumberSign_of_conj_eq_self`). Two corrections are
recorded and both are kept visible:

1. **The statement needs `IsPrimitive`, and without it it is false.** The `changeLevel` image
   of the quadratic character mod 3 at modulus 6 takes the values $(0,1,0,0,0,-1)$; it is odd,
   its Gauss sum is $\omega-\omega^5=i\sqrt3$ ($\omega=e^{2\pi i/6}$), hence
   $\text{rootNumber}=i\sqrt3/(i\sqrt6)=1/\sqrt2\ne\pm1$ (verified numerically). "Every
   application already assumes primitivity, so nothing is lost — but the hypothesis is
   genuinely necessary, not bookkeeping" (`html/dirichlet-011.html` §7.3).
2. **The natural impulse — prove the sign from `gaussSum_sq` — does not work as stated**,
   because Mathlib's `MulChar.gaussSum_sq` sits in a `[Field R]` section and so covers prime
   moduli only. The proof instead applies the primitive functional equation twice and
   evaluates at $s=1$: $\Lambda_\chi(s)=\varepsilon^2\Lambda_\chi(s)$, and $\Lambda_\chi(1)\ne0$
   from `LFunction_apply_one_ne_zero` and `gammaFactor χ 1 ≠ 0`; then `sq_eq_one_iff`.

**Result 3.16 (the composite-modulus Gauss-sum square — a new Mathlib lemma;
`notes/generality-lean.md` §9).** `RouteABC.gaussSum_sq_of_isPrimitive`
(`lean/GaussSumComposite.lean`):
$$\texttt{gaussSum}\ \chi\ \texttt{stdAddChar}^2=\chi(-1)\cdot N .$$
"It comes from the product form
$\texttt{gaussSum}\,\chi\,\texttt{stdAddChar}\cdot\texttt{gaussSum}\,\chi^{-1}\,\texttt{stdAddChar}
=\chi(-1)\cdot N$, proved without ever dividing in `ZMod N` — by comparing the two evaluations
of $\mathcal F(\mathcal F\chi)$ at $k=1$." The file also specialises back to Mathlib's field
case at prime $N$ ($N=3,5,7$) as a consistency check, and gives a **second, independent proof**
of the root-number sign (`rootNumber_eq_one_or_neg_one'`) along the route that was originally
blocked. Verified numerically for primitive quadratic characters at $N=8,12,20,24$ and shown
to fail at $N=6$ without primitivity (`python/check_gausssum_sq.py`).

**Result 3.17 (the analytic hypotheses are discharged; `notes/generality-lean.md` §10).**
`lean/DirichletAnalytic.lean` proves all three analytic hypotheses
(`han`, `hint₀`, `hint₁`) of `routeB_for_dirichletL_unconditional` — unconditionally in the
character, for every $\chi\ne1$; no primitivity, reality or quadraticity is used — and
repackages Route B as `routeB_for_dirichletL_of_zeros`, whose **only** hypotheses are the
numerical zero data $(Z,m,\texttt{hno})$. The edge non-vanishing that $hint_0,hint_1$ consume
is itself derived from `hmem`+`hno`.

**Result 3.18 (Route B for Dirichlet L, all hypotheses discharged).**
`routeB_for_dirichletL_unconditional` (`lean/DirichletRouteB.lean`), with both former `Prop`
hypotheses now theorems: `hε : RootNumberSign χ` from
`rootNumberSign_of_isQuadratic`, and `hreal : CompletedLFunctionConj χ` from
`DirichletCharacter.completedLFunction_conj` applied to
`conj_eq_self_of_isQuadratic`. Conclusion:
$$\operatorname{Im}\bigl(\text{rightPath}(\operatorname{logDeriv}(\texttt{dirichletCompleted}\ \chi))\ t_0\ t_1\bigr)
=\pi\sum_{z\in Z}m(z).$$

#### 3.2.3 The certified Dirichlet window for $\chi_3$

**Result 3.19 (CERTIFIED).** For the real primitive character $\chi_3$ mod 3
(`python/certify_dirichlet_routeB.py`, log `logs/certify_dirichlet_routeB_chi3.log`,
sidecar `data/certify_dirichlet_routeB_chi_3_T10.json`):

* the count by **argument tracking**: since $\operatorname{Im}(I_3)=\Delta\arg H$ along the path,
  $N_\chi(T)=\operatorname{Im}(I_3)/\pi$; tracked sample by sample with adaptive refinement and
  **no curvature bound**, deliberately, because "the box enclosure of $L$ from the interval
  engine is sound but loose near $\operatorname{Re}s=1/2$ (Euler–Maclaurin cancellation), so a
  midpoint-rule budget is unusable";
  $$N_{\chi_3}(10)\in[0.9999999979,\ 1.000000002]\ \Longrightarrow\ N=1;$$
* the **on-line zeros**: on the critical line $H$ is real (root number $+1$), so
  $\Xi(t)=\operatorname{Re}H(1/2+it)$ is real-analytic and its zeros are the on-line zeros;
  certified sign changes of $\Xi$, each endpoint enclosure excluding $0$, bracket exactly one
  zero at $\operatorname{Im}s=8.039737156\ldots$ in a bracket of width $1.1\cdot10^{-10}$. The
  sidecar records the bracket as the rationals
  $[1381216326077/171798691840,\ 86326020381/10737418240]$, with `order: 1`, `turing_ok: true`;
* since the number of certified on-line zeros equals the total multiplicity $N_{\chi_3}(10)$,
  **every zero of $L(\chi_3,\cdot)$ with $1/2<\operatorname{Im}s<10$ is simple and on the
  critical line**, and the finite data $(Z, m\equiv1, \texttt{hno})$ is certified for that
  window.

The archived log times the two phases at 454 s and 298 s (total 752 s) and exits 0. The
independent verifier `python/check_dirichlet_routeB.py` passes all four checks
(`logs/check_dirichlet_routeB.log`): gamma containment (5 points, 0 missed), $H/\Xi$
containment for $\chi_3,\chi_4,\chi_5,\chi_8$ (0 missed), the arg-tracking enclosure
$[0.999999999114,1.00000000089]$ containing the direct quadrature value $1.0$, and each
bracket containing an mpmath reference zero.

**The Lean statement's residual obligation.** The Lean statement still takes $Z,m,\texttt{hno}$
as hypotheses; the numerical certificate is **not** formalised. The obligation is named as the
structure `CertifiedWindow` (`lean/CertifiedWindow.lean`), with `routeB_for_chi3_of_window`
for the concrete window $(1/2,10)$; "producing a `CertifiedWindow` would require a verified
numerical evaluator for `dirichletCompleted chi3` and a formalised argument-principle count,
neither of which is in Mathlib" (`html/dirichlet-011.html` §7.3).

#### 3.2.4 The explicit formula for Dirichlet $L$ (Route C)

**Result 3.20 (CERTIFIED — validated assembly).** `python/dirichlet_explicit.py`
(logs `logs/dirichlet_explicit_chi3.log`, `logs/dirichlet_explicit_chi5.log`):

| character | $\theta$ | $N_{\text{prime}}$ | residual | error budget (arch, prime, zero-tail) | verdict |
|---|---|---|---|---|---|
| $\chi$ mod 3 | 8 | 4000 | $-4.2945568\cdot10^{-10}$ | $2.016\cdot10^{-7}$ (3.1e−8, 2.0e−9, 1.6e−7) | VALIDATED |
| $\chi$ mod 5 | 7 | 4000 | $2.1798798\cdot10^{-8}$ | $1.331\cdot10^{-6}$ (1.3e−6, 1.8e−9, 6.6e−10) | VALIDATED |

Both runs print `VALIDATED: |residual| <= budget` and exit 0 (508 s and 779 s).
The Lean algebraic layer is `lean/DirichletExplicit.lean` (`dirichletWeight` $=\Lambda(n)\chi(n)$,
the Euler-product coefficient; its prime-power values; the prime-side split; `dirichletPsi`;
`DirichletExplicitData.validated`), with `DirichletExplicitWiring.lean`,
`DirichletExplicitWiring2.lean`, `DirichletPrimeTail.lean`, `DirichletArchimedean.lean` and
`DirichletGammaLogDeriv.lean` supplying the wiring.

#### 3.2.5 The conditional interface and the conditional count

**Result 3.21 (PROVED (Lean)).** With $h_L$ discharged by journal 300 and $h_H$ reduced to
its integrable case by journal 302 (`lean/DirichletStripBound.lean:1429`,
`:1474`), §226's reduction turns the interface into a theorem from exactly two named
hypotheses (`lean/DirichletStripBound.lean:1501`):

```lean
theorem criticalStripLogDerivBound_of_L_and_hH
    (χ : DirichletCharacter ℂ N) (hχ : χ ≠ 1) {CL : ℝ}
    (hL : ∀ y : ℝ, ‖logDeriv (LFunction χ) (1 + y * Complex.I)‖
      ≤ CL * (1 + Real.log (|y| + 2)))
    {CH : ℝ} (hCH : 0 < CH)
    (hH : ∀ t T : ℝ, |t| ≤ T → 0 ≤ T →
      Integrable (fun x : ℝ => ‖completedLogDeriv χ (x + t * Complex.I)‖)
        (volume.restrict (Set.Ioc (1 / 2 : ℝ) 1)) →
      (∫ x in (1 / 2 : ℝ)..1, ‖completedLogDeriv χ (x + t * Complex.I)‖)
        ≤ CH * (1 + Real.log ((N : ℝ) * (T + 2)))) :
    CriticalStripLogDerivBound χ
```

**Result 3.22 (PROVED (Lean) — the Riemann–von Mangoldt count bound, conditional on
$(h_L,h_H)$).** `dirichletCompleted_zeroCount_le_of_L_and_hH`
(`lean/DirichletStripBound.lean:1520`) applies the programme's own consumer
`dirichletCompleted_zeroCount_le_of_criticalStrip` to Result 3.21:
$$\exists C_0>0:\quad \sum_{z\in Z}m(z)\ \le\
C_0\,\bigl(1+\log(N(T+2))\bigr)\bigl(1+|t_1-t_0|\bigr)/\pi .$$
Round 40 of the log records this landing, with the two costs: copying the 20-argument
signature, and discovering that the `[[a,b]]` interval notation needs
`open scoped Interval`. The registry also records at that round
"`research/check_footprints.py /tmp/all82.log -> 320 footprints, all clean`" and
"`cd 011/lean && ./check.sh --all -> 29 OK`" (`objectives.json`, `round_log`, round 40,
second entry).

**The correction this required, kept visible.** The task's original framing ("from the single
$L'/L$ hypothesis") "was optimistic: `hH` turned out to be a genuine second input, and the
assembly shows so explicitly" (`objectives.json`, `O1.T5`/`O1.T10` `outcome`).

#### 3.2.6 Why three tasks are blocked, and how the premise of one was retracted

**O1.T5, O1.T9, O1.T11 share the same blocker in substance**: their remainder is the two
classical inputs $h_L,h_H$, "both PNT-strength" (`objectives.json`, `blocked_reason` of each;
`html/objectives.html` §2.1).

* **O1.T9** (restate the interface so its contour avoids zeros) was opened *to repair a
  supposed defect in the target*, and **the defect was the author's, not the interface's — a
  retraction, journal 272** (`objectives.json`, `O1.T9.value`). What survives from the task is
  all landed: the perturbation machinery, the corrected reading, the edge
  factorisation/decomposition/assembly, and the discharge of the archimedean term. The chosen
  restatement is **option (ii) with zero-avoidance taken as a conjunct, resolved by limit
  passage**, justified by two measured facts
  (`python/contour_repair_probe.py`, exit 0): (A) the ordinates are discrete — every gap among
  the first 30 zeta zeros is positive, minimum $1.21929$; (B) at distance $d$ from a zero the
  edge integral grows like $\log(1/d)$ — $0.482,\ 2.171,\ 4.418,\ 6.714$ at
  $d=1,\ 0.1,\ 0.01,\ 0.001$ — while at generic heights it is uniformly $O(1)$
  ($0.231$–$0.323$ at midpoints), "so the repair costs nothing when the edges sit at a fixed
  distance from zeros." This adds a hypothesis and leaves the **conclusion** (hence the count
  implication) unchanged — not a weakening. The two landed halves are
  `zeroCount_mono` and the pair `exists_zero_free_height_of_finite` /
  `isDiscrete_zeroSet_of_analyticOnNhd` / `finite_zeros_in_reProdIm` /
  `exists_zero_free_height_of_analytic` (`lean/DirichletZeroCounting.lean`).
* **O1.T5** and **O1.T11** are blocked on the same two inputs. O1.T11's `blocked_reason`
  records the measurement behind the verdict: the bound "is TRUE and measured well-behaved
  (journal 314: on the accessible window $t\le55$ the relevant integral sits at $0.35$–$0.54$
  and is FLAT with its ratio to $\log t$ falling), but every route to PROVING it needs the same
  classical input as $h_L$." The total-variation split reduces the integral to
  $\mathrm{Var}(\log|\Lambda|)+\mathrm{Var}(\arg\Lambda)$, and neither term is controlled by
  the strip bounds alone — "variation is not bounded by range ($\sin(1000x)$ has range 2 and
  variation 2000), and Mathlib lacks the hard direction of $\int|h'|=\mathrm{Var}(h)$ (journal
  312)." The classical proof goes through the Dirichlet series for $\Lambda'/\Lambda$ on the
  line, i.e. the same $\sum\Lambda(n)\chi(n)=o(N)$ input as $h_L$. Hence: "discharging the
  interface IS the Riemann–von Mangoldt theorem."

**The strip-edge premise that re-scoped O1.T9 (measured, then retracted).**
`python/strip_edge_divergence_probe.py` (exit 0) showed that the horizontal-edge integral
$\int_{1/2}^{1}\|\operatorname{logDeriv}(x+it_0)\|\,dx$ diverges whenever $t_0$ is the ordinate
of a zero of the completed $L$-function with $\operatorname{Re}\in[1/2,1]$: at the critical-line
zero $\gamma_1$ it grows exactly like $\log(1/2\varepsilon)$ (measured offset $-0.19497$,
stable to 5 digits from $\varepsilon=10^{-4}$ to $10^{-8}$), while at a generic height it
converges to $0.4823$. Since the interface quantifies over all $t_0<t_1$,
the interface would be either vacuous there (Mathlib convention: the integral of a
non-integrable function is 0) or false there (improper-integral reading). The conclusion drawn
at the time — that the objective "discharge `CriticalStripLogDerivBound`" was ill-posed — was
then **retracted (journal 272)**, and what survives is the machinery above
(`objectives.json`, `O1.T8.decision`, `O1.T9.value`).

#### 3.2.7 The sharp archimedean rate: mathematics complete and verified, Lean open

**Result 3.23 (registry status: OPEN; content: mathematics complete and verified).** The
registry marks `O1.T6` and `O1.T12` **`open`**, and simultaneously records in O1.T12's approach
`[ROUND 263 UPDATE — MATHEMATICS COMPLETE AND VERIFIED]` (and the same wording in `README.md`
and `research-journal.md`). Both facts are reported here, because this is exactly the kind of
distinction the registry exists to preserve: the registry's completion rule "requires both
Python and Lean for a task to be `done`", and the Lean step is not done
(`html/objectives.html` §9).

The verified content:

* The target $\|\Gamma(\sigma+it)\|\le2\sqrt{2\pi}\,|t|^{\sigma-1/2}e^{-(\pi/2)|t|}$ for
  $|t|\ge2$, $\sigma\in[0.25,2]$ **holds** on the tested range: running
  `python/t12_sharp_rate_probe.py` (mpmath, dps = 40, deterministic) gives
  $$\sup_{\sigma\in[0.25,2],\ |t|\in[2,400]}
  \frac{\|\Gamma(\sigma+it)\|}{2\sqrt{2\pi}|t|^{\sigma-1/2}e^{-(\pi/2)|t|}}=0.5590179691,$$
  attained at $\sigma=2.0$, $t=2$, with `TARGET HOLDS <=> sup ratio <= 1 -> TRUE`, exit 0.
  (The run was reproduced for this manuscript; see §4.)
* The sharp asymptotic
  $\log\|\Gamma(\sigma+it)\|=(\sigma-\tfrac12)\log|t|-\tfrac{\pi}{2}|t|+\tfrac12\log(2\pi)+O(1/|t|)$
  is **confirmed**: the probe's section B prints differences $|{\rm diff}|\le0.00125$ at
  $\sigma=2,t=20$, $5.0\cdot10^{-5}$ at $t=100$, $3.1\cdot10^{-6}$ at $t=400$, and $0$ to
  displayed precision at $\sigma=0.5$ and $\sigma=1$.
* The **missing ingredient is identified exactly**: the crude integral lower bound leaves a
  $+\tfrac12\log n$ residual (the probe's section C: `crude-target` grows
  $+1.6465\to+4.6046$ for $n=10^2\to10^5$ at $\sigma=0.5$, $t=10$), and the Euler–Maclaurin
  endpoint term $\tfrac12(f(0)+f(n))$ — equivalently the trapezoidal/Hermite–Hadamard lower
  bound on the convex range $n\le|t|-\sigma$ — cancels it (the corrected exponent converges to
  $-2.3038$ against $\log\|\Gamma\|$). Mathlib has **no** Euler–Maclaurin and **no**
  trapezoidal lemma ("only first-order `SumIntegralComparisons` and Jensen")
  (`html/objectives.html` §3).

**Two routes were rigorously closed** (`objectives.json`, `O1.T6.sub_routes`;
`html/objectives.html` §3, "Two routes refuted"):

* **GammaSeq** — "refuted (uniform-in-$n$ bound capped at rate 1)". Because
  `norm_GammaSeq_le_eventually` is uniform in $n\ge\lceil|t|\rceil$, **any** such bound is
  capped at rate 1, while the true rate is $\pi/2\approx1.5708$; the discarded product mass
  $\sum_j\log\sqrt{(\sigma+j)^2+t^2}-(n+1)\log|t|$ is only $\approx0.132\,|t|$, so the diagonal
  rate of GammaSeq is $1.132$ — still short (`objectives.json`, `O1.T6.approach`).
* **reflection** — "reduces to GammaSeq target": $\Gamma(s)\Gamma(1-s)=\pi/\sin(\pi s)$ is
  exact, and while $1/|\sin|$ supplies rate $\pi$ (stronger than $\pi/2$, so the exponential
  rate is not the obstruction), the identity needs a **lower** bound on
  $|\Gamma(1-\sigma-it)|$, and that factor itself carries exactly the Stirling decay
  $e^{-\pi|t|/2}$ — "so reflection relocates Stirling rather than avoiding it."

**The hazard relaxation is recorded durably**
(`objectives.json`, `round_log` rounds 53 and 253; `html/objectives.html` §3): complex Stirling
is **authorised**, but journal 515 established by direct inventory that **Mathlib contains no
complex Stirling lemmas at all** — "so the relaxation permits me TO BUILD such lemmas, it does
not unlock an existing theorem."

**What is landed in Lean toward the rate** (`lean/GammaBounds.lean`, 140 declarations):

| declaration | line | content |
|---|---|---|
| `norm_GammaSeq_eq` | 1074 | exact norm identity for `Complex.GammaSeq` |
| `norm_GammaSeq_le_eventually` | 1229 | the committed uniform-in-$n$ bound (rate $\to1$) |
| `norm_Gamma_le_decay_half` / `_quarter` / `_upper` | 1394 / 1472 / 1531 | decay bounds on $[1/2,1]$, $[1/4,1]$, $[3/2,2]$ |
| `log_factorial_le_stirling` | 2596 | $\log n!\le n\log n-n+\tfrac12\log(2\pi n)+\tfrac1{12n}$ |
| `log_norm_GammaSeq` | 2649 | the logarithm identity |
| `log_norm_GammaSeq_le` | 2682 | the size bound |
| `norm_Gamma_le_of_GammaSeq_bound` | 930 | the final-assembly bridge |
| `tendsto_log_norm_GammaSeq` | 2941 | the convergence, landed first attempt |
| `log_norm_GammaSeq_le_sum` | 2952 | the first brick of the final $|t|$-bound |

The remaining Lean step is precisely: "the EM endpoint bound (trapezoidal lower bound on the
convex range $n\le|t|-\sigma$ plus a bounded-remainder handle on the concave tail), then the
final `calc` assembly via `Real.exp_le_exp` + `norm_Gamma_le_of_GammaSeq_bound`"
(`objectives.json`, `O1.T12.approach`).

**Measured verdicts and corrections on this route, kept visible.**

* The **Stirling-in-$n$ route was refuted by two independent computations** (journals 487, 489,
  reported at `html/objectives.html` §3): $E-B$ is positive at $t=4$, $n=100000$, and $E$ grows
  like $\sigma\log n$, so no $n$-free bound exists. Journal 222 is the decisive round: "$E(n)$
  is not bounded above in $n$, so the Stirling-on-$n!$ route cannot reach the rate."
* The **first-order product-sum bracket is correct but $t$-free and therefore cannot carry the
  rate** (journal 513). The re-aimed sharp two-sided bracket
  $\sum\log(\sigma+j)\le\sum\log\|s+j\|\le\sum\log(\sigma+j+|t|)$ landed in five bricks
  (journals 498, 506, 507, 511, 512).
* **A wrong formulation was corrected, not hidden**: journal 516 established that the correct
  statement of the convergence needs **no** $\sigma\log n$ subtraction (GammaSeq tends to
  $\Gamma$ directly); journal 518 then landed `tendsto_log_norm_GammaSeq` first attempt.
* **Two different comparisons involving the factor 2 and $\sqrt{2\pi}$ coexist in the
  sources.** Round 252 measured the ratio against $\sqrt{2\pi}\,|t|^{\sigma-1/2}e^{-(\pi/2)|t|}$
  and reported $1.0000195$ or less for $\sigma\le1$, $1.0308$ at $\sigma=1.5,t_0=2$, and
  $1.1180$ at $\sigma=2,t_0=2$; round 263 and `notes/sharp-gamma-rate.md` measure against the
  model with $2\sqrt{2\pi}$ included and report $0.559$ ($\approx1.118/2$). The two statements
  are consistent under the factor-of-two convention difference, but the sources do not say so
  explicitly; this is listed under §5 and in `uncertainties`.

#### 3.2.8 The $\zeta$ windows: a soundness erratum and its resolution

This is part of the O1 record because the same engine serves all three routes.

**Result 3.24 (CERTIFIED — but only with the corrected primitives, and the correction is
recorded).** Two soundness bugs were found in the 010 interval primitives while building the
independent Dirichlet engine (`notes/010-EXP_NUM_ERRATUM.md`, "Severity: soundness of every
positive-width box enclosure in the Route-B engine"):

1. **`exp_num` inverted its interval for $y_{\rm hi}\le0$** — for $y_{\rm lo}\le y_{\rm hi}\le0$
   we have $e^{y_{\rm lo}}\le e^{y_{\rm hi}}$, so the endpoint names were swapped, $\text{lo}>\text{hi}$,
   and the radius came out negative — which `ivmath.Num.__init__` **silently clamped to 0**,
   "turning the inconsistency into a plausible-looking zero-width point at the midpoint".
   Example: $y=[-0.55,-0.45]$ has true $e^y$ range $[0.57694981038,0.63762815162]$; before, the
   engine returned $0.6072889810006344\pm0$, which "contains NEITHER endpoint".
2. **`ndef` used the nonnegative-numerator division formula**, `lo = x.lo/y.hi`,
   `hi = x.hi/y.lo`, correct only when $x\ge0$. Because `cdiv` feeds it a **signed** numerator
   ($a_{\rm re}b_{\rm re}+a_{\rm im}b_{\rm im}$), every complex division in the engine was
   exposed. Random test: **1584/3000 containment failures before, 0/3000 after**
   ($x=[-1.8370969,-1.6862478]$, $y=[3.6373329,3.7097691]$: true $x/y$ range
   $[-0.50506704,-0.45454251]$; before, $[-0.49520519,-0.46359457]$, "misses both ends by
   $\sim0.01$ (2 % of the value)").

**Blast radius** (`notes/010-EXP_NUM_ERRATUM.md`): Route A **not** affected ($\sigma=1/2$
exactly, point evaluations); Route C **not** affected; **Route B counts affected**, because
their curvature bound `Lf` came from a box enclosure. "So `Lf` was an upper bound on $|f'|$ at
the cell midpoint, not on the cell, and the quadrature budget $\sum\tfrac18|ds|^2Lf$ was
correspondingly too small." Honest verdict as recorded: the two archived runs had headroom
($T=15$: half-width $0.2018$ against the $0.5$ requirement, $\times2.5$; $T=33$: $0.289$,
$\times1.73$), "so the conclusions *may* well survive. But this is now an **estimate, not a
proof**, and the shortfall is not bounded by the previous estimate: as archived, **the two
Route-B counts are not rigorous** and must be re-run."

**The re-run, and then the removal of the curvature bound** — this is the resolution, and it is
a stronger statement than a re-run:

| run | archived (buggy primitives) | re-run (fixed primitives) | verdict |
|---|---|---|---|
| $T=15$, steps/unit 24, $K=40$ | $N\in[0.7981608,1.2018097]$, hw $0.2018$ | $N\in[0.56932353,1.4325407]$, hw $0.4316$ | $N(15)=1$ certified at the $1/8$ convention |
| $T=33$, steps/unit 40, $K=100$ | $N\in[4.711,5.2890345]$, hw $0.289$ | $N\in[3.3040886,6.695946]$, hw $1.696$ | **UNDECIDED** — the archived $N(33)=5$ does not survive |

Because since $I_3=\int\operatorname{logDeriv}\xi\,ds=\Delta\log\xi$, its imaginary part is the
continuous change of $\arg\xi$ along the path, `python/zeta_routeB.py` tracks $\arg\xi$ from a
rigorous value enclosure of $\xi(s)=\tfrac12s(s-1)\pi^{-s/2}\Gamma(s/2)\zeta(s)$ and never
evaluates `Lf`, so it is immune to both the erratum and the midpoint constant. Logs
`logs/zeta_routeB_arg_T15.log` and `logs/zeta_routeB_arg_T33.log`:
$$N(15)\in[0.999999909,1.000000091]\ \Rightarrow\ N=1,\qquad
N(33)\in[4.999999675,5.000000325]\ \Rightarrow\ N=5 .$$
Each is a few minutes' work. So the two $\zeta$ windows are **restored, and now with a much
tighter and proof-clean method**; the archived quadrature runs remain as the concrete
demonstration of the erratum's blast radius (`notes/010-EXP_NUM_ERRATUM.md`).

**Result 3.25 (the midpoint constant: an unproved constant, doubled; also kept visible).** The
quadrature budget was written $|{\rm err}|\le\tfrac18|ds|^2\sup|f'|$. The elementary bound for
the midpoint rule is $|{\rm err}|\le\tfrac14|ds|^2\sup|f'|$ (the triangular kernel $h/2-|x|$
has $L^1$ mass $h^2/4$), and it is sharp even for holomorphic $f$ — the extremal profile is
uniformly approximable on a segment by entire functions (Mergelyan). "Hence the general lemma
'$|{\rm err}|\le(1/8)|ds|^2\sup|f'|$' is **false**; the code's $1/8$ is half the elementary
constant" (`notes/midpoint-constant.md`). Why the archived numbers are nevertheless very
likely safe: the budget uses `Lf`, the engine's **box** enclosure, which overestimates
$\sup|f'|$ by roughly $10^6$–$10^7$ on ordinary steps, "so the factor of two is absorbed *in
practice*, but it is not absorbed by any proof." The fix was applied: the two
`(mp.mpf(1)/8)` occurrences in `eta_interval.I3_certificate` and `certify_count_par._one`
were changed to `(mp.mpf(1)/4)`, and the quadrature route is **retired as the primary Route-B
count** in favour of argument tracking. The note states the correct statement to quote if the
$1/8$ runs are ever cited again: either re-derive with $1/4$ (doubling the quadrature part), or
prove `Lf >= 2 sup|f'|` for the box enclosure, "which is not done anywhere."

### 3.3 O2 — the decomposition-lab verdict: the harmonic tier cannot see zeros

O2 has 7 tasks: **4 `done`, 3 `refuted`** (`objectives.json`; `html/objectives.html` §2.2). It
is the folder's negative result, recorded "so it is not re-attempted as if open"
(`objectives.json`, `O2.reason_to_exist`; `README.md`).

**Setting.** `html/decomposition_lab.html` §2–§3 proposes a greedy Egyptian decomposition of
integers and rationals — each integer $n$ written as $n(1/2+1/4+1/8+\cdots)$, or built from
distinct unit fractions by the greedy rule, then "promoted" upward so that $k$ copies of
$1/d$ are swapped for the equal number of copies of the highest unit fraction $1/e$ they make
exactly ($10\times1/8\to5\times1/4\to2\times1/2+1/4$), "repeated until nothing moves, so the
total gravitates to $1/2$" — and asks whether this decomposes the *terms* of
$\zeta(s)=\sum n^{-s}$ into a second-tier harmonic series.

**Result 3.26 (what §2–§3 actually prove; O2.T3/T5, `done`; status **PROVED**).** The pooling
operation is a representation-theoretic identity with exactly one invariant
(`notes/decomposition-lab-notes.md` §1):
$$\sum_ix_i=\sum_d\frac{c_d}{d},$$
and promotion is a rewriting system using $k(1/d)=j(1/e)$ whenever $ke=jd$, which preserves
the value and nothing else. Consequently: "on a **single** greedy expansion the denominators
are distinct, so promotion does **nothing** (probe P3: `moves = 0` for $n=1,2,3,4$); once
several numbers are **pooled**, promotion moves copies around (probe P3: $A=\{1,\dots,5\}$,
$15=15$ after 21 moves, $104\to91$ groups) — and in doing so it **destroys the attribution** of
which $x_i$ contributed which unit fraction." So "the 'second tier' is a nonnegative integer
multiplicity vector whose only invariant is the total sum. That is the whole content of
§2–§3, and it is why the operation is 'magnitude-level'."

**Result 3.27 (R1, decompose the index: REFUTED; O2.T1, `refuted`).** The identity
$$\zeta(s)=\sum_{n\ge1}\Bigl(\sum_{d\in D(n)}\frac1d\Bigr)^{-s}$$
is **exact and useless** (`notes/decomposition-lab-notes.md` §2). Probe P1:

| $n$ | terms of $D(n)$ | $\lceil e^{n-\gamma}\rceil\approx k(n)$ | largest denominator |
|---|---|---|---|
| 1 | 1 | 1 | 1 digit |
| 2 | 4 | 3 | 1 digit |
| 3 | 13 | 10 | 5 digits |
| 4 | 35 | 30 | 44 digits |
| 5 | 99 | 82 | 142,548 digits |
| 6 | ≥ 226 | 226 | ≥ 308,599 digits |

where $k(n)=\max\{k:H_k\le n\}$, $H_k=\sum_{i\le k}1/i$; the greedy expansion of $n$ contains
the whole initial block $1,2,\dots,k(n)$ and then a Sylvester-type tail with
$d_{m+1}\ge d_m^2-d_m+1$, i.e. $\log d_m$ doubles. Hence $|D(n)|\ge e^{n-\gamma}$, and a single
term of $D(6)$ already needs a 300,000-digit denominator. Pooling indices $n\le N$ gives
$Z_N(s)=\sum_dc_dd^{-s}$, which by construction has $Z_N(1)=N(N+1)/2$, is supported on
$\sim e^N$ distinct denominators, and bears no relation to $\zeta$: probe P4 gives
$Z_4(1/2+i\gamma_1)=1.322363-0.300877i$ while $\zeta(1/2+i\gamma_1)=0$. The structural reason
(probe P2) is that the membership indicator $a_d(n)=\mathbf 1[d\in D(n)]$ is a **threshold** in
$n$ — $d\in D(n)$ once $d\le k(n)$, i.e. eventually constant 1 — so it is *not* $q$-periodic
for any $q>1$ and admits no finite Fourier/character expansion. "Periodicity in $n$ is exactly
the hypothesis that makes 007 work; without it there is no collapse."

**Result 3.28 (R2, decompose the magnitude: REFUTED as a route; O2.T2, `refuted`;
status HEURISTIC/structural).** For $s=\sigma+it$,
$n^{-s}=n^{-\sigma}e^{-it\log n}$: the decomposition of the magnitude is independent of the
phase. Regrouping by denominator $d$ gives
$$\zeta(\sigma+it)=\sum_d\frac1d\sum_{n:\,d\in E(n,\sigma)}e^{-it\log n},$$
and for each fixed $d$ the set $\{n:d\in E(n,\sigma)\}$ is a union of intervals in $n$, so each
inner sum is a difference of truncated Dirichlet series over intervals, "i.e. exactly what Abel
summation / Euler–Maclaurin already gives. The rearrangement buys no cancellation beyond the
classical tail estimate." *Status:* the identities are exact; the "no new cancellation" claim
is the standard partial-summation observation (`notes/decomposition-lab-notes.md` §3).

**Result 3.29 (R3, the periodic partition — the only reading that simplifies; O2.T3, `done`;
status **PROVED** (classical) + **VERIFIED** $9.9\cdot10^{-32}$).** If $c:\mathbb N\to\mathbb C$
is $q$-periodic,
$$\sum_{n\ge1}c(n)n^{-s}=\sum_{r=1}^qc(r)\sum_{m\ge0}(mq+r)^{-s}
=q^{-s}\sum_{r=1}^qc(r)\zeta(s,r/q),$$
a **finite** combination of Hurwitz zetas; for a Dirichlet character $\chi$ mod $q$ the left
side is $L(s,\chi)$, and for the principal character it is $\prod_{p\mid q}(1-p^{-s})\zeta(s)$.
Verified independently by grouped summation at 30 dps:
$L(2,\chi_3)=3^{-2}(\zeta(2,1/3)-\zeta(2,2/3))=0.781302412896486296867\ldots$, agreement
$9.9e-32$. "This is the precise sense in which a partition of $\zeta$'s terms into classes
'simplifies' the series: the classes must be a **finite periodic partition**." A partition by
Egyptian decomposition is a threshold (R1), not periodic, so (HURWITZ) has no analogue. And
007 is the boundary shadow of (HURWITZ): for the tail with $x=e^{-p/n}$,
$F_r(x)=\sum_{j\ge1}c(r+j)x^j=f_r(x)/(1-x^q)$,
$f_r(x)=\sum_{s=1}^{q}c(r+s)x^s$; the second-order expansion survives in full shape,
$p(n)=an+g+c/n+O(1/n^2)$, with character-twisted moments, but the leading threshold equation
$F_r(x)=1$ exists or not depending on $(\chi,r)$ — it fails (**proved**,
`Op57.chi3_F_lt_one`, `Op57.chi4_F_lt_one`) for $\chi_3,\chi_4$, and holds for $29.7\,\%$ of
the 4537 pairs with real $\chi$, $q\le60$. Crucially, "$F_r=1$ is a **boundary/threshold
equation**, *not* a zero of the underlying $L$-function; the handoff is explicit that 007
'bears on no RH'."

**Result 3.30 (R4, the tier that carries zero information; O2.T4, `refuted`).** The harmonic
tier that actually governs zeros is the **multiplicative (prime-power)** tier:
$$\log\zeta(s)=\sum_p\sum_{k\ge1}\frac1kp^{-ks},\qquad
-\frac{\zeta'}{\zeta}(s)=\sum_{n\ge2}\Lambda(n)n^{-s},\qquad
\frac1{\zeta(s)}=\sum\mu(n)n^{-s}.$$
Probe P5 verifies it against $\log\zeta(s)$ at $s=2,\,1.5,\,1+0.5i$ with residuals
$3.8\cdot10^{-7}$, $3.2\cdot10^{-4}$, $1.6\cdot10^{-1}$ (the last truncation-limited at
$N=2\cdot10^5$). "This is the tier whose coefficients $\Lambda(n),\mu(n)$ are multiplicative."
A unit-fraction decomposition of the integer $n$ is neither multiplicative nor additive in
$\log n$ (`notes/decomposition-lab-notes.md` §5).

**Result 3.31 (R5, positive/negative partitions made precise; O2.T5, `done`; PROVED +
NUMERICAL).** Splitting $n^{-s}=n^{-\sigma}\cos(t\log n)-in^{-\sigma}\sin(t\log n)$ and putting
$$R_\pm(t)=\sum_{n:\,\pm\cos(t\log n)>0}n^{-\sigma}|\cos(t\log n)|,\qquad
I_\pm(t)=\sum_{n:\,\pm\sin(t\log n)>0}n^{-\sigma}|\sin(t\log n)|,$$
gives $\operatorname{Re}\zeta(s)=R_+-R_-$, $\operatorname{Im}\zeta(s)=I_+-I_-$, and on the
critical line a zero needs **both** balances. *Re:* this is exactly rh43 —
$P_N=|M_N|\iff\operatorname{Re}S_N(t)=0$, **PROVED** by
`balanced_iff_realPartial_eq_zero` (`lean/Rh43/Balance.lean:187`) — but the *term-level*
partition fails: at $N=6$ the exact subset-sum defect is $0.169963\ldots$ (NUMERICAL), because
$\cos(t\log1)=1$ alone exceeds $P/2$ whenever $P<2$. *Im:* positive/negative $\operatorname{Im}$
is the sign of $\sum_{n\le N}\sin(t\log n)$, on the critical line (up to the theta phase) the
sign of $Z(t)$, the classical zero locator; the essential ingredient is the **completion**
$Z(t)=e^{i\theta(t)}\zeta(1/2+it)$ with
$\theta(t)=\arg\Gamma(1/4+it/2)-(t/2)\log\pi$, "which comes from the functional equation, not
from the terms." *Vectors:* the same information as the pair (sign Re, sign Im), i.e. quadrant
counting.

**Result 3.32 (P6, the decisive caveat; O2.T7, `done`; PROVED + NUMERICAL).**
$$|S_N(1/2+i\gamma_1)|\approx0.0707\sqrt N ,$$
so **no finite partial sum of the zeta series vanishes at a zero**. The probe prints
$|S_N|/\sqrt N=0.070939,\,0.070722,\,0.070705,\,0.070704,\,0.070704$ at
$N=10^2,10^3,10^4,10^5,10^6$. The Lean companion is rh43's
`balanced_iff_realPartial_eq_zero` (Thm 4.1 of the note's dictionary reference); the registry
records the theorem with axioms `["propext","Classical.choice","Quot.sound"]`
(`objectives.json`, `O2.T7.lean`). "No finite partial sum vanishes at a zero; the cancellation
is in the Euler–Maclaurin tail. A partition of the *terms* therefore cannot locate the zero.
The harmonic tier acts on the moduli $n^{-\sigma}$, which commute with the phases, so it leaves
$R_\pm,I_\pm$ unchanged term by term — R1/R2 cannot help R5."

**Result 3.33 (the verdict; O2.T6, `done`).** One script emits every number quoted in the note
(P1–P6), "making the note's verdict independently checkable"
(`objectives.json`, `O2.T6`). *Status of the script:* `python/decomposition_lab_zeta_probe.py`,
run 2026-10-15, exit 0 (and reproduced for this manuscript, exit 0, §4).

**The note's own "what is open", kept as it stands** (`notes/decomposition-lab-notes.md` §8):
an `Im`-balance theorem is **DONE** — `rounds/rh43/im_balance.py` (54 checks) proves existence
of a **positive** root for every $N\ge2$ from Weyl equidistribution (the relevant torus
function has mean exactly $0$, unlike the real part's mean $1$) plus IVT, gives exact first
roots $\pi/\log2$ ($N=2$) and $2\pi/\log6$ ($N=3$), certifies brackets for
$N=2..20,25,30,40,50$, and applies Brown's criterion to the tail question: at $\sigma=0$ the
absolute $\operatorname{Im}$ series diverges ($A=\infty$) so no summable tail can repair the
finite-$N$ defect, while for $\sigma>1$ the split is Brown-complete up to $\sigma\approx1.87$
(vs the pure-budget threshold $p^*=1.7286472389981836$). Still **OPEN**: complex characters in
007 (push the periodic partition to $|\chi|=1$, and decide whether $\operatorname{Re}\Phi_\chi$
or $|\Phi_\chi|$ is the right threshold functional); and a correct "two-balance" statement for
the *completed* function, since "stated for partial sums it is false by Thm 4.1". And the
recorded instruction: "**Do not** pursue R1/R2 as a route to zeros: P1–P4 show the replacement
is astronomically larger, aperiodic, and phase-blind."

### 3.4 The wider ledger, as this folder carries it

The folder is a snapshot of the whole programme, so the manuscript records the registry's own
11-item proved ledger (`README.md` §"What is proved"; `truths.md` §13;
`objectives.json`, `harvest.proved_ledger`) with the locators `truths.md` gives. These are
*other rounds'* results, republished here; the statuses are `truths.md`'s.

| # | result | `truths.md` status | Lean / evidence |
|---|---|---|---|
| 1 | Greedy digit word: factor-complexity law and inverse-problem impossibility (Rh41) | PROVED (Lean); 8 theorems use `native_decide` | `lean/Rh41/DigitWord.lean:119` (`complexity_main`), `lean/Rh41/Alphabet.lean:702`, `lean/Rh41/Impossibility.lean:21,97` |
| 2 | Signed Tau alphabet: budget algebra, Brown's criterion, census law, four thresholds, parity lock (Rh42) | PROVED (Lean) | `lean/Rh42/Budget.lean:122–158`, `lean/Rh42/Reachable.lean:147`, `lean/Rh42/Tau.lean:260,274` |
| 3 | Balance $\iff\operatorname{Re}S_N(t)=0$, attainable for every $N\ge2$ (Rh43) | PROVED (Lean) | `lean/Rh43/Balance.lean:187,230,359` |
| 4 | Smoothing does not remove the $\sqrt N$; only the functional equation does (Rh044) | PROVED (paper) + VERIFIED to 5–7 digits; the earlier $1/\sqrt{2t}$ constant is REFUTED | `lean/Rh044/Smoothing.lean:121,204`; `notes/readme-rounds__rh044__README.md` §2 |
| 5 | Weil explicit formula + Turing windows $1/2<\operatorname{Im}<15$ and $1/2<\operatorname{Im}<33$, both unconditional (Rh45/010) | CERTIFIED; `N(15)\in[0.7981608,1.2018097]$ at `Lf_const=None` | `logs/010-certify_count15_uncond.log`, `logs/010-certify_count33_par.log`; `lean/Rh45/Explicit.lean:223` |
| 6 | Finite-prefix indeterminacy (two-point Chowla) — one clean new theorem (Rh46) | PROVED (Lean); 2-point Chowla itself remains OPEN | `lean/Rh46/Chowla.lean:332,381,495` |
| 7 | Sylvester-sparsity for the greedy support (Rh47) | PROVED (paper) + VERIFIED (53 159 pairs, 0 violations) | `notes/truths-rh47.md` |
| 8 | OP-5/OP-6 asymptotics (Op56) | PROVED (Lean, axiom-clean) | `lean/Op56/Asymptotic.lean:246` (`op5_nmin_asymptotic`), `:301` (`op6_reachable_fraction`) |
| 9 | von Mangoldt sieves (sibling `publish/001`) | PROVED (Lean) | `truths.md` §11 |
| 10 | Three thresholds $p_N<p_P<p^*$ (TppLean) | PROVED (Lean) | `lean/TppLean/ThreeThresholds.lean:734` |
| 11 | 011 part (A) steps 1–3: $\sup_t\|L(1+it)\|<\infty$; $\Lambda$ bounded on the closed strip; the interface reduced to (H)/(V); the polynomial bound for `LFunction` | PROVED (Lean) | `notes/handoff-013.md` update table; `lean/DirichletStripBound.lean` |

Two entries of this ledger carry corrections that must stay visible:

* **#8, OP-5.** The registry records that the exact ceiling law
  $n_{\min}(p)=\lceil p/\log2-5/2\rceil$ is **FALSE**; the crossing is
  $n_*(p)=p/\log2-3/2+F(p)$ with
  $F(p)=-b/(n_*\log2)+O(n_*^{-2})\approx2.698\cdot10^{-3}/p>0$,
  $b=3(\log2)^2-(25/12)\log2$, and the law holds iff $1-\{y\}>F(p)$,
  $y=p/\log2-3/2$; the first counterexample is a **451-digit** $p$ with
  $n_{\min}p=\lceil p/\log2-5/2\rceil+1$ (independently reproduced at 1150 dps). The sharpest
  true uniform statement is the disjunction
  $n_{\min}p\in\{\lceil A\rceil,\lceil A\rceil+1\}$, **unproved**
  (`truths.md` §9; `objectives.json`, `harvest`). Likewise the $O(1/p)$ error was corrected to
  $O(1)$: `op5_nmin_asymptotic` is stated with the constant $11=8+5/2$.
* **#8, OP-6.** The $1/p$ coefficient is closed-form but **not constant**:
  $c(e)=-\tfrac{(\log2)^2}{2}\bigl(e^2-e+\tfrac94\bigr)$ with
  $e(p)=\lceil p/\log2-5/2\rceil-(p/\log2-5/2)\in[0,1)$, ranging over
  $[-(\log2)^2,-\tfrac98(\log2)^2]=[-0.480453,-0.540510]$; "the formerly quoted constant
  $-0.540509640658\ldots$ is the $e=0$ (smooth-index) value — **the earlier
  constant-coefficient statement was false**" (`truths.md` §9).
* **#3 / rh47.** rh46's inherited sparse bound $2\cdot\#\{n\le x+2:n\in A\}$ is **REFUTED**
  ($A=\{5\}$, $x=5$, $|\Delta S|=4$); the corrected bound
  $|S_A-S|\le2\cdot\#\{n\le x:n\in A\lor n+2\in A\}\le4\cdot\#\{m\le x+2:m\in A\}$ is
  **PROVED (Lean, OP-12)** in `lean/Rh47/Sparse.lean`.
* **#4.** "smoothing removes the $\sqrt N$" is **REFUTED**, and "the earlier $1/\sqrt{2t}$
  constant is wrong" (`truths.md` §5).

**Certified corpus state.** The closing census (round 262) records: `TREE ERRORS=0`; 365
footprints all clean; 365 `depends on axioms` lines, every one
`[propext, Classical.choice, Quot.sound]`; zero occurrences of `sorry`, `admit` or
`native_decide`; 29 Lean files for the 011 development; `verify_objectives.py RESULT: OK`;
27 tasks across 3 objectives; 18 harvest entries; 677 journal sections; 38 deterministic Python
probes. Round 263 then adds the sharp-rate completion. `truths.md` §1 adds the corpus-wide
audit: **no `axiom` declaration anywhere** in the corpus, and no literal `sorry` remains — the
last one (`Op56.tailSum_integral_lower`) was discharged by repairing its hypothesis (see
§3.5).

### 3.5 Two corrections internal to the harvest, kept visible

**The false `Op56.tailSum_integral_lower`.** `truths.md:49–56` records that the lemma "was
**false** as written ($N+1\le M$; witness $p=2$, $N=0$, $M=1$: LHS $0.25$ vs
`tailSum 2 1 = 0.16123…`). It is now a theorem under the corrected hypothesis $N+2\le M$, with
the supporting helper `integral_two_mul_rpow`
($\int_{Ioi M}(2x)^{-p}=(2M)^{-p}\cdot M/(p-1)$)." The old claim and the corrected claim are
both in the record. It "remains a documented, unused negative result (the antitone integral
test is too lossy to prove completeness). The corpus is now `sorry`-free."

**The `native_decide` footprint.** `truths.md:57–65`: the `interval_cases j <;> native_decide`
steps in `Op56.tsum_pow6_exp_neg_half_le` were replaced by
`interval_cases j <;> norm_num [Nat.stirlingSecond]`, so every probed `Op56` theorem now reports
`#print axioms` $=[\texttt{propext},\texttt{Classical.choice},\texttt{Quot.sound}]$ with no
`native_decide` token anywhere in that development. "The only remaining `native_decide` use in
the whole corpus is the unrelated one in `lean/Rh41/DigitWord.lean` (eight theorems:
`onset_not_determined_by_gaps`, the six `refuted_*` witnesses, `plateau_empty_example`,
`c1_bound_gap_necessary`)." This is why the Rh41 row of the corpus audit reads
"PROVED (Lean + native_decide)" for eight theorems while the rest of the corpus is clean.

**Also recorded.** `truths.md` §9 (census caveat) and `html/objectives.html` §9 note a **census caveat**:
`census_measure_eq` holds *by construction* — `reachableMeasure` is defined to be
$2^{n_{\min}p}\cdot\texttt{tailSum}\,p\,(n_{\min}p)$, the right-hand side of the census law — so
the strictly geometric statement (that the $2^{n_{\min}}$ translates in $S_1$ are pairwise
disjoint and their union is exactly the sub-sum set) is **not formalised**;
`lean/Op56/Census.lean` states this as the remaining "census counting" gap. The arithmetic is
verified numerically to $3.9\cdot10^{-62}$ for thirteen exponents (`truths.md` §9).

### 3.6 Registry data defects (reported, not resolved)

`html/objectives.html` §9, the "Caveats and data notes" section that exists precisely to make
the drift visible, records four defects, all reproduced in this manuscript because they bear on
how the ledger should be read:

1. **`O3.T8` lists itself as a dependency** (`dependencies: ["O3.T1","O3.T8"]`). "A
   self-dependency is inert under the ranking rule, but it is a data defect, not a design
   choice." (Confirmed in `objectives.json`.)
2. **Round 40 is logged twice.** "The `round_log` has 264 entries for 263 round numbers;
   round 40 appears twice, both describing the landing of
   `dirichletCompleted_zeroCount_le_of_L_and_hH`." (Confirmed: 264 entries, 263 distinct round
   numbers, duplicate 40; both entries are dated 2026-10-16.)
3. **The published-paper numbering skips 013** (012 is followed by 014) — in the
   `harvest.published_papers` list: `001, 002, 003, 004, 005, 006, 007, 008, 009, 010, 011,
   012, 014`.
4. **`O1.T12` stays `open` even though its mathematics is complete**, because the programme's
   rule requires both Python and Lean for a task to be `done` — "and the remaining
   Euler–Maclaurin endpoint lemma is not yet formalised."
5. **The frontier's `next_step` text for `O1.T12` predates the re-aim**: "It still carries the
   journal-319 framing ('Euler–Maclaurin-type estimate') even though the route was re-aimed to
   the product-sum bracket and the final target is journal 519."

"None of these affects the substance of the mathematics; they are the drift a self-describing
ledger exists to make visible."

## 4. Verification and evidence

### 4.1 What was run while writing this manuscript

| command | result | note |
|---|---|---|
| `python3 verify_objectives.py` | `frontier: O1.T12(15), O1.T6(10)` / `checked 3 objectives, 27 tasks, 29 modules` / `RESULT: OK`, exit 0 | the registry gate; it also gates on the sources (`build_objectives.py`, `verify_objectives.py`, `check_footprints.py` must parse) |
| `python3 t12_sharp_rate_probe.py` (in `python/`) | exit 0; section A prints `sup ratio … = 0.5590179691` attained at $\sigma=2.0,\ t=2$, `TARGET HOLDS <=> sup ratio <= 1 -> TRUE`; section B confirms the asymptotic (differences $3.1\cdot10^{-6}$ at $\sigma=2,t=400$, $0$ to displayed precision at $\sigma=0.5,1$); section C shows the crude residual growing $+1.6465\to+4.6046$ for $n=10^2\to10^5$ against the corrected exponent; section D reports `sum-trap >= 0` where $f$ is convex | mpmath, deterministic |
| `python3 decomposition_lab_zeta_probe.py` (in `python/`) | exit 0; P2 prints the threshold rows and `k(n): {1:1,2:3,3:10,4:30,5:82,6:226}`; P3 prints `moves=0` for $n=1,2,3,4$ and `15.0 = 15.0 after 21 promotion moves; #groups 104 -> 91`; P4 prints $Z_4(1/2+i\gamma_1)=1.322363-0.300877i$; P5 residuals $3.805e-7$, $0.0003199$, $0.1586$; P6 prints $|S_N|/\sqrt N = 0.070939, 0.070722, 0.070705, 0.070704, 0.070704$ at $N=10^2\ldots10^6$ | mpmath, deterministic |

### 4.2 What was **not** run, and why

* **`cd lean && ./check.sh --all`** (97 modules, Lean 4 + Mathlib) was **not run**. The
  toolchain and Mathlib are present (`$HOME/lean/mathlib4`, toolchain pinned by
  `mathlib4/lean-toolchain` to `leanprover/lean4:v4.35.0-rc2`, and `lean/check.sh` requires
  them), but **no `.olean` files ship with this folder** (`*.olean` and `__pycache__` are
  explicitly excluded, `README.md` §"Running the checks"), so the build is a from-scratch
  elaboration of 97 modules against Mathlib and cannot finish inside the ~60-second budget
  this manuscript was written under. The Lean claims in §3.2.2 are therefore cited from the
  modules' own proofs and from the recorded build evidence, not re-elaborated here.
* **`python3 check_dirichlet_engine.py`** was started and **stopped after it exceeded the
  budget**: its archived log reports 165.1 s in step [1] alone, 247.4 s in steps [2–4] and
  34.0 s in step [5] (`logs/check_dirichlet_engine.log`), i.e. several minutes in total. The
  numbers in §4.3 are quoted from that archived log.
* **The heavy certificates** — `certify_dirichlet_routeB.py` (752 s),
  `dirichlet_explicit.py` (508 s and 779 s), `certify_count15_uncond.py` (9571 s),
  `certify_count33_par.py` (9391 s), `route_c_assembly.py` (593 s) — were **not** run. Their
  archived logs are cited verbatim in §4.3.
* **`python3 check_engine.py`, `check_fast_mode.py`, `check_zeta_routeB.py`** were not re-run;
  the archived logs are cited.

### 4.3 The archived evidence, with locators

| claim | evidence file | observed content |
|---|---|---|
| sharp rate target holds | `python/t12_sharp_rate_probe.py`; `notes/sharp-gamma-rate.md` | sup ratio 0.559…, attained $\sigma=2,t=2$; exit 0 |
| $\chi_3$ Turing window $1/2<\operatorname{Im}s<10$ | `logs/certify_dirichlet_routeB_chi3.log`; `data/certify_dirichlet_routeB_chi_3_T10.json` | `I3 count: N_chi(10) in [0.9999999979, 1.000000002] -> N=1 CERTIFIED (454s)`; `on-line zero brackets: 1 (298s)`; `bracket width 1.11e-10`; `total 752s`; `EXIT_DIR=0` |
| the same window, independently | `logs/check_dirichlet_routeB.log` | `RESULT: PASS`, `EXIT_VERIFY=0`; gamma 5 points 0 missed; $H/\Xi$ for $\chi_3,\chi_4,\chi_5,\chi_8$, 0 missed; arg-tracking $[0.999999999114,1.00000000089]$ contains direct quadrature $1.0$; bracket count $=1$ |
| Dirichlet Route C, $\chi_3$ and $\chi_5$ | `logs/dirichlet_explicit_chi3.log`, `logs/dirichlet_explicit_chi5.log` | $\chi_3$: residual $-4.2945568e-10$, budget $2.016e-07$, `VALIDATED`, exit 0, 508 s. $\chi_5$: residual $2.1798798e-08$, budget $1.331e-06$, `VALIDATED`, exit 0, 779 s |
| Dirichlet interval engine | `logs/check_dirichlet_engine.log` | `RESULT: PASS — all containment / width / bound checks satisfied`, `EXIT=0`; 756 Hurwitz enclosures worst width $7.080e-10$; 84 path points; 105 boxed-sample checks 0 failures, 5 boxes refused; EM remainder ratios $\le0.487$ |
| $\zeta$ window $T=15$, unconditional quadrature | `logs/010-certify_count15_uncond.log` | `N(15) in [0.7981608,1.2018097] -> N(15)=1 CERTIFIED (9571s)`; `UNCONDITIONAL: no cited \|zeta'/zeta\| bound was used; Lf is enclosed per step` |
| $\zeta$ window $T=33$, unconditional quadrature | `logs/010-certify_count33_par.log` | `N(33) in [4.711,5.2890345] -> N(33)=5 CERTIFIED (9391s)`; 1340 boxes, 8 workers |
| both $\zeta$ windows, curvature-free | `logs/zeta_routeB_arg_T15.log`, `logs/zeta_routeB_arg_T33.log` | `N(15) in [0.999999909,1.000000091] -> N=1 CERTIFIED`; `N(33) in [4.999999675,5.000000325] -> N=5 CERTIFIED`; the $T=15$ log states it is "the curvature-free re-run: no midpoint rule, no Lf, hence no dependence on the 1/8-vs-1/4 constant" |
| Route C ($\zeta$) | `logs/010-route_c_assembly.log` | residual $-9.0786991e-9$, budget $2.794e-08$ (arch 1.6e−8, prime 1.2e−8, zero-tail 1.6e−80), `VALIDATED (593s)` |
| engine re-validation | `logs/010-verify_engine.log`, `logs/010-recheck_engine.log` | `0 fail(s)` in both; two independent runs (`truths.md` §6) |
| fast mode contract | `logs/010-check_fast_mode.log` | `[PASS] fast_mode: work = 60`, `EPS = 1.0e-40`, `EPS >= 10^-work (contract)`, 4 containment checks, `0 fail(s)` |
| the erratum's regression tests | `notes/010-EXP_NUM_ERRATUM.md` §"The fixes, verified" | `check_ndef.py` 0 fail(s) (0/3000, was 1584/3000); `check_exp_num.py` 0 fail(s) (eta_box 0 corner failures, was 36); `check_engine.py` 0 fail(s) |
| footprint purity | `python/../check_footprints.py`; round-262 census | 365 footprints, all `[propext, Classical.choice, Quot.sound]`; 0 `sorry`/`admit`/`native_decide` |
| registry validity | `python3 verify_objectives.py` | `RESULT: OK` (re-run for this manuscript) |

`check_footprints.py` exists because the naive check is wrong: "Lean wraps long declaration
names, so a perfectly clean footprint can be printed as `'RouteABC.some_long_name' depends on
axioms: [propext,\n Classical.choice,\n Quot.sound]` and the naive count reports a false
NON-CLEAN. That happened (journal 277)." It rejoins wrapped output first, then counts, and
`--expect N` asserts the count.

### 4.4 The figures

Three PNG figures ship in `assets/`, produced by
`python/eta_cos_sin.py` and `python/deconstructed_zeta.py` (both syntax-checked; their outputs
are quoted in the HTML ledgers):

* `assets/eta_cos_sin.png` — six panels on $\eta$ at the first zero: (A) $\operatorname{Re}$
  and $\operatorname{Im}$ partial sums to $M$; (B) the $\operatorname{Im}$ terms are not on the
  unit circle, the greedy word supplying phase only; (C) the boolean selectors $\delta_k$ over
  100 terms $\times$ 196 components, blue = shared by more than one term (30), green = private
  to one term (166); (D) how often each greedy sine component is selected (66 of 196 components
  used by exactly one term); (E) greedy sine reconstruction error per term, max error
  $2.09e-06$ against the bound $\pi/(k+2)=3.14e-06$; (F) the identity in one block.
* `assets/deconstructed_zeta.png` — every $\zeta$ term as a product of greedy angular
  fractions: (A) which of the first 41 fractions each term uses, (B) the same on
  $\log_{10}(k+2)$ up to $k\le10^6$ showing the far fractions are term-private, (C) the collapse
  of one term ($n=9$, $A=\{0,1,5,55,4019\}$, sum $178.9169°$), (D) the 32 uncollapsed products
  of $n=9$ with cos-sum $-0.999821346$, (E) the outer amplitude $n^{-\sigma}$.
* `assets/sine_harmonics.png` — the companion sine-harmonics figure (from
  `python/sine_harmonics.py`).

## 5. What is not claimed

**The twin-prime boundary, stated first and without softening.** Nothing in this folder proves
anything about twin primes or about the parity obstruction.
$$\sum_{n\le x}\lambda(n)\lambda(n+2)=o(x)\quad\text{remains \textbf{OPEN}}$$
(`README.md` §"What is proved" → "Not done"; `research-journal.md` §"Open, blocked, and not
done"; `truths.md` §7 row "two-point Chowla"; `objectives.json`, `harvest.not_done`). `truths.md`
records the 2026 reassessment: "still out of reach; every 2020–2026 advance is log-averaged /
shift-averaged / conditional." And `truths.md` §8 records the programme's own verdict that its
goal "is **not reachable by this programme as it stands**", with OP-16/17/18 "out of reach".

**What is not proved, per objective.**

* **O3.** No zero of $\zeta$ is proved or claimed. Every table and figure is a numerical
  evaluation; "a small value of $|\eta|$ at some $t$ is evidence, not proof, that
  $\zeta(1/2+it)=0$" (`html/eta-euler-acceleration.html` §6). Certifying a zero is
  OUT OF SCOPE for that document. The selector paper's own caveat: zeros there "are found by
  bisection on $\eta$ (Euler-transformed), not from the selectors."
* **O1.** No all-zeros (GRH-strength) conclusion. "Routes A–C certify finite windows. No
  generalisation of the statements produces a conclusion about all zeros of anything, because
  the hypotheses are finitely many enclosures. […] Any claim of the form 'the routes generalise
  to GRH' is false" (`html/dirichlet-011.html` §9, "What cannot be generalised"). Also: the
  numerical $L$-engine is not generic; Route A cannot see multiplicity above one (a $k$-th
  order certificate "is a genuine extension, not an instantiation"); the archimedean budget
  generalises only within the $\Gamma$-family. The sharp archimedean rate is **verified
  numerically**, not formalised. No certified window for any object other than $\zeta$ was
  claimed at the time `dirichlet-011.html` was written; the $\chi_3$ window
  $1/2<\operatorname{Im}s<10$ is claimed in the later registry round and is reported in §3.2.3
  here, with the *log and sidecar* as its evidence. The whole Dirichlet interface and count are
  **conditional** on $(h_L,h_H)$.
* **O2.** The verdict is negative by design. Its own remaining opens are listed in §3.3.
* **Engine.** The 010 quadrature route is **retired** as the primary count, and as archived its
  two Route-B counts are not rigorous (§3.2.8). `ivmath.Num` now raises on a negative radius
  instead of clamping it, closing the failure mode that hid bug 1; `log_hi` range reduction
  remains open ("Item 4 … still open", `notes/010-EXP_NUM_ERRATUM.md`).
* **The registry itself.** `verify_objectives.py` checks existence, parseability, theorem-name
  occurrence, the priority identity and the frontier ordering — it does **not** check the truth
  of any statement, nor that a task marked `done` has a complete proof. The data defects of §3.6
  are outside its scope.

**Corrections and retractions kept visible** (the brief's rule, applied): §3.2.6 O1.T9's
retracted premise; §3.2.6 the strip-edge divergence measurement and its retraction;
§3.2.7 the Stirling-in-$n$ refutation and the corrected convergence formulation;
§3.2.8 both erratum bugs and the midpoint constant; §3.3 the refuted R1/R2/R4 readings;
§3.4 the false OP-5 ceiling law, the false OP-6 constant-coefficient statement, the refuted
rh46 sparse bound, the refuted smoothing constant; §3.5 the false
`Op56.tailSum_integral_lower` hypothesis and the removed `native_decide` footprint.

**One internal tension the folder does not resolve.** `html/dirichlet-011.html` is the
objective's *source paper* and its status table marks the Dirichlet interval engine as
"BUILT (new)" and the $\chi_3$, $T=10$ data as "CERTIFIED (new)", while its §8 target
catalogue still reads "interval engine — missing" for Dirichlet $L$ and "reality — missing";
the registry (`O1.T4` `done`, `O1.T7` `done`) and `notes/generality-lean.md` §§7–10 record both
as closed and the paper's own §7.3 and "Status" table record the closures. The paper's §8 table
is thus **stale with respect to the paper's own §7.3**; the registry is the later authority, and
this manuscript reports the registry's statuses.

## 6. Value and significance

**What it closes.** O1 closes the question it asks: the Route A/B/C cores *are* already general
(`html/dirichlet-011.html` §2, §6), so the remaining work in generalising them is instantiation
data, not new mathematics — "that is a much better position than a bespoke theorem about
$\zeta$ would have been." Within the instantiation it closes the substantive Mathlib gap
(conjugation reality), the root-number sign (with the record that its statement *needs*
`IsPrimitive` and is false without it), the composite-modulus Gauss-sum square, the three
analytic hypotheses, and a certified window for $\chi_3$. O2 closes the decomposition-lab idea
as a *negative result with a quantified reason*, so that it is not re-attempted as open. O3
closes the question of what the η/Euler route can deliver: a fast evaluator with an
$O(t)$-term/$O(t^2)$-work cost, an IEEE-double floor near $2\cdot10^{-15}$ and an optimal
$K\approx72$ — explicitly not a certification.

**What it enables.** Three reusable instruments. (i) The general interface
`SelfDualReal`/`SelfDualRealUpToSign` plus `routeB_reduction_general`: to add a new object, "you
supply a `SelfDualReal` instance plus a zero set, and Route B does the rest"
(`html/dirichlet-011.html` §4.2). The paper names the honest formal target for that: a Lean
`structure SelbergClass` carrying analyticity, the functional equation with conductor and root
number, the Euler product (needed only on Route C's prime side) and a Ramanujan-type growth
condition, "with the numerical engine as an extra parameter" (§8, §9). (ii) A rigorous
Dirichlet-$L$ interval engine whose limits are stated honestly — $M=20,K=50$ gives
$5\cdot10^{-27}$ at $t=50$ but $1.2\cdot10^{-6}$ at $t=100$ ($M$ must grow like $t/4$); a
$\sigma$-box wider than $\approx0.1$ makes the $L$ enclosure contain 0 and the log-derivative
routine **refuses** rather than lie; near a zero of $L$ only relative accuracy survives
(§7.3, `logs/check_dirichlet_engine.log`). (iii) The curvature-free argument-tracking count,
which "needs neither `Lf` nor any constant" and restored both $\zeta$ windows "with a much
tighter and proof-clean method" (`notes/midpoint-constant.md`).

**What it corrects.** Two soundness bugs in shared interval primitives, found *because* an
independent engine was built and its verifier flagged its inputs — the erratum's blast-radius
analysis is the model: it separates what is unaffected (Route A, Route C) from what is not
(Route B counts) and states that those counts "are not rigorous" until re-run. An unproved
budget constant ($1/8$ vs the sharp $1/4$), found independently of the bugs, with the honest
note that the margin "absorbs the factor of two in practice, but not in any proof". A false
lemma (`Op56.tailSum_integral_lower`) whose hypothesis was repaired rather than hidden. A
false ceiling law (OP-5) with a 451-digit counterexample. A false constant-coefficient claim
(OP-6). A refuted sparse bound in rh46, corrected in `lean/Rh47/Sparse.lean`. The removal of
the corpus's last `native_decide` (outside Rh41) and of its last `sorry`.

**Where the frontier is, at the registry's close.** The frontier is two tasks, both the same
remaining step: the final $|t|$-bound. Everything else in O1 is either landed and green (the
interface is a compiled conditional theorem), blocked on the two PNT-strength classical inputs
($h_L$, $h_H$), or — for the archimedean term — reduced to a single formalisation, the
Euler–Maclaurin endpoint lemma of round 263. As `html/objectives.html` §4 puts it, the two
frontier tasks are the same remaining step, and "the mathematics is complete and verified;
only that one Lean lemma remains. The frontier is one lemma deep." The three blocked tasks
stay blocked because their remainders are the Riemann–von Mangoldt theorem itself, which the
folder states plainly rather than dressing up.

## Sources

All paths are relative to this folder. Line numbers are as read. SHA-256 digests of the
primary quoted sources, as read:

| source | SHA-256 |
|---|---|
| `objectives.json` | `aebe01cab06c6e9ab7e4c6e1fe0a99b409fb1d21040cf579eaeffccf85b7f5ed` |
| `truths.md` | `ab40a254e9c660253e5487933686430ea0828d9e83fa3b90ce5fe63c50786d98` |
| `README.md` | `636f31a6500adaee82c4c80d3d4579f57b69a0b2a4f09bd896b0cd36bd6e348d` |
| `research-journal.md` | `2a0be57cebd348003c17731d5b72c2551a8d42cdbbb3b311518371f7538e7503` |
| `html/eta-euler-acceleration.html` | `98eeb04495c4f2acfd96eb8fe539f6dbf7a75ffb230be67445638681f4c33f2f` |
| `html/dirichlet-011.html` | `9164d21c521ce3a983e8b30dbbd0c76b1a7abaaa31287b89175d8aeebf3fac0b` |
| `html/objectives.html` | `cae8cd8cf1a6581355e02300ad21c8c5cca6368453dc182b448eea9305615977` |
| `notes/sharp-gamma-rate.md` | `b2b9594470b7e2647ccf1c7796bb3592ad1c4440c737fd1cba15d315c057d215` |
| `notes/generality-lean.md` | `9c339fc59a779e4bb59d98c43b3db055883fa09571901978a2d214f64159a46c` |
| `notes/decomposition-lab-notes.md` | `fc36e30d6a16987c7a83ad1db6440f08edbdbb119358897f0d8118df5daba9d2` |
| `notes/midpoint-constant.md` | `29bb7caaec2787b01d7e687291805dabd8d74451ae85062b544f89c04deb22c9` |
| `notes/010-EXP_NUM_ERRATUM.md` | `20434a7f5c524f62457445011c261933cd48eaadfe74bdd6a20186836b3d1d1d` |
| `notes/handoff-013.md` | `b5b88c78bad8fad05281ff7b43fd63e74d1fe51f8bdbe9134adfdfdbe2a6803e` |
| `logs/certify_dirichlet_routeB_chi3.log` | `6d917b500fb3a5570b62089d19c6bb1f9bf82ac6331f7aae99875d8c1e9809b8` |
| `data/certify_dirichlet_routeB_chi_3_T10.json` | `f3c93d257e70e00ce67c7c5d0d5e56795b12e58049a4a3baa42391f97ee3d959` |

**Registry and ledgers**

* `objectives.json` — the registry, schema 1.0, generated 2026-10-16T06:17:19 by
  `research/build_objectives.py`; read programmatically (3 objectives, 27 tasks, 264 round-log
  entries for 263 rounds, 18 harvest `lean_corpus` entries, 29 module-graph nodes, 8 external
  modules, 7 `task_to_module` edges, 11 proved-ledger items, 13 published papers). Quoted
  fields: `workflow`, `indices_legend`, `ranking_rule`, `objectives[*]`, `frontier`,
  `harvest`, `lean_dependencies`, `round_log` (rounds 1–263).
* `README.md` — layout table, the three objectives, the 11-item ledger, the tally
  "19 done · 3 refuted · 3 blocked · 2 open", the run recipes, the provenance note (local-only
  regenerated `.olean`/`__pycache__`).
* `truths.md` — the harvested ledger (389 lines): status legend §"How to read a status"
  (lines 8–24), corpus audit §1 (lines 28–65), §2–§12 per-development tables, §13 the
  one-line ledger. Quoted: §1 caveats, §7 (rh46), §9 (OP-5/OP-6, OP-9, OP-10, OP-6 O4,
  census caveat), §10 (007/008/009 verdicts), §12 (ConeLean/TppLean).
* `research-journal.md` — the compacted journal: final state (round 263), the three
  objectives' verdicts, the 11-item ledger, the open/blocked/not-done list.
* `html/objectives.html` — the chronicle of the registry: §0 one-paragraph mathematics, §1 the
  three objectives, §2 the task ledger with T/V/P, §3 the sharp-rate campaign of rounds
  56–262 (with the ordered list of landings), §4 the frontier, §5 the harvest, §6 the axiom
  policy and module graph, §7 the round log by phase, §8 the status summary, §9 the caveats
  and data notes.
* `verify_objectives.py` — the registry gate (run; `RESULT: OK`); `build_objectives.py` — the
  generator (580 837 bytes, parsed by the gate, not otherwise read);
  `check_footprints.py` — the robust footprint checker (read in full).

**Papers (read directly from the HTML for the mathematics)**

* `html/eta-euler-acceleration.html` — the O3 paper: §0 verdict, §1 definitions 1.1/1.2, §2.1
  the exact relation, §2.2 Euler–Maclaurin cancellation, §2.3 the evolution and Figure 1,
  §2.4 the balance table, §3.1 Euler's transformation with derivation, §3.2–§3.5 the family,
  §4.1 Algorithm 4.1, §4.2 accuracy and Figure 2, §4.3 transient/cost table, §4.4 the
  double floor, §5.1–§5.4 the four ledger tables, §6 certification vs evaluation, §7 failure
  modes, §8 the 005 digit-map lab, §9 status table, §10 references.
* `html/dirichlet-011.html` — the O1 paper: the abstract (in full, including the layered
  answer), §1 the four readings L1–L4, §2 the audit table, §3 Route A and its caveat, §4 Route
  B's combinatorial and analytic layers (with `routeB_reduction_general` quoted), §5 Route C
  and the three tails, §6 the generality ladder, §7 the worked instantiation (§7.1 Mathlib,
  §7.2 the normalisation, §7.3 the gaps and their closure with the erratum and the certified
  $\chi_3$ window), §8 the target catalogue, §9 what cannot be generalised, §10 status and
  reproduction.
* `html/decomposition_lab.html` — the lab's §1–§3 statement (geometric series; greedy harmonic
  decomposition of integers; of rational reals with promotion to $1/2$); the mathematics is
  carried by `notes/decomposition-lab-notes.md`.
* `html/eta_selectors.html` — the selector paper: the phase decomposition
  $\sin(t\log n)=\varepsilon_n\sin(\pi\sum_{k\in A_n}1/(k+2))$, the grid, and its caveat that
  the selectors are index/phase data and the vanishing needs the weighted sum.

**Notes**

* `notes/sharp-gamma-rate.md` (95 lines) — the complete derivation of the sharp rate: §1 the
  route and the two ingredients, §2 the endpoint correction verified, §3 the five
  cancellations, §4 from asymptotic to uniform bound, §5 what remains.
* `notes/generality-lean.md` (721 lines) — the Lean generality record: §0 environment facts,
  §1 the interface and the sign refinement, §2 Route A and the new Route C, §3 the Dirichlet
  normalisation, §4 Route B for Dirichlet L, §5 the Mathlib/010 lemma inventory and the two
  former gaps, §6 the honest audit (proved/assumed/not attempted), §7–§10 the four addenda
  (`DirichletConj`, `RootNumber`, `GaussSumComposite`, `DirichletAnalytic`).
* `notes/handoff-013.md` (352 lines) — the part-(A) brief: §1 the objective with the interface
  quoted, §2 the TL;DR table, §3 build and verify metrics, §4 what is committed and where,
  §5 what is not done (steps 3a–3c, 4), §6 step 3a's recipe with the three obstacles,
  §7 hazards, §8 process lessons, §9 where to look, §10 suggested first moves; plus the
  2026-10-15 update boxes (the tree was not green when the brief was frozen; 3a/3b and the
  convexity substitute are done).
* `notes/midpoint-constant.md` (79 lines) — the $1/8$ vs $1/4$ finding, the "very likely safe"
  argument via `Lf`, and the applied fix.
* `notes/010-EXP_NUM_ERRATUM.md` (218 lines) — the two soundness bugs, their blast radius, the
  impact table, the $1/8$ finding, the fixes verified, the follow-up and the re-run status.
* `notes/decomposition-lab-notes.md` (289 lines) — the O2 verdict: §0 the result table R1–R5,
  §1 what §2–§3 actually prove, §2 R1, §3 R2, §4 R3 and the 007 bridge, §5 R4, §6 R5, §7 the
  per-claim status table, §8 what is open.
* `notes/Rh45-ARGUMENT_PRINCIPLE.md`, `Rh45-GAMMA_PRODUCT.md`, `Rh45-POLYGAMMA.md`,
  `Rh45-SIMPSON.md`, `Rh45-WEIERSTRASS.md`, `Rh45-XI_ENTIRE.md` — the six proof notes behind
  the general Route B (the rectangle argument principle with the edge-by-edge computation; the
  locally uniform Euler-product limit for `GammaSeq`; the polygamma series; the corrected
  single-panel Simpson estimate together with the two reasons the original statement was
  **false**; the zero-division factorisation; the concrete $\xi$ ingredients).
* Other notes in the folder (not read in full; listed for completeness):
  `notes/truths-rh41.md`, `truths-rh42.md`, `truths-rh43.md`, `truths-rh044.md`,
  `truths-rh47.md`, `handoff-rh042/43/044/47.md`, `handoff-rh42.md`, `handoff-rh43.md`,
  `handoff-rh47.md`, `generalisation-analysis.md`, `readme-*.md`, `004-*.md`,
  `010-KERNEL_FINDINGS.md`, `010-T1_BLOCKER.md`.

**Lean** (97 modules; `lean/check.sh` lists exactly 97, one per file, in dependency order)

* `lean/check.sh` — read in full: toolchain discovery, `LEAN_PATH` construction, the `--all`
  module list, and the note that "Never pipe check.sh into `tail` and read `$?`".
* `lean/Generic.lean` — `SelfDualReal`, `SelfDualRealUpToSign`, `logDeriv_one_sub_of_const_mul`,
  `routeB_of_selfDualReal`, `routeB_general_of_logDeriv`, `routeB_of_selfDualRealUpToSign`,
  `CertifiedZero`, `validated_truncation_bound_finset`, `validated_truncation_bound_three`,
  `dirichletCompleted`, `dirichletL_normalised_one_sub`, `dirichletCompleted_selfDual`,
  `dirichletCompleted_conj`, `RootNumberSign`, `CompletedLFunctionConj`,
  `routeB_for_dirichletL` (quoted via `notes/generality-lean.md`).
* `lean/DirichletConj.lean` — read: header plus `LSeries_conj` and the module's declarations
  (`LFunction_conj_of_one_lt_re`, `Complex.Gammaℝ_conj`, `gammaFactor_conj`,
  `completedLFunction₀_conj`, `completedLFunction_conj`, `completedRiemannZeta_conj`).
* `lean/DirichletStripBound.lean` — read lines 1420–1549: `exists_integral_…_of_L` (:1429),
  `exists_horizontal_bound_of_integrable_case` (:1474),
  `criticalStripLogDerivBound_of_L_and_hH` (:1501),
  `dirichletCompleted_zeroCount_le_of_L_and_hH` (:1520),
  `integrable_norm_completedLogDeriv_horizontal` (:1549).
* `lean/DirichletZeroCounting.lean:480` — `CriticalStripLogDerivBound` (quoted via
  `notes/handoff-013.md` §1); `lean/DirichletZeroCount2.lean:468` —
  `riemannVonMangoldtDensity_of_interface`.
* `lean/GammaBounds.lean` (140 declarations) — line locators for the nine declarations in the
  §3.2.7 table, as listed there.
* `lean/CertifiedWindow.lean` — the structure named as the remaining obligation.
* `lean/DirichletAnalytic.lean` — the analytic-hypothesis discharge (quoted via
  `notes/generality-lean.md` §10); `lean/DirichletRouteB.lean` —
  `routeB_for_dirichletL_unconditional`; `lean/RootNumber.lean`,
  `lean/GaussSumComposite.lean` — quoted via `notes/generality-lean.md` §§8–9.
* `lean/Rh45/Routes.lean:37,71,95,106,123,162` — Routes A/B/C;
  `lean/Rh45/RouteBAnalytic.lean:227` — `routeB_reduction`;
  `lean/Rh45/Explicit.lean:223`; `lean/Rh45/Archimedean.lean`, `SimpsonPanel.lean`,
  `Weierstrass.lean`, `ArgumentPrinciple.lean`, `PolygammaSeries.lean`, `GammaProduct.lean`,
  `XiEntire.lean`, `RouteBGeneral.lean` — read via the `notes/Rh45-*.md` notes.
* `lean/Rh41/DigitWord.lean:119,212,226,237,253,262,331,347,515,546,566`;
  `lean/Rh42/Budget.lean:122–158`, `Reachable.lean:147,171`, `Tau.lean:178,260,274`;
  `lean/Rh43/Balance.lean:187,230,330,350,359,392,458,489`;
  `lean/Rh044/Smoothing.lean:121,204,215,249,336,365`;
  `lean/Rh46/Chowla.lean:162,174,210,227,239,298,332,381,392,495`;
  `lean/Rh47/Sparse.lean`; `lean/Op56/Asymptotic.lean:246,301`, `Census.lean:56,60`,
  `Exact.lean:107,143`, `PhiThird.lean`, `PhiFourth.lean`, `FloorAsymptotic.lean`;
  `lean/TppLean/ThreeThresholds.lean:734`; `lean/ConeLean/*` — line locators as given in
  `truths.md` §§2–12 (read there, not re-opened except where noted).
* `lean/Axioms.lean`, `AxiomsConj.lean`, `AxiomsL.lean` — the `#print axioms` trackers
  (`AxiomsL.lean:116,141,277,280,405` located for the interface theorems).

**Python** (85 `.py` files including `__init__.py`; 38 match `*probe*.py`)

* `python/ivmath.py` — read (header, `WORK = 400`, `EPS = 1e-320`, the `Num` type and its
  operations, `pi` via Machin, `log_n`, `cos_num`/`sin_num`).
* `python/eta_interval.py` (1198 lines), `python/dirichlet_interval.py` (630 lines) — the
  interval engines (headers and API; the Dirichlet engine's own `_div_iv`/`_cdiv`/`_exp_box`,
  built because of the 010 erratum).
* `python/t12_sharp_rate_probe.py` (112 lines) — run; output quoted in §4.1/§4.3.
* `python/decomposition_lab_zeta_probe.py` (198 lines) — run; P1–P6 output quoted in §3.3/§4.1.
* `python/zeta_routeB.py` — the curvature-free argument-tracking count (via
  `notes/midpoint-constant.md` and the two logs).
* `python/certify_dirichlet_routeB.py` (127 lines), `python/check_dirichlet_routeB.py`,
  `python/dirichlet_explicit.py`, `python/dirichlet_routeB.py`, `python/check_dirichlet_engine.py`
  (459 lines), `python/check_gausssum_sq.py`, `python/check_dirichlet_conj.py`,
  `python/contour_repair_probe.py`, `python/strip_edge_divergence_probe.py`,
  `python/gamma_rate_probe.py`, `python/gammaseq_rate_probe.py`,
  `python/c1_gamma_t_bound_probe.py`, `python/eta_cos_sin.py` (407 lines),
  `python/deconstructed_zeta.py` (152 lines), `python/certify_count15_uncond.py`,
  `python/certify_count_par.py`, `python/route_c_assembly.py`, `python/check_fast_mode.py`,
  `python/check_engine.py`, `python/check_exp_num.py`, `python/check_ndef.py`,
  `python/probe_lf.py`, `python/scan_i3_boxes.py`, `python/check_zeta_routeB.py` — cited via
  the `logs/` and the notes; not all re-read in full.
  **Not run** (budget): `check_dirichlet_engine.py` (started, stopped), and the heavy
  certificates listed in §4.2.

**Logs and data**

* `logs/` (38 files) — quoted: `certify_dirichlet_routeB_chi3.log`,
  `check_dirichlet_routeB.log`, `dirichlet_explicit_chi3.log`, `dirichlet_explicit_chi5.log`,
  `check_dirichlet_engine.log`, `zeta_routeB_arg_T15.log`, `zeta_routeB_arg_T33.log`,
  `010-certify_count15_uncond.log`, `010-certify_count33_par.log`,
  `010-route_c_assembly.log`, `010-check_fast_mode.log`, `010-verify_engine.log`.
* `data/certify_dirichlet_routeB_chi_3_T10.json` — read in full (eight fields; the zero
  bracket as two exact rationals; `turing_ok: true`).
* `data/eta_selectors.tsv` (40 779 bytes), `data/partition_N20.json`,
  `data/positive_only_N20.json` — the selector grid and the partition artefacts (cited by the
  papers; not otherwise read).
* `assets/eta_cos_sin.png`, `assets/deconstructed_zeta.png`, `assets/sine_harmonics.png` —
  viewed; described in §4.4.

**Sibling editions referenced but not part of this folder** (local-only, elsewhere in the
repository; the reproductions inside them were **not** re-run): the 010 rigorous scripts and
their certificates (`certify_count15_uncond.py`, `certify_count33_par.py`,
`eta_interval.py`'s origin, `zeta_routeB.py`'s origin), `publish/001-von-mangoldt-sieves`,
`rounds/rh*/` notes, `open/lean/Op56`, `007/lean/Op57`, `008/lean/Op58`, `009/lean/Op59`, and
the project-wide journal (677 sections) of which `research-journal.md` is the compacted form.

**External sources cited by the folder's own papers** (not re-verified here; as listed in
`html/eta-euler-acceleration.html` §10 and `html/dirichlet-011.html` "References"): Euler
(1755); Aitken (1926); Shanks (1955); Wynn (1956, 1961); Borwein–Borwein (1987); P. Borwein
(2000); Cohen–Rodriguez Villegas–Zagier (2000); Borwein–Bradley–Crandall (2000); Titchmarsh–
Heath-Brown (1986); Edwards (1974); Turing (1953); Johansson (2015); Brent–Zimmermann (2010);
Weniger (1989); Levin (1973); Selberg (1992); Iwaniec–Kowalski (2004); and Mathlib's
`NumberTheory/LSeries/{DirichletContinuation,Dirichlet,Nonvanishing}.lean`,
`Analysis/Fourier/ZMod.lean`, `Analysis/SpecialFunctions/Stirling.lean`.
