# OP-2 — one-point Chowla is equivalent to the prime number theorem (SETTLED, not open)

**Kind:** Theorem
**Status:** CITED (literature — Tao, arXiv:1605.04628 §1; the transfer identity `λ = 1_□ * μ` is classical, Landau)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/open/07-open-problems.md`](../../research/twin-prime-parity/open/07-open-problems.md) — § 0.1 item 1, § A.1 row OP-2, § A.2, § B.1 "OP-2" (lines 53–65, 95, 115–120, 310–318)

## Statement

> **`rh46/README.md` §1.3 states that one-point Chowla `Σ_{n≤x} λ(n) = o(x)` is "itself OPEN". That is false.** The `k = 1` case of the Chowla conjecture *is* equivalent to the prime number theorem, and is therefore a theorem — see [Tao, *Equivalence of the logarithmically averaged Chowla and Sarnak conjectures*, arXiv:1605.04628](https://arxiv.org/abs/1605.04628) §1: *"The `k=1` case of the Chowla conjecture is equivalent to the prime number theorem. The higher `k` cases are open."* The elementary transfer is the identity `λ = 1_□ * μ` (`Σ_n λ(n)n^{−s} = ζ(2s)/ζ(s)`), from which `Σ_{n≤x} λ(n) = Σ_{d≤√x} M(x/d²)` and conversely `M(x) = Σ_{d≤√x} μ(d) L(x/d²)`; splitting the `d`-sum at a large fixed `D` gives the equivalence with `M(x) = o(x)`, i.e. PNT (classical, Landau). **`rh47/HANDOFF.md` §5.1 and `rh47/README.md` repeat the `rh46` wording; both inherit the error.** The register row OP-2 is therefore **SETTLED (theorem)**, not OPEN.

The register's own tabulation of the row:

> | **OP-2** | One-point case `Σ_{n≤x} λ(n) = o(x)`. | **SETTLED (theorem)** — *not open* | Equivalent to PNT; `k = 1` Chowla ([Tao, arXiv:1605.04628](https://arxiv.org/abs/1605.04628)); the transfer is the classical `λ = 1_□ * μ` identity. Recorded in this register because `rh46` §1.3 and `rh47` §5.1 mislabel it OPEN. | None to the statement. The obstruction is to **method**: Selberg's parity problem says no sieve weight `w` built from small-prime residue conditions can give `Σ w(n)λ(n) = o(Σ w(n))`, even though the theorem is true ([`rh43/truths.md`](../../research/twin-prime-parity/rounds/rh43/truths.md) §8.5). |

## Hypotheses and notation

- `λ` is the Liouville function (`(−1)^{Ω(n)}`); `μ` the Möbius function; `M(x) = Σ_{n≤x} μ(n)`; `L(x) = Σ_{n≤x} λ(n)`.
- `1_□` is the indicator of the squares; `λ = 1_□ * μ` is Dirichlet convolution, equivalently `Σ_{d|n} λ(d) = 1` if `n` is a square and `0` otherwise (`Σ_n λ(n)n^{−s} = ζ(2s)/ζ(s)`).
- `D` is a large fixed splitting point of the `d`-sum in the transfer argument.
- `k = 1` Chowla is `Σ_{n≤x} λ(n) = o(x)`; PNT is `M(x) = o(x)` (equivalently `ψ(x) = x + o(x)`).

## Proof / evidence

- Citation: Tao, *Equivalence of the logarithmically averaged Chowla and Sarnak conjectures*, arXiv:1605.04628 §1 (the register quotes: "The `k=1` case of the Chowla conjecture is equivalent to the prime number theorem. The higher `k` cases are open.").
- The register sketches the elementary transfer (`λ = 1_□ * μ`, `Σ_{n≤x} λ(n) = Σ_{d≤√x} M(x/d²)`, conversely `M(x) = Σ_{d≤√x} μ(d) L(x/d²)`, split the `d`-sum at large fixed `D`) and attributes the equivalence with `M(x) = o(x)` to Landau.
- The register's § B.1 "OP-2" entry prescribes only record maintenance: correct `rh46/README.md` §1.3 and `rh47/HANDOFF.md` §5.1 / `rh47/README.md` to say "equivalent to PNT, hence a theorem"; difficulty `L`, "the mathematics is classical".

## Dependencies and related results

- The register's `OP-4` row: "`k=1` ⟺ PNT ([Tao, arXiv:1605.04628](https://arxiv.org/abs/1605.04628))"; `OP-17` (Sarnak) is implied by un-averaged Chowla.
- The same equivalence is THEOREM 3.3 of the dictionary ledger [`03-parity-problem.md`](../../research/twin-prime-parity/dictionary/03-parity-problem.md) and the harvested file `tpp-dict-03-one-point-chowla-iff-pnt.md`.
- The register contrasts the theorem with the *method* obstruction: Selberg's parity problem (`rh43/truths.md` §8.5) bars a sieve proof even though the statement is true.

## Notes

- The register's document-level disclaimer must be read with this row: "a reference register, not a result. It contains no new theorem and claims none." The content harvested here is the register's correction of the record — the equivalence is literature, not new mathematics.
- The register states the row plainly: "This is the register's only row whose residue is *methodological*. `Σ_{n≤x}λ(n) = o(x)` is a theorem (⟺ PNT). What is *not* available is a proof by sieve."
- The register says the error is inherited: "`rh47/HANDOFF.md` §5.1 and `rh47/README.md` repeat the `rh46` wording; both inherit the error."
