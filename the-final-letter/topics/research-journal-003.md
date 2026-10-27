
### 2026-10-27 — I.297: `ContDiffAt` of `s ↦ b^{-s}` (T399); a `rw` friction

`contDiffAt_cpow_neg (b : ℂ) (hb : b ≠ 0) (n : WithTop ℕ∞) (s : ℂ) :
ContDiffAt ℂ n (fun s => b^(-s)) s`, proved by rewriting to
`Complex.exp (-s * Complex.log b)` and composing `Complex.contDiff_exp`.
This is the hypothesis `iteratedDeriv_sum` needs for the base sum.

**Friction (not yet solved).** `rw [iteratedDeriv_fun_sum hf]` fails: the lemma's
implicit `𝕜`, order, index set and point become metavariables that `rw` cannot
infer before matching, and the resulting goal is reported as
`(↑(↑n + 1) : ℂ) ≠ 0` rather than the intended sum equality.  Tried `refine
(iteratedDeriv_fun_sum …).trans ?_` — instance-synthesis failures on the
implicits.  **Next attempt should state the goal as an equality of functions and
provide every implicit explicitly**, e.g.
`iteratedDeriv_sum (I := Finset.range 20) (f := fun n z => ((n+1 : ℂ))^(-z))`
with `x := s`, or bypass these lemmas by `Finset.induction` with
`iteratedDeriv_add`.

**Note:** the zero-proof `(↑(↑n + 1) : ℂ) ≠ 0` needed
`congrArg Complex.re` + `rw [Complex.ofReal_re, Complex.zero_re]` + `linarith`;
`positivity` and `exact_mod_cast` both fail on the complex coercion.
