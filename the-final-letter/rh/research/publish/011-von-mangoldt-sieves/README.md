# publish/011 — Sieves for the von Mangoldt function

Eleventh published edition. This folder packages **item §11 of `research/truths.md`**:
the von Mangoldt sieve results, with the Lean companion and the reference
implementation.

> **Note on editions.** This is the **same paper** as
> [`publish/001-von-mangoldt-sieves`](../001-von-mangoldt-sieves), the original first
> edition. `011` is the copy made by item number when the `truths.md` ledger was
> packaged. The two folders carry identical material; the first edition's own folder guide
> is preserved here as [`FIRST-EDITION-README.md`](FIRST-EDITION-README.md), and this
> folder adds the item ledger [`TRUTHS.md`](TRUTHS.md).

## What the item is

The von Mangoldt function `Λ` is `log p` on the powers of a prime and `0` elsewhere. This
item is the *sieve* side: exact algorithms that produce the whole table
`(Λ(1), …, Λ(N))`, together with the formalised identities they rely on.

| Result | Statement | Status |
|---|---|---|
| support | `Λ n ≠ 0 ↔ IsPrimePow n` | **PROVED** (Lean) |
| prime powers | `Λ(p^k) = log p` for `p` prime, `k ≠ 0` | **PROVED** (Lean) |
| divisor identity | `Σ_{d∣n} Λ d = log n` | **PROVED** (Lean) |
| Möbius inversion | `Λ = μ ∗ log` | **PROVED** (Lean) |
| non-additive / non-multiplicative | with witnesses `6 = 2·3`, `4 = 2·2` | **PROVED** (Lean) |
| bound | `Λ n ≤ log n` | **PROVED** (Lean) |

The round also records the **sieve bug** that motivates the work: a linear-sieve
recurrence computes `log rad(n) = Σ_{p|n} log p`, the additive function that agrees with
`Λ` on prime powers but not in general. The same defect appears independently in
[`publish/006-explicit-formula-routes-abc`](../006-explicit-formula-routes-abc)
(`Rh45/VonMangoldtSieve.lean`), where `Λ 6 = 0` and `Λ` is shown not additive.

## Contents

| File | What it is |
|---|---|
| [`TRUTHS.md`](TRUTHS.md) | **The item**: the §11 ledger from `research/truths.md`, links re-pointed into this folder. |
| [`FIRST-EDITION-README.md`](FIRST-EDITION-README.md) | The first edition's own folder guide. |
| [`von-mangoldt-sieves.html`](von-mangoldt-sieves.html) | The paper. Self-contained: styles and mathematics are inline. |
| [`von_mangoldt_sieves.py`](von_mangoldt_sieves.py) | Reference implementation and self-check of Algorithms A, B, B′ and C, plus the exact checks of §4. **Python 3 standard library only.** |
| [`VonMangoldtSieves.lean`](VonMangoldtSieves.lean) | The Lean companion: `support_ne_zero_iff`, `apply_prime_pow`, `divisor_identity`, `moebius_convolution`, `not_additive`, `not_multiplicative`, `le_log`. |
| [`check.sh`](check.sh) | Builds the Lean companion against Lean 4 + Mathlib. |

## What is proved

Everything tabulated above is proved in Lean. Propositions 2.5–2.8 of the paper (the
additive sibling `log rad`, Chebyshev's `ψ` and `θ`, the lcm identity, and the Dirichlet
series) are proved in the paper; the lcm identity and the divisor identity are also
verified numerically by `von_mangoldt_sieves.py`.

Nothing here is open, and nothing here touches the twin-prime or parity questions.

## Running the checks

```sh
./check.sh                            # Lean 4 + Mathlib, exit 0 (~15 s)
python3 von_mangoldt_sieves.py        # default N = 2000
python3 von_mangoldt_sieves.py 50000  # any table bound
```

The script exits `0` if and only if every check passes. It runs the prime-power marking
sieve and the integer divisor-sum sieve and compares their exact outputs, checks the
exact divisor identity `∏_{d|n} exp Λ(d) = n` in integer arithmetic, compares the real
divisor-sum sieve and the Möbius-convolution sieve against the exact table, and verifies
`exp ψ(10) = lcm(1,…,10)` and `exp ψ(20) = lcm(1,…,20)`.

See `publish/002-greedy-digit-word/README.md` for the `LEAN_PREFIX` convention.

## Dependencies

Everything needed is in this folder. External dependencies: **Mathlib** (Lean) only —
`von_mangoldt_sieves.py` imports nothing outside the Python standard library.

## Provenance

Originally published as `publish/001-von-mangoldt-sieves`; see `research/truths.md` §11.
The files here are byte-identical copies of that edition, with the item ledger added, its
links re-pointed into this folder, and the first edition's guide kept under a distinct
name.
