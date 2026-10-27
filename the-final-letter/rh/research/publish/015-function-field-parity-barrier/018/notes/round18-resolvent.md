# Round 18 — the resolvent cannot compensate: cyclic Galois groups

Round 17's preview proposed that the `d=4` compensation is a **resolvent-cubic**
phenomenon. This round tests it and finds the opposite: over `𝔽_q` the resolvent
root is **automatic** for every irreducible quartic, so it carries no
information about the quadratic-factor set. The reason is that Galois groups
over finite fields are cyclic.

---

## 1. Established direction — the resolvent always has a root

For `f = x^4 + a_3x^3 + a_2x^2 + a_1x + a_0` the pairing resolvent is

```
R(z) = z³ − a_2 z² + (a_3 a_1 − 4 a_0) z − (a_3² a_0 − 4 a_2 a_0 + a_1²) .
```

Its roots are `z_ij = α_iα_j + α_kα_l` over the three pairings of the roots.

**Computed fact** (`checks/round18_resolvent.py` §[A]).  For every irreducible
quartic over `𝔽_q`, `q = 5,7,11,13`:

| `q` | irreducible quartics | resolvent roots |
|---|---|---|
| 5 | 150 | **exactly 1** |
| 7 | 588 | **exactly 1** |
| 11 | 3630 | **exactly 1** |
| 13 | 7098 | **exactly 1** |

**Why.** The Frobenius on the four roots of an irreducible quartic is a
**4-cycle**, which is **odd**. An odd `4-cycle` fixes exactly one of the three
pairings (`§[B]`): for `σ = (0 1 2 3)`, the "cross" pairing `{0,2}{1,3}` is
fixed and the other two are swapped. Hence the resolvent factors as

```
R(z) = (z − z_0) · (irreducible quadratic) ,
```

with exactly one root in `𝔽_q`.

## 2. Why this kills the resolvent explanation

A resolvent root `z` gives a **pairing** defined over `𝔽_q`, but the
corresponding quadratic factors are over `𝔽_q` only when their discriminant is
a square. For an irreducible quartic the discriminant is a non-square, so there
is **no** quadratic factor. The resolvent root is automatic and says nothing
about `Q(g)` (`§[C]`: zero reducible quartics have a resolvent root but no
quadratic factor — the root is either present-and-irrelevant or absent).

So the `Q`-compensation cannot be read off from the resolvent.

## 3. Over `ℚ` this is different

Over `ℚ` the Galois group of a quartic can be `S_4`. An element of `S_4` of
cycle type `4` is odd and fixes one pairing, but a `3-cycle` or `2+2` element
does not; for an `S_4` quartic the resolvent is **irreducible** (a classical
fact: `x^4 + x + 1` has resolvent `z³ − 4z − 1`, irreducible over `ℚ`).

So the function-field "compensation" is a **cyclic-Galois** artifact: the
Frobenius is always an odd 4-cycle, which always fixes a pairing.

---

## 4. Wild guess 18 — the cyclic-Galois compensation

> **Wild guess 18.** The `d=4` compensation is an artifact of **cyclic Galois
> groups**. Over `𝔽_q` the Frobenius 4-cycle always fixes a pairing, so the
> quartic always presents a "half-factorised" structure and the quadratic-factor
> set is large enough for the cap. Over `ℚ` the Galois group can be `S_4`; no
> element need fix a pairing, the resolvent can be irreducible, and the
> compensation disappears — this is the **parity barrier**: the non-abelian
> Galois group removes the "free" half-factorisation that the function-field
> argument uses.

**Evidence.**

* Every irreducible quartic over `𝔽_q` has exactly one resolvent root (`§1`).
* The reason is the odd Frobenius 4-cycle fixing one pairing (`§[B]`).
* Over `ℚ`, `S_4` quartics have irreducible resolvents (`§3`), so the
  compensation is not available.

**Why it is a guess.** The step from "resolvent root" to "`Q`-compensation"
is not proved; the resolvent root is necessary-looking but the quadratic-factor
condition is separate. The `ℚ` identification with the parity barrier is an
analogy.

**What would falsify it.** A proof of the `d=4` cap that does not use the
cyclic structure (e.g. a purely combinatorial value-set argument) would
undercut the "cyclic artifact" reading.

---

## 5. Lean — a concrete resolvent instance

`lean/Resolvent.lean`:

```
resolvent_roots_one : #{z ∈ 𝔽₅ : z³ − z − 1 = 0} = 1
quartic_no_root     : ∀ x : 𝔽₅, x^4 + x + 4 ≠ 0
```

The quartic `x^4 + x + 4` is irreducible over `𝔽₅` and its resolvent `z³ − z − 1`
has exactly one root — the concrete shape of `§1`. Footprints
`[propext, Classical.choice, Quot.sound]`.

---

## 6. Honest verdict

* **Established this round:** every irreducible quartic over `𝔽_q` has exactly
  one resolvent root; the odd-4-cycle explanation; the failure of the resolvent
  to characterise `Q(g)`; the `ℚ` contrast (`S_4` ⟹ irreducible resolvent).
* **The wild guess:** the `d=4` compensation is a cyclic-Galois artifact, and
  the parity barrier is the non-abelian Galois group over `ℚ`. Supported by the
  resolvent data, but the link to `Q`-compensation is unproved.
* **Not claimed:** that the cap *follows* from the cyclic structure; that
  non-abelianness is the *only* obstruction; any `ℚ` theorem.

## 7. Next round

1. **Prove `Q`-compensation without the resolvent**, using the quadratic-factor
   parametrization directly.
2. **The individual twin count `T(4;q,2)`** vs the family maximum: clarify which
   is the right object for the barrier.
3. **Wild guess 19 (preview).** *The cyclic-Galois structure makes the
   function-field twin count a **character sum over the cyclic group**; over
   `ℚ` the corresponding sum is over a non-abelian Galois group and no longer
   factors. The barrier is the failure of the abelian Fourier analysis.*
   Investigate: express `T(4;q,2)` as a sum over `Gal(𝔽_{q^4}/𝔽_q)`.

---

## 8. Reproduction

```
python3 checks/round18_resolvent.py   # exit 0
python3 -m pytest -q tests/           # 297 passed
cd lean && ./check.sh Resolvent.lean Axioms.lean   # OK
```

New files this round: `checks/round18_resolvent.py`, `tests/test_round18.py`,
`lean/Resolvent.lean`.
