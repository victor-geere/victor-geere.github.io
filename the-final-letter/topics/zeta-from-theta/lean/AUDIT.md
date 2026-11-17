# Provenance audit (D7)

**Claim audited.** The functional equation `zetaTheta_one_sub` (D4) and the
assembled `riemannZeta_one_sub_from_theta` (M6) are reachable from the theta
layer without passing through Mathlib's `*_one_sub` theorems for the zeta/Hurwitz
development.

**Method used: Method B (constant-level), the rigorous form.** Method A
(file-level `grep`) was run first as a spot-check; Method C (negative build) was
not run. Method B is implemented in [`Audit.lean`](Audit.lean), adapted from
`Mathlib.Util.PrintSorries`: starting from a target declaration it walks every
reachable `ConstantInfo` — both the *type* and the *value* of defs, theorems,
opaque definitions, constructors and inductives — and intersects the reachable
set with

```
riemannZeta_one_sub, completedRiemannZeta_one_sub,
completedRiemannZeta₀_one_sub, completedHurwitzZetaEven_one_sub,
hurwitzZetaEven_one_sub, cosZeta_one_sub, sinZeta_one_sub
```

Run:

```bash
./audit.sh          # == ./check.sh Audit.lean
```

## Recorded output (2026-11-09, Lean `v4.35.0-rc2`)

```
provenance OK: ZetaFromTheta.zetaTheta_one_sub reaches 51118 declarations; none is in the forbidden set [...]
provenance OK: ZetaFromTheta.zetaTheta_eq_riemannZeta reaches 55193 declarations; none is in the forbidden set [...]
provenance OK: ZetaFromTheta.riemannZeta_one_sub_from_theta reaches 55435 declarations; none is in the forbidden set [...]
provenance OK: ZetaFromTheta.riemannZeta_one_sub_from_theta' reaches 55445 declarations; none is in the forbidden set [...]
provenance OK: ZetaFromTheta.zetaTheta_removable_at_trivial_zero reaches 55335 declarations; none is in the forbidden set [...]
[check] OK   Audit.lean
```

(The bracketed forbidden list is the seven names above; it is elided here for
width and is printed in full by the command.)

## Why the assembled theorem is larger

The audit reports dependency-*closure* sizes, not "amount of FE content".  The
same run also computed the set difference between the targets:

| target | declarations |
|---|---:|
| `zetaTheta_one_sub` (D4) | 51,118 |
| `zetaTheta_eq_riemannZeta_of_ne_zero_one` (D5) | 55,193 |
| `riemannZeta_neg_two_mul_nat_add_one` (trivial zero) | 53,400 |
| `riemannZeta_one_sub_from_theta` (conditional M6) | 55,435 |
| `riemannZeta_one_sub_from_theta'` (unconditional M6) | 55,445 |

Relative to D4's 51,118 (set differences, not net growth — the closures overlap
without either containing the other):

* D5 contributes **4,316** declarations not already in D4's cone (its net
  closure growth is +4,075, because it also drops 241 of D4's Gamma-reflection
  nodes).  That 4,316 is 4,316 of the assembled theorem's 4,327 new nodes —
  essentially the whole gap.  D5's proof uses
  `completedRiemannZeta_eq_LambdaTilde_all`, whose proof calls
  `differentiableAt_completedZeta`; that reaches Mathlib's Hurwitz-zeta analytic
  infrastructure (`completedHurwitzZetaEven`, `AbstractFuncEq`, Fourier
  `AddCircle`, `Lp`, `ContinuousMap`, `JacobiTheta`, …).  None of it is
  functional-equation content, but it is a lot of declarations.
* `riemannZeta_neg_two_mul_nat_add_one` contributes **3,452** new declarations
  (net +2,282), almost all of them already inside the D5 cone.  Hence the
  unconditional branch costs only **10** more than the conditional one (55,445
  vs 55,435).
* D4 itself touches almost none of that infrastructure: its cone is theta +
  Mellin + Gamma reflection.

So the 4,327-node gap is the price of the *identification* and the
*trivial-zero value*, not of the functional-equation proof.  A larger cone is
not a weaker audit: the only thing that matters for the independence claim is
that no forbidden name occurs, and that is checked over the whole closure.

## Sensitivity check

A passing audit is only meaningful if the walker can fail.  Two negative
controls were run and both were flagged:

```lean
-- direct: Mathlib's own lemma
#provenance riemannZeta_one_sub
-- => provenance FAIL: riemannZeta_one_sub reaches forbidden constants [riemannZeta_one_sub]

-- transitive: a ZFE lemma defined from it
#provenance ZetaFunctionalEquation.zeta_one_sub
-- => provenance FAIL: ZetaFunctionalEquation.zeta_one_sub reaches forbidden constants [riemannZeta_one_sub]
```

The second control is the important one: it shows the walk follows a use through
an intermediate declaration in another module, so the `OK` verdicts are not
artefacts of stopping at the target.

## What this does and does not establish

* **Established.** No declaration in the transitive dependency cone of any of
  the four targets is one of the seven functional-equation lemmas. This is a
  statement about the *proof terms and statements* that Lean actually stores, not
  about source files.
* **Not established: mathematical independence.** The audit cannot rule out that
  a non-forbidden lemma was *proved using* a forbidden one; it checks the
  constants in the cone, and if a lemma in the cone had a forbidden constant in
  its own value, that constant would itself be in the cone and would be reported.
  So the walk does cover transitive use. What it cannot cover is a *definition*
  that encodes the functional equation implicitly (for example a constant whose
  body is an opaque quotient), or a future Mathlib rename that makes a forbidden
  lemma appear under a different name.
* **Not established: numerical or semantic independence.** The identification
  D5 and the removable-singularity statement D6 *do* use Mathlib's `riemannZeta`
  (through the definitional rewrite `riemannZeta_def_of_ne_zero` and the
  continuation `completedRiemannZeta_eq_LambdaTilde_all`). The pure
  theta-side functional equation is D4 (`zetaTheta_one_sub`); the audit of
  `zetaTheta_one_sub` alone is the cleanest statement of independence. The
  assembled M6 theorems additionally consume D5 and are audited separately
  above.  The unconditional M6 (`riemannZeta_one_sub_from_theta'`) also uses
  Mathlib's trivial-zero lemma in the `s = 1 + 2n` branch, which is not a
  functional-equation lemma and does not appear in the forbidden set.
* **Method C not run.** The negative-build test (building against a Mathlib with
  the forbidden names removed) was not performed. Until it is, "independent"
  should be read as "audited by Method B", which is stronger than the
  spot-check in the original README but is not the negative build.
