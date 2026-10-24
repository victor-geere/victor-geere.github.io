# OP-5 and OP-6: The Index Asymptotic $n_{\min}(p)$ and the Reachable Fraction, with Their Corrections

**First edition, packaged from `research/truths.md` §9; prose from `open/OP-05-nmin-asymptotic.md`, `open/OP-06-reachable-fraction.md`, `open/OP-09-other-moduli.md` and `006/handoff.md`. Local-only folder: the `open/lean/Op56` and `006/lean/Op56` developments are byte-identical, and `HANDOFF-006.md` records which copy is canonical; this edition reproduces the files unmodified except that markdown links have been re-pointed into the folder.**

## Abstract

This folder packages the two problems the programme's `open/` directory was created to settle, together with their Lean 4 + Mathlib proofs, the corrections that followed, and the numerical cross-checks. **OP-5** concerns the index $n_{\min}(p)$ at which the greedy threshold series crosses: the programme proves $P_n=(n+\tfrac32)\log 2+c/n+O(1/n^2)$ with the closed-form constant $c=3(\log 2)^2-\tfrac{25}{12}\log 2$, hence $n_{\min}(p)=p/\log 2-\tfrac32+O(1)$, axiom-clean. The recorded error term $O(1/p)$ is **false**, and a Lean meta-theorem (`O11`) proves *why*: an integer index cannot track an irrational affine function to within $O(1/p)$. The recorded exact ceiling law $n_{\min}(p)=\lceil p/\log 2-\tfrac52\rceil$ is also **false**: the first counterexample is a 451-digit $p$, verified at 1150 dps. The recorded "$1/\log q$" reading of other moduli is **false** too; the slope is $1/\log 2$ for every modulus, and $r=0$ is exactly $q$-independent. **OP-6** settles the reachable fraction: $L(p)=p\log p-(1+\log\log 2)p+O(1)$, i.e. $\operatorname{measure}(S_1)/P(p)=p^{-p}e^{(1+\log\log 2)p}(1+o(1))\to0$; its $1/p$ coefficient is a closed-form *function* of the ceiling error, not the constant previously quoted. Nothing here touches the twin prime conjecture, the parity problem, or the Riemann hypothesis.

## 1. Introduction and goal

The programme's twin-prime-parity line reduces one side of the parity question to a *greedy* construction on a decaying alphabet. Two quantitative questions about that construction were registered as open problems and are settled here:

* **OP-5** — the asymptotic of the *completeness threshold index* $n_{\min}(p)$ as $p\to\infty$, where $n_{\min}(p)$ is the first index at which the positive half-tail becomes complete in Brown's sense;
* **OP-6** — the exact order of the *reachable fraction* $\operatorname{measure}(S_1)/P(p)$ of the budget.

The chain is: `rh42`'s census theorem supplies the interval count $2^{n_{\min}-1}$, OP-5 supplies the exponent $n_{\min}(p)$, and OP-6 converts both into the decay law of the fraction. The folder's own register (`notes/07-open-problems.md`) marks both **SETTLED**, having been **OPEN**.

What this item is *not*: no progress is claimed on the twin prime conjecture, on the parity problem, or on the Riemann hypothesis. The finite checks are finite checks. What the item *is*: three axiom-clean Lean theorems (`op5_threshold_asymptotic`, `op5_nmin_asymptotic`, `op6_reachable_fraction`), their supporting development, an unconditional floor-asymptotic meta-theorem, plus the explicit corrections of four over-claims the record had carried — the $O(1/p)$ error term, the exact ceiling law, the constant $1/p$ coefficient, and the $1/\log q$ guess for other moduli. Every correction is kept beside the claim it corrects.

## 2. Setup and definitions

**Alphabet and budgets.** The positive half-series of the programme is
$$a_k=(2k)^{-p},\qquad k=1,2,3,\dots,\qquad P(p)=\sum_{k\ge1}a_k=2^{-p}\zeta(p),\qquad T_n=\sum_{k\ge n}a_k=2^{-p}\zeta(p,n),$$
with the *Hurwitz* tail convention $T_n=2^{-p}\zeta(p,n)$ (the first retained index is $k=n$). Lean uses the equivalent 0-based sequence
$$\operatorname{term}(p,n)=b_n=a_{n+1}=\bigl(2(n+1)\bigr)^{-p},\qquad n=0,1,2,\dots,$$
and the dictionary $n_{\min}^{\text{1-based}}=\operatorname{nmin}p+1$, $T^{\text{1-based}}_{n_{\min}}=\operatorname{tailSum}p\,(\operatorname{nmin}p)$,
$$\operatorname{measure}(S_1)=2^{\operatorname{nmin}p}\cdot\operatorname{tailSum}p\,(\operatorname{nmin}p).$$
The offset between the two conventions is the source of the constants $-\tfrac32$ (1-based, notes) and $-\tfrac52$ (0-based, Lean).

**Brown's criterion and the threshold index.** $\operatorname{IsComplete}(p,N)$ is $b_N\le T_{N+1}=\operatorname{tailSum}p\,(N+1)$; $\operatorname{nmin}p$ is the least $N$ with $\operatorname{IsComplete}(p,N)$ (total by a junk value $0$ for $p<2$; the specifications require $p\ge2$). The normalised boundary form is
$$\Phi_p(n)=\sum_{j\ge1}\Bigl(1+\frac{j}{n}\Bigr)^{-p},$$
and the *thresholds* $P_n$ are defined by $\Phi_{P_n}(n)=1$, i.e. $\operatorname{IsThreshold}(n,p)$ is $\Phi_p(n)=1$. In these terms $\operatorname{IsComplete}(p,N)\iff1\le\Phi_p(N+1)$, so $\operatorname{nmin}p=\min\{N:\Phi_p(N+1)\ge1\}$.

**Reachable set and the OP-6 quantity.** $\operatorname{IsReachable}(p,x)$ means $x$ is a finite sub-sum of $(b_n)$; $S_1=\{x:\operatorname{IsReachable}(p,x)\}$; $\operatorname{reachableMeasure}p=2^{\operatorname{nmin}p}\operatorname{tailSum}p\,(\operatorname{nmin}p)$ and
$$L(p)=-\log\frac{\operatorname{measure}(S_1)}{P(p)},\qquad L_{\text{asym}}(p)=p\log p-(1+\log\log2)p,\qquad \operatorname{nminAsym}(p)=\frac{p}{\log2}-\frac52,$$
$$\operatorname{thresholdAsym}(n)=\Bigl(n+\frac32\Bigr)\log2+\frac{3(\log2)^2-\frac{25}{12}\log2}{n}.$$
Throughout, $p$ ranges over integers $\ge2$, $n$ over positive integers, and all asymptotics are as $p$ or $n\to\infty$. The Lean toolchain is Lean 4 `v4.35.0-rc2` with Mathlib at `$LEAN_PREFIX/mathlib4`; the development has **no `axiom` declaration, no `sorry`, and no compiled decision procedure**, so the probed theorems rest on exactly `[propext, Classical.choice, Quot.sound]`.

## 3. Results

### 3.1 OP-5, the leading coefficient is forced — PROVED (Lean)

**Theorem (`leadingCoeff_forced`).** If $x\in[0,1)$ and $\sum_{j\ge1}x^j=1$ (as a `HasSum`), then $x=1/2$.

Equivalently: the rate $\log2$ of OP-5 is not fitted but forced, because the threshold equation $\sum_{j\ge1}x^j=1$ has the unique root $x=1/2$, i.e. $1/c=\log2$.

### 3.2 OP-5, the threshold asymptotic — PROVED (Lean, axiom-clean)

**Theorem (`op5_threshold_leading`).** If $P_{\mathrm{fun}}(n)$ is a threshold sequence, i.e. $\operatorname{IsThreshold}(n,P_{\mathrm{fun}}(n))$ for all $n$, with $1/2\le P_{\mathrm{fun}}(n)/n\le1$, then
$$P_{\mathrm{fun}}(n)=n\log2+O(1).$$

**Theorem (`op5_threshold_second_order`).** Under the same hypotheses,
$$P_{\mathrm{fun}}(n)=\Bigl(n+\frac32\Bigr)\log2+O(1).$$
The $O(1)$ correction is exactly $\tfrac32\log2$, because $\Phi S(\log2)=\sum_{k\ge1}k^22^{-k}=6$ makes the threshold equation give $u=\log2+\frac{3\log2}{2n}+O(1/n^2)$.

**Theorem (`op5_threshold_asymptotic`).** Under the same hypotheses,
$$P_{\mathrm{fun}}(n)=\operatorname{thresholdAsym}(n)+O\!\left(\frac{1}{(n+1)^2}\right),\qquad \operatorname{thresholdAsym}(n)=\Bigl(n+\frac32\Bigr)\log2+\frac{c}{n},$$
$$c=c_5=3(\log2)^2-\frac{25}{12}\log2=-0.0026975844119484539513\ldots$$
The analytic input is `threshold_third_order_uniform`, a uniform third-order expansion $\Phi_{un}(n)=(e^u-1)^{-1}+\frac{u}{2n}\Phi S(u)+\frac{D(u)}{n^2}+O(n^{-3})$; the proof extracts $u\in[\tfrac12,1]$ and converts $1/n^3$ into the stated rate via $(n+1)^2\le4n^2$.

### 3.3 OP-5, the index asymptotic — CORRECTED, then PROVED (Lean, axiom-clean)

**Theorem (`op5_nmin_asymptotic`).**
$$\bigl(\operatorname{nmin}p-\operatorname{nminAsym}(p)\bigr)_{p}=O(1),\qquad\text{i.e.}\qquad n_{\min}(p)=\frac{p}{\log2}-\frac32+O(1).$$
The explicit constant is $11=8+\tfrac52$, from the landed ceiling alignment $|\operatorname{nmin}p\cdot\log2-p|\le4$ (`log_nmin_close`) together with $\tfrac12\le\log2$.

**Correction (kept visible).** The recorded statement was
$$n_{\min}(p)=\frac{p}{\log2}-\frac32+O(1/p)\qquad\text{(the 0-based form } \operatorname{nmin}p-\operatorname{nminAsym}(p)=O(1/p)\text{),}$$
and it is **false**. $\operatorname{nmin}p$ is an integer, while $p/\log2-\tfrac52$ is irrational-linear in $p$, so an $O(1/p)$ error would say that $p/\log2-\tfrac52$ lies within $C/p$ of an integer for every large $p$; since $\{p/\log2\}$ is equidistributed, that can hold only on a density-zero set. The statement is **false on arithmetical grounds alone** — no input from $\Phi$ or the census law. Measured directly ($\Phi_p(n)=\sum_{j\ge0}(1+(j+1)/n)^{-p}$, $\operatorname{nmin}p$ the least $N$ with $\Phi_p(N+1)\ge1$):

| $p$ | $\operatorname{nmin}p$ | $p/\log2-\tfrac52$ | gap | $p\cdot$gap |
|---|---|---|---|---|
| 1000 | 1441 | 1440.195041 | 0.804959 | 804.96 |
| 2000 | 2883 | 2882.890082 | 0.109918 | 219.84 |
| 5000 | 7211 | 7210.975204 | 0.024796 | 123.98 |
| 10000 | 14425 | 14424.450409 | 0.549591 | 5495.91 |
| 20000 | 28852 | 28851.400818 | 0.599182 | 11983.64 |
| 50000 | 72133 | 72132.252044 | 0.747956 | 37397.78 |

$p\cdot\text{gap}$ grows like $p$: the error term is $O(1)$, and no sharper. (The table is reproduced by `verify-006/op05_nmin_ceiling.py` from `HANDOFF-006.md` §5.2.)

**A retraction, also kept visible.** An earlier internal diagnosis held the theorem *blocked on mathematics absent from the library* (a discrete crossing alignment $|\Phi_p(\operatorname{nmin})-1|=O(1/n^2)$). That diagnosis was **wrong**: the sharp alignment is the *ceiling* statement $|\operatorname{nmin}p\cdot\log2-p|\le4$, already in the development, and once the theorem's statement was corrected to $O(1)$ the proof followed from landed lemmas.

### 3.4 The floor-asymptotic meta-theorem `O11` — PROVED (Lean, axiom-clean, unconditional)

**Theorem (`no_index_asymptotic_error`).** If $\alpha$ is irrational, $\beta\in\mathbb R$, $n:\mathbb N\to\mathbb Z$, $C\in\mathbb R$ and $P\in\mathbb N$, and if
$$\bigl|n(p)-(\alpha p+\beta)\bigr|\le\frac{C}{p}\qquad\text{for every }p\ge P,$$
then `False`.

*Proof (as carried).* Comparing the hypothesis at $p$ and $p+1$ gives
$$\bigl|(n(p+1)-n(p))-\alpha\bigr|\le\frac{C}{p+1}+\frac{C}{p}\le\frac{2|C|}{p}.$$
The left side is $|z-\alpha|$ for the **integer** $z=n(p+1)-n(p)$; since the right side is $o(1)$, those integers are eventually constant, equal to some $z$, and squeezing the same bound against arbitrarily large $p$ forces $\alpha=z$, so $\alpha$ is rational — contradiction. **No density or equidistribution input is used**, and $C$ need not be nonnegative (the proof runs with $|C|$).

Formalised alongside: `no_index_asymptotic_error_nat` (the $\mathbb N$-valued form), `irrational_not_eventually_error_inv` (the packaged existential), `log_two_inv_no_index_asymptotic` (the instance $\alpha=1/\log2$, arbitrary $\beta$), and `nmin_error_not_bigO_inv` (the OP-5 instance $\alpha=1/\log2$, $\beta=-\tfrac52$ against $\operatorname{nmin}$ and $\operatorname{nminAsym}$).

**Hypothesis kept explicit.** `Irrational (Real.log 2)` is Lindemann–Weierstrass ($\exp(\log2)=2$ is algebraic and $\ne0,1$); Mathlib `v4.35.0-rc2` formalises only the *analytic part* of Lindemann–Weierstrass, not the transcendence conclusion, so the $\log2$ instances carry it as an explicit hypothesis, transported to $1/\log2$ by `Irrational.inv`. **The general meta-theorem is unconditional.**

### 3.5 The exact ceiling law `O3` — REFUTED

The recorded exact law was the following statement, called (CEIL) below:
$$\operatorname{nmin}p=\Bigl\lceil\frac{p}{\log2}-\frac52\Bigr\rceil$$
(equivalently $0<\operatorname{nmin}p-(p/\log2-\tfrac52)<1$). **It is false.** From the third-order expansion with $u=p/n$, the real crossing is
$$n_\ast(p)=\frac{p}{\log2}-\frac32+F(p),\qquad F(p)=-\frac{b}{n_\ast\log2}+O(n_\ast^{-2})>0,\qquad b=3(\log2)^2-\frac{25}{12}\log2\approx-2.6976\cdot10^{-3},$$
so $F\approx2.698\cdot10^{-3}/p$, and with $y=\frac{p}{\log2}-\frac32$,
$$\operatorname{nmin}p=\Bigl\lceil\frac{p}{\log2}-\frac52\Bigr\rceil \iff 1-\{y\}>F(p).$$
The law fails exactly on the (sparse) $p$ for which $1-\{y\}<F(p)$, i.e. for continued-fraction denominators of $2/\log2$ with a large enough partial quotient. **The first counterexample found has 451 decimal digits**, where $\operatorname{nmin}p=\lceil p/\log2-\tfrac52\rceil+1$; it is verified at **1150 dps** by `verify-006/op05_nmin_ceiling_false.py`, and the search also shows a failure density up to $P$ growing like $c\ln P$.

**The earlier 76-value sweep is correct but incomplete.** `verify-006/op05_nmin_ceiling.py` tests 76 values of $p\in[200,3000)$ at 50-digit precision and finds **0 mismatches**, concluding (CEIL); that is exactly the good set, and the folder keeps both the sweep and its refutation visible. The Lean layer replaces the law by the **reduction** `nmin_eq_of_Phi`: if $\Phi_p(N)<1\le\Phi_p(N+1)$ then $\operatorname{nmin}p=N$; equivalently (`nmin_eq_iff_Phi_bounds`, $1\le N$)
$$\operatorname{nmin}p=N\iff \Phi_p(N)<1\ \wedge\ 1\le\Phi_p(N+1),$$
and `nmin_eq_ceil_of_Phi_bounds` is the (true) conditional form at $N=\lceil p/\log2-\tfrac52\rceil$. Consequently **no sharpening of the windows `Phi_window_low`/`Phi_window_high` can prove (CEIL)**: a window with slack $K/n^2$ in $w=p/n-\log2$ decides the crossing only when $1-\{y\}>K/(n\log2)$, which is exactly the bad case. The strongest **true uniform statement**, still **unproved**, is the disjunction
$$\operatorname{nmin}p\in\Bigl\{\Bigl\lceil\frac{p}{\log2}-\frac52\Bigr\rceil,\ \Bigl\lceil\frac{p}{\log2}-\frac52\Bigr\rceil+1\Bigr\},$$
equivalently $0<n_\ast(p)-(p/\log2-\tfrac32)<1$ for the real crossing. A sharpened window with slack $\sim|b|/n^2$ would prove that disjunction; the existing $10^{19}/n^2$ slack is the obstruction.

### 3.6 Other moduli, item `O9` — DERIVED + VERIFIED; the recorded guess REFUTED

The TODO said: *"replace $2k$ by $qk+r$; the leading constant becomes $1/\log q$-type data; the method is unchanged."* Define the modulus alphabet
$$\operatorname{term}(p,q,r,n)=\bigl(q(n+1)+r\bigr)^{-p},\qquad n\ge0,\ q\ge2,\ 0\le r<q,$$
i.e. the progression $q+r,2q+r,3q+r,\dots$, with Brown's criterion $b_N\le T_{N+1}$, $b_N=(q(N+1)+r)^{-p}$, $T_N=\sum_{n\ge N}b_n$. Dividing by $b_N$ with $m_0:=q(N+1)+r$,
$$\frac{T_{N+1}}{b_N}=\sum_{j\ge1}\Bigl(1+\frac{qj}{m_0}\Bigr)^{-p}=\sum_{j\ge1}\Bigl(1+\frac{j}{m_0/q}\Bigr)^{-p}=:F_1(m_0/q),$$
so the criterion depends on the modulus data **only through the real number** $m_0/q=N+1+r/q$. With $\theta(p)$ the root $F_1(\theta(p))=1$,
$$\text{criterion}(N;q,r)\iff N+1+\frac rq\ge\theta(p),\qquad \theta(p)=\frac{p}{\log2}+O(1).$$
Two consequences:

1. **$r=0$ is exactly $q$-independent.** Then $m_0/q=N+1$ is an integer and the criterion is literally the OP-5 one: $\operatorname{nmin}(p;q,0)=\operatorname{nmin}(p;2,0)$ for **every** $q$; checked for $q\in\{2,3,4,5,6,7,11\}$ at $p\in\{200,1000,5000\}$.
2. **The slope is $1/\log2$ for every $q,r$:** $\operatorname{nmin}(p;q,r)=\frac{p}{\log2}-1-\frac rq+O(1)$; $q$ enters only through the $r/q$ shift of the constant. Over all 60 tested cases ($q\le11$, $r<\min(q,3)$, $p\le5000$) the spread of $\operatorname{nmin}+1+\frac rq-\frac{p}{\log2}$ is $[-1.4951,-0.5132]$ — bounded and $(q,r)$-uniform.

**The recorded "$1/\log q$" claim is FALSE.** What is *not* claimed: only the leading order and the $r/q$ shift are settled; the $O(1)$ term itself is not a constant (it has the same non-converging ceiling structure as OP-5's $O(1)$ correction, cf. §3.5), and no Lean generalisation is attempted.

### 3.7 The fourth-order expansion `O10` — PROVED (Lean, axiom-clean); the threshold form NOT landed

**Theorem (`Phi_fourth_order`).** There is $C>0$ with, eventually in $n$, for all $u\in[\tfrac12,1]$,
$$\Bigl|\Phi(un,n)-\Bigl[(e^u-1)^{-1}+\frac{u}{2n}\Phi S(u)+\frac{-\frac u3\Phi K_3u+\frac{u^2}{8}\Phi K_4u}{n^2}+\frac{E(u)}{n^3}\Bigr]\Bigr|\le\frac{C}{n^4},$$
$$E(u)=\frac u4\Phi K_4u-\frac{u^2}{6}\Phi K_5u+\frac{u^3}{48}\Phi K_6u,\qquad C=11\cdot10^{12}+2\cdot10^{12}+7 .$$
The chain is `phi_term_sharp4` (the former sole blocker; constant $11$, about $118\times$ margin), `tsum_pow8_exp_neg_half_le`, `tsum_shift_pow_exp_le8` ($m\le8$), `phi_tail_sum_le4`, `phi_finite_part_le4`, `PhiMainS4_eq` and `Phi_fourth_order_aux`. The moments used are $1082$/$9366$ (and $1091670$ for $k^8$), not the earlier $541$/$4683$. **Not landed: the threshold-form fourth order (`SFourth`)**, scoped as new analytic content.

### 3.8 Supporting results — PROVED (Lean)

* **`Φ` asymptotic.** There is $C>0$ with, for $n\ge4$ and $u\in[\tfrac12,1]$, $|\Phi_{un}(n)-(e^u-1)^{-1}|\le C/n$.
* **Existence of the threshold.** `IsComplete p (4p)` for $p\ge2$ (`exists_isComplete`), with the explicit witness $N=4p$; $N=3p$ does **not** work (its chain would need $\tfrac32\le1$).
* **Census.** `census_measure_eq` and `census_ratio`: $\operatorname{reachableMeasure}p=2^{\operatorname{nmin}p}\operatorname{tailSum}p\,(\operatorname{nmin}p)$ and the ratio is $2^{\operatorname{nmin}p}$.
* **Integral test, a negative result.** `tailSum_integral_lower` is proved for the **corrected** hypothesis $N+2\le M$; the as-written $N+1\le M$ form is **false** (witness $p=2$, $N=0$, $M=1$: left side $0.25$ while `tailSum 2 1 = 0.16123…`). The corrected lemma is too lossy to prove completeness (at the threshold its bound is $\approx0.73\,b_N<b_N$) and is used by nothing. The helper `integral_two_mul_rpow`, $\int_{Ioi M}(2x)^{-p}=(2M)^{-p}\frac{M}{p-1}$, is also proved.
* **Reference constants (proved):** $\sum k^22^{-k}=6$, $\sum k^32^{-k}=26$, $\sum k^42^{-k}=150$, $\sum k^2(7/8)^k=840$; $\Phi C\le3368$.
* **Correction kept visible.** The earlier attribution of the gap to "Euler–Maclaurin for the Hurwitz tail at $p\gg n$" was **wrong**: at the threshold $p/n\to\log2$, so $p$ and $n$ are *comparable* ($p/N=1.000,0.833,0.769,0.714,0.699$ at $p=2,5,10,20,100$) and Euler–Maclaurin is both absent from Mathlib and the wrong tool (its series diverges here). The route used is the geometric comparison $G_k\le T_k\le G_k e^{uk^2/(2n)}$ refined to third order.

### 3.9 OP-6, the reachable fraction — PROVED (Lean, axiom-clean)

**Theorem (`op6_reachable_fraction`).**
$$\bigl(L(p)-L_{\text{asym}}(p)\bigr)_p=O(1),\qquad L_{\text{asym}}(p)=p\log p-(1+\log\log2)p,$$
equivalently
$$L(p)=p\log p-(1+\log\log2)p+O(1),\qquad \frac{\operatorname{measure}(S_1)}{P(p)}=p^{-p}e^{(1+\log\log2)p}\bigl(1+o(1)\bigr)\to0 .$$
The `rh42` register asked for a leading constant $c$ in $-\log(\operatorname{measure}/P)\sim c\,p\log p$; **the leading term is confirmed and $c=1$** (not $1/\log2=1.4427$, not $2/\log2=2.8854$), with the exact second coefficient
$$-(1+\log\log2)=-0.6334870794183357\ldots,\qquad \log\log2=-0.3665129205816643\ldots$$
The linear term is of the *same order* as the leading term, so the ratio $L/(p\log p)\to1$ only slowly: the exact census gives $L/(p\log p)=0.95414668$ at $p=10^6$. The proof composes the census law with OP-5: `L_decomp` gives $L(p)=-\operatorname{nmin}p\log2-\log(\operatorname{tailSum}p\,(\operatorname{nmin}p))+\log(\operatorname{budget}p)$, and four landed estimates (with constants $\log3$, $\log9$, $4$, $300$, summing to $\le1000$) bound the residual. Here `LAsym`'s **linear coefficient is given**, not re-derived from first principles; it enters through `log_ratio_close` and the OP-5 second-order layer.

### 3.10 OP-6, the $1/p$ coefficient `O4` — DERIVED + VERIFIED; the recorded constant REFUTED

**The recorded claim was a constant:**
$$L(p)=p\log p-(1+\log\log2)p-\frac{0.540509640658\ldots}{p}+O(1/p^2).$$
**That is false.** Write the true index as $n=p/\log2-\tfrac32+e$ with the ceiling error
$$e=e(p)=\Bigl\lceil\frac{p}{\log2}-\frac52\Bigr\rceil-\Bigl(\frac{p}{\log2}-\frac52\Bigr)\in[0,1).$$
The $\log2\cdot e$ terms cancel exactly and the coefficient is the **function**
$$c(e)=-\frac{(\log2)^2}{2}\Bigl(e^2-e+\frac94\Bigr),\qquad\text{ranging over}\quad c\in\bigl[-(\log2)^2,-\tfrac98(\log2)^2\bigr]=[-0.480453013918201,\,-0.540509640657977],$$
so that
$$L(p)=p\log p-(1+\log\log2)p+\frac{c(e(p))}{p}+O(1/p^2).$$
The numeral $-0.540509640658\ldots$ is exactly $-\tfrac98(\log2)^2$, the $e=0$ — i.e. **smooth-index** — value; it is not the coefficient of the true integer index. The `O(1/p^2)` remainder cannot absorb an oscillating $O(1/p)$ term, so the exact statement is $L(p)=p\log p-(1+\log\log2)p+O(1/p)$ with the coefficient above. **The main OP-6 theorem is unaffected**, and the declaration `c6 := -0.540509640658` survives in `Asymptotic.lean` only as the historical smooth-index numeral, used by no theorem.

*A sign detail kept visible:* the OP-6 note's §1 writes the term as $-c(e(p))/p$ while its own §2.4 and the verifying script use $+c(e(p))/p$ with $c(e)<0$; the measured table below ($p\cdot R(p)\approx-0.48$) agrees with the $+c(e(p))/p$ reading, which is the one used here.

**Numerical confirmation** (`op06_ceiling_coefficient.py`; $R(p)=L(p)-L_{\text{asym}}(p)$, $e$ from the true ceiling index):

| $p$ | $e(p)$ | $p\cdot R(p)$ | $c(e(p))$ | difference |
|---|---|---|---|---|
| $10^6$ | 0.459111 | -0.480854964688 | -0.480854650376 | $3.1\cdot10^{-7}$ |
| $10^9$ | 0.611037 | -0.483414796849 | -0.483414796528 | $3.2\cdot10^{-10}$ |
| $10^{12}$ | 0.536593 | -0.480774682330 | -0.480774682330 | $3.2\cdot10^{-13}$ |
| $10^{13}$ | 0.865926 | -0.512619855067 | -0.512619855067 | $3.5\cdot10^{-14}$ |

A single constant cannot fit: $p=10^7$ gives $p\cdot R=-0.520616694704$ while $p=10^9$ gives $-0.483414796849$ (difference $3.7\cdot10^{-2}$).

### 3.11 The census caveat — recorded, not stale

`census_measure_eq` holds **by construction**: `reachableMeasure` is *defined* as $2^{\operatorname{nmin}p}\operatorname{tailSum}p\,(\operatorname{nmin}p)$, the right-hand side of the census law. The strictly geometric statement — that the $2^{\operatorname{nmin}}$ translates in $S_1$ are pairwise disjoint with union exactly the sub-sum set — is **not formalised**; `Op56/Census.lean` states this as the remaining "census counting" gap, needing `nmin_minimal` for disjointness and the measure identity for a disjoint union of $2^{\operatorname{nmin}}$ intervals of length $T_{\operatorname{nmin}}$. The arithmetic is verified numerically to $3.9\cdot10^{-62}$ for thirteen exponents by `rounds/rh42/reachable.py` §2 (local-only, outside this folder), and the identity is re-derived in `notes/OP-06-reachable-fraction.md` §1.

### 3.12 The recorded guess for OP-5's slope — REFUTED

The register's earlier suggestion $n_{\min}(p)\approx p+O(1)$ is **false**: the slope is $1/\log2=1.4426950408\ldots$, and $n_{\min}-p$ grows without bound. Measured by `op05_nmin.py`: $n_{\min}/p=1.3000,1.4200,1.4400,1.4420,1.4424$ at $p=10,50,200,1000,5000$, with $n_{\min}-p=3,21,88,442,2212$.

## 4. Verification and evidence

### 4.1 Scripts run for this edition

All Python checks were run on **2026-10-16** with Python 3.13.13 (`numpy` 2.5.0, `mpmath` 1.3.0). They write nothing but stdout, so they were run in place; the Lean build was run on a **copy** of the folder under a temporary directory so that no build artifacts were written into the published folder.

| Command | Exit | Observed output (representative lines) |
|---|---|---|
| `python3 op05_nmin.py` | **0** | §1 refutes the slope guess: `p=5000 n_min=7212 n_min/p=1.4424`; §2 `predicted c = 3(ln2)^2 - (25/12)ln2 = -0.0026975844119484539513`, `Richardson fit (last 4) c_fit = -0.002697584512195 diff = -1.002e-10`; §3 `n=1000 3.230e-09 / 0.00323 … n=1000000 3.233e-15 / 0.00323`; §4 `n=100 ratio=1.0119, n=1000 1.0012, n=10000 1.0001`; §5 `root of zeta(p) = 2 : 1.72864723899818362`, `P_1 (threshold, h(1,p)=0) : 1.72864723899818362`. |
| `python3 op06_reachable_fraction.py` | **0** | §0 reproduces the `rh42` table (`p=2 … 12`); §1 `p=1000 … (L-p log p)/p = -0.6334875826` → `p=1000000 … -0.6334870794`, `the last column -> -(1 + ln ln 2) = -0.633487079418336`; §2 large-$p$ branch `1/p coefficient -> -0.540509640658` (smooth-index, historical); §3 `residual * p` oscillates `-0.503136, -0.517180, -0.534774, -0.481076, …, -0.480562` at $p\le10^6$. |
| `python3 op06_ceiling_coefficient.py` | **0** | table above, `worst |p*R - c(e)| over the table = 3.143e-07`, `the deviation falls by ~10x per decade of p`, non-constancy witness `p = 1e7 … p*R = -0.520616694704` vs `p = 1e9 … -0.483414796849`, `difference = 0.0372019`, **`VERDICT: CONFIRMED`**. |
| `python3 op09_moduli.py` | **0** | §1 `p = 200 nmin = [287, …, 287] all equal` (also 1000, 5000); §2 `θ(p) - p/log 2 = 6.0` for every $p$ (see the observation below); §3 `spread … over all 60 cases: [-1.4950409, -0.51322271]`, **`VERDICT: CONFIRMED`**. |
| `python3 verify-006/op05_nmin_ceiling.py` | **0** | `p=1000 nmin=1441 asym=1440.195041 gap=0.804959 p*gap=804.96 True … p=50000 72133 72132.252044 0.747956 37397.78 True`; `gap range [0.024796, 0.804959] (always inside (0,1))`; `p*gap is UNBOUNDED => |nmin p - (p/ln2 - 5/2)| = O(1), and the old O(1/p) is FALSE`; `Wider sweep … tested 76 values of p, mismatches: 0`. |
| `python3 verify-006/op05_nmin_ceiling_false.py` | **0** | 451-digit counterexample; see §4.2. |
| `./check.sh --all` (Lean 4 + Mathlib, on a temp copy) | **0** | 9/9 `[check] OK`; see §4.2. |

### 4.2 The two decisive checks

**The 451-digit ceiling counterexample.** `python3 verify-006/op05_nmin_ceiling_false.py` exits **0**. Its first section is the positive control: (CEIL) holds at $p=1000,5000,10000$ (`ok=True`). Its second section searches continued fractions of $\beta=2/\log2$ with failure threshold $Q(M-Q\beta)<0.0077835833$, printing at each hit the digit count of $Q$; the first candidate found is at step 869, `Q has 451 digits, Q*(M-Q*beta) = 0.005383079`. Its third section re-verifies at 1150 dps:
```
p = 1831818673613185754746818686991356738383131544534391214519013360…1508975
ceil(p/ln2 - 5/2) = ceil(y) - 1 = ...19674852910985882734
ceil(y)                          = ...19674852910985882735
nmin p (computed)                = ...19674852910985882735
Phi_p(ceil(y)-1) - 1 = -5.24563943843337e-451
Phi_p(ceil(y)+0) - 1 = -1.73102960196935e-906
Phi_p(ceil(y)+1) - 1 =  5.24563943843337e-451
```
so $\Phi_p(\lceil y\rceil)<1<\Phi_p(\lceil y\rceil+1)$ while $\lceil p/\log2-\tfrac52\rceil=\lceil y\rceil-1$, forcing $\operatorname{nmin}p=\lceil y\rceil=\lceil p/\log2-\tfrac52\rceil+1$: **(CEIL) fails**. (The run prints the full 451-digit $p$; it is abbreviated here, with the full value in the script's output and the leading digits quoted in `notes/OP-05-nmin-asymptotic.md`.)

**The Lean build.** `./check.sh --all` on a copy elaborates the nine modules and exits **0**, printing one `[check] OK` line per module (observed, with wall-clock seconds):
```
[check] OK   Op56/Defs.lean (166s)
[check] OK   Op56/Exact.lean (182s)
[check] OK   Op56/Census.lean (115s)
[check] OK   Op56/PhiAsymptotic.lean (154s)
[check] OK   Op56/PhiThird.lean (182s)
[check] OK   Op56/PhiFourth.lean (168s)
[check] OK   Op56/Asymptotic.lean (7s)
[check] OK   Op56/FloorAsymptotic.lean (6s)
[check] OK   Op56.lean (5s)
```
Nine of nine OK, 0 failures; the run emits linter warnings (a deprecated `dif_pos`, unused simp arguments, and unused-variable notes) but no errors. Independently of the sources, `grep` over the nine modules finds **no `axiom` declaration, no `native_decide`, and no tactic-position `sorry`** (the only occurrences of the word `sorry` are in docstrings asserting its absence). `HANDOFF-006.md` and `LEAN-README.md` record the development at **0 `sorry`**, **0 `axiom`**, **0 `native_decide`**, with `#print axioms` on the headline theorems equal to `[propext, Classical.choice, Quot.sound]`; `TRUTHS.md` records `ΦThird`/`ΦFourth` taking 78 s and 121 s on the original machine, and the rest under 35 s. The toolchain is Lean 4 `v4.35.0-rc2` with Mathlib; there is no `lake` project file, `check.sh` reconstructs `LEAN_PATH` from `lake env` inside the Mathlib checkout.

**One stale count kept visible.** The root module `Op56.lean`'s docstring still says "`./check.sh --all` is **8/8 green**", while `check.sh --all` elaborates nine modules and `README.md`/`LEAN-README.md` say **9/9**; `HANDOFF-006.md` also says 9/9. The 8/8 line is stale text from before `FloorAsymptotic.lean`/`PhiFourth.lean` were added.

**Observation on `op09_moduli.py` §2.** The printed `θ(p) - p/log 2 = 6.0` at every $p$ is exactly the upper edge of the script's bisection bracket. As coded, the bisection keeps `lo = mid` when `F1(mid,p) >= 1`, which is the rule for a function *decreasing* in `n`; but $F_1(n)=\sum_j(1+j/n)^{-p}$ is *increasing* in $n$, so that section converges to `hi = p/log 2 + 6` rather than to the root. The substantive checks (§1 exact $q$-independence and §3's bounded spread of $\operatorname{nmin}+1+r/q-p/\log2$) do not depend on it and support the stated law; the derived relation with the correct direction is criterion$(N;q,r)\iff N+1+r/q\ge\theta(p)$. This is recorded as a defect in that one printed section, not in the result.

### 4.3 Evidence recorded in the folder

* `logs/op06_ceiling_coefficient.log` records the same table as the live run (`worst 3.143e-07`, `VERDICT: CONFIRMED`); `logs/op09_moduli.log` records the 60-case run (`VERDICT: CONFIRMED`).
* `HANDOFF-006.md` §5–§6 carries the theorem statements, the measured tables, the corrections and the `#print axioms` footprint; §4 explains the two `namespace Op56` blocks in `PhiThird.lean` (40 declarations reachable as `Op56.Op56.*`).
* `notes/OP-05-nmin-asymptotic.md` §3–§5 carries the threshold table, the Richardson fit to $1\cdot10^{-10}$, the $0.00323$ remainder and the $P_1=p^\ast$ boundary check; §4 carries the exceptional-set width of the closed form.
* `notes/OP-06-reachable-fraction.md` §3.1 reproduces the `rh42` §4 table and notes that the record's $p=1.8$ and $p=2.2$ rows appear offset by one (harmless for the asymptotics); §3.3 keeps the superseded smooth-index table beside the corrected one.
* The `006`-side copies in `verify-006/` are byte-identical to the top-level scripts except for re-pointed prose links (`op05_nmin.py`) and the $1/p$-correction docstring (`op06_reachable_fraction.py`, whose `verify-006` copy still states the superseded constant in its header).

## 5. What is not claimed

* **No twin primes, no parity problem, no Riemann hypothesis.** Nothing here touches them. The finite checks are finite checks.
* **The exact ceiling law is not a theorem and never was.** (CEIL) is refuted by a 451-digit counterexample; the disjunction $\operatorname{nmin}p\in\{\lceil A\rceil,\lceil A\rceil+1\}$ is the sharpest *true* uniform statement and is **unproved**.
* **The $O(1/p)$ error term is false**, as is the constant $1/p$ coefficient and the $1/\log q$ reading of other moduli. All three are retained beside their corrections; the main theorems ($O(1)$ error, closed-form $c(e)$ coefficient, slope $1/\log2$) are unaffected.
* **The census identity is formalised by construction.** The geometric "census counting" statement (disjoint translates, union exactly the sub-sum set) is **not** formalised; the arithmetic check is numerical.
* **The threshold-form fourth order (`SFourth`) is not landed** — new analytic content.
* **`op5_nmin_asymptotic`'s constant is $11$**, not claimed sharp; the theorem bounds the residual, and `LAsym`'s linear coefficient is *given* rather than re-derived in OP-6.
* **The meta-theorem's `log 2` instances are conditional** on `Irrational (Real.log 2)` (Lindemann–Weierstrass, absent from Mathlib `v4.35.0-rc2`); the general meta-theorem is unconditional.
* **`tailSum_integral_lower` is a negative result** and is used by nothing; its original hypothesis $N+1\le M$ was false and is corrected to $N+2\le M$.
* **`op09_moduli.py`'s §2 printed threshold values are an artefact** of the bisection direction as coded (see §4.2); only the leading order and $r/q$ shift of `O9` are claimed, and no Lean generalisation is attempted.
* **`op06_reachable_fraction.py` §4 still prints the superseded constant** in its closing "closed form" text; the corrected coefficient lives in its own docstring, in `op06_ceiling_coefficient.py` and in `notes/OP-06-reachable-fraction.md` §2.4. The stale line is kept visible rather than silently edited.
* **Two recorded numeric discrepancies are not resolved here**: the OP-06 correction banner cites $3.1\cdot10^{-13}$ at $p=10^{13}$ where the table, `README.md` and `TRUTHS.md` give $3.5\cdot10^{-14}$ (the table is the value reproduced by the live run); and `README.md`'s `O9` row says "60 cases, $q\le11$" while the note says 60 cases at 60 dps — these agree.
* **Attribution.** The folder states the programme (math.solveathome.org), the rounds (`rh42`, `open/`, `006/`) and the Lean toolchain, but no individual authors or dates of the mathematics; none is asserted here.

## 6. Value and significance

The item closes a registered chain — `rh42` census $\to$ OP-5 threshold/index $\to$ OP-6 decay — with machine-checked proofs of the three headline asymptotics and an unconditional meta-theorem that explains a structural impossibility rather than merely observing it: an integer index cannot track an irrational affine function to within $O(1/p)$, so the corrected $O(1)$ error of OP-5 is the end of the line, not a gap to be sharpened. It is also a case study in record hygiene: the round kept every false claim it corrected — the $O(1/p)$ error, the exact ceiling law (with its 451-digit falsifier and the 76-value sweep that missed it), the constant $1/p$ coefficient, the $1/\log q$ modulus guess, the stale "does not compile" note, and the stale 8/8 build count — next to the corrected statement and the evidence that refuted it. The quantitative pay-off is that the reachable fraction of the budget is now known to die like $p^{-p}e^{(1+\log\log2)p}$, with $c=1$ in the registered $c\,p\log p$ form, and its $1/p$ behaviour is pinned to a closed-form function of the ceiling error. Finally, the folder is explicit about its own remaining holes: the ceiling disjunction, the census counting, and the threshold-form fourth order.

## Sources

All paths are relative to this folder. SHA-256 values are of the files as read for this edition.

| Source | Role | Locator | SHA-256 |
|---|---|---|---|
| [`README.md`](README.md) | folder guide, contents, proved/refuted/open summary | whole file | `b82033ab2526e013d53ff52e4f9f8e2462f2c3b44c8cd0370064cfb704c00d87` |
| [`TRUTHS.md`](TRUTHS.md) | the §9 ledger: every theorem with status and Lean proof locator | table, lines 12–29 | `58076047aab5a4662dc6b4f1482e71f455f8f504e8b910595ee0fa035db487c3` |
| [`HANDOFF-006.md`](HANDOFF-006.md) | cleaned authoritative state: theorem statements, proof routes, corrections, gotchas | §§1–12 | `17e4def2fc0dd1ab87d6dfba43471a9e3afae3db75ef85f472cfde0ee5c66493` |
| [`LEAN-README.md`](LEAN-README.md) | the Lean development's own guide | whole file | `41bfb83ba1bde01c874d530e13fad17a22fff64e116d6813010ff9e7b0112650` |
| [`Op56/Asymptotic.lean`](Op56/Asymptotic.lean) | the headline theorems, `c5`, `c6`, `leadingCoeff_forced` | 338 lines | `1d343279d915579eefa5631384eb656dd799ec382d2b613cd2bf98c559a6c54d` |
| [`Op56/Defs.lean`](Op56/Defs.lean) | objects, indexing dictionary, asymptotics expressions | 78 lines | `1acc049eb53c53aa5aaeaf530588c7833532b2d026f382cb014089f783e872e3` |
| [`Op56/FloorAsymptotic.lean`](Op56/FloorAsymptotic.lean) | `O11`: the floor/Diophantine meta-theorem and OP-5 instance | 227 lines | `86ba84730f378f60e48b243f1b30c32cd712e450a4a37e52e8e78192ca609675` |
| [`Op56/Census.lean`](Op56/Census.lean) | census identity and ratio, with the recorded counting obstruction | 67 lines | `669a48eb8cf0775fb9d7b8ac22251f50f49042f5b999b138d1a65b42755f5e7a` |
| [`Op56/Exact.lean`](Op56/Exact.lean) | exact layer, `exists_isComplete`, corrected integral test | 385 lines | `13ba7d83e6715bafc96ec56f61f95899e4aff86f1b21b322ff02f75f04d34a37` |
| [`Op56/PhiAsymptotic.lean`](Op56/PhiAsymptotic.lean) | `Φ` first/second-order asymptotics | 2473 lines | `3d1771953cf9340fe237a235bbd08e359ab128aba11e156549ce9e2c1c5536a9` |
| [`Op56/PhiThird.lean`](Op56/PhiThird.lean) | third-order layer, ceiling reduction, OP-6 estimate chain | lines 5178–5256 for the ceiling reduction | `f43107d2d01f177ded4b376c7f076a1d173944e18b7b7601cf57fd301aa962f7` |
| [`Op56/PhiFourth.lean`](Op56/PhiFourth.lean) | `O10`: `Phi_fourth_order` and its auxiliary layer | `Phi_fourth_order` at line 1513 | `45b28aef87617f278919ef436ad719293ec6218e49c106abe0a7f2ee47663391` |
| [`Op56.lean`](Op56.lean) | root module (its "8/8" count is stale; see §4.2) | whole file | `243d62c21e43019708eced67ca1ee4678b1b340e0cfcfc3cae1b5c5c9b607cdf` |
| [`check.sh`](check.sh) | the build script: elaborates the nine modules against Mathlib | whole file | `11b481d126c607d7d437e4eb4ff7294707ce50dd053fa865ff65249d36a27f57` |
| [`op05_nmin.py`](op05_nmin.py) | OP-5 ground truth: slope, threshold constant, remainder | 154 lines | `b32aae09e040bece103271cee7226cc83fd1202d97ee8480a34dcf2874290651` |
| [`op06_reachable_fraction.py`](op06_reachable_fraction.py) | OP-6 census values, leading coefficients | 169 lines | `1020f1fec1d7f5dd770d5e60dc0aabfd6d06458ab320b1d349ac56808ed7d84f` |
| [`op06_ceiling_coefficient.py`](op06_ceiling_coefficient.py) | `O4`: the closed-form $1/p$ coefficient and non-constancy | 118 lines | `adf1a8547c39e386ac39fad1817123a618d7c0b1f279ba1aaea73d77ef5c1131` |
| [`op09_moduli.py`](op09_moduli.py) | `O9`: other-moduli falsification | 142 lines | `4f587043f5e50521c9b23fae5aaf98bd357036c8d03460f4481f2e5349baa59d` |
| [`verify-006/op05_nmin_ceiling.py`](verify-006/op05_nmin_ceiling.py) | falsifies $O(1/p)$; 76-value sweep of (CEIL) | 110 lines | `638f0a0b3e1a9dff77aeea1505087f860cb3d0d7519657cdfe72c583bc6ad137` |
| [`verify-006/op05_nmin_ceiling_false.py`](verify-006/op05_nmin_ceiling_false.py) | the 451-digit counterexample to (CEIL), 1150 dps | 174 lines | `4322f0d8973632a44dd921edbd07a2c949d3ba04c04f8fc88d1e7a1e9f94cc25` |
| [`verify-006/op05_nmin.py`](verify-006/op05_nmin.py) | `006`-side copy of the OP-5 ground truth | 154 lines | `5abb417e55dfb9c84c84973bb75d5a10d7f9d5a7348cdf7a296dd3a4658f67b5` |
| [`verify-006/op06_reachable_fraction.py`](verify-006/op06_reachable_fraction.py) | `006`-side copy, header still at the superseded constant | 153 lines | `f287307699b2990b729f159a2d51b7174a17d360fbd338d829033d7e1afdb412` |
| [`logs/op06_ceiling_coefficient.log`](logs/op06_ceiling_coefficient.log) | recorded `O4` run | whole file | `b80c93552c8f66bd3a8c65c927a540b0edbdb2bb410413566cc53ea13de2a3cb` |
| [`logs/op09_moduli.log`](logs/op09_moduli.log) | recorded `O9` run | whole file | `b6849b62859d4ae1cc29581f2eb3fa3cd28ffd32deba0bcb76fb7f4763808155` |
| [`notes/OP-05-nmin-asymptotic.md`](notes/OP-05-nmin-asymptotic.md) | OP-5 write-up with both correction banners | §§1–6 | `67056d53cc9711bd6c81c6f0a329c9c2c21b9586356854f8bd2702f05347c9ef` |
| [`notes/OP-06-reachable-fraction.md`](notes/OP-06-reachable-fraction.md) | OP-6 write-up, §2.4 the closed-form coefficient | §§1–4 | `166f72827b964d94e38d1fba5a9c61c6663b14100bc5e761dc92cab8a48e149a` |
| [`notes/OP-09-other-moduli.md`](notes/OP-09-other-moduli.md) | the `O9` falsification write-up | whole file | `db1e675218a8850d226bea73b45ac72757b622aa497c396644ef56b2c3009114` |
| [`notes/07-open-problems.md`](notes/07-open-problems.md) | the register: OP-5/OP-6 rows, difficulty, sources | rows at lines 112–113, 217–238 | local-only context |
| `rounds/rh42/reachable.py` §2 | the $3.9\cdot10^{-62}$ census arithmetic check | cited in `notes/OP-06-reachable-fraction.md` §1 | local-only, not in this folder |
| `open/HANDOFF.md` | the full development log (archaeology) | cited in `HANDOFF-006.md` §12 | local-only, not in this folder |
| `research/truths.md` §9 | upstream ledger | reproduced as `TRUTHS.md` | local-only, not in this folder |
