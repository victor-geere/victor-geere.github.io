# 06 — The register of numerical checks

**Programme folder:** `/Users/victor/workspace/rh` — rounds **rh42, rh43, rh044, rh45, rh46, rh47**.

This is the *checks* half of the twin-prime-parity documentation: for every round it
records **what was computed, by what method, to what precision, with what outcome**, and
— the part that matters — **what each check does and does not establish**. The claims
and their statuses live in [`../dictionary/00-dictionary.md`](../dictionary/00-dictionary.md);
the unsolved items live in [`../open/07-open-problems.md`](../open/07-open-problems.md).
See also [`../dictionary/03-parity-problem.md`](../dictionary/03-parity-problem.md) for
the Chowla/Elliott landscape these checks touch.

> **Reading rule that governs every line below.** A finite numerical computation
> establishes (i) the values it actually computed, at the stated precision, and (ii) any
> *refutation* that a single certified counterexample can force. It **never** establishes
> an asymptotic statement, and a PASS means "the check's criterion was met on the
> computed range", not "the claim is proved". Where a script reports `N checks pass`,
> that is a count of criteria, not of theorems. Scripts whose own headers say they are
> heuristic are quoted as heuristic.

**Conventions used in this file.**

* A *source tag* looks like `rh46/verify/chowla_two_point.log`. Every number below
  carries one.
* *Precision* is always the precision the artefact reports: exact `Fraction`, a
  rational-interval width, an mpmath `dps`, or a fitted quantity with its uncertainty.
* A **REFUTED** line is a check whose *target claim* is false; the script's own
  `PASS` means the refutation succeeded. `FAIL` lines are criteria the audit could not
  meet (usually because the claim is false or the criterion was mis-set), and are
  reported as such.
* The directory of round 44 is **`rh044`**, not `rh44`. `rh44/` does not exist in the
  workspace; every reference in this file is to `rh044/`.

---

## How the rounds chain together

| round | directory | the numerical object | scripts → logs |
|---|---|---|---|
| rh42 | `rh42/` | ζ-budgets `P(p)`, `N(p)`; the exact reachable set of the signed alphabet | `helix_zeta.py`, `reachable.py` |
| rh43 | `rh43/` | the balanced split `Re S_N(t)=0` at `Re(S)=0`, `S=i t` | `zeta_split.py`, `verify/independent_check.py`, `verify/positive_only_split.py` |
| rh044 | `rh044/` | smoothed partial sums `S_N^φ(1/2+it)`, the θ/functional-equation route, zero localisation | `smoothed_zeta.py`, `verify/independent_check.py` |
| rh45 | `rh45/` | the Weil explicit formula, zeros from `Z(t)`, `N(T)` by the argument principle | `explicit_formula.py` (**no log**), `verify/independent_check.py` |
| rh46 | `rh46/` | the two-point Chowla sum `S(x)=Σ_{n≤x}λ(n)λ(n+2)` | `chowla_two_point.py`, `verify/independent_check.py` |
| rh47 | `rh47/` | the greedy harmonic sine against λ-parity; the barrier probes B1/B2/B3 | `greedy_parity_probe.py`, `verify/independent_check.py` |

Each round also has a Lean layer (`<round>/lean/`, `./check.sh --all`) whose logs are
`<round>/verify/lean_check.log`; the Lean content is *theorems*, not numerics, and is
listed here only where it bounds what a numerical check can claim.

---

# rh42 — ζ-budgets and the exact reachable set

**Artefacts.**
`../../../rh42/helix_zeta.py` → [`../../../rh42/verify/helix_zeta.log`](../rounds/rh42/verify/helix_zeta.log), final line
**`ALL 80 CHECKS PASS`** (`exit=0`); reproduced bit-identically by
[`helix_zeta_rerun.log`](../rounds/rh42/verify/helix_zeta_rerun.log) (identical except the
trailing `exit=0`).
`../../../rh42/reachable.py` → [`../../../rh42/verify/reachable.log`](../rounds/rh42/verify/reachable.log), final line
**`ALL 70 CHECKS PASS`** (`exit=0`).
Lean: [`lean_check.log`](../rounds/rh42/verify/lean_check.log) — `Rh42/Reachable.lean`,
`Budget.lean`, `Tau.lean`, `Rh42.lean` all OK, `exit=0`.

**Method (one sentence).** Exact `Fraction` arithmetic and outward-rounded rational
enclosures throughout — Machin's formula for π, Euler–Maclaurin (outward rounded) for
ζ(3), `2 artanh(1/3)` for ln 2, exact enumeration of all `2^16` sub-sums at `p=2` —
with `mpmath` at **200 dps** only for the θ/heights of the helix checks.

**Headline numbers.**

Budgets `P(p)=2^{−p}ζ(p)` (even m), `N(p)=(1−2^{−p})ζ(p)−1` (odd m ≥ 3):

| p | ζ(p) | P(p) | N(p) | P+N | P−N |
|---|---|---|---|---|---|
| 2 | 1.644934067 | 0.4112335167 | 0.2337005501 | 0.6449340668 | 0.1775329666 |
| 3 | 1.202056903 | 0.1502571129 | 0.05179979026 | 0.2020569032 | 0.09845732263 |
| 4 | — | 0.06764520211 | 0.01467803160 | — | 0.05296717050 |

Identity residuals `P+N−(ζ(p)−1)` and `P−N−(1−η(p))` are `≤ 1.32e-81`
(`helix_zeta.log` §1). The alphabet's total sign sum is **`1 − ln 2 =
+0.30685281944005469058`** — the log explicitly corrects a page that prints
`ln 2 − 1 = −0.306852819440054691`.

Thresholds, each certified by a **sign change on an explicit rational bracket**
(`reachable.log` §5):

| threshold | meaning | value | bracket width |
|---|---|---|---|
| `pN` | `N(pN)=1` | 1.3777851698375411838 | 1.1e-12 |
| `pP` | `P(pP)=1` | 1.4649845878051603837 | 2.2e-12 |
| `p*` | `ζ(p*)=2` | 1.7286472389981836181 | 1.4e-13 |
| `q` | negative half complete | 2.07677517921069 | 3.4e-14 |

and `pN < pP < p* < q`. At `p*` the budget interval has length exactly 1
(`P(p*)+N(p*) = 1.00000000000013`); `P(p*) = 0.6034694993 = 2^{1−p*} < 1`, so `sin=1`
is **not** representable at `p*`.

Exact reachable sets (`reachable.log` §3–3b):

| p | reachable set | gap |
|---|---|---|
| 2 | `[0, π²/24 − 1/4] ∪ [1/4, π²/24]` = `[0, 0.161233516712] ∪ [0.25, 0.411233516712]` | `(0.161233516712, 0.25)` |
| 3 | `[0,0.0096321129] ∪ [0.015625,0.025257113] ∪ [0.125,0.13463211] ∪ [0.140625,0.15025711]` | four intervals |

`π²` was enclosed to width `5.615e-84` (Machin), `ζ(3)` to width `3.125e-18`
(Euler–Maclaurin). Census theorem `#intervals = 2^{n_min−1}`,
`measure = 2^{n_min−1} T_{n_min}` checked for `p = 1.2 … 12`; the two independent routes
agree to `3.89e-62`. Reachable fraction of the budget: `1.0` up to `p*`, then
`0.937`, `0.784`, `0.658`, `0.491`, `0.256`, `0.0528`, `0.00104` at
`p = 1.8, 2, 2.2, 2.5, 3, 4, 6`.

Helix / word facts: at 200 dps the word at `θ`, `θ+1`, `θ+2`, `1/2−θ` agrees with max
height spread `1.63e-201`; the 45° greedy support starts `{0, 3, 139, 68573}` with tail
`3.1163e-11`.

**What it establishes.**

* The budget identities to `1e-81` and the four threshold **existence-and-bracket**
  certificates: each of `pN, pP, p*, q` provably lies in the quoted interval (sign
  change + monotonicity/sign analysis on that interval).
* The **exact** reachable sets at `p=2` and `p=3` (a finite but exact statement: the
  sub-sum structure of a specific rational sequence), and the census formula
  (`#intervals`, `measure`) as a verified identity on the tested ladder of `p`.
* That the positive half is complete for `p ≤ p*` and the negative half for `p ≤ q`
  **on the tested grid and at `p*±10^{−6}, q±10^{−6}`**; the global iff is a Lean
  theorem (`Rh42/Reachable.lean`), not the numerics.
* The helix factorization `w(θ)=w(θ+1)=w(1/2−θ)` at four sampled θ, in exact
  arithmetic.

**What it does not.**

* `ALL 80 CHECKS PASS` is **80 criteria**, not 80 theorems. In particular the
  `H5` greedy-residual checks are statements about finitely many rational targets
  (e.g. `x=2/5` reaches residual `2.820e-10` after 4000 steps); they do not prove a
  rate.
* The thresholds are located only **inside their brackets**; the quoted decimals are
  the published values, and the check is that the bracket contains them — nothing is
  claimed about digits beyond the bracket.
* The `R6` monotonicity of the reachable fraction and the `R2` interval count are
  verified for `p ∈ {1.2, …, 12}`; the general statement is the census theorem in Lean.
* None of this is about the Riemann hypothesis or about primes. `p*` is a ζ-threshold
  of a representation problem, not a statement about zeros.
* The `p=1` in-budget claim (`max |residual| = 2.291e-6` for the sines tested) is
  empirical: both budgets are infinite at `p=1`, so "no target is out of budget" is
  true for the wrong reason and the residual is only observed to be small.

---

# rh43 — the balanced split at `Re(S) = 0`

**Artefacts.**
`../../../rh43/zeta_split.py` → [`../../../rh43/verify/zeta_split.log`](../rounds/rh43/verify/zeta_split.log),
final line **`64 checks pass, 0 fail`** (no `exit=` line written).
`../../../rh43/verify/independent_check.py` → [`independent_check.log`](../rounds/rh43/verify/independent_check.log),
final line **`102/102 checks pass   (elapsed 56.3 s)`**, `EXIT=0`.
`../../../rh43/verify/positive_only_split.py` → [`positive_only_split.log`](../rounds/rh43/verify/positive_only_split.log),
final line **`15 checks pass, 0 fail`**.
Lean: [`lean_check.log`](../rounds/rh43/verify/lean_check.log) — `Rh43/Balance.lean`,
`Rh43.lean` OK.

**Method (one sentence).** `mpmath` 1.3.0 at **60 dps** for the round script, and a fully
independent auditor using **exact rational interval arithmetic on scaled integers
(multiples of `2^{−320}`)**, with `TAIL = 1e-75`, Taylor remainder `1e-85`, and
root-bracket target `1e-46`.

**Headline numbers.**

`S_N(t) = Σ_{n≤N} n^{−it} = Σ_n e^{−it log n}`; the convention is `S = i t`, so
`Re S_N = Σ cos(t log n)`; balance ⇔ `P = |M|` where `P`/`M` are the sums over
`cos>0` / `cos<0`.

| N | smallest positive root of `Re S_N = 0` | digits (auditor) | round's own bracket width |
|---|---|---|---|
| 2 | `π/log 2 = 4.5323601418271938096276829457167` (exact zero) | 74 (enclosure) | exact |
| 3 | 2.42665205162968924405857564688668 | 47 | 2.84e-16 |
| 4 | 1.85039292764260780631379556995417 | 47 | 3.47e-21 |
| 5 | 1.55009817600781349235317852292262 | 47 | 3.47e-21 |
| 6 | 1.36250808733474170983371419814076 | 47 | 3.47e-21 |
| 8 | 1.13684395014600383257874781653817 | 47 | 3.47e-21 |
| 12 | 0.91319827876062629357124803935550 | 47 | 3.47e-21 |
| 20 | 0.72461569909908482871273815855624 | 47 | 1.16e-13 |
| 50 | 0.52144338691777468350280721800959 | 47 | 1.22e-07 |

The auditor's `0.72461569909908483` and `0.52144338691777468` lie **inside** the round's
own (coarser) brackets `[0.724615699099028, 0.724615699099144]` and
`[0.521443359375, 0.521443481445]`: the two **agree**, they do not disagree.

Rational witnesses (`independent_check.log` C2): `f(5/2) = −0.0843357582984253225…`,
`f(12/5) = +0.0321644000045122068…`, `f(49/20) = −0.0275201407947055668…`, all with
enclosures `≈5e-74` wide. These are the Lean proofs' inputs.

Balanced partitions (C4): at `N=3` the positive set is `{1}`, negative `{2,3}`,
`P=|M|=1`; at `N=12`, `{1,…,5}` vs `{6,…,12}`, `P=|M|=2.7448557107742332447`.

Imaginary-part split (C7): `Im S_N = 0` has a different smallest root — `N=3` gives
`3.50671248852758994823819331613312 = 2π/log 6`, versus `2.426652…` for the Re split.
`N=1`: `Im S_1 ≡ 0` identically, so `N=1` is "balanced" for every `t` (degenerate).

Positive-only problem (`positive_only_split.log`): the top-level criterion `P ≥ 2`
holds in every tested case (`N=20…800`); **exact** two-subset equality always fails at
the last term by Brown's criterion, and the greedy defect shrinks with the number of
positive terms:

| N | #pos | P | greedy defect |
|---|---|---|---|
| 200 | 93 | 30.089652 | 0.003643 |
| 400 | 293 | 190.409 | 0.0001029 |
| 800 | 693 | 573.63405 | 0.0001514 |

**What it establishes.**

* Certified brackets for the ten listed Re-roots, each with the two ingredients that
  make it a *smallest positive* root: `Re S_N ≠ 0` on `[0, s_lo]` (certified minimum)
  and constant sign of the slope on `[s_lo, b]`. For `N=3` the non-vanishing of
  `S_3` for **all** `t` is a genuine proof (irrationality of `log 3/log 2`).
* Three **refutations** of the round's own stated claims, with certificates:
  * **C3 `N=2` "no root" — REFUTED.** `Re S_2(t) = 1 + cos(t log 2) ≥ 0` with
    tangential zeros, and `S_2` vanishes **exactly** at `t=(2k+1)π/log 2`.
  * **C5 "no exact complex vanishing for `N ≤ 6`" — REFUTED** by `N=2`
    (`S_2(π/log2) = 1 + e^{−iπ} = 0` exactly).
  * **C6 "`N^{1/2}`-ish growth" — REFUTED.** With the rigorous first-order
    Euler-summation lower bound
    `|S_N(t)| ≥ N/√(1+t²) − (|t|/2)log N − (1/√(1+t²)+1) → ∞`, growth is **linear**:
    certified exponents `0.986434` (`t=1`), `1.061003` (`t=14.134…`), `1.000126`
    (C1 root); `|S_N|/N → 1/√(1+t²)` with max deviation `5.44e-07` at `N=10^6`.
* The convention-dependence of "balanced": the Re-split and the Im-split solve
  *different* equations and have different roots.

**What it does not.**

* **C5 for `N = 4, 5, 6` is PARTIAL**, and says so. Only certified *lower bounds* on
  the window `[0,15]` are offered (`|S_4| > 3.0779e-1`, `|S_5| > 2.1911e-3`,
  `|S_6| > 7.7536e-4`); the grid minima on `[0,60]` are explicitly labelled "NOT a
  lower bound", and no non-vanishing proof over all `t` exists.
* The root brackets certify existence and uniqueness **inside the bracket**, not the
  global absence of other roots (the two-part certificate closes that for the listed
  `N`, but only because `f` is shown positive left of the bracket and monotone inside).
* The balanced split is **not** a partition of the terms: at `N=3` the positive side
  has one term, so no two-subset split exists; at `N=6` the positive terms miss `P/2`
  by `0.169962576380678` and the negative by `0.065392329418967`. What exists is two
  equal *numbers* `P/2, P/2` (and `M/2, M/2`), not two equal subsets.
* `N ≥ 51` is not certified; the "balanced partial sum exists for every `N ≥ 3`" is a
  Lean theorem (`Rh43/Balance.lean`), with the numerics as illustration.
* Nothing here concerns RH: `Re(S) = 0` is far outside the half-plane of convergence,
  so divergence of `S_N` is expected.

---

# rh044 — smoothing laws and the θ / functional-equation route

**Artefacts.**
`../../../rh044/smoothed_zeta.py` → [`../../../rh044/verify/smoothed_zeta.log`](../rounds/rh044/verify/smoothed_zeta.log),
final line **`59 checks pass, 0 fail`** (total wall `302.5 s`).
`../../../rh044/verify/independent_check.py` → [`independent_check.log`](../rounds/rh044/verify/independent_check.log),
final line **`43/43 auditor checks pass`**, `EXIT_CODE=0`; its verdict block records
**3 of 5 round claims REFUTED as stated, 2 verified**.
Lean: [`lean_check.log`](../rounds/rh044/verify/lean_check.log) — `Rh044/Smoothing.lean`,
`Rh044.lean` OK.

**Method (one sentence).** `mpmath` 1.3.0 at the **dps reported with every claim** —
60 dps for §§1–2, 120 dps for the round's θ route, 160 dps for the auditor's — with
exact Euler–Maclaurin constants, and the auditor rebuilding the incomplete `Γ` by its
own series **and** its own quadrature (mutual agreement to `2.65e-163`) and the θ
integral by its own quadrature (agreement to `1.83e-69`).

**Headline numbers.**

T1 — sharp cutoff. `|S_N(1/2+it) − ζ(1/2+it)|/√N → 1/√(1/4+t²) = 1/|s−1|`:

| t | exact constant C | brief's `1/√(2t)` | ratio | observed at `N=102400` | ratio obs/C |
|---|---|---|---|---|---|
| 14.134725141734693 | 0.0707035277318122 | 0.1880794379435 | 2.6601139 | 0.0707037004038 | 1.0000024422 |
| 21.022039638771555 | 0.0475556741610922 | 0.154222442448529 | 3.2429872 | 0.0475557903472 | 1.0000024432 |
| 10.0 | 0.0998752338877845 | 0.223606797749979 | 2.2388613 | 0.0998754777633 | 1.0000024431 |

Fitted slopes of `log|S_N−ζ|` vs `log N`: `0.49968393` over all `N` (`1e2…1.024e5`),
`0.49995164` for `N ≥ 1000`. The next Euler–Maclaurin orders are confirmed:
`|R_1|√N = 0.4999995932 → 1/2`, `|R_2| N^{3/2} = 1.178630488 → |s|/12 = 1.178630487`.

T2 — smoothing. Master law
`S_N^φ − ζ = N^{1−s} J(φ) + φ(0)ζ(s) + R_N`, `J(φ)=∫_0^1 φ(u)u^{−s}du`, `R_N=O(N^{−σ})`:

| weight φ | φ(0) | φ(1) | `\|J\|` (predicted `\|E\|/√N`) | observed at `N=102400` | residual slope |
|---|---|---|---|---|---|
| sharp `1` | 1 | 1 | 0.0707035277318 | 0.0707037004038 | −0.499989 |
| `e^{−u}` (to N) | 1 | 0.3679 | 0.0261423776999 | 0.0261423115614 | −0.486895 |
| raised cos `(1−cos 2πu)/2` | 0 | 0 | 0.00797298346237 | 0.00797298346841 | **−2.0** |
| `u(1−u)` | 0 | 0 | 0.00490122433646 | 0.00490126062799 | **−0.999426** |
| `(u(1−u))³` | 0 | 0 | 0.000117718448844 | 0.000117718448844 | **−3.00351** |
| `e^{−u}` to convergence | — | — | `\|Γ(1−s)\| = 5.708835887e-10 = √(π/cosh πt)` | — | −0.998519 |

Verdicts printed in the log:
**(a) "the `O(√N)` fluctuation is removed by every weight with `φ(1)=0`" → REFUTED**
(witness `u(1−u)`: `|E|(1.024e5)/|E|(400) = 16.4666` vs a `√N` factor `16.0`);
**(b) "the residual is `O(N^{−σ})` with a weight-dependent constant" → VERIFIED**,
with the sharper observed rates tabulated above.

T3 — θ / functional equation. The corrected identity
`π^{−s/2}Γ(s/2)ζ(s) = 1/(s(s−1)) + ½[A(s)+A(1−s)]`,
`A(s)=∫_1^∞ x^{s/2−1}(θ(x)−1)dx`, reproduces ζ at the tested points:

| s | `\|ζ_θ(s) − ζ(s)\|` (round, X=40) | auditor (own θ route, X=34) |
|---|---|---|
| 2 | 2.6708e-55 | 5.679e-69 (series remainder bound 5.707e-69) |
| 4 | 3.3698e-53 | 1.784e-68 (bound 1.793e-68) |
| ½ + i·14.134725141734693 | 3.3105e-52 | 1.035e-64 (bound 1.042e-64) |
| ½ + i·21.022039638771555 | 6.0056e-50 | — |
| ½ + i·25.010857580145688 | 2.2357e-48 | — |

Rigorous tail: `X_min = 25` for a bound `< 1e-30`; the script uses `X=40`; self-consistency
`X=30` vs `X=50` differs by `1.7238e-38`. The brief's stated formula was tested and
fails at `s=2` by `|brief − ζ(2)| = 0.0977365` (`smoothed_zeta.log`; independently
`|diff| = 0.09774`, `0.4463` at `s=4`, `0.1417` at the zero, in
`rh044/verify/independent_check.log`).

T4 — zeros.

| k | `mp.zetazero` (60 dps) | located from `Re ζ(½+it)` | `\|root − zetazero\|` | `\|ζ\|` at root |
|---|---|---|---|---|
| 1 | 14.1347251417346937904572519836 | 14.1347251417346937904572519836 | 3.8e-34 | 3.0e-34 |
| 2 | 21.0220396387715549926284795939 | (same) | 2.3e-33 | 2.7e-33 |
| 3 | 25.0108575801456887632137909926 | (same) | 3.7e-33 | 5.0e-33 |
| 4 | 30.4248761258595132103118975306 | (same) | 3.3e-34 | 4.3e-34 |
| 5 | 32.9350615877391896906623689641 | (same) | 3.3e-33 | 4.6e-33 |

Auditor's independent `Z(t)` route reproduces all five to **≥25 digits** (identical to
every printed digit, so agreement is `0.0` at the `1e-44` bisection floor).
Sharp partial-sum roots are *not* zeta zeros: first roots `0.3039896294` (`N=1e3`),
`0.2137236687` (`1e4`), `0.1637436299` (`1e5`), counts in `(0,35)` `60/102/128` against
the density model `log N/π = 77.0/102.6/128.3`; `t_first·log N = 2.099886, 1.968468,
1.885168 → π/2`.

Null counting (`independent_check.log` C5): `N(30) = 3`; Riemann–von Mangoldt main term
`(T/2π)log(T/2πe) + 7/8 = 3.56465638149708`, differing by `−0.564656 = S(30)/π`. The
round's `theta(T)/π + 1` form gives `3.56487744436142`; the five zeros lie in
`(14,15),(21,22),(25,26),(30,31),(32,33)`.

**What it establishes.**

* The **corrected constants and laws**, with rigorous upper bounds for the refutations:
  the brief's limit `1` is impossible because `|S_N−ζ|√(2t)/√N ≤ 0.3760035107` at
  `N=1e5` (an a-priori Euler–Maclaurin bound); the brief's θ formula is algebraically
  wrong and was re-derived; `|Γ(1−s)| = √(π/cosh πt)` is confirmed to 10 digits.
* That the smoothed `|E|√N` is **unbounded** over `N=1e2…1e5` for all six weights
  (max `7070.37` sharp, `2614.23` for `e^{−u}`, `11.7718` for `(u(1−u))³`), and that
  the local log-log exponent is `+0.5` for every weight in the last decade — smoothing
  rescales the constant, it does not remove the term.
* The auditor's θ identity is verified **without `mpmath`'s `zeta` and without
  `mpmath`'s incomplete Γ**: own series, own quadrature, mutual agreement `1.8e-69`,
  series tail bound `5.7e-69`.
* Five zeros to ≥25 digits from two routes (one of which uses no `mp.zetazero`).

**What it does not.**

* "`|E|/√N → |J(φ)|`" is a **finite-range** statement; the fitted slopes (`0.4997`,
  `0.5125`, …) are 12-point descriptions. The exact leading law comes from the
  Abel/Euler–Maclaurin derivation, not from the fit.
* The §2(a) refutation is a finite witness (`N=400` vs `N=1.024e5`); it shows the
  `√N` term has not disappeared over that range, not that it never can.
* Only the **θ / functional-equation route** reaches `o(N^{−A})` for all `A`
  (error `e^{−πX}`) — and that route *uses* the functional equation, i.e. it is not a
  smoothing trick. No `φ` of the tested family gives `o(1)`.
* In the round's own script the T4 reference is `mp.zetazero`, so the "agreement" is a
  self-consistency check; the genuinely independent zero evidence is the auditor's
  `Z(t)` route.
* The `model count 76` at `N=1000` in T4(ii) does **not** match the observed 60; the
  check passes on stability of the count under grid refinement (`0.05` vs `0.02`) and
  on the grid minimum exceeding the rounding bound, not on the model.
* Nothing here about RH; locating zeros is not a statement about where they all are.

---

# rh45 — the explicit formula, zeros, and counts

**Artefacts.**
`../../../rh45/explicit_formula.py` → **the intended log
`../../../rh45/verify/explicit_formula.log` DOES NOT EXIST.** The script's header says
`Run: python3 -u explicit_formula.py > verify/explicit_formula.log 2>&1`; no such file
is present in `rh45/verify/`, and `rh45/truths.md` records that the run was
**interrupted**. All rh45 numbers below therefore come from the auditor.
`../../../rh45/verify/independent_check.py` → [`independent_check.log`](../rounds/rh45/verify/independent_check.log),
final line **`FINAL: 19/21 checks pass   (t=307.2s)`**.
Lean: [`lean_check.log`](../rounds/rh45/verify/lean_check.log) — `Rh45/Explicit.lean`,
`Rh45.lean` OK.

**Method (one sentence).** `mpmath` 1.3.0 with a zero table from `mp.zetazero` (`K=100`,
`γ_100 = 236.524229666`), primes `≤ 2·10^6` (`148933` of them; `149235` prime-power
entries), explicit `Λ` sieve, digamma quadrature for the archimedean term, and an
argument-principle contour integral of `ζ'/ζ` for the counts.

**Headline numbers.**

Corrected Weil explicit formula
`Σ_ρ Φ(ρ) = Φ(1)+Φ(0) − Σ_{n≥2} Λ(n)/√n [g(log n)+g(−log n)] + (1/2π)∫_ℝ φ(t)Ψ(t)dt`,
`Ψ(t) = −log π + Re ψ(1/4+it/2)`, `Φ(1)+Φ(0) = 2φ(i/2)` for even `g`:

| kernel | LHS | RHS − LHS | truncation bound |
|---|---|---|---|
| Gaussian `φ=e^{−t²/2}` | 8.2619765949e-44 | 1.56477e-44 | zero 3.18799e-12151, prime 2.27964e-43 |
| modulated Gaussian (`θ=γ₁`) | 1.0000000000500724334 | 9.63025e-46 | zero 5.88835e-10743 |
| narrow Gaussian (`σ=¼`) | 0.00388829070707166133 | −1.10094e-63 | zero 2.6715589e-761 |
| Cauchy companion `a=1` | 0.12539427897704363758 | +0.01870876736 | density estimate 0.01189760566 (≈2 digits only) |

Falsification of the round's naive normalisation (C1d/Gaussian): literal
`RHS − LHS = 0.536580471657` (reading A) and `1.57877108264` (reading B), decomposing as
pole-argument error `F(1)+F(0) − 2φ(i/2) = −0.65976624642101921005` plus missing
archimedean `−1.1963467180780578254`. The Cauchy `a=1/2` kernel is
**REFUTED as stated**: the stated `(F,g)` is off by `2/π`; the pole part `π(U+1)` and
the prime sum `π Σ_{n≤N} Λ(n)/n = π log N − πγ + o(1)` both diverge like `π log N`,
cancelling to `π(1+γ) = 4.954969146` (measured `4.960586862, 4.950210887, 4.953233872,
4.956233204` at `N=10^3…10^6`); the zero side converges only like `log G/G`
(density estimate `0.0059488263` at `G=236.524`), so 20 digits would need `G ~ 10^21`.

Zeros (own `Z(t)` route, no `mp.zetazero`):

| k | value | agreement with reference |
|---|---|---|
| 1 | 14.134725141734693790457251983562 | 2.708e-34 (33.567 digits) |
| 2 | 21.022039638771554992628479593897 | 2.777e-33 (32.556) |
| 3 | 25.010857580145688763213790992563 | 1.819e-33 (32.740) |
| 4 | 30.424876125859513210311897530584 | 1.320e-33 (32.879) |
| 5 | 32.935061587739189690662368964075 | 3.489e-33 (32.457) |

`|Im(e^{iθ}ζ)| ≤ 9.42e-87` at the located zeros. Counts by contour integral of `ζ'/ζ`:
`N(T) = 1, 10, 29` at `T = 20, 50, 100`, equal to the `mp.zetazero` counts (differences
`0`, `7.3e-42`, `3.1e-28`). Exact counting identity `N(T) = θ(T)/π + 1 + S(T)` verified
to `2.3e-41`; asymptotic residual `= 1/(48πT)(1 + O(1/T²))` (at `T=100`:
`6.6315e-5` vs `1/(48πT) = 6.6315e-5`).

Cost of the partial-sum route (C4.1, **REFUTED**): `Re S_N(1/2+it_1)` has **no** sign
change within `±10^{−3}` of `t_1` for `N ∈ {10^3,10^4,10^5,10^6}`; the values
`0.644382, 6.986419, 12.538622, 36.051590` **grow** like `≈0.04√N`. The suggested
`N ≳ T² = 200` is far too optimistic.

Parity data (C5):

| quantity | value |
|---|---|
| `λ(n)` over `n ≤ 2·10^6` | `+1`: 999382; `−1`: 1000617; ratio 0.998766 |
| twin primes `(n,n+2) ≤ 2·10^6` | 14871, **all** with `λ(n)=λ(n+2)=−1` (0 of the `+1` class) |
| pair patterns `(λ(n),λ(n+2))`, all `n` | `(+,+)` 499148, `(+,−)` 500234, `(−,+)` 500235, `(−,−)` 500381; same/mixed ratio 0.999060 |
| `Σ_{n≤2·10^6} λ(n)λ(n+2)` | `−940 = −4.700e-04 · x` |
| coprime-to-`p≤100` survivors `n≤2e6` | 38523; `λ=+1` 14688 vs `λ=−1` 23835 (ratio 0.616237), of which 23792 (61.8 %) are prime |

**What it establishes.**

* The corrected explicit-formula convention, verified on four kernels to 44–63 digits
  (the Cauchy companion only to ~2 digits, honestly labelled).
* Two rigorous **refutations**: the naive normalisation is wrong (decomposition given),
  and the `a=1/2` Cauchy kernel cannot be verified as stated (the divergence
  computation is exact).
* Five zeros to 32–33 digits and `N(20), N(50), N(100)` by an independent
  argument-principle route — this is genuine route independence (no `mp.zetazero` for
  locating; the reference table is used only for comparison).
* `N ≳ T²` for resolving `γ₁` is refuted: the sharp Dirichlet partial sum gets *worse*
  as `N` grows on `Re s = ½`.

**What it does not.**

* The explicit formula is a known theorem; the numerics confirm the implementation and
  fix the convention. They say nothing about RH.
* The Gaussian LHS is `~1e-44`, so those kernels check `0 = 0`; only the modulated
  Gaussian has an `O(1)` LHS. rh45's own open list records that an admissible kernel
  with `O(1)` LHS **and** rapidly convergent zero side is still missing.
* C4.1's refutation is a non-detection at four values of `N`; it refutes the specific
  cost estimate, and shows the quantity diverges, but is not a theorem about all `N`.
* C5's twin-prime row is **forced by primality** (`Ω=1` → `λ=−1`), not evidence about
  primes; the coprime-survivor imbalance is prime domination, and the log says so.
* The parity data are a finite census. `Σλ(n)λ(n+2) = −940` at `2·10^6` is a finite
  value and says nothing about the limit.

---

# rh46 — the two-point Chowla sum `Σ_{n≤x} λ(n)λ(n+2)`

**Artefacts.**
`../../../rh46/chowla_two_point.py` → [`../../../rh46/verify/chowla_two_point.log`](../rounds/rh46/verify/chowla_two_point.log),
final line **`30 checks pass, 0 fail   (wall clock 262.5s)`**;
[`exit_code.txt`](../rounds/rh46/verify/exit_code.txt) = `EXIT_CODE=0`.
Reproduced by [`chowla_two_point.repro1.log`](../rounds/rh46/verify/chowla_two_point.repro1.log)
(**`30 checks pass, 0 fail`, wall 264.1 s**); the two logs agree on every `S` value
across the whole `10^9` ladder — only timings and one prose paragraph differ.
`../../../rh46/verify/independent_check.py` → [`independent_check.log`](../rounds/rh46/verify/independent_check.log),
final line **`FINAL: 25/26 checks pass   (t=32.5s)`** — the single FAIL is the
reconnaissance cross-check (see *Corrections*).
Lean: [`lean_check.log`](../rounds/rh46/verify/lean_check.log) — `Rh46/Chowla.lean` and
`Rh46.lean` OK (linter warnings only).

**Method (one sentence).** A segmented `Ω`-sieve, window `BLOCK=10^7`, int64 exact
sums (no array of size `x`), `λ(n) = (−1)^{Ω(n)}` exact on every `n`; the auditor
implements **three unrelated `λ` algorithms** — a segmented trial-division sieve, an
additive prime-power sieve (`Ω = Σ_{p^k|n} 1`), and pure-Python factorization — and
cross-checks them exactly (`0` mismatches on `[1,10^8+2]` for the first two, spot
checks at `10^7`, `10^8` for the third).

**Headline numbers.**

`S(x) = Σ_{n≤x} λ(n)λ(n+2)` (exact integers; `chowla_two_point.log` SS1 and
`verify/independent_check.log` §3):

| x | 10¹ | 10² | 10³ | 10⁴ | 10⁵ | 10⁶ | 10⁷ | 10⁸ | 10⁹ |
|---|---|---|---|---|---|---|---|---|---|
| `S(x)` | −4 | −2 | −30 | 12 | 258 | 68 | **1246** | 4632 | 43790 |
| `S(x)/x` | −0.4 | −0.02 | −0.03 | 1.2e-3 | 2.58e-3 | 6.8e-5 | 1.246e-4 | 4.632e-5 | 4.379e-5 |
| `max_{x'≤x}\|S\|` | 4 | 8 | 30 | 73 | 282 | 689 | 3059 | 6454 | 48700 |
| `max\|S\|/√x` | 1.2649 | 0.8000 | 0.9487 | 0.7300 | 0.8918 | 0.6890 | 0.9673 | 0.6454 | 1.5400 |

The `10^9` ladder checkpoints (round log, exact): `10^8: 4632`, `2·10^8: −4740`,
`3·10^8: 1364`, `4·10^8: 17656`, `5·10^8: 37082`, `6·10^8: 43200`, `7·10^8: 32784`,
`8·10^8: 30480`, `9·10^8: 35402`, `10^9: 43790`.
Argmaxima (auditor): `max|S| = 3059` at `x = 8572105` for `x ≤ 10^7`;
`max|S| = 6454` at `x = 66967578` for `x ≤ 10^8`.

Growth fits — **two fits that disagree**, as they should for a running maximum:

| source | range | exponent | other |
|---|---|---|---|
| round `chowla_two_point.log` | `10^3…10^9` (7 points, 6 decades) | `α = 0.5200 ± 0.0249` | `b = −0.4038`, rms 0.2562 |
| auditor `independent_check.log` | `10^3…10^8` | `θ = 0.4834 ± 0.0186` | `C = 0.9896`, `R² = 0.9941`, local exponents `0.386, 0.587, 0.388, 0.647, 0.324` |

Logarithmic average `L_h(x) = (1/log x) Σ_{n≤x} λ(n)λ(n+h)/n` (float64, worst-case
rounding bound `2.2e-7`; validated against mpmath 40 dps at `x=10^4`, `|diff| ≤ 1.11e-16`):

| x | 10⁵ | 10⁶ | 10⁷ | 10⁸ | 10⁹ |
|---|---|---|---|---|---|
| `L_2(x)` | −0.1176306913 | −0.0981590430 | −0.0841484884 | −0.0736344098 | −0.0654503824 |
| `L_1(x)` | −0.0728106641 | −0.0610076728 | −0.0522652492 | −0.0457360136 | −0.0406543156 |

Weighted sums settle: `W_2 → ≈ −1.3563` (`c₂ = −1.35557853`), `W_1 → ≈ −0.8425`
(`c₁ = −0.84110811`); `1/log x` fits have relative residuals `9.64e-04` (h=2) and
`3.39e-03` (h=1); the auditor fits `θ = 0.9931 ± 0.0026` and `0.9968 ± 0.0014`, i.e.
`H(x) = O(1)`.

SS4 (the logical core). With `X = 10^4`, `A± = {n > X+2 : 4|n, f(n)=f(n−2)=∓1}` where
`f(n)=λ(n)λ(n+2)`, and `λ± = −λ` on `A±`:

* `λ, λ+, λ−` agree on **every** `n ≤ 10^4` (`0` differences; first flip index `10012`),
  and `S(x)=S+(x)=S−(x)` for every `x ≤ 10^4`;
* the identity `S±(x) − S(x) = ±4·#{n ∈ A± : n ≤ x} ± 2ε`, `ε ∈ {0,1}`, holds **exactly**
  at every `x ≤ 10^7`;
* at `x = 10^7`: `S+(x)/x = 0.25002` (density of `A+` is `0.06248`, `4× = 0.24990`),
  `S−(x)/x = −0.24969`, while `S(x)/x = 1.246e-4`. The naive control
  `A0 = {4|n, n>X}` gives `S0(x)/x = 0.000211` — **not** a witness.
* Auditor's strongest form: `λ'' = λ` on `[1,10^8]`, `≡ 1` beyond ⇒ `S''(x)=S(x)` for all
  `x ≤ 10^8−2` (**0 of 99 999 998 prefixes differ**), yet `S''(10^8) = 4634` vs
  `S(10^8)=4632` and `S''(x)/x → 1` (`0.99999900` at `10^{12}`).

SS5 (why the analytic route is unavailable). `f(n)=λ(n)λ(n+2)` is **not multiplicative**
(`f(1) = −1 ≠ 1`; `f(2)f(11) = −1 ≠ f(22)=1`; `f(2)f(13)=1 ≠ f(26)=−1`), and at `s=2`:

| quantity | value |
|---|---|
| `D(2) = Σ_{n≤10^6} f(n)/n²` | −1.12681304 |
| naive product `Π_{p≤10^5}(1 + Σ_k f(p^k)p^{−2k})` | 0.88759631 |
| `\|D(2) − product\|` | 2.01440934 |
| round's stated product tail bound | 1.80898647 |
| **correct** tight tail bound | ≈ **1.84e-05** (n-tail `2e-6` + p-tail `1.645e-5` + k-tail `1e-9`) |

**What it establishes.**

* The exact values of `S(x)` at the nine checkpoints up to `10^9`, and their running
  maxima — **that, and nothing about the limit**.
* A finite check of an *unconditional theorem* (Tao 2015, logarithmic Chowla, fixed
  shift): `|L_h|` decreases at every grid step and `|L_h|·log x` is nearly constant.
* The **finite-prefix indeterminacy** (SS4/A1) is the round's real logical result: it is
  an exact construction, verified on 99 999 998 prefixes, showing that the entire
  computed dataset is equally consistent with `S(x)=o(x)` and with `S(x) ~ x`.
* The negative algebraic fact that the Euler-product/`ζ` route does not apply, verified
  numerically with a rigorous tail bound.

**What it does not.**

* `(★) Σ_{n≤x}λ(n)λ(n+2) = o(x)` is **OPEN**. The script's own banner says so before
  any number; the `10^9` table is consistent with `(★)` and is **not evidence for it**,
  because SS4 constructs sequences with the same prefix and `S(x)/x → 1/4`.
* `α = 0.5200 ± 0.0249` is the exponent of a **running maximum** over 7 points; a
  running maximum is biased upward and can only grow, and a finite fit cannot exclude a
  later excursion. The two independent fits (`0.5200` vs `0.4834`) differ by more than
  their nominal errors, and the local exponents span `0.32–0.65` — **the exponent is
  not resolved**.
* `30 checks pass` are 30 criteria; most are self-consistency (sieve vs reference,
  flat vs streamed, weighted vs flat). The only unconditional content is the
  logarithmic average of a known theorem.
* The "RH-conditional `x^{1/2+ε}`" reading is **WITHDRAWN** (auditor check B4): since
  `n ↦ λ(n)λ(n+2)` is not multiplicative, no Euler product exists, and no standard
  theorem derives the bound from RH.
* The quoted sparse-modification bound is **false** — see *Corrections*.

---

# rh47 — the greedy harmonic sine against λ-parity (the barrier probes)

**Artefacts.**
`../../../rh47/greedy_parity_probe.py` → [`../../../rh47/verify/greedy_parity_probe.log`](../rounds/rh47/verify/greedy_parity_probe.log)
(byte-identical copy at `greedy_parity_probe.stdout`). **The log contains two
concatenated runs**, see *Corrections*:
* a superseded block ending **`21 checks pass, 1 fail   (wall clock 26491.0s)`**, and
* the current summary **`23 checks pass, 0 fail   (wall clock 3.5 s)`** — confirmed by
  re-running the on-disk script in a scratch copy (output `23 checks pass, 0 fail`,
  `wall clock 3.0s`, `EXIT=0`).
`../../../rh47/verify/independent_check.py` → [`independent_check.log`](../rounds/rh47/verify/independent_check.log),
final lines **`RESULT: 31/31 checks pass`**, `elapsed: 38.8s`.
`../../../rh47/verify/_draft_probe_03h56.py.bak` is an earlier draft scaffold (it
contains no `CHK.check` calls).
Lean: **none** — `rh47/lean/Rh47/` is **empty**, there is no `rh47/verify/lean_check.log`,
and the auditor says so explicitly ("no rh47 Lean statement").

**Method (one sentence).** Exact `Fraction` greedy/`ceil`-chain supports cross-checked
against the literal step-by-step rule; big-integer Sylvester sequence to `s_21`; exact
`λ`/`Ω` sieve to `10^7` with tier-B `λ` from exact factorization (Pollard–Brent,
elements `≤ 10^{13}`); the statistics use a seeded Monte-Carlo size/range control
(`R=500`, `SEED=47`) plus a positional (sign-permutation) pool and a rank-matched slot
pool. The auditor repeats everything with its own `λ` and a 2000-replicate global
permutation null.

**Headline numbers.**

The Sylvester-sparsity theorem (the round's one new exhaustive statement):
`m_{i+1} ≥ m_i(m_i−1)+1`, **0 violations in 53 159 consecutive pairs over 20 320
supports**. Consequences: `|A| ≥ 20 ⇒ max A ≥ s_20`, which has **106 721 decimal
digits** (`s_6 = 3263443`; `s_7 = 10650056950807` has 14 digits; `s_8` has 27). The
ladder `x_k = (s_{k+1}−2)/(s_{k+1}−1)` realises `|A| = k` exactly, so the size class is
non-empty but uncomputable.

Specified-test domain: `|A| ≥ 20` selects **0** of the 19 900 targets with denominator
`≤ 200` (max `|A| = 11`) and **0** of the 400 random large-denominator targets
(max `|A| = 18`) — 100 % of a natural exact sample is dropped. Supports with `|A| ≥ 4`
in sample A: 9435.

Relaxed diagnostic (`|A| ≥ 4`, elements `≤ 10^{13}`; **8 820 targets**, tier A 6461 with
`max A ≤ 10^7`, tier B 2359; sizes `{4:5762, 5:2580, 6:478}`; 1015 supports excluded by
the factorability rule). All statistics are in λ-mean units (`= 2·N+/|A| − 1`):

| statistic | value | reading |
|---|---|---|
| mean λ over `A(x)` | −0.300635 | observed support mean |
| C0 range-matched baseline `μ₀` | −0.009552 | exact λ density over `[2,max A]` |
| pooled `z` vs C0 | **−47.9170** (p ≈ 0) | large **nominal** deviation |
| positional (sign-permutation) control C1 | `z = +0.4342` (p = 0.664) | nominal signal killed |
| rank-matched slot control C2 | `z = +1.5484` (p = 0.122) | nominal signal killed |
| per-target `p < 0.05` vs C2 | 0.024 (nominal 0.05) | no excess |
| targets with `\|resid/sd\| ≥ 3` | 4 of 8820 (chance ≈ 24) | none survives |

Why the nominal `z` is meaningless: the 8 820 supports use only **7 033 distinct
positions**; `m = 2` occurs in **70.5 %** of them. The eight most frequent positions
carry 15 915 of 38 816 occurrences, so the statistic is a statement about
`λ(2)=λ(3)=λ(7)=λ(8)=−1`, `λ(4)=+1`. The largest slot-controlled residual is
`x = 30/103`, `A = [4, 25, 793, 907545, 1482547361100]`, `resid/sd = 3.048`.

B2 — the ζ-budgets are **index-parity** objects. The `2×2` table at `N=10^7`:

| | Ω even | Ω odd | total |
|---|---|---|---|
| n even | 2 501 146 | 2 498 854 | 5 000 000 |
| n odd | 2 498 433 | 2 501 567 | 5 000 000 |

independence expectation `2 499 789.5`; `χ²(1) = 2.9441`, `z = 0.9905`;
`#{n ≤ N : index parity ≠ Ω parity} = 4 997 287 = 0.4997 N`;
`Σ_{n≤N} λ(n)(−1)^n = 5426` (`5.43e-4·N`). The auditor strengthens this with **twist
invariance**: `Σ λ(n)(−1)^n · λ(n+2)(−1)^{n+2} = Σ λ(n)λ(n+2)` **exactly** (0
mismatches on `10^6`), so index parity is invisible to the correlation itself. Auditor's
`|S12(N)| = |Σ(−1)^n λ(n)|`: `464` at `10^5`, `1302` at `10^6`, log-log slope `0.464`
(consistent with `½`, not `1`).

B3 — `f(n) = λ(n)λ(n+2)` is **not multiplicative** and has **no Euler product**:
`f(1) = −1`; coprime witnesses `f(2)f(11) = −1 ≠ f(22) = 1`,
`f(2)f(13) = 1 ≠ f(26) = −1`, `f(3)f(5) = 1 ≠ f(15) = −1` (12 016 failing coprime pairs
`a,b ≤ 200, ab ≤ 10^6`). At `s=2`: `D(2) = −1.1268130386`,
`Π = 0.8875735163`, `|D(2) − Π| = 2.0143865549` against a rigorous total tail
`n-tail 2.0000e-06 + p-tail 1.6449e-05 + k-tail 1.0000e-09 = 1.8450e-05` — the
discrepancy exceeds the tail by a factor **109 178**.

The auditor's non-trivial constructions (C3a): a prime-indexed alphabet
`α_p = (−1)^{Ω(p+2)}/(p+2)` gives `z = +10.1` — but `import = mean(sign·λ) = 1.0000`,
i.e. the alphabet literally *contains the target function*; the same take rule with
permuted signs is null (`+0.0192 ± 0.0968`). `(−1)^{ω(q)}` gives `import = 0.6272`,
`z = +6.3` (a weaker import of the same parity). So the non-nullity lives in the
**alphabet**, not in the greedy dynamics — a circularity witness.

The greedy support has **zero density**: mean `|A| = 2.95, 3.25, 3.60, 3.90` for
`N = 10^2…10^5`, i.e. density `3.9e-05`.

**What it establishes.**

* The **Sylvester-sparsity ceiling is a proof** (the rigidity lemma), and it is the only
  logically exhaustive statement in the round. It is a statement about the greedy
  object, not about primes.
* The specified SS2 test (`|A| ≥ 20` and every element factorable) has an **empty
  computable domain** — demonstrated, not speculated.
* In the relaxed regime, **no parity signal survives size-matched, positional and
  rank-matched controls** — a finite, honestly low-power null.
* B2's strengthening is an exact identity (twist invariance), so even perfect
  index-parity knowledge cannot move `Σλ(n)λ(n+2)`.
* B3's no-Euler-product verdict is a finite algebraic fact with a rigorous tail.

**What it does not.**

* **No progress on the twin-prime conjecture, the parity problem, or
  `Σλ(n)λ(n+2)=o(x)`.** The script's banner states this before any number, and the
  auditor's verdict repeats it.
* The `|A| ≥ 4` diagnostic is **below the specified threshold** and has low power:
  the auditor's word statistics rest on only 163 support terms over 40 words × `10^5`
  indices (pooled `z = −1.68, −0.72, +1.37, −0.74`; per-target `max|z| ≤ 2.42`).
  A null with low power is not evidence of absence in general.
* The barrier itself is a **HEURISTIC**, not a theorem. The auditor records: the proved
  legs are budget sign-blindness (plus twist invariance) and the Euler-product failure;
  "the two do not mix" is not established. The phrase "every greedy-sine object is an
  additive character in `log n`" is **imprecise and too wide** (rh47/truths.md §3).
* The Sylvester ceiling says a large-support target is uncomputable, not that no
  parity signal could exist in principle.
* `rh47` has **no Lean layer**; `rh47/lean/Rh47/` is empty. The only formal layer in the
  round is the inherited, separately certified rh46 development.

---

# Cross-checking: what was reproduced, and by which independent route

| result | primary source | independent route | outcome |
|---|---|---|---|
| rh42 budgets, thresholds, reachable sets | `rh42/helix_zeta.py`, `reachable.py` | the round's own rerun (`helix_zeta_rerun.log`) + Lean `Rh42/*` | reproduced bit-identically; algebraic parts Lean-certified |
| rh43 balanced-split roots | `rh43/zeta_split.py` (60 dps) | `rh43/verify/independent_check.py` (exact rational intervals, `1e-75` tails) | roots reproduced to **47 digits**; round's coarse brackets (`1e-7` at `N=50`) contain them |
| rh43 positive-only defect | `positive_only_split.py` | same script's independent Brown-criterion route | consistent |
| rh044 sharp constant `1/\|s−1\|` | `smoothed_zeta.py` | `rh044/verify/independent_check.py` (own θ route) | confirmed; brief's `1/√(2t)` refuted (factor 2.66) |
| rh044 zeros 1–5 | `mp.zetazero` | own `Z(t)` + own θ evaluator | agree to **≥25 digits**; sharp partial-sum roots shown **not** to be zeros |
| rh044 `N(30)` | round count | argument-principle integral of `ζ'/ζ` + independent `S(T)` | `N(30)=3`; RvM main term `3.564656` does not round to the truth |
| rh45 explicit formula | corrected convention | own incomplete-Γ (series **and** quadrature), own `Z(t)`, own `Λ` sieve | verified to `1e-44…1e-63` on Gaussian kernels; naive normalisation refuted |
| rh45 zeros 1–5 | `mp.zetazero` reference | sign changes of `Z(t)` with own `θ(t)` | 32.5–33.6 digits, no `mp.zetazero` used for locating |
| rh46 `S(x)`, `x ≤ 10^8` | segmented sieve | flat cumsum; 3 independent `λ` algorithms | exact integer agreement (`tol = 0`) |
| rh46 `S(10^9)` | round segmented sieve | two bit-identical reruns of the full ladder | identical (`30/0` both) |
| rh46 finite-prefix indeterminacy | `chowla_two_point.py` SS4 (X=10^4) | auditor A1 (X=10^8, 99 999 998 prefixes) | both exact; A1 is the stronger form |
| rh46 no-Euler-product | `D(2)` vs naive product | auditor model A (exact to `2^{26}`) + rh47 auditor | reproduced; **tail bound corrected** (below) |
| rh47 greedy supports | `greedy_parity_probe.py` | `rh47/verify/independent_check.py` | rigidity, parity lock, density reproduced |
| rh47 nominal `z` | round C0 control | positional C1 and slot C2 controls | nominal `z = −47.9` killed by controls (z = +0.43, +1.55) |
| rh47 barrier | stated in the round | auditor attack (31/31) | conclusion confirmed, but it is a **heuristic**, with 2 factual corrections |

**Route-independence caveats.** The rh43/rh044/rh45 "independent" checks are
independent *implementations* in the same environment; where the reference table is
`mp.zetazero` (rh044, rh45), agreement with it is not independent of `mpmath`. The
genuinely route-independent zero evidence is rh45's `Z(t)` scan and rh044's θ-route
evaluation. No check anywhere is verified against an external table or third-party
code.

---

# Corrections and discrepancies (both sources reported)

1. **`S(10^7) = 1244` → `1246`.** The main agent's reconnaissance printed `1244`;
   the auditor's **three independent `λ` algorithms** give `1246`
   (`rh46/verify/independent_check.log` check `S2.crosscheck`, the run's only FAIL;
   `rh46/README.md` §1.2). The difference is a **final-block boundary slip** in the
   reconnaissance streaming: `1244 = Σ_{n≤x−2}` (it drops `n=10^7−1, 10^7`, whose
   products are both `+1`). No single convention reproduces the recon row
   (`Σ_{n≤x}` matches 4/5 rows, `Σ_{n≤x−2}` only 2/5). **`1246` is correct.**
   The reconnaissance script itself is not preserved in `rh46/verify/`; the `1244`
   survives only as `RECON_S` in `independent_check.py` and as the README's correction
   note.

2. **rh46's sparse-modification bound is FALSE.** `chowla_two_point.log` SS4 and
   `independent_check.log` D4 state
   `|S_A(x) − S(x)| ≤ 2·#{n ≤ x+2 : n ∈ A}` "for ANY flip set `A`". The rh47 auditor
   refutes it: `A = {5}`, `x = 5` gives `|ΔS| = 4 > 2` (the two affected terms `n=3`
   and `n=5` each change by `−2`). **Correct bound:**
   `|S_A(x) − S(x)| ≤ 2·#{n ≤ x : n ∈ A or n+2 ∈ A} ≤ 4·#{m ≤ x+2 : m ∈ A}`
   (`rh47/verify/independent_check.log` C4a–C4b; `rh47/truths.md` §3). The `o(x)`
   conclusion is unaffected: a sparse `A` still moves `S` by `o(x)`. The corrected
   bound — and the falsity of the inherited form — is now **machine-checked** in
   [`../rounds/rh47/lean/Rh47/Sparse.lean`](../rounds/rh47/lean/Rh47/Sparse.lean)
   (`corrSparse_sub_corr_abs_le`, `corrSparse_sub_corr_abs_le_four`,
   `rh46_sparse_bound_false`, `corrSparse_bound_sharp`; item OP-12).

3. **rh46's product tail bound `1.80898647` is mis-derived.** It equals
   `4·Σ_{p≤10^5} 1/p²` over the **retained** primes, not a bound on the omitted factor
   (`p > 10^5`). The correct tight bound is `≈1.84e-05`
   (`rh47/verify/independent_check.log` C2d, total rigorous uncertainty `1.836e-05`;
   `greedy_parity_probe.log` SS4 gives `1.8450e-05` by a slightly looser split). The
   no-Euler-product verdict survives, on a tail ~`10^5×` smaller than published.
   (`rh46/independent_check.log` C2b independently reproduces the published model
   `0.88759631` and the discrepancy `2.01440934`.)

4. **rh45 `truths.md` pass count *was* stale (now corrected).** `rh45/truths.md` used
   to say the auditor was "**17/21** (the 4 failures …)" and to list `C1e`,
   `C3.rvm.asymptotic`, `C4.1`, `C5.3`. The log
   [`rh45/verify/independent_check.log`](../rounds/rh45/verify/independent_check.log)
   shows **`FINAL: 19/21 checks pass`** with exactly **two** non-passes: `C1e` and
   `C4.1`; `C3.rvm.asymptotic` and `C5.3` are `[PASS]` in the log. **The log is
   authoritative** (it is the run output). The ledgers `rh45/truths.md` and
   `010/truths.md` now read **19/21** (correction `X4` of the programme README); the
   historical `17/21` line survives only inside the audit record, where it is labelled
   as corrected. **Update (dispositions):** `C4.1` has since been **RETIRED** as an
   over-strong criterion of the task prompt and `C1e` has been **RETIRED as
   unsatisfiable-by-its-instrument and restated** as the convergent companion `C1f`, so the
   current `010/` adjudication is *"19/21 checks pass; 2 retired; failures: none"* — see
   [`010/verify/DISPOSITIONS.md`](../010/verify/DISPOSITIONS.md).

5. **rh47's probe log contains a superseded run.** `greedy_parity_probe.log` holds two
   summary blocks: an old `21 checks pass, 1 fail (wall clock 26491.0s)` in which
   `S2.nominal.signal.under.spec.control` FAILs with pooled `z = 0` and C0 baseline
   `μ₀ = −1.019104`, followed by the current `23 checks pass, 0 fail (wall clock 3.5 s)`
   with `z = −47.9170` and `μ₀ = −0.009552`. The current script on disk (23 checks,
   including `S1.sylvester.ladder.exact`) re-run in a scratch copy reproduces
   **`23 checks pass, 0 fail`, `z = −47.9170`**. **The `z = 0` block is a superseded
   buggy intermediate** (wrong C0 baseline); the round's documented `z = −47.9`
   (`README.md`, `HANDOFF.md`, `truths.md`) is the correct current value. The
   `21/1` block should not be cited.

6. **rh044 brief constants.** The brief's normalisation `1/√(2t)` is wrong; the exact
   constant is `1/√(1/4+t²) = 1/|s−1|` (factors `2.6601139` at `t=14.1347`,
   `3.2429872` at `t=21.0220`, `2.2388613` at `t=10`). The brief's θ formula is also
   wrong: at `s=2` it returns `ζ(2) − 0.0977365`.

7. **rh45's naive explicit formula.** Pole terms `F(1)+F(0)` and the omitted
   archimedean integral make the literal RHS wrong by `0.536580471657` (reading A).
   The correction is itemised: `−0.65976624642101921005` (pole arguments) and
   `−1.1963467180780578254` (missing archimedean).

8. **rh43's three refuted round claims.** "`N=2` has no root" and "no exact complex
   vanishing for `N ≤ 6`" are both refuted by `N=2` (`Re S_2` has tangential zeros;
   `S_2(π/log 2) = 0` exactly). "`|S_N|` grows like `N^{1/2}`" is refuted: growth is
   linear, with the rigorous Euler-summation lower bound.

9. **rh46's two growth fits disagree.** `α = 0.5200 ± 0.0249` (round, `x ≤ 10^9`) vs
   `θ = 0.4834 ± 0.0186` (auditor, `x ≤ 10^8`), with local exponents `0.32–0.65`.
   Neither is an asymptotic exponent; the disagreement is the point — **the exponent is
   not resolved**.

10. **rh42 sign correction.** The pages print the alphabet total as `ln 2 − 1 =
    −0.30685`; the correct value for this alphabet is `1 − ln 2 = +0.30685281944005469`
    (`helix_zeta.log` §1, `reachable.log` §6).

11. **rh46's withdrawn claim.** The "RH-conditional `x^{1/2+ε}`" reading of `max|S|` is
    recorded as **WITHDRAWN / unverified** (auditor B4): the shifted product is not
    multiplicative, so the Dirichlet-series/Perron route does not apply.

12. **rh44 vs rh044 naming.** The brief for this document says "`rh44/verify/` logs
    (smoothing laws)"; the actual directory is **`rh044/`**. There is no `rh44/`.

13. **rh45's own numerics log is missing.** `rh45/verify/` contains only
    `independent_check.log` and `lean_check.log`; `explicit_formula.py`'s intended
    `explicit_formula.log` was never committed (the run was interrupted). All rh45
    numbers in this register are the auditor's.

14. **rh044 T4 model count.** At `N=1000` the round's "model count" column says `76`
    while the observed count is `60` (stable under `0.05 → 0.02` refinement). The check
    passes on stability and on the grid minimum versus the rounding bound, not on the
    model.

15. **`rh43/ivmath.py` enclosure caveat (reported by the B.2 rank-8 engine).**
    `ivmath.log_prime` evaluates `log p = 2∑_{k<K} q^{2k+1}/(2k+1)` with `K = 120` and a
    geometric tail bound that *is* included in the reported error; near `p = 40`
    (`q = 39/41`) that tail is already `≈5·10⁻⁸`, so `ivmath` cannot certify signs at
    that width.  The rank-8 script additionally reports that the `ivmath` interval was
    not always a strict superset of the high-precision value in a spot cross-check
    (worst containment defect `1.3·10⁻²¹`).  The rank-8 result therefore uses
    `mpmath.iv` with directed rounding and **does not depend on `ivmath`**; the rank-7
    script replaces the log engine by its own `ratio ≤ 1/3`, `K = 320` series.
    **Recommendation:** re-audit `ivmath.log_prime`'s error accounting before relying on
    it for sign certificates narrower than `10⁻¹⁸`; nothing in this register currently
    does.  (No claim is made here about `ivmath`'s other routines.)

---

# How to re-run

From `/Users/victor/workspace/rh`. Scripts that do not name a log are run with shell
redirection; the auditor scripts of rh45/rh46/rh47 write their own log (running them
overwrites it — the rh46 and rh47 **round** scripts also overwrite their logs via a
`Tee` opened with mode `"w"`).

```bash
cd /Users/victor/workspace/rh

# ---- rh42 — ζ-budgets and the exact reachable set (fast; 80 + 70 checks) ----
python3 -u rh42/helix_zeta.py > rh42/verify/helix_zeta.log 2>&1
python3 -u rh42/reachable.py  > rh42/verify/reachable.log  2>&1
( cd rh42/lean && ./check.sh --all )          # 4 modules, exit 0

# ---- rh43 — the balanced split at Re(S)=0 (102 + 64 + 15 checks) ----
python3 -u rh43/zeta_split.py  > rh43/verify/zeta_split.log 2>&1
python3 -u rh43/verify/independent_check.py > rh43/verify/independent_check.log 2>&1
python3 -u rh43/verify/positive_only_split.py > rh43/verify/positive_only_split.log 2>&1
( cd rh43/lean && ./check.sh --all )

# ---- rh044 — smoothing laws (note: rh044, not rh44; ~303 s + ~88 s) ----
python3 -u rh044/smoothed_zeta.py > rh044/verify/smoothed_zeta.log 2>&1
python3 -u rh044/verify/independent_check.py > rh044/verify/independent_check.log 2>&1
( cd rh044/lean && ./check.sh --all )

# ---- rh45 — explicit formula / zeros / counts ----
# the round script's own log was never produced (run interrupted):
python3 -u rh45/explicit_formula.py > rh45/verify/explicit_formula.log 2>&1
python3 -u rh45/verify/independent_check.py            # self-writes .../independent_check.log; 19/21
( cd rh45/lean && ./check.sh --all )

# ---- rh46 — two-point Chowla (exact sieve to 10^9; ~4.5 min + ~33 s) ----
python3 -u rh46/chowla_two_point.py                    # self-writes .../chowla_two_point.log; 30/30
python3 -u rh46/verify/independent_check.py            # self-writes .../independent_check.log; 25/26
( cd rh46/lean && ./check.sh --all )

# ---- rh47 — the greedy parity probe ----
python3 -u rh47/greedy_parity_probe.py                 # self-writes .../greedy_parity_probe.log; 23/23
python3 -u rh47/verify/independent_check.py            # self-writes .../independent_check.log; 31/31
# rh47 has no Lean module: rh47/lean/Rh47/ is empty
```

Expected terminal summaries: rh42 `ALL 80 CHECKS PASS` / `ALL 70 CHECKS PASS`;
rh43 `64 checks pass, 0 fail`, `102/102 checks pass`, `15 checks pass, 0 fail`;
rh044 `59 checks pass, 0 fail`, `43/43 auditor checks pass`;
rh45 `FINAL: 19/21 checks pass`; rh46 `30 checks pass, 0 fail`, `FINAL: 25/26 checks
pass` (the FAIL is the `1244 vs 1246` reconnaissance cross-check, item 1 above);
rh47 `23 checks pass, 0 fail`, `RESULT: 31/31 checks pass`.

**Reproduction notes.** rh42's `helix_zeta.log` is bit-identical under rerun except the
trailing `exit=0`. rh46's full `10^9` ladder was run twice
(`chowla_two_point.log`, `chowla_two_point.repro1.log`) and every `S` value is
identical. Running rh46's or rh47's round script overwrites its log in place; to check
them without disturbing the committed evidence, copy the script (and an empty `verify/`
directory) to a scratch location — the log path is derived from `__file__`, so the
committed log is untouched.

---

*Status of this register:* every number above is transcribed from the named log. The
only numbers not from a committed log are (i) the rh47 re-run confirmation in item 5,
performed in a scratch copy of the on-disk script, and (ii) the Lean module statuses
from the `lean_check.log` files. Statements flagged OPEN — `Σ_{n≤x}λ(n)λ(n+2)=o(x)`,
the twin-prime conjecture, the parity problem, and the rh47 barrier — are open in this
register too.
