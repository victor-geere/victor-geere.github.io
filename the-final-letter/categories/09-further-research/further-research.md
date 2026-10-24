# Further research

The programme’s open problems are not all equally useful. This list is ranked by what would actually move a wall, not by what is easy to compute.

## Tier 1 — would move a wall

### R1. Prove or refute OP-19 (the log-indicator barrier)

The well-posed replacement for OP-3: for every log-arc rule `A_I`, is `C_I(x) = Σ_{n≤x}1_{A_I}(n)λ(n) = o(x)`? A proof would be a genuine parity result; a counterexample would kill the sign-blind programme.

**Why it matters:** it is the cleanest precise statement of “can a sign-blind rule with no arithmetic input force a multiplicative correlation?”
**Status:** open. See [`summary-rh/03/04`](../../summary-rh/03-open-problems/04-op-19-log-indicator.md).

### R2. Prove or refute Weil positivity for the repaired current

The tensor programme reduces the RH positivity to Weil positivity for `W`. A proof would close RH; a counterexample would refute it. The current `W` has the correct spectral resolution; the positivity is the open statement.

**Why it matters:** it is the exact form of the missing arithmetic positivity on the RH side.
**Status:** open/classical. See [`summary/10`](../../summary/10-prime-spectrum-tensor/17-theorem-c-weil-criterion.md).

### R3. Prove or refute `(M)` in a class that contains `ζ`

`(M)`: no zeros in `σ>1`. Under (M), the DH obstruction lapses, but (M) does not prove RH. The useful version is a multiplicativity/positivity input that fails for a sum of two Euler products and is strong enough to reach `σ=1/2`.

**Why it matters:** it is the sharpest known separator between the additive and multiplicative worlds.
**Status:** open as an input; see [`summary/06`](../../summary/06-davenport-heilbronn/README.md).

### R4. A Lee–Yang/confinement theorem for the polygon

F.4: a ferromagnetic spin system whose finite partition functions are `η_N^{(N²)}`, or any reweighting confining every finite zero to a line. It passes the DH litmus; the computable part is the transfer-operator form.

**Why it matters:** it is the one known mechanism that forces finite zeros onto a line.
**Status:** open. See [`summary/09`](../../summary/09-quantum-placements/05-open-item-f.4.md).

## Tier 2 — would sharpen a wall

### R5. de Bruijn–Newman `Λ = 0`

Known `0 ≤ Λ ≤ 0.22`; RH is `Λ=0`. A proof of `Λ=0` would close RH. A proof of `Λ>0` would refute it.

### R6. Jensen/Li tower uniformity

Fixed degree at large shift is known; uniformity in the degree is the full tower. A proof would close RH; a counterexample would refute it.

### R7. Uniform slow passage on the tightness window

`|ζ′(ρ)| ≤ N^ε` on `|γ| ≤ N^{1/2−ε}`. This is a GUE/HKO prediction, not used by any theorem. It would make parts of the conversion uniform.

### R8. Uniform isolation

A pair-correlation bound on zeros with a neighbour within `N^{−κ}`. It would make the isolation clause of Definition 5.1 uniform.

## Tier 3 — formalisation and methodology

### R9. Formalise the conversion theorem in Lean

A substantial measure-theory/analytic-number-theory project. It would make the RH conversion machine-checked, but it would not prove RH.

### R10. Formalise the greedy/budget/balance layers

`Rh41`, `Rh42`, `Rh43`, `Rh45`, `Rh47`, `Op56`, `ConeLean`, `TppLean` already contain substantial Lean. A unified `FinalLetter` development could import them and expose a single API.

### R11. Make OP-18 well-posed

OP-18 is not well-posed as phrased; on a fixed class it is the existential dual of OP-19. The useful task is to fix the class and state the dual precisely.

### R12. A formal “no finite prefix” meta-theorem

The finite-prefix theorem is about one slice. A general meta-theorem — any predicate determined by finitely many values cannot imply a limit statement — would be a reusable no-go principle. It is not currently formalised.

## What not to do

- **Do not run more zeros.** The finite-prefix theorem says finite computation cannot decide the Chowla limit; the `T=15/33` certificates are finite-window results, not RH.
- **Do not sharpen an estimate that the DH twist also satisfies.** The DH litmus says it cannot be the missing input.
- **Do not treat density statements as pointwise.** Bombieri–Hejhal show they are blind to density-zero off-line sets.
- **Do not promote `CONJECTURED` heuristics to targets.** Eleven of the 36 harvested items are recorded expectations, not commitments.
- **Do not restore X1–X6.** The errata are part of the result.

[Back to README](README.md) · [Back to index](../../index.html)
