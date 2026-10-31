# Frontier: what an RH proof would still require

**Status:** no RH proof yet. The finite and structural layers are
substantially complete and largely Lean-checked. The **global** inputs needed
for an RH proof are not present. This note states the gap precisely so that
further work targets it rather than adding finite certificates.

## 1. What is established

**Lean-checked** (five files, no `sorry`; see [`../lean/README.md`](../lean/README.md)):

- finite KMS positivity, compatibility, and the limit form on the union
  (`Rescue.lean`, `Limit.lean`);
- the archimedean contour identity and symbol symmetries
  (`Archimedean.lean`);
- the ζ/Γ symbol identity on `Re s > 1`, its continued form, the completed-zeta
  functional equation, zero pairing, critical-line symmetry, and the
  log-derivative antisymmetry (`Symbol.lean`);
- the finite Hodge-index inequality, its equality/kernel case, the
  `2×2` Gram kernel, and margin monotonicity (`Shadow.lean`).

**Numerical certificates** (Python, explicit bounds, not Lean):

- exact cosh \(+\Omega\) Gram tests on the compact-support basis;
- interval-certified Gaussian Gram matrices at \(n=2,4,6,8\);
- a positive interval for the compact-support diagonal
  \(W_{00}\in[4.44\cdot10^{-5},3.86\cdot10^{-4}]\);
- the margin collapse, confirmed at 50 digits.

## 2. What is missing

1. **The distributional explicit formula (Guinand–Weil).**  The identity
   expressing the Weil functional as the zero sum plus the prime and
   archimedean terms, on a test-function class with a controlled zero-sum
   convergence.  Mathlib has the ζ and Γ functional equations but not this
   formula.  It is the bridge from the symbol/zero structure to the cone, and it is
**distributional**: the naive compact-support zero sum diverges
exponentially (note 49). The
non-archimedean **sign structure** is already Lean-checked
(`pole_term_nonneg`, `prime_term_nonpos` in [`../lean/Weil.lean`](../lean/Weil.lean)),
and the zero set is conjugation-stable (`completedZeta_conj`,
`completedZeta_zero_conj`), with `Z` real on the real axis
(`completedZeta_ofReal_im_zero`), so the zero sum is real. The
nonvanishing half-planes are Lean-checked: `Re s > 1`
(`completedZeta_ne_zero_of_one_lt_re`) and `Re s < 0` away from the trivial
zeros (`completedZeta_ne_zero_of_re_lt_zero_of_not_trivial`). Nontrivial zeros therefore lie in the **open critical strip**
`0 < Re s < 1` (`completedZeta_zero_re_open_strip`). The trivial zeros `Z(-2(n+1))=0` are Lean-checked **under Mathlib's
convention** (`Gamma` at nonpositive integers is defined as `0`); this is a
junk-value statement, not a claim about the meromorphic continuation, where
the Gamma pole and the zeta zero cancel. The identities used below are proven
away from `0,1` and the Gamma poles. (See the docstring of
`completedZeta_trivial_zero`.) The **genuine** trivial zeros are those of
zeta itself, `ζ(-2m)=0` for `m≥1`, Lean-checked as
`riemannZeta_trivial_zero` from `ζ(-k)=(-1)^k B_{k+1}/(k+1)` and the vanishing
of odd Bernoulli numbers.
(`completedZeta_trivial_zero`), so the zero picture is complete: trivial
zeros at the negative even integers, nontrivial zeros in `0 < Re s < 1`. In the strip the zeros of `Z` and `ζ` coincide
(`completedZeta_eq_zero_iff_zeta`). The critical line `Re s = 1/2` remains
the RH statement. The distributional
identity itself is not formalised.
2. **The Bost–Connes identification.**  The actual crossed product
   \(C^*(\mathbb Q/\mathbb Z)\rtimes\mathbb N^\times\), its \(\beta=1\) KMS
   state, and the identification of its modular Hamiltonian with the CCM
   length.  The finite KMS forms and their limit are formalised; the algebra
   and dictionary are not.
3. **A global positivity or kernel theorem.**  The limit Weil form must be
   non-negative on the test cone.  Finite positive-definite certificates
   cannot deliver this: the margin collapses, and the collapse is now
   Lean-backed (`hodge_index_equality_kernel`, `margin_nonincrease`).

## 3. What would count as a proof

The target is now a Lean definition, `RiemannHypothesis` in
[`../lean/Symbol.lean`](../lean/Symbol.lean): every zero of `Z` in the critical
strip has `Re s = 1/2`.  The `ζ`-form and the completed-zeta form are proved
equivalent (`riemannHypothesis_iff_zeta`).  The definition is **not** proved:
the programme has not produced a theorem of type `RiemannHypothesis`.  Its
geometric form, `riemannHypothesis_iff_critical_line`, says every strip zero
lies on `1/2 + iℝ`.

## 4. Why more finite certificates will not close it

The finite Gram route reaches only the semidefinite edge.  Increasing the
basis drives the margin to zero, and a zero margin is a kernel direction, not
a positive gap.  The missing input is a **global** statement about the limit
form — equivalently, the explicit-formula positivity — not a larger matrix.
This is the precise wall behind the earlier "no uniform gap" diagnostics.

## 5. Bottom line

- The finite and structural layers are in place.
- The three global inputs above are absent.
- More finite certificates do not approach the cone.
- No RH proof yet.

[Back to the dossier](../README.md) · [Margin collapse](45-margin-collapse.md) ·
[Lean core](../lean/README.md) · [Research journal](../research-journal.md)
