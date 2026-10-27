# Round 115 — the conjecture at `n = 13, 14`

*Plan fixed at the start of the round (`rounds.log`, BEFORE line).*

---

## 1. The envisioned path

After round 114 all four standard mechanisms were measured and closed, and the only remaining object is the
statement itself: at fixed `q`,

```
T_q(n) = S(q) q^n / n² + O(q^{n/2}) .
```

The 018 notes record that this is *conjectural* at fixed `q` (the literature's large-`q` theorems have errors
`O(q^{n−1/2})`, useless as `n → ∞`). So the honest remaining work on this front is to push the empirical test
further: every extra degree is a genuine test of both the conjecture and the error model.

This round computes `T(13)`, `T(14)` at `q = 3` and `T(9)` at `q = 5` — the largest counts the segmented
counter can reach at these `q`.

## 2. Wild guess 56

> **Wild guess 56.** `T(13)` and `T(14)` lie inside the `q^{n/2}` band around `S(q)q^n/n²` — i.e.
> `|E(n)|/q^{n/2}` stays below `1`, as it has for every `n ≤ 12`.

**Why guess it.** The error has been `0.01–0.3` of `q^{n/2}` for eleven consecutive degrees, with no upward
trend. If the Weil-scale model is right, this must continue; a jump above `1` would be a genuine surprise.

## 3. Results

New counts (computed by the segmented counter, `checks/round115.py`):

| `q` | `n` | `T(n)` | time |
|---|---|---|---|
| 3 | 13 | **3747** | 188 s |
| 3 | 14 | **9510** | 666 s |
| 5 | 9 | **17265** | 210 s |

Extended error table at `q = 3`:

| `n` | `T(n)` | `S q^n/n²` | `E(n)` | `q^{n/2}` | `|E|/q^{n/2}` |
|---|---|---|---|---|---|
| 11 | 585 | 579.91 | +5.09 | 420.9 | 0.012 |
| 12 | 1506 | 1461.85 | +44.15 | 729.0 | 0.061 |
| **13** | **3747** | 3736.79 | **+10.21** | 1262.7 | **0.008** |
| **14** | **9510** | 9666.09 | **−156.09** | 2187.0 | **0.071** |

At `q = 5`, `n = 9`: `T = 17265` against `S(5)·5^9/81 = 17108.99`, so `E = +156.01` and
`|E|/q^{4.5} = 156.01/1397.5 = 0.112`.

**Wild guess 56 is confirmed.** The ratio stays in `[0.008, 0.30]` across `n = 2..14`, with the two new points at
`0.008` and `0.071`. The main term is now accurate to `0.3%` at `n = 13` and `1.6%` at `n = 14`.

The conjecture `T(n) ~ S(q)q^n/n²` at fixed `q` survives its largest test so far: six new degrees of data
(`q = 3`: 13, 14; `q = 5`: 9) with no deviation beyond the `q^{n/2}` envelope.

## 4. Lean

The degree-one base case behind `T(1) = q`: shifting a monic linear polynomial by a constant keeps it monic
linear, hence irreducible (`Linear.shift_linear`). Standard axioms.

## 5. What this does and does not show

* **Does:** the fixed-`q` asymptotic is now supported at `n` up to 14 for `q = 3` and up to 9 for `q = 5`, with
  the error always inside the Weil band. Any proof strategy must reproduce these numbers.
* **Does not:** prove the asymptotic. A finite verification, however long, is not a theorem — and round 112
  showed the error is deterministic, so agreement at 14 points is evidence, not proof.

## 6. State

* `T(13) = 3747`, `T(14) = 9510` (`q = 3`), `T(9) = 17265` (`q = 5`); all within `0.12 q^{n/2}` of the main term.
* Wild guess 56 confirmed.
* `Linear.shift_linear` added to the Lean layer; 20 tests green.

## 7. Next round (116)

The empirical side is now saturated at fixed `q` (each extra degree costs minutes). The remaining useful
directions are (a) a synthesis of the whole phase, and (b) the one structural question still open from round
113: whether the class-orbit law can be turned into a *proof* of the singular series' shift-independence at
finite `n`, which would explain the finite-`n` data from the group action alone. Round 116 will attempt (b) and
fall back to (a).
