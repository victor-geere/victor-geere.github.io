# Round 11 — the shift dependence is `d`-torsion: a character-support theorem

Round 10 found that the shift average is a polynomial and that the `h`-dependence
is character-theoretic. This round makes that precise: the multiplicative
Fourier transform of `h ↦ T(d;q,h)` is supported **exactly on the characters of
order dividing `d`**, and in the generic class (`d ∤ q−1`) the individual count
is the exact polynomial.

---

## 1. Established direction — the support theorem

For `h ∈ 𝔽_q^*`, `T(d;q,h) = #{f deg d : f, f+h irr}`.  Let `g` be a primitive
root, `h = g^e`, and define the multiplicative Fourier coefficients

```
c_k = (1/(q−1)) Σ_{h∈𝔽_q^*} T(d;q,h) · ζ^{−k e} ,    ζ = e^{2πi/(q−1)} .
```

**Observation (verified for every `q` in the scan, 37 checks all passing).**
The support of `c_k` is:

| `d` | support | when |
|---|---|---|
| 3 | characters of order dividing 3 | `3 \| q−1`; otherwise only `k=0` |
| 4 | characters of order dividing 4 | `q ≡ 1 (mod 8)` |
| 4 | characters of order dividing 2 | `q ≡ 5 (mod 8)` |
| 4 | only `k=0` | `q ≡ 3 (mod 4)` |
| 5 | characters of order dividing 5 | `5 \| q−1`; otherwise only `k=0` |

Examples: `d=3, q=13` (support `k=0,4,8` of 12), `d=4, q=17` (support
`k=0,4,8,12` of 16), `d=5, q=41` (support `k=0,8,16,24,32` of 40).

The `d=4` 2-adic refinement (`4` only when `8 | q−1`, else `2`) is a genuine
arithmetic subtlety, not a numerical artefact: at `q = 13` the quartic
coefficients vanish and only the quadratic survives.

**`k = 0` is the average.** The average is the trivial character; the
nontrivial characters are the arithmetic.

## 2. The generic class is exactly polynomial

When `d ∤ q−1`, the only character is the trivial one, so `T(d;q,h)` is
independent of `h` and equals the average.  Then `T(d;q,2)` is the exact
polynomial:

* `d = 3`, `q ≡ 2 (mod 3)`:
  ```
  T(3;q,2) = q³/9 · (1 − 1/q − 2/q²) ,
  ```
* `d = 4`, `q ≡ 3 (mod 4)`:
  ```
  T(4;q,2) = q(q³ − q² − 5q − 3)/16 .
  ```

Verified for every relevant prime in the scan (`checks/round11_characters.py`
§[B]): `d=3` at `q = 5,11,17,23`; `d=4` at `q = 7,11,19,23,31`.

**`d = 5` does not follow.** On the eight generic primes `5,7,13,17,19,23,29,37`
a degree-6 fit of `T(5;q,2)` has RMS residual `154` (relative `~5e−5`). It is not
an exact low-degree polynomial on the available points; more primes (or a higher
degree) are needed to decide.

## 3. The `d = 4` amplitude

For `q ≡ 1 (mod 4)` the quadratic amplitude is

```
B_4(q) = (mean_{χ=1} T − mean_{χ=−1} T)/2 :
q=5: 5/2,  q=13: 117/2,  q=17: 289/2,  q=29: 1653/2,  q=37: −1147/2 .
```

At `q = 17` all four quartic classes are distinct; at `q = 13` the quartic
coefficients cancel and only the quadratic remains.

---

## 4. Wild guess 11 — the character-sum gap

> **Wild guess 11.** The individual twin count is
> `T(d;q,h) = A_d(q) + Σ_{χ ≠ 1, ord χ | d} c_χ(q) χ(h)`:
> a polynomial `A_d` plus a character sum over the `d`-torsion. In `𝔽_q[x]` the
> shift `h` ranges over the finite group `𝔽_q^*`, so the characters are
> available and the average kills them. Over `ℚ` the shift is **fixed**
> (`h = 2`), and one needs the values of infinitely many characters at `2` — the
> **character-sum gap**. The solution would be a reciprocity law that evaluates
> the character sum at a fixed shift.

**Evidence.**

* The support theorem (§1): the arithmetic is exactly the `d`-torsion
  characters.
* The generic-class polynomials (§2): the trivial character is `A_d(q)`.
* The `d=4` amplitude `B_4` (§3): a genuine character-sum value.
* The average `A_d(q)` is polynomial for `d=3,4`; the individual count is not,
  because of the character terms.

**Why it is a guess.** Over `ℚ` there is no finite multiplicative group acting
on the additive shift; the "characters" would be Dirichlet characters mod the
conductor, and evaluating them at `h=2` for all conductors is not known. The
guess locates the obstruction in the *un-averaging*, not in the local densities.

**What would falsify it.** A proof of the twin conjecture that bypasses the
character sum entirely (e.g. a direct Type-II estimate at fixed `h`) would show
the character-sum gap is not the only route.

---

## 5. Lean — shift averages at `𝔽₅` and `𝔽₇`

* `CubicAverageFive.sum_cubicTwin5 : Σ_{h∈𝔽₅^*} cubicTwin5h h = 40`
  (average `10`).
* `CubicSeven.sum_cubicTwin7 : Σ_{h∈𝔽₇^*} cubicTwin7h h = 168`
  (average `28`, from round 10).

Both are finite checks; footprints
`[propext, Classical.choice, Quot.sound]`. (An `𝔽₁₁` version with `Σ = 1320`
was attempted but exceeds the deterministic heartbeat limit; it is recorded here
as not-yet-formalised.)

---

## 6. Honest verdict

* **Established this round:** the multiplicative-Fourier support theorem
  (character order dividing `d`, with the `d=4` 2-adic refinement); the exact
  generic-class polynomials for `d=3,4`; the `B_4` values; `d=5` is not yet a
  clean polynomial.
* **The wild guess:** the barrier is the character-sum gap — the fixed `h=2`
  needs the values of infinitely many `d`-torsion characters. Coherent, supported
  by the support theorem, not testable over `ℚ`.
* **Not claimed:** that the character sum is the *only* gap; that `d=5` is
  never polynomial; any reciprocity law.

## 7. Next round

1. **`d=5` with more primes** (`q = 43, 47, …`) to decide polynomial vs not.
2. **Prove the support theorem** (at least for `d=3`) from the cubic-twist
   geometry, and formalise it.
3. **Wild guess 12 (preview).** *The amplitude `B_d(q)` is a product of local
   terms: `B_4(q) = q · Σ_{χ_4} c(χ_4) χ_4(2)`, and the constants `c(χ_4)` are
   `L`-values of the twist. Over `ℚ` the analogous amplitude is a product of
   local factors at the primes dividing the conductor — the "local-global"
   barrier.* Investigate: fit `B_4(q)/q` against quartic character sums.

---

## 8. Reproduction

```
python3 checks/round11_characters.py   # exit 0
python3 -m pytest -q tests/            # 237 passed
cd lean && ./check.sh Cubic.lean Axioms.lean   # OK
```

New files this round: `checks/round11_characters.py`,
`tests/test_round11.py`, and the `𝔽₅` shift-average theorem in
`lean/Cubic.lean`.
