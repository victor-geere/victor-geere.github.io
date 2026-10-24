# Periodic orbits on Bruhat–Tits trees — research programme

**Status:** reconstructed finite formal core + exact computation layer. The local Reshetikhin–Turaev identity `RT_{C_p}(β) = p^{-n}` and the global adelic/spectral claim remain **open**; the source itself retracts the former and the later repair sections are circular.  
**Source:** [`archive/maths/rh/research/periodic-orbits/1_1.tex`](../../archive/maths/rh/research/periodic-orbits/1_1.tex), part of a 28-file TeX development (`1_1`–`3_4c`, `complete.tex`, `verify.py`, notebooks).  
**Inventory:** [Scraps](../../scraps.html) item 19 · [Topic index](../README.md) · [The Final Letter](../../index.html).

## What the programme is

The archived corpus tries to turn the periodic orbits of the $p$-adic shift into a *local Euler factor*. The chain is:

1. Let $T_p$ be the Bruhat–Tits tree of $\mathrm{PGL}(2,\mathbb{Q}_p)$, with boundary $\mathbb{P}^1(\mathbb{Q}_p)$.
2. The shift $\sigma_p$ is induced by $\mathrm{diag}(p,1)$, so on the boundary $\sigma_p(z)=pz$.
3. A length-$n$ periodic orbit of $\sigma_p$ on $T_p$ should give a framed braid $\beta\in B_n$.
4. In $\mathcal{C}_p=\mathrm{SU}(2)_{p-2}$ at $q=e^{\pi i/p}$, the Reshetikhin–Turaev invariant of the closure is claimed to be
   $$\mathrm{RT}_{\mathcal{C}_p}(\beta)=p^{-n}.$$
5. Summing these local weights over $n$ should reproduce $(1-p^{-s})^{-1}$, and assembling the primes into an adelic transfer operator should make the non-trivial zeros of $\zeta$ a spectrum — hence RH.

Steps 1–2 and the finite modular data are genuine. Step 3 is asserted rather than constructed. Step 4 is the local identity. Step 5 is the global spectral claim, and nothing in the corpus proves even step 4. This folder reconstructs the small finite core that can be stated and checked, and records the rest with its archived status.

## The source contradicts itself

This is the central provenance fact, and the dossier must not smooth it over.

| Source file | What it says about `RT = p^{-n}` |
|---|---|
| `3_1.tex` | States it as the **Main Local RT-Weight Theorem**, with a four-step proof roadmap. |
| `3_2.tex` | **Retracts it.** The Verlinde collapse to a single Gauss sum is missing its Seifert data, and the claimed evaluation $G_p=\tau_p$ is false: the author computes $G_p$ over $\mathbb{Q}(\zeta_p)$ and reports a mismatch of magnitude and argument for every $p\le 17$. Conclusion: "the local identity therefore remains an open conjecture rather than a theorem." |
| `3_2a.tex` | Surveys alternative braid-to-manifold identifications; states the route is open. |
| `3_2b.tex`, `3_3.tex`, `3_4.tex`, `3_4a–c.tex` | Claim to repair the proof using the column $\ell=(p-1)/2$ and auxiliary twists $f_k=+1$. |
| `verify.py` | The verification script is **circular**: `RT_alternative` computes `result = p**(-n)` directly, then asserts the difference to `p**(-n)` is small. It never evaluates the reduced Verlinde sum. |
| `3_4c.tex` | The "complete runnable script" sets `sum_ek_prime = n + n` and sums only over even `k`, so it does not compute the sum it claims to verify. |

The repair is also mathematically empty: with $\ell=(p-1)/2$ one has $2\ell+1=p$, hence
$$S_{j\ell}=\sqrt{2/p}\,\sin\!\big(\pi(2j+1)p/p\big)=\sqrt{2/p}\,\sin(\pi(2j+1))=0,$$
so the "surviving sum" $\sum_j d_j\theta_j S_{j\ell}$ is identically zero. A zero column cannot normalise to $\tau_p S_{0\ell}\ne 0$; the reduction would give $\mathrm{RT}=0$, not $p^{-n}$. The Python layer verifies this exactly (row C3).

## Reconstructed objects and notation

| Object | Definition | Status |
|---|---|---|
| Tree $T_p$ | Bruhat–Tits tree of $\mathrm{PGL}(2,\mathbb{Q}_p)$, $(p+1)$-regular | Standard |
| Shift $\sigma_p$ | Induced by $\mathrm{diag}(p,1)$; boundary map $z\mapsto pz$ | Standard |
| Length-$n$ orbit | $\{v,\sigma_p v,\ldots,\sigma_p^{n-1}v\}$, $\sigma_p^n v=v$, $n$ minimal | Definition |
| Fixed vertices | Count of $\sigma_p^n$-fixed vertices is $p^n+1=\lvert\mathbb{P}^1(\mathbb{Z}/p^n)\rvert$ | Source claim; tested separately from primitive orbits |
| Braid word $\beta$ | Word in $B_n$ read from the orbit, with blackboard framing | Asserted, not constructed |
| Writhe $w(\beta)$ | Sum of signed generator exponents | Finite bookkeeping |
| Category $\mathcal{C}_p$ | $\mathrm{SU}(2)_{p-2}$, $q=e^{\pi i/p}$ | Standard |
| Labels | $j=0,\tfrac12,\ldots,\tfrac{p-2}{2}$, equivalently $r=2j+1=1,\ldots,p-1$ | Standard |
| Quantum dimension | $d_j=\sin(\pi(2j+1)/p)/\sin(\pi/p)$ | Standard |
| $S$-matrix | $S_{jj'}=\sqrt{2/p}\,\sin(\pi(2j+1)(2j'+1)/p)$ | Standard |
| Ribbon twist | $\theta_j=e^{(\pi i/p)(j(j+1)-1/4)}$ | Standard |
| Total dimension | $D_p^2=p/(2\sin^2(\pi/p))$ | Standard; exact check C2 |
| RT weight | $w_n=p^{-n}$ | Definition; positivity T5 |
| Gauss sums | $G_p=\sum_j d_j\theta_j S_{j0}$, $\tau_p=e^{i\pi/4}p^{-1/2}$ | C4: $G_p\ne\tau_p$ |

Note one further source error: `3_4b.tex` says $r=2j+1$ runs over the **odd** integers $1,3,\ldots,p-1$. In fact $j$ runs over $0,\tfrac12,\ldots,\tfrac{p-2}{2}$, so $r=1,2,\ldots,p-1$ (all integers). The identity $\sum_{r=1}^{p-1}\sin^2(\pi r/p)=p/2$ requires the full range; the odd-only range would give $p/4$.

## Theorem ledger

Every row marked **Theorem** is proved in [`lean/Topic.lean`](lean/Topic.lean) with no `sorry`, `axiom`, or `admit`. Every row marked **Computation** is tested in [`tests/test_programme.py`](tests/test_programme.py). The ledger has four kinds — **Theorem**, **Computation**, **Source claim**, and **Open / conjecture**; the first table records the first two, the second table the latter two.

| # | Kind | Statement | Lean / test name |
|---|---|---|---|
| T1 | Theorem | Quantum dimensions are positive: $0<r<p\Rightarrow 0<d_r(p)$. | `PeriodicOrbits.qdim_pos` |
| T2 | Theorem | Quantum dimensions are symmetric: $d_r(p)=d_{p-r}(p)$ for $r\le p$. | `PeriodicOrbits.qdim_symm` |
| T3 | Theorem | For $p>1$, $S_{1r}=\sqrt{2/p}\,\sin(\pi/p)\,d_r$: the $S$-matrix determines the quantum dimensions. | `PeriodicOrbits.smat_one` |
| T4 | Theorem | For $p>1$, the squared total quantum dimension is positive: $D_p^2>0$. | `PeriodicOrbits.Dsq_pos` |
| T5 | Theorem | The local RT weight is positive: $p^{-n}>0$. | `PeriodicOrbits.rtWeight_pos` |
| T6 | Theorem | Finite geometric identity: $\sum_{n<N}p^{-n}=(1-p^{-N})/(1-p^{-1})$. | `PeriodicOrbits.geom_rtWeight` |
| T7 | Theorem | A full twist on $n\ge 2$ strands has positive writhe $n(n-1)$. | `PeriodicOrbits.fullTwist_writhe_pos` |
| C1 | Computation | $d_j>0$, $d_0=1$, and $d_r=d_{p-r}$ for $p=3,5,7,11$. | `test_quantum_dimensions_positive_and_symmetric` |
| C2 | Computation | $\sum_{r=1}^{p-1}\sin^2(\pi r/p)=p/2$ exactly (reduction mod $\Phi_p$), hence $D_p^2=p/(2\sin^2(\pi/p))$; numerical residual $<10^{-40}$ at 50 digits. | `test_total_quantum_dim_identity` |
| C3 | Computation | For $\ell=(p-1)/2$, every $S_{j\ell}=0$ and the "surviving sum" is exactly $0$ ($p=3,5,7$). | `test_verlinde_column_at_half_p_vanishes` |
| C4 | Computation | $G_p\ne\tau_p$ for $p=3,5,7$ (mismatch far above $10^{-3}$; 40-digit evaluation). | `test_source_gauss_sum_mismatch` |
| C5 | Computation | $p^{-n}$ is exact rational, and $\sum_{n<N}p^{-n}=(1-p^{-N})/(1-p^{-1})$, including the empty sum $N=0$. | `test_rt_weight_and_truncated_euler_factor` |
| C6 | Computation | Writhe is additive; the full twist has $w=n(n-1)$, positive for $n\ge2$, zero for $n=1$, and the empty word has writhe $0$. | `test_writhe_bookkeeping` |
| C7 | Computation | Primitive length-$n$ orbits by Möbius inversion: $nP(n)=\sum_{d\mid n}\mu(n/d)(p^d+1)$; $P(1)=p+1$, $P(2)=(p^2-p)/2$. | `test_primitive_orbit_counts` |

Nothing in the ledger asserts `RT = p^{-n}`, the existence of the Seifert identification, or RH.

## Source claims and open items (not promoted to theorems)

These are recorded with the source's own status. None is used as a theorem of this reconstruction.

| Claim | Kind | Source status | Reconstruction note |
|---|---|---|---|
| Exactly $p^n+1$ periodic orbits of length $n$ | **Source claim** | `1_1.tex` Proposition, with proof sketch | Conflates $\sigma_p^n$-**fixed vertices** with **primitive** length-$n$ orbits. The fixed-vertex count $p^n+1$ is the standard $\lvert\mathbb{P}^1(\mathbb{Z}/p^n)\rvert$; primitive orbits are the Möbius sum C7. For $p=3,n=2$: $10$ fixed vertices, $3$ primitive orbits. |
| Orbit $\mapsto$ framed braid $\beta\in B_n$ with canonical framing | **Source claim** | `2_1.tex` construction, `2_2.tex` framing | Asserted with examples; no general algorithm, and "canonical" is only fixed up to conjugacy. Not formalised. |
| Closure is a Seifert-fibred manifold over the 4-punctured sphere | **Source claim** | `2_2.tex`, `3_1.tex` Step 1 | No explicit Seifert invariants are produced; `3_2.tex` lists this as a gap. |
| Verlinde sum collapses to the single Gauss sum $G_p$ | **Source claim** | `3_1.tex` Step 2, `3_2.tex` | Explicitly conditional in `3_2.tex`. |
| $G_p=\tau_p=e^{i\pi/4}p^{-1/2}$ | **Source claim** (false) | `3_1.tex` Step 3 | **False** as stated; `3_2.tex` retracts it. C4 confirms the mismatch. |
| $\mathrm{RT}_{\mathcal{C}_p}(\beta)=p^{-n}$ | **Open / conjecture** | Stated as theorem in `3_1.tex`; retracted to open in `3_2.tex`; re-asserted in `3_2b`/`3_4` | Not established. The re-assertion uses a column that vanishes identically (C3), and `verify.py` hardcodes the answer. |
| Assemble local weights into an adelic operator whose spectrum is the zeta zeros | **Open / conjecture** | Global programme, outside this folder | Conditional on the local identity; completely open. |
| RH / GRH consequences | **Open / conjecture** | Global claim | **Open.** No proof is claimed here. |

## Open items and gaps

1. **The local RT identity.** `RT_{C_p}(β)=p^{-n}` is not proved. The source's own §3.2 leaves it open; the later repair is vacuous at the key column. A genuine proof would need (a) a fully explicit orbit-to-braid and braid-to-3-manifold map, (b) the Seifert invariants as functions of the $p$-adic slope, and (c) a non-circular evaluation of the resulting state sum.
2. **Braid and framing construction.** The corpus gives illustrative words ($\beta=\sigma_1$ for $(p,n)=(3,2)$; $\beta=\sigma_1\sigma_2\sigma_1$ for $(5,3)$) but no deterministic algorithm, and the isotopy lemma is asserted.
3. **Correct orbit count.** Replace "$p^n+1$ length-$n$ orbits" by the primitive count C7, and identify which orbits carry which braid.
4. **Gauss-sum obstruction.** Any repair must produce a non-zero reduced column and an evaluation that is not the classical quadratic Gauss sum; the corpus does neither.
5. **Global spectral claim.** The adelic transfer operator, its self-adjointness, and the identification of its spectrum with the zeros are all outside this reconstruction and remain open. RH is not a theorem of this programme.

## Python layer

[`python/programme.py`](python/programme.py) provides:

- `admissible_labels(p)`, `quantum_dim(j,p)`, `s_entry(j,jp,p)`, `theta(j,p)`, `total_quantum_dim_sq(p)`;
- `sin_sq_sum_mod_cyclotomic(p)` — exact rational arithmetic in $\mathbb{Q}[z]/(\Phi_p)$;
- `total_quantum_dim_numeric_residual(p, dps)` — explicitly numerical, tolerance stated by the caller;
- `verlinde_column_sum(p,ell)`, `gauss_sum(p)`, `tau_gauss(p)`, `gauss_mismatch(p,dps)`;
- `rt_weight(p,n)`, `truncated_euler_factor(p,N)`, `euler_factor_closed_form(p,N)`;
- `writhe(word)`, `full_twist_writhe(n)`;
- `fixed_vertices(p,n)`, `primitive_orbit_count(p,n)`.

Run:

```bash
cd the-final-letter/topics/periodic-orbits
python3 -m pytest -q tests
```

Current result: **7 passed** (under 1 s warm). The suite covers every Computation row and the edge cases $N=0$, $B_1$, the empty word, and rejected non-prime $p$.

## Lean layer

[`lean/Topic.lean`](lean/Topic.lean) defines `PeriodicOrbits.qdim`, `Smat`, `Dsq`, `rtWeight`, `writhe`, and proves T1–T7. It imports Mathlib and uses only elementary order, trigonometric, field, and list-sum facts. There is no `sorry`, `axiom`, or `admit`.

What is deliberately *not* formalised: the shift on $T_p$, the orbit-to-braid construction, the RT invariant, the Seifert identification, the Verlinde sum, and every global spectral statement. See [`lean/README.md`](lean/README.md).

```bash
cd the-final-letter/topics/periodic-orbits
./lean/check.sh
```

Recorded build: [`lean/BUILD.log`](lean/BUILD.log) — `[check] OK   Topic.lean`.

## Provenance

- [`archive/maths/rh/research/periodic-orbits/`](../../archive/maths/rh/research/periodic-orbits) — the full 28-file corpus, including `complete.tex`, `verify.py`, and the notebooks.
- [`scraps.html`](../../scraps.html) — inventory entry 19 ("Reshetikhin–Turaev invariants of framed braids from periodic orbits on Bruhat–Tits trees… 28 files"); harvest note: technical corpus, overlaps items 21 and 23.
- [`topics/README.md`](../README.md) — all topic folders.
- [`summary/14-legacy-conjectures/`](../../summary/14-legacy-conjectures/README.md) — the deduplicated conjecture index.

[Back to the topic index](../README.md) · [Scraps](../../scraps.html) · [The Final Letter](../../index.html)
