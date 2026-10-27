# The double-blind debate — two advisors, relayed without attribution

Two expert agents were given an identical brief and **mutually blind** identities: neither
was told which archetype it was, neither learned the other's identity, and every relay was
stripped of attribution. I (the orchestrator) alone hold the mapping. Round 1: both answer
the brief independently. Round 2: each receives the other's verdicts, anonymised, and must
attack them.

*Honest limitation: this is mutual blindness with unattributed relay, not strict double
blindness. I wrote both briefs and therefore know the style instructions; only the advisors
are blind to each other and to their own labels.*

---

## Round 1 — independent verdicts

### Advisor 1

- Constant in Phase 1 is exactly `1/2`; only the alternating-series remainder, no new
  mechanism.
- The rate `(c)` is real and measured: `|s_N − s₀|√N → 0.2656 = (1/2)/|η′(s₀)|`,
  `|η′(s₀)| = 1.882697`. Attribution: **quantitative Hurwitz/Rouché**. But it is a
  **refiner, not a locator**: needs `s₀` already isolated, needs a *certified* lower bound
  `|η′| ≥ μ` (simplicity of zeros is open), and rigorous verification is **Turing's method +
  sign changes of `Z(t)`**, not Newton.
- Not an advance: `(1/2)N^{−1/2}` at `N = √(t/2π)` **is** Gabcke's Riemann–Siegel
  `O(t^{−1/4})`.
- Claim 5 (Mahler) is a **tautology** for the true ladder — reindexing alone; genuine Mahler
  content only for the model `n_j = q^{2^j}`.
- Claim 6 is **false**: two infinite words of distinct letters sum to `1`.
- The digit identity is exact but near-tautological; supports are infinite with
  doubly-exponential indices; **no finite complete set per target**.
- `(a)` classification possible but **information-free**.
- `(b)` no-go for every listed operation. The **provable core**: any statistic of supports
  *alone* is an empirical-measure functional of `θ_n`, which equidistributes to Lebesgue
  **independently of `t`** (confirmed `N = 2·10⁵`), so all such functionals are `t`-free. The
  map discards exactly the pairing with `n`, where the zero information lives.
- The **only live gap** is an exotic factorisation `ζ = Φ∘D` — explicitly **not** killed,
  stated as conjecture with a counting obstruction.
- Background: Spira (zeros of sections of ζ), Turán, Levinson, [arXiv:0807.0019](https://ar5iv.labs.arxiv.org/html/0807.0019).
- **Self-counterargument:** the no-go covers the listed operations and support-only
  statistics; an exotic `Φ` is not excluded, and any construction using the **joint law of
  `(n, θ_n)`** escapes the equidistribution argument.

### Advisor 2

- Accepts 1 (sharpening it to `(N+1)^{−1/2}`), 3, 4, 5, 6.
- **Rejects 2's verdict**: `η_N` has *no* spurious strip zeros below `T ≈ 100`; at `N = 64`
  its zeros sit in `Re ∈ [0.47, 0.53]`. It locates in the plane but cannot certify
  `Re = 1/2`.
- **Rejects 7 (quantitatively).** "`t`-free" needs the empirical measure of `θ_n` to
  converge to Lebesgue **uniformly in `t`**. It does not: KS(empirical `θ/π` vs Lebesgue)
  `= 0.0459 (t=14.13), 0.0258 (30), 0.0045 (100), 0.0006 (1000) ≈ 0.6/t`, i.e. `65×` the
  sampling floor at `γ₁`. Support statistics are **not** `t`-free; they inherit an
  `O(1/t)` tilt. The surviving statement is weaker and unproved.
- **Rejects 8 as dead, not live.** `D` has explicit off-line zeros, and every ζ zero with
  `|Im| ≤ 40` is simple and on `Re = 1/2` (van de Lune–te Riele, Platt), so
  `Z(D) ⊄ Z(ζ)`. Stronger and assumption-free: **if `g` is meromorphic and `≢ 0` then `gD`
  has the same natural boundary `Re s = 0`** (else `D = (gD)/g` would continue too); ζ is
  meromorphic on `ℂ`, so `ζ ≠ g·D(as+b)` for every affine map. **That is a theorem.**
- Also: "649 ζ zeros to `T = 40`" is wrong by two orders of magnitude — `N(40) = 7`,
  `N(1000) = 649`. The counting obstruction built on it is void.
- **The route missed:** the joint law's entire content is the **exact multiplicative
  cocycle** `θ_{mn} = θ_m + θ_n` (`t log` is a homomorphism `(ℕ,×) → (ℝ/2πℤ,+)`). The digit
  map destroys it. So apply the numeration where the cocycle lives — **to the primes**.
  Prediction: digit-word statistics over `p ≤ X` show an explicit-formula-sized anomaly at
  `t = γ_k` absent over all `n ≤ X`. Second miss: the **Sylvester Euler product**
  `L_M(s) = Π_j (1 − s_j^{−s})^{−1}` genuinely exists (pairwise coprimality) and is a
  natural-boundary L-function.
- `(c)` **better than Advisor 1 claims**: exact strip counts; location error
  `(1/2)N^{−1/2}/(1.5 log(γ/2π))`; `N ≥ (log γ)²` for certification.
- **Pre-registered test:** at `T = 200`, `N = 512`, recount in the wider box `Re ∈ [−1,2]`.
  `≈91` ⟹ the alternating structure suppresses spurious zeros; `≈198` ⟹ the narrow box hid
  them and `η_N` is a zero-generator. **Prediction: `91 ± O(1)`.**
- **Self-counterargument:** the no-go rests on `Z(D) ⊄ Z(ζ)` at `|Im| < 40` — a finite check
  evaded by any limit or set-valued transfer; and since KS `≈ 0.6/t` proves support
  statistics *are* `t`-dependent, only an empirical null test (powerless at 20 zeros) stands
  between the programme and a real anomaly.

---

## Round 2 — adjudication, by my own computation

**The pre-registered test was run. It falsifies Advisor 2's prediction, in the programme's
favour.**

| `N` | narrow `Re ∈ [0.05,0.95]`, `T=200` | wide `Re ∈ [−1,2]`, `T=200` |
|---|---|---|
| 16 | 45 | 77 |
| 32 | 63 | 93 |
| 64 | **79** | 113 |
| 128 | **79** | 121 |
| 256 | **79** | 135 |
| 512 | **79** | 160 |

ζ has **79** zeros with `Im < 200`. Predicted `≈91`; actual `79` — the strip count is
*exactly* ζ's, for every `N ≥ 64`. But the wide box grows monotonically toward
`≈(T/2π)log N ≈ 199`, so the spurious zeros are real and live **outside** the strip. Both
halves of Advisor 2's dichotomy were right; its number was wrong.

**Newton seeded at each of the 79 ζ zeros:** `79/79` matched for `N ≥ 128`, mean shift
`0.0061`, max `0.0133` at `N = 512`, against the predicted `0.0117`. The correspondence is
real.

**Advisor 1's claims, verified:** the constant `1/2`, `|η′(s₀)| = 1.8826967`, the "refiner
not locator" verdict in the sense that certification needs Turing, the Mahler tautology, and
the two-words-summing-to-1 counterexample — I reproduced all of them independently
(`1/2+1/3+1/7+1/43+… = 1` and `1/2+1/3+1/44+1/925+… = 1`).

**Advisor 2's claims, verified:** the `N(40) = 7` correction (my own check: `N(40) ≈ 6.3`
by Riemann–von Mangoldt), the off-line zeros of `D` (Phase 3 of the earlier work), and the
natural-boundary permanence argument — which is a valid proof.

**On the `t`-tilt (item 7):** Advisor 2 is right that I must not claim `t`-freeness
*uniformly*. My own KS figure (`0.0197` at `N = 2·10⁵`, `t = 14.13`) was computed on the
**unfolded** phase `t log n/π mod 1`; the folded quantity `θ_n/π` carries the larger
discrepancy Advisor 2 quotes. Both are `≫ N^{−1/2}`, both shrink with `t`. The honest
statement: support-only statistics are *approximately* `t`-free with a smooth `O(1/t)`
tilt, and that tilt is not understood.

## Unresolved — stated, not papered over

1. **The live gap is now narrower but not closed.** After Advisor 2's natural-boundary
   permanence theorem, no *meromorphic* factorisation `ζ = g·D(as+b)` exists. What survives
   is only transfers that **do not preserve `Z(D)`** — multi-step/limit constructions such as
   Euler products. The structural obstruction there is rank: the ladder's exponent counting
   function is `~log log λ`, versus `log n = O(n^ε)` for the divisor lattice.
   *Conjecture (not result):* no Euler-product L-function factors through a Fabry-gap
   Mahler series, because Fabry lacunarity is incompatible with multiplicative closure.
2. **The prime-cocycle route (Advisor 2's proposal) — RUN, and closed.** See
   [`prime-cocycle.md`](prime-cocycle.md). The prime sum **does** carry the zero with the
   exact explicit-formula signature (`|R(γ₁)| = log X + O(1)`: 9.37, 11.52, 14.40, 15.48
   against log X = 9.21, 11.51, 13.82, 15.20; argmax lands on γ₁ for `X ≥ 10⁵`), but the
   **digit-word statistic does not** — max `|z| = 1.30` over the first ten zeros against a
   null of 400 random heights, Bonferroni threshold 2.81 (all-n side: 1.62). The reason is
   structural: `2δ₀−1` is a square wave in the phase, so its odd harmonics relocate the
   signal to `t = γ_k/m`; the digit map destroys the frequency localisation that makes the
   prime route work. Advisor 2's mechanism was right; the digit-word corollary is false.
3. **Certification.** Neither advisor disputes that locating requires certified bounds;
   Advisor 1 says Turing, Advisor 2 says `N ≥ (log γ)²` with `|ζ′(ρ)| ≈ 0.87 log(γ/2π)`.
   They disagree on whether the strip locator is an advance. My reading: it is a clean
   *counter* and a good *locator*, but it sits on known ground (Spira, Turán,
   arXiv:0807.0019) and its zero-location rate is the classical `N^{−1/2}`.
