# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repository is

The personal GitHub Pages site of Victor Geere, served from the `master` branch at the custom domain `victorgeere.co.za` (see `CNAME`). It is a static site with **no build step, no framework, no bundler, and no test suite**. Content falls into three categories:

1. **Mathematical research** — HTML papers and essays, largely centred on the Riemann Hypothesis (harmonic sine reconstruction, greedy harmonic decomposition, transfer operators, quantum-Egyptian functional equation).
2. **Finance/trading ebooks and essays** — volatility harvesting, Kelly criterion, Heston model, etc.
3. **Interactive browser visualisations** — Three.js / Plotly demos of complex functions, quaternions, and probability games.

## Commands

```bash
# Serve the site locally (plain Node static server, zero dependencies)
npm start          # runs `node server.js`, listens on port 80
```

`server.js` binds port 80, which requires root; either run it elevated or temporarily change `PORT`. Because pages are self-contained, opening an HTML file directly in a browser also works for most content (CDN scripts require network access).

**Python tools** (`maths-py/`): Streamlit apps for numerical exploration.

```bash
cd maths-py
source .venv/bin/activate      # or create: python -m venv .venv && pip install -r requirements.txt
streamlit run <script>.py      # e.g. cumulative_angles.py, riemann.py
```

**LaTeX** (`maths/latex/`): `proof.tex` is compiled with `latexmk` (artifacts are committed alongside).

There is no lint or test command. Subproject `package.json` files have stub `test` scripts that exit with an error; `eta-term-diffs` has `npm run try` (`node test.js`). CI is CodeQL JavaScript analysis only (`.github/workflows/codeql-analysis.yml`), on push/PR to `master`.

## Deployment

Pushing to `master` publishes immediately via GitHub Pages — there is no staging environment. Everything committed at the repo root is live.

## Architecture

### Self-contained HTML pages

Every essay/paper is a single standalone HTML file that pulls its dependencies from CDNs:

- **MathJax 3** (`cdn.jsdelivr.net/npm/mathjax@3`) for all mathematics. Research papers (e.g. `maths/rh.html`) define an inline `MathJax = { tex: { macros: {...} } }` config block *before* the MathJax script tag, declaring shorthand macros (`\C`, `\R`, `\H`, `\spec`, …). Follow the same pattern when creating new papers.
- **Plotly / Three.js** from CDN for interactive figures.
- **Pyodide** in some papers (e.g. `maths/rh.html`) for in-browser numerical verification of claims.
- Styling is either inline `<style>` with CSS custom properties (research papers: light theme, dark-blue accents) or a shared per-directory stylesheet (`essays/style.css`, root `main.css`).

### Directory layout

- Root pages (`index.html`, `maths.html`, `archive.html`, `rh.html`) share `main.css` and use a "quote card" layout (`.flex-container` > `.quote` blocks with a body fade-in on load).
- `essays/` — self-contained essays sharing `essays/style.css`.
- `ebooks/` — longer-form reference documents, same style as essays.
- `maths/` — research papers, each self-styled. `maths/rh/research/` holds active research programmes as subdirectories (one per approach: `adelic-transfer-operator/`, `self-adjoint-operator/`, `harmonic-sine-transform/`, …) mixing HTML, Markdown notes, and prompts. `maths/theorems/` and `archive/` hold Markdown drafts and older material.
- `maths-py/` — Python/Streamlit numerical companions to the papers.
- Visualisation subprojects (`complex-3d/`, `eta-term-diffs/`, `quaternions/`, `vector-calculus/`, `probability/game/`) each have a `package.json` (three, mathjs, dat.gui), **but the libraries are vendored under each project's `lib/` directory and loaded directly by the browser** — `npm install` is not needed to run them. Shared helper modules (`colors.js`, `mathtools.js`, `plotutils.js`, `zeta.js`, `primes.js`) are copied per-project rather than shared. `quaternions/docs/README.md` documents that project's module layout.

### README.md is the site index

`README.md` is a manually maintained catalogue of every page (file, title, description, grouped by section). When adding or renaming a page, update the corresponding README table. Note that a few README entries reference stale paths (e.g. `game/` is actually `probability/game/`), so verify a path exists before relying on the index.

## Conventions

- British spelling throughout ("visualisation", "colour", "factorisation") — in prose, file names, and titles.
- New maths papers follow the existing versioning idiom: successive revisions as sibling files (`...-v2.html`, `...-v3.html`) rather than overwriting, with older material moved to `archive/`.
- Papers about the Riemann Hypothesis are exploratory/speculative research documents; several deliberately track their own open gaps and proof status — preserve that framing when editing rather than upgrading claims.
