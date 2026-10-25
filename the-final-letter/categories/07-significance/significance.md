# Significance

## 1. Negative results with positive content

The programme’s central results are negative: the additive toolbox cannot prove RH; the greedy sine cannot solve parity; finite prefixes cannot decide Chowla. But each negative result has positive content:

- the Davenport–Heilbronn litmus tells you which future inputs could work;
- the five-bridge refutation tells you which parity strategies are dead;
- the finite-prefix theorem tells you why computation cannot settle the limit.

A negative result that closes a door is more useful than a positive result that opens a wrong one.

## 2. A reusable litmus test

The Davenport–Heilbronn test is a general method: run your construction on a function that has every feature you use except the one you need. If it reports the wrong answer, your method cannot be the proof. This is a transferable methodological contribution, not just a fact about ζ.

## 3. A formalised no-go core

The finite-prefix theorem is formalised in Lean, with no `sorry` and no `axiom`. It is a small, reusable no-go result: finite data cannot determine a correlation limit. The formalisation makes the no-go precise and machine-checkable.

## 4. A unified vocabulary

The programme gives a shared vocabulary for two fields that usually do not talk to each other: the measure-theoretic conversion of RH and the parity/Chowla barrier. “Right-half atom”, “sign-blind rule”, “positive-density coupling”, “finite-prefix indeterminacy”, and “global arithmetic positivity” can be used in the same sentence without equivocation.

## 5. A correction to the rhetoric of progress

The programme is a corrective to the rhetoric that more numerical probing, more data, or more numerical zeros will close these problems. The finite-prefix theorem is a precise statement that they will not. This matters for how the subject is presented to students, funders, and the public.

## 6. A pedagogical map

The two-wall map is a teaching device. It shows what a proof of RH would have to consume, what a proof of twin primes would have to consume, and why the standard toolkits stop where they do. It is a map of the edge of the known, not a claim to have crossed it.

## 7. A record of failure, kept honestly

The programme keeps its errors: X1–X6, the `O(1/p)` correction, the false ceiling law, the withdrawn barrier sentence, the 015 dimension-law retraction. The errata are part of the significance. A research programme that hides its failures is less useful than one that maps them.

## 8. A reusable certified computation layer

Objective III is a positive residue of the programme even though it does not move either wall. It gives an exact-rational interval engine, a straight-line certificate format, an independent replay checker, and a Lean soundness theorem, together with kernel-checked enclosures for `π`, `exp`, `log`, `sin` and `cos` and a closed ζ(2) replay. Any future finite-scale claim about `ζ`, `ζ(s,a)` or `L(s,χ)` can use this layer instead of floating point. The layer is honest about its boundary: the Euler–Maclaurin identity and the explicit tail bound have a written proof but are not Lean-formalised, and the evaluator is not yet a hypothesis in a theorem about a wall. That boundary is part of the significance, not a defect to hide.

[Back to README](README.md) · [Back to index](../../index.html)
