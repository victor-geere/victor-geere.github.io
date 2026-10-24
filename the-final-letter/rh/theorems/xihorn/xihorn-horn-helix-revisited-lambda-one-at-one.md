# ξ′/ξ(1) = Σ_γ 1/(¼ + γ²) = λ₁

**Kind:** Proposition
**Status:** PROVED (paper argument; equation (1) evaluated at s = 1, numeric value to 12 digits)
**Area:** xi-horn
**Source:** [`xi-horn/horn-helix-revisited.md`](../../xi-horn/horn-helix-revisited.md) — §1.2, equation (2); §7 dictionary, term "λ₁ = ξ′/ξ(1)"

## Statement

> And (1) at s = 1 *is* λ₁:
>
> ```
> ξ′/ξ(1) = Σ_γ 1/(¼+γ²) = λ₁         (numeric: 0.0230957089661, 12 digits)  (2)
> ```
>
> rh10 §5 called λ₁ "one constant, three dials." Here it is a fourth: the value of the closure ledger at the pole's old address.

with λ₁ = 1 + γ_E/2 − ½ln 4π = 0.0230957089661.

## Hypotheses and notation

- (1) is the closure ledger ξ′/ξ(s) = Σ_γ 2(s−½)/((s−½)²+γ²), with zeros paired ρ = ½ ± iγ.
- At s = 1 each summand is 2·½/((½)²+γ²) = 1/(¼+γ²).
- γ_E is Euler's constant; λ₁ is rh10 §5's constant, quoted as 0.0230957089661.

## Proof / evidence

Immediate evaluation of (1) at s = 1; the source gives the numeric value 0.0230957089661 to 12 digits (§6 repeats "ξ′/ξ(1) numeric | 0.0230957089661 (= λ₁, 12 digits)"). The same paper's §1.2 uses the identity to pay the ledger's tail: Σ_{k≤150} 1/(¼+γ_k²) = 0.02064233715, tail 0.00245337.

## Dependencies and related results

- [The closure ledger](xihorn-horn-helix-revisited-closure-ledger.md) (1), of which this is the value at s = 1.
- rh10 §5's λ₁ ("one constant, three dials") → [rh10-lambda-one-three-dials.md](../rh10/rh10-lambda-one-three-dials.md); the source adds the fourth reading.
- 2λ₁ = 0.0461914 is the Báez-Duarte constant quoted in §4.1/§6.

## Notes

- The identity inherits the pairing hypothesis of (1): the zeros are written ρ = ½ ± iγ.
- The source presents λ₁ here as a dial of the *closure ledger*, not as new mathematics; the constant itself is rh10 §5's.
