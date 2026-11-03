#!/usr/bin/env python3
"""Build a D3 graph linking Lean proofs and lemmas to known conjectures.

Every theorem/lemma in index-lean.md becomes a node. A curated catalogue of
literature conjectures supplies keyword, topic and concept matches. Edges are
*candidate relevance* only: they record which words or topics triggered the
match, not that the Lean declaration proves or resolves the conjecture.
"""
from __future__ import annotations

import json
import re
from collections import Counter, defaultdict
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
INDEX = ROOT / "index-lean.md"
OUT = ROOT / "lean-conjecture-graph.html"

ROW_RE = re.compile(
    r"^\s*\|\s+\[(\d+)\]\(([^)#]+)#L\d+\)\s*\|\s*(theorem|lemma)\s*\|\s*"
    r"`([^`]+)`\s*\|\s*(\$[^$]*\$)\s*\|\s*$",
    re.MULTILINE,
)

# Catalogue. `weight` is the score for a keyword hit; `topics` adds a prior for
# a whole programme folder. The graph only keeps matches at or above MIN_SCORE.
CONJECTURES = [
    {
        "id": "rh",
        "name": "Riemann Hypothesis",
        "short": "Every non-trivial zero of ζ has real part 1/2.",
        "url": "https://en.wikipedia.org/wiki/Riemann_hypothesis",
        "color": "#2563eb",
        "weight": 3,
        "keywords": [
            "riemann", "zeta", "critical line", "critical strip", "explicit formula",
            "completedzeta", "riemannzeta", "nontrivial zero", "non-trivial zero",
            "zero-free", "zero free", "off-line", "xi function", "mertens",
        ],
        "topics": {
            "absolute-polarized-hodge-index-realization": 1,
            "intersection-form-zeta": 1,
            "finite-window-zeros": 1,
            "geometric-dynamical-phase-transitions": 1,
            "partial-sum-plus-tail": 1,
            "adelic-transfer-operator": 1,
            "prime-spectrum-tensor": 1,
            "self-adjoint-ccm": 1,
            "topological-zeta": 1,
        },
    },
    {
        "id": "grh",
        "name": "Generalized Riemann Hypothesis",
        "short": "RH for Dirichlet L-functions and other global L-functions.",
        "url": "https://en.wikipedia.org/wiki/Generalized_Riemann_hypothesis",
        "color": "#0ea5e9",
        "weight": 3,
        "keywords": [
            "dirichlet character", "dirichlet l", "l-series", "lseries",
            "generalized riemann", "hecke character",
        ],
        "topics": {"padic-stochastic-zeta": 1, "prime-spectrum-tensor": 1},
    },
    {
        "id": "lindelof",
        "name": "Lindelöf Hypothesis",
        "short": "ζ(1/2 + it) grows slower than any power of t.",
        "url": "https://en.wikipedia.org/wiki/Lindel%C3%B6f_hypothesis",
        "color": "#14b8a6",
        "weight": 3,
        "keywords": ["lindelof", "lindelöf", "subconvex", "subconvexity", "growth exponent"],
        "topics": {},
    },
    {
        "id": "twin",
        "name": "Twin Prime Conjecture",
        "short": "Infinitely many primes p with p+2 also prime.",
        "url": "https://en.wikipedia.org/wiki/Twin_prime",
        "color": "#f59e0b",
        "weight": 4,
        "keywords": ["twin prime", "twin-prime", "prime pair", "twin"],
        "topics": {"greedy-harmonic-sine-parity": 3, "gdst-twin-series": 2},
    },
    {
        "id": "goldbach",
        "name": "Goldbach Conjecture",
        "short": "Every even integer greater than 2 is the sum of two primes.",
        "url": "https://en.wikipedia.org/wiki/Goldbach%27s_conjecture",
        "color": "#f97316",
        "weight": 4,
        "keywords": ["goldbach"],
        "topics": {},
    },
    {
        "id": "hl",
        "name": "Hardy–Littlewood k-tuple Conjecture",
        "short": "Asymptotic count for admissible prime tuples.",
        "url": "https://en.wikipedia.org/wiki/First_Hardy%E2%80%93Littlewood_conjecture",
        "color": "#eab308",
        "weight": 3,
        "keywords": ["hardy", "littlewood", "k-tuple", "prime tuple", "prime constellation"],
        "topics": {"greedy-harmonic-sine-parity": 2},
    },
    {
        "id": "eh",
        "name": "Elliott–Halberstam Conjecture",
        "short": "A level-of-distribution statement for primes in APs.",
        "url": "https://en.wikipedia.org/wiki/Elliott%E2%80%93Halberstam_conjecture",
        "color": "#d97706",
        "weight": 3,
        "keywords": ["elliott", "halberstam"],
        "topics": {"greedy-harmonic-sine-parity": 2},
    },
    {
        "id": "chowla",
        "name": "Chowla's Conjecture",
        "short": "Cancellation in the Liouville function correlations.",
        "url": "https://arxiv.org/abs/1510.00776",
        "color": "#84cc16",
        "weight": 3,
        "keywords": ["chowla"],
        "topics": {"greedy-harmonic-sine-parity": 2},
    },
    {
        "id": "sarnak",
        "name": "Sarnak's Conjecture",
        "short": "The Möbius function is disjoint from zero-entropy systems.",
        "url": "https://arxiv.org/abs/1510.00776",
        "color": "#22c55e",
        "weight": 3,
        "keywords": ["sarnak"],
        "topics": {"greedy-harmonic-sine-parity": 2},
    },
    {
        "id": "pair",
        "name": "Montgomery Pair-Correlation Conjecture",
        "short": "Normalised zero gaps follow GUE random-matrix statistics.",
        "url": "https://en.wikipedia.org/wiki/Montgomery%27s_pair_correlation_conjecture",
        "color": "#a855f7",
        "weight": 3,
        "keywords": [
            "pair correlation", "montgomery", "gue", "random matrix",
            "spectral statistics", "correlation kernel",
        ],
        "topics": {"ghd-correlation-kernel": 3, "prime-spectrum-tensor": 2},
    },
    {
        "id": "hp",
        "name": "Hilbert–Pólya Conjecture",
        "short": "Zero ordinates are eigenvalues of a self-adjoint operator.",
        "url": "https://en.wikipedia.org/wiki/Hilbert%E2%80%93P%C3%B3lya_conjecture",
        "color": "#ec4899",
        "weight": 2,
        "keywords": [
            "hilbert", "polya", "pólya", "spectral", "self-adjoint", "selfadjoint",
            "hamiltonian", "eigenvalue", "spectrum", "operator",
        ],
        "topics": {
            "self-adjoint-ccm": 2,
            "adelic-transfer-operator": 2,
            "transfer-operator-proof": 2,
            "greedy-harmonic-hilbert-polya": 2,
            "harmonic-categorical-hilbert-polya": 2,
        },
    },
    {
        "id": "weil",
        "name": "Weil Positivity",
        "short": "Positivity of the Weil functional; a criterion for RH.",
        "url": "https://arxiv.org/abs/2006.13771",
        "color": "#ef4444",
        "weight": 3,
        "keywords": [
            "weil", "positivity", "positive definite", "cone positivity",
            "hodge index", "intersection form",
        ],
        "topics": {
            "absolute-polarized-hodge-index-realization": 2,
            "intersection-form-zeta": 2,
            "finite-explicit-formula": 2,
            "topological-zeta": 2,
            "self-adjoint-ccm": 1,
        },
    },
]

DECL_RE = re.compile(
    r"^\s*(?:(?:private|protected|noncomputable|local|scoped|unsafe|partial)\s+)*"
    r"(?:@\[[^\]]*\]\s*)*(theorem|lemma)\s+([^\s(:\{]+)"
)
TOKEN_RE = re.compile(r"[A-Za-z][A-Za-z0-9_'.]*")


def strip_comments(text: str) -> str:
    """Blank out Lean comments and strings, preserving line numbers."""
    out: list[str] = []
    i, n = 0, len(text)
    block = 0
    line = False
    string = False
    while i < n:
        c = text[i]
        nxt = text[i + 1] if i + 1 < n else ""
        if line:
            if c == "\n":
                line = False
                out.append("\n")
            else:
                out.append(" ")
            i += 1
            continue
        if block:
            if c == "/" and nxt == "-":
                block += 1
                out.append("  ")
                i += 2
                continue
            if c == "-" and nxt == "/":
                block -= 1
                out.append("  ")
                i += 2
                continue
            out.append("\n" if c == "\n" else " ")
            i += 1
            continue
        if string:
            out.append("\n" if c == "\n" else " ")
            if c == "\\" and i + 1 < n:
                out.append(" ")
                i += 2
                continue
            if c == '"':
                string = False
            i += 1
            continue
        if c == "-" and nxt == "-":
            line = True
            out.append("  ")
            i += 2
            continue
        if c == "/" and nxt == "-":
            block = 1
            out.append("  ")
            i += 2
            continue
        if c == '"':
            string = True
            out.append(" ")
            i += 1
            continue
        out.append(c)
        i += 1
    return "".join(out)


def declaration_bodies() -> dict[tuple[str, int, str], str]:
    """Return (relative file, line, name) -> declaration text (statement + body)."""
    bodies: dict[tuple[str, int, str], str] = {}
    for path in ROOT.rglob("*.lean"):
        if "target" in path.parts or ".lake" in path.parts:
            continue
        rel = path.relative_to(ROOT).as_posix()
        lines = strip_comments(path.read_text(encoding="utf-8")).split("\n")
        declarations = []
        for i, line in enumerate(lines):
            match = DECL_RE.match(line)
            if match:
                declarations.append((i, match.group(2)))
        for index, (start, name) in enumerate(declarations):
            end = declarations[index + 1][0] if index + 1 < len(declarations) else len(lines)
            bodies[(rel, start + 1, name)] = "\n".join(lines[start:end])
    return bodies


MIN_SCORE = 2
MAX_PER_PROOF = 4

rows = ROW_RE.findall(INDEX.read_text(encoding="utf-8"))
if not rows:
    raise SystemExit(f"no rows parsed from {INDEX}")


def normalized(text: str) -> str:
    return re.sub(r"[_-]", " ", text.lower())


nodes: list[dict] = []
links: list[list] = []
conjecture_index: dict[str, int] = {}
conjecture_counts: Counter = Counter()
dominant_counts: Counter = Counter()

for line_text, rel, kind, name, latex in rows:
    topic = rel.split("/", 1)[0]
    text = normalized(name + " " + topic + " " + latex)
    proof_index = len(nodes)
    nodes.append({
        "id": f"p:{rel}:{line_text}:{name}",
        "type": kind,
        "label": name,
        "topic": topic,
        "file": rel,
        "line": int(line_text),
        "url": f"{rel}#L{int(line_text)}",
        "degree": 0,
        "dominant": None,
        "confidence": None,
    })

    scores = []
    for conjecture in CONJECTURES:
        score = 0
        evidence = []
        for keyword in conjecture["keywords"]:
            if keyword in text:
                score += conjecture["weight"]
                evidence.append(keyword)
        topic_weight = conjecture["topics"].get(topic, 0)
        if topic_weight:
            score += topic_weight
            evidence.append("topic:" + topic)
        if score:
            scores.append((score, conjecture, evidence))
    scores.sort(key=lambda item: -item[0])

    chosen = [item for item in scores[:MAX_PER_PROOF] if item[0] >= MIN_SCORE]
    for score, conjecture, evidence in chosen:
        cid = conjecture["id"]
        if cid not in conjecture_index:
            conjecture_index[cid] = len(nodes)
            nodes.append({
                "id": f"j:{cid}",
                "type": "conjecture",
                "label": conjecture["name"],
                "short": conjecture["short"],
                "url": conjecture["url"],
                "color": conjecture["color"],
                "degree": 0,
                "topic": None,
            })
        ci = conjecture_index[cid]
        confidence = "strong" if score >= 6 else ("moderate" if score >= 3 else "contextual")
        links.append([proof_index, ci, score, confidence, ", ".join(evidence)])
        conjecture_counts[cid] += 1
        nodes[ci]["degree"] = conjecture_counts[cid]
        nodes[proof_index]["degree"] += 1
        if nodes[proof_index]["dominant"] is None:
            nodes[proof_index]["dominant"] = cid
            nodes[proof_index]["confidence"] = confidence

for node in nodes:
    if node["type"] in {"theorem", "lemma"} and node["dominant"] is None:
        node["dominant"] = "unlinked"
        dominant_counts["unlinked"] += 1
    elif node["type"] in {"theorem", "lemma"}:
        dominant_counts[node["dominant"]] += 1


conjecture_nodes = [n for n in nodes if n["type"] == "conjecture"]
proof_nodes = [n for n in nodes if n["type"] in {"theorem", "lemma"}]
unlinked = sum(1 for n in proof_nodes if n["dominant"] == "unlinked")

# Dependency links: an unmatched proof is attached to a matched proof whose
# statement or proof body refers to it by name. Resolution prefers the same
# file, then the same programme folder, to avoid cross-file name collisions.
bodies = declaration_bodies()
by_name: dict[str, list[int]] = defaultdict(list)
for i, node in enumerate(nodes):
    if node["type"] in {"theorem", "lemma"}:
        by_name[node["label"]].append(i)

dependencies: list[list] = []
seen_dependencies: set[tuple[int, int]] = set()
for parent_index, parent in enumerate(nodes):
    if parent["type"] not in {"theorem", "lemma"} or parent["dominant"] == "unlinked":
        continue
    body = bodies.get((parent["file"], parent["line"], parent["label"]), "")
    if not body:
        continue
    tokens = set(TOKEN_RE.findall(body))
    # Qualified references (Namespace.foo) also resolve to their final segment.
    tokens |= {token.rsplit(".", 1)[1] for token in tokens if "." in token}
    for token in tokens:
        if token == parent["label"]:
            continue
        candidates = by_name.get(token, [])
        if not candidates:
            continue
        local = [i for i in candidates if nodes[i]["file"] == parent["file"]]
        same_topic = [
            i for i in candidates
            if nodes[i]["file"].split("/", 1)[0] == parent["topic"]
        ]
        for child in (local or same_topic):
            if nodes[child]["dominant"] != "unlinked":
                continue
            key = (child, parent_index)
            if key in seen_dependencies:
                continue
            seen_dependencies.add(key)
            dependencies.append([child, parent_index, token])

linked_unmatched = len({child for child, _, _ in dependencies})

graph = {
    "source": INDEX.name,
    "nodes": nodes,
    "links": links,
    "dependencies": dependencies,
    "conjectures": [
        {
            "id": n["id"].split(":", 2)[1],
            "name": n["label"],
            "short": n["short"],
            "url": n["url"],
            "color": n["color"],
            "count": n["degree"],
        }
        for n in conjecture_nodes
    ],
    "stats": {
        "proofs": len(proof_nodes),
        "conjectures": len(conjecture_nodes),
        "links": len(links),
        "dependencies": len(dependencies),
        "linkedUnmatched": linked_unmatched,
        "unlinked": unlinked,
    },
}
assert all(0 <= a < len(nodes) and 0 <= b < len(nodes) for a, b, *_ in links)

payload = json.dumps(graph, ensure_ascii=False, separators=(",", ":")).replace("</", "<\\/")

html = r"""<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Lean proofs and conjectures — force-directed graph</title>
<style>
  :root {
    --bg: #f7f8fa; --panel: #fff; --ink: #1f2937; --muted: #64748b;
    --line: #dbe2ea; --accent: #1d4ed8;
  }
  * { box-sizing: border-box; }
  html, body { height: 100%; margin: 0; }
  body {
    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
    color: var(--ink); background: var(--bg); overflow: hidden;
  }
  #app { display: grid; grid-template-columns: 280px minmax(0, 1fr) 350px; grid-template-rows: 100vh; }
  aside { background: var(--panel); border-right: 1px solid var(--line); overflow-y: auto; padding: 16px; }
  #details { border-right: 0; border-left: 1px solid var(--line); }
  h1 { font-size: 1rem; margin: 0 0 4px; letter-spacing: -0.01em; }
  h2 { font-size: 0.76rem; text-transform: uppercase; letter-spacing: 0.08em; color: var(--muted); margin: 18px 0 8px; }
  p, li { font-size: 0.81rem; line-height: 1.45; }
  .small { color: var(--muted); font-size: 0.75rem; }
  a { color: var(--accent); text-decoration: none; }
  a:hover { text-decoration: underline; }
  .statgrid { display: grid; grid-template-columns: 1fr 1fr; gap: 6px; margin: 10px 0; }
  .stat { background: #f1f5f9; border-radius: 6px; padding: 6px 8px; }
  .stat b { display: block; font-size: 1rem; }
  .stat span { color: var(--muted); font-size: 0.7rem; }
  label { display: flex; align-items: center; gap: 7px; font-size: 0.8rem; margin: 5px 0; cursor: pointer; }
  input[type="checkbox"] { accent-color: var(--accent); }
  input[type="search"], select {
    width: 100%; font: inherit; font-size: 0.8rem; padding: 6px 8px;
    border: 1px solid var(--line); border-radius: 6px; background: #fff;
  }
  .row { display: flex; gap: 8px; }
  .row > * { flex: 1; }
  button {
    font: inherit; font-size: 0.8rem; padding: 6px 8px; border-radius: 6px;
    border: 1px solid var(--line); background: #fff; cursor: pointer;
  }
  button:hover { background: #f1f5f9; }
  button.primary { background: var(--accent); border-color: var(--accent); color: #fff; }
  #graphwrap { position: relative; min-width: 0; }
  canvas { display: block; width: 100%; height: 100%; cursor: grab; touch-action: none; }
  canvas:active { cursor: grabbing; }
  #legend { position: absolute; left: 14px; bottom: 14px; max-width: 520px; background: rgba(255,255,255,0.95); border: 1px solid var(--line); border-radius: 8px; padding: 8px 10px; font-size: 0.72rem; line-height: 1.55; }
  .dot { display: inline-block; width: 9px; height: 9px; border-radius: 50%; margin-right: 5px; }
  .conjrow { display: flex; align-items: center; gap: 6px; padding: 3px 0; font-size: 0.76rem; }
  .conjrow .name { flex: 1; min-width: 0; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
  .conjrow .count { color: var(--muted); font-variant-numeric: tabular-nums; }
  .conjrow a { color: var(--muted); font-size: 0.72rem; }
  #tooltip {
    position: absolute; pointer-events: none; background: rgba(15,23,42,0.95); color: #fff;
    padding: 6px 8px; border-radius: 6px; font-size: 0.74rem; max-width: 330px;
    opacity: 0; transition: opacity 0.08s; z-index: 5;
  }
  #loading {
    position: absolute; inset: 0; display: flex; align-items: center; justify-content: center;
    background: rgba(247,248,250,0.82); font-size: 0.9rem; color: var(--muted); z-index: 10;
  }
  .pill { display: inline-block; padding: 1px 7px; border-radius: 999px; font-size: 0.66rem; color: #fff; text-transform: uppercase; letter-spacing: 0.04em; }
  .detail-label { font-size: 1.02rem; font-weight: 600; word-break: break-word; margin: 4px 0; }
  .linklist { list-style: none; padding: 0; margin: 8px 0; }
  .linklist li { padding: 4px 0; border-bottom: 1px solid #eef2f6; font-size: 0.75rem; }
  .linklist a { color: var(--accent); }
  code { background: #f1f5f9; border-radius: 3px; padding: 1px 4px; font-size: 0.74rem; }
  .note { background: #eff6ff; border: 1px solid #bfdbfe; border-radius: 6px; padding: 8px; font-size: 0.75rem; color: #1e3a8a; }
  .evidence { color: var(--muted); font-size: 0.72rem; }
  @media (max-width: 1000px) {
    #app { grid-template-columns: 240px minmax(0, 1fr); }
    #details { display: none; }
  }
</style>
</head>
<body>
<div id="app">
  <aside id="controls">
    <h1>Proofs → conjectures</h1>
    <p class="small">Parsed from <a href="index-lean.md"><code>index-lean.md</code></a>. Coloured edges are candidate conjecture relevance from names, topics and LaTeX — not claims that a proof resolves a conjecture. Dashed edges are proof dependencies: an unmatched proof → a matched proof that references it. Drag nodes or use the spacing slider.</p>
    <div class="statgrid">
      <div class="stat"><b>__PROOFS__</b><span>proofs / lemmas</span></div>
      <div class="stat"><b>__CONJECTURES__</b><span>conjectures</span></div>
      <div class="stat"><b>__LINKS__</b><span>candidate links</span></div>
      <div class="stat"><b>__DEPS__</b><span>parent links</span></div>
      <div class="stat"><b>__UNLINKED__</b><span>unmatched proofs</span></div>
      <div class="stat"><b>__LINKED_UNMATCHED__</b><span>unmatched now linked</span></div>
    </div>

    <h2>Catalogue</h2>
    <div id="catalogue"></div>
    <p class="small">Only conjectures with at least one matching proof are drawn. Literature links open externally.</p>

    <h2>Confidence</h2>
    <select id="confidence">
      <option value="2">All matches</option>
      <option value="3">Moderate and strong</option>
      <option value="6">Strong only</option>
    </select>

    <h2>Search</h2>
    <input type="search" id="search" placeholder="Proof or conjecture label…">

    <h2>Spacing</h2>
    <input type="range" id="spacing" min="0.4" max="2.5" step="0.1" value="1" style="width:100%">
    <p class="small" id="spacing-value">1.0× — drag nodes to rearrange</p>

    <h2>Display</h2>
    <label><input type="checkbox" id="show-unlinked" checked> Show unmatched proofs</label>
    <label><input type="checkbox" id="show-dependencies" checked> Show parent links</label>
    <label><input type="checkbox" id="show-labels" checked> Show labels</label>
    <div class="row" style="margin-top:8px">
      <button id="reheat">Reheat</button>
      <button id="reset">Reset</button>
    </div>
    <p class="small" id="visible-count" style="margin-top:10px"></p>
  </aside>

  <main id="graphwrap">
    <canvas id="graph"></canvas>
    <div id="tooltip"></div>
    <div id="legend"></div>
    <div id="loading">Laying out the graph…</div>
  </main>

  <aside id="details">
    <h2>Details</h2>
    <div id="detail-body" class="note">Click a proof or conjecture. Drag to pan, scroll to zoom.</div>
    <h2>How links are inferred</h2>
    <p class="small">A proof is connected to a conjecture when its name, programme folder or LaTeX statement contains a catalogue keyword, or when the whole folder is a strong contextual prior. Each edge records the evidence and a confidence level: strong ≥ 6, moderate 3–5, contextual 2.</p>
    <p class="small">A dashed dependency edge is added when a matched proof's statement or proof body mentions the name of an otherwise unmatched proof, preferring references in the same file or programme folder.</p>
    <p class="small">Unmatched proofs are grey; use the confidence selector to remove weaker suggestions.</p>
  </aside>
</div>

<script src="https://cdn.jsdelivr.net/npm/d3@7"></script>
<script>
const graph = __GRAPH__;
const nodes = graph.nodes.map((d, i) => Object.assign({}, d, {index: i}));
const conjectureLinks = graph.links.map(([source, target, score, confidence, evidence]) => ({source, target, score, confidence, evidence, kind: "conjecture"}));
const dependencyLinks = graph.dependencies.map(([source, target, evidence]) => ({source, target, score: 1, confidence: "dependency", evidence, kind: "dependency"}));
const links = conjectureLinks.concat(dependencyLinks);
const byIndex = new Map(nodes.map(d => [d.index, d]));
const endIndex = v => (typeof v === "object" ? v.index : v);
const conjectureColor = new Map(graph.conjectures.map(c => [c.id, c.color]));
const UNLINKED_COLOR = "#94a3b8";

for (const [i, d] of nodes.entries()) {
  const angle = (i / Math.max(1, nodes.length)) * Math.PI * 2;
  d.x = 820 + Math.cos(angle) * 300;
  d.y = 500 + Math.sin(angle) * 300;
}

const proofToConjectures = new Map();
const conjectureToProofs = new Map();
for (const l of conjectureLinks) {
  if (!proofToConjectures.has(l.source)) proofToConjectures.set(l.source, []);
  proofToConjectures.get(l.source).push(l);
  if (!conjectureToProofs.has(l.target)) conjectureToProofs.set(l.target, []);
  conjectureToProofs.get(l.target).push(l.source);
}
const proofToParents = new Map();
const proofToChildren = new Map();
for (const l of dependencyLinks) {
  if (!proofToParents.has(l.source)) proofToParents.set(l.source, []);
  proofToParents.get(l.source).push({index: l.target, evidence: l.evidence});
  if (!proofToChildren.has(l.target)) proofToChildren.set(l.target, []);
  proofToChildren.get(l.target).push({index: l.source, evidence: l.evidence});
}

const state = {
  conjectures: new Set(graph.conjectures.map(c => c.id)),
  minConfidence: 2,
  search: "",
  labels: true,
  showUnlinked: true,
  showDependencies: true,
  spacing: 1,
  selected: null,
  hovered: null
};

const catalogue = d3.select("#catalogue");
for (const c of graph.conjectures) {
  const row = catalogue.append("div").attr("class", "conjrow");
  row.append("input")
    .attr("type", "checkbox")
    .property("checked", true)
    .on("change", (event) => {
      if (event.target.checked) state.conjectures.add(c.id);
      else state.conjectures.delete(c.id);
      update();
    });
  row.append("span").attr("class", "dot").style("background", c.color);
  row.append("span").attr("class", "name").attr("title", c.short).text(c.name);
  row.append("span").attr("class", "count").text(c.count);
  row.append("a").attr("href", c.url).attr("target", "_blank").attr("rel", "noopener").text("↗");
}

d3.select("#confidence").on("change", (event) => {
  state.minConfidence = +event.target.value;
  update();
});
d3.select("#search").on("input", (event) => {
  state.search = event.target.value.trim().toLowerCase();
  update();
});
d3.select("#show-unlinked").on("change", (event) => { state.showUnlinked = event.target.checked; update(); });
d3.select("#show-dependencies").on("change", (event) => { state.showDependencies = event.target.checked; update(); });
d3.select("#show-labels").on("change", (event) => { state.labels = event.target.checked; draw(); });
d3.select("#spacing").on("input", (event) => {
  state.spacing = +event.target.value;
  d3.select("#spacing-value").text(state.spacing.toFixed(1) + "× — drag nodes to rearrange");
  applySpacing();
});
d3.select("#reheat").on("click", () => simulation.alpha(0.9).restart());
d3.select("#reset").on("click", () => {
  state.conjectures = new Set(graph.conjectures.map(c => c.id));
  state.minConfidence = 2;
  state.search = "";
  state.showUnlinked = true;
  state.showDependencies = true;
  state.spacing = 1;
  state.labels = true;
  state.selected = null;
  d3.selectAll("#catalogue input").property("checked", true);
  d3.select("#confidence").property("value", 2);
  d3.select("#search").property("value", "");
  d3.select("#show-unlinked").property("checked", true);
  d3.select("#show-dependencies").property("checked", true);
  d3.select("#spacing").property("value", 1);
  d3.select("#spacing-value").text("1.0× — drag nodes to rearrange");
  d3.select("#show-labels").property("checked", true);
  applySpacing();
  renderDetails(null);
  update();
  simulation.alpha(0.6).restart();
});

const canvas = document.getElementById("graph");
const ctx = canvas.getContext("2d");
const wrap = document.getElementById("graphwrap");
const tooltip = document.getElementById("tooltip");
const loading = document.getElementById("loading");
let width = 0, height = 0, transform = d3.zoomIdentity;
let visibleCache = {nodes: [], links: []};
let drawCount = 0;
let dragNode = null;
let dragStart = null;
let dragMoved = false;

const zoom = d3.zoom().scaleExtent([0.08, 12]).on("zoom", (event) => { transform = event.transform; draw(); });
d3.select(canvas).call(zoom);

function linkDistance(l) {
  const base = l.kind === "dependency" ? 24 : 40 + 22 / Math.max(1, l.score);
  return base * state.spacing;
}
function linkStrength(l) {
  return l.kind === "dependency" ? 0.9 : 0.25 + Math.min(0.55, l.score / 18);
}
function chargeStrength(d) {
  return (d.type === "conjecture" ? -1500 : -7) * state.spacing;
}
function applySpacing() {
  if (!simulation) return;
  simulation.force("link").distance(linkDistance).strength(linkStrength);
  simulation.force("charge").strength(chargeStrength);
  simulation.alpha(0.5).restart();
}

const simulation = d3.forceSimulation(nodes)
  .force("link", d3.forceLink(links)
    .id(d => d.index)
    .distance(linkDistance)
    .strength(linkStrength))
  .force("charge", d3.forceManyBody()
    .strength(chargeStrength)
    .distanceMax(340))
  .force("center", d3.forceCenter(820, 500))
  .force("collide", d3.forceCollide(d => nodeRadius(d) + (d.type === "conjecture" ? 22 : 1)).iterations(2))
  .alphaDecay(0.03)
  .velocityDecay(0.4)
  .on("tick", ticked);

new ResizeObserver(resize).observe(wrap);

function resize() {
  const rect = wrap.getBoundingClientRect();
  width = Math.max(320, rect.width);
  height = Math.max(320, rect.height);
  const ratio = window.devicePixelRatio || 1;
  canvas.width = Math.round(width * ratio);
  canvas.height = Math.round(height * ratio);
  ctx.setTransform(ratio, 0, 0, ratio, 0, 0);
  simulation.force("center", d3.forceCenter(width / 2, height / 2));
  simulation.alpha(0.25).restart();
  draw();
}

function nodeRadius(d) {
  if (d.type === "conjecture") return Math.min(26, 11 + Math.log2(1 + (d.degree || 1)) * 2.2);
  return 2.3 + Math.min(2.2, Math.log2(1 + (d.degree || 1)) * 0.5);
}

function isProof(d) { return d.type === "theorem" || d.type === "lemma"; }
function matchesSearch(d) { return !state.search || d.label.toLowerCase().includes(state.search); }

function proofVisible(d) {
  const conj = proofToConjectures.get(d.index) || [];
  const visibleConj = conj.filter(l => {
    const target = byIndex.get(endIndex(l.target));
    return target && state.conjectures.has(target.id.split(":", 2)[1]) && l.score >= state.minConfidence;
  });
  const selfMatch = matchesSearch(d);
  const conjMatch = visibleConj.some(l => matchesSearch(byIndex.get(endIndex(l.target))));
  const depMatch = state.showDependencies && [
    ...(proofToParents.get(d.index) || []),
    ...(proofToChildren.get(d.index) || [])
  ].some(link => {
    const other = byIndex.get(link.index);
    return other && matchesSearch(other);
  });
  if (state.search && !selfMatch && !conjMatch && !depMatch) return false;
  if (!state.showUnlinked && visibleConj.length === 0) return false;
  return true;
}

function conjectureVisible(d) {
  const cid = d.id.split(":", 2)[1];
  if (!state.conjectures.has(cid)) return false;
  if (state.search && !matchesSearch(d)) {
    const proofMatches = (conjectureToProofs.get(d.index) || []).some(i => {
      const p = byIndex.get(i);
      return p && matchesSearch(p);
    });
    if (!proofMatches) return false;
  }
  return true;
}

function nodeVisible(d) {
  return isProof(d) ? proofVisible(d) : conjectureVisible(d);
}

function recomputeVisibility() {
  const visible = nodes.filter(nodeVisible);
  const visibleSet = new Set(visible.map(d => d.index));
  const visibleLinks = links.filter(l => {
    const s = typeof l.source === "object" ? l.source.index : l.source;
    const t = typeof l.target === "object" ? l.target.index : l.target;
    return visibleSet.has(s) && visibleSet.has(t) &&
      (l.kind === "dependency" ? state.showDependencies : l.score >= state.minConfidence);
  });
  visibleCache = {nodes: visible, links: visibleLinks};
}

function ticked() {
  draw();
  if (simulation.alpha() < 0.05) {
    loading.style.opacity = "0";
    loading.style.pointerEvents = "none";
    simulation.stop();
  }
}

function draw() {
  if (!width || !height) return;
  ctx.clearRect(0, 0, width, height);
  ctx.save();
  ctx.translate(transform.x, transform.y);
  ctx.scale(transform.k, transform.k);

  const visible = visibleCache.nodes;
  const visibleLinks = visibleCache.links;

  ctx.setLineDash([]);
  for (const l of visibleLinks) {
    if (l.kind === "dependency") continue;
    const target = byIndex.get(typeof l.target === "object" ? l.target.index : l.target);
    const src = byIndex.get(typeof l.source === "object" ? l.source.index : l.source);
    if (!target || !src) continue;
    ctx.strokeStyle = (conjectureColor.get(target.id.split(":", 2)[1]) || "#94a3b8") + "55";
    ctx.lineWidth = (0.35 + Math.min(1.5, l.score / 8)) / Math.max(0.6, transform.k);
    ctx.beginPath();
    ctx.moveTo(src.x, src.y);
    ctx.lineTo(target.x, target.y);
    ctx.stroke();
  }

  ctx.setLineDash([3 / transform.k, 3 / transform.k]);
  ctx.strokeStyle = "rgba(71,85,105,0.62)";
  ctx.lineWidth = 0.8 / Math.max(0.65, transform.k);
  for (const l of visibleLinks) {
    if (l.kind !== "dependency") continue;
    const target = byIndex.get(typeof l.target === "object" ? l.target.index : l.target);
    const src = byIndex.get(typeof l.source === "object" ? l.source.index : l.source);
    if (!target || !src) continue;
    ctx.beginPath();
    ctx.moveTo(src.x, src.y);
    ctx.lineTo(target.x, target.y);
    ctx.stroke();
  }
  ctx.setLineDash([]);

  for (const d of visible) {
    const r = nodeRadius(d);
    ctx.beginPath();
    ctx.arc(d.x, d.y, r, 0, Math.PI * 2);
    if (d.type === "conjecture") {
      ctx.fillStyle = d.color;
      ctx.globalAlpha = 0.95;
      ctx.fill();
      ctx.lineWidth = 2 / transform.k;
      ctx.strokeStyle = "#fff";
      ctx.stroke();
    } else {
      const cid = d.dominant && d.dominant !== "unlinked" ? d.dominant : null;
      ctx.fillStyle = cid ? (conjectureColor.get(cid) || "#2563eb") : UNLINKED_COLOR;
      ctx.globalAlpha = cid ? 0.58 : 0.33;
      ctx.fill();
    }
    ctx.globalAlpha = 1;
    if (state.selected === d.index) {
      ctx.lineWidth = 2 / transform.k;
      ctx.strokeStyle = "#111827";
      ctx.stroke();
    }
  }

  if (state.labels) {
    ctx.font = `${Math.max(9, 11 / transform.k)}px -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif`;
    ctx.textBaseline = "middle";
    ctx.lineJoin = "round";
    const placed = [];
    const [vx0, vy0] = transform.invert([0, 0]);
    const [vx1, vy1] = transform.invert([width, height]);

    function intersects(box) {
      return placed.some(p => !(box.x2 < p.x1 || box.x1 > p.x2 || box.y2 < p.y1 || box.y1 > p.y2));
    }

    for (const d of visible) {
      const isConj = d.type === "conjecture";
      const show = isConj || transform.k > 2.2 ||
        state.selected === d.index || state.hovered === d.index;
      if (!show) continue;
      const r = nodeRadius(d);
      const label = d.label;
      const metrics = ctx.measureText(label);
      let x = d.x + r + 4 / transform.k;
      let y = d.y;
      let align = "left";
      let box;

      if (isConj) {
        const candidates = [
          {x: d.x + r + 5, y: d.y, align: "left"},
          {x: d.x - r - 5, y: d.y, align: "right"},
          {x: d.x, y: d.y - r - 11, align: "center"},
          {x: d.x, y: d.y + r + 13, align: "center"}
        ];
        for (const c of candidates) {
          const half = c.align === "center" ? metrics.width / 2 : 0;
          const left = c.align === "right" ? c.x - metrics.width : c.x - half;
          const right = c.align === "left" ? c.x + metrics.width : c.x + half;
          const candidateBox = {
            x1: left - 2, x2: right + 2, y1: c.y - 8, y2: c.y + 8
          };
          const inside = left >= vx0 && right <= vx1 && c.y >= vy0 && c.y <= vy1;
          if (inside && !intersects(candidateBox)) {
            x = c.x; y = c.y; align = c.align; box = candidateBox; break;
          }
        }
        if (!box) {
          box = {x1: x - 2, x2: x + metrics.width + 2, y1: y - 8, y2: y + 8};
        }
        placed.push(box);
      }

      ctx.textAlign = align;
      ctx.strokeStyle = "rgba(255,255,255,0.9)";
      ctx.lineWidth = 3.4 / transform.k;
      ctx.strokeText(label, x, y);
      ctx.fillStyle = isConj ? "#111827" : "#334155";
      ctx.globalAlpha = 0.95;
      ctx.fillText(label, x, y);
      ctx.globalAlpha = 1;
    }
    ctx.textAlign = "left";
  }
  ctx.restore();

  if (++drawCount % 10 === 0) {
    d3.select("#visible-count").text(
      `${visible.length.toLocaleString()} nodes · ${visibleLinks.length.toLocaleString()} links`
    );
  }
}

function nearestNode(event) {
  const [mx, my] = d3.pointer(event, canvas);
  const [x, y] = transform.invert([mx, my]);
  let best = null, bestDist = Infinity;
  for (const d of visibleCache.nodes) {
    if (!Number.isFinite(d.x)) continue;
    const dist = (d.x - x) ** 2 + (d.y - y) ** 2;
    if (dist < bestDist) { bestDist = dist; best = d; }
  }
  if (!best) return null;
  const radius = nodeRadius(best) + 6 / transform.k;
  return bestDist <= radius * radius ? best : null;
}

canvas.addEventListener("mousemove", (event) => {
  const d = nearestNode(event);
  state.hovered = d ? d.index : null;
  if (d) {
    const sub = d.type === "conjecture"
      ? `Conjecture · ${d.degree} linked proofs`
      : `${d.type} · ${d.topic} · ${(d.degree || 0)} candidate conjectures`;
    tooltip.innerHTML = `<b>${escapeHtml(d.label)}</b><br>${escapeHtml(sub)}`;
    tooltip.style.opacity = "1";
    const rect = wrap.getBoundingClientRect();
    tooltip.style.left = (event.clientX - rect.left + 12) + "px";
    tooltip.style.top = (event.clientY - rect.top + 12) + "px";
    canvas.style.cursor = "pointer";
  } else {
    tooltip.style.opacity = "0";
    canvas.style.cursor = "grab";
  }
});
canvas.addEventListener("mouseleave", () => { tooltip.style.opacity = "0"; });
canvas.addEventListener("click", (event) => {
  if (dragMoved) { dragMoved = false; return; }
  const d = nearestNode(event);
  if (!d) return;
  state.selected = d.index;
  renderDetails(d);
  draw();
});
canvas.addEventListener("dblclick", (event) => {
  const d = nearestNode(event);
  if (d && d.url) window.open(d.url, "_blank", "noopener");
});

// Node dragging. The pointerdown capture removes the zoom behaviour while a
// node is grabbed, so panning and dragging do not fight each other.
canvas.addEventListener("pointerdown", (event) => {
  if (event.button !== 0) return;
  const d = nearestNode(event);
  if (!d) return;
  event.preventDefault();
  event.stopPropagation();
  dragNode = d;
  dragMoved = false;
  dragStart = {x: event.clientX, y: event.clientY};
  d3.select(canvas).on(".zoom", null);
  const [mx, my] = d3.pointer(event, canvas);
  const [gx, gy] = transform.invert([mx, my]);
  d.fx = gx;
  d.fy = gy;
  tooltip.style.opacity = "0";
  canvas.style.cursor = "grabbing";
  simulation.alphaTarget(0.2).restart();
  canvas.setPointerCapture(event.pointerId);
}, true);

canvas.addEventListener("pointermove", (event) => {
  if (!dragNode) return;
  const [mx, my] = d3.pointer(event, canvas);
  const [gx, gy] = transform.invert([mx, my]);
  dragNode.fx = gx;
  dragNode.fy = gy;
  if (dragStart && Math.hypot(event.clientX - dragStart.x, event.clientY - dragStart.y) > 3) {
    dragMoved = true;
  }
  simulation.alpha(0.35).restart();
});

function endDrag(event) {
  if (!dragNode) return;
  const node = dragNode;
  const moved = dragMoved;
  node.fx = null;
  node.fy = null;
  dragNode = null;
  dragStart = null;
  dragMoved = false;
  simulation.alphaTarget(0);
  d3.select(canvas).call(zoom);
  canvas.style.cursor = "grab";
  if (event && canvas.hasPointerCapture(event.pointerId)) {
    canvas.releasePointerCapture(event.pointerId);
  }
  if (!moved) {
    state.selected = node.index;
    renderDetails(node);
  }
  draw();
}
canvas.addEventListener("pointerup", endDrag);
canvas.addEventListener("pointercancel", endDrag);

function escapeHtml(s) {
  return String(s).replace(/[&<>"']/g, c => ({"&":"&amp;","<":"&lt;",">":"&gt;",'"':"&quot;","'":"&#39;"}[c]));
}

function confidenceLabel(score, confidence) {
  return `${confidence} (score ${score})`;
}

function appendDependencySection(body, d) {
  const parents = proofToParents.get(d.index) || [];
  const children = proofToChildren.get(d.index) || [];
  if (!parents.length && !children.length) return;
  body.append("h2").text("Proof dependencies");
  if (parents.length) {
    body.append("p").html(`Referenced by <b>${parents.length}</b> parent proof${parents.length === 1 ? "" : "s"}.`);
    const list = body.append("ul").attr("class", "linklist");
    for (const item of parents.slice(0, 100)) {
      const p = byIndex.get(item.index);
      if (!p) continue;
      list.append("li").html(
        `<a href="${p.url}" target="_blank" rel="noopener">${escapeHtml(p.label)}</a><br>` +
        `<span class="evidence">via ${escapeHtml(item.evidence)}</span>`
      );
    }
    if (parents.length > 100) body.append("p").attr("class", "small").text(`… and ${parents.length - 100} more parents.`);
  }
  if (children.length) {
    body.append("p").html(`References <b>${children.length}</b> unmatched proof${children.length === 1 ? "" : "s"}.`);
    const list = body.append("ul").attr("class", "linklist");
    for (const item of children.slice(0, 100)) {
      const c = byIndex.get(item.index);
      if (!c) continue;
      list.append("li").html(
        `<a href="${c.url}" target="_blank" rel="noopener">${escapeHtml(c.label)}</a><br>` +
        `<span class="evidence">via ${escapeHtml(item.evidence)}</span>`
      );
    }
    if (children.length > 100) body.append("p").attr("class", "small").text(`… and ${children.length - 100} more children.`);
  }
}

function renderDetails(d) {
  const body = d3.select("#detail-body");
  body.html("").classed("note", false);
  if (!d) {
    body.classed("note", true).text("Click a proof or conjecture. Drag to pan, scroll to zoom.");
    return;
  }
  const isConj = d.type === "conjecture";
  const color = isConj ? d.color : (d.dominant && d.dominant !== "unlinked" ? conjectureColor.get(d.dominant) : UNLINKED_COLOR);
  body.append("div").html(`<span class="pill" style="background:${color}">${isConj ? "CONJECTURE" : d.type.toUpperCase()}</span>`);
  body.append("div").attr("class", "detail-label").text(d.label);
  if (!isConj) body.append("p").text("Topic: " + d.topic);

  if (isConj) {
    body.append("p").text(d.short);
    body.append("p").html(`<a href="${d.url}" target="_blank" rel="noopener">Literature ↗</a>`);
    body.append("p").html(`Linked to <b>${(d.degree || 0).toLocaleString()}</b> proofs in the catalogue.`);
    const proofIndexes = (conjectureToProofs.get(d.index) || []).filter(i => {
      const l = conjectureLinks.find(x => endIndex(x.source) === i && endIndex(x.target) === d.index);
      return !l || l.score >= state.minConfidence;
    }).sort((a, b) => (byIndex.get(a).label || "").localeCompare(byIndex.get(b).label || ""));
    const list = body.append("ul").attr("class", "linklist");
    for (const i of proofIndexes.slice(0, 250)) {
      const p = byIndex.get(i);
      if (!p) continue;
      list.append("li").html(`<a href="${p.url}" target="_blank" rel="noopener">${escapeHtml(p.label)}</a><br><span class="small">${escapeHtml(p.topic)} · ${escapeHtml(p.type)}</span>`);
    }
    if (proofIndexes.length > 250) body.append("p").attr("class", "small").text(`… and ${proofIndexes.length - 250} more.`);
    return;
  }

  body.append("p").html(`<a href="${d.url}" target="_blank" rel="noopener">Open the Lean declaration ↗</a>`);
  const matched = (proofToConjectures.get(d.index) || []).filter(l => l.score >= state.minConfidence);
  if (!matched.length) {
    body.append("p").attr("class", "small").text("No conjecture matched the catalogue at this confidence level.");
    appendDependencySection(body, d);
    return;
  }
  body.append("p").html(`Candidate conjectures: <b>${matched.length}</b>.`);
  const list = body.append("ul").attr("class", "linklist");
  for (const l of matched.sort((a, b) => b.score - a.score)) {
    const c = byIndex.get(endIndex(l.target));
    if (!c) continue;
    list.append("li").html(
      `<a href="${c.url}" target="_blank" rel="noopener">${escapeHtml(c.label)}</a> ` +
      `<span class="evidence">${confidenceLabel(l.score, l.confidence)} · ${escapeHtml(l.evidence)}</span>`
    );
  }
  appendDependencySection(body, d);
}

function update() {
  recomputeVisibility();
  draw();
  if (simulation) simulation.alpha(0.2).restart();
}

// Initial paint.
setTimeout(() => {
  update();
  resize();
  simulation.alpha(1).restart();
  loading.textContent = "Laying out " + nodes.length.toLocaleString() + " nodes…";
}, 40);
setTimeout(() => {
  loading.style.opacity = "0";
  loading.style.pointerEvents = "none";
}, 6000);

const legend = d3.select("#legend");
legend.append("div").html(`<span class="dot" style="background:#2563eb"></span>Proof / lemma (colour = strongest conjecture)`);
legend.append("div").html(`<span class="dot" style="background:${UNLINKED_COLOR}"></span>Unmatched proof`);
legend.append("div").html(`<span style="color:#475569">┄</span> parent link (unmatched → referencing proof)`);
for (const c of graph.conjectures) {
  legend.append("div").html(`<span class="dot" style="background:${c.color}"></span>${escapeHtml(c.name)}`);
}
</script>
</body>
</html>
"""

html = (
    html.replace("__GRAPH__", payload)
    .replace("__PROOFS__", f"{graph['stats']['proofs']:,}")
    .replace("__CONJECTURES__", f"{graph['stats']['conjectures']:,}")
    .replace("__LINKS__", f"{graph['stats']['links']:,}")
    .replace("__DEPS__", f"{graph['stats']['dependencies']:,}")
    .replace("__UNLINKED__", f"{graph['stats']['unlinked']:,}")
    .replace("__LINKED_UNMATCHED__", f"{graph['stats']['linkedUnmatched']:,}")
)
OUT.write_text(html, encoding="utf-8")
print(
    f"wrote {OUT} with {len(proof_nodes):,} proofs, "
    f"{len(conjecture_nodes):,} conjectures, {len(links):,} candidate links "
    f"({unlinked:,} unmatched proofs)"
)
