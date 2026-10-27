# Research-programme standard

Every topic folder follows this standard. The standard exists so that a topic can be reconstructed honestly without turning an archived claim into a theorem.

## Required files

```
<topic>/
  README.md              programme dossier and theorem ledger
  index.html             browser-readable version of the dossier
  python/
    __init__.py
    programme.py         sympy/exact computation layer
  tests/
    test_programme.py    pytest unit tests
  lean/
    README.md            what is and is not formalised
    Topic.lean           the proved formal core
    check.sh             wrapper around ../../tools/check-lean.sh
```

`lean/BUILD.log` is written by `check.sh` as a local build artefact. It is not
required in the tree and is ignored by Git.

The Lean file must contain **no `sorry`, no `axiom`, and no `admit`**. The Python tests must pass with `python3 -m pytest`.

## The theorem ledger

Each README and index.html contains a table with four kinds of item:

| Kind | Meaning | Must be proved? |
|---|---|---|
| **Theorem** | A statement in this reconstruction's formal core. | Yes, in `lean/Topic.lean`. |
| **Computation** | An exact or high-precision calculation. | Yes, by `tests/test_programme.py`. |
| **Source claim** | A statement asserted by the archived source. | No; record it with its archived status. |
| **Open / conjecture** | A precise unresolved statement. | No; record it as open. |

“All theorems are proved” means: every row of the ledger marked **Theorem** has a corresponding Lean declaration, and every row marked **Computation** has a test. Source claims and open conjectures are not theorems of the reconstruction.

## Honesty rules

1. Do not upgrade a source claim to a theorem. Use the archived status: *archived claim*, *superseded*, *withdrawn*, *open*, *speculative*.
2. Do not state the Riemann hypothesis, twin primes, Chowla, Sarnak, or Elliott as proved.
3. If a source claim cannot be formalised in the available time, leave it as a source claim and explain the gap in `lean/README.md`.
4. A theorem whose statement is vacuous, tautological, or unrelated to the source does not count. The formal core should contain the elementary lemmas the programme actually uses.
5. Prefer small, genuine theorems (positivity, monotonicity, finite identities, bounds, symmetry) over a large file of `rfl`.

## Python layer

- Use `sympy` for exact symbolic work and `mpmath` for numerical checks.
- Keep the module importable without side effects.
- Tests must cover every **Computation** row and at least one failure/edge case.
- Use exact rational/trigonometric identities where possible; numerical checks must state their tolerance.

## README / index.html

`README.md` and `index.html` must contain the same programme, not a stub:

- provenance and source links;
- the reconstructed objects and notation;
- the theorem ledger;
- the Python layer and how to run it;
- the Lean layer and what is not formalised;
- open items and known gaps;
- links back to [`scraps.html`](../scraps.html) and [`topics/README.md`](README.md).

`index.html` is self-contained (inline CSS, no build step) and mirrors the README.

## Verification

```
# Python
python3 -m pytest the-final-letter/topics/<topic>/tests -q

# Lean
the-final-letter/topics/<topic>/lean/check.sh
```

A topic passes the **structural audit** when every required file is present and the Lean core contains no `sorry`/`axiom`/`admit`. The index reports this as **structural pass**. It does not certify that the ledger rows, test names and Lean statements agree; that is a separate review, and it is not implied by the status.
