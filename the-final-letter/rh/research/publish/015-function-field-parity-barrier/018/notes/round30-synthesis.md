# Round 30 — synthesis and final status

This is the final round of the programme.  The last "wild guess" — that the
`j`-line fluctuation is the elliptic-curve trace `−a_j/2` — is **refuted**, and
this note records the honest state of the whole 30-round arc.

---

## 1. Final investigation — the elliptic-trace guess is refuted

Round 29 found `I(j) = (q−1)/4 + O(1)` on the `j`-line.  The natural guess was
that the fluctuation `m(j) = I(j) − (q−1)/4` is `−a_j/2` for the elliptic curve
with `j`-invariant `j`.  Tested against the standard model
`y² = x³ + 3k x + 2k`, `k = j/(1728−j)` (`j ≠ 0,1728`):

| `q` | 13 | 29 | 37 | 41 |
|---|---|---|---|---|
| corr(`4I−(q−1)`, trace) | +0.30 | +0.25 | −0.10 | −0.18 |
| `m = −a_j/2` holds | 0/13 | 0/29 | 1/37 | 0/41 |

The correlation is weak and the identity fails.  So the fluctuation is **not**
the elliptic trace of the `j`-curve; its source remains open.  (This also kills
the round-29 preview and the round-21/22 "Hecke/`L`-value" readings in their
simplest forms.)

---

## 2. The arc

| rounds | theme |
|---|---|
| 1–4 | separation theorem, curve lift, first constants `S(q)` |
| 5–8 | Frobenius-trace reading, exact `d=3,4` formulas, `Li₂` generating function, `1/q` corrections |
| 9–12 | error barrier, shift averages, character support, `d=5` non-polynomial |
| 13–17 | constant-shift distribution, sieve-union cap, value-set collapse, corrected cap scope |
| 18–22 | cyclic-Galois resolvent, one-point/two-point gap, variance, four-point moment, `B₄` congruence |
| 23–25 | translation divisibility, exact orbit count, `x⁴+b` cap proof |
| 26–29 | depressed quartic, even slice, translation reduction, `j`-invariant, cusp doubling |
| 30 | refutation of the elliptic-trace guess; synthesis |

## 3. What is established

**Formal (Lean, 20 files, 382 tests).**

* the 2-D Chebotarev vs 1-D zeros separation (`Separation.lean`);
* the Möbius inversion `q^n = Σ d·I(d)` (`Mobius.lean`);
* the curve lift and the degree-2/3/4 finite tables (`Curve`, `Quad`, `Cubic`);
* the twin indicator is not multiplicative (`Barrier.lean`);
* `x ↦ x³` is a bijection when `3 ∤ q−1` (`Cubing.lean`);
* the Artin-Schreier collapse and squarefreeness (`ArtinSchreier.lean`);
* the quartic polynomial identity, the extremal factorization, the depressed
  normal form, the even-quartic factorization, the `j`-invariant scaling, the
  cusp witness (`QuarticPoly`, `ExtremalQuartic`, `DepressedQuartic`,
  `EvenQuartic`, `JInvariant`, `Doubling`).

**Computational (33 check scripts).**

* exact constants: `S(3)=0.396104…`, `S(5)=0.709544…`, `S(7)=0.812706…`,
  `S(11)=0.891687…`, `S(13)=0.910723…`;
* exact `d=2,3,4` formulas; generic-class polynomials;
* `d=5` is **not** polynomial (exact interpolation);
* multiplicative-Fourier support on the `d`-torsion characters;
* translation divisibility `q | T(d;q,h)` for `d < q`;
* orbit count `T(4;q,2)/q = 4k(k+1)²` for `q = 4k+3`;
* `B₄(q)/q ≡ 1 (mod 8)` for nine primes;
* the `d=4` cap for `q ≤ 43`; the `x⁴+b` proof for `q ≡ 1 (mod 4)`;
* `j`-line density `1/4`, cusp doubling to `1/2`.

## 4. What is NOT established — the barrier

* the general `d=4` cap (`|Im ∪ Q| ≥ (q+1)/2` for every quartic);
* the individual `T(d;q,2)` for `d ≥ 4` (only the average and the
  `j`-line are known);
* any proof of the twin conjecture over `ℚ`.

The programme has **not** crossed the parity barrier.  It has:

1. formalised the function-field side (separation, exact formulas, constants);
2. shown that the individual twin count is a **two-point** statistic not
   determined by the one-point (sieve) data (round 19);
3. identified the character-sum / diagonal–off-diagonal structure of the
   function-field count (rounds 11, 20);
4. mapped the `d=4` cap to a **cusp phenomenon** on the `j`-line (rounds 25–29).

## 5. Honest bottom line

The function-field twin problem is essentially solved at the level of averages
and exact low-degree formulas; the **individual** count at `d ≥ 4` and the
`ℚ` conjecture remain open.  The rounds' wild guesses have narrowed the
candidate mechanisms to: (i) the one-point/two-point gap, (ii) the character
sum over the cyclic Galois group, (iii) the cusp doubling on the `j`-line.
None of these is a proof.

**Verdict:** the programme achieves its stated objective of *advancing towards*
the barrier — with a complete formal and computational record — but the barrier
itself is not crossed.

---

## 6. Reproduction

```
python3 checks/round30_final.py   # exit 0
python3 -m pytest -q tests/       # 382 passed
cd lean && ./check.sh <all files> # all OK
```

New file this round: `checks/round30_final.py`.  Full index in `README.md`.
