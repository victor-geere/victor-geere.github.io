# Handover — where a successor should start

*Written at the close of phase 020 (round 127). The programme's north star was not reached; this document says
exactly where it stopped and what to do next.*

---

## 1. Read these first (about ten minutes)

1. [`EXECUTIVE-SUMMARY.md`](EXECUTIVE-SUMMARY.md) — one page: findings, conclusion, ledger.
2. [`PROGRAMME-SYNTHESIS.md`](PROGRAMME-SYNTHESIS.md) — the three phases in full.
3. [`020/notes/synthesis.md`](../020/notes/synthesis.md) — phase 020's fourteen findings with statuses.

Then run the harness (§5) before changing anything.

---

## 2. The state of play

**Proved** (Lean, standard axioms): the separation witness; the parity theorem; the degree-grading lemma; the
boundary `0/1` lemma; the local factor `2^k`; the local-factor dichotomy; the shift law's two halves; the window
algebra; the `(Q−1)/(Q−2)` correction; the 019 splitting step.

**Measured** (exact finite computation, 35 audited claims): the parity factor `4 = 2^dim`; the main term
`T = S(q)q^n/n² + E` with `|E|/q^{n/2} ≤ 0.30` for `n ≤ 14`; `T(13) = 3747`, `T(14) = 9510`; the four failure
modes; the orbit law; the polynomial-shift series.

**Open:** the fixed-`q` asymptotic; the polynomial-shift version; the 019 identity; the `d=4` cap's generic case.

**The one-sentence conclusion:** the barrier is a missing *object* — a way to resolve the two conditions
jointly — not a missing estimate; over `𝔽_q[x]` that object is the Frobenius, over `ℤ` it would be a grading
substitute.

---

## 3. Four directions, ordered by how soon they can bite

### D1 — Formalise the pair equidistribution (highest value, heaviest)

The mechanism that actually proves the function-field statement is Chebotarev/equidistribution for the pair
`(f, f+2)`, i.e. for the splitting field of `f(f+h)` as `f` ranges over degree-`n` polynomials.

* **First concrete step:** state and prove the geometric core — the Galois group of `f(f+2)` over `𝔽_q(x)` is
  the fibre product of two `S_n`'s, with the Frobenius acting diagonally. This is the object whose
  equidistribution gives the count.
* **Payoff:** the first machine-checked route to the fixed-`q` statement.
* **Risk:** heavy; needs Mathlib's Galois theory at a level the current modules do not touch.

### D2 — Attack the fixed-`q` asymptotic directly (best value per hour)

The 018 notes record the fixed-`q`, `n → ∞` case as conjectural: the large-`q` theorems have error
`O(q^{n−1/2})`, useless for fixed `q`. Phase 020 measured that the truth has error `O(q^{n/2})` and that the
large sieve is lossy by a factor `n` (round 114).

* **First step:** prove a *one-sided* statement — e.g. `T(n) ≤ (S(q)+o(1)) q^n/n²` — by a method that beats the
  large sieve. The upper-bound sieve is capped at `4×` (round 110), so the method must use the pair structure.
* **Constraint:** any proof must reproduce the measured band (§4).

### D3 — The grading substitute over `ℤ` (the transfer problem)

Over `𝔽_q[x]` the Möbius sum truncates canonically because the degree grades the ring. Over `ℤ` there is no
grading; the truncation error of `1_Irr = Σ_{d|n} μ(d)·[·]` *is* the two-point Chowla correlation.

* **First step:** isolate exactly which property of the grading is used (the notes point at the fact that each
  degree class contributes exactly one unit of mass, so the level sum is quadratic rather than harmonic). State
  it as a theorem about `𝔽_q[x]`, then ask what would replace it over `ℤ`.

### D4 — The one unexplored sieve family (cheapest to scope)

Non-square weights with a positivity structure other than `Λ²`. `Λ²` is capped at `2^dim`; the bilinear family
is provably indefinite (round 111). Anything else that is nonnegative and vanishes off the sifted set is fair
game.

---

## 4. Hard constraints any successful proof must satisfy

1. **Reproduce the numbers:** `T(13) = 3747`, `T(14) = 9510` at `q = 3`, with `|T − S q^n/n²| ≤ q^{n/2}` (the
   measured ratio never exceeds `0.30`); `T(9) = 17265` at `q = 5`.
2. **Not be a bounded-support divisor sum** — excluded by the parity theorem (Lean: `Periodic`,
   `NonPeriodic` in 018).
3. **Not be a square weight at level `n/2`** (factor `4`), a bilinear pair weight (indefinite), a degree-window
   average (no cancellation), or the large sieve alone (slack `n`).
4. **For polynomial shifts**, the singular series `S_h = S·Π_{Q|h}(Q−1)/(Q−2)` must appear.

---

## 5. The harness

```
cd 020
python3 checks/audit.py                  # 35 claims; must print 0 failures
python3 -m unittest discover -s tests    # 20 tests
python3 checks/linkcheck.py              # 0 broken links
cd lean && ./check.sh *.lean             # 14 modules, standard axioms

cd ../../019
python3 -m unittest discover -s tests    # 14 tests
python3 checks/falsification_test.py     # 80 primes
python3 checks/sympy_crosscheck.py       # independent path
```

Add a claim to `audit.py` for every new number you quote. That rule caught two real bugs in this phase
(round 108's truncation, round 109's `ω` counter).

---

## 6. Conventions

* **Status ladder:** proved (human argument) / Lean-certified / measured (exact finite computation) / open /
  wild guess / refuted. Never promote a measurement to a proof in prose.
* **Round protocol:** one line in `rounds.log` before, one after; a note `020/notes/roundNNN.md` with the path
  stated *before* the computation, the wild guess, the results, and the Lean addition; `objectives.json`
  updated each round.
* **Wild guesses** are numbered consecutively; the next number is **68**. A wild guess must come with a
  falsification test, and must be reported as refuted when it is.
* **Keep the distinction visible:** the phase's value is that "proved" and "measured" are never conflated.

---

## 7. What not to redo

| closed | result | round |
|---|---|---|
| `Λ²` at level `n/2` | capped at `2^dim`; `4×` for twins | 110, 112, 118 |
| bilinear pair weight | indefinite; no bound | 111 |
| degree windows | no `L^{−1/2}`; deterministic error | 112 |
| large sieve | slack of order `n` | 114 |
| a closed form for the boundary | `y²P(y)` has no limit | 119 |
| connecting `χ₂(2)` to the sieve cap | orthogonal (Gauss-sum normalisation) | 118 |
| spectrality of `T` | refuted | 107 |

---

## 8. If you have an hour, a day, or a week

* **An hour:** run the harness, read the three documents, pick D2's one-sided statement and write down what it
  would take.
* **A day:** scope D2 or D4 — pick one, write the statement, run the audit on any new number.
* **A week:** scope D1 — state the Galois-group-with-Frobenius object and what equidistribution would give.

---

## 9. Closing note

The phase produced no crossing. It produced a map with numbers on it: which mechanisms fail, by how much, and
why they fail for the same reason. That is the honest inheritance, and it is a useful one — a successor can
skip four dead ends and start from a measured constraint rather than a slogan.
