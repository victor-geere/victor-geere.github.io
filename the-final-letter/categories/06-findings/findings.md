# Findings

## F1 — The Riemann conversion is complete

The geometric programme proves the equivalence between RH and the equality of the balanced and unrestricted supports. The conversion is not a proof of RH, but it is a complete translation: no part of the implication is missing. The remaining gap is the equality itself.

## F2 — The additive toolbox self-limits

The Davenport–Heilbronn twist has every feature the construction consumes — functional equation, mean-zero periodic coefficients, Euler–Maclaurin comparison, classical floor — and no Euler product. The framework transfers verbatim and reports a false RH at Spira’s zero. Therefore no theorem from the additive toolbox can prove RH. This is a proved limitative result, not a heuristic.

## F3 — The parity programme self-limits

The greedy harmonic sine is a rich object: a proved complexity law, exact budgets, Brown reachability, a parity lock, a balance identity, and the sharp partial-sum error. But all five bridges to the parity problem fail: the support carries no λ-parity signal, the budgets carry only index parity, the correlation has no Euler product, the support is Sylvester-sparse, and an arithmetic alphabet is circular. The programme’s own verdict is that the goal is unreachable as it stands.

## F4 — Finite prefixes cannot decide the Chowla wall

The finite-prefix indeterminacy theorem is the one clean new theorem. Two functions can agree on an arbitrarily long prefix and have different correlation sums; the perturbation has ℓ²-mass exactly `4`. Therefore no finite computation can establish two-point Chowla. The theorem is Lean-certified. It is the formal statement of the futility of finite verification.

## F5 — Density statements are blind

Bombieri–Hejhal show that “almost all” statements about zeros of a linear combination of `L`-functions are blind to a density-zero set of off-line zeros. The RH measures escape this only because the tempering weight charges individual atoms. Any bridge that is only density-level cannot close either wall.

## F6 — The missing inputs are the same kind of object

The RH wall needs an arithmetic positivity/multiplicativity input: `(M)`, Weil positivity, the absence of a right-half atom, or the joint non-vanishing of `K` and `S`. The parity wall needs a sign-blind rule with positive-density multiplicative coupling to `Ω`. They are not the same statement, but they are the same kind of object: a global arithmetic positivity that the local machinery cannot manufacture.

## F7 — Computation is not the bottleneck

The programme has extensive numerics: certified zeros at `T=15` and `T=33`, Fisher zeros, parity probes, Chowla correlations to `10⁹`, and a Lean corpus. None of it decides the asymptotic statements. The finite-prefix theorem explains why: a finite computation can refute, but cannot establish, the limit. The bottleneck is the missing global input, not compute.

## F8 — Lean confirms the core, not the walls

The Lean development is `sorry`-free and `axiom`-free. It formalises the finite-prefix core and the well-posedness of the two walls. It does not formalise the conversion theorem or the sharpness theorem, and it does not prove either wall. Formalisation is a microscope, not a key.

## F9 — The two walls are independent but structurally analogous

The programme does not prove `RH ↔ twin primes`, or `RH ↔ Chowla`. The two walls are logically independent. But they share a shape: a local/additive/finite-prefix method reaches a sharp limit, and the missing ingredient is a global arithmetic positivity. The analogy is structural, not a theorem of equivalence.

## F10 — The map is the achievement

The programme’s achievement is not a proof of either wall. It is the map: the conversion theorem, the sharpness theorem, the finite-prefix theorem, the five-bridge refutation, the two-wall diagnosis, and the Lean core. The map is complete enough to tell a future researcher where not to dig.

[Back to README](README.md) · [Back to index](../../index.html)
