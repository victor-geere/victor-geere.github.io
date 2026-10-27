# OP-3 — the barrier downgraded: "sign-blind alphabet, no arithmetic input", and the two do not mix

**Kind:** Claim
**Status:** CONJECTURED (heuristic — the source states it as a HEURISTIC and as **OPEN**; the register's earlier, over-wide form is withdrawn)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/open/07-open-problems.md`](../../research/twin-prime-parity/open/07-open-problems.md) — § 0.1 item 4, § A.1 row OP-3, § A.2 (lines 75–81, 96, 122–146)

## Statement

> **`rh47`'s own barrier was over-wide and is downgraded to a heuristic.** "Every greedy-sine object is an additive character in `log n`" is too wide: `n^{−it}` is a *multiplicative* character on `(ℝ₊,×)`, and the budgets are constants in `p`. The audit's `C3a` even exhibits a greedy object of the *same take rule* with an *arithmetic* alphabet (`α_p = (−1)^{Ω(p+2)}/(p+2)`, `z = +10.1`) — which mixes, but is circular. The barrier must read **sign-blind alphabet, no arithmetic input**, and "the two do not mix" stays **HEURISTIC** (`rh47/truths.md` §3).

The register's row:

> | **OP-3** | **R2 of `rh47`** — no sign-blind deterministic rule that sees `n` only through `log n` can force a multiplicative correlation with `Ω`. | **OPEN → IMPOSSIBLE-AS-STATEMENT** as inherited; the precise version is OPEN | `rh47`'s barrier package: budget sign-blindness (`P+N = ζ−1`, `P−N = 1−η`, separating *index* parity only), the twist invariance `Σ λ(n)(−1)ⁿλ(n+2)(−1)^{n+2} = Σ λ(n)λ(n+2)` exactly (`0/10⁶` mismatches), and the Euler-product failure `\|D(2) − model\| = 2.0144 > 1.84·10⁻⁵` ([`rh47/truths.md`](../../research/twin-prime-parity/rounds/rh47/truths.md) §2). | R2 is **not a well-formed proposition** as inherited ("rule", "seeing", "force" are undefined) — see A.2, OP-3. The first concrete instance that resists everything the programme has: the `rh43` positive-part set `A = {n : cos(t log n) > 0}` is sign-blind and depends on `n` only through `log n`, yet `Σ_{n≤x} 1_A(n)λ(n) = o(x)` is **not known** — the Fourier expansion reduces it to a *divergent* sum of individually-`o(x)` twisted sums `Σ λ(n)n^{−ikt}`. |

And from § A.2:

> 1. **It is not yet a proposition.** "Rule", "sees", and "force" have no definitions in the harvest; R2 is a research direction, not a theorem statement. *Making R2 precise is itself the first open sub-problem.*
> 2. **The over-wide reading is false.** The `rh47` HANDOFF's supporting sentence — "every greedy-sine object is an additive character in `log n`" — was withdrawn after audit (`truths.md` §3): `n^{−it}` is multiplicative on `(ℝ₊,×)`, and the sums `Σ λ(n)n^{−it}` *do* vanish (`= o(x)` for each fixed real `t`; classical, from `ζ(2s)/ζ(s)` analytic on `Re s ≥ 1` because `ζ(1+ir) ≠ 0`). So additivity alone neither prevents nor forces correlation.
> 3. **The concrete instance that resists.** The `rh43` positive-part set `A_t = {n : cos(t log n) > 0}` is exactly a sign-blind rule depending on `n` only through `log n`; `Σ_{n≤x} 1_{A_t}(n)λ(n) = o(x)` is **not known**. The Fourier series `1_{cos θ>0} = 1/2 + (2/π)Σ_{k≥0}(−1)^k cos((2k+1)θ)/(2k+1)` expresses the sum as a *divergent* series of individually-`o(x)` twisted sums, so no available technique truncates it. *(Literature status of this one instance: marked **unverified** in this register — it is not settled by any result harvested in rh40–rh47, and the register could not confirm a published resolution.)*

## Hypotheses and notation

- `Ω(n)` is the number of prime factors with multiplicity; `α_p` is the alphabet used by the greedy take rule; `z` is the reported standardised deviation.
- "Sign-blind" = the budgets are constants in the sign structure of the target; `P+N = ζ−1`, `P−N = 1−η`.
- `A_t = {n : cos(t log n) > 0}` is the `rh43` positive-part set; `1_{cos θ>0} = 1/2 + (2/π)Σ_{k≥0}(−1)^k cos((2k+1)θ)/(2k+1)` is its Fourier series.
- `D(2)` is the two-point correlation's Dirichlet sum at `s=2`; the model is the naive Euler product; the tail `1.84·10⁻⁵` is the corrected rigorous tail.

## Proof / evidence

- The register reports the *proved legs* of the barrier package from `rh47/truths.md` §2: budget sign-blindness, the twist invariance (`0/10⁶` mismatches), and the Euler-product failure (`2.0144 > 1.84·10⁻⁵`).
- The same legs are recorded in [`checks/06-numerical-checks.md`](../../research/twin-prime-parity/checks/06-numerical-checks.md) § rh47 and in this harvest's entries on budget sign-blindness and on non-multiplicativity / no Euler product.
- The audit's circular witness: prime-indexed alphabet `α_p = (−1)^{Ω(p+2)}/(p+2)` gives `z = +10.1`, but `import = mean(sign·λ) = 1.0000`, i.e. "the alphabet literally *contains the target function*"; the same take rule with permuted signs is null (`+0.0192 ± 0.0968`).

## Dependencies and related results

- `OP-12`, `OP-16`, `OP-18` of the same register; the `rh47` harvested round files `tpp-rh47-*` in this harvest.
- The register's § B.3 (out of reach): "**OP-3** in its strong form. Not because it is false, but because it is not yet a proposition, and because the one concrete instance (`1_{cos(t log n)>0}`) is itself open".

## Notes

- **Status honesty.** The source calls the corrected barrier a **HEURISTIC** and the impossibility claim **not** a theorem: "the proved legs are budget sign-blindness (plus twist invariance) and the Euler-product failure; 'the two do not mix' is not established." The status `CONJECTURED` above is the closest term of the SPEC vocabulary; the source's own words are "HEURISTIC" and "OPEN".
- The register's document-level disclaimer still applies to this row: "a reference register, not a result. It contains no new theorem and claims none."
- The register also insists on the *point* of the downgrade: "The `k = 1` twisted Chowla facts show that vanishing correlations with `log n`-data *exist*, so any negative theorem must isolate a genuinely additional property (roughness / positive density)".
- `rh47`'s literal over-wide sentence and its withdrawal are recorded in `rh47/truths.md` §3 and in the checks register's §§ rh47.
