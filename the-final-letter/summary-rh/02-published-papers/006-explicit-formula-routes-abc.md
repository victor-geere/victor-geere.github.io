# 006 — The Explicit Formula and Routes A/B/C

| Field | Value |
|---|---|
| Source | [`research/publish/006-explicit-formula-routes-abc/manuscript.md`](../../rh/research/publish/006-explicit-formula-routes-abc/manuscript.md) |
| Status | Published; truths ledger §6. |
| Harvested statements | 6 |

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

## Harvested theorem-like statements

### Theorem A (Route A logic).

*Let $a<b$, let $f:\mathbb{R}\to\mathbb{R}$ be continuous on
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

### Corollary A′ (enclosure form).

*Suppose instead we are given enclosures: $f(a)\in[l_a,h_a]$
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

### Proposition D (symmetric winding forces the line).

*Let $R\subset\{0<\operatorname{Re}s<1\}$
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

### Theorem B (Turing reduction).

*Fix a height $T>0$. Let $\mathrm{Cert}$ be the finite set
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

### Theorem C (error assembly).

*Suppose the exact right-hand side of the explicit formula
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

### Route C, assembled.

Theorem C plus (C1)–(C3) turns the numerical identity into a
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

## Source

[`manuscript.md`](../../rh/research/publish/006-explicit-formula-routes-abc/manuscript.md) · [`README.md`](../../rh/research/publish/006-explicit-formula-routes-abc/README.md)
