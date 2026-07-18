=========================================
          MiniProof Language v1.0
=========================================

A fully explicit proof language for first-order logic
based on the Curry-Howard correspondence, using only
printable ASCII characters (US-101 keyboard).

----------------------------------------
1. LEXICAL GRAMMAR
----------------------------------------

letter  = 'a'..'z' | 'A'..'Z'
digit   = '0'..'9'
ident   = letter (letter | digit)*
         (not a reserved word)

reserved words:
  Prop, Term, Prf, fun, all, ex, False,
  case, of, inl, inr, fst, snd, pack,
  unpack, as, in, forall, exists

----------------------------------------
2. SYNTAX OF TERMS, FORMULAS AND PROOFS
----------------------------------------

(* Object language terms (individuals) *)
term ::= ident
       | ident '(' term (',' term)* ')'

(* Formulas *)
prop ::= ident                                 -- atomic proposition
       | ident '(' term (',' term)* ')'        -- predicate applied to terms
       | term '=' term                         -- equality
       | '~' prop                              -- negation (-> False)
       | prop '/\' prop                        -- conjunction
       | prop '\/' prop                        -- disjunction
       | prop '->' prop                        -- implication
       | 'forall' ident ':' 'Term' '->' prop   -- universal quantifier
       | 'exists' ident ':' 'Term' '->' prop   -- existential quantifier
       | '(' prop ')'

(* Proof terms *)
proof ::= ident                                 -- hypothesis or named proof
        | '(' proof ')'                         -- grouping
        | '\' ident ':' prop '.' proof          -- implication intro
        | proof proof                           -- implication elim
        | '(' proof ',' proof ')'               -- conjunction intro
        | 'fst' proof                           -- conjunction elim left
        | 'snd' proof                           -- conjunction elim right
        | 'inl' proof                           -- disjunction intro left
        | 'inr' proof                           -- disjunction intro right
        | 'case' proof 'of' ident '=>' proof
          '|' ident '=>' proof                  -- disjunction elim
        | '\' ident ':' 'Term' '.' proof        -- universal intro
        | proof '[' term ']'                    -- universal elim
        | 'pack' '(' term ',' proof ')'         -- existential intro
        | 'unpack' proof 'as'
          '(' ident ',' ident ')' 'in' proof    -- existential elim
        | 'explode' proof                       -- false elim (ex falso)

----------------------------------------
3. DECLARATIONS AND THEORIES
----------------------------------------

A MiniProof file contains a sequence of declarations:

  - Term constants:
      Term const <ident> : Term.
      Term const <ident> : Term -> Term.
      (the arrow chain indicates arity)

  - Predicate constants:
      Pred const <ident> : Term -> ... -> Prop.
      (nullary predicates are just Prop)

  - Axioms:
      Axiom <ident> : Prf(<prop>).

  - Theorems (proofs):
      Theorem <ident> : Prf(<prop>) := <proof>.

----------------------------------------
4. TYPING RULES (Curry-Howard)
----------------------------------------

Context Gamma is a set of variable declarations:
  x : Term        (term variable)
  x : Prf(A)      (proof variable for formula A)

Notation: Gamma |- M : Prf(A) means M is a proof of A.

---- Assumption ----
If x:Prf(A) in Gamma, then Gamma |- x : Prf(A).

---- Implication (->) ----
Gamma, x:Prf(A) |- M : Prf(B)
----------------------------- (->I)
Gamma |- \x:A. M : Prf(A -> B)

Gamma |- M : Prf(A -> B)   Gamma |- N : Prf(A)
---------------------------------------------- (->E)
Gamma |- M N : Prf(B)

---- Conjunction (/\) ----
Gamma |- M : Prf(A)   Gamma |- N : Prf(B)
----------------------------------------- (/\)I)
Gamma |- (M, N) : Prf(A /\ B)

Gamma |- M : Prf(A /\ B)
------------------------ (/\E1)
Gamma |- fst M : Prf(A)

Gamma |- M : Prf(A /\ B)
------------------------ (/\E2)
Gamma |- snd M : Prf(B)

---- Disjunction (\/) ----
Gamma |- M : Prf(A)
---------------------- (\/I1)
Gamma |- inl M : Prf(A \/ B)

Gamma |- M : Prf(B)
---------------------- (\/I2)
Gamma |- inr M : Prf(A \/ B)

Gamma |- M : Prf(A \/ B)
Gamma, x:Prf(A) |- N : Prf(C)
Gamma, y:Prf(B) |- P : Prf(C)
------------------------------------- (\/E)
Gamma |- case M of x => N | y => P : Prf(C)

---- Universal quantifier (forall) ----
Gamma, x:Term |- M : Prf(A)
----------------------------- (forall I)  (x not free in any hypothesis)
Gamma |- \x:Term. M : Prf(forall x:Term -> A)

Gamma |- M : Prf(forall x:Term -> A)   Gamma |- t : Term
--------------------------------------------------------- (forall E)
Gamma |- M[t] : Prf(A[t/x])

---- Existential quantifier (exists) ----
Gamma |- t : Term   Gamma |- M : Prf(A[t/x])
-------------------------------------------------- (exists I)
Gamma |- pack(t, M) : Prf(exists x:Term -> A)

Gamma |- M : Prf(exists x:Term -> A)
Gamma, x:Term, y:Prf(A) |- N : Prf(C)
--------------------------------------------------- (exists E)
Gamma |- unpack M as (x, y) in N : Prf(C)
(x not free in C or any hypothesis except y)

---- False elimination ----
Gamma |- M : Prf(False)
-------------------------- (explode)
Gamma |- explode M : Prf(A)

----------------------------------------
5. EQUALITY (axioms, not built-in)
----------------------------------------

Equality is a binary predicate `=` declared as:
  Pred const eq : Term -> Term -> Prop.
Notation: t1 = t2 means eq(t1,t2).

We require user to add axioms:
  Axiom refl : Prf(forall x:Term -> x = x).
  Axiom subst : Prf(forall x:Term -> forall y:Term -> (x = y) -> (P(x) -> P(y))).
(for any formula P with a free variable)

----------------------------------------
6. EXAMPLE PROOF (transitivity of ->)
----------------------------------------

Theorem trans : Prf((A -> B) -> (B -> C) -> (A -> C)) :=
  \f:(A->B). \g:(B->C). \x:A. g (f x).

----------------------------------------
7. CHECKING PROCESS
----------------------------------------

1. Parse the theory file, building a global context of
   constants and axiom assumptions.
2. For each theorem, type-check the proof term against
   the given formula using the inference rules.
3. If the proof term is well-typed, the theorem is accepted.
   Otherwise, report the first type error.

This language forces every proof step to be fully
explicit; no hidden leaps of logic are allowed.