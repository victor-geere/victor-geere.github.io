# publish/010 — Generalisations and attempts: character weights, shift-2, angle parity

Tenth published edition. This folder packages **item §10 of `research/truths.md`**: the
three generalisation attempts made after OP-5/OP-6 — the character-weighted limit law
(`007`), the automorphic/spectral attempt at the shift-2 core (`008`), and the angle /
`Ω`-sign analysis (`009`) — each with its Lean development and its verdict.

## What the item is

The three attempts share a shape: take the machinery that worked for the programme's
internal problem, replace the alphabet (by a Dirichlet character, by a spectral object,
or by an angle twist), and see how much survives. The Lean layer records what *does*
survive; the verdicts record what does not.

**`007` — character-weighted limit law.**

* `Φ_c(p,n) → F_r(e^{−p/n})` with `F_r(x) = f_r(x)/(1 − x^q)` (proved in Lean:
  `hasSum_F_of_periodic`, `F_eq_fblock`).
* **Leading equation:** `x = 1/√2` for even `r`, `x = (√5−1)/2` for odd `r`.
* **No threshold for `χ₃`, `χ₄`:** `F_r < 1` on `[0,1)` for all residues.
* **Verdict (paper):** the OP-5 second-order expansion **survives** for character sums,
  but the leading equation **fails** for `χ₃` and `χ₄` — 29.7 % of 4537 `(χ, r)` pairs
  have a root.

**`008` — the shift-2 split and the spectral attempt.**

* `S(x,2) = S(⌊x/2⌋,1) + C(⌊(x+1)/2⌋)` with `C(K) = Σ_{k≤K} λ(4k²−1)` (proved).
* λ on the polynomial core: `liouville_pair`, `poly_identity`, `even_shift` (proved).
* **Verdict (paper):** the automorphic/spectral input **does not** break parity over ℚ —
  `L(s,λ) = ζ(2s)/ζ(s)` has no automorphic object. Parity *is* broken over `𝔽_q[T]` by
  Sawin–Shusterman, but the result does not transfer.

**`009` — angle parity and `Ω`-signs.**

* Sparse-pair bound: `|Σ aₙ(wₙw_{n+2} − 1)| ≤ 2·#{crossings}` (proved).
* Angle twist invisible: the twist changes the correlation by `O(θ(N+2)/c)` (proved).
* **Verdict (paper):** a sign either preserves the pair cancellation (uninformative) or
  destroys it (useless). **The parity barrier stands.**

## Contents

| Path | What it is |
|---|---|
| [`TRUTHS.md`](TRUTHS.md) | **The item**: the §10 ledger from `research/truths.md`, links re-pointed into this folder. |
| [`Op57/`](Op57), [`Op57.lean`](Op57.lean) | `007`'s Lean development: blocks, the leading law, the obstruction. |
| [`Op58/`](Op58), [`Op58.lean`](Op58.lean) | `008`'s Lean development: the shift-2 split and the polynomial core. |
| [`Op59/`](Op59), [`Op59.lean`](Op59.lean) | `009`'s Lean development: the sparse-pair bound and the angle twist. |
| [`check.sh`](check.sh) | Builds all three developments, in dependency order (11 files). |
| [`lean-Op57-README.md`](lean-Op57-README.md), [`lean-Op58-README.md`](lean-Op58-README.md), [`lean-Op59-README.md`](lean-Op59-README.md) | Each development's own module guide. |
| [`round-007-README.md`](round-007-README.md), [`round-007-handoff.md`](round-007-handoff.md) | `007`'s round summary and handoff. |
| [`round-008-README.md`](round-008-README.md), [`round-008-handoff.md`](round-008-handoff.md) | `008`'s. |
| [`round-009-README.md`](round-009-README.md), [`round-009-handoff.md`](round-009-handoff.md) | `009`'s. |
| [`notes/007/`](notes/007), [`notes/008/`](notes/008), [`notes/009/`](notes/009) | The substantive notes: the generalisation attempt, the automorphic/spectral attempt, and the angle-parity/`Ω`-sign analysis. |
| [`verify/007/`](verify/007), [`verify/008/`](verify/008), [`verify/009/`](verify/009) | The numerical verification scripts for each round. |

## What is proved, what is refuted, what is open

* **Proved in Lean** — the character-weighted limit law and the two parity leading
  equations; `χ₃`/`χ₄` have no leading threshold; the shift-2 split and the polynomial
  core identities; the sparse-pair bound; the angle-twist invisibility.
* **Refuted on paper** — the leading equation for `χ₃`, `χ₄` (29.7 % of `(χ,r)` pairs
  have a root); the hope that the automorphic/spectral input breaks parity over ℚ; the
  hope that an angle sign helps.
* **Open** — none of the three attempts produced a new open problem; their function is to
  **close off** routes. The programme's parity barrier is unchanged by all three, and its
  live open questions are indexed in `research/open.md`.

## Running the checks

```sh
./check.sh --all                  # Lean 4 + Mathlib, 11 files, exits 0 (~2 min)
python3 verify/007/01_twisted_threshold.py
python3 verify/008/03_function_field.py
python3 verify/009/01_angle_parity.py
```

The `verify/NNN/` scripts are numbered in the order the rounds ran them; each prints its
own comparison and exits non-zero only on a genuine mismatch. See
`publish/002-greedy-digit-word/README.md` for the `LEAN_PREFIX` convention.

## Dependencies

Everything needed is in this folder. The only external dependencies are **Mathlib**
(Lean) and **NumPy/mpmath** (the verification scripts).

## Provenance

Produced in the programme's rounds `007`, `008` and `009`; see `research/truths.md` §10.
The three rounds' `index.html` pages are **not** included — they are rendered views of
the corresponding `round-NNN-README.md`, which are here. Sources are otherwise
reproduced unmodified except that markdown links have been re-pointed into this folder.
