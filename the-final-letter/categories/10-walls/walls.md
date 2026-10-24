# The walls

A wall is a place where a method class reaches a proved or structural limit. The programme identifies eight. They are not all independent; the first two are the headline walls, the rest are the mechanisms that make them hard.

## W1 — The arithmetic-positivity wall (RH)

**What it blocks.** The Riemann programme converts RH into the equality of the balanced and unrestricted supports. The equality is equivalent to the absence of a right-half atom of the unrestricted measure, to the joint non-vanishing of `K = ¼ Re ξ` and `S = ¼ Im ξ`, to Weil positivity for the repaired current, and to `(M)` plus a conversion that reaches `σ=1/2`.

**Why it is a wall.** The additive toolbox cannot force positivity. The Davenport–Heilbronn twist has every additive feature and no Euler product, and the framework correctly reports a false RH at Spira’s zero. Therefore no theorem from the additive toolbox can be RH (Corollary C.10).

**What would breach it.** A global arithmetic positivity/multiplicativity input that fails for a sum of two Euler products and is strong enough to exclude a right-half atom.

**Status.** The conversion is proved; the positivity is open.

## W2 — The parity wall (twin primes, Chowla)

**What it blocks.** The greedy harmonic sine is a deterministic, sign-blind object. The twin-prime/Chowla target needs a positive-density multiplicative coupling to `Ω`. The programme proves the greedy support is Sylvester-sparse (density `≈3.9·10⁻⁵`), the budgets carry only index parity, the correlation has no Euler product, and the arithmetic-alphabet bridge is circular.

**Why it is a wall.** Selberg’s parity barrier: purely sieve-theoretic information cannot distinguish even/odd `Ω`. Every bridge that stays sign-blind is either too sparse or circular.

**What would breach it.** A sign-blind rule with a positive-density multiplicative coupling to `Ω`, or a proof of OP-19, or a genuinely new arithmetic input.

**Status.** The finite-prefix theorem, the Sylvester-sparsity theorem, and the five-bridge refutation are proved; the coupling is open.

## W3 — The finite-prefix wall

**What it blocks.** No finite prefix of values can decide an asymptotic correlation statement. The finite-prefix indeterminacy theorem makes this precise for two-point Chowla: a function can agree with `λ` on `[1,a)` and change the correlation later; the perturbation has ℓ²-mass exactly `4`.

**Why it is a wall.** A finite computation can refute an asymptotic claim by finding a counterexample, but cannot establish the limit. The theorem is Lean-certified.

**What would breach it.** Nothing, for the finite-prefix method. It is a no-go result, not a conjecture. The only way past it is to use a global argument, not more prefix data.

**Status.** Proved.

## W4 — The Euler-product wall

**What it blocks.** `f(n)=λ(n)λ(n+2)` is not multiplicative; the shifted product has no Euler product. The Dirichlet series of `f` does not factor over primes, so the standard multiplicative-function toolkit does not apply.

**Why it is a wall.** The RH side’s missing input is also an Euler-product/positivity input. The DH function has a functional equation but no Euler product; the correlation has no Euler product. Both walls sit at the same absence.

**What would breach it.** A genuinely new way to handle non-multiplicative correlations, or a proof that a multiplicative surrogate carries the needed information.

**Status.** Proved obstruction (no Euler product); no breach known.

## W5 — The self-adjointness wall (Hilbert–Pólya)

**What it blocks.** A Hilbert–Pólya operator would prove RH by self-adjointness. The programme’s CCM/helix work reduces the problem to a WKB/trace-formula conjecture (CCM Conjecture 1); the canonical paper’s tensor work reaches Weil positivity instead. Neither supplies the operator.

**Why it is a wall.** Self-adjointness is a strong global positivity. The local geometric constructions do not produce it. The trace-formula picture passes the DH litmus but has no constructed operator.

**What would breach it.** A self-adjoint operator whose spectral determinant is `ξ`, with the required positivity.

**Status.** Open; CCM Conjecture 1 is the precise obstruction.

## W6 — The uniformity wall

**What it blocks.** The RH conversion needs uniformity in height: the tightness window `|γ| ≤ N^{1/2−ε}`, the isolation clause, and the vanishing aperture. The parity programme needs uniformity in scale: the log-average vs natural-density gap.

**Why it is a wall.** The known methods give local or averaged statements. The conversion needs pointwise uniformity; the parity target needs a fixed shift, not an average. The gap is structural (Tao’s entropy-decrement remark; Frantzikinakis–Lemańczyk–de la Rue for Cesàro).

**What would breach it.** A pointwise uniformity theorem, not a density statement.

**Status.** Open/conditional (GUE, pair correlation, Lindelöf).

## W7 — The density-vs-pointwise wall

**What it blocks.** “Almost all” statements are blind to a density-zero set. Bombieri–Hejhal show this for zeros of linear combinations of `L`-functions. A density-zero off-line zero can survive any density statement.

**Why it is a wall.** The RH measures escape it only because the tempering weight charges individual atoms; the parity target needs a pointwise correlation, not a density statement.

**What would breach it.** A pointwise theorem, e.g. a Lee–Yang/confinement property for every finite zero.

**Status.** Proved blindness; pointwise bridge open (F.4).

## W8 — The well-posedness wall

**What it blocks.** Some open problems are not propositions as stated. OP-3 (“no sign-blind rule seeing `n` only through `log n`”) is false in its literal reading because `log` is injective and can encode arithmetic. OP-18 collapses to the existential dual of OP-19. The barrier sentence X5 was too wide and was withdrawn.

**Why it is a wall.** A problem that is not well-posed cannot be proved or refuted. The programme’s repair is OP-19: restrict the *description* of the rule (log-arc rules), not its value.

**What would breach it.** A precise definition and a definite truth value. OP-19 is the model.

**Status.** OP-19 is well-posed and open; OP-18 needs the same treatment.

## The wall map

```
                 W1 arithmetic positivity (RH)
                         |
        W4 Euler product | W6 uniformity | W5 self-adjointness
                         |
                 W7 density vs pointwise
                         |
                 W3 finite prefix
                         |
                 W2 parity (twin primes / Chowla)
                         |
                 W8 well-posedness
```

The arrows are not logical implications. They are the directions in which the programme’s methods hit a limit. The map is the achievement; the walls are the reason it is not a proof.

[Back to README](README.md) · [Back to index](../../index.html)
