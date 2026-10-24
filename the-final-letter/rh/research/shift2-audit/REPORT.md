# The shift-2 odd core: a "what would it take" audit

*Disciplined analysis of `C(K) = Σ_{k≤K} λ(2k−1)λ(2k+1)`. No proof of anything is claimed.
Every substantive claim carries a label: **CONFIDENT** / **PLAUSIBLE** / **UNVERIFIED**.
Sources verified in this session are listed in §7; anything I did not read is marked.*

---

## 0. Headline: the premise of part (C) is false

The brief states: *"KNOWN: Σ_{n≤x} λ(n)λ(n+1) = o(x) is a THEOREM (Matomäki–Radziwiłł–Tao 2015,
proved using the Matomäki–Radziwiłł short-interval theorem together with an entropy/parity
argument)."* **This is not a theorem.** (CONFIDENT — verified from the primary sources, §7.1–7.3.)

* Matomäki–Radziwiłł, *Multiplicative functions in short intervals*, **Corollary 2**:
  > "For every integer h ≥ 1, there exists δ(h) > 0 such that
  >  (1/X)|Σ_{n≤X} λ(n)λ(n+h)| ≤ 1 − δ(h) for all large enough X > 1."

  Their abstract describes the h = 1 case of this as bounding the mean value of λ(n)λ(n+1)
  "non-trivially … by 1 − δ", calling it "progress towards Chowla's conjecture"; and they quote
  Hildebrand that even liminf_x (1/x)Σ_{n≤x} λ(n)λ(n+1) < 1 had been "beyond reach of the
  present methods". So the best *un-averaged* statement at h = 1 is a bound away from 1, not o(1).
* Matomäki–Radziwiłł–Tao, *An averaged form of Chowla's conjecture* (v3, 2022): "This conjecture
  remains unproven for any h_1,…,h_k with k ≥ 2."
* Tao–Teräväinen (arXiv:1809.02518): "**No further cases of the unweighted Chowla conjecture are
  currently known**" beyond k = 1 (which is the prime number theorem). Their own theorem is for
  *almost all scales*: k-point Chowla for k odd or k = 2 for all X outside a set of zero
  logarithmic density.
* Matomäki–Radziwiłł–Tao, *Sign patterns of the Liouville and Möbius functions*: the λ result is
  **positive lower natural density of each of the eight length-three sign patterns** — a density
  statement, not a cancellation statement. The word o(x) does not occur.

What the h = 1 problem actually has is: a 1−δ bound (MR, all h), a **logarithmically averaged**
vanishing (Tao), an **almost-all-scales** vanishing (Tao–Teräväinen), a **shift-averaged** vanishing
(MRT), and positive-density sign patterns (MRT). Nothing un-averaged. The "entropy/parity argument"
is Tao's *entropy decrement*, and what it delivers is the **logarithmic** average.

Consequence for the reduction supplied in the brief:

> **shift-2 ⟺ [h = 1] AND [odd core]** — and **both** halves are open.

The brief's "given MRT, shift 2 is EQUIVALENT to C(K) = o(K)" is therefore only valid conditionally
on the h = 1 statement, and that statement is open. (CONFIDENT. The exact identity is verified in §1.)

---

## 1. Corrected logical geography (exact, elementary)

Throughout: λ is completely multiplicative, λ(p) = −1; S_h(x) = Σ_{n≤x} λ(n)λ(n+h);
C(K) = Σ_{k≤K} λ(2k−1)λ(2k+1).

**(1.1) Exact parity splitting.** (CONFIDENT — one line: λ(2)=−1, λ(2)²=1.)
```
S_2(x) = S_1(⌊x/2⌋) + C(⌊(x+1)/2⌋)          exactly.
```
Verified numerically with discrepancy **0** at x = 10³, 10⁵, 10⁷ (§5). Hence
`S_2 = o(x)` ⟺ `S_1 = o(x)` **and** `C = o(K)`; the core by itself does not give shift 2.

**(1.2) The core is a polynomial sum.** (CONFIDENT — λ completely multiplicative gives
λ(m²−1) = λ(m−1)λ(m+1) with no coprimality needed.) Substituting n = m−1:
```
S_2(x) = Σ_{m=2}^{x+1} λ(m²−1)            exactly
       = [even m part] + [odd m part]  =  C(⌊(x+1)/2⌋)  +  S_1(⌊x/2⌋),
```
which is the same identity as (1.1) read through m = n+1. Verified numerically up to a single
boundary term (= −λ((x+1)²−1)), §5. So:

* the **h = 1 problem** is (essentially) the **odd-m half** of Σ λ(m²−1);
* the **odd core** is the **even-m half** of the same sum.

Both are instances of Chowla's conjecture for a degree-2 polynomial (f(m) = m²−1), which is open;
the general polynomial form is described as "extremely hard and still … wide open" for degree > 1
(§7.8). This is the sharpest available statement of "what the two problems are": *not* two different
objects, but two halves of one object, split by the parity of the argument.

**(1.3) The core's own second moments are λ-correlations at other shifts.** (CONFIDENT.)
With c(k) := λ(2k−1)λ(2k+1),
```
c(k)c(k+1) = λ(2k−1)λ(2k+3)      (since λ(2k+1)² = 1),
so   Σ_{k≤K} c(k)c(k+1) = Σ_{k≤K} λ(2k−1)λ(2k+3)   — the odd part of the shift-4 correlation.
```
Verified exactly (discrepancy 0 at K = 10, 10³, 10⁶), §5. The family
`{odd part of shift-h correlation : h odd}` is closed under taking autocorrelations. Consequence for
method families that consume second moments (spectral, positivity, amplification): see (A)(v).

---

## 2. (A) Mechanism audit

Summary table, then detail.

| family | applies to C(K)? | what blocks | class |
|---|---|---|---|
| (i) MR short intervals | **No** (hypothesis class excludes it); gives 1−δ for the *whole* S_2 only | the pair sequence is not multiplicative; no n₁n₂ shape | STRUCTURAL |
| (ii) entropy decrement | **Yes, fully — but only log-averaged / almost-all-scales** | the average over a parameter is consumed, not an artefact | STRUCTURAL |
| (iii) Selberg / FI asymptotic sieve + Type II | **No** | parity principle + no bilinear input for a rigid one-variable factorisation | STRUCTURAL |
| (iv) Dirichlet series / Perron via Euler product | **No** | no Euler product; and Abel/residue data is *provably* too weak | STRUCTURAL |
| (v) spectral / positivity | only as bookkeeping; no mechanism | the object is "degree 2"; its moments are again λ-correlations | STRUCTURAL for known mechanisms, OPEN for a new one |
| (vi) almost-all shifts / almost-all scales | **Yes, but the averages are over parameters we need fixed** | prescribed point cannot be certified by an a.e. statement | STRUCTURAL |

### (i) Matomäki–Radziwiłł short-interval theorem

**What it says** (CONFIDENT — quoted from §7.1). For multiplicative f : ℕ → [−1,1], any 2 ≤ h ≤ X,
δ > 0:
```
| (1/h)Σ_{x≤n≤x+h} f(n)  −  (1/X)Σ_{X≤n≤2X} f(n) |  ≤  δ + C' loglog h / log h
```
for all but at most `C X ( (log h)^{1/3}/(δ²h^{δ/25}) + 1/(δ²(log X)^{1/50}) )` integers x ∈ [X,2X].
There is also a **bilinear** variant (their Theorem 2) for sums of f(n₁)f(n₂) with
x ≤ n₁n₂ ≤ x + h√x, √x ≤ n₁ ≤ 2√x — this one holds in *all* such intervals.

**Applicability to C(K): NO.** (CONFIDENT.)
* The object is a *bilinear statistic of λ*: Σ_k λ(2k−1)·λ(2k+1), two values of λ at
  **additively** related arguments. The theorem is machinery for *linear* statistics of a single
  multiplicative function (plus its modulation by n^{it}/χ in the MRT extension).
* The sequence n ↦ λ(n)λ(n+2) is **not multiplicative**: f(3) = λ(3)λ(5) = +1,
  f(9) = λ(9)λ(11) = −1 ≠ f(3)², and f(15) = −1 ≠ f(3)f(5) = +1. (CONFIDENT; the same fact is
  machine-checked in this workspace as `chowla_not_multiplicative` / `chowlaAF_not_conv`.)
* Theorem 2's shape is *multiplicative* (n₁n₂ in a short interval); the core's factorisation
  (2k−1)(2k+1) is a function of one variable and has no free divisor parameter, so it does not fit.

**What it *does* give for shift 2** (CONFIDENT, it is their Corollary 2 with h = 2):
`|Σ_{n≤X} λ(n)λ(n+2)| ≤ (1−δ(2)) X`. Because of (1.1), this bounds `S_1 + C` jointly and therefore
**yields no non-trivial bound for the core**: `S_1` and `S_2` each satisfy a (1−δ) bound, and
`C = S_2 − S_1(x/2)` is a difference of two such, bounded below the trivial bound by nothing.
I did **not** find any statement in the literature giving a non-trivial bound for the odd-restricted
sum. (UNVERIFIED whether such a bound is known; see T2 in §3.)

**Sub-gap even in the multiplicative case** (CONFIDENT, arithmetic): to convert "short average is
small for all but O(X(log h)^{−1/100}) values of x" into a bound on the full sum, one partitions
[1,X] into X/H blocks and needs the exceptional set to be o(X/H). It is not; the shortfall is not a
constant factor but a different order of magnitude. This is the *shape* of every un-averaging
failure in this problem.

### (ii) Entropy decrement (Tao)

**What it gives** (CONFIDENT — quoted from §7.4). Tao's theorem: for fixed natural numbers
a₁,a₂,b₁,b₂ with a₁b₂ − a₂b₁ ≠ 0,
```
Σ_{x/ω(x) < n ≤ x} λ(a₁n+b₁)λ(a₂n+b₂)/n = o(log ω(x)),   ω(x) → ∞.
```
Tools listed in the abstract: multiplicativity at small primes, MRT short intervals, concentration
of measure, Hardy–Littlewood circle method + a restriction theorem for the primes, and the entropy
decrement argument. It extends to the logarithmically averaged Elliott conjecture in the two-point
case.

**Applicability to C(K): YES — completely.** Take a₁ = a₂ = 2, b₁ = −1, b₂ = +1:
a₁b₂ − a₂b₁ = 4 ≠ 0. So the core satisfies the logarithmically averaged statement, with no structural
obstacle whatsoever. (CONFIDENT.)

**What blocks the un-averaged conclusion.** The entropy decrement consumes an average over a
parameter (a dilation / the scale) in order to reduce the two-point object to a statement about a
single multiplicative function; what comes out is an averaged statement. (PLAUSIBLE — this is the
standard understanding of why the method is intrinsically averaged; I did not read the internals of
the proof this session. The *statement* — log-averaged only — is CONFIDENT.)

**Evidence that the limit is real and not laziness** (CONFIDENT for the numbers, PLAUSIBLE for the
interpretation):
* Even in the log-averaged world, where the result *is* a theorem, the best known quantitative bound
  is a power saving in log: `Σ_{n≤x} λ(n)λ(n+1)/n ≪ (log x)^{1−c}` (Pilatte, §7.6), improving
  Helfgott–Radziwiłł's `log x/(log log x)^{1/2}`; the author states this "appears to be best possible
  with current methods".
* Meanwhile the un-averaged best is still 1−δ. The gap between "log-saving" and "x-saving" has not
  been crossed for k ≥ 2 anywhere.
* The higher-order obstruction is explicitly identified by Tao as "the need to control short sums of
  multiplicative functions modulated by local nilsequences" — i.e. the missing input is again
  *linear* machinery.

### (iii) Selberg / Friedlander–Iwaniec asymptotic sieve and Type-II inputs

**Applicability to C(K): NO.** (CONFIDENT for the parity principle and for the rigidity argument;
UNVERIFIED for the exact hypothesis list of the FI sieve, which I did not read this session.)

* **Parity principle** (CONFIDENT as a theorem of sieve theory): a sieve of bounded level — i.e. input
  consisting of congruence/divisibility data up to a fixed depth — cannot distinguish integers with an
  even number of prime factors from those with an odd number. λ is exactly the parity-detecting
  function, so no sieve-only input determines Σ_k λ(4k²−1). Any method in this family must therefore
  break parity by an extra input, not by sieving better.
* **Type-II / bilinear input** (CONFIDENT in shape): the Friedlander–Iwaniec asymptotic sieve breaks
  parity using a bilinear (Type II) hypothesis over a two-parameter range — this is what makes the
  two-variable results (e.g. primes of the form X²+Y⁴) possible. For the core the factorisation is
  **rigid**: 4k²−1 = (2k−1)(2k+1) is one fixed pair of linear forms in one variable. There is no free
  parameter to build a bilinear form from, and the arguments of the two λ's are additively, not
  multiplicatively, related. Consistently with this, the one-variable quadratic problem (n²+1 prime)
  is open, and the state of the art there is almost-prime / large-prime-factor information
  (§7.10) — precisely bounded-depth information, which is parity-blind for λ.
* The classical Type-II *convolution* shape for multiplicative functions (the Λ = μ∗log model) is
  excluded for this object on algebraic grounds; in this workspace that is machine-checked
  (`chowlaAF_not_conv`: λ(n)λ(n+2) is not a convolution of multiplicative functions). Note the
  logical scope: that excludes *multiplicative* summands, not every conceivable bilinear input.

### (iv) Dirichlet series / Perron methods via an Euler product

**Applicability to C(K): NO**, for two independent reasons.

1. **No Euler product.** (CONFIDENT.) n ↦ λ(n)λ(n+2) is not multiplicative (f(9) = −1 ≠ f(3)² = 1),
   so F(s) = Σ_n λ(n)λ(n+2)n^{−s} has no product, no functional equation, and no continuation
   mechanism of the classical kind. Equivalently, in the polynomial form the sum is over values of a
   polynomial, not over a multiplicative semigroup.
2. **The Abelian data is provably insufficient.** (CONFIDENT; external counterexample.) The vanishing
   of the residue of F at s = 1 — i.e. `lim_{ε↓0} ε Σ f(n)n^{−1−ε} = 0` — does **not** imply the
   Cesàro mean vanishes. Witness f(n) = cos(θ log n): its Dirichlet series is (ζ(s−iθ)+ζ(s+iθ))/2,
   holomorphic at s = 1, so the Abelian mean vanishes, yet Σ_{n≤x} cos(θ log n) ≍ x/√(1+θ²). This is
   the classical non-equivalence of Abelian and Cesàro summability for bounded sequences. So *any*
   route that only extracts the pole/behaviour at s = 1 is structurally too weak — including the
   "residue" reformulation recorded in this workspace.

   Caveat, to avoid over-reading: this does not forbid *circle-method* uses of ζ-type information.
   Tao's log-averaged proof uses the Hardy–Littlewood circle method plus a restriction theorem for
   the primes. It forbids the Euler-product/Perron/continuation route, and it forbids concluding the
   target from s = 1 data.

### (v) Spectral or positivity methods (Hilbert-space realisation, amplification)

**Applicability: only as bookkeeping; no known mechanism.** (CONFIDENT for the identities below;
PLAUSIBLE for the reading of the method families.)

* Since c(k) = λ(2k−1)λ(2k+1) is a bounded ±1 sequence, "C(K) = o(K)" is exactly the statement that
  the spectral measure of c has no atom at frequency 0 — the finite Wiener–Khinchin identity is
  machine-checked in this workspace (`dft_autocorr`). That is a reformulation, not a method.
* The difficulty is what the second moments *are*: by (1.3), `Σ c(k)c(k+1) = Σ λ(2k−1)λ(2k+3)`, i.e.
  the autocorrelation of the core is the odd part of the shift-4 λ-correlation. Any second-moment,
  spectral or positivity argument applied to c consumes **another member of the same open family**.
  This is a self-reference, not a reduction. (CONFIDENT — it is an identity.)
* Amplification needs a family with a symmetry/spectral parameter in which to amplify; the core
  presents a single sequence with no parameter. The historical parity-breaking successes
  (Friedlander–Iwaniec, Bombieri–Friedlander–Iwaniec) use positivity tied to an algebraic family.
  Here the only available "family" is the shift, and averaging over shifts is exactly MRT's averaged
  theorem — which cannot certify a prescribed shift.
* What is *not* ruled out: some genuinely new positivity mechanism. This is the one entry in the
  workspace's own ledger that is not contradicted by a machine-checked fact, and I agree with that
  assessment. (PLAUSIBLE.)

### (vi) Almost-all-shifts results and almost-all-scales results

**(a) Almost all shifts.** (CONFIDENT — quoted from §7.3.) MRT: for fixed k,
```
Σ_{h_1,…,h_k ≤ H} | Σ_{n≤X} λ(n+h_1)⋯λ(n+h_k) | = o(H^k X)   as X → ∞, H = H(X) ≤ X, H → ∞,
```
together with `∫_0^X |Σ_{x≤n≤x+H} λ(n)e(αn)| dx = o(HX)` uniformly in α.
**Applies to the core in the only way an average can: a prescribed shift pair — (1,3) for a shift-2
correlation, (1,2) for shift 1 — is one point among H² and gets no information.** The mean is not
trivialised by diagonal terms alone (the k = 2 diagonal pair h₁ = h₂ contributes H·X = o(H²X)), but a
single prescribed shift is invisible to it. (CONFIDENT.)
*The brief also attributes an almost-all-shifts result to Tao–Teräväinen. I did not verify which
paper that is and will not guess: **UNVERIFIED**.*

**(b) Almost all scales.** (CONFIDENT — quoted from §7.5.) Tao–Teräväinen prove, for correlations
`E_{n≤X/d} g_1(n+ah_1)⋯g_k(n+ah_k)` with a dilation parameter a and shifts h_i, that the correlation
vanishes for almost all X (outside a set of zero logarithmic density) unless the product weakly
pretends to be a twisted Dirichlet character; in particular the k-point Chowla conjecture for k odd
or k = 2 holds **for all scales X outside a set of zero logarithmic density**.

**Does it cover the core? Not literally — but yes by the reduction, and this is worth stating
precisely** (CONFIDENT; the applicability argument is mine, derived from their quoted statement, and
is *not* a quotation of a theorem about the core). The class in their theorem is shift correlations
`∏ g_i(n + a h_i)` with the variable running over **all** n; arguments `n + 2h_i` always share the
parity of n, so `Σ_k λ(2k−1)λ(2k+1)` — a correlation restricted to odd n — is *not* an instance of
their stated theorem, and I did not verify whether their method extends to residue-class-restricted
or general equal-leading-coefficient affine correlations (**UNVERIFIED**). The transfer instead uses
the exact identity of §1.1 in the form `C(K) = S_2(2K) − S_1(K) + O(1)`. `S_1` and `S_2` are both
k = 2 shift correlations, hence both covered by their theorem, so both are o(X) for all X outside a
set of zero logarithmic density. The map K ↦ 2K preserves zero logarithmic density, and a union of
two such sets is such a set. Hence:

> **C(K) = o(K) for all K outside a set of zero logarithmic density.** (Derived, not quoted.)

Nothing is asserted at a **prescribed** K. The gap is therefore not "the method cannot see the
object" but "the method sees it almost everywhere in the scale".

**Why no averaging argument can fix this** (CONFIDENT, machine-checked barrier of principle, in this
workspace): `scale_average_does_not_control_prescribed` exhibits a bounded sequence whose partial
sums vanish at every scale up to N/2 and equal N − N/2 at the prescribed scale N. So "for almost all
scales, S(X) = o(X)" can never imply "S(X) = o(X) at this X" for general sequences. The same style of
witness exists for the shift average (`shift_average_does_not_control_single`). These are barriers to
the *inference*, not theorems about λ.

**Structural observation tying (vi) to (i)–(ii).** (PLAUSIBLE.) All of the machinery in (i) and (ii)
is machinery for **linear statistics of multiplicative functions** (plus modulations). The core is a
**bilinear statistic of λ**. The only known bridge from bilinear to linear is the entropy-decrement /
dilation averaging step — and that bridge is exactly what forces the average. This is, to me, the
clearest single-sentence diagnosis of why every route in this list lands on an averaged statement.

---

## 3. (B) Gap statement

For each theorem that comes close: the exact generalisation needed, and its classification.

| # | theorem (verified) | exact generalisation that would reach the core | class | my confidence |
|---|---|---|---|---|
| T1 | MR Thm 1 (short intervals for multiplicative f) | same conclusion with f replaced by the two-point correlation x ↦ λ(x)λ(x+h), or with a product shape covering (2k−1)(2k+1) | **STRUCTURAL** | CONFIDENT (hypothesis class excludes non-multiplicative objects) |
| T2 | MR Cor 2 (`(1/X)\|Σλ(n)λ(n+h)\| ≤ 1−δ(h)`, every h ≥ 1) | the same bound for the **odd-restricted** sum Σ_{k≤K} λ(2k−1)λ(2k+1) | extraction from T2 is impossible (C = S₂ − S₁(x/2)); whether a direct adaptation gives it: | CONFIDENT that known statements give nothing for C; **UNVERIFIED** whether a 1−δ core bound is in the literature |
| T3 | Tao 2015 (log-averaged two-point Chowla/Elliott, all affine forms) | remove the logarithmic average and fix the scale | **STRUCTURAL** (average consumed by entropy decrement) | CONFIDENT for the statement; PLAUSIBLE for the mechanism reading |
| T4 | TT 2019 (k = 2 Chowla at almost all scales) | exceptional set of zero log-density → empty for large X | **STRUCTURAL** (a.e.-in-scale cannot certify a point; machine-checked toy barrier) | CONFIDENT |
| T5 | MRT 2015 (Chowla averaged over shifts) | prescribed shift h = 2 | **STRUCTURAL** | CONFIDENT |
| T6 | MRT 2016 (positive lower density of each length-3 pattern) | density exactly 1/4 of each pattern | **STRUCTURAL** — and note this generalisation *is* the target (equivalence is machine-checked in this workspace: `chowlaSum_tendsto_iff_patCount_tendsto`) | CONFIDENT |
| T7 | Pilatte 2023 (Σλ(n)λ(n+1)/n ≪ (log x)^{1−c}) | un-averaged analogue | **STRUCTURAL**; also a QUANTITATIVE datum: even where the theorem holds, the saving is a power of log, not x | CONFIDENT (statement); author's "best possible with current methods" = PLAUSIBLE |
| T8 | Jaskari–Sachpazis 2024 (Chowla bounds **conditional on a Landau–Siegel zero**), Jaskari–Sachpazis also improves Germán–Kátai, Chinis, Tao–Teräväinen | unconditional version | **CONDITIONAL**; it covers the *pretentious* case (λ ≈ χ), where λ(n)λ(n+h) ≈ χ(n(n+h)) becomes an ordinary character sum, i.e. algebraically accessible. The hard case is the *non-pretentious* one, and that is exactly where the averaging lives | CONFIDENT for the abstract's content; PLAUSIBLE for the pretentious/non-pretentious reading |

**Two structural remarks on this table.**

* **Every "STRUCTURAL" verdict above has the same shape**: the theorem is true for a class of
  objects that does not contain the core, or for an averaged version of the statement we need. No
  entry is "same mechanism, better constants".
* **The single genuinely quantitative sub-gap I can name** (CONFIDENT, arithmetic): the exceptional
  set in MR Thm 1 has size ≍ X(log h)^{−1/100}; summing short intervals into a global sum needs
  o(X/H). Improving a constant, or even a power of log, does not bridge that. Similarly for T7: even
  a much better power of log leaves the un-averaged statement untouched.

**The un-averaging lemma, stated exactly** (this is the missing lemma the brief asks for; it is
sufficient, it is not a proof, and it is *not* a strictly weaker statement than the target):

> **Lemma U(h).** There exist H = H(x) → ∞ and δ = δ(x) → 0 such that for all sufficiently large x,
> the set of X ∈ [x, 2x] with
> `| (1/H) Σ_{X<n≤X+H} λ(n)λ(n+h) | > δ`
> has measure o(x/H).

Summing over a partition of [1,x] into intervals of length H gives Σ_{n≤x} λ(n)λ(n+h) = o(x)
elementary. So **Lemma U(2) implies the core estimate; Lemma U(1) implies the h = 1 estimate.**
(CONFIDENT that Lemma U(h) suffices, for each h. CONFIDENT that Lemma U(h) is open: if it were known,
un-averaged two-point Chowla would be known, contradicting the state of the art in §7.5.)

Note what Lemma U is *not*: it does not follow from MR Thm 1 (that is for multiplicative objects and
has the wrong exceptional-set scale), and it does not follow from the almost-all-scales theorem of
TT 2019 (that is almost all *scales*, this is almost all *intervals within every scale*).

---

## 4. (C) What the h = 1 proof has that the core lacks

**Short answer: nothing, because there is no un-averaged h = 1 proof.** (CONFIDENT — §0.)

The question presupposes a solved h = 1 and an unsolved h = 2. Both are unsolved; they are not even
different problems in the relevant sense — they are the odd-m and even-m halves of Σ λ(m²−1) (§1.2).

What h = 1 actually has, and whether the core has it too:

| known result for shift h = 1 | does it cover the core? |
|---|---|
| 1−δ bound (MR Cor 2) — and it is stated for **every** h ≥ 1, h = 2 included | the *whole* S₂, yes; the core itself, no (§2(i)); no asymmetry in favour of h = 1 |
| log-averaged o(1) (Tao 2015, all affine forms with a₁b₂ ≠ a₂b₁) | **yes, identically** ((2,−1),(2,+1), determinant 4) |
| o(1) at almost all scales (TT 2019, k = 2) | **yes, but through the reduction, not literally** (§2(vi)(b)): `C(K) = S₂(2K) − S₁(K)` and both `S₁`, `S₂` are in their class, so `C(K) = o(K)` outside a zero-log-density set |
| o(1) on average over shifts (MRT 2015) | yes, in the only sense an average can be (one point among H²) |
| positive lower density of all sign patterns (MRT 2016) | yes — their λ theorem is about length-**3** patterns, so it covers (λ(n),λ(n+1)) *and* (λ(n),λ(n+2)) |
| best quantitative log-averaged bound, (log x)^{1−c} (Pilatte) | Pilatte states it for h = 1; I did not verify a general-h or affine-forms version — **UNVERIFIED**, though the method is the h = 1 case of the same entropy-decrement framework |
| bounds conditional on a Landau–Siegel zero (Jaskari–Sachpazis, any k ≥ 2) | for the *full* sums Σ_{n≤x}∏λ(n+h_i), yes; and here the packaging is harmless — see the note below |

**A note on which un-averaged packagings transfer to the core.** All the *un-averaged* theorems in
the literature are stated for full shift sums Σ_{n≤X} λ(n+h_1)λ(n+h_2). The core is reachable from
them through `C(K) = S_2(2K) − S_1(K)` only when the conclusion is closed under differences:
* for an "o(X) outside an exceptional set" conclusion (TT 2019) it transfers, giving the almost-all-K
  statement of §2(vi)(b);
* for a "≤ (1−δ)X" conclusion (MR Cor 2) it gives nothing (a difference of two 1−δ bounds is below
  the trivial bound);
* for a **power-saving** conclusion it transfers again, since a difference of two power savings is a
  power saving. So a *conditional* route to a non-trivial bound for the core may already exist:
  if the Landau–Siegel-zero bounds of Jaskari–Sachpazis are of the shape ≪ x/(log x)^A or x^{1−δ},
  then C(K) ≪ K/(log K)^A (resp. K^{1−δ}) under the same hypothesis. (CONFIDENT as to the logic;
  **UNVERIFIED** as to the shape of their bound — I read only the abstract.)

**The one genuine asymmetry I found** (CONFIDENT, from MR's own text): for **h = 1** their Corollary 2
also holds for a larger class of multiplicative f — those that are merely *completely multiplicative
at the prime 2* — which the h ≥ 2 statement does not claim. That is a statement about generalising the
*function* f, using the parity of 2 in the configuration n, n+1. It gives λ no extra strength, and it
is the closest thing to an h = 1 special feature in the un-averaged theory.

**A second asymmetry, in the opposite direction** (UNVERIFIED, flagged because it is the only place
the core could presently be *weaker* than the full-shift statement): the literature's un-averaged
packaging concerns full shift sums. I did not find any statement of a non-trivial bound for the
odd-restricted sum Σ_{k≤K} λ(2k−1)λ(2k+1), and it does not follow from MR Cor 2 (h = 1) plus
MR Cor 2 (h = 2). Whether MR's method adapts to the odd-restricted sum I do **not** claim either way.
I have a heuristic in which a near-maximal core forces λ to be constant on long runs of odd numbers,
making short-interval averages of λ over [x,x+H] of size ≈ 1/2 for most x and contradicting
MR Thm 1; I am **not** presenting this as a proof, and I make **no claim of progress**. Anyone
wanting to use it must supply: a rigorous passage from "the core sum is ≥ (1−ε)K for arbitrarily
large K" to "a positive proportion of short intervals [x,x+H_i] carry a run of ≥ H_i constant odd
values, at a scale where MR's exceptional-set bound applies".

**What a proof would have to supply.** By §2, a successful route must produce a *non-averaged* input
that sees a **bilinear statistic of λ at additively related arguments**, and it must do so at a
**prescribed scale and prescribed shift**. The three families that could in principle supply it, none
of which exists:

1. **A Type-II input for a rigid one-variable factorisation** — i.e. a bilinear estimate for
   `Σ_k α_k λ(2k−1)λ(2k+1)`-type sums that does not come from averaging over a dilation. Everything
   known in this direction is either the *averaged* Chowla theorem or the *linear* short-interval
   uniformity results (e.g. MRTSTT's nilsequence correlations for μ, Λ, d_k, which are correlations
   of f with a nilsequence, not with a shift of f — so they do not see this object). (CONFIDENT for
   the applicability verdict; the existence question is OPEN.)
2. **An un-averaged version of the entropy decrement at the two-point level** — equivalently, a proof
   of Lemma U(h). (STRUCTURAL gap; no proposal exists that I am aware of.)
3. **A genuinely new positivity mechanism for a degree-2 object.** The obstacle is §1.3: the core's
   second moments are again λ-correlations. Any such mechanism must therefore apply to the whole
   family {odd part of shift-h, h odd} at once — which is, in particular, a family that contains the
   h = 1 odd-shift objects. (PLAUSIBLE.)

**Do I believe the core is reachable by the same machinery?** No. Not because the core is special, but
because the machinery that "reaches" h = 1 also reaches the core and stops at an averaged statement
in both cases. The core is not a narrow target that is one technical lemma away from the h = 1
argument; the two are the same open problem seen through the two parities of m in Σ λ(m²−1).

---

## 5. Numerical experiments (finite range only)

Two scripts, both in this directory, run at N = 10⁸ (exact λ by a numpy prime-power sieve; 4 s):

* `core_probe.py` → `core_probe_N1e8.log`
* `core_probe2.py` → `core_probe2.log`

**What was verified exactly.**

1. `S_2(x) = S_1(⌊x/2⌋) + C(⌊(x+1)/2⌋)` — discrepancy **0** at x = 10³, 10⁵, 10⁷.
2. `S_2(x) = Σ_{m=2}^{x+1} λ(m²−1)` — discrepancy exactly ±1, equal to the single omitted boundary
   term −λ((x+1)²−1) (checked by hand at x = 10: λ(120) = (−1)⁵ = −1; at x = 1000:
   λ(1001·1003) = λ(7·11·13)·λ(17·59) = (−1)(+1) = −1). So the identity holds exactly.
3. `Σ_{k≤K} c(k)c(k+1) = Σ_{k≤K} λ(2k−1)λ(2k+3)` — discrepancy **0** at K = 10, 10³, 10⁶.

**What was measured.**

* Normalised sums at 5×10⁷: `S_1(x)/x = +4×10⁻⁵`, `S_2(x)/x = −4×10⁻⁵`, `C(K)/K = +5×10⁻⁵`.
* Random-walk normalisation: `max_{K≤5×10⁷} |C(K)|/√K = 2.13`, against iid ±1 controls 1.93, 2.47,
  2.85 — i.e. the core looks like a random walk to the eye of this statistic.
* Dyadic blocks: every block sum / √(block length) is O(1) (all |z| ≤ 1.9 over 23 scales) — the
  cancellation is spread over scales; there is no single bad scale.
* Local bias: `max_{q≤120, a} |Σ_{k≤K, k≡a (q)} c(k)| / √(K/q)` = 4.02 for the core, versus 3.66 worst
  and 2.48 median for a random ±1 control — nothing anomalous. (A pretentious conspiracy λ ≈ χn^{it}
  would show here.)
* **Run lengths** (the observable MR-type arguments bite on): the core sequence has a longest run of
  +1 of length 23 and of −1 of length 26, against log₂n = 25.6 and random controls 23–26; the h = 1
  sequence gives 24 and 26. **The core is indistinguishable from the h = 1 sequence in exactly the
  statistic that the 1−δ proof uses.**
* Bias: the fraction of +1 in the core is 0.50003 overall; per dyadic block all deviations are
  ≤ 0.7√len.

**What this does and does not say.** It confirms that the elementary reductions in §1 are exactly
right, and it exhibits no visible structure distinguishing the core from the shift-1 sequence. It is
**finite-range evidence only**: no finite computation decides o(x), and none of it is evidence for
the conjecture. Its value is the reverse direction — a gross conspiracy (a periodic or pretentious
component, a single bad scale, anomalously long constancy) would have been visible, and there is none
up to 5×10⁷.

---

## 6. Confidence ledger

**CONFIDENT (verified from primary sources this session):** the exact content of MR Cor 2 (all h ≥ 1,
including the 1−δ form and the extended class of f for h = 1); MR Thm 1 and Thm 2 statements; MRT
averaged-over-shifts theorem and the sentence "remains unproven for any k ≥ 2"; MRT sign-pattern
result being positive lower density, not o(x); Tao's log-averaged affine-forms theorem and its tool
list; TT 2019's almost-all-scales k = 2 theorem and "no further cases of the unweighted Chowla
conjecture are currently known"; Pilatte's bound and its comparison to Helfgott–Radziwiłł;
Jaskari–Sachpazis being conditional on a Landau–Siegel zero and covering all k ≥ 2; MRTSTT's
nilsequence-correlation scope (μ, Λ, d_k).

**CONFIDENT (elementary, verified numerically here):** §1.1, §1.2, §1.3 identities; the failure of
multiplicativity of λ(n)λ(n+2); that C = S₂ − S₁(x/2) yields no non-trivial bound from MR Cor 2; that
Lemma U(h) (if true) implies the un-averaged statement; and the derived transfer
`C(K) = o(K)` for all K outside a set of zero logarithmic density (from TT 2019 applied to S₁ and S₂
plus the exact identity — a derivation I make here, not a quoted theorem about the core).

**PLAUSIBLE (standard understanding, not verified here):** that the entropy decrement intrinsically
consumes an average; that the linear-vs-bilinear diagnosis of §2(vi) is the right one-sentence
explanation; that the FI sieve's parity-breaking input is a Type-II/bilinear hypothesis of the shape
described; that the Siegel-zero conditional results cover exactly the pretentious case; that a new
positivity mechanism is the only non-contradicted route.

**UNVERIFIED (do not rely on):** whether any non-trivial (1−δ-type) bound for the **odd-restricted**
core sum is in the literature (I did not find one); whether MR's method adapts to it (I have a
heuristic only, no proof, no claim); the exact hypothesis list of the Friedlander–Iwaniec asymptotic
sieve (I state its shape, not its formulation); which Tao–Teräväinen paper the brief means by an
almost-all-**shifts** result; the internal reason TT 2019's exceptional set cannot be removed; whether
anything after 2019 has changed the un-averaged picture (I searched and found nothing, but
"no result found" is not proof of absence — the strongest verified statement remains TT 2019's, plus
Pilatte's 2023/2026 remark that the log-averaged bound is "best possible with current methods").

**Explicitly not used:** the search space contains non-peer-reviewed and evidently unreliable claims
of an unconditional proof of Chowla (a ResearchGate item "via Exact 2-Adic Profile Decomposition", and
Zenodo preprints on "Perron/Sobolev" and a "structural barrier to linear sieve methods"). I did not
read them for content and cite none of them. Nothing in this report depends on them.

**Worked examples of the discipline:** I have not stated any theorem I did not verify; I have not
claimed progress on Chowla; the three places where I go beyond quoting the literature are (a) the
transfer of TT 2019's almost-all-scales theorem to the core via `C = S₂(2K) − S₁(K)` (§2(vi)(b),
labelled as a derivation I make, not a quoted theorem), (b) the 1−δ heuristic for the core (§4,
explicitly not a proof, no claim), and (c) the reading of the linear/bilinear diagnosis (§2(vi),
PLAUSIBLE).

---

## 7. Sources (all fetched/verified this session unless marked)

1. K. Matomäki, M. Radziwiłł, *Multiplicative functions in short intervals*, arXiv:1501.04585
   (Ann. of Math. 2016) — Thm 1, Thm 2, Cor 2, and the Hildebrand quotation.
2. K. Matomäki, M. Radziwiłł, T. Tao, *Sign patterns of the Liouville and Möbius functions*,
   arXiv:1509.01545 (Forum of Math. Sigma) — Thms 1.6, 1.9 and the surrounding discussion.
3. K. Matomäki, M. Radziwiłł, T. Tao, *An averaged form of Chowla's conjecture*, arXiv:1503.05121
   (Algebra Number Theory 9 (2015) 2167–2196) — abstract, theorem, and the "unproven for any k ≥ 2"
   sentence.
4. T. Tao, *The logarithmically averaged Chowla and Elliott conjectures for two-point correlations*,
   arXiv:1509.05422 (Forum of Math. Pi) — abstract.
5. T. Tao, J. Teräväinen, *The structure of correlations of multiplicative functions at almost all
   scales…*, arXiv:1809.02518 — abstract; §1.1 including "No further cases of the unweighted Chowla
   conjecture are currently known"; Thms 1.5, 1.6.
6. C. Pilatte, *Improved bounds for the two-point logarithmic Chowla conjecture*, arXiv:2310.19357 —
   abstract (incl. the Helfgott–Radziwiłł comparison).
7. M. Jaskari, S. Sachpazis, *The Chowla conjecture and Landau–Siegel zeroes*, arXiv:2409.10663
   (Math. Proc. Camb. Phil. Soc.) — abstract.
8. P. Borwein, S. K. K. Choi, H. Ganguli, *Sign changes of the Liouville function on quadratics*,
   arXiv:1109.3107 — for the statement that Chowla's conjecture for degree > 1 is wide open.
9. K. Matomäki, X. Shao, T. Tao, J. Teräväinen, *Higher uniformity of arithmetic functions in short
   intervals I*, arXiv:2204.03754 (Forum of Math. Pi 11 (2023), e29) — abstract (scope: nilsequence
   correlations of μ, Λ, d_k).
10. *(Not read, cited as context only, marked UNVERIFIED: J. Merikoski's work on the largest prime
    factor of n²+1 / almost-primes in quadratic polynomials; Iwaniec's almost-prime theorem for n²+1;
    the classical Selberg/Friedlander–Iwaniec/Bombieri formulations of the parity problem and of the
    asymptotic sieve.)*
11. Workspace items referenced (this repository, verified by their own ledgers):
    `research/twin-prime-parity/cone/residue-verdict.md` and the machine-checked modules it cites
    (`chowla_not_multiplicative`, `chowlaAF_not_conv`, `dft_autocorr`,
    `shift_average_does_not_control_single`, `scale_average_does_not_control_prescribed`,
    `chowlaSum_tendsto_iff_patCount_tendsto`).
