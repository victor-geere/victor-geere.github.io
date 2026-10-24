# The Explicit Formula and Routes A / B / C: Certified Simple Zeros and Validated Truncation

**First edition, packaged from `research/truths.md` §6 (round `rh45`, folder `010`); the
item was received from `research/twin-prime-parity/rounds/rh45/` and is reproduced here
with markdown links re-pointed into this folder. This folder does not prove the twin
prime conjecture, and it claims nothing about the Riemann Hypothesis; it certifies two
finite height windows and five individual zeros.**

## Abstract

The programme extracts zero information from $\zeta$ through the Weil explicit formula.
A first draft of that formula used the wrong normalisation; the corrected form is the one
used here, and the correction is kept on the record. This paper packages three
certification routes. **Route A**: a continuous $f$ with $f(a)<0<f(b)$ and a strictly
one-signed derivative on $(a,b)$ has a unique simple zero there — PROVED in Lean
(`Rh45Routes.exists_unique_root_of_sign_change`, and the enclosure form
`certified_root_of_enclosures`), which turns interval enclosures into certified simple
zeros. Applied with the rigorously enclosed real function $Z(t)$ from the folder's own
enclosure engine, Route A certifies $\gamma_1,\dots,\gamma_5$ unique, simple and on the
critical line, 5/5 (CERTIFIED, `rigorous/certify_unique.log`). **Route B**: the Turing
reduction — certified zeros inside the window's zero set and a rigorous count no larger
than the certified set force equality — is PROVED in Lean (`turing_reduction`,
`all_zeros_are_certified`); combined with two unconditional counts
($N(15)\in[0.7981608,1.2018097]$ and $N(33)\in[4.711,5.2890345]$, no cited
$|\zeta'/\zeta|$ bound, `Lf_const = None`) it closes the windows $\tfrac12<\operatorname{Im}<15$
and $\tfrac12<\operatorname{Im}<33$: every zero there is simple and on the critical line
(CERTIFIED, both unconditional). **Route C**: the truncation error assembly is PROVED in
Lean (`validated_truncation_bound`), the prime tail is Mathlib's Chebyshev bound
(`prime_tail_input`, PROVED), the archimedean tail is PROVED with explicit constants, and
the zero tail is CITED (Riemann–von Mangoldt plus Trudgian's explicit $S(T)$ bound) with a
PROVED Stieltjes assembly; the numerical assembly is VALIDATED on the modulated Gaussian
with residual $-9.08\cdot 10^{-9}$ against a budget of $2.79\cdot 10^{-8}$.

**Keywords.** Riemann zeta function; Weil explicit formula; certified zeros; interval
arithmetic; Lean 4; Mathlib; Turing's method; argument principle; Chebyshev; Stirling.

## 1. Introduction and goal

The programme's instrument for extracting zero information from $\zeta$ is the explicit
formula. An audit (folded into this paper as §7) fixed the exact form of the formula,
found that the first-draft normalisation was false, and listed the defects `F1–F7` of the
original `rh45` draft; Routes A, B and C are the response to that audit's three
"certification routes". The goal of the folder is not a new zero-counting theorem but a
*validated instrument*: logic that is machine-checked, an arithmetic engine whose
enclosures are sound, and numerical certificates whose error budgets are explicit.

Three things are in scope. First, the logical content of a zero certificate (Route A:
sign change plus a derivative-sign enclosure gives a unique simple zero). Second, the
Turing reduction that converts a rigorous total count into the assertion that *every* zero
in a finite window is simple and on the critical line (Route B). Third, the validated
truncation of the explicit formula into three explicitly bounded tails (Route C). The
numerical work that discharges the hypotheses — the enclosure engine, the zero brackets,
the two counts and the Route C assembly — is in this folder and is reported with its
observed output in §4.

The explicit boundary of the item is stated by the sources and repeated in §8: anything
about the Riemann Hypothesis is out of scope; only finite windows and five individual
zeros are certified.

## 2. Setup and definitions

**Test functions.** Throughout, $g:\mathbb{R}\to\mathbb{C}$ is a real, even test function
(the sources use $g$ real and even; the Route C certificate uses the modulated Gaussian
$g(u)=e^{-u^2/2}\cos(\theta u)/\sqrt{2\pi}$ with $\theta=14\in\mathbb{Q}$, so that the
kernel is exact). Its Fourier transform and its Laplace-type transform are

$$\varphi(t)=\int_{\mathbb{R}} g(u)e^{itu}\,du,\qquad
\Phi(s)=\int_{\mathbb{R}} g(u)e^{(s-1/2)u}\,du ,$$

so that $\varphi$ is even and $\Phi(1-s)=\Phi(s)$ for even real $g$. On the critical line
the two agree: $\Phi(\tfrac12+i\gamma)=\varphi(\gamma)$.

**The corrected Weil explicit formula.** With $\Lambda$ the von Mangoldt function,
$\psi(x)=\sum_{n\le x}\Lambda(n)$ and $\Psi(t)=-\log\pi+\operatorname{Re}\psi(\tfrac14+it/2)$
(the archimedean term; $\psi$ on the right is the digamma function), the audited identity is

$$\sum_{\rho}\Phi(\rho)=\Phi(1)+\Phi(0)
-\sum_{n\ge 2}\frac{\Lambda(n)}{\sqrt n}\bigl[g(\log n)+g(-\log n)\bigr]
+\frac{1}{2\pi}\int_{\mathbb{R}}\varphi(t)\Psi(t)\,dt ,$$

the sum over the nontrivial zeros $\rho$ of $\zeta$. The first draft's form
$(E)\ \sum_\rho F(\rho)=F(1)+F(0)-\frac{1}{2\pi}P$ with $F(s)=\int g(u)e^{-su}du$ is
**false**; the audit's witnesses for that (residuals $-1.037$, $+2.278$, $+2.023$,
$+2.18$ on four kernels, where the Weil form gives $9.63\cdot 10^{-46}$) are reproduced in
§7.1 below. The pole-pair collapse for even $g$ is recorded by the sources as
$\Phi(1)+\Phi(0)=2\varphi(i/2)=2\int g(u)e^{-u/2}du$ (see the note on the intermediate
term in §9).

**Zeros and counts.** Write $\rho=\beta+i\gamma$ for a nontrivial zero of $\zeta$, counted
with multiplicity, and $N(T)$ for the number of zeros with $0<\operatorname{Im}\rho<T$
(the folder's certificates use the symmetric contour and the normalisation
$N(T)=\operatorname{Im}(I_3)/\pi$ of §3.2). $\gamma_1<\gamma_2<\cdots$ are the positive
ordinates.

**The real function $Z$.** With $\theta$ the Riemann–Siegel theta function,

$$Z(t)=e^{i\theta(t)}\zeta(\tfrac12+it),\qquad
Z(t)=\cos\theta(t)\operatorname{Re}\zeta(\tfrac12+it)-\sin\theta(t)\operatorname{Im}\zeta(\tfrac12+it) ,$$

which is real for real $t$; a zero of $Z$ is a zero of $\zeta$ on the critical line.

**Enclosures.** The engine's rigorous reals are value-plus-guaranteed-error pairs
$[v-e,v+e]$ (`rigorous/ivmath.py`, with the transcendental quantities built from bounded
series rather than taken from `mpmath`); the soundness contract is that the blanket
rounding slack `EPS` dominates the accumulated rounding at the working precision, and the
certified fast mode (`work = 60`, `EPS = 1e-40`) moves `WORK`, `EPS` and mpmath's precision
together.

**Curvature input for Route B.** On the Route B path, $f=\xi'/\xi$ with
$\xi(s)=\tfrac12 s(s-1)\pi^{-s/2}\Gamma(s/2)\zeta(s)$, and
$f'=(\log\xi)''=-1/s^2-1/(s-1)^2+\tfrac14\psi'(s/2)+\zeta''/\zeta-(\zeta'/\zeta)^2$.
The midpoint rule on a step of length $|ds|$ has $|\text{err}|\le\tfrac18|ds|^2\sup|f'|$;
`Lf_const` denotes a supplied bound for $\sup|f'|$, and `Lf_const = None` means the engine
encloses $|f'|$ per step instead of citing one.

## 3. Results

The numbering of the sources (Theorems A, B, C; Corollary A′; Proposition D; the two
Turing windows; the tail propositions) is kept, and every status marker is attached to the
exact claim it marks. `PROVED (Lean)` means machine-checked with no `sorry`, no `axiom` and
axiom footprint `[propext, Classical.choice, Quot.sound]`; the certificates are labelled as
the logs label them.

### 3.1 Route A — the sign-change certificate

**Theorem A (Route A logic).** *Let $a<b$, let $f:\mathbb{R}\to\mathbb{R}$ be continuous on
$[a,b]$ and differentiable on $(a,b)$, and suppose $f(a)<0<f(b)$ and $f'(x)>0$ for every
$x\in(a,b)$. Then $f$ has exactly one zero $x_*\in(a,b)$, and it is simple: $f'(x_*)>0$.*
**PROVED (Lean)**, `Rh45Routes.exists_unique_root_of_sign_change`
(`Rh45/Routes.lean#L37`).

*Proof (as carried by the source).* Existence: $0\in[f(a),f(b)]$, so the intermediate value
theorem for continuous functions on a closed interval gives $x\in[a,b]$ with $f(x)=0$; since
$f(a)<0$ and $f(b)>0$, in fact $x\in(a,b)$. Uniqueness and simplicity: a differentiable
function with strictly positive derivative on the interior of an interval is strictly
increasing there; two distinct zeros $x<y$ would give $f(x)<f(y)$, i.e. $0<0$, a
contradiction. Simplicity is exactly the derivative hypothesis at the zero. $\blacksquare$

**Route A, decreasing case (mirror).** *The same statement with $f'(x)<0$ on $(a,b)$ and
$f(a)>0>f(b)$.* **PROVED (Lean)**,
`Rh45Routes.exists_unique_root_of_sign_change_neg` (`Rh45/Routes.lean#L129`); needed at
$\gamma_2$ and $\gamma_4$, where $Z'<0$.

**Corollary A′ (enclosure form).** *Suppose instead we are given enclosures: $f(a)\in[l_a,h_a]$
with $h_a<0$; $f(b)\in[l_b,h_b]$ with $0<l_b$; and $f'(x)\in[m,M]$ for all $x\in(a,b)$ with
$0<m$. Then the conclusion of Theorem A holds.* **PROVED (Lean)**,
`Rh45Routes.certified_root_of_enclosures` (`Rh45/Routes.lean#L71`).

Corollary A′ is the exact interface a numerical certificate must hit. For $f=Z$ it requires
(i) a rational bracket $a<b$ with enclosed $Z(a)<0<Z(b)$ and (ii) an enclosure of $Z'$ on
$(a,b)$ bounded away from zero. Nothing else is assumed: no knowledge of $\theta$ or of the
imaginary part of $\zeta$ enters the logic, only the enclosures. (In the delivered
certificate script the bracket centre is seeded from a numerically known zero ordinate; the
source notes that "brackets are relative to the numerically known $\gamma_k$". See §9.)

**Certified on-line zeros (existence; finite check, CERTIFIED).** For $k=1,\dots,5$,
`rigorous/certify_zeros.py` exhibits rational $a<b$ with enclosed $Z(a)<0<Z(b)$; by the
intermediate value theorem $Z$ — hence $\zeta$ — has a zero on the critical line in
$(a,b)$. Observed output (`rigorous/certify_zeros.log`, exit 0, 5/5): relative brackets of
width $6.104\cdot 10^{-5}$ for $\gamma_1,\gamma_2,\gamma_3$, $9.766\cdot 10^{-4}$ for
$\gamma_4$ and $3.125\cdot 10^{-2}$ for $\gamma_5$; no value of $\zeta$ is quoted from
`mpmath`, the endpoints are enclosures produced by the engine.

**Certified uniqueness and simplicity (CERTIFIED 5/5).** The engine computes a rigorous
enclosure of $Z'$ over a whole bracket (rigorous $\zeta'$ with the proved tail, plus
$\theta'$, $\theta''$ bounds); a strictly one-signed $Z'$ enclosure makes $Z$ strictly
monotone, so the sign change gives a *unique simple* zero. Observed output
(`rigorous/certify_unique.log`, exit 0, 5/5), on brackets of width $10^{-3}$:

| zero | enclosed $Z'$ | conclusion |
|---|---|---|
| $\gamma_1$ | $[0.766441,\,0.819918]$ | unique simple on-line zero |
| $\gamma_2$ | $[-1.17358,\,-1.10014]$ | unique simple on-line zero |
| $\gamma_3$ | $[1.32035,\,1.42321]$ | unique simple on-line zero |
| $\gamma_4$ | $[-1.34866,\,-1.25925]$ | unique simple on-line zero |
| $\gamma_5$ | $[1.33534,\,1.42899]$ | unique simple on-line zero |

**Route A is therefore complete for $\gamma_1,\dots,\gamma_5$:** existence by an enclosed
$Z$ sign change, uniqueness and simplicity by an enclosed one-signed $Z'$, with the logical
step machine-checked in Lean (CERTIFIED, 5/5). The ordinates themselves are recorded by the
ledger (`ROUND-TRUTHS.md` §5) as located from $\zeta$ evaluations alone, without
`mp.zetazero`, to 32–33 digits: $\gamma_1=14.134725141734693790457251983562$,
$\gamma_2=21.022039638771554992628479593897$,
$\gamma_3=25.010857580145688763213790992563$,
$\gamma_4=30.424876125859513210311897530584$,
$\gamma_5=32.935061587739189690662368964075$.

**Proposition D (symmetric winding forces the line).** *Let $R\subset\{0<\operatorname{Re}s<1\}$
be a rectangle invariant under $s\mapsto 1-s$, with $\zeta\ne 0$ on $\partial R$, and
suppose the winding number of $\zeta$ along $\partial R$ equals $1$. Then $R$ contains
exactly one zero of $\zeta$, it is simple, and $\operatorname{Re}\rho=\tfrac12$.*
**PROVED (§4 of the paper, using the functional equation and the argument principle)**;
not formalised in this folder.

*Proof (as carried by the source).* The argument principle makes the winding number the
number of zeros of $\zeta$ in $R$ counted with multiplicity; it is $1$, so there is exactly
one simple zero $\rho\in R$. If $\operatorname{Re}\rho\ne\tfrac12$, the functional equation
$\xi(s)=\xi(1-s)$ (equivalently $\zeta(1-\rho)=0$ in the strip) makes $1-\rho$ a zero as
well; invariance of $R$ puts $1-\rho\in R$, and $1-\rho\ne\rho$. That is a second zero,
contradicting multiplicity $1$. $\blacksquare$

Proposition D is the recommended Route A engine in the source because it needs no $Z$, no
$\theta$ and no $\Gamma$; the folder did not adopt it — the adopted route is the point-wise
$Z$ route above, and §7 records the diagnosis (naive arc enclosures are far too wide).

### 3.2 Route B — the Turing reduction

**Theorem B (Turing reduction).** *Fix a height $T>0$. Let $\mathrm{Cert}$ be the finite set
of heights at which Route A certificates have been produced, and let $\mathrm{Zeros}$ be the
finite set of zeros $\rho=\beta+i\gamma$ of $\zeta$ with $0<\gamma<T$ and $0<\beta<1$,
counted with multiplicity. Suppose (i) $\mathrm{Cert}\subseteq\mathrm{Zeros}$ and (ii)
$|\mathrm{Zeros}|\le|\mathrm{Cert}|$, where $|\mathrm{Zeros}|$ is a rigorous upper bound
for the number of zeros in the window. Then $\mathrm{Zeros}=\mathrm{Cert}$: every zero in
the window is one of the certified ones, hence simple and on the critical line.*
**PROVED (Lean)**, `Rh45Routes.turing_reduction` (`Rh45/Routes.lean#L95`), as
`Finset.eq_of_subset_of_card_le`.

*Proof (as carried by the source).* If $\mathrm{Zeros}\supsetneq\mathrm{Cert}$ then
$|\mathrm{Zeros}|>|\mathrm{Cert}|$, contradicting (ii). Hence equality; by (i) and Route A
each element of $\mathrm{Cert}$ is a simple on-line zero, so every element of
$\mathrm{Zeros}$ is one. $\blacksquare$

**Route B, packaged.** *Under the same two hypotheses, every $z\in\mathrm{Zeros}$ satisfies
$z\in\mathrm{Cert}$.* **PROVED (Lean)**, `Rh45Routes.all_zeros_are_certified`
(`Rh45/Routes.lean#L162`).

Theorem B is where Turing's method lives: the work is entirely in discharging (ii), a
rigorous upper bound for the number of zeros in the window, and in producing the certified
set of (i). Because a rigorous count of all zeros in the window (by the argument principle)
also counts possible off-line zeros, equality forces every zero in range onto the line — the
exclusion that a sign-change scan alone cannot provide.

**The counting identity.** Let $\xi(s)=\tfrac12 s(s-1)\pi^{-s/2}\Gamma(s/2)\zeta(s)$, so that
$\xi(s)=\xi(1-s)$, and let

$$I_3=\int_{(\frac12,\frac12)\to(1,\frac12)\to(1,T)\to(\frac12,T)}\frac{\xi'}{\xi}(s)\,ds ,$$

a path lying in $\operatorname{Re}s\in[\tfrac12,1]$ (the domain on which the engine is
valid). Because $\xi(s)=\xi(1-s)$ and the rectangle $[0,1]\times[\tfrac12,T]$ is symmetric,
splitting $\oint_{\partial R}\xi'/\xi\,ds$ into halves gives $2I_3=2\pi i\,N(T)$, hence

$$N(T)=\frac{\operatorname{Im}(I_3)}{\pi}.$$

The identity was checked numerically (`mpmath`) at $T=20,35,50$, giving
$\operatorname{Im}(I_3)/\pi=1,5,10$ exactly: **NUMERICAL (identity)**, not a certificate.
The analytic (symmetric) layer of the reduction is **PROVED (Lean)**: `xi_one_sub`,
`logDeriv_one_sub`, `logDeriv_conj`, `logDeriv_one_sub_conj`,
`xi_logDeriv_symmetry`, the contour reduction
`rectBoundary_eq_rightPath_sub_conj` ($\oint_{\partial R}g=I_3-\overline{I_3}=2i\operatorname{Im}I_3$
from the single symmetry $g(1-\bar s)=-\overline{g(s)}$), and `routeB_reduction` /
`routeB_reduction_of_functional_equation` ($\operatorname{Im}(I_3)=\pi Z$ from the
argument-principle count $\oint=2\pi iZ$) — `Rh45/RouteBAnalytic.lean`, 6/6, axiom-clean,
with the rectangle argument principle and $\xi(\bar s)=\overline{\xi(s)}$ as explicit named
hypotheses because Mathlib lacks them (Mathlib has no `riemannXi` and no winding number).

**Quadrature.** `I3_certificate` uses the midpoint rule with the curvature bound
$|\text{err}|\le\tfrac18|ds|^2\sup|f'|$, $f=\xi'/\xi$. With a per-path constant
$Lf\ge\sup|f'|$ the step is chosen so that the total budget is $<\pi/2$.

**Certified counts.** Observed outputs:

* `rigorous/certify_count.log`: with `Lf_const = 25` (a rigorous bound *provided* it exceeds
  $\sup|f'|$; the empirical value on the path is $\approx 4.2613$), $T=3$ at
  `steps/unit = 10`, $K=50$ gives
  $\operatorname{Im}(I_3)/\pi\in[-0.34815161,0.34815127]$, i.e. **$N(3)=0$ CERTIFIED**
  ($480$ s).
* `rigorous/certify_count15d.log`: **conditional** certificate, fast mode, `K = 40`,
  `Lf_const = 30` justified only by the *cited* zero-free-region bound
  $|\zeta'(\sigma+it)/\zeta(\sigma+it)|\le A\log(|t|+2)$ with $A=1$: $T=15$,
  `steps/unit = 48` gives $\operatorname{Im}(I_3)/\pi\in[0.57197018,1.4279394]$, i.e.
  **$N(15)=1$ CERTIFIED, modulo that cited input** ($2870$ s). The source records that the
  empirical value of $\sup|f'|$ is $\approx 4.26$, far below the cited $30$.
* `rigorous/certify_count15_uncond.log` (**item T1, certified 2026-10-11**): the same count
  with `Lf_const = None` — no cited $|\zeta'/\zeta|$ bound anywhere — gives $T=15$,
  `steps/unit = 24`, $K=40$, $I_3=(-6.553844068,3.141546283)$ and
  $N(15)\in[0.7981608,1.2018097]$, i.e. **$N(15)=1$ CERTIFIED, UNCONDITIONAL** ($9571$ s;
  half-width $0.2018<0.5$). Two engine obstructions had to be removed: the removable
  singularity of $\zeta=\eta/(1-2^{1-s})$ on $\operatorname{Re}s=1$ at
  $t_k=2\pi k/\ln 2$ (including $t_0=0$), routed for boxes within $7/10$ of any $t_k$ to the
  rigorous local Taylor/Cauchy enclosure `zeta_local_box`; and the loose curvature bound,
  which is enclosed per step rather than cited, bringing $\sum Lf$ from $74776$ down to
  $2282.1$ (so $\text{err}=\sum Lf/(8\cdot 24^2)=0.495$).
* `rigorous/certify_count33_par.log` (**item T2, certified 2026-10-11**): the parallel form
  of the same certificate, `T=33`, `steps/unit = 40`, $K=100$, `Lf_const = None`,
  `boxes = 1340`, 8 workers, gives
  $I_3=(-21.381925500160733,15.7080176058059)$ and
  $N(33)\in[4.711,5.2890345]$, i.e. **$N(33)=5$ CERTIFIED, UNCONDITIONAL** ($9391$ s;
  half-width $0.289<0.5$). Two configuration requirements were found: the Euler-accelerated
  $\eta$ enclosure needs $K\gtrsim 0.25\,t$ (at $t=33$, $K=40$ returns a $1.8\cdot 10^{10}$-wide,
  sound but uselessly loose enclosure, while $K=100$ is clean: `scan_i3_boxes.py 33 16 100`
  → 536 boxes, 0 failing, versus 261 failures at $K=40$); and `steps/unit = 32` is
  **UNDECIDED by 3.8 %** ($N(33)\in[4.4810151,5.5190349]$, half-width $0.519>0.5$), so $40$
  is used. A $12$-step-per-unit run of the unconditional $T=15$ count is also on record as
  UNDECIDED ($N(15)\in[-19.70387,21.704076]$), which is why $24$ steps per unit are used.

**The two Turing windows are closed, both unconditionally.** The certified on-line zeros with
$\tfrac12<\operatorname{Im}<15$ are exactly $\{\gamma_1\}$, and those with
$\tfrac12<\operatorname{Im}<33$ are exactly $\{\gamma_1,\dots,\gamma_5\}$ (brackets up to
$32.9341\dots 32.9361$, all $<33$). By the machine-checked
`Rh45Routes.all_zeros_are_certified`:

> **every zero with $\tfrac12<\operatorname{Im}<15$, and every zero with
> $\tfrac12<\operatorname{Im}<33$, is simple and on the critical line.**
> **CERTIFIED — UNCONDITIONAL (items T1, T2; `Lf_const = None`).**

### 3.3 Route C — validated truncation and the three tails

**Theorem C (error assembly).** *Suppose the exact right-hand side of the explicit formula
equals the computed partial sum plus three tails,
$\mathrm{rhsTrue}=\mathrm{rhsComputed}+(Z_{\text{tail}}+P_{\text{tail}}+A_{\text{tail}})$,
and the exact left-hand side equals $\mathrm{rhsTrue}$. Then*

$$|\mathrm{lhs}-\mathrm{rhsComputed}|\le|Z_{\text{tail}}|+|P_{\text{tail}}|+|A_{\text{tail}}| .$$

**PROVED (Lean)**, `Rh45Routes.validated_truncation_bound` (`Rh45/Routes.lean#L106`).

*Proof (as carried by the source).* Substitute and apply the triangle inequality twice.
$\blacksquare$

The content of Route C is therefore entirely in the three bounds. Throughout this subsection
$g$ is even, $\varphi(t)=\int g(u)e^{itu}du$ and $\Phi(s)=\int g(u)e^{(s-1/2)u}du$ as in §2.

**(C1) Prime tail (Chebyshev).** Mathlib proves Chebyshev's bound
$\psi(x)\le(\log 4+4)x$ for $x\ge 0$ (`Chebyshev.psi_le_const_mul_self`), restated in the
development as `Rh45Routes.prime_tail_input` (`Rh45/Routes.lean#L123`).
**PROVED (Lean) / MATHLIB.** Let $G(y)=|g(y)|+|g(-y)|$ and $h(y)=e^{-y/2}G(y)$, decaying.
Partial summation against $\psi(x)=\sum_{n\le x}\Lambda(n)$ gives, for every $N$,

$$\Bigl|\sum_{n>N}\frac{\Lambda(n)}{\sqrt n}\bigl[g(\log n)+g(-\log n)\bigr]\Bigr|
\le(\log 4+4)\int_{\log N}^{\infty}\Bigl(1+\frac{|h'(y)|}{h(y)}\Bigr)e^{y/2}G(y)\,dy ,$$

i.e. the tail is controlled by an explicit constant times an integral of the kernel's own
decay. For the Gaussian family $G(y)=e^{-y^2/2}$ and $N=2\cdot 10^6$ this is below
$10^{-43}$. **PROVED (modulo the partial-summation step, elementary)** — that status is the
source's.

**(C2) Archimedean tail (Stirling).** For $z=\tfrac14+it/2$ with $|t|\ge 2$, Stirling's
formula with the standard remainder gives
$\operatorname{Re}\psi(z)=\log|z|+O(1/|z|)$; more precisely
$|\operatorname{Re}\psi(z)-\log|z||\le 1/|z|$ for $|z|\ge 1$, and
$\log|z|=\log(t/2)+O(1/t^2)$. Hence

$$|\Psi(t)-\log(t/2\pi)|\le \frac{2}{t}\quad(t\ge 2),\qquad\text{and in particular}\quad
|\Psi(t)|\le\log t+3 .$$

Consequently the archimedean tail beyond $A$ satisfies

$$\Bigl|\frac{1}{2\pi}\int_{|t|>A}\varphi(t)\Psi(t)\,dt\Bigr|
\le\frac{1}{\pi}(\log A+3)\int_A^{\infty}|\varphi(t)|\,dt ,$$

which for the Gaussian family at $A=60$ is below $10^{-770}$. **PROVED (Stirling remainder;
elementary).**

**(C3) Zero tail (Riemann–von Mangoldt).** The Riemann–von Mangoldt formula
$N(T)=\frac{T}{2\pi}\log\frac{T}{2\pi e}+\frac78+S(T)$ with the explicit bound
$|S(T)|\le 0.2\log T+2.5$ ($T\ge e$; Trudgian 2014) makes the counting function explicit:
for $G<H$,

$$N(H)-N(G)\le\frac{1}{2\pi}(H-G)\log\frac{H}{2\pi}+\frac{2}{\pi}\log H+6+o(1).$$

Stieltjes integration against this bound gives, for the zero tail,

$$\Bigl|\sum_{\gamma>G}\Phi(\tfrac12+i\gamma)\Bigr|\le\int_G^{\infty}|\varphi(t)|\,dN(t)
\le\frac{\log(G/2\pi)+1}{2\pi}\int_G^{\infty}|\varphi(t)|\Bigl(1+\frac1t\Bigr)dt
+\frac{2}{\pi}\int_G^{\infty}|\varphi(t)|\log t\,dt ,$$

again an explicit, kernel-dependent constant. **CITED (RvM + Trudgian) + PROVED (Stieltjes
assembly).** The source records that this replaces the audit's density estimate (finding F3)
by a bound resting on a cited explicit $S(T)$ inequality.

**Route C, assembled.** Theorem C plus (C1)–(C3) turns the numerical identity into a
validated statement: the residual is bounded by three explicitly computable quantities, each
proved (prime and archimedean) or reduced to a cited explicit counting inequality (zero
side).

**The validated assembly (VALIDATED).** `rigorous/route_c_assembly.py` evaluates the
audited identity on the modulated Gaussian $g(u)=e^{-u^2/2}\cos(14u)/\sqrt{2\pi}$,
$\varphi(t)=\tfrac12(e^{-(t-14)^2/2}+e^{-(t+14)^2/2})$, with an explicit three-part budget.
Observed output (`rigorous/route_c_assembly.log`, exit 0):

```
Route C assembly: modulated Gaussian, theta=14, Nprime=2000, Simpson steps=12000
  prime sum  = -0.672452800598  (28s)
  archimedean= 0.318512824929  (quad err 1.6e-08, tail 1.8e-57)
  pole       = 4.69648155895e-43
  LHS (5 zeros + tail) = 0.990965634606
  RHS                  = 0.990965625527
  residual             = -9.0786991e-9
  error budget         = 2.794e-08  (arch 1.6e-08, prime 1.2e-08, zero-tail 1.6e-80)
  VALIDATED: |residual| <= budget   (593s)
```

that is, $\mathrm{RHS}-\mathrm{LHS}=-9.08\cdot 10^{-9}$ against the budget
$2.79\cdot 10^{-8}$. The constituents are: **prime side** — exact $\Lambda(n)$ for
$n\le 2000$ plus the Chebyshev tail
$|\sum_{n>N}\Lambda(n)f(n)|\le C(Nf(N)+\int_N^{\infty}x|f'|)$ with $\psi(x)\le(\log 4+4)x$
(the Lean `prime_tail_input`), tail $1.2\cdot 10^{-8}$; **archimedean side** — composite
Simpson on $[0,30]$ with $|\varphi^{(k)}|\le\mathbb{E}|Z|^k$ (Gaussian moments) and
$|\Psi^{(k)}|\le 2^{-k}k!\sum_j(\tfrac14+j)^{-k-1}$, quadrature error $1.6\cdot 10^{-8}$
after Simpson steps were raised $1500\to 12000$ (the earlier $1500$-step run gave
$6.5\cdot 10^{-5}$), Gaussian tail $1.8\cdot 10^{-57}$; **zero side** — the five certified
zeros with their rigorous brackets, plus the density tail
$\int_{\gamma_5}^{\infty}|\varphi|(\log(t/2\pi)+1)/(2\pi)\,dt=1.6\cdot 10^{-80}$. Since the
Simpson error is $\propto\text{STEPS}^{-4}$, the step increase cut the archimedean bound from
$6.5\cdot 10^{-5}$ to $1.6\cdot 10^{-8}$ and the total from $6.499\cdot 10^{-5}$ to
$2.794\cdot 10^{-8}$. Two real bugs were found and fixed while validating: the von Mangoldt
sieve computed $\log\operatorname{rad}(n)$, the additive (not completely additive) function
agreeing with $\Lambda$ on prime powers (residual $0.15$); and `exp_num` on a *wide negative
interval* returned only its lower endpoint (residual $1.3\cdot 10^{-4}$, harmless for point
intervals, which is why the earlier checks had passed). **VALIDATED.**

**Cost note.** The tail bound carries the factor
$1/|\Gamma(1/2+it)|=\sqrt{\cosh(\pi t)/\pi}\approx e^{\pi t/2}/\sqrt{2\pi}$, so the number
of Euler orders needed grows roughly linearly in $t$; the first zeros ($t\approx 14\dots 50$)
need $K\approx 85\dots 180$ orders. The source notes this is the same $O(t)$ cost identified
in the $\eta$/Euler paper §4.3, now inside a certificate.

### 3.4 The engine and its validation

`rigorous/eta_interval.py` (with the bundled `rigorous/ivmath.py`) is the rigorous
point/box enclosure engine: exact integer-square-root $n^{-1/2}$ (width $10^{-90}$),
range-reduced rigorous $\exp$, high-accuracy $\log n$, `ivmath` phases, and the
Euler-accelerated $\eta$ series with proved geometric tails for
$\eta,\eta',\eta''$ (hence $\zeta,\zeta',\zeta''$), plus rigorous $\theta,\theta'$ by
Stirling with the explicit remainder
$|R_N|\le 2^{N+1}|B_{2N+2}|/((2N+2)(2N+1)|z|^{2N+1})$, complex $\psi,\psi'$ by recurrence to
$|w|\ge 8$ plus Stirling with remainder, and $\xi'/\xi$, $f'=(\log\xi)''$. The proved tails
recorded by the source are

$$|\Delta^k a_0|\le\frac{1}{|\Gamma(s)|}\Bigl[\frac{x_0^{\sigma}}{\sigma}+(1-e^{-x_0})^k\Gamma(\sigma)\Bigr]
\quad(\eta),$$

$$|\Delta^k b_0|\le\frac{1}{|\Gamma(s)|}\Bigl[\frac{5}{\sigma}+\frac{1}{\sigma^2}+\rho^k(5\Gamma(\sigma)+1)\Bigr]
\quad(\eta'),$$

$$|\Delta^k c_0|\le\frac{1}{|\Gamma(s)|}\Bigl[\frac{27}{\sigma}+\frac{10}{\sigma^2}+\frac{2}{\sigma^3}
+\rho^k(27\Gamma(\sigma)+13)\Bigr]\quad(\eta''),\qquad
|\Gamma(\tfrac12+it)|=\sqrt{\frac{\pi}{\cosh\pi t}} .$$

**Engine re-validation (VERIFIED).** `rigorous/check_engine.py` at $K=60$, two independent
runs, both end in `0 fail(s)`: `rigorous/verify_engine.log` and
`rigorous/recheck_engine.log`. The checks are containment (not accuracy) of every enclosure
against `mpmath`, plus the tail bound dominating the true truncation error, plus the winding
diagnostic. Observed widths include: $n^{-1/2}$ enclosures of width $1.00\cdot 10^{-90}$;
$\eta$ enclosure at $(\sigma,t)=(0.5,14.134725141734693)$, $K=60$, width
$6.18\cdot 10^{-9}$ with tail radius $3.07\cdot 10^{-9}$ exceeding the true error; and at
$(\sigma,t)=(0.5,20.0)$ width $6.16\cdot 10^{-5}$ with tail radius $3.08\cdot 10^{-5}$. The
winding diagnostic at $\gamma_1$ records the failure mode that shaped the design: on the
edge $\sigma=0.51$ a box of parameter width $0.02$ near $\gamma_1$ has
`excludes0=False`, $|\text{center}|=7.696\cdot 10^{-2}$ against width $2.63\cdot 10^{-1}$,
so the box contains $0$ — which is why the adopted route is the point-wise $Z$ route and not
the arc/winding route.

**Certified fast mode (PROVED contract + VERIFIED `0 fail(s)`).**
`eta_interval.fast_mode()` is `work = 60`, `EPS = 1e-40`; it moves `WORK`, the rounding slack
`EPS` and mpmath's precision *together* so that the enclosure contract
`EPS ≥ accumulated rounding` holds. The source is explicit that setting `iv.WORK = 60` alone
does **not**: `EPS` keeps its $400$-digit value. `rigorous/check_fast_mode.py` validates the
bookkeeping and the containment (4/4 containment rows, `0 fail(s)`); widths agree between
the slow and fast modes ($6.177\cdot 10^{-9}$ at $(\sigma,t)=(0.5,14.134725141734693)$).

**Singularity routing (VERIFIED).** `rigorous/zeta_singularity.py` validates
`singular_ts`/`box_near_singularity` (rigorous enclosures of $t_k=2\pi k/\ln 2$, with
$t_0=0$ included when the window is positive) and the local Taylor/Cauchy enclosure
`zeta_local_box` (which contains $\zeta,\zeta',\zeta''$ on the tested boxes) and the
`xi_logderiv` fallback; observed output `0 fail(s)`, with the fallback reporting
$Lf\le 24.097979$, $24.378848$, $23.507768$, $25.593883$ on four boxes near $t_1$.

**The von Mangoldt sieve bug (PROVED in Lean; reproduced numerically).**
`Rh45/VonMangoldtSieve.lean` proves `vonMangoldt_six` ($\Lambda 6=0$) and
`vonMangoldt_not_additive` (witness $6=2\cdot 3$) — **PROVED (Lean)**.
`rigorous/von_mangoldt_sieve_check.py` reproduces the audit's numbers
(`rigorous/von_mangoldt_sieve_check.log`): the buggy sieve matches
$\log\operatorname{rad}(n)$ for all $n\le 10000$ (0 mismatches) and disagrees with $\Lambda$
at 8719 of them, first at $[6,10,12,14,15,18,20,21,22,24,26,28]$;
$\sum_{2\le n\le 2000}\Lambda(n)=1994.4516$ versus $\sum\log\operatorname{rad}(n)=11773.2988$
(ratio $5.90303$); and the Route C prime sum shifts from $-0.67245280061731$ (correct
$\Lambda$) to $-0.52060701516694$ ($\log\operatorname{rad}$), a difference of
$0.15184578545037$.

**The admissible kernel (T6 — FOUND + REFUTED, high-precision numerical, not
interval-certified).** `rigorous/kernel_probe.py` (`rigorous/kernel_probe.log`, 9/9
self-checks, $95.7$ s, `mp.dps = 60`) exhibits the compactly supported even kernel
$g(u)=C(1-u^2/144)^{40}\cos(\gamma_1u)$ on $[-12,12]$, $C=0.60026318172387376824$, with
$|\mathrm{LHS}|=2.0$ and $\mathrm{RHS}-\mathrm{LHS}=-7.2363\cdot 10^{-54}$ at $K=100$ zero
terms, and a zero-tail bound $4.95487\cdot 10^{-77}$ at $G=\gamma_{100}=236.52423$ — many
orders of magnitude below $1/\log G=0.182947$. Hence the *literal* negative claim ("an
$O(1)$ left side forces a zero-side tail $\ge c/\log G$") is **FALSE**; the correct
structural statement is Paley–Wiener: compact support forbids exponential decay of
$\varphi$, so $g\in C^m$ gives $\varphi(t)=O(t^{-(m+1)})$ and a tail
$O((\log G)G^{-m})$, needing $m\ge 1$ (the $m=0$ jump case, e.g. the Cauchy kernel, is the
divergent boundary case). **FOUND + REFUTED** (high-precision numerical, not
interval-certified). The same log records the $\Lambda$ guard: the probe checks its sieve
against an independent trial-division $\Lambda$ (0 mismatches for $n\le 3000$) and against
$\log\operatorname{rad}(n)$ (2533 mismatches); using $\log\operatorname{rad}$ would turn the
Gaussian residual into a fake $-0.0858$, whereas with correct $\Lambda$ it is
$1.56\cdot 10^{-44}$.

**The archimedean term (T7) — PROVED (Lean, 0 `sorry`/`axiom`), with 2 named hypotheses.**
`Rh45/Archimedean.lean` proves continuity/measurability of $\Psi(t)=-\log\pi+\operatorname{Re}\psi(\tfrac14+it/2)$,
the digamma recurrence and reflection formula on the line, the chain rule
$\Psi^{(k)}(t)=(i/2)^k\psi^{(k)}(\tfrac14+it/2)$ yielding the $2^{-k}$ budget, the Leibniz
product bound $|(\varphi\Psi)^{(4)}|\le\sum_k\binom{4}{k}M_kP_{4-k}$, and the composite-Simpson
assembly $(b-a)h^4/180\cdot\sum_k\binom{4}{k}M_kP_{4-k}$. Two inputs are named hypotheses
because Mathlib lacks them: the digamma (Hurwitz) series estimate `psiSeriesBound` and the
single-panel Simpson error `SimpsonPanelEstimate`. **Finding:** the paper's $k=0$ digamma
bound is **vacuous** ($\sum_j 1/(\tfrac14+j)$ diverges); the meaningful cases are $k\ge 1$,
and the Lean development proves the recurrence route instead.

**Zeros to 32–33 digits (VERIFIED).** The sources record $\gamma_1,\dots,\gamma_5$ located
from $\zeta$ alone to $32$–$33$ digits (`010/truths.md` §5). This paper did not re-run that
probe; it is listed as not run in §4.

## 4. Verification and evidence

### 4.1 Commands

From this folder (`research/publish/006-explicit-formula-routes-abc`):

```sh
./check.sh --all                    # Lean 4 + Mathlib, the six modules, exits 0

cd rigorous
python3 check_fast_mode.py          # certified fast mode: contract + containment, 0 fail(s)  (<1 min)
python3 certify_unique.py           # Route A: 5/5 Theorem-A certificates
python3 certify_zeros.py            # Route A: 5/5 existence certificates
python3 check_engine.py             # engine containment checks (slow: ~8 min at K=60)
python3 zeta_singularity.py         # the removable-singularity routing, 0 fail(s)
python3 certify_count.py            # Route B: N(3) = 0 (~8 min)
python3 certify_count15d.py         # Route B: N(15) = 1, conditional (cited |zeta'/zeta| <= A log t) (~45 min)
python3 certify_count15_uncond.py   # Route B: N(15) = 1, UNCONDITIONAL (9571 s recorded)
python3 certify_count_par.py 33 40 100 8   # Route B: N(33) = 5, UNCONDITIONAL (9391 s recorded, ~2.6 h)
python3 route_c_assembly.py         # Route C: validated assembly (~10 min; 593 s recorded)
python3 kernel_probe.py             # T6 admissible kernel, 9/9 (96 s recorded)
```

The certificate drivers are long-running; the recorded outputs are the `rigorous/*.log`
files, so re-running is optional. `probe_lf.py` and `scan_i3_boxes.py` honour
`PROBE_WORKERS` / `SCAN_WORKERS`.

### 4.2 What was observed in this packaging run

* `python3 rigorous/check_fast_mode.py` — **run in this packaging pass**, exit 0, `0 fail(s)`,
  output identical to the archived `rigorous/check_fast_mode.log`: bookkeeping `work = 60`,
  `EPS = 1.0e-40`, `EPS >= 10^-work`; containment `True` on all four rows, with widths
  $6.177\cdot 10^{-9}$, $6.155\cdot 10^{-5}$, $6.296\cdot 10^{-9}$, $4.914\cdot 10^{-9}$.
* `python3 rigorous/certify_unique.py` — **run in this packaging pass**, exit 0, `5 / 5`,
  and the five $Z'$ enclosures reproduce the archived values digit for digit
  ($[0.766441,0.819918]$, $[-1.17358,-1.10014]$, $[1.32035,1.42321]$,
  $[-1.34866,-1.25925]$, $[1.33534,1.42899]$). The rerun's own log was not written (the
  script only prints to stdout), so the archived `rigorous/certify_unique.log` is
  untouched.
* `./check.sh --all` (Lean 4 + Mathlib) — **run in this packaging pass**, exit 0, all six
  modules: `[check] OK Rh45/Explicit.lean (64s)`,
  `[check] OK Rh45/Archimedean.lean (54s)`, `[check] OK Rh45/Routes.lean (19s)`,
  `[check] OK Rh45/VonMangoldtSieve.lean (2s)`,
  `[check] OK Rh45/RouteBAnalytic.lean (8s)`, `[check] OK Rh45.lean (6s)`. The toolchain on
  the packaging machine is Lean `v4.35.0-rc2` with the Mathlib checkout at `LEAN_PREFIX/mathlib4` (default `HOME/lean/mathlib4`),
  matching `check.sh`'s expectations. The generated `.olean` files were removed after the
  check.
* **Not run in this packaging pass**, with reasons: `check_engine.py` and
  `zeta_singularity.py` (each on the order of minutes to tens of minutes and their logs are
  archived); `certify_count.py`; `certify_count15d.py`; `certify_count15_uncond.py`
  ($9571$ s); `certify_count_par.py 33 40 100 8` ($9391$ s); `route_c_assembly.py`
  ($593$ s); `kernel_probe.py` ($96$ s); `probe_lf.py`; `scan_i3_boxes.py`; and
  `explicit_formula.py`, which the folder itself retires (its convention is false and its
  run was interrupted; see §7, F1/F6). Instead of re-running them, the archived logs were
  read in full and are quoted in §3 and §7 with their own timings.

### 4.3 Recorded evidential statuses

| claim | status (as the source marks it) | evidence |
|---|---|---|
| Route A logic, both signs | PROVED (Lean) | `Rh45/Routes.lean#L37`, `#L129`, `#L71` |
| Route B Turing reduction + packaged form | PROVED (Lean) | `Rh45/Routes.lean#L95`, `#L162` |
| Route C error assembly, prime tail | PROVED (Lean) | `Rh45/Routes.lean#L106`, `#L123` |
| explicit formula, algebraic layer | PROVED (Lean) | `Rh45/Explicit.lean#L223` |
| von Mangoldt sieve bug | PROVED (Lean) | `Rh45/VonMangoldtSieve.lean#L6`, `#L16` |
| archimedean term T7 | PROVED (Lean, 0 `sorry`/`axiom`) + 2 named hypotheses; $k=0$ bound vacuous | `Rh45/Archimedean.lean` |
| Route B analytic layer T8 | PROVED (Lean, 6/6, axiom-clean) + 2 named hypotheses (rectangle argument principle; $\xi(\bar s)=\overline{\xi(s)}$) | `Rh45/RouteBAnalytic.lean` |
| $\gamma_1,\dots,\gamma_5$ unique, simple, on-line | CERTIFIED 5/5 | `rigorous/certify_unique.log` |
| $N(3)=0$, $N(15)=1$ | CERTIFIED | `rigorous/certify_count.log`, `rigorous/certify_count15d.log` |
| Turing window $\tfrac12<\operatorname{Im}<15$ | CERTIFIED — UNCONDITIONAL | `rigorous/certify_count15_uncond.log` + `all_zeros_are_certified` |
| Turing window $\tfrac12<\operatorname{Im}<33$ | CERTIFIED — UNCONDITIONAL | `rigorous/certify_count33_par.log` + `all_zeros_are_certified` |
| Route C assembly | VALIDATED | `rigorous/route_c_assembly.log` |
| engine re-validation | VERIFIED (`0 fail(s)` twice) | `rigorous/verify_engine.log`, `rigorous/recheck_engine.log` |
| certified fast mode | PROVED (contract) + VERIFIED (`0 fail(s)`) | `rigorous/check_fast_mode.log` |
| admissible kernel T6 | FOUND + REFUTED (high-precision numerical, not interval-certified) | `rigorous/KERNEL_FINDINGS.md`, `rigorous/kernel_probe.log` |
| corrected Weil form | PROVED (paper) + VERIFIED to $\ge 20$ digits on four kernels | `ROUND-TRUTHS.md` §1 |
| counting formula $N(T)=\theta(T)/\pi+1+S(T)$ | PROVED (paper) + VERIFIED to $10^{-20}$ | `ROUND-TRUTHS.md` §4 |
| zeros to 32–33 digits | VERIFIED | `ROUND-TRUTHS.md` §5 |
| auditor criteria `C4.1`, `C1e` | both RETIRED by disposition; `C1e` restated as the convergent companion `C1f`; adjudication *19/21 checks pass; 2 retired; failures: none* | `verify/DISPOSITIONS.md`, `verify/independent_check.log` |

`explicit_formula.py` is retained in the folder for the record only; its convention is
**false** and it is superseded by `rigorous/route_c_assembly.py` (README, "Contents"). This
is one of the corrections the folder keeps visible (§7, F1).

## 5. Boundaries: what the three routes still need

The sources name the residual obligations, and they are not hidden by the
statuses above.

* **Route A is complete only for five zeros.** The certified set is
  $\{\gamma_1,\dots,\gamma_5\}$; nothing here certifies the sixth or any later zero. The
  brackets are relative to numerically known ordinates, and the certified count for each
  window is compared against a finite certified set.
* **Route B closes two finite windows only** ($\tfrac12<\operatorname{Im}<15$ and
  $\tfrac12<\operatorname{Im}<33$), both unconditional. The counting identity
  $N(T)=\operatorname{Im}(I_3)/\pi$ is itself NUMERICAL; its analytic layer is Lean-proved
  only conditionally on the rectangle argument principle, which Mathlib lacks and which the
  folder did not build. Beyond $T=33$ nothing is certified.
* **Route C is VALIDATED on one kernel** (the modulated Gaussian) with the zero side resting
  on the five certified brackets plus a density tail; the zero-side tail is CITED (RvM +
  Trudgian), not proved from scratch. The source's own wording is that the zero tail "rests
  on a cited explicit $S(T)$ inequality".
* **Lean scope.** Mathlib has no explicit formula, no Riemann–von Mangoldt identity, no
  argument principle/winding number, and no `riemannXi`; the audited identity itself is
  therefore PROVED in the paper sense, not machine-checked end to end. The Lean layer leaves
  four named hypotheses (digamma series estimate; single-panel Simpson error; rectangle
  argument principle; $\xi(\bar s)=\overline{\xi(s)}$) and does not formalise the numerical
  enclosures.
* **The `k=0` digamma bound is vacuous**; this is recorded as a finding, not repaired.

## 6. The audit of this work, and the defects it found

This section folds in `audit.html` (a paper about the audit of this work), keeping its
finding labels `F1–F7` and its exact locators. The audit's subject was the original `rh45`
submission against §6 of the programme's $\eta$/Euler paper; its verdict at the time was
*strong numerics, no certified zero* — Route A not met, Route B not met, Route C partial —
followed by the post-audit response that the three routes were then proved and the engine
implemented.

**§6 standard audited against** (`audit.html` §1): Route A = interval-arithmetic sign change
of $Z$ plus a root-isolation argument; Route B = Turing's method: a rigorous count $N(T)$
plus a matching number of sign changes, excluding missed and off-line zeros; Route C =
explicit formula with validated kernels and rigorous truncation bounds for the zero, prime
and archimedean terms. The audit's test is whether the inputs are *enclosed* and whether the
*exclusion* is performed.

**What `rh45` had, per the audit** (`audit.html` §2): the corrected Weil form
(residuals $1.6\cdot 10^{-44}$ for $\sigma=1$, $9.6\cdot 10^{-46}$ for the modulated
Gaussian, $-1.1\cdot 10^{-63}$ for $\sigma=1/4$; falsification $0.5366$ / $1.5788$ for the
two readings); zeros located without `mp.zetazero` to $32.5$–$33.6$ digits; the
argument-principle count and $S(T)$ matching at $T=20,50,100$ with
$N=\theta/\pi+1+S$ to $1\cdot 10^{-20}$; and a $476$-line Lean algebraic layer with no
`sorry`.

**F1 — the main script's convention `(E)` is false.** `explicit_formula.py`'s docstring and
its S6 summary adopt
$(E)\ \sum_\rho F(\rho)=F(1)+F(0)-P/(2\pi)$ with $F(s)=\int g\,e^{-su}du$, while the ledger,
the README and the auditor adopt the Weil form. The audit evaluated both on four kernels
(`audit.html` §6 F1 and §7.1): modulated Gaussian ($\mathrm{LHS}\approx 1$) — Weil
$+9.63\cdot 10^{-46}$; `(E)` $-1.037$; naive $-0.468$. Gaussian $\sigma=1$
($\mathrm{LHS}\approx 8.3\cdot 10^{-44}$) — Weil $+1.57\cdot 10^{-44}$;
`(E)` $+2.278$; naive $+1.379$. Gaussian $\sigma=1/4$ ($\mathrm{LHS}\approx 3.9\cdot 10^{-3}$)
— Weil $-2.27\cdot 10^{-61}$; `(E)` $+2.023$; naive $+1.995$. Compact $g=(1-u^2)^2$, 200
zeros — Weil converges; `(E)` $+2.18$. **MAIN SCRIPT WRONG.** The audit notes the error is
confined to the main script, since the public ledger takes the auditor's correct form, and
that S1.3's check $|\text{residual}|<10^{-3}$ would fail if that script were run to
completion.

**F2 — `C1a` proves nothing (absolute versus relative tolerance).**
$\mathrm{LHS}=8.2619765948608225685562103609704482\cdot 10^{-44}$,
$|\mathrm{RHS}-\mathrm{LHS}|=1.5647708\cdot 10^{-44}$, so the relative error is $0.189$
(19 %); the threshold $10^{-20}$ is absolute, so a 19 % error "passes". The prime-tail
majorant $2.279643\cdot 10^{-43}$ exceeds the signal. `C1a` should be reported as a
trivially satisfied identity, not as "$\ge 20$ digits"; `C1b` and `C1c` are the meaningful
checks.

**F3 — density estimates presented as bounds.** `zero_tail_bound` and `prime_tail_bound`
integrate the mean density ($dN\approx\frac{1}{2\pi}\log(t/2\pi)dt$; $\psi(x)\approx x$ with
a stated $2y$ majorant). They are excellent diagnostics and generous when the kernel decays
super-exponentially, but they are not derived from explicit inequalities
($\psi(x)\le(\log 4)x$; $N(T+h)-N(T)=(h/\pi)\log T+O(\log T)$; $|S(T)|\le c\log T$). For the
Cauchy companion the honest label is "~2 digits", not "verified". (Route C §3.3 above is the
response: the prime side is now the Lean-proved Chebyshev input, the archimedean side is
proved with explicit constants, and the zero side is reduced to a cited explicit $S(T)$
inequality.)

**F4 — `mp.zetazero` inside the verification chains.** The zero side of C1 (all four
kernels) is $2\sum_{k\le 100}\varphi(\gamma_k)$ from `mp.zetazero`; C3 validates its count
against `mp.zetazero`; the main script's S1.3 zero side also uses `mp.zetazero`. Route C
wants the zero side validated independently (Route A outputs, or a rigorous density bound).
The C2 route (own $Z$) exists but is not what feeds C1. (In the delivered work the zero side
of the validated assembly uses the five certified brackets.)

**F5 — stale ledger line (corrected by the audit).** `truths.md` line 9 said "17/21 (the 4
failures …)". The re-run gives **19/21** with **no failures** and two **RETIRED** criteria
(`C4.1`, an over-strong criterion of the task prompt; `C1e`, unsatisfiable as literally
stated and restated as `C1f` — `verify/DISPOSITIONS.md`), matching the programme README's
correction X4. The audit updated the round file to **19/21** and marked the historical §3
table as such. This paper's §4.3 records the disposition (`C4.1` and `C1e` retired; `C1e`
restated as the convergent companion `C1f`; *19/21 checks pass; 2 retired; failures: none*).
`ROUND-TRUTHS.md` also names the stale line and the X4 correction, and states that the
auditor's own scoring is deliberately left as the historical record.

**F6 — the main script has no log; its run was interrupted.** The round ledger states the
numerics rest on the auditor because `explicit_formula.py`'s run was interrupted.
Consequently the S1.3 "verification" of `(E)` was never produced. Re-running it would expose
F1; the audit instead evaluated the formula directly (the F1 table). This paper did not run
it either (§4.2).

**F7 — the Lean scope was algebraic only.** At audit time `Rh45/Explicit.lean` (476 lines,
no `sorry`, no extra axiom) proved kernel evenness and positivity, the $s\leftrightarrow1-s$
symmetry about $\tfrac12$, the pole pair and its collapse, monotonicity and non-negativity of
the finite zero sum, the prime-side split and evenness, the finite-in-compact statement for
`riemannZetaZeros`, `vonMangoldtMain` and the exact constant $7/8$ rewrite, and
$\int_0^\infty e^{-u/2}\cos(tu)du=2/(1+4t^2)$ with
$\int(\pi/2)e^{-|u|/2}\cos(tu)du=(\pi/2)\,\text{cauchyKernel}$. It contained *no* explicit
formula, *no* Riemann–von Mangoldt identity, *no* analytic continuation argument and *no*
zero; Mathlib itself has none of these (grep for `RiemannVonMangoldt`/`explicitFormula`
returns empty; it has `riemannZeta_one_sub`, `logDeriv_riemannZeta_one_sub`, the Euler
product, `isDiscrete_riemannZetaZeros` and `IsCompact.inter_riemannZetaZeros_finite`). The
delivered folder answers this by adding `Rh45/Routes.lean`, `Rh45/Archimedean.lean` and
`Rh45/RouteBAnalytic.lean` — but the boundary recorded in F7 still stands for the explicit
formula and the RvM identity themselves.

**The audit's independent reproduction** (`audit.html` §7, produced with Python 3.13 /
mpmath 1.3.0 / numpy 2.5.0 / SymPy 1.14.0 plus a local Lean 4 + Mathlib build, nothing
imported from `rh45`): the convention test of §7.1 (F1 table above); own-$Z$ zero values to
25 digits with $|{\rm own}-{\rm reference}|$ between $2.71\cdot 10^{-34}$ and
$3.49\cdot 10^{-33}$; the counting identity at $T=20,50,100$ with residuals $0$,
$-1.05\cdot 10^{-53}$, $-3.10\cdot 10^{-28}$ (the $T=100$ residual quadrature-limited);
SymPy checks of the elementary layer
($\int_0^\infty e^{-u/2}\cos(tu)du=2/(1+4t^2)$;
$\int_{\mathbb{R}}e^{-|u|/2}e^{itu}du=4/(1+4t^2)$, so
$\int(\pi/2)e^{-|u|/2}\cos(tu)du=(\pi/2)\text{cauchyKernel}$;
$F_{\text{compact}}(s)=\int_{-1}^{1}(1-u^2)^2e^{-su}du$ equal to the script's
$I_0-2I_2+I_4$ closed form with both giving $16/15$ at $s=0$ and
$F(0.7)=1.104511938596\dots$;
$\psi(1/4)=-\gamma-\pi/2-3\ln 2=-4.227453533376265408\dots$; the `vonMangoldtMain` rewrite
with symbolic difference $0$); and the Lean check
`lean/check.sh --all` → `[check] OK Rh45/Explicit.lean (31s)`,
`[check] OK Rh45.lean (5s)`, exit 0, with `#print axioms` on six declarations all giving
`[propext, Classical.choice, Quot.sound]`.

**The audit's roadmap** (`audit.html` §8) is, in its own words: a rigorous scalar engine
(reuse the programme's `ivmath.py` pattern of value + guaranteed error); Route A
certificates (rational $a<b$ with enclosed $Z(a)<0<Z(b)$ and an enclosed $|Z'|\ge m>0$);
Route B as a real Turing test (ball-arithmetic contour integral with an explicit bound on
the argument change on each side, an explicit $|S(T)|\le c\log T$ input, and a sign-change
count matching $N(T)$); Route C with validated tails and relative tolerances, and
`mp.zetazero` removed from the zero side; fix the record (the `(E)` convention, the 19/21
line, run the main script or retire it); and either formalise the explicit formula or state
the Lean boundary. The delivered folder records which of these it did: the engine exists
(`rigorous/eta_interval.py`), Route A certificates exist for five zeros, the two windows are
closed unconditionally, the Route C assembly is validated with relative-error-aware
budgets, and the `(E)` convention is retired in favour of `rigorous/route_c_assembly.py`.

## 7. What is not claimed

* **Nothing about the Riemann Hypothesis.** No statement in this folder bears on RH; only
  the finite windows $\tfrac12<\operatorname{Im}<15$ and $\tfrac12<\operatorname{Im}<33$ and
  five individual zeros are certified.
* **No twin prime result.** This folder proves nothing about the twin prime conjecture or
  about prime pairs; the twin prime conjecture is not proved by this programme's papers.
* The `T=15` conclusion is **no longer conditional**: item T1 is certified with
  `Lf_const = None` ($N(15)\in[0.7981608,1.2018097]$, $9571$ s), so no cited
  $|\zeta'/\zeta|$ bound is used. The former `Lf_const = 30` certificate
  (`certify_count15d`) is retained for comparison and is **conditional** on the cited
  zero-free-region bound with $A=1$.
* The `18`/`s` / `K` configuration requirements are empirical findings, not theorems:
  $K\gtrsim 0.25\,t$ for the Euler-accelerated enclosure, and `steps/unit = 40` for $T=33$.
  A run outside the recorded configuration is UNDECIDED, not false; the failure mode is
  loud, never silently unsound.
* The audit findings `F1–F7` are stated above at the point of their correction; in
  particular `explicit_formula.py` is **wrong as to its convention** and is kept only for the
  record, and the `k=0` digamma bound is **vacuous**.
* Every numerical result lives in a log under `rigorous/` or `verify/`; re-running a script
  reproduces the certificate, but runtimes vary with machine speed. The logs embed the
  source-round paths (`rounds/rh45/…`) in their final lines; the scripts themselves use only
  paths relative to their own directory.

## 8. Value and significance

The folder's value is that it converts an audit's list of *what a certified zero would
require* into an instrument with explicit statuses. It is worth recording for four reasons.
It fixes the explicit formula's normalisation and keeps the wrong convention visible (F1),
so the error is not re-proposed. It reduces a zero certificate to three interval enclosures
and machine-checks that reduction (Route A, Lean), so a numerical bracket plus a one-signed
derivative enclosure is enough — and it then produces such certificates for
$\gamma_1,\dots,\gamma_5$. It makes the Turing reduction and the truncation assembly
machine-checked (Routes B and C) and closes two finite windows **unconditionally** by
removing the last cited input ($Lf_const = None$), so the statement "every zero with
$\tfrac12<\operatorname{Im}<15$ (and with $\tfrac12<\operatorname{Im}<33$) is simple and on
the critical line" rests on enclosures rather than on a cited zero-free-region bound. And it
records the engine obstructions and their fixes — the removable singularity
$\zeta=\eta/(1-2^{1-s})$ at $t_k=2\pi k/\ln 2$, the tight curvature enclosure
($\sum Lf$: $74776\to2282.1$), the certified fast mode's coupled contract, the von Mangoldt
sieve bug, and the vacuous $k=0$ digamma bound — so that they are not reintroduced. The T6
finding (an admissible compactly supported kernel with an $O(1)$ left side, refuting the
literal tail lower bound) additionally corrects a structural claim of the earlier round.

## 9. Uncertainties and open items

1. **The pole-pair intermediate expression.** `ROUND-TRUTHS.md` §1 and
   `ROUND-HANDOFF.md` §1 write $\Phi(1)+\Phi(0)=2\varphi(i/2)$ for even $g$; the Lean
   development records the same collapse in its own normalisation as
   `polePair F = 2 * F (1/2 + 1/2)`, i.e. $2\Phi(1)$ (`Rh45/Explicit.lean#L223`). The
   ledger states both defining relations, $\Phi(s)=\varphi((s-1/2)/i)$ and
   $\Phi(s)=\int_{\mathbb{R}}g(u)e^{(s-1/2)u}du$; a direct evaluation of the two pole terms
   from the integral definition gives $\Phi(1)+\Phi(0)=2\int_{\mathbb{R}}g(u)e^{-u/2}du$,
   which is what this paper reports and what the Route C script implements numerically. The
   intermediate expression is not used in any computation quoted here.
2. **A cosmetic defect in a log.** `rigorous/certify_unique.py` prints the literal string
   `> 0` after every $Z'$ enclosure, including the two negative ones ($\gamma_2$:
   $[-1.17358,-1.10014]$; $\gamma_4$: $[-1.34866,-1.25925]$). The mathematics is unaffected
   (the negative enclosures are used through `exists_unique_root_of_sign_change_neg`), but
   the printed annotation is wrong for those rows.
3. **A sibling-folder count discrepancy (not this folder's).** No source in this folder
   states a theorem count for `Rh45/Explicit.lean` beyond its 476 lines. In the sibling
   folder 007, `ROUND-NOTES.md` states 38 theorems for `Rh46/Chowla.lean` while its README
   states 37 (a direct count of `theorem` declarations in the file gives 37). That
   discrepancy is flagged here only because the manuscript for 007 had to choose a figure.
4. **The `Z`-route seeding.** The certificate scripts seed each bracket from a numerically
   known ordinate (`mp.im(mp.zetazero(k))`), then enclose $Z$ at rational endpoints. The
   logical step (Theorem A) needs only the enclosures; the *choice* of bracket is numerical.
5. **Files inspected only in part.** `rigorous/eta_interval.py` (1163 lines) and
   `rigorous/ivmath.py` (400 lines) were read at their interfaces and header contracts, not
   line by line; their correctness is delegated to `check_engine.py`, `check_fast_mode.py`
   and `zeta_singularity.py`, whose logs are quoted.
6. **The twin-prime framing.** The brief for this manuscript series says the programme's
   papers state at the top of the abstract that they do not prove the twin prime conjecture.
   The sources in this folder (README, `TRUTHS.md`, round notes) do not make any
   twin-prime claim; the sentence in the abstract is carried for that programme-level
   requirement, not from a folder source.

## Sources

All paths are relative to this folder. SHA-256 hashes are given for the sources quoted or
tabulated in this manuscript; all quoted material is local to this folder (**local-only**).

| source | role here | SHA-256 |
|---|---|---|
| `README.md` (publish/006) | item description, contents, headline table, running the checks | `44acd2ab8ba4b4b0d800f0353502590b5cf04264172d8de9ebe1f5aa2b69b0e2` |
| `TRUTHS.md` | the item ledger (research/truths.md §6), all statuses in §3.1–§3.4 | `6c7ad8ec92946d8749927e329ccda8f7db44b0a16cce91abc2344af8e6259c8a` |
| `ROUND-README.md` | Routes A/B/C statement, `Z'` table, configuration facts | `6998b91027e6a69de7600e4c6acfcfa3332732c69ea600798bf0b978e10cdc72` |
| `ROUND-HANDOFF.md` | handoff, Weil form, caveats, provenance | — |
| `ROUND-TRUTHS.md` | round ledger; §1 corrected Weil form; §4 counting formula; §5 zeros to 32–33 digits | — |
| `notes/routes-a-b-c-status.md` | per-route status, engine ingredient table, open items | — |
| `notes/rh45-HANDOFF.md` | `rh45` handoff | — |
| `index.html` | the round paper: Theorems A/B/C, Corollary A′, Proposition D, §5 engine, §5.1–5.3 certificates, status table | `aba25d02ca132e39a3720c5c9eaf253708ecc814c2b5f2bd92844b1bbdef58be` |
| `audit.html` | the audit folded in as §6: §1 standard, §2 claims/evidence, §3–5 route verdicts, §6 findings F1–F7, §7 independent reproduction, §8 roadmap, §9 status table | — |
| `Rh45/Routes.lean` | Theorems A, B, C; `#L37`, `#L71`, `#L95`, `#L106`, `#L123`, `#L129`, `#L162` | `d5a75b6b356060ff42769490455accf8fe86b2e5ca9da5244276fa022aace1f6` |
| `Rh45/Explicit.lean` | algebraic layer; `polePair_eq` `#L223` | `966beeed161c6b7ec28ca7c5bb6acabf928e9718179c48576da68bebc7c92a59` |
| `Rh45/Archimedean.lean` | T7 archimedean term (499 lines) | `bfc49e07a8ef923ce8997fab1f34aca5a911b42ac1d2cc3bfb2b4080aea4c4cc` |
| `Rh45/RouteBAnalytic.lean` | T8 analytic layer of Route B (264 lines) | `52b34c0a07e37b2e7dedf69822db23187aada0c8e4df653491af6cb6cca3f597` |
| `Rh45/VonMangoldtSieve.lean` | `vonMangoldt_six` `#L6`, `vonMangoldt_not_additive` `#L16` | `9ff92f41fad4e2c0f4f0a7717df3a5964954383613c16abb9261a33fe9aa6e8d` |
| `Rh45.lean`, `check.sh`, `LEAN-README.md` | root module, build script, Lean inventory and named hypotheses | — |
| `rigorous/eta_interval.py` | the enclosure engine (1163 lines) | `9d744ea66a935690649ecfe91280a8f86726854bac5f7675ed441cfa0a0bae97` |
| `rigorous/ivmath.py` | bundled rigorous real arithmetic (400 lines) | `0018e9e3da282d24ecbf28c484b0ac416d742114409edffa613c988913883572` |
| `rigorous/certify_unique.log` | Route A 5/5 certificates, `exit=0` | `2c12dfff06a3b76a39de618e8f708c1435f8c65d6ec5beea2393bcca6cb6656e` |
| `rigorous/certify_zeros.log` | Route A 5/5 existence certificates | `09b685f9e826805af2c207528cf0a9f0d40219e3e46f6ae42a229166f0aecf0a` |
| `rigorous/certify_count.log` | $N(3)=0$ | `77f35727ba4e8921cfa74eee4af877f9c0b0ccf50e9840d04880c86510b21140` |
| `rigorous/certify_count15d.log` | $N(15)=1$ conditional (`Lf_const = 30`, $2870$ s) | `24cb834288503504bcc82ceb7f7dfbe31fd75e94eca1c1a74761e58735576e83` |
| `rigorous/certify_count15_uncond.log` | $N(15)=1$ UNCONDITIONAL ($9571$ s) | `8c924803ee9bfa91a96db990005d3a69ca878a729959b43b9e2977597a5ea6ae` |
| `rigorous/certify_count33_par.log` | $N(33)=5$ UNCONDITIONAL ($9391$ s) | `c16acae317032d16e67d9a9f5182151f1fc14ba78e9a02e8169b0483f1722b51` |
| `rigorous/certify_count15_uncond_r2.log` | `steps/unit = 12` UNDECIDED run | — |
| `rigorous/certify_count33_par_s32.log` | `steps/unit = 32` UNDECIDED by 3.8 % run | — |
| `rigorous/route_c_assembly.log` | Route C validated assembly | `f2c6d309aad922c2915abb4ac5e9289fdb2741fa90f7b6ef761b842cfd68dd2a` |
| `rigorous/verify_engine.log`, `recheck_engine.log` | engine re-validation, `0 fail(s)` twice | — |
| `rigorous/check_fast_mode.log` | certified fast mode, `0 fail(s)` | — |
| `rigorous/zeta_singularity.log` | removable-singularity routing, `0 fail(s)` | — |
| `rigorous/kernel_probe.log`, `rigorous/KERNEL_FINDINGS.md` | T6 finding (9/9, $95.7$ s) | — |
| `rigorous/probe_lf_T15_s24.log`, `probe_lf_T33_sample.log`, `probe_lf_T33_s32_K100.log` | curvature-budget probes ($\sum Lf$ values) | — |
| `rigorous/scan_i3_boxes_T15_s24.log`, `scan_i3_boxes_T33_K100.log` | box scans (372 boxes 0 failing; 536 boxes 0 failing) | — |
| `rigorous/von_mangoldt_sieve_check.log` | sieve-bug reproduction | — |
| `rigorous/T1_BLOCKER.md` | the T1 history (name kept though the item is done) | — |
| `rigorous/certify_count15_uncond.py`, `certify_count_par.py`, `route_c_assembly.py`, `certify_unique.py`, `certify_zeros.py`, `check_engine.py`, `check_fast_mode.py`, `zeta_singularity.py`, `kernel_probe.py`, `probe_lf.py`, `scan_i3_boxes.py`, `von_mangoldt_sieve_check.py`, `certify_count.py`, `certify_count15d.py` | the drivers quoted in §3 and §4 | — |
| `verify/DISPOSITIONS.md` | `C4.1` and `C1e` dispositions | `379fb04bc5df73db669e06427559dbe417f0c0d36ff62be0c5fb933125e641a0` |
| `verify/independent_check.log`, `verify/independent_check.py`, `verify/lean_check.log` | the auditor's 19/21 route, the Lean check log | `ead17885d7216ef34555186f93860965f15eeec2aad24d67276353f26e65ceb1` (log) |
| `explicit_formula.py` | retained for the record; its convention is **false** (F1) | — |

External inputs cited by the sources (not in this folder): Mathlib (Leibniz rule, intermediate
value theorem `intermediate_value_Icc`, `strictMonoOn_of_deriv_pos`, Chebyshev
`Chebyshev.psi_le_const_mul_self`, `riemannZeta_one_sub`,
`completedRiemannZeta_one_sub`); A. M. Turing, *Some calculations of the Riemann
zeta-function*, Proc. LMS **3** (1953) 99–117; T. Trudgian, *An improved upper bound for the
argument of the Riemann zeta-function*, Math. Comp. **83** (2014) 1895–1903
($|S(T)|\le 0.2\log T+2.5$); E. C. Titchmarsh & D. R. Heath-Brown, *The Theory of the
Riemann Zeta-Function* (RvM, explicit formula, Stirling remainder). Lean toolchain recorded
by the sources: Lean 4 `v4.35.0-rc2` with the Mathlib checkout at `LEAN_PREFIX/mathlib4` (default `HOME/lean/mathlib4`); Python 3.13.13
with mpmath 1.3.0 (and numpy 2.5.0 for the audit's reproduction).
