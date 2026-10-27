"""
MiniProof Language v1.0 — Lark parser
Implements the grammar from miniproof.md exactly.
"""

from lark import Lark, Transformer, v_args, Token, Tree

# ---------------------------------------------------------------------------
# Grammar
# ---------------------------------------------------------------------------

GRAMMAR = r"""
    // -----------------------------------------------------------------------
    // Top level
    // -----------------------------------------------------------------------
    theory : decl*

    decl : term_const
         | pred_const
         | axiom_decl
         | theorem_decl

    // Term constant:  Term const <ident> : Term ( -> Term )* .
    term_const : "Term" "const" IDENT ":" term_kind "."
    term_kind  : "Term" ("->" "Term")*

    // Predicate constant:  Pred const <ident> : Term -> ... -> Prop .
    pred_const : "Pred" "const" IDENT ":" pred_kind "."
    pred_kind  : ("Term" "->")* "Prop"

    // Axiom:  Axiom <ident> : Prf(<prop>) .
    axiom_decl : "Axiom" IDENT ":" "Prf" "(" prop ")" "."

    // Theorem:  Theorem <ident> : Prf(<prop>) := <proof> .
    theorem_decl : "Theorem" IDENT ":" "Prf" "(" prop ")" ":=" proof "."

    // -----------------------------------------------------------------------
    // Object-language terms (individuals)
    // -----------------------------------------------------------------------
    term : IDENT "(" term ("," term)* ")"  -> term_app
         | IDENT                            -> term_var

    // -----------------------------------------------------------------------
    // Formulas (props) — explicit precedence levels (low to high):
    //   prop_impl  (->  right-assoc)
    //   prop_disj  (\/  right-assoc)
    //   prop_conj  (/\  right-assoc)
    //   prop_neg   (~)
    //   prop_prim  (atoms, quantifiers, parens)
    // The ? prefix makes single-child rules transparent (no tree node emitted).
    // -----------------------------------------------------------------------
    ?prop      : prop_impl
    ?prop_impl : prop_disj "->" prop_impl  -> prop_impl
               | prop_disj
    ?prop_disj : prop_conj "\\/" prop_disj -> prop_disj
               | prop_conj
    ?prop_conj : prop_neg  "/\\" prop_conj -> prop_conj
               | prop_neg
    ?prop_neg  : "~" prop_neg              -> prop_neg
               | prop_prim
    ?prop_prim : "forall" IDENT ":" "Term" "->" prop -> prop_forall
               | "exists" IDENT ":" "Term" "->" prop -> prop_exists
               | term "=" term                       -> prop_eq
               | IDENT "(" term ("," term)* ")"      -> prop_pred
               | IDENT                               -> prop_atom
               | "(" prop ")"                        -> prop_paren

    // -----------------------------------------------------------------------
    // Proof terms
    // -----------------------------------------------------------------------
    // Lambda, case, and unpack extend greedily to the right, so they live at
    // the top proof level (not inside proof_atom).  This prevents the
    // ambiguity between  \x:A. f x  as  (\x:A. f) x  vs  \x:A. (f x).
    //
    // proof_app handles left-associative application and postfix instantiation.
    // proof_atom covers every form that can legally appear as an argument.

    ?proof : proof_lam
           | proof_app

    proof_lam : "\\" IDENT ":" "Term" "." proof                                   -> proof_lam_term
              | "\\" IDENT ":" prop_prim "." proof                                 -> proof_lam_prop
              | "case" proof "of" IDENT "=>" proof "|" IDENT "=>" proof            -> proof_case
              | "unpack" proof "as" "(" IDENT "," IDENT ")" "in" proof             -> proof_unpack

    ?proof_app : proof_app proof_atom     -> proof_apply
               | proof_app "[" term "]"   -> proof_inst
               | proof_atom

    proof_atom : IDENT                                -> proof_var
               | "(" proof "," proof ")"              -> proof_pair
               | "(" proof ")"                        -> proof_paren
               | "fst" proof_atom                     -> proof_fst
               | "snd" proof_atom                     -> proof_snd
               | "inl" proof_atom                     -> proof_inl
               | "inr" proof_atom                     -> proof_inr
               | "pack" "(" term "," proof ")"        -> proof_pack
               | "explode" proof_atom                 -> proof_explode

    // -----------------------------------------------------------------------
    // Lexer — IDENT must not match reserved words.
    // -----------------------------------------------------------------------
    IDENT : /(?!(forall|exists|fst|snd|inl|inr|case|of|pack|unpack|as|in|explode|Term|Prop|Prf|Theorem|Axiom|Pred|const|False)\b)[A-Za-z][A-Za-z0-9]*/

    %ignore /\(\*[^*]*\*+([^)*][^*]*\*+)*\)/
    %ignore /\s+/
"""

# We need to handle keyword vs identifier conflict. Lark terminals are greedy,
# so we use a priority trick: list reserved words as their own terminals and
# give IDENT lower priority.

# Rather than fighting Lark's terminal priority here, we post-process identifiers
# in the transformer. The grammar above uses quoted strings for all keywords so
# Lark handles them correctly as literals vs IDENT automatically.


# ---------------------------------------------------------------------------
# AST node classes
# ---------------------------------------------------------------------------

class Term:
    pass

class TermVar(Term):
    def __init__(self, name: str):
        self.name = name
    def __repr__(self):
        return self.name

class TermApp(Term):
    def __init__(self, name: str, args: list):
        self.name = name
        self.args = args
    def __repr__(self):
        return f"{self.name}({', '.join(map(repr, self.args))})"


class Prop:
    pass

class PropAtom(Prop):
    def __init__(self, name): self.name = name
    def __repr__(self): return self.name

class PropPred(Prop):
    def __init__(self, name, args): self.name = name; self.args = args
    def __repr__(self): return f"{self.name}({', '.join(map(repr, self.args))})"

class PropEq(Prop):
    def __init__(self, lhs, rhs): self.lhs = lhs; self.rhs = rhs
    def __repr__(self): return f"({self.lhs} = {self.rhs})"

class PropNeg(Prop):
    def __init__(self, p): self.p = p
    def __repr__(self): return f"~{self.p}"

class PropConj(Prop):
    def __init__(self, l, r): self.l = l; self.r = r
    def __repr__(self): return f"({self.l} /\\ {self.r})"

class PropDisj(Prop):
    def __init__(self, l, r): self.l = l; self.r = r
    def __repr__(self): return f"({self.l} \\/ {self.r})"

class PropImpl(Prop):
    def __init__(self, l, r): self.l = l; self.r = r
    def __repr__(self): return f"({self.l} -> {self.r})"

class PropForall(Prop):
    def __init__(self, var, body): self.var = var; self.body = body
    def __repr__(self): return f"(forall {self.var}:Term -> {self.body})"

class PropExists(Prop):
    def __init__(self, var, body): self.var = var; self.body = body
    def __repr__(self): return f"(exists {self.var}:Term -> {self.body})"


class Proof:
    pass

class ProofVar(Proof):
    def __init__(self, name): self.name = name
    def __repr__(self): return self.name

class ProofApply(Proof):
    def __init__(self, fn, arg): self.fn = fn; self.arg = arg
    def __repr__(self): return f"({self.fn} {self.arg})"

class ProofLamProp(Proof):
    def __init__(self, var, prop, body): self.var = var; self.prop = prop; self.body = body
    def __repr__(self): return f"(\\{self.var}:{self.prop}. {self.body})"

class ProofLamTerm(Proof):
    def __init__(self, var, body): self.var = var; self.body = body
    def __repr__(self): return f"(\\{self.var}:Term. {self.body})"

class ProofPair(Proof):
    def __init__(self, l, r): self.l = l; self.r = r
    def __repr__(self): return f"({self.l}, {self.r})"

class ProofFst(Proof):
    def __init__(self, p): self.p = p
    def __repr__(self): return f"fst {self.p}"

class ProofSnd(Proof):
    def __init__(self, p): self.p = p
    def __repr__(self): return f"snd {self.p}"

class ProofInl(Proof):
    def __init__(self, p): self.p = p
    def __repr__(self): return f"inl {self.p}"

class ProofInr(Proof):
    def __init__(self, p): self.p = p
    def __repr__(self): return f"inr {self.p}"

class ProofCase(Proof):
    def __init__(self, scrut, x, lbranch, y, rbranch):
        self.scrut = scrut; self.x = x; self.lbranch = lbranch
        self.y = y; self.rbranch = rbranch
    def __repr__(self):
        return f"case {self.scrut} of {self.x} => {self.lbranch} | {self.y} => {self.rbranch}"

class ProofInst(Proof):
    def __init__(self, p, t): self.p = p; self.t = t
    def __repr__(self): return f"{self.p}[{self.t}]"

class ProofPack(Proof):
    def __init__(self, t, p): self.t = t; self.p = p
    def __repr__(self): return f"pack({self.t}, {self.p})"

class ProofUnpack(Proof):
    def __init__(self, p, x, y, body):
        self.p = p; self.x = x; self.y = y; self.body = body
    def __repr__(self): return f"unpack {self.p} as ({self.x}, {self.y}) in {self.body}"

class ProofExplode(Proof):
    def __init__(self, p): self.p = p
    def __repr__(self): return f"explode {self.p}"


class Decl:
    pass

class TermConst(Decl):
    def __init__(self, name, arity): self.name = name; self.arity = arity
    def __repr__(self): return f"Term const {self.name} : {'->'.join(['Term']*(self.arity+1))}"

class PredConst(Decl):
    def __init__(self, name, arity): self.name = name; self.arity = arity
    def __repr__(self): return f"Pred const {self.name} : {'Term->'*self.arity}Prop"

class AxiomDecl(Decl):
    def __init__(self, name, prop): self.name = name; self.prop = prop
    def __repr__(self): return f"Axiom {self.name} : Prf({self.prop})"

class TheoremDecl(Decl):
    def __init__(self, name, prop, proof):
        self.name = name; self.prop = prop; self.proof = proof
    def __repr__(self): return f"Theorem {self.name} : Prf({self.prop}) := {self.proof}"

class Theory:
    def __init__(self, decls): self.decls = decls
    def __repr__(self): return '\n'.join(map(repr, self.decls))


# ---------------------------------------------------------------------------
# Transformer
# ---------------------------------------------------------------------------

@v_args(inline=True)
class MiniProofTransformer(Transformer):

    # -- Theory --
    def theory(self, *decls):
        return Theory(list(decls))

    def decl(self, d):
        return d

    # -- Declarations --
    def term_const(self, name, kind):
        # kind is the number of "->" arrows, arity = number of "Term" tokens - 1
        return TermConst(str(name), kind)

    def term_kind(self, *tokens):
        # tokens are all the "Term" literals; arity = len - 1
        return len(tokens) - 1

    def pred_const(self, name, kind):
        return PredConst(str(name), kind)

    def pred_kind(self, *tokens):
        # tokens are "Term" literals; count of Term tokens = arity
        return len(tokens)

    def axiom_decl(self, name, prop):
        return AxiomDecl(str(name), prop)

    def theorem_decl(self, name, prop, proof):
        return TheoremDecl(str(name), prop, proof)

    # -- Terms --
    def term_var(self, name):
        return TermVar(str(name))

    def term_app(self, name, *args):
        return TermApp(str(name), list(args))

    # -- Props --
    # Operator nodes (called via -> aliases on the grammar rules)
    def prop_impl(self, l, r): return PropImpl(l, r)
    def prop_disj(self, l, r): return PropDisj(l, r)
    def prop_conj(self, l, r): return PropConj(l, r)
    def prop_neg(self, p):     return PropNeg(p)

    def prop_atom(self, name):
        return PropAtom(str(name))

    def prop_pred(self, name, *args):
        return PropPred(str(name), list(args))

    def prop_eq(self, lhs, rhs):
        return PropEq(lhs, rhs)

    def prop_forall(self, var, body):
        return PropForall(str(var), body)

    def prop_exists(self, var, body):
        return PropExists(str(var), body)

    def prop_paren(self, p):
        return p

    # -- Proofs --
    def proof_apply(self, fn, arg):
        return ProofApply(fn, arg)

    def proof_var(self, name):
        return ProofVar(str(name))

    def proof_paren(self, p):
        return p

    def proof_pair(self, l, r):
        return ProofPair(l, r)

    def proof_lam_prop(self, var, ann, body):
        # ann is a Prop (result of prop_prim sub-rules)
        return ProofLamProp(str(var), ann, body)

    def proof_lam_term(self, var, body):
        return ProofLamTerm(str(var), body)

    def proof_fst(self, p):
        return ProofFst(p)

    def proof_snd(self, p):
        return ProofSnd(p)

    def proof_inl(self, p):
        return ProofInl(p)

    def proof_inr(self, p):
        return ProofInr(p)

    def proof_case(self, scrut, x, lb, y, rb):
        return ProofCase(scrut, str(x), lb, str(y), rb)

    def proof_inst(self, p, t):
        return ProofInst(p, t)

    def proof_pack(self, t, p):
        return ProofPack(t, p)

    def proof_unpack(self, p, x, y, body):
        return ProofUnpack(p, str(x), str(y), body)

    def proof_explode(self, p):
        return ProofExplode(p)


# ---------------------------------------------------------------------------
# Public API
# ---------------------------------------------------------------------------

_parser = Lark(
    GRAMMAR,
    parser="earley",
    start="theory",
    ambiguity="resolve",
)

def parse(text: str) -> Theory:
    tree = _parser.parse(text)
    return MiniProofTransformer().transform(tree)

def parse_prop(text: str) -> Prop:
    p = Lark(GRAMMAR, parser="earley", start="prop", ambiguity="resolve")
    return MiniProofTransformer().transform(p.parse(text))

def parse_proof(text: str) -> Proof:
    p = Lark(GRAMMAR, parser="earley", start="proof", ambiguity="resolve")
    return MiniProofTransformer().transform(p.parse(text))


# ---------------------------------------------------------------------------
# Type checker
# ---------------------------------------------------------------------------

class TypeError(Exception):
    pass

class TypeChecker:
    """
    Checks proof terms against propositions using the Curry-Howard rules
    from miniproof.md Section 4.
    """

    def __init__(self, theory: Theory):
        # Global context: name -> Prop (for axioms/theorems) or "Term" (for term consts)
        self.globals: dict = {}
        self._load(theory)

    def _load(self, theory: Theory):
        for d in theory.decls:
            if isinstance(d, AxiomDecl):
                self.globals[d.name] = d.prop
            elif isinstance(d, TheoremDecl):
                self._check_theorem(d)
                self.globals[d.name] = d.prop
            elif isinstance(d, TermConst):
                self.globals[d.name] = "Term"
            elif isinstance(d, PredConst):
                self.globals[d.name] = ("Pred", d.arity)

    def _check_theorem(self, d: TheoremDecl):
        result = self.infer({}, d.proof)
        if not self._prop_eq(result, d.prop):
            raise TypeError(
                f"Theorem '{d.name}': proof has type\n  {result}\nbut expected\n  {d.prop}"
            )

    def _prop_eq(self, a: Prop, b: Prop) -> bool:
        """Syntactic equality of propositions."""
        if type(a) != type(b):
            return False
        if isinstance(a, PropAtom):
            return a.name == b.name
        if isinstance(a, PropPred):
            return a.name == b.name and len(a.args) == len(b.args) and all(
                self._term_eq(x, y) for x, y in zip(a.args, b.args))
        if isinstance(a, PropEq):
            return self._term_eq(a.lhs, b.lhs) and self._term_eq(a.rhs, b.rhs)
        if isinstance(a, PropNeg):
            return self._prop_eq(a.p, b.p)
        if isinstance(a, (PropConj, PropDisj, PropImpl)):
            return self._prop_eq(a.l, b.l) and self._prop_eq(a.r, b.r)
        if isinstance(a, (PropForall, PropExists)):
            return a.var == b.var and self._prop_eq(a.body, b.body)
        return False

    def _term_eq(self, a: Term, b: Term) -> bool:
        if type(a) != type(b):
            return False
        if isinstance(a, TermVar):
            return a.name == b.name
        if isinstance(a, TermApp):
            return a.name == b.name and len(a.args) == len(b.args) and all(
                self._term_eq(x, y) for x, y in zip(a.args, b.args))
        return False

    def _subst_prop(self, prop: Prop, var: str, term: Term) -> Prop:
        """Substitute term for var in prop."""
        if isinstance(prop, PropAtom):
            return prop
        if isinstance(prop, PropPred):
            return PropPred(prop.name, [self._subst_term(t, var, term) for t in prop.args])
        if isinstance(prop, PropEq):
            return PropEq(self._subst_term(prop.lhs, var, term),
                          self._subst_term(prop.rhs, var, term))
        if isinstance(prop, PropNeg):
            return PropNeg(self._subst_prop(prop.p, var, term))
        if isinstance(prop, PropConj):
            return PropConj(self._subst_prop(prop.l, var, term),
                            self._subst_prop(prop.r, var, term))
        if isinstance(prop, PropDisj):
            return PropDisj(self._subst_prop(prop.l, var, term),
                            self._subst_prop(prop.r, var, term))
        if isinstance(prop, PropImpl):
            return PropImpl(self._subst_prop(prop.l, var, term),
                            self._subst_prop(prop.r, var, term))
        if isinstance(prop, PropForall):
            if prop.var == var:
                return prop  # bound variable shadows
            return PropForall(prop.var, self._subst_prop(prop.body, var, term))
        if isinstance(prop, PropExists):
            if prop.var == var:
                return prop
            return PropExists(prop.var, self._subst_prop(prop.body, var, term))
        return prop

    def _subst_term(self, t: Term, var: str, replacement: Term) -> Term:
        if isinstance(t, TermVar):
            return replacement if t.name == var else t
        if isinstance(t, TermApp):
            return TermApp(t.name, [self._subst_term(a, var, replacement) for a in t.args])
        return t

    def infer(self, ctx: dict, prf: Proof) -> Prop:
        """
        Infer the proposition proved by prf in context ctx.
        ctx maps variable names to Prop (proof vars) or the string "Term" (term vars).
        Raises TypeError on failure.
        """
        if isinstance(prf, ProofVar):
            if prf.name in ctx:
                t = ctx[prf.name]
                if t == "Term":
                    raise TypeError(f"'{prf.name}' is a term variable, not a proof variable")
                return t
            if prf.name in self.globals:
                t = self.globals[prf.name]
                if isinstance(t, Prop):
                    return t
            raise TypeError(f"Unknown proof variable: '{prf.name}'")

        if isinstance(prf, ProofLamProp):
            # \x:A. M  proves  A -> B  when M proves B under x:A
            new_ctx = {**ctx, prf.var: prf.prop}
            body_type = self.infer(new_ctx, prf.body)
            return PropImpl(prf.prop, body_type)

        if isinstance(prf, ProofLamTerm):
            # \x:Term. M  proves  forall x:Term -> A
            new_ctx = {**ctx, prf.var: "Term"}
            body_type = self.infer(new_ctx, prf.body)
            return PropForall(prf.var, body_type)

        if isinstance(prf, ProofApply):
            fn_type = self.infer(ctx, prf.fn)
            arg_type = self.infer(ctx, prf.arg)
            if not isinstance(fn_type, PropImpl):
                raise TypeError(f"Application: function has non-implication type {fn_type}")
            if not self._prop_eq(fn_type.l, arg_type):
                raise TypeError(
                    f"Application: argument type\n  {arg_type}\ndoes not match\n  {fn_type.l}")
            return fn_type.r

        if isinstance(prf, ProofPair):
            l = self.infer(ctx, prf.l)
            r = self.infer(ctx, prf.r)
            return PropConj(l, r)

        if isinstance(prf, ProofFst):
            t = self.infer(ctx, prf.p)
            if not isinstance(t, PropConj):
                raise TypeError(f"fst: expected conjunction, got {t}")
            return t.l

        if isinstance(prf, ProofSnd):
            t = self.infer(ctx, prf.p)
            if not isinstance(t, PropConj):
                raise TypeError(f"snd: expected conjunction, got {t}")
            return t.r

        if isinstance(prf, ProofInl):
            # inl M : A \/ B — we can only infer A; B is unknown
            # In a bidirectional system we'd need a type annotation; here we just
            # return a partially-determined type. We raise if used in checking context.
            t = self.infer(ctx, prf.p)
            raise TypeError(
                "inl: cannot infer the right disjunct; use in a checking context or annotate")

        if isinstance(prf, ProofInr):
            t = self.infer(ctx, prf.p)
            raise TypeError(
                "inr: cannot infer the left disjunct; use in a checking context or annotate")

        if isinstance(prf, ProofCase):
            scrut_type = self.infer(ctx, prf.scrut)
            if not isinstance(scrut_type, PropDisj):
                raise TypeError(f"case: scrutinee has non-disjunction type {scrut_type}")
            ctx_l = {**ctx, prf.x: scrut_type.l}
            ctx_r = {**ctx, prf.y: scrut_type.r}
            t_l = self.infer(ctx_l, prf.lbranch)
            t_r = self.infer(ctx_r, prf.rbranch)
            if not self._prop_eq(t_l, t_r):
                raise TypeError(
                    f"case: branches have different types\n  {t_l}\nvs\n  {t_r}")
            return t_l

        if isinstance(prf, ProofInst):
            # M[t] : A[t/x]  when M : forall x:Term -> A
            fn_type = self.infer(ctx, prf.p)
            if not isinstance(fn_type, PropForall):
                raise TypeError(f"[t]: expected forall type, got {fn_type}")
            return self._subst_prop(fn_type.body, fn_type.var, prf.t)

        if isinstance(prf, ProofPack):
            # pack(t, M) : exists x:Term -> A  when M : A[t/x]
            # We can't infer the bound variable name without annotation; raise.
            raise TypeError(
                "pack: cannot infer existential type without annotation on the bound variable")

        if isinstance(prf, ProofUnpack):
            # unpack M as (x, y) in N
            scrut_type = self.infer(ctx, prf.p)
            if not isinstance(scrut_type, PropExists):
                raise TypeError(f"unpack: expected exists type, got {scrut_type}")
            new_ctx = {**ctx, prf.x: "Term", prf.y: scrut_type.body}
            return self.infer(new_ctx, prf.body)

        if isinstance(prf, ProofExplode):
            t = self.infer(ctx, prf.p)
            if not isinstance(t, PropAtom) or t.name != "False":
                raise TypeError(f"explode: expected Prf(False), got {t}")
            # Returns any proposition — we return a placeholder atom
            return PropAtom("_")

        raise TypeError(f"Cannot infer type of proof term: {type(prf).__name__}")

    def check(self, ctx: dict, prf: Proof, expected: Prop):
        """Check prf against expected proposition, handling inl/inr/pack."""
        if isinstance(prf, ProofInl):
            if not isinstance(expected, PropDisj):
                raise TypeError(f"inl: expected a disjunction type, got {expected}")
            self.check(ctx, prf.p, expected.l)
            return
        if isinstance(prf, ProofInr):
            if not isinstance(expected, PropDisj):
                raise TypeError(f"inr: expected a disjunction type, got {expected}")
            self.check(ctx, prf.p, expected.r)
            return
        if isinstance(prf, ProofPack):
            if not isinstance(expected, PropExists):
                raise TypeError(f"pack: expected an existential type, got {expected}")
            body = self._subst_prop(expected.body, expected.var, prf.t)
            self.check(ctx, prf.p, body)
            return
        # Fall through to inference + equality check
        inferred = self.infer(ctx, prf)
        if not self._prop_eq(inferred, expected):
            raise TypeError(
                f"Type mismatch:\n  inferred  {inferred}\n  expected  {expected}")


# ---------------------------------------------------------------------------
# CLI entry point
# ---------------------------------------------------------------------------

def main():
    import sys
    if len(sys.argv) < 2:
        print("Usage: miniproof_parser.py <file.mp>")
        sys.exit(1)
    with open(sys.argv[1]) as f:
        src = f.read()
    try:
        theory = parse(src)
        print("Parse OK.")
        print(theory)
        tc = TypeChecker(theory)
        print("Type check OK.")
    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        sys.exit(1)

if __name__ == "__main__":
    main()
