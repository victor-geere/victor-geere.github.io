# 019 — the F4 falsification test, completed

**Status: the test is complete; the identity is not proved.** This directory contains the moved harvest
([`harvest.html`](harvest.html)) and the work that completes the falsification test of its §2 F4.

---

## 1. What was tested

The 018 programme reduces its arithmetic to one identity (`018/notes/round105-Ksums.md`):

```
sum_A chi2(A) |K(A,c)|^2  =  2 chi2(c) sqrt(q) Re J(chi4, chi4)^2
K(A,c) = sum_w chi2(A^2 - w^2) zeta^{-c w / 4},     zeta = exp(2 pi i / q)
```

verified at `q = 17, 41, 73, 89, 97`. The round-106 harvest called for a falsification test: one more prime.
This directory runs the test at **every prime `q ≡ 1 (mod 4)` up to 1000** (80 primes), for `c = 1, 2, 3`,
**exactly** rather than numerically.

## 2. Method — exact, not floating point

Both sides are elements of the cyclotomic ring `Z[zeta_q]`. Each is represented as an integer vector of length
`q`, and equality is decided by reduction modulo the cyclotomic polynomial `Phi_q(x) = 1 + x + ... + x^{q-1}`.
No tolerance is involved: a pass is a proof for that `q`.

The two building blocks:

* `sum_A weight(A) K(A,c)^2` is assembled as a length-`q` integer vector by summing over `A` first
  (`lib/twisted_parseval.py`);
* `sqrt(q)` is the quadratic Gauss sum `sum_x zeta^{x^2}`, also an integer vector, so the right-hand side is an
  integer vector as well.

## 3. Result

| form | holds | verdict |
|---|---|---|
| strict: `2 chi2(c) sqrt(q) Re J^2` | 37 / 80 | holds at **every** `q ≡ 1 (mod 8)` (37/37); fails at **every** `q ≡ 5 (mod 8)` (0/43) |
| general: `2 chi2(2c) sqrt(q) Re J^2` | 80 / 80 | holds in both classes |
| untwisted: `sum_A |K|^2 = q^2 - 2q` | 80 / 80 | holds everywhere |

Two conclusions.

1. **The stated hypothesis was too weak.** The identity does not hold for all `q ≡ 1 (mod 4)`; the measured
   boundary is exactly `q ≡ 1 (mod 8)`, i.e. `chi2(2) = 1`. The programme's "in practice `q ≡ 1 (mod 8)`" is
   therefore not an artefact of the data — it is the hypothesis.
2. **The failure has a one-character fix.** The uniform form

   ```
   sum_A chi2(A) |K(A,c)|^2  =  2 chi2(2c) sqrt(q) Re J(chi4, chi4)^2
   ```

   holds at all 80 primes and reduces to the stated form exactly when `chi2(2) = 1`. This is the statement a
   proof should now aim at.

No counterexample to the corrected form was found in 80 primes. That is evidence, not proof: the identity is
still open.

## 4. What is certified

`lean/Twist.lean` proves the one purely combinatorial step of the derivation — that summing over the squares is
summing over everything plus the `chi2`-weighted sum:

```lean
theorem Twist.twisted_parseval_step (f : ZMod p → ℂ) (h0 : f 0 = 0) :
    2 * ∑ a, (if IsSquare a then f a else 0)
      = ∑ a, f a + ∑ a, (quadraticChar (ZMod p) a : ℂ) * f a
```

plus the pointwise form `2 * 1_square = 1 + chi2`, a version over all of `ZMod p` (with the `f 0` correction),
and the corollary that `ZMod p` has `(p+1)/2` squares. All five declarations depend only on
`propext`, `Classical.choice`, `Quot.sound` (checked by `lean/Verify.lean`).

**What this does not do:** it does not prove the character sum. The green Lean file certifies the reduction, not
the identity. The distinction is the point of the harvest, and it is preserved here.

## 5. Files

```
019/
├── harvest.html                      the harvest (moved from 018, F4 extended)
├── lib/twisted_parseval.py           exact arithmetic in Z[zeta_q]
├── checks/falsification_test.py      the runner (writes results.json)
├── checks/sympy_crosscheck.py        independent path: sympy Legendre, sympy rem, mpmath 50 dps
├── tests/test_twisted_parseval.py    14 unit tests
├── lean/Twist.lean                   the certified splitting lemma
├── lean/Verify.lean                  axiom footprint
└── results.json                      all 80 rows
```

## 6. Reproduction

```
python3 checks/falsification_test.py          # exit 0; 80 primes; ~3.4 s
python3 checks/sympy_crosscheck.py            # exit 0
python3 -m unittest discover -s tests -v      # 14 tests, OK
./check.sh 019                               # from the package root; [check] OK
```

Requires `numpy`, `sympy`, `mpmath`, and a local `$HOME/lean` with Mathlib4 for the Lean layer.

## 7. Caveats

* The exact test decides the identity *for each prime tested*; it is not a proof for all `q`. The uniform
  statement remains open.
* The `chi2(2c)` correction was found empirically (all 43 primes `≡ 5 (mod 8)` fail the strict form by exactly
  the sign of `chi2(2)`) and is exactly verified; it is not derived from the twisted-Parseval mechanism, which
  remains Probe 47 in the harvest.
* The Lean layer is about `ZMod p` for `p` prime; it does not formalise `K`, `J`, or the character sum.
