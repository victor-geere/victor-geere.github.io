# 009 — OP-5 and OP-6, Resolved

| Field | Value |
|---|---|
| Source | [`research/publish/009-op5-op6-asymptotics/manuscript.md`](../../rh/research/publish/009-op5-op6-asymptotics/manuscript.md) |
| Status | Published; truths ledger §9. |
| Harvested statements | 9 |

## Abstract

This folder packages the two problems the programme's `open/` directory was created to settle, together with their Lean 4 + Mathlib proofs, the corrections that followed, and the numerical cross-checks. **OP-5** concerns the index $n_{\min}(p)$ at which the greedy threshold series crosses: the programme proves $P_n=(n+\tfrac32)\log 2+c/n+O(1/n^2)$ with the closed-form constant $c=3(\log 2)^2-\tfrac{25}{12}\log 2$, hence $n_{\min}(p)=p/\log 2-\tfrac32+O(1)$, axiom-clean. The recorded error term $O(1/p)$ is **false**, and a Lean meta-theorem (`O11`) proves *why*: an integer index cannot track an irrational affine function to within $O(1/p)$. The recorded exact ceiling law $n_{\min}(p)=\lceil p/\log 2-\tfrac52\rceil$ is also **false**: the first counterexample is a 451-digit $p$, verified at 1150 dps. The recorded "$1/\log q$" reading of other moduli is **false** too; the slope is $1/\log 2$ for every modulus, and $r=0$ is exactly $q$-independent. **OP-6** settles the reachable fraction: $L(p)=p\log p-(1+\log\log 2)p+O(1)$, i.e. $\operatorname{measure}(S_1)/P(p)=p^{-p}e^{(1+\log\log 2)p}(1+o(1))\to0$; its $1/p$ coefficient is a closed-form *function* of the ceiling error, not the constant previously quoted. Nothing here touches the twin prime conjecture, the parity problem, or the Riemann hypothesis.

## Harvested theorem-like statements

### Theorem (`leadingCoeff_forced`).

If $x\in[0,1)$ and $\sum_{j\ge1}x^j=1$ (as a `HasSum`), then $x=1/2$.

Equivalently: the rate $\log2$ of OP-5 is not fitted but forced, because the threshold equation $\sum_{j\ge1}x^j=1$ has the unique root $x=1/2$, i.e. $1/c=\log2$.

### Theorem (`op5_threshold_leading`).

If $P_{\mathrm{fun}}(n)$ is a threshold sequence, i.e. $\operatorname{IsThreshold}(n,P_{\mathrm{fun}}(n))$ for all $n$, with $1/2\le P_{\mathrm{fun}}(n)/n\le1$, then
$$P_{\mathrm{fun}}(n)=n\log2+O(1).$$

### Theorem (`op5_threshold_second_order`).

Under the same hypotheses,
$$P_{\mathrm{fun}}(n)=\Bigl(n+\frac32\Bigr)\log2+O(1).$$
The $O(1)$ correction is exactly $\tfrac32\log2$, because $\Phi S(\log2)=\sum_{k\ge1}k^22^{-k}=6$ makes the threshold equation give $u=\log2+\frac{3\log2}{2n}+O(1/n^2)$.

### Theorem (`op5_threshold_asymptotic`).

Under the same hypotheses,
$$P_{\mathrm{fun}}(n)=\operatorname{thresholdAsym}(n)+O\!\left(\frac{1}{(n+1)^2}\right),\qquad \operatorname{thresholdAsym}(n)=\Bigl(n+\frac32\Bigr)\log2+\frac{c}{n},$$
$$c=c_5=3(\log2)^2-\frac{25}{12}\log2=-0.0026975844119484539513\ldots$$
The analytic input is `threshold_third_order_uniform`, a uniform third-order expansion $\Phi_{un}(n)=(e^u-1)^{-1}+\frac{u}{2n}\Phi S(u)+\frac{D(u)}{n^2}+O(n^{-3})$; the proof extracts $u\in[\tfrac12,1]$ and converts $1/n^3$ into the stated rate via $(n+1)^2\le4n^2$.

### Theorem (`op5_nmin_asymptotic`).

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

### Theorem (`no_index_asymptotic_error`).

If $\alpha$ is irrational, $\beta\in\mathbb R$, $n:\mathbb N\to\mathbb Z$, $C\in\mathbb R$ and $P\in\mathbb N$, and if
$$\bigl|n(p)-(\alpha p+\beta)\bigr|\le\frac{C}{p}\qquad\text{for every }p\ge P,$$
then `False`.

*Proof (as carried).* Comparing the hypothesis at $p$ and $p+1$ gives
$$\bigl|(n(p+1)-n(p))-\alpha\bigr|\le\frac{C}{p+1}+\frac{C}{p}\le\frac{2|C|}{p}.$$
The left side is $|z-\alpha|$ for the **integer** $z=n(p+1)-n(p)$; since the right side is $o(1)$, those integers are eventually constant, equal to some $z$, and squeezing the same bound against arbitrarily large $p$ forces $\alpha=z$, so $\alpha$ is rational — contradiction. **No density or equidistribution input is used**, and $C$ need not be nonnegative (the proof runs with $|C|$).

Formalised alongside: `no_index_asymptotic_error_nat` (the $\mathbb N$-valued form), `irrational_not_eventually_error_inv` (the packaged existential), `log_two_inv_no_index_asymptotic` (the instance $\alpha=1/\log2$, arbitrary $\beta$), and `nmin_error_not_bigO_inv` (the OP-5 instance $\alpha=1/\log2$, $\beta=-\tfrac52$ against $\operatorname{nmin}$ and $\operatorname{nminAsym}$).

### Hypothesis kept explicit.

`Irrational (Real.log 2)` is Lindemann–Weierstrass ($\exp(\log2)=2$ is algebraic and $\ne0,1$); Mathlib `v4.35.0-rc2` formalises only the *analytic part* of Lindemann–Weierstrass, not the transcendence conclusion, so the $\log2$ instances carry it as an explicit hypothesis, transported to $1/\log2$ by `Irrational.inv`. **The general meta-theorem is unconditional.**

### Theorem (`Phi_fourth_order`).

There is $C>0$ with, eventually in $n$, for all $u\in[\tfrac12,1]$,
$$\Bigl|\Phi(un,n)-\Bigl[(e^u-1)^{-1}+\frac{u}{2n}\Phi S(u)+\frac{-\frac u3\Phi K_3u+\frac{u^2}{8}\Phi K_4u}{n^2}+\frac{E(u)}{n^3}\Bigr]\Bigr|\le\frac{C}{n^4},$$
$$E(u)=\frac u4\Phi K_4u-\frac{u^2}{6}\Phi K_5u+\frac{u^3}{48}\Phi K_6u,\qquad C=11\cdot10^{12}+2\cdot10^{12}+7 .$$
The chain is `phi_term_sharp4` (the former sole blocker; constant $11$, about $118\times$ margin), `tsum_pow8_exp_neg_half_le`, `tsum_shift_pow_exp_le8` ($m\le8$), `phi_tail_sum_le4`, `phi_finite_part_le4`, `PhiMainS4_eq` and `Phi_fourth_order_aux`. The moments used are $1082$/$9366$ (and $1091670$ for $k^8$), not the earlier $541$/$4683$. **Not landed: the threshold-form fourth order (`SFourth`)**, scoped as new analytic content.

### Theorem (`op6_reachable_fraction`).

$$\bigl(L(p)-L_{\text{asym}}(p)\bigr)_p=O(1),\qquad L_{\text{asym}}(p)=p\log p-(1+\log\log2)p,$$
equivalently
$$L(p)=p\log p-(1+\log\log2)p+O(1),\qquad \frac{\operatorname{measure}(S_1)}{P(p)}=p^{-p}e^{(1+\log\log2)p}\bigl(1+o(1)\bigr)\to0 .$$
The `rh42` register asked for a leading constant $c$ in $-\log(\operatorname{measure}/P)\sim c\,p\log p$; **the leading term is confirmed and $c=1$** (not $1/\log2=1.4427$, not $2/\log2=2.8854$), with the exact second coefficient
$$-(1+\log\log2)=-0.6334870794183357\ldots,\qquad \log\log2=-0.3665129205816643\ldots$$
The linear term is of the *same order* as the leading term, so the ratio $L/(p\log p)\to1$ only slowly: the exact census gives $L/(p\log p)=0.95414668$ at $p=10^6$. The proof composes the census law with OP-5: `L_decomp` gives $L(p)=-\operatorname{nmin}p\log2-\log(\operatorname{tailSum}p\,(\operatorname{nmin}p))+\log(\operatorname{budget}p)$, and four landed estimates (with constants $\log3$, $\log9$, $4$, $300$, summing to $\le1000$) bound the residual. Here `LAsym`'s **linear coefficient is given**, not re-derived from first principles; it enters through `log_ratio_close` and the OP-5 second-order layer.

## Source

[`manuscript.md`](../../rh/research/publish/009-op5-op6-asymptotics/manuscript.md) · [`README.md`](../../rh/research/publish/009-op5-op6-asymptotics/README.md)
