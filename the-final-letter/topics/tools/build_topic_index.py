#!/usr/bin/env python3
"""Generate the-final-letter/topics/index.html from the topic READMEs."""
from __future__ import annotations
import html
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
REQUIRED = [
    "README.md", "index.html", "python/programme.py",
    "tests/test_programme.py", "lean/Topic.lean",
]

# slug: (novelty, current value, potential value, tractability), each 1-5.
# The ratings are editorial judgements about the reconstructed programme, not
# mathematical claims. See the legend in the generated page.
RATINGS = {
    "absolute-polarized-hodge-index-realization": (4, 4, 5, 2),
    "adelic-transfer-operator": (4, 3, 4, 2),
    "dyadic-sheaf-cohomology": (4, 2, 3, 1),
    "eml-universal-operator": (3, 3, 3, 4),
    "euler-maclaurin": (3, 4, 3, 5),
    "factorisation-theta": (2, 3, 2, 5),
    "finite-window-zeros": (4, 2, 4, 3),
    "finite-explicit-formula": (2, 1, 3, 2),
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
    "intersection-form-zeta": (4, 3, 3, 2),
    "isabelle-afp": (2, 2, 2, 3),
    "nested-spheres-continuous-cone": (3, 3, 3, 3),
    "partial-sum-plus-tail": (4, 5, 4, 4),
    "padic-greedy-sine": (3, 2, 2, 4),
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
    "sin-x-over-x": (3, 3, 2, 5),
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
    """Structural status only: required files present, not that the ledger agrees."""
    present = sum(1 for f in REQUIRED if (topic / f).exists())
    return "structural pass" if present == len(REQUIRED) else f"non-standard layout ({present}/{len(REQUIRED)} required paths)"


def link_for(topic: Path) -> str:
    """Browser target: the dossier index when present, otherwise the README."""
    target = "index.html" if (topic / "index.html").exists() else "README.md"
    return f"./{topic.name}/{target}"


def score(v: int, label: str) -> str:
    return (
        f'<td class="scorecell" data-sort="{v}"><span class="score s{v}" '
        f'title="{html.escape(label)}: {SCORE_WORDS[v]}">{v}</span></td>'
    )


def fmt_num(x: float) -> str:
    """Compact display for derived numeric columns; full precision stays in data-sort."""
    return str(int(x)) if float(x).is_integer() else f"{x:.2f}".rstrip("0").rstrip(".")


rows = []
for topic in sorted(
        p for p in ROOT.iterdir()
        if p.is_dir() and p.name != "tools" and not p.name.startswith(".")
    ):
    if topic.name not in RATINGS:
        raise SystemExit(f"missing rating for {topic.name}")
    rows.append((topic.name, title_for(topic), status_for(topic), link_for(topic), *RATINGS[topic.name]))

table = "\n".join(
    f'<tr data-idx="{idx}">'
    f'<td>{html.escape(name)}</td>'
    f'<td><a href="{link}">{html.escape(title)}</a></td>'
    f'<td>{html.escape(status)}</td>'
    + score(novelty, "Novelty")
    + score(current, "Current Value")
    + score(potential, "Potential Value")
    + f'<td class="numcell" data-sort="{potential - current}">{potential - current}</td>'
    + score(tractability, "Tractability")
    + f'<td class="numcell" data-sort="{novelty * (potential - current) * (tractability - 2.5) * 2:.6f}">'
      f'{fmt_num(novelty * (potential - current) * (tractability - 2.5) * 2)}</td>'
    + "</tr>"
    for idx, (name, title, status, link, novelty, current, potential, tractability) in enumerate(rows)
)

SORT_SCRIPT = """<script>
(function () {
  var table = document.querySelector('table');
  if (!table || !table.tBodies.length || !table.tHead) return;
  var tbody = table.tBodies[0];
  var headers = Array.prototype.slice.call(table.tHead.rows[0].cells);
  var active = -1, ascending = true;

  function value(row, i) {
    var cell = row.cells[i];
    return cell.dataset.sort !== undefined ? cell.dataset.sort : cell.textContent.trim();
  }

  function compare(a, b, i) {
    var av = value(a, i), bv = value(b, i);
    if (headers[i].dataset.type === 'num') {
      var x = parseFloat(av), y = parseFloat(bv);
      if (isNaN(x)) x = -Infinity;
      if (isNaN(y)) y = -Infinity;
      return x - y;
    }
    return av.localeCompare(bv, undefined, {numeric: true, sensitivity: 'base'});
  }

  function sortBy(i) {
    var rows = Array.prototype.slice.call(tbody.rows);
    rows.sort(function (a, b) {
      return compare(a, b, i) * (ascending ? 1 : -1) ||
        (parseInt(a.dataset.idx, 10) - parseInt(b.dataset.idx, 10));
    });
    rows.forEach(function (r) { tbody.appendChild(r); });
    headers.forEach(function (h, j) {
      if (j === i) h.setAttribute('aria-sort', ascending ? 'ascending' : 'descending');
      else h.removeAttribute('aria-sort');
    });
  }

  function activate(i) {
    if (active === i) ascending = !ascending;
    else { active = i; ascending = true; }
    sortBy(i);
  }

  headers.forEach(function (th, i) {
    th.classList.add('sortable');
    th.setAttribute('tabindex', '0');
    th.setAttribute('title', 'Click to sort');
    th.addEventListener('click', function () { activate(i); });
    th.addEventListener('keydown', function (e) {
      if (e.key === 'Enter' || e.key === ' ') {
        e.preventDefault();
        activate(i);
      }
    });
  });
})();
</script>"""

html_text = f'''<!DOCTYPE html>
<html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1">
<title>Research topics — reconstructed programmes</title>
<style>
body{{font-family:Georgia,serif;max-width:1240px;margin:2.2rem auto;padding:0 1.3rem;line-height:1.6;color:#1a202c;background:#fcfcfb}}
h1{{font-size:2rem;margin-bottom:.2rem}}h2{{margin-top:2.2rem;border-bottom:1px solid #d8d8d8;padding-bottom:.25rem}}
a{{color:#1a5fb4;text-decoration:none}}a:hover{{text-decoration:underline}}
.sub{{color:#555;font-style:italic}}code{{background:#f1f3f5;padding:.08rem .22rem;border-radius:3px}}
.tablewrap{{overflow-x:auto}}
table{{border-collapse:collapse;width:100%;margin:1rem 0;font-size:.92rem;min-width:1080px}}
th,td{{border:1px solid #d8d8d8;padding:.4rem .5rem;text-align:left;vertical-align:top}}
th{{background:#f3f5f7}}.top{{background:#f3f5f7;border:1px solid #dde3ea;padding:1rem 1.2rem;border-radius:8px}}
th.sortable{{cursor:pointer;user-select:none;white-space:nowrap}}
th.sortable:hover{{background:#e8edf2}}
th.sortable:focus-visible{{outline:2px solid #1a5fb4;outline-offset:-2px}}
th.sortable::after{{content:" \\2195";color:#9aa4ad;font-size:.72rem}}
th[aria-sort="ascending"]::after{{content:" \\25B2";color:#1a5fb4}}
th[aria-sort="descending"]::after{{content:" \\25BC";color:#1a5fb4}}
td.numcell{{text-align:right;font-variant-numeric:tabular-nums;white-space:nowrap}}
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
<div class="top"><p>Every folder is assessed against the <a href="PROGRAMME-STANDARD.md">programme standard</a>. A topic marked <strong>structural pass</strong> has the required README, index.html, sympy computation layer, pytest suite, and Lean core. A topic marked <strong>non-standard layout</strong> is missing one or more of those required paths (the count gives how many of the five are present); its programme link points to its README where no browser index exists yet. That is a layout finding only, not a judgement that the dossier is thin or unverified. The status certifies the file layout and the audit, not that the ledger, tests, or Lean statements agree. Source claims and open conjectures are recorded as such, not proved.</p><p>The table includes the three programme objectives: the Riemann wall (<code>geometric-dynamical-phase-transitions</code>), the parity wall (<code>greedy-harmonic-sine-parity</code>), and Objective III, certified partial-sum-plus-tail evaluation (<code>partial-sum-plus-tail</code>).</p></div>
<div class="legend"><strong>Rating key (1–5).</strong> These are editorial judgements about the reconstructed programme, not mathematical claims.
<ul>
<li><strong>Novelty</strong> — 5: a genuinely new mechanism; 3: known ideas in a new arrangement; 1: standard or expository.</li>
<li><strong>Current Value</strong> — 5: reusable proved core and tests now; 3: a useful audit or finite core; 1: archive pointer.</li>
<li><strong>Potential Value</strong> — 5: could move a recognised wall; 3: a useful technical advance; 1: little mathematical upside.</li>
<li><strong>Tractability</strong> — 5: finite or computational, near-term; 3: substantial but feasible; 1: deep, blocked, or dependent on an open conjecture.</li>
<li><strong>To Do</strong> — derived: Potential Value − Current Value.</li>
<li><strong>Priority</strong> — derived: Novelty × To Do × (Tractability − 2.5) × 2. A negative value means low tractability outweighs the remaining work.</li>
</ul></div>
<h2>Topics</h2>
<p class="sub">Click any column header to sort; click again to reverse.</p>
<div class="tablewrap"><table><thead><tr><th data-type="text">Folder</th><th data-type="text">Programme</th><th data-type="text">Status</th><th data-type="num">Novelty</th><th data-type="num">Current Value</th><th data-type="num">Potential Value</th><th data-type="num">To Do</th><th data-type="num">Tractability</th><th data-type="num">Priority</th></tr></thead><tbody>
{table}
</tbody></table></div>
<p><a href="STATUS.md">Reconstruction status ledger</a> · <a href="PROGRAMME-STANDARD.md">Programme standard</a> · <a href="../scraps.html">Scraps inventory</a> · <a href="../index.html">The Final Letter</a> · <a href="README.md">README index</a></p>
{SORT_SCRIPT}
</body></html>
'''
(ROOT / "index.html").write_text(html_text, encoding="utf-8")
print(f"wrote {ROOT/'index.html'} with {len(rows)} topics, nine columns and sortable headers")
