# The twin-prime parity programme — cross-phase synthesis

*Written at round 124 of phase 020. Covers phases 018, 019 and 020.*

---

## 1. What the programme is

Three phases, one question: **what exactly blocks the twin prime problem, and can the function-field model
measure the block?**

| phase | directory | question | outcome |
|---|---|---|---|
| 018 | `018/` | transposed to `𝔽_q[x]`, which statistics see twins? | a map: separation theorem, `d=4` cap, closed forms, parity theorem |
| 019 | `019/` | the last character-sum identity — test it | hypothesis sharpened to `q ≡ 1 (mod 8)`; corrected `χ₂(2c)` form verified at 80 primes |
| 020 | `020/` | can a sieve, window, or second moment cross the barrier? | four mechanisms measured; all fail by computable factors |

---

## 2. Phase 018 — the barrier

* **Separation.** The zeta of a qrime set determines exactly its degree counts; no function of it determines
  the twin count. Witness over `𝔽₇`; Lean-checked.
* **The `d = 4` cap.** For every quartic over `𝔽_q`, `|(−Im g) ∪ Q| ≥ (q+1)/2`. Proved modulo Ritt,
  Poincaré reducibility and the `S₄` decomposition; the algebraic links are Lean-checked.
* **Closed forms.** `T` is a DFT of class counts; `A = (3q²+2q+3)/16`; `m = (a²+1)/2` verified at 28 primes and
  identified with `J(χ₄,χ₄)`.
* **Parity theorem.** Bounded-support divisor sums are periodic; the twin indicator is not. Hence no
  finite-level Selberg sieve can equal it. Proved and Lean-checked.

## 3. Phase 019 — the identity

The remaining arithmetic of 018 is one twisted-Parseval identity. Phase 019 made the test exact (elements of
`ℤ[ζ_q]`, compared modulo `Φ_q`) and ran it at every prime `q ≡ 1 (mod 4)` up to 1000:

* the identity **as stated** holds exactly at the `37` primes `≡ 1 (mod 8)` and fails at all `43` primes
  `≡ 5 (mod 8)`;
* the corrected form `Σ_A χ₂(A)|K(A,c)|² = 2χ₂(2c)√q Re J²` holds at **all 80**;
* the algebraic splitting step is Lean-certified.

So the hypothesis is exactly `q ≡ 1 (mod 8)`, and the identity remains open.

## 4. Phase 020 — the mechanisms

Over `𝔽_q[x]`, with `S(q)` the twin singular series:

| mechanism | measured failure | round |
|---|---|---|
| `Λ²` square weight, level `n/2` | exactly `4×` the truth asymptotically | 110, 112 |
| bilinear pair weight | indefinite form; no bound at all | 111 |
| degree windows | position-dependent error; no `L^{−1/2}` cancellation | 112 |
| large sieve | slack of order `n` (bound `≍ q^n/n` vs main `q^n/n²`) | 114 |

Plus the supporting structure:

* the exact expansion with its boundary stratum, whose coefficients are `0/1` (Lean);
* the degree grading that makes the Legendre sieve exact at `y = n/2` (Lean);
* the dimension law: the factor is `2^dim` — `2` for qrimes, `4` for twins — and `χ₂(2)` does not enter it;
* polynomial shifts obey the modified singular series `S_h = S·Π_{Q|h}(Q−1)/(Q−2)`, and the factor stays `4`
  even when every linear prime divides `h`;
* the shift law: `T(n;h)` is exactly the orbit decomposition under `⟨(𝔽_q^×)^n, −1⟩` (11/11 cases);
* the main term holds with `|E|/q^{n/2} ∈ [0.008, 0.30]` for `n ≤ 14` at `q = 3`, and `T(13) = 3747`,
  `T(14) = 9510`.

## 5. The one conclusion

**The barrier is dimensional.** A `k`-condition problem is bounded `2^k` times above the truth by the best
square-weight sieve, and the deficiency depends on the number of conditions, not on local densities. Every
other mechanism fails for the same reason: none resolves the two conditions *jointly and exactly*. What does is
equidistribution of the pair `(f, f+2)` — supplied over `𝔽_q[x]` by the Frobenius, unavailable over `ℤ`.

**The transfer demand.** A proof over `ℤ` needs a **grading substitute**: a canonical, error-controlled
truncation of the Möbius sum. Over `𝔽_q[x]` the degree provides it; over `ℤ` the truncation error is the
two-point Chowla correlation.

## 6. Proved versus measured

**Proved (Lean 4, standard axioms; `020/lean`, twelve modules):** shift-invariance of local factors; the local
factor `2^k`; the local-factor dichotomy `|F|−1` vs `|F|−2`; the degree-grading lemma; the boundary `0/1`
lemma; the linear base case; the `±h` orbit size; the Cauchy–Schwarz and support-size steps; window
concatenation; the ratio `(Q−1)/(Q−2)` and its algebra.

**Measured (exact finite computation, `020/checks`, 35 audited claims):** every constant above — the factor
`4`, the error ratios, the orbit counts, the large-sieve slack, the polynomial-shift series.

**Not proved:** the asymptotic `T(n) ~ S(q)q^n/n²` at fixed `q` (conjectural in the literature the 018 notes
searched), the polynomial-shift version, and the 019 identity.

## 7. What a successor programme should do

1. **Formalise the 2D equidistribution input.** That is the mechanism that actually proves the function-field
   asymptotic; everything else has been measured and is closed.
2. **Attack the fixed-`q` asymptotic.** It is the model's central open statement; phase 020 supplies the
   numerics any proof must match.
3. **Search for a grading substitute over `ℤ`.** The most concrete formulation of the transfer problem the
   programme produced.
4. **If continuing the sieve direction:** the only unexplored family is non-square weights with a positivity
   structure other than `Λ²`; the bilinear family is provably dead.

## 8. Reproduction

```
018/   source programme (106 notes, 45 Lean modules, 111 checks)
019/   the χ₂(2c) test: exact, 80 primes, Lean splitting step
020/   phase 020: 18 rounds, 12 Lean modules, 20 tests, 35-claim audit
provenance/rounds.log          one line before and after every round
provenance/objectives.json     the objective and round ledger
```
