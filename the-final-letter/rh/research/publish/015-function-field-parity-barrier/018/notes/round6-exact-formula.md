# Round 6 — the exact degree-3 formula, the degree-4 contrast, and the complexity guess

Round 5 read the twin count as a Frobenius trace and found that the "clean"
degree-3 formula holds exactly in the supersingular case. This round **decodes
the exact Bary-Soroker–Stix formula** (arXiv:1711.05564), verifies it against
the sieve for both shifts, probes degree 4, and sharpens the wild guess.

---

## 1. Established direction — the exact degree-3 formula

**Theorem (Bary-Soroker–Stix, Thm. 1.2 & 1.4).** For a prime power `q` and
`h ∈ 𝔽_q^*`, with `E: Y²−Y=X³` and its cubic twist `E_h: hX³=Y(Y−1)`, put
`c_q = (1+q−#E(𝔽_q))/√q` and `c_{q,h} = (1+q−#E_h(𝔽_q))/√q`. Then

```
π(3,q;(0,h)) = q³/9 · {
  1 − q⁻¹ − 3q⁻²                      if q ≡ 0 (mod 3),
  1 + (c_q² − 3)·q⁻¹ − 2q⁻²           if q ≡ 1 (mod 3) and h is a cube,
  1 + c_q·c_{q,h}·q⁻¹ − 8q⁻²          if q ≡ 1 (mod 3) and h is not a cube,
  1 − q⁻¹ − 2q⁻²                      if q ≡ 2 (mod 3),
}
```

where `π(3,q;(0,h)) = #{f monic, deg f = 3 : f and f+h both irreducible}`.

**Verification against the sieve.** `checks/round6_exact.py` and
`tests/test_bsstix.py` check, for every prime `5 ≤ q ≤ 73`:

* `π(3,q;(0,1))` equals the direct count for shift 1;
* `π(3,q;(0,2))` equals the direct count for shift 2 (our `T(3)`);
* the right-hand side is an integer (denominator 1).

The branch is real: `h = 2` is a cube exactly for `q = 31, 43, …` among the
`q ≡ 1 (mod 3)`, and the formula switches branch there. For `q ≡ 2 (mod 3)`,
`h = 2` gives the same count as `h = 1` (both branches collapse to
`1 − q⁻¹ − 2q⁻²`), which is why rounds 3–5 could compare `T(3)` to the
shift-1 "clean" formula.

**Reading.** The exact formula is a *sum of Frobenius traces*:

* `c_q²` in the cube branch (the square is `c_q² = n²/q` with
  `n = 1+q−#E`; no square roots in exact arithmetic);
* `c_q·c_{q,h}` in the non-cube branch (the product of the trace of `E` and the
  trace of its cubic twist).

The `q ≡ 2 (mod 3)` case is exactly `c_q = 0` (supersingular), so only the
polynomial part survives. This is the precise form of round 5's "clean part =
trivial cohomology, ordinary part = `H¹`" reading.

**Lean.** `lean/Cubic.lean` now checks both branches at a fixed field:

* `CubicTwins.cubicTwin_five : cubicTwin = 10` (`F₅`, supersingular, shift 2);
* `CubicSeven.cubicTwin_seven : cubicTwin7 = 35` (`F₇`, **ordinary**, shift 2;
  the clean formula would give `280/9`).

---

## 2. Degree 4 — the dichotomy does not persist

Computed `T(4)` for all primes `5 ≤ q ≤ 61` (`lib/fast_twin.py`) and compared
`16·T(4)/q⁴` to `S(q)`:

| `q` | 5 | 7 | 11 | 13 | 17 | 19 | 23 | 29 | 31 | 37 | 41 | 43 | 47 | 53 | 59 | 61 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| `16T₄/q⁴ / S(q)` | .722 | .918 | .971 | .944 | 1.004 | .991 | .994 | .977 | .997 | 1.003 | .974 | .998 | .999 | 1.001 | .999 | .994 |

The relative deviation `E(q) = 16T(4)/q⁴ − S(q)` fits

```
|E(q)| ≈ q^{−1.04}     (q ≥ 17) ,
```

much better than the worst-case `O(q^{−1/2})` of the general theorem, and with
**no congruence-class split** analogous to the `q ≡ 2 (mod 3)` dichotomy of
degree 3. The `q ≡ 1` and `q ≡ 2` values interleave.

**Reading.** Degree 3 is a low-dimensional miracle: the parametrising variety is
an `𝔸¹`-bundle over the complement of a divisor on a hyperelliptic surface
covered by `E × E` (Bary-Soroker–Stix, Thm. 1.5), and the elliptic curve has a
one-parameter supersingular locus. Degree 4 lives on a higher-dimensional
variety, the trace is a sum of more terms, and the arithmetic does not collapse
into a simple "clean vs ordinary" dichotomy.

---

## 3. Wild guess 6 — the barrier is cohomological complexity in `d`

Round 5's preview was an "archimedean" guess. The degree-4 contrast suggests a
sharper form, of which the archimedean story is one face.

> **Wild guess 6.** The twin count in degree `d` is a trace on a variety `V_d`
> whose cohomological complexity grows with `d`. Degree 3 is solvable because
> `V_3` is essentially an elliptic curve with a one-parameter supersingular
> locus. For `d ≥ 4` the trace lives on a higher-dimensional variety with no
> simple dichotomy, and the deviation from `S(q)q^d/d²` is a genuinely
> higher-dimensional arithmetic fluctuation. Over `ℚ`, the twin motive has
> **unbounded rank**, and the parity barrier is the absence of a *stable*
> cohomology theory for the `V_d` as `d → ∞`. Crossing the barrier would be a
> "motivic large sieve": a uniform trace formula for `V_d` in the stable range.

**Why this is a guess.** We have no construction of `V_d` over `ℚ`, no stable
range theorem, and no evidence that such a theory exists. What we do have is the
degree-3 exact formula (a genuine trace), the degree-4 contrast (the dichotomy
disappears), and the general theorem's error constant depending on `d`
(Pollack's `(n!)^B`), which is the analytic shadow of the same growth.

**What would falsify it.** A uniform-in-`d` exact formula, or a stable
cohomology computation that keeps the clean/ordinary dichotomy for all `d`,
would show the complexity picture is too pessimistic.

**Relation to the dictionary.** This is the "automorphic/spectral" route of
`03-parity-problem.md` §5.4, made specific: the missing input is not a better
sieve weight but a *uniform trace formula* for the twin varieties.

---

## 4. Honest verdict

* **Established this round:** the exact degree-3 formula is decoded and verified
  for both shifts over all primes `5 ≤ q ≤ 73`; the branch structure (cube /
  non-cube / supersingular) is real; Lean checks both the supersingular (`F₅`)
  and ordinary (`F₇`) cases; degree 4 has deviation `≈ q^{−1.04}` with no
  congruence split.
* **The wild guess:** coherent, supported by the `d = 3` vs `d = 4` contrast,
  not testable over `ℚ`. It reframes the barrier as *unbounded cohomological
  complexity*, not as a missing sieve estimate.
* **Not claimed:** that `V_d` exists over `ℚ`; that a stable cohomology theory
  exists; that this route is necessary.

## 5. Next round

1. **Degree 5.** Is there any congruence-class split left? Compute `T(5)` for
   enough `q` and fit; the complexity guess predicts none.
2. **Generating function.** Form `F(t) = Σ_d T(d) t^d / q^d` in the
   `q → ∞` limit and ask whether it is rational / algebraic (a "stable" object).
3. **Wild guess 7 (preview).** *The barrier is the failure of the twin
   generating function to be rational: in `𝔽_q[x]` the exact formulas for each
   `d` assemble into a rational/algebraic generating function whose denominator
   is the L-function; over `ℚ` the generating function is not rational.*
   Investigate: compute `F_d = lim_{q→∞} T(d)/q^d` for `d ≤ 6` and test for a
   recurrence.

---

## 6. Reproduction

```
python3 checks/round5_lfunction.py    # exit 0
python3 -m pytest -q tests/           # 116 passed
cd lean && ./check.sh Cubic.lean Axioms.lean   # OK
```

New files this round: `lib/bsstix.py`, `tests/test_bsstix.py`, and the `F₇`
section of `lean/Cubic.lean`.
