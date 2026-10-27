# Round 112 — is 4 universal, and do windows help?

*Plan fixed at the start of the round (`rounds.log`, BEFORE line).*

---

## 1. The envisioned path

Round 110 measured the parity factor `4` at `θ = 1/2` for `q = 3` (large `n`) and `q = 5` (small `n`). Two
things could undercut that measurement, and both are testable cheaply:

1. **Is `4` universal, or an accident of `q = 3`?** If the factor depends on `q` at fixed `n`, then it is not
   the dimension constant but a finite-`q` artefact.
2. **Do degree windows systematically reduce the main-term error?** The programme's premise is that segmented
   window counting beats pointwise counting. If the window error decays like `L^{−1/2}` in the window length
   (random phases), windows are the right estimator; if the error merely fluctuates with the window position,
   they are not.

## 2. Wild guess 53

> **Wild guess 53.** Averaging over a window of `L` consecutive degrees suppresses the main-term error like
> `L^{−1/2}`, because the `q^{n/2}` oscillations have effectively random phases across `n`.

**Why guess it.** The error `E(n)` is a sum of oscillating terms (round 109). Random phases would give the
usual square-root cancellation, which is exactly what makes windowed estimators valuable.

**Falsification test.** Compute `W = Σ_{n∈window} T(n)` and `M = Σ main(n)` for windows of length `2..5` at
`q = 3`, and tabulate the relative error `|W − M|/M`. A decay like `L^{−1/2}` confirms; a position-dependent
fluctuation refutes.

## 3. Results

### 3.1 The factor at fixed `n` is not universal — it is asymptotic

| `n` | `q = 3` | `q = 5` | `q = 7` | `q = 11` | `q = 13` | `q = 17` |
|---|---|---|---|---|---|---|
| 4 | — (T = 0) | — (T = 0) | 2.66 | 2.61 | 2.71 | 2.57 |
| 6 | 3.61 | 4.03 | 3.28 | — | — | — |

So at fixed small `n` the ratio is `2.6–4.0` and depends on `q` in a non-monotone way. It approaches `4` only
as `q^n` grows: `q = 3` at `n = 10, 12` gives `4.01, 4.00`; `q = 5` at `n = 6` gives `4.03`.

The natural reading is a correction of relative size `≍ n²/q^{n/2}` with oscillating sign — the same
Weil-scale error as round 109, transported to the sieve ratio. That is consistent with everything else the
programme has measured, and it means **the parity factor is an asymptotic constant**, not an identity at each
`n`. The honest statement is `lim_{q^n→∞} bound/truth = 4`, established at two `q` and large `n`.

### 3.2 Windows do not give systematic cancellation

Relative error of the main term, `q = 3` (single terms first):

| `n` | 6 | 7 | 8 | 9 | 10 | 11 | 12 |
|---|---|---|---|---|---|---|---|
| rel. error | 25.2% | 15.2% | 11.4% | 9.1% | 7.7% | 0.9% | 3.0% |

Windows:

| window | `L` | rel. error |
|---|---|---|
| 6..9 | 4 | **0.34%** |
| 7..10 | 4 | 4.23% |
| 8..11 | 4 | 0.91% |
| 9..12 | 4 | 1.69% |
| 9..11 | 3 | 0.45% |
| 10..12 | 3 | 1.38% |
| 11..12 | 2 | 2.41% |

Some windows are dramatically better (`6..9` at 0.34% versus 25% pointwise at `n = 6`), but the improvement is
**position-dependent, not length-dependent**: at fixed right end `12`, the error goes `2.41% → 1.38% → 1.69%`
for `L = 2,3,4`. There is no `L^{−1/2}` trend.

**Wild guess 53 is refuted.** The oscillations do not behave like random phases; they are a single
deterministic spectrum, and a window can land on a lucky cancellation or a unlucky one. A windowed estimator is
therefore not self-validating: it needs the error term to be *bounded*, which brings the programme back to the
Weil-scale control of round 109.

### 3.3 Lean

The dimension-`k` local factor is now proved for `k = 3` alongside `k = 2`
(`SieveLocal.card_roots_mul = 2`, `card_roots_prod = 4`, `card_roots_three = 8`): the `2^k` in
`A[d,e] = 2^{ω(lcm)} q^{−deg lcm}` is a theorem, not a convention.

## 4. What this round adds

* The parity factor `4` is asymptotic; at fixed small `n` it fluctuates with `q` in the way the Weil-scale
  error predicts.
* Segmented windows do **not** provide systematic error reduction; they inherit the deterministic error.
* So the window method can only work if the error is controlled analytically — which is the same demand as
  before, not a way around it.

## 5. Next round (113)

The remaining untried mechanism is the **second-moment (large-sieve) route**: bound `Σ_f |Σ_{d|f} λ_d|²` over a
family of moduli using orthogonality, rather than a single square weight. Over `𝔽_q[x]` that is a theorem
(Fourier analysis on `𝔽_q[x]/(d)`), and it is the mechanism that actually proves the function-field asymptotic.
Round 113 sets it up and measures whether it reaches the truth where the `Λ²` bound stopped at `4×`.
