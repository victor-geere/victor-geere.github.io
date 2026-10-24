# The incidence numbers are the von Mangoldt weights

**Kind:** Theorem
**Status:** VERIFIED (numerical; from Landau's theorem; evidence absent; the source is prose only, no committed evaluator)
**Area:** rh-html
**Source:** [`rh13.html`](../../html/rh13.html) — §2 "The arc-ℤ circles, and the incidence of the rulings"

## Statement

> The zero-ruling meets the scale circle of n = p<sup>k</sup> with intersection number −(ΔT/2π)Λ(n)/√n — verified at seven gears at T = 2000 (to 8%) and again across the 10⁶ band (to 4%), with non-gears meeting it at under 12% of the weakest gear: the weave is supported on the gears, at every altitude.

The source's abstract states the same reading: "the two rulings' incidence numbers are computed at two altitudes".

## Hypotheses and notation

- First ruling: at every altitude, the phase circle of arc 2π; a zero γ is a closed winding of the whole train (the zero-ruling). Second ruling: for each prime p, the scale circle ℝ₊/p<sup>ℤ</sup> of arc log p, whose k-th winding visits the gears p, p², p³, … (the arc-ℤ register).
- The pairing of a zero-winding γ against the k-th winding of the p-circle is cos(γ·k log p).
- Λ is the von Mangoldt function; ΔT is the altitude band; the reference is Landau's theorem in the form Σ<sub>γ≤T</sub> cos(γ log n) ≈ −(T/2π)Λ(n)/√n (rh8 §5).

## Proof / evidence

The source computes the incidence sums at two altitudes and compares them with −(ΔT/2π)Λ(n)/√n: seven gears at T = 2000 to 8%, again across the 10⁶ band to 4%, with the three non-gears (6, 10, 12) bounded under 12% of the weakest gear. It records the dependency honestly: "The incidence computation is Landau's theorem (rh8 §5) wearing intersection theory." Its reading: "measured at 2000 and at 10⁶, the same Λ-weights to within the stated tolerances. This is the property a ruled surface must have and a coincidence would not: the fabric does not change with height."

## Dependencies and related results

- [The crossing form: signature (25, 0, 0)](rh13-crossing-form-signature.md) — the matrix the same scale circles pair into.
- [The ℤ-radix audit](rh13-radix-audit-one-tick-per-zero.md) — the audit of the phase register.
- [The counting function of the missing curve](../rh12/rh12-counting-function-of-missing-curve.md) — the same atoms read transversally (rh12 §6).

## Notes


- The underlying incidence result is Landau's theorem, cited from rh8 §5; the source's contribution is the two-altitude verification of the surface reading.
- The source flags Figure 1's left panel as a labelled schematic; every number beside it is computed.

- **Evidence absent (session-003 audit repair 3, 2025-10-06).** No script, log or other evaluator is named in the document or in the source it was harvested from. The number(s) above therefore rest on the source's prose alone: nothing committed in this repository computes them. The label carries `evidence absent` for that reason and for no other — it is **not** a claim that the result is wrong, and it is **not** a demotion of the mathematics. It is the qualifier the archive already uses well elsewhere: `research/twin-prime-parity/checks/06-numerical-checks.md:378` discloses in the same spirit that `explicit_formula.log` "DOES NOT EXIST".
