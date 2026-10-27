# publish/001-von-mangoldt-sieves — Sieves for the von Mangoldt Function

First edition of the paper *Sieves for the von Mangoldt Function*, together with a
reference implementation and a Lean 4 / Mathlib companion.

## Contents

| File | What it is |
|---|---|
| `von-mangoldt-sieves.html` | The paper (open in any browser). Self-contained: styles and mathematics are inline. |
| `von_mangoldt_sieves.py` | Reference implementation and self-check of Algorithms A, B, B′ and C, plus the exact checks of §4. Python 3 standard library only. |
| `VonMangoldtSieves.lean` | Lean 4 formalisation of Propositions 2.1, 2.2, 2.4 and Corollary 2.3. |
| `README.md` | This file. |

Everything in this folder is self-contained. The single external dependency is
**Mathlib**, needed only to elaborate `VonMangoldtSieves.lean`.

## Running the numerical self-check

```sh
python3 von_mangoldt_sieves.py        # default N = 2000
python3 von_mangoldt_sieves.py 50000  # any table bound
```

The script

1. runs the prime-power marking sieve (Algorithm A) and the integer divisor-sum
   sieve (Algorithm B′) and compares their exact outputs;
2. checks the exact divisor identity `∏_{d|n} exp Λ(d) = n` for every `n ≤ N`, in
   integer arithmetic (no floating point in the decision);
3. compares the real divisor-sum sieve (Algorithm B) and the Möbius-convolution
   sieve (Algorithm C) with the exact table;
4. prints `ψ(10^k)` for `k ≤ 6` and checks `exp ψ(10) = lcm(1,…,10)` and
   `exp ψ(20) = lcm(1,…,20)`.

It exits with status `0` if and only if every check passes.

## Building the Lean companion

`VonMangoldtSieves.lean` imports only Mathlib. Inside any Lean 4 project that
provides Mathlib (for example via `lakefile.toml` depending on `mathlib`):

```sh
lake env lean VonMangoldtSieves.lean
```

The file defines, under the namespace `VonMangoldtSieves`:

* `support_ne_zero_iff` — `Λ n ≠ 0 ↔ IsPrimePow n` (Proposition 2.1);
* `apply_prime_pow` — `Λ (p ^ k) = log p` for `p` prime, `k ≠ 0` (Proposition 2.1);
* `divisor_identity` — `∑_{d | n} Λ d = log n` (Proposition 2.2);
* `moebius_convolution` — `Λ = μ * log` (Corollary 2.3);
* `not_additive` — witness `6 = 2 · 3` (Proposition 2.4);
* `not_multiplicative` — witness `4 = 2 · 2` (Proposition 2.4);
* `le_log` — `Λ n ≤ log n` (Proposition 2.4).

Propositions 2.5–2.8 (the additive sibling `log rad`, Chebyshev's `ψ` and `θ`,
the lcm identity, and the Dirichlet series) are proved in the paper; the lcm
identity and the divisor identity are also verified numerically by
`von_mangoldt_sieves.py`.
