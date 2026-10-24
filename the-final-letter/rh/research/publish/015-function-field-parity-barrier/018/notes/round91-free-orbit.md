# Round 91 — Target B: the free-orbit theorem, formalized

Round 36 of the aggressive goal.  The abstract content of the translation-orbit
divisibility `q ∣ T(d;q,h)` is now **formalized in Lean**.

---

## 1. The theorem

```
FreeOrbit.card_dvd_card_of_free_action :
  (∀ g : G, ∀ x : X, g • x = x → g = 1) →  |G| ∣ |X| .
```

**Proof.**  The orbit–stabilizer theorem
(`MulAction.card_orbit_mul_card_stabilizer_eq_card_group`) with a trivial
stabilizer gives `|orbit x| = |G|`.  The class formula
(`MulAction.selfEquivSigmaOrbitsQuotientStabilizer`) writes `X` as the disjoint
union of its orbits, so `|X| = Σ_ω |orbit ω| = Σ_ω |G|`, which is divisible by
`|G|`.  ∎

Compiles clean (`lean/FreeOrbit.lean`).

## 2. The application

For the diagonal translation action on pairs of monic quartic polynomials,

```
t · (f, g) = (f + t, g + t) ,      t ∈ 𝔽_q ,
```

the action is free (`f + t = f ⇒ t = 0`), so by the theorem

```
q ∣ #{(f,g) : f, g irr, g − f = h}  =  T(4;q,h) .
```

The orbit argument of round 23 thus has a Lean-checked abstract core.

---

## 3. Wild guess 33 — the remaining gaps are formalization + one integer

> **Wild guess 33.** After this round, the `d=4` cap and the `d=5` congruence
> depend only on **formalization** (Ritt, Poincaré, the `S₄` decomposition) and,
> for `d=4`, on the single integer `m`.  No new mathematical idea is needed for
> the `d=5` case, and the `d=4` case is one arithmetic identification away.

**Evidence.** 43 → 44 Lean files, 0 errors; the `c₄` chain is proved modulo `m`;
the `d=5` congruence is a corollary of the orbit theorem.

## 4. Honest verdict

* **Target B — the free-orbit theorem is formalized.**  `q ∣ T` now has a
  Lean-checked abstract core; the `d=5` congruence follows.
* **(A) — cap assembled**, with the orbit step formalized.
* **(C) — parity theorem complete for the divisor-sum class.**

## 5. Next round

1. **`m`** (the last arithmetic gap).
2. **A closing note.**

---

## 6. Reproduction

```
cd lean && ./check.sh FreeOrbit.lean   # OK
python3 checks/round90_m_nine.py       # exit 0
python3 -m pytest -q tests/            # 538 passed
```
