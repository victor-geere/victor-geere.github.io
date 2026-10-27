# Round 124 — the capstone begins

*Plan fixed at the start of the round (`rounds.log`, BEFORE line).*

---

## 1. The envisioned path

Three rounds remain in the goal's budget. The phase is complete; what is missing is the write-up: a cross-phase
statement (018 + 019 + 020) that a reader can use without the eighteen round notes, an audit that covers the
newest constants, and one Lean capstone that states the local-factor dichotomy in a single theorem.

## 2. Wild guess 65

> **Wild guess 65.** The audit extends to the polynomial-shift constants with no failures, and the phase's
> central constant (`4`) plus its setting (`2^dim`, `(Q−1)/(Q−2)` correction) can be stated in one page without
> losing precision.

**Why guess it.** Every constant was produced by checked-in code; the synthesis already exists in phase form.

**Falsification test.** Extend `audit.py` with the round-121/123 constants and write the cross-phase synthesis.

## 3. Results

* Audit extended to **35 claims** (adding `T(3,6;x) = 16`, `T(3,9;x) = 190`, `S_h(x) = 0.792208`,
  `T(3,13; x(x+1)(x+2)) = 29670`): **35/35 pass**.
* Cross-phase synthesis written: [`../../PROGRAMME-SYNTHESIS.md`](../../provenance/PROGRAMME-SYNTHESIS.md) — three phases, the
  single conclusion (the barrier is dimensional), the transfer demand, the proved-versus-measured ledger, and
  four directions for a successor.

**Wild guess 65 is confirmed.**

## 4. Lean

`Capstone.local_factor_dichotomy`: one theorem covering both local factors,

```
# {a : a ≠ 0 ∧ a + h ≠ 0} = |F| − 1 − (if h = 0 then 0 else 1),
```

i.e. `|F| − 1` when the prime divides `h` and `|F| − 2` otherwise. This is the local fact behind the whole
phase: the singular series, the `(Q−1)/(Q−2)` correction, and the dimension count. Standard axioms; thirteen
modules green.

## 5. State

* Audit 35/35; cross-phase synthesis written; Lean capstone proved.
* Thirteen Lean modules, 20 unit tests, all green.

## 6. Next round (125)

Finish the write-up: a one-page executive summary at the programme root, a check that every cross-reference in
the synthesis resolves, and a final read of `objectives.json` against the record.
