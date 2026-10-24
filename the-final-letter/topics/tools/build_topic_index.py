#!/usr/bin/env python3
"""Generate the-final-letter/topics/index.html from the topic READMEs."""
from __future__ import annotations
import html
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
REQUIRED = [
    "README.md", "index.html", "python/programme.py",
    "tests/test_programme.py", "lean/Topic.lean", "lean/BUILD.log",
]

# slug: (novelty, current value, potential value, tractability), each 1-5.
# The ratings are editorial judgements about the reconstructed programme, not
# mathematical claims. See the legend in the generated page.
RATINGS = {
    "adelic-transfer-operator": (4, 3, 4, 2),
    "dyadic-sheaf-cohomology": (4, 2, 3, 1),
    "eml-universal-operator": (3, 3, 3, 4),
    "factorisation-theta": (2, 3, 2, 5),
    "finance-trading": (1, 3, 1, 5),
    "frozen-truths": (3, 4, 3, 5),
    "gap-inventory-strengthening": (2, 3, 2, 5),
    "gdst": (4, 3, 4, 2),
    "gdst-twin-series": (4, 3, 4, 3),
    "geometric-dynamical-phase-transitions": (5, 5, 5, 4),
    "geometric-reformulation": (4, 3, 4, 2),
    "ghd-correlation-kernel": (4, 3, 4, 3),
    "greedy-harmonic-decomposition": (4, 4, 4, 5),
    "greedy-harmonic-hilbert-polya": (4, 3, 4, 2),
    "greedy-harmonic-sine-parity": (4, 4, 4, 3),
    "greedy-harmonic-transfer-operator": (2, 2, 2, 4),
    "greedy-harmonic-zeta": (3, 2, 3, 3),
    "harmonic-categorical-hilbert-polya": (4, 3, 4, 2),
    "harmonic-geometric-unified-theory": (3, 2, 3, 1),
    "harmonic-sine": (3, 3, 3, 4),
    "harmonic-sine-eta": (2, 3, 2, 4),
    "harmonic-sine-greedy-harmonic-essays": (2, 2, 2, 3),
    "harmonic-sine-transform": (5, 4, 5, 3),
    "hst-programme": (4, 3, 4, 3),
    "iota-helix-function": (3, 2, 3, 2),
    "isabelle-afp": (2, 2, 2, 3),
    "nested-spheres-continuous-cone": (3, 3, 3, 3),
    "padic-stochastic-zeta": (2, 3, 2, 4),
    "periodic-orbits": (4, 2, 4, 2),
    "phase-interference": (3, 2, 3, 3),
    "prime-spectrum-tensor": (4, 4, 4, 3),
    "proof-99-global-harmonic-framework": (3, 2, 3, 2),
    "qefe": (5, 3, 5, 2),
    "qefe-research-notes": (3, 2, 3, 3),
    "quaternion-cosine": (3, 2, 3, 4),
    "research-programme-iii": (4, 2, 4, 2),
    "rh-mtc-padic": (4, 2, 4, 2),
    "riemann-helix": (3, 3, 3, 3),
    "self-adjoint-ccm": (5, 3, 5, 1),
    "sinc-sine-kernel-moments": (2, 3, 2, 4),
    "theorems-paper-series": (3, 2, 3, 2),
    "topological-zeta": (5, 3, 5, 1),
    "transfer-operator-proof": (3, 2, 3, 2),
    "yakaboylu-notes": (2, 2, 2, 3),
}

SCORE_WORDS = {5: "Very high", 4: "High", 3: "Moderate", 2: "Limited", 1: "Low"}


def title_for(topic: Path) -> str:
    readme = topic / "README.md"
    if readme.exists():
        for line in readme.read_text(encoding="utf-8").splitlines():
            if line.startswith("# "):
                return line[2:].strip()
    return topic.name.replace("-", " ").title()


def status_for(topic: Path) -> str:
    missing = [f for f in REQUIRED if not (topic / f).exists()]
    return "complete" if not missing else f"in progress ({len(REQUIRED)-len(missing)}/{len(REQUIRED)})"


def score(v: int, label: str) -> str:
    return (
        f'<td class="scorecell"><span class="score s{v}" '
        f'title="{html.escape(label)}: {SCORE_WORDS[v]}">{v}</span></td>'
    )


rows = []
for topic in sorted(p for p in ROOT.iterdir() if p.is_dir() and p.name != "tools"):
    if topic.name not in RATINGS:
        raise SystemExit(f"missing rating for {topic.name}")
    rows.append((topic.name, title_for(topic), status_for(topic), *RATINGS[topic.name]))

table = "\n".join(
    "<tr>"
    f'<td>{html.escape(name)}</td>'
    f'<td><a href="./{html.escape(name)}/index.html">{html.escape(title)}</a></td>'
    f'<td>{html.escape(status)}</td>'
    + score(novelty, "Novelty")
    + score(current, "Current Value")
    + score(potential, "Potential Value")
    + score(tractability, "Tractability")
    + "</tr>"
    for name, title, status, novelty, current, potential, tractability in rows
)

html_text = f'''<!DOCTYPE html>
<html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1">
<title>Research topics — reconstructed programmes</title>
<style>
body{{font-family:Georgia,serif;max-width:1240px;margin:2.2rem auto;padding:0 1.3rem;line-height:1.6;color:#1a202c;background:#fcfcfb}}
h1{{font-size:2rem;margin-bottom:.2rem}}h2{{margin-top:2.2rem;border-bottom:1px solid #d8d8d8;padding-bottom:.25rem}}
a{{color:#1a5fb4;text-decoration:none}}a:hover{{text-decoration:underline}}
.sub{{color:#555;font-style:italic}}code{{background:#f1f3f5;padding:.08rem .22rem;border-radius:3px}}
.tablewrap{{overflow-x:auto}}
table{{border-collapse:collapse;width:100%;margin:1rem 0;font-size:.92rem;min-width:900px}}
th,td{{border:1px solid #d8d8d8;padding:.4rem .5rem;text-align:left;vertical-align:top}}
th{{background:#f3f5f7}}.top{{background:#f3f5f7;border:1px solid #dde3ea;padding:1rem 1.2rem;border-radius:8px}}
.legend{{background:#fbfbfa;border:1px solid #e3e3e0;padding:.8rem 1rem;border-radius:8px;font-size:.92rem;margin:1rem 0}}
.legend ul{{margin:.35rem 0 0 1.1rem;padding:0}}.legend li{{margin:.15rem 0}}
.score{{display:inline-block;min-width:1.55rem;text-align:center;font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",sans-serif;font-weight:700;font-size:.78rem;border-radius:999px;padding:.05rem .3rem}}
.s5{{background:#d8efdf;color:#155d2c}}.s4{{background:#e8f3ea;color:#2c6b3f}}
.s3{{background:#fff3d6;color:#715412}}.s2{{background:#fbe9e7;color:#843a32}}
.s1{{background:#eef0f2;color:#555}}
td.scorecell{{text-align:center;white-space:nowrap}}
</style></head><body>
<h1>Research topics</h1>
<p class="sub">Reconstructed programmes: README, index, sympy tests, Lean core</p>
<div class="top"><p>Every folder follows the <a href="PROGRAMME-STANDARD.md">programme standard</a>. A topic marked <strong>complete</strong> has a README, index.html, sympy computation layer, pytest suite, and a compiling Lean core. Source claims and open conjectures are recorded as such, not proved.</p></div>
<div class="legend"><strong>Rating key (1–5).</strong> These are editorial judgements about the reconstructed programme, not mathematical claims.
<ul>
<li><strong>Novelty</strong> — 5: a genuinely new mechanism; 3: known ideas in a new arrangement; 1: standard or expository.</li>
<li><strong>Current Value</strong> — 5: reusable proved core and tests now; 3: a useful audit or finite core; 1: archive pointer.</li>
<li><strong>Potential Value</strong> — 5: could move a recognised wall; 3: a useful technical advance; 1: little mathematical upside.</li>
<li><strong>Tractability</strong> — 5: finite or computational, near-term; 3: substantial but feasible; 1: deep, blocked, or dependent on an open conjecture.</li>
</ul></div>
<h2>Topics</h2>
<div class="tablewrap"><table><thead><tr><th>Folder</th><th>Programme</th><th>Status</th><th>Novelty</th><th>Current Value</th><th>Potential Value</th><th>Tractability</th></tr></thead><tbody>
{table}
</tbody></table></div>
<p><a href="STATUS.md">Reconstruction status ledger</a> · <a href="PROGRAMME-STANDARD.md">Programme standard</a> · <a href="../scraps.html">Scraps inventory</a> · <a href="../index.html">The Final Letter</a> · <a href="README.md">README index</a></p>
</body></html>
'''
(ROOT / "index.html").write_text(html_text, encoding="utf-8")
print(f"wrote {ROOT/'index.html'} with {len(rows)} topics and four rating columns")
