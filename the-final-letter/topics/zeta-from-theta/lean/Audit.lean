/-
# Provenance audit (D7, Method B)

`#print axioms` lists only axioms, not the constants a proof depends on.  This
file implements the constant-level audit described in HANDOFF §7: starting from a
target declaration it walks every reachable `ConstantInfo` (types *and* values)
and reports any constant in the forbidden set — the functional-equation lemmas of
Mathlib's zeta/Hurwitz development.

The implementation is adapted from `Mathlib.Util.PrintSorries`, which does the
same walk for `sorryAx`.

Run with `./check.sh Audit.lean` (or `./audit.sh`).  A `provenance OK` line is a
pass; a `provenance FAIL` line is an elaboration error.
-/
import Topic

open Lean Meta Elab Command

namespace ZetaFromTheta

/-- The functional-equation lemmas of the Hurwitz/zeta development that must not
occur in the dependency cone of the theta-side development. -/
def forbiddenNames : Array Name := #[
  `riemannZeta_one_sub,
  `completedRiemannZeta_one_sub,
  `completedRiemannZeta₀_one_sub,
  `completedHurwitzZetaEven_one_sub,
  `hurwitzZetaEven_one_sub,
  `cosZeta_one_sub,
  `sinZeta_one_sub ]

/-- State of the walk: the set of declarations already visited. -/
structure ProvenanceState where
  visited : NameSet := {}

/-- Collect all declarations reachable from `c` through types and values. -/
partial def collectDeps (c : Name) : StateT ProvenanceState MetaM Unit := do
  let collectExpr (e : Expr) : StateT ProvenanceState MetaM Unit := do
    e.getUsedConstants.forM collectDeps
  let s ← get
  unless s.visited.contains c do
    modify fun s => { s with visited := s.visited.insert c }
    let env ← getEnv
    match env.checked.get.find? c with
    | some (.axiomInfo v)  => collectExpr v.type
    | some (.defnInfo v)   => collectExpr v.type *> collectExpr v.value
    | some (.thmInfo v)    => collectExpr v.type *> collectExpr v.value
    | some (.opaqueInfo v) => collectExpr v.type *> collectExpr v.value
    | some (.quotInfo _)   => pure ()
    | some (.ctorInfo v)   => collectExpr v.type
    | some (.recInfo v)    => collectExpr v.type
    | some (.inductInfo v) => collectExpr v.type *> v.ctors.forM collectDeps
    | none                 => pure ()

/-- Run the walk and split the reachable set into (visited, forbidden hits). -/
def auditDeps (target : Name) : MetaM (NameSet × Array Name) := do
  let (_, s) ← (collectDeps target).run {}
  pure (s.visited, forbiddenNames.filter (fun f => s.visited.contains f))

elab "#provenance " n:ident : command => do
  let target ← liftCoreM <| realizeGlobalConstNoOverloadWithInfo n
  let (visited, hits) ← liftTermElabM <| auditDeps target
  if hits.isEmpty then
    logInfo m!"provenance OK: {target} reaches {visited.size} declarations; \
      none is in the forbidden set {forbiddenNames.toList}"
  else
    logError m!"provenance FAIL: {target} reaches forbidden constants {hits.toList}"

end ZetaFromTheta

open ZetaFromTheta

#provenance zetaTheta_one_sub
#provenance zetaTheta_eq_riemannZeta
#provenance riemannZeta_one_sub_from_theta
#provenance riemannZeta_one_sub_from_theta'
#provenance zetaTheta_removable_at_trivial_zero
