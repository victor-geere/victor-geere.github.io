# Round 15 — the value-set collapse at `d = 5`

Round 14 identified the `d = 4` cap as a union bound `|Im ∪ Q| ≥ (q+1)/2`. This
round shows **why it fails at `d = 5`**: the value set of a quintic can collapse
to size `1` or `3`, leaving almost every constant shift irreducible.

---

## 1. Established direction — the `d = 4` cap at larger `q`

The cap `I(a) ≤ (q−1)/2` was verified for `q = 5,7,11,13` in round 13. Extended:

| `q` | 5 | 7 | 11 | 13 | 17 | 19 | 23 |
|---|---|---|---|---|---|---|---|
| `max I` | 2 | 3 | 5 | 6 | 8 | 9 | 9 |
| `(q−1)/2` | 2 | 3 | 5 | 6 | 8 | 9 | 11 |
| tight? | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✗ |

So the cap holds for `q ≤ 23`, and is tight for `q ≤ 19` (not at `q = 23`).
The bound is real, not a small-`q` coincidence.

## 2. The `d = 5` collapse

The extremal `d = 5` families are not generic — they are **power maps**:

| `q` | extremal `g` | `|Im(g)|` | `|Im ∪ Q| = q − I` | `max I` | `(q−1)/2` |
|---|---|---|---|---|---|
| 5 | `x⁵ − x` | **1** | 1 | 4 | 2 |
| 11 | `x⁵` | **3** | 3 | 8 | 5 |

At `q = 5`, `x⁵ − x = 0` for every `x` (Fermat), so the family `x⁵ − x + b`
evaluates to `b` at every point: for `b ≠ 0` there is no root, and in fact
`x⁵ − x + b` is irreducible for all four nonzero `b`. The value set has size
`1`, the union has size `1`, and the cap fails.

At `q = 11`, `x⁵` has image size `3` (since `gcd(5,10)=5`), and `x⁵ + b` is
irreducible for the other `8` values of `b`.

**Mechanism.** The quartic's value set cannot collapse this far (a degree-4 map
has image `≳ q/4`, and the quadratic factors fill the gap); the quintic's can
(`x^p − x` collapses to a single point in characteristic `p`).

---

## 3. Wild guess 15 — generic versus specific

> **Wild guess 15.** The union bound is a **value-set** statement, and it holds
> exactly while the value set cannot collapse. At `d = 5` the power/Artin-Schreier
> families collapse it, making the count "almost all `b` irreducible" — a
> **generic** phenomenon, the function-field analogue of **Hilbert's
> irreducibility theorem**. The twin problem, however, asks about a **specific**
> shift (`h = 2`). The barrier is the gap between the generic statement (almost
> every `b`) and the specific one (`b = 2`).

**Evidence.**

* The `d=4` cap is tight for `q ≤ 19` and the value set is large.
* The `d=5` extremal families are exactly the collapsing power maps (`§2`).
* The collapse is a "generic" family (`x⁵ − x + b` irreducible for all `b≠0`),
  which is the same shape as Hilbert irreducibility over `ℚ`.

**Why it is a guess.** Hilbert irreducibility is a statement about *almost all*
specialisations; it says nothing about a fixed one. The identification of the
function-field `b`-average with Hilbert irreducibility is heuristic. There is no
proof that the value-set collapse is the *only* mechanism at `d ≥ 5`.

**What would falsify it.** A `d=5` extremal family with a large value set would
show the collapse is not the mechanism; a proof that the cap holds at `d=5` for
all `q` would contradict §2.

---

## 4. Lean — the Artin-Schreier collapse over `𝔽₅`

`lean/ArtinSchreier.lean`:

```
pow_five_eq_self      : ∀ x : ZMod 5, x^5 = x
eval_artin_schreier   : x^5 - x + b = b
artin_schreier_no_root: b ≠ 0 → x^5 - x + b ≠ 0
```

The first is Fermat (a finite check); the other two follow by rewriting and
`ring`. This is the Lean form of the value-set collapse: the family is constant
in `x` and equal to `b`. Footprints `[propext, Classical.choice, Quot.sound]`.

(Irreducibility of the four nonzero members is verified computationally, not in
Lean; it would need a degree-5 irreducibility criterion.)

---

## 5. Honest verdict

* **Established this round:** the `d=4` cap holds for `q ≤ 23` (tight for
  `q ≤ 19`); the `d=5` extremal families are the power/Artin-Schreier maps
  `x⁵−x` and `x⁵`, with value-set sizes `1` and `3`; the value-set-collapse
  mechanism; the Artin-Schreier collapse in Lean.
* **The wild guess:** the cap is a value-set statement, and the `d=5` failure is
  the generic (Hilbert-irreducibility) regime versus the specific twin shift.
  Coherent, supported by the extremal families, not testable over `ℚ`.
* **Not claimed:** a proof of the `d=4` cap; that value-set collapse is the only
  `d≥5` mechanism; any Hilbert-irreducibility theorem for `ℚ`.

## 6. Next round

1. **Prove the `d=4` cap** using the value-set lower bound for quartics
   (`|Im(g)| ≳ q/4`) plus a lower bound on `|Q(g) \ Im(g)|`.
2. **`d = 6, 7` extremal families**: are they all power/Artin-Schreier-type?
3. **Wild guess 16 (preview).** *The value-set collapse is a **characteristic-p**
   phenomenon: `x^p − x` collapses because the derivative vanishes. Over `ℚ`
   there is no such collapse (the derivative of `x^p − x` is `p x^{p−1} − 1`,
   which is `−1`), so the `ℚ` analogue of the extremal family is "generic" in a
   different sense. The barrier is the failure of the characteristic-p collapse
   over `ℚ`.* Investigate: compare `x^p − x + b` over `𝔽_p` with `x^p − x + n`
   over `ℚ`.

---

## 7. Reproduction

```
python3 checks/round15_value_set.py   # exit 0
python3 -m pytest -q tests/           # 269 passed
cd lean && ./check.sh ArtinSchreier.lean Axioms.lean   # OK
```

New files this round: `checks/round15_value_set.py`, `tests/test_round15.py`,
`lean/ArtinSchreier.lean`.
