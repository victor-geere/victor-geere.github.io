# Glossary

| Term | Meaning |
|---|---|
| **Wall** | A proved or structural limit of a method class. |
| **Bridge** | A proposed route from available data to the far side of a wall. |
| **Litmus** | A test that a bridge must pass; the Davenport–Heilbronn test is the RH litmus. |
| **Global arithmetic positivity** | A positivity/multiplicativity input that fails for a sum of two Euler products; the missing object on both walls. |
| **Finite-prefix indeterminacy** | Two functions agreeing on a prefix can have different correlation sums; no finite computation decides the limit. |
| **Sign-blind** | A rule described without reference to `λ`, `Ω`, or arithmetic data. |
| **Positive-density coupling** | A statistic `T` with `Σ_{n≤x}T(n)λ(n) ≢ o(x)`. |
| **Right-half atom** | An atom of the unrestricted measure with `Re s > 1/2`; its absence is RH. |
| **Weil positivity** | Positivity of the Weil current `W` on the cone; equivalent to RH. |
| **Hypothesis (M)** | The limit function has no zeros in `σ>1`. |
| **DH litmus** | A result can close the RH gap only if it fails for the Davenport–Heilbronn function. |
| **OP-19** | The log-indicator barrier: `C_I(x)=o(x)` for every log-arc rule. |
| **F.4** | A Lee–Yang/confinement property for the polygon. |
| **Λ** | de Bruijn–Newman constant; RH is `Λ=0`; known `0≤Λ≤0.22`. |
| **Jensen/Li tower** | Hyperbolicity of all Jensen polynomials / non-negativity of all Li coefficients; equivalent to RH. |
| **CERTIFIED** | Rigorous finite-window interval certificate; not an asymptotic theorem. |
| **Objective III** | The programme's positive computation layer: a certified partial-sum-plus-tail evaluator for `ζ`, `ζ(s,a)` and `L(s,χ)`. |
| **Rational interval** | A pair of rationals `[lo, hi]` containing a real value; the evaluator's exact arithmetic domain. |
| **Certificate** | A straight-line record of rational interval operations, replayed by an independent checker and kernel-checked in Lean. |
| **Source claim** | A statement asserted by the source but not formalised here; it is recorded, not adopted as a theorem. |
| **Instrument, not a bridge** | A tool that makes finite-scale claims exact without supplying an asymptotic input; Objective III is the programme's instrument. |
| **`sorry` / `axiom`** | Lean placeholders/assumptions; the `FinalLetter` build has none. |
| **`native_decide`** | A decision procedure with an axiom footprint; eight `Rh41` theorems use it, none in `FinalLetter`. |

[Back to README](README.md) · [Back to index](index.html) · [Status](STATUS.md)
