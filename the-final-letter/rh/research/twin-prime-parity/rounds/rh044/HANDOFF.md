# rh044 — the smoothing bridge: from the finite-`N` balance to the zeros of ζ

**Question of the round** (the gap left open by [`../rh43/truths.md`](../rh43/truths.md) §7.6).

rh43 established: at `Re(S) = 1/2` the terms have radial decay `n^{-1/2}`, the split
is `P_N, |M_N| ~ (2/π)√N` each, and the balance condition `Re S_N(1/2 + it) = 0` has
roots — but those roots are *generic* oscillations of the Dirichlet polynomial
(height scale `1/log N`, clustering at `t → 0`), not zeros of `ζ`.  The reason was
locating the zero needs `o(1)` control of

```
S_N(1/2+it) − ζ(1/2+it)  =  O(√N)        (sharp cutoff)
```

so no finite-`N` balance condition can see a zero.  rh044 asks: **can a
smoothing/summation method (Euler–Maclaurin, Abel/exponential summation, or the
explicit formula) replace the sharp cutoff and extract `ζ` to `o(1)` — even
exponentially small — accuracy?**  If yes, the bridge is built and the finite-`N`
split can be used to locate zeros; if there is an obstruction, it must be stated
with its witness.

---

## 0. What is verified before any claim is made

Reconnaissance (system Python, mpmath at 40–120 dps, `t = 14.134725141734693`,
`|ζ(1/2+it)| ~ 1e-16`):

| `N` | `\|S_N − ζ\|` sharp | fluctuation `\|S_N−ζ\|/√N` | `\|E_N − ζ\|` exponential weight |
|---|---|---|---|
| 100 | 0.70939 | 0.07094 | 0.012064 |
| 200 | 1.0014 | 0.07081 | 0.0058355 |
| 400 | 1.415 | 0.07075 | 0.0039575 |
| 800 | 2.0004 | 0.07073 | 0.00077569 |
| 1600 | 2.8286 | 0.07071 | 0.0031778 |

Two facts, both new to this round (rh43 asserted the first qualitatively; the
constant `1/√(2t)` is now identified):

1. **The sharp cutoff does not converge *at a zero* in the practical sense**: the
   difference grows like `√N`, with the exact constant `1/√(2t) = 0.0707036…` — the
   measured column `|S_N−ζ|/√N` is `0.07094, 0.07081, 0.07075, 0.07073, 0.07071`.
   The partial sum itself is `≈ √(N)/(√2 t)`, i.e. it never "sees" the zero.
2. **Smoothing removes the fluctuations** (the error drops by a factor ~100 at
   `N = 800`), but the residual is *still algebraic*, an oscillating tail.  The
   candidate laws to be settled in this round:

   * `|S_N^φ − ζ| = O(N^{-σ})` for a smooth weight `φ` with `φ(1) ≠ 0`
     (on the critical line: `O(N^{-1/2})`);
   * the fluctuation term `O(√N)` of the sharp cutoff is eliminated by *any* weight
     with `φ(1) = 0`;
   * `|E_N^exp − ζ| = O(N^{σ-1})` for the exponential weight `e^{-n/N}`
     (`O(N^{-1/2})` on the critical line);
   * **exponential** accuracy requires the functional equation: the classical
     `ζ(s) = (1/(s-1)) + (1/s) θ-integral` (Riemann's theta smoothing) gives
     `|ζ − ζ_θ| ≤ e^{-πN}` with `O(√N)` terms, and that is the only route here that
     reaches `o(N^{-A})` for every `A`.

The round's job is to make these quantitative, to build the theta-smoothed ζ
evaluator, and to locate the first zeros with it — or to record the obstruction
with its witness if one of the laws is false.

---

## 0.5 Outcome (filled in as the round closed)

The reconnaissance laws of §0 were **partly wrong**, and the corrections are the
round's most useful output:

* the sharp-cutoff constant is `1/|s−1| = 1/√(1/4+t²)`, **not** `1/√(2t)`
  (factor 2.66 at `t = 14.13`);
* **smoothing does not remove the `√N`**: `|S_N^φ − ζ|/√N → |M_φ(s)| =
  |∫_0^1 φ(u)u^{−s}du|`, verified to 5–7 digits for six weights; the growth exponent
  is `0.5000` for every one of them, and smoothing only rescales the constant (best
  tested weight `(u(1−u))^3`, factor 600);
* exponential accuracy is reachable **only** through the functional equation
  (Riemann's theta identity), verified independently to `1e−64` with an `e^{−πX}`
  tail bound.

The gap of rh43 §7.6 is therefore *identified*, not newly bridged: the missing step
is the functional equation, i.e. Riemann 1859 / Riemann–Siegel 1932.

See [`truths.md`](truths.md) for the ledger (including the four refuted first-draft
claims R1–R4) and [`README.md`](README.md) for the corrected tables.

---

## 1. Targets

* **T1** the sharp-cutoff fluctuation law and its constant: `S_N − ζ ~ −√(N)/(√(2t))`
  at a zero (fit + derivation from the Euler–Maclaurin main term).
* **T2** the smoothed error laws of §0, each verified by log–log fits over at least
  three decades of `N`, with the smoothing factor `φ` and its Mellin transform
  stated.
* **T3** the theta-smoothed evaluator: implement
  `ζ_θ(s) = 1/(s-1) + 1/s + ∫_1^∞ (x^{s/2} + x^{(1-s)/2})(θ(x)-1) dx/x`
  with a rigorous tail bound, and verify `|ζ_θ − ζ| < 1e-30` at the tabulated zeros
  and at `s = 2, 4`.
* **T4** zero localisation: the zeros of the *theta-smoothed* real part on the
  critical line converge exponentially to the true zeros; the zeros of the *sharp*
  partial sum do not (they cluster at the `1/log N` scale, as rh43 found).  Report
  the first five zeros with certified windows.
* **T5** the verdict for rh43's gap, and the parity-problem consequence: state
  exactly which of the four bridges is closed, which is only relocated, and why none
  of them is the multiplicative input the parity problem denies.

## 2. Evidence plan

| evidence | what it is | expected result |
|---|---|---|
| `smoothed_zeta.py` | the round's numerics: sharp vs smooth vs exponential vs theta, the fit tables, the zero localisation | exit 0, all checks pass |
| `verify/independent_check.py` | the auditor's independent route: its own θ-route and its own `ζ` values from `mpmath`'s Euler–Maclaurin/functional equation, no import from the round | exit 0 |
| `lean/Rh044/` | the algebraic layer: the weight identities, the split/error decomposition, the theta kernel algebra | builds clean |

## 3. House rules (unchanged from rh40–rh43)

Exact or rigorously enclosed arithmetic for the object; every reported number carries
its truncation; nothing enters the ledger without an independent recomputation;
refuted statements are kept with their smallest witness.
