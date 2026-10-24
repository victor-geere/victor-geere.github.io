# rh40 — round 01, Agent B (the auditor)

Recorded verbatim by the mediator. Scripts written by B this round:
`rh40/verify/agentB_sweep.py`, `rh40/verify/agentB_audit.py`.

**Mediator's verification status is in `round01.md`; headings below are B's.**

---

## [CHARITABLE]

Repaired C2, precisely. Fix a finitely supported word w_N with ones
a_0<...<a_m<N (m>=1), F(L) its length-L factor set, d+(f) the number of right
extensions of f inside w_N, and Z(L)=#{f in F(L): d+(f)=0}=|F(L)|-|{prefix(g):
g in F(L+1)}|, which is 0 or 1. Three repairs to HANDOFF §4/§7.2: (i) the exact
first difference is p(L+1)-p(L)=RS(L)-Z(L), not RS(L); Z(L) is a uniqueness
indicator for the terminal window t=N-L, not a count of windows. (ii) The
plateau/decay boundary is L=N-a_m-1, not "N/2": for sqrt2-1 the plateau reaches
L=1748=0.874N. (iii) On the plateau p(L)=a_m+2, fixed by the last one alone (so
§3.3's "609=605+4 and also 607+2" is the second reading), and p is not
eventually constant at fixed N. The (i,x) repair of §7.2: for L>span the factor
whose first 1 is a_i at offset x=a_i-t is the tail {x+(a_j-a_i): j>=i}, and the
realisable pairs are exactly those with 0<=x<=min(d_{i-1}-1,a_i,L-1) (convention
d_{-1}=infinity) and a_i-x<=N-L; the all-zero factor occurs iff L<=N-a_m-1. On
the plateau these tails are distinct, which is why p=a_m+2.

## [KNOWN]

Cassaigne's first-difference method (Complexity and special factors, Bull. SMF
125 (1997) 1-26, [Zbl 0921.68065](https://zbmath.org/?q=0921.68065)) gives
p(L+1)-p(L)=sum_{f in F(L)}(d+(f)-1) for an *extendable* language, where d+>=1,
so HANDOFF §3.4's form p(L+1)-p(L)=#right-special is correct only there;
right-special/extendability as in [Cassaigne-Nicolas,
arXiv:0903.1627](https://arxiv.org/abs/0903.1627). The finite-word correction
Z(L) is elementary (p(L+1)=sum of d+ over F(L), counting each (L+1)-factor by its
unique length-L prefix) and I found no source stating it; the naive RS(L)-LS(L+1)
has no correct attribution - it is simply false. New, and unclaimed by the
handoff (§3.3 itself says the saturation value "needs its own derivation"): the
exact finite identity, and the plateau law a_m+2. Misattribution flag:
probes.py's "e-2" word (10,20,40,80), N=500, is *not* e-2 - the true greedy word
for e-2 at N=2000 is (0,3,53); the brief's M6 "e-2" row inherits the mislabel.

## [TESTED]

(a) For all five words (1/pi (2,13,607) N=1400; log2 (0,4,36,6069) N=13000;
sqrt2-1 (1,11,251) N=2000; (10,20,40,80) N=500; true e-2 (0,3,53) N=2000) and
every L in [1,N-1]: p(L+1)-p(L)=RS(L)-Z(L) holds 18895/18895, 0 failures; naive
RS(L)-LS(L+1) holds 0/18895; RS(L)-LS(L) 5/18895. The mediator's hypothesis is
right, sharpened: the loss is -Z(L) in {0,-1}, and Z(L)=1 exactly when the
terminal window t=N-L produces a factor occurring at no other t. For 1/pi, Z=0 on
[605,791], Z=1 on [792,1399], RS=0 throughout; first_difference_check disagrees on
exactly the 608 values L in [792,1399], first L=792=N-a_m-1.

(b) p(L)=609 on exactly L in [605,792] (188 values), nowhere else; p(L)=N-L+1 on
exactly L in [792,1400] (609 values): 792->609, 793->608, 799->602, 800->601,
1399->2. The brief's [605,791] misses L=792, and "decay begins at N-a_m=792" is
off by one: N-a_m=793=1400-607, while 792=N-a_m-1.

(c) Not a function of (m,span,N): 45/55 keys are multi-valued; m=1, span=0, N=20
gives (0,)->2 versus (11,)->10. Not gaps alone, nor (gaps,N): gaps=() at N=20
gives max p = 2,11,10,2 for (0,),(10,),(11,),(19,). Positive law: max p = a_m+2
for every support with N>=2a_m+3 - 255/255 N=20 words and 744/744 random supports
(N<=300), zero counterexamples - giving 609, 6071, 253, 82, 55. So the plateau
value is a_m+2, a function of a_m alone (equivalently, of the gaps together with
a_0).

(d) digitword.py is computationally clean: p_offset==p_bruteforce on 43342
exhaustive cases (N<=12, <=4 ones, all L), on all 701 decay-regime L of 1/pi, and
on 400 random words; right_special_factors==my own independent bit-string
enumeration on 22088 cases and on all L<1400 for 1/pi; slopes()==hand computation
for (0,2), N=6 (p=[2,3,4,3,2,1], runs [(1,2,1),(3,5,-1)]). Two defects, both
documentation: slopes()'s docstring repeats §3.1's false runs ((11,592,2),
(593,604,3)) although the function returns [(1,10,1),(11,13,2),(14,604,1),
(605,791,0),(792,1399,-1)]; and factor_set(L>N) returns set() where p_offset
raises. Scripts: rh40/verify/agentB_sweep.py, rh40/verify/agentB_audit.py.

## [VERDICT]

STANDING: the corrected identity p(L+1)-p(L)=RS(L)-Z(L) and the plateau/decay laws
p=a_m+2 and p=N-L+1 are exactly verified (the a_m+2 form still lacks a proof),
while §3.4's RS-form and §3.1's formula are DISPROVEN at fixed N, with the two
off-by-one boundary corrections recorded.

## [OPEN]

Ask A to prove that on the plateau the map (first-1 index, offset) -> factor is
injective and all a_m+1 non-empty pairs realise, hence p(L)=a_m+2 whenever
N>=2a_m+3 - or to exhibit the smallest support (with N>=2a_m+3) where it fails;
my 999 tested supports found none.
