# Final note

## What has been achieved

This programme has achieved six things.

**1. A conversion.** The Riemann hypothesis has been translated into an equality of supports of two measure families. The translation is complete. It does not prove the hypothesis, but it removes the ambiguity about what a proof would have to show: the absence of a right-half atom, the joint non-vanishing of `K` and `S`, Weil positivity for the repaired current.

**2. A sharpness theorem.** The Davenport–Heilbronn twist has every feature the additive construction uses and no Euler product. The construction transfers verbatim and reports a false Riemann hypothesis at Spira’s zero. Therefore no theorem using only the ingredients in that additive construction can prove RH. This is not a failure of effort; it is a limit of that construction.

**3. A finite-prefix indeterminacy.** Two functions can agree on an arbitrarily long prefix yet produce different correlation sums at finite scales. The perturbation has ℓ²-mass exactly `4`, so the two functions differ in only finitely many terms and have the same asymptotic correlation behaviour. The theorem is Lean-certified, `sorry`-free, and `axiom`-free. It shows that a finite prefix does not determine a finite correlation; it is not by itself a no-go for asymptotic reasoning.

**4. A barrier map.** The parity programme proves the factor-complexity law, the budgets, Brown reachability, the parity lock, the balance identity, the sharp error at a zero, the failure of smoothing to remove `√N`, the corrected explicit formula, the Sylvester-sparsity theorem, and the non-multiplicativity of the shifted product. It disposes of all five bridges from the greedy sine to parity.

**5. A Lean spine.** The `FinalLetter` development defines the two walls in Mathlib’s vocabulary, defines two-point Chowla, and proves the finite-prefix theorem in a form that connects the two programmes. The build is `[check] OK`, with no `sorry` and no `axiom`.

**6. A certified computation layer.** Objective III reconstructs the partial-sum-plus-tail evaluator as a programme: exact rational interval arithmetic, a straight-line certificate replayed by an independent checker, a Lean soundness theorem, the eta cos/sin split, kernel-checked transcendental enclosures, a closed ζ(2) replay, and a Lean-proved Euler–Maclaurin identity and tail bound for `K ≥ 1`. It is the instrument the walls need, not a bridge across either. No theorem about a wall yet uses a certified enclosure as a hypothesis; a target-width certificate format is proved, but a symbolic width bound is not.

## What has not been achieved

The Riemann hypothesis is not proved. The twin-prime conjecture is not proved. Chowla for `k ≥ 2` is not proved. Sarnak’s conjecture is not proved. Elliott’s conjecture is not proved.

The programme does not prove that these walls are unclimbable. It proves that the methods surveyed here cannot climb them. That is a different and more honest claim.

## The futility

The futility is not the futility of mathematics. It is the futility of a certain kind of attack: more zeros, more digits, more finite prefixes, more local estimates, more sign-blind rules, more density statements. Each of these can refute. None of them can establish the limit. The finite-prefix theorem is the precise form of that sentence for Chowla; the Davenport–Heilbronn theorem is the precise form of it for the additive RH toolbox. The certified evaluator is not a counterexample to that sentence: it makes finite claims exact, but it does not make a finite claim asymptotic.

The wall is not a mistake in the proof. The wall is the proof that the method has reached its edge.

This is why the final letter is a letter of resignation — not from mathematics, but from the illusion that the wall is a calculation. The calculation is done. The map is drawn. The door is not in this house.

## What remains

The two walls remain. OP-19 remains. Weil positivity remains. F.4 remains. `Λ=0` remains. The Jensen/Li tower remains. The conversion remains an equivalence, not a proof. The finite-prefix theorem remains a no-go, not a victory. The evaluator's Euler–Maclaurin identity and tail bound are Lean theorems for `K ≥ 1`, but no wall theorem consumes a certified enclosure yet, and only a concrete certificate width, not a symbolic width bound, is checked.

But something remains that was not there before: a precise map of where the walls are, what they are made of, which bridges fail and why, and what a future bridge would have to consume. A map is not a key, but it is not nothing. It is the difference between being lost and knowing that you are at the wall.

## The last sentence

The final letter does not end with a theorem. It ends with a location.

> The Riemann hypothesis and the twin-prime conjecture are not behind a computation. They are behind an arithmetic positivity that the local methods cannot manufacture. We have proved the absence of the local key for the methods surveyed here, and drawn the shape of the lock.

That is what has been achieved. The futility is that the lock is still locked.

[Back to README](README.md) · [Back to index](../../index.html)
