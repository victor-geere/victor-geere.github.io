# Evidence layout

This folder is self-contained. Every link in its own documents is relative to
the file that contains it, and resolves to a file inside `the-final-letter/`.
The site's CDN scripts (MathJax, Plotly, Three.js) remain external by design;
nothing else is fetched from outside the folder.

The evidence the letter cites was imported from the repository root and the
research repository on 24 October 2026. The imports are snapshots: they are
read-only evidence, not a second copy of the live corpora.

| Directory | Files | Size | Origin | Role |
|---|---:|---:|---|---|
| [`summary/`](summary/README.md) | 208 | 0.99 MB | `summary/` in this repository | Riemann programme annex |
| [`summary-rh/`](summary-rh/README.md) | 68 | 0.52 MB | `summary-rh/` in this repository | parity programme annex |
| [`archive/`](archive/) | 192 | 5.8 MB | `archive/` in this repository | working library of the archived sources cited by the letter |
| [`rh/`](rh/README.md) | 2585 | 47 MB | `~/workspace/rh` | working source snapshot backing `summary-rh/` citations |
| [`categories/`](categories/README.md) | 42 | 0.19 MB | reconstructed in this folder | the thirteen numbered sections, 00–12 |
| [`geometric-dynamical-phase-transitions/`](geometric-dynamical-phase-transitions/README.md) | 17 | 0.52 MB | repository root | canonical paper bundle, already self-contained |
| [`topics/`](topics/README.md) | 661 | 31 MB | reconstructed in this folder | 46 topic dossiers, tests, Lean cores (counts include local build artefacts) |
| [`lean/`](lean/README.md) | 9 | 0.66 MB | reconstructed in this folder | the `FinalLetter` Lean synthesis |
| `main.css`, `favicon.ico` | 2 | 3 KB | repository root | assets referenced by the imported archive pages |

## What is guaranteed

1. **No link leaves the folder.** All internal links are file-relative; the
   old workspace-root convention (`the-final-letter/...`, `../summary/...`) is
   gone.
2. **There are no broken links outside `rh/`.** That covers the numbered
   sections `00`–`12`, `topics/`, `summary/`, `summary-rh/`, the paper bundle,
   the master documents, and the whole of `archive/`. The `rh/` snapshot has
   22 references to files that do not exist upstream; they are enumerated in
   [`rh/README.md`](rh/README.md).
3. **Imported evidence is reachable.** Sources cited by the letter, by
   `summary/`, and by `summary-rh/` were copied and the links re-based.

Run the check with:

```bash
python3 tools/check-links.py
```

The checker fails if a link leaves the folder or if a curated document links to
a missing file. It reports, without failing, the 22 dead references inside the
`rh/` source snapshot.

## What is a snapshot, not a curated document

- **`archive/`** is a working library, not a frozen snapshot. It contains the
  archived files the letter cites plus the files they need. The old library
  index pages (notably `archive/maths/index.html` and the GHD continuation
  pages) linked to files that had since moved into `archive/maths/rh/research/`
  and `archive/qefe/`. Those links were repaired, not preserved: the targets
  were copied to their canonical locations and the links re-pointed. All
  archive links now resolve. One large duplicate, the 9.6 MB
  `talagrand_bounds_stochastic_processes.pdf`, is deliberately not vendored;
  the repository-root `archive/ebooks/` copy remains canonical.
- **`rh/`** is a working snapshot of `~/workspace/rh`: the files reachable
  from `summary-rh/`, at their canonical paths. Its links were repaired the
  same way as `archive/` (import the upstream target, re-point flattened
  notes). Twenty-two references remain and cannot be repaired, because the
  target is absent from the research repository itself; they are listed in
  [`rh/README.md`](rh/README.md).
- The dossier
  [`topics/greedy-harmonic-transfer-operator`](topics/greedy-harmonic-transfer-operator/README.md)
  cites an archived empty directory. An empty directory cannot be represented
  in git, so the path is given as code rather than as a link.

## Adding or moving evidence

1. Put the file in the nearest evidence directory, preserving the source's
   relative structure where practical.
2. Link to it relative to the file that contains the link (for example
   `../archive/maths/rh.html`, not `../../archive/maths/rh.html`).
3. Run `python3 tools/check-links.py` before committing.
4. If the file comes from a live corpus, record its source in this table.

[Back to README](README.md) · [Master TOC](TABLE-OF-CONTENTS.md)
