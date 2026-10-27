# rh40 — cumulative error ledger

Every error made by **any** participant is recorded here, in the ledger-keeping
spirit of HANDOFF.md §8.4. The previous dialogue's ledger had 24 rows across ten
rounds; this is the successor.

Status vocabulary: **MEDIATOR ERROR**, **AGENT A ERROR**, **AGENT B ERROR**,
**HANDOFF DEFECT** (a defect in `HANDOFF.md` itself, found by recomputation).

| # | round | who | claim | why it was wrong | caught by |
|---|---|---|---|---|---|
| 1 | open | HANDOFF DEFECT | §3.1's piecewise law `p(L) = 2L − 10` on `12 ≤ L ≤ 593`, `3L − 603` on `594 ≤ L ≤ 604` | false from `L = 15`: gives 20 where the truth is 19; at `L = 593` gives 1176 vs 597. §5 already flagged the law as over-extrapolated; §3.1 printed it as the law | mediator (probe 6) |
| 2 | open | HANDOFF DEFECT | §3.4/§3.3's implication that `p(L) = #right-special(L)` first difference holds for the finite word | fails for all 608 values `L ∈ [792, 1399]` at `N = 1400` | mediator (M5) |
| 3 | open | MEDIATOR ERROR | finite-word fix is `p(L+1) − p(L) = RS(L) − LS(L+1)` | false in the decay regime; the correct object is `Z(L) = \|F(L)\| − #prefixes(F(L+1))`, a terminal-uniqueness indicator, **not** a left-special count | Agent B, then mediator's second script |
| 4 | open | MEDIATOR ERROR | plateau is `L ∈ [605, 791]` | truth is `L ∈ [605, 792]` (188 values) | Agent B |
| 5 | open | MEDIATOR ERROR | decay begins at `N − a_m` | `N − a_m = 793`; the decay **law** begins at `N − a_m − 1 = 792` | Agent B |
| 6 | open | MEDIATOR ERROR | `#{L : Z(L) = 1} = a_m` | truth is `a_m + 1`: the range `[N − a_m − 1, N − 1]` has `a_m + 1` elements | mediator (verification script) |
| 7 | open | MEDIATOR ERROR | initial rational census: "277 of 277 reduced p/q with q ≤ 30 terminate" | cap of 200 was too small. **the count is a cap artefact: 277/277 at cap 2·10⁵ and 2·10⁹, 275/277 at 5·10⁶, 268/277 at ≈2·10⁶.** Deepest indices: `4/25 = 53 307 974`, `27/29 = 1 003 066 151`. The mediator stated "268" as if it were absolute | mediator self-caught (twice) |
| 8 | open | MEDIATOR ERROR | brief M6 generalised: "the C1 regime ends strictly below the next gap **in every case**" | true for the four dialogue words; not established in general, and later tests show the boundary depends on more than the gaps | mediator self-caught |
| 9 | open | HANDOFF DEFECT | §5 counterexample "distance law fails at L = 12: 13 vs 14" | does not reproduce — both sides give 14. The true first failure is `L = 11` (13 vs 12) | mediator |
| 10 | open | HANDOFF DEFECT | §5 counterexample "pairs law fails, log 2, L = 6: 9 vs 8" | does not reproduce — both sides give 8. The true first failure for log 2 is `L = 4` (6 vs 5) | mediator |
| 11 | round 1 | AGENT A ERROR | C1 boundary `L_max = 1 + min(min_j d_j, min_j(d_j+d_{j+1}))` | fails *inside* its own claimed range on 4 903 of 17 375 sampled eligible words, and is too early on 449. Exact on the four dialogue words — which is what made it look right | mediator |
| 12 | round 1 | AGENT A ERROR | counterexample `{13,244}`, N = 253, quoted as "rule 233 vs true 24" | the numbers are internally inconsistent (truth at `L = 233` is 21; the true first failure is `L = 24`, rule 25 vs exact 24), and the word is degenerate: `N − a_m − 1 = 8`, so C1 has almost no content there | mediator |
| 13 | round 1 | AGENT B ERROR | "the naive `RS(L) − LS(L+1)` holds 0/18895 cases" | the count is not reproducible. The formula happens to hold on the **pre-decay** range where `Z(L) = 0`; it fails only where `Z(L) = 1`. B's substantive point stands, B's denominator does not | mediator |
| 14 | round 1 | MEDIATOR ERROR | brief put to A said "decay begins at exactly `N − a_m = 792`" | same as row 5, repeated in the agent-facing brief before B corrected it | Agent B (round 1) |
| 15 | round 1 | MEDIATOR ERROR | `round01_brief.md` labelled the word `(10,20,40,80)`, N=500 as "e−2" | it is not e−2. The true greedy support for e−2 is `(0, 3, 53)` at N = 2000, stable over dps ∈ {60,120,200}. The mislabel came from HANDOFF §3.3 and was inherited without checking | Agent B |
| 16 | round 1 | MEDIATOR ERROR | test suite `test_base_case` asserted `p(L) = L + 1` up to the min gap for a single-one word | for a single one at `a` the law is `p(L) = min(L, a+1) + 1` for `L ≤ N − a − 1`, then `N − L + 1`; validated only for `N ≥ 2a + 4` | mediator (pytest) |
| 17 | open | MEDIATOR ERROR | `test_rational_termination` asserted `(terminating, total) == (268, 277)` after raising the cap to 5·10⁶ | at that cap the truth is `(275, ["4/25", "27/29"])`. The mediator raised the cap but left the old assertion, then read a truncated pytest tail as "all passed" | mediator, only on re-reading the full output |
| 18 | open | MEDIATOR ERROR | `round01.md` and the ledger asserted the 268 figure as settled | it is a cap artefact; corrected in `truths.md` H1–H3 with the exact extreme indices | mediator self-caught |
| 19 | open | HANDOFF DEFECT | §6.5's residual-orbit protocol: "iterate ~40–50 steps per target, then test whether the running averages converge" | **unachievable.** The residual squares each step, so step `k` needs `~2^k` digits. Measured: dps 60→7 steps, 3200→13 steps, `steps ≈ 2 + log₂(dps)`. 40–50 steps needs ≈10¹² digits | mediator |
| 20 | open | MEDIATOR ERROR | `probes.py` probe 5 ran at dps 140 and reported `-inf` means, which reads as "the means diverge" | it was precision underflow after 7–12 steps, not divergence. Fixed to dps 800 **and** the real law (I5/I6 in `truths.md`) recorded instead | mediator |

| 21 | session 3 | MEDIATOR ERROR | C1 equivalence `L ≤ 1 + min_j d_j or L > max_j d_j` | **false on 65.6 % of 1 772 281 cases** (all supports, `m+1 ≤ 4`, `N ≤ 25`, all `L`); still false on 26 % restricted to `L ≤ a_0+1`. Generalised from four examples | mediator, by exhaustive test |
| 22 | session 3 | MEDIATOR ERROR | `p(L) = min(L, a_0, N−L+1) + [N−L > a_0]` for single-one words | false in the degenerate case `a = 0, N = 1`; the correct law is `p(L) = min(L, a) + [N−L > a]` | mediator |
| 23 | session 3 | MEDIATOR ERROR | C1 regime `L ≤ min(min_j d_j, a_0+1, N−a_0−1)` | the bound must be `a_0`, not `a_0+1`: `ones=(1,)`, `N=3`, `L=2` is a counterexample. The corrected Theorem D is exact on 399 486 cases | mediator |
| 24 | session 3 | MEDIATOR ERROR | `p(L) = Σ_j |X_j|` (sum of per-index offset intervals) | the intervals **overlap**; the correct count is the union. Overcounts by up to 14 for 1/π and 41 for (10,20,40,80) | mediator |
| 25 | session 3 | MEDIATOR ERROR | the `(i, x, jmax)` and `(i, x)` encodings of factors | not injective: `{0,1}`, `N=3`, `L=1` gives two windows with the same `(i,x)` and the *same* factor. The `(S, x)` encoding is the one that works | mediator |
| 26 | session 3 | MEDIATOR ERROR | general_law.py's first two runs: the all-zero condition as `a_m + 1 ≤ N − L` | the correct condition is `a_0 + 1 ≤ N − L`; the first version reported ~100 k spurious failures | mediator |
| 27 | session 3 | HANDOFF DEFECT | §6 item 5 / journal: `A(N) = O(log log N)` presented as the known bound | the super-exponential index growth proves the **lower** bound `Ω(log log N)`; `O(log log N)` is the unproved direction | mediator |

| 28 | session 3 | MEDIATOR ERROR | the all-zero condition, tried in three forms: `a_m+1 ≤ N−L`, then `a_0+1 ≤ N−L` | none is valid in general. The truth is "some **extended** gap (before the first, between consecutive ones, or after the last) is `≥ L+1`" — 24 337 and 29 247 failures respectively on the 95 826-case corpus. The trailing-gap form is correct only under `L ≥ span`, which is why K1 was unaffected | mediator |

| 29 | session 3 | MEDIATOR ERROR | in `verify_agentK6.py` I compared Agent B's `u`-map against `u' = uq/(q−u)` while advancing with coefficient `1/(q−2)` | the coefficient is `1/q` with `q = ⌈1/r⌉`; using `q−2` produced 4 spurious mismatches. My error, not B's | mediator |
| 30 | session 3 | MEDIATOR ERROR | I dismissed B's `s' = 1 − {q²/s}` as failing (8 steps, 5 mismatches) | the identity is correct; my test read `s_next` from the wrong `r'`. Re-tested cleanly: 6 steps, 0 mismatches | mediator |

| 31 | session 3 | AGENT-K7 ERROR (delegated) | the family's word is `1^{N(p)}0^∞` with every gap equal to 1, and `α_n=(n+2)^{−3/2}` is a max-gap-1 witness | the orbit **never halts** for `1<p≤p*`: `N(p)` ends the initial segment, then the fixed positive residual keeps selecting a tail (`{0..8, 34, 954, 77716, …}`, gaps 25/919/76 761). Repeated in the agent's *final* report after the mediator had refuted it in the interim one | mediator |
| 32 | session 3 | AGENT-K7 ERROR (delegated) | the termination threshold for general `x` quoted as `p = 1.728647…` | the threshold is target-dependent: `Σ α_n ≥ x`. For `x = 1/2` it is the root of `ζ(p) = 3/2`, `p = 2.18528545178748223` | mediator |
| 33 | session 3 | MEDIATOR ERROR | `verify_agentK6.py` compared against `u' = uq/(q−u)` while advancing with coefficient `1/(q−2)` | coefficient is `1/q`; four spurious mismatches | mediator |
| 34 | session 3 | MEDIATOR ERROR | declared B's `s' = 1 − {q²/s}` false (5 of 8 mismatches) | the identity is correct; my test read `s_next` from the wrong `r'` | mediator |

## Attributed results (not errors — recorded so credit and status are clear)

| result | who | status |
|---|---|---|
| `p(L+1) − p(L) = RS(L) − Z(L)`, the finite-word Cassaigne repair | **Agent B** (round 1), mediator-reproduced | `STANDING` |
| `max p = a_m + 2` on the plateau, **proved** | **mediator** (this session) | `PROVED` — [`K1_plateau_theorem.md`](../K1_plateau_theorem.md) |
| The large-`L` law `p(L) = min(a_m+1, N−L+1) + [L ≤ N−a_m−1]` | **mediator** | `PROVED` |
| The decay law as a corollary (C2b) | **mediator** | `PROVED` |
| The plateau **value** first observed as `a_m + 2` | **Agent B**, independently predicted by **Agent A** | their observation is now a theorem |
| `Z(L) = 1 ⟺ L ∈ [N−a_m−1, N−1]` | Agent B (value), mediator (exact range) | `VERIFIED` |
| The `e−2` mislabel, the `slopes` docstring defect, the `factor_set` API defect | **Agent B** | fixed |
| The residual-orbit precision law `steps ≈ 2 + log₂(dps)` | **mediator** | `VERIFIED`; refutes the handoff's protocol |

The mediator's K1 proof was reached only after four of the mediator's own
candidate laws for the plateau/onset boundary had been refuted (E8, J11, J12 and
the `min(a_m+2, N−L+1)` form). The path was: Agent B's `a_m+2` observation →
Agent A's independent prediction on three new words → the mediator's search for
the *onset* rule → failure → the realisation that the correct statement is not
about the onset but about `min(a_m+1, N−L+1)` plus an indicator.

## Ledger summary

| participant | errors |
|---|---|
| HANDOFF.md (defects in the inherited document) | 6 |
| mediator | 23 |
| Agent A | 2 |
| Agent B | 1 |
| delegated K6/K7 agents | 2 |

**34 rows total.**

The honest reading: the mediator is still the least reliable participant, as in
the previous dialogue, and the independent-recomputation rule (HANDOFF.md §8) is
what caught every one of these. Agent B's single error is a wrong *count* on a
correct *claim*; Agent A's two errors are both about a **boundary** — the same
failure mode HANDOFF.md §7.1 predicted for A, which is a useful confirmation
that the persona's stated failure mode is real and detectable.
