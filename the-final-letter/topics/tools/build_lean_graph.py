#!/usr/bin/env python3
"""Build a D3 force-directed graph from the LaTeX statements in index-lean.md.

Nodes are proofs/lemmas and the constants, terms, symbols, characters and
keywords occurring in their LaTeX statements. Edges connect a proof to each
concept it uses. Proof nodes link straight to the declaration line in the
Lean source; concept nodes link to their first occurrence and list every
proof that uses them.
"""
from __future__ import annotations

import json
import re
from collections import Counter, defaultdict
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
INDEX = ROOT / "index-lean.md"
OUT = ROOT / "lean-graph.html"

ROW_RE = re.compile(
    r"^\s*\|\s+\[(\d+)\]\(([^)#]+)#L\d+\)\s*\|\s*(theorem|lemma)\s*\|\s*"
    r"`([^`]+)`\s*\|\s*(\$[^$]*\$)\s*\|\s*$",
    re.MULTILINE,
)

GREEK = {
    "alpha": "α", "beta": "β", "gamma": "γ", "delta": "δ",
    "varepsilon": "ε", "epsilon": "ϵ", "zeta": "ζ", "eta": "η",
    "theta": "θ", "iota": "ι", "kappa": "κ", "lambda": "λ",
    "mu": "μ", "nu": "ν", "xi": "ξ", "pi": "π", "rho": "ρ",
    "sigma": "σ", "tau": "τ", "upsilon": "υ", "varphi": "φ",
    "phi": "ϕ", "chi": "χ", "psi": "ψ", "omega": "ω",
    "Gamma": "Γ", "Delta": "Δ", "Theta": "Θ", "Lambda": "Λ",
    "Xi": "Ξ", "Pi": "Π", "Sigma": "Σ", "Phi": "Φ",
    "Psi": "Ψ", "Omega": "Ω",
}
SYMBOLS = {
    "le": "≤", "ge": "≥", "ne": "≠", "approx": "≈", "equiv": "≡",
    "sim": "∼", "in": "∈", "notin": "∉", "subseteq": "⊆", "subset": "⊂",
    "cup": "∪", "cap": "∩", "setminus": "∖", "sum": "∑", "prod": "∏",
    "int": "∫", "partial": "∂", "infty": "∞", "times": "×", "cdot": "·",
    "circ": "∘", "ast": "∗", "bullet": "•", "Vert": "‖", "vert": "|",
    "langle": "⟨", "rangle": "⟩", "lfloor": "⌊", "rfloor": "⌋",
    "lceil": "⌈", "rceil": "⌉", "emptyset": "∅", "top": "⊤", "bot": "⊥",
    "mid": "∣", "nmid": "∤", "nabla": "∇", "surd": "√", "propto": "∝",
    "ll": "≪", "gg": "≫", "otimes": "⊗", "oplus": "⊕", "forall": "∀",
    "exists": "∃", "to": "→", "leftarrow": "←", "leftrightarrow": "↔",
    "Rightarrow": "⇒", "Leftrightarrow": "⇔", "mapsto": "↦",
    "uparrow": "↑", "downarrow": "↓", "land": "∧", "lor": "∨",
    "neg": "¬", "vdash": "⊢", "oint": "∮", "bigsqcup": "⨆",
    "frac": "", "tfrac": "", "left": "", "right": "", "bigl": "",
    "bigr": "", "Big": "", "quad": "", "qquad": "",
}
BLACKBOARD = {"R": "ℝ", "C": "ℂ", "N": "ℕ", "Z": "ℤ", "Q": "ℚ", "F": "𝔽", "k": "𝕜"}
CALLIGRAPHIC = {
    "F": "ℱ", "N": "𝒩", "O": "𝒪", "U": "𝒰", "L": "ℒ", "H": "ℋ",
    "P": "𝒫", "R": "ℛ", "S": "𝒮", "T": "𝒯",
}
STRUCTURAL = {"mathrm", "mathcal", "mathbb", "text", "operatorname"}
KEYWORDS = {"if", "then", "else", "let", "in", "match", "with"}
COLORS = {
    "theorem": "#2563eb",
    "lemma": "#0891b2",
    "term": "#16a34a",
    "constant": "#ea580c",
    "symbol": "#7c3aed",
    "character": "#dc2626",
    "keyword": "#64748b",
}


def unescape_latex(text: str) -> str:
    return (
        text.replace(r"\_", "_")
        .replace(r"\{", "{")
        .replace(r"\}", "}")
        .replace(r"\ ", " ")
        .replace("{}", "")
    )


def strip_binders(text: str) -> str:
    """Remove bound names while keeping binder types and the quantifiers."""
    out: list[str] = []
    i = 0
    while i < len(text):
        command = None
        for candidate in (r"\forall", r"\exists", r"\lambda"):
            if text.startswith(candidate, i):
                command = candidate
                break
        if command:
            out.append(command)
            i += len(command)
            while i < len(text):
                if text.startswith(r"\,", i):
                    i += 2
                elif text[i].isspace():
                    i += 1
                else:
                    break
            if i < len(text) and text[i] == "[":
                continue
            depth = 0
            k = i
            while k < len(text):
                ch = text[k]
                if ch in "([{":
                    depth += 1
                elif ch in ")]}":
                    depth = max(0, depth - 1)
                elif depth == 0 and (ch == ":" or ch == "," or text.startswith(r"\Rightarrow", k)):
                    break
                k += 1
            i = k
            continue
        out.append(text[i])
        i += 1
    return "".join(out)


def read_group(text: str, i: int) -> tuple[str, int]:
    """Read a braced group starting at i; return its contents and end index."""
    if i >= len(text) or text[i] != "{":
        return "", i
    depth = 0
    for k in range(i, len(text)):
        if text[k] == "{":
            depth += 1
        elif text[k] == "}":
            depth -= 1
            if depth == 0:
                return text[i + 1:k], k + 1
    return text[i + 1:], len(text)


def tokenize(statement: str) -> list[tuple[str, str, str]]:
    """Return (type, display label, raw token) triples from a LaTeX statement."""
    text = strip_binders(statement)
    tokens: list[tuple[str, str, str]] = []
    i = 0
    while i < len(text):
        c = text[i]
        if c == "\\":
            match = re.match(r"\\([A-Za-z]+)", text[i:])
            if not match:
                i += 2 if i + 1 < len(text) else 1
                continue
            command = match.group(1)
            i += len(match.group(0))
            if command in STRUCTURAL:
                j = i
                while j < len(text) and text[j].isspace():
                    j += 1
                inner, i = read_group(text, j)
                inner = unescape_latex(inner)
                if command == "mathbb":
                    label = BLACKBOARD.get(inner, f"𝔹{inner}" if inner else "?")
                    tokens.append(("constant", label, "\\mathbb{" + inner + "}"))
                elif command == "mathcal":
                    label = CALLIGRAPHIC.get(inner, inner)
                    tokens.append(("term", label, "\\mathcal{" + inner + "}"))
                elif command == "text":
                    word = inner.strip()
                    if word:
                        tokens.append(("keyword", word, "\\text{" + word + "}"))
                else:
                    if inner:
                        tokens.append(("term", inner, "\\" + command + "{" + inner + "}"))
                continue
            if command in GREEK:
                tokens.append(("character", GREEK[command], "\\" + command))
                continue
            if command in SYMBOLS:
                label = SYMBOLS[command]
                if label:
                    tokens.append(("symbol", label, "\\" + command))
                continue
            tokens.append(("symbol", command, "\\" + command))
            continue

        if c.isdigit():
            match = re.match(r"[0-9]+(?:\.[0-9]+)?", text[i:])
            label = match.group(0)
            tokens.append(("constant", label, label))
            i += len(label)
            continue
        if c.isalpha():
            match = re.match(r"[A-Za-z]+", text[i:])
            word = match.group(0)
            if word in KEYWORDS:
                tokens.append(("keyword", word, word))
            elif len(word) == 1:
                tokens.append(("character", word, word))
            else:
                tokens.append(("term", word, word))
            i += len(word)
            continue
        if c in "=+-<>/":
            tokens.append(("symbol", c, c))
            i += 1
            continue
        i += 1
    return tokens


rows = ROW_RE.findall(INDEX.read_text(encoding="utf-8"))
if not rows:
    raise SystemExit(f"no rows parsed from {INDEX}")

nodes: list[dict] = []
links: list[list[int]] = []
concept_index: dict[tuple[str, str], int] = {}
concept_proofs: dict[int, set[int]] = defaultdict(set)
concept_topics: dict[int, set[str]] = defaultdict(set)
topic_counts: Counter = Counter()

for line_text, rel, kind, name, latex in rows:
    topic = rel.split("/", 1)[0]
    url = f"{rel}#L{int(line_text)}"
    proof_index = len(nodes)
    nodes.append({
        "id": f"p:{rel}:{line_text}:{name}",
        "type": kind,
        "label": name,
        "topic": topic,
        "url": url,
        "degree": 0,
    })
    topic_counts[topic] += 1

    counts = Counter()
    for concept_kind, label, raw in tokenize(latex[1:-1]):
        counts[(concept_kind, label)] += 1

    for (concept_kind, label), weight in counts.items():
        key = (concept_kind, label)
        if key not in concept_index:
            concept_index[key] = len(nodes)
            nodes.append({
                "id": f"c:{concept_kind}:{label}",
                "type": concept_kind,
                "label": label,
                "url": url,
                "degree": 0,
            })
        ci = concept_index[key]
        links.append([proof_index, ci, weight])
        concept_proofs[ci].add(proof_index)
        concept_topics[ci].add(topic)
        nodes[proof_index]["degree"] += 1

for ci, proofs in concept_proofs.items():
    nodes[ci]["degree"] = len(proofs)
    nodes[ci]["topics"] = sorted(concept_topics[ci])

graph = {
    "source": INDEX.name,
    "nodes": nodes,
    "links": links,
    "topics": sorted(topic_counts),
    "topicCounts": dict(topic_counts),
    "colors": COLORS,
}

payload = json.dumps(graph, ensure_ascii=False, separators=(",", ":")).replace("</", "<\\/")
counts = Counter(node["type"] for node in nodes)
stats = {
    "proofs": counts["theorem"] + counts["lemma"],
    "theorems": counts["theorem"],
    "lemmas": counts["lemma"],
    "concepts": len(nodes) - counts["theorem"] - counts["lemma"],
    "edges": len(links),
}

html = r"""<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Lean proof graph — concepts, symbols and declarations</title>
<style>
  :root {
    --bg: #f7f8fa;
    --panel: #ffffff;
    --ink: #1f2937;
    --muted: #64748b;
    --line: #dbe2ea;
    --accent: #1d4ed8;
  }
  * { box-sizing: border-box; }
  html, body { height: 100%; margin: 0; }
  body {
    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
    color: var(--ink);
    background: var(--bg);
    overflow: hidden;
  }
  #app {
    display: grid;
    grid-template-columns: 270px minmax(0, 1fr) 340px;
    grid-template-rows: 100vh;
  }
  aside {
    background: var(--panel);
    border-right: 1px solid var(--line);
    overflow-y: auto;
    padding: 16px;
  }
  #details { border-right: 0; border-left: 1px solid var(--line); }
  h1 { font-size: 1rem; margin: 0 0 4px; letter-spacing: -0.01em; }
  h2 { font-size: 0.78rem; text-transform: uppercase; letter-spacing: 0.08em; color: var(--muted); margin: 20px 0 8px; }
  p, li { font-size: 0.82rem; line-height: 1.45; }
  .small { color: var(--muted); font-size: 0.76rem; }
  .statgrid { display: grid; grid-template-columns: 1fr 1fr; gap: 6px; margin: 10px 0; }
  .stat { background: #f1f5f9; border-radius: 6px; padding: 6px 8px; }
  .stat b { display: block; font-size: 1rem; }
  .stat span { color: var(--muted); font-size: 0.7rem; }
  label { display: flex; align-items: center; gap: 8px; font-size: 0.82rem; margin: 6px 0; cursor: pointer; }
  input[type="checkbox"] { accent-color: var(--accent); }
  select, input[type="search"], input[type="number"] {
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
  canvas { display: block; width: 100%; height: 100%; cursor: grab; }
  canvas:active { cursor: grabbing; }
  #legend { position: absolute; left: 14px; bottom: 14px; background: rgba(255,255,255,0.94); border: 1px solid var(--line); border-radius: 8px; padding: 8px 10px; font-size: 0.74rem; line-height: 1.6; }
  .swatch { display: inline-block; width: 9px; height: 9px; border-radius: 50%; margin-right: 5px; }
  #tooltip {
    position: absolute; pointer-events: none; background: rgba(15,23,42,0.94); color: #fff;
    padding: 6px 8px; border-radius: 6px; font-size: 0.75rem; max-width: 320px;
    opacity: 0; transition: opacity 0.08s; z-index: 5;
  }
  #loading {
    position: absolute; inset: 0; display: flex; align-items: center; justify-content: center;
    background: rgba(247,248,250,0.82); font-size: 0.9rem; color: var(--muted); z-index: 10;
  }
  #details .empty { color: var(--muted); font-size: 0.82rem; }
  .pill { display: inline-block; padding: 1px 7px; border-radius: 999px; font-size: 0.68rem; color: #fff; text-transform: uppercase; letter-spacing: 0.04em; }
  .linklist { list-style: none; padding: 0; margin: 8px 0; }
  .linklist li { padding: 4px 0; border-bottom: 1px solid #eef2f6; font-size: 0.76rem; }
  .linklist a { color: var(--accent); text-decoration: none; }
  .linklist a:hover { text-decoration: underline; }
  .detail-label { font-size: 1.05rem; font-weight: 600; word-break: break-word; }
  code { background: #f1f5f9; border-radius: 3px; padding: 1px 4px; font-size: 0.75rem; }
  .hint { background: #eff6ff; border: 1px solid #bfdbfe; border-radius: 6px; padding: 8px; font-size: 0.76rem; color: #1e3a8a; }
  @media (max-width: 1000px) {
    #app { grid-template-columns: 230px minmax(0, 1fr); }
    #details { display: none; }
  }
</style>
</head>
<body>
<div id="app">
  <aside id="controls">
    <h1>Lean proof graph</h1>
    <p class="small">Parsed from <a href="index-lean.md"><code>index-lean.md</code></a>. Click a node for details and links to the Lean source. Bound variable names are omitted; character nodes are free and Greek variables.</p>
    <div class="statgrid">
      <div class="stat"><b>__PROOFS__</b><span>proofs / lemmas</span></div>
      <div class="stat"><b>__CONCEPTS__</b><span>concepts</span></div>
      <div class="stat"><b>__EDGES__</b><span>proof–concept links</span></div>
      <div class="stat"><b>__TOPICS__</b><span>topics</span></div>
    </div>

    <h2>Preset</h2>
    <div class="row">
      <button class="primary" id="preset-semantic">Semantic</button>
      <button id="preset-all">All</button>
    </div>
    <p class="small">Semantic shows proofs, terms and constants; All adds symbols, characters and keywords.</p>

    <h2>Node types</h2>
    <div id="type-filters"></div>

    <h2>Concept degree</h2>
    <p class="small">Hides one-off terms and ubiquitous notation.</p>
    <div class="row">
      <input type="number" id="min-degree" min="1" value="2" title="Minimum number of proofs using a concept">
      <input type="number" id="max-degree" min="1" value="400" title="Maximum number of proofs using a concept">
    </div>

    <h2>Topic</h2>
    <select id="topic"></select>

    <h2>Search</h2>
    <input type="search" id="search" placeholder="Filter labels…">

    <h2>Display</h2>
    <label><input type="checkbox" id="show-labels" checked> Show labels</label>
    <label><input type="checkbox" id="hide-isolated" checked> Hide isolated proofs</label>
    <p class="small">Major concepts are labelled by default; hover, select or zoom for the rest.</p>
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
    <div id="detail-body" class="empty">Click a proof or concept node. Drag to pan, scroll to zoom.</div>
  </aside>
</div>

<script src="https://cdn.jsdelivr.net/npm/d3@7"></script>
<script>
const graph = __GRAPH__;
const COLORS = graph.colors;

const TYPE_LABELS = {
  theorem: "Theorem",
  lemma: "Lemma",
  term: "Term",
  constant: "Constant",
  symbol: "Symbol",
  character: "Character",
  keyword: "Keyword"
};

const nodes = graph.nodes.map((d, i) => Object.assign({}, d, {index: i}));
const links = graph.links.map(([source, target, weight]) => ({source, target, weight}));
const byIndex = new Map(nodes.map(d => [d.index, d]));
const labelCandidates = new Set(
  nodes.filter(d => d.type !== "theorem" && d.type !== "lemma")
    .sort((a, b) => (b.degree || 0) - (a.degree || 0))
    .slice(0, 80)
    .map(d => d.index)
);
for (const [i, d] of nodes.entries()) {
  const angle = (i / Math.max(1, nodes.length)) * Math.PI * 2;
  d.x = 820 + Math.cos(angle) * 280;
  d.y = 500 + Math.sin(angle) * 280;
}

// Adjacency is used by the details panel.
const proofToConcepts = new Map();
const conceptToProofs = new Map();
for (const l of links) {
  if (!proofToConcepts.has(l.source)) proofToConcepts.set(l.source, []);
  proofToConcepts.get(l.source).push(l.target);
  if (!conceptToProofs.has(l.target)) conceptToProofs.set(l.target, []);
  conceptToProofs.get(l.target).push(l.source);
}

const state = {
  types: new Set(["theorem", "lemma", "term", "constant"]),
  minDegree: 2,
  maxDegree: 400,
  topic: "all",
  search: "",
  labels: true,
  hideIsolated: true,
  selected: null,
  hovered: null
};

const typeList = ["theorem", "lemma", "term", "constant", "symbol", "character", "keyword"];
const typeFilter = d3.select("#type-filters");
for (const type of typeList) {
  const id = "type-" + type;
  const label = typeFilter.append("label");
  label.append("input")
    .attr("type", "checkbox")
    .attr("id", id)
    .property("checked", state.types.has(type))
    .on("change", (event) => {
      if (event.target.checked) state.types.add(type);
      else state.types.delete(type);
      update();
    });
  label.append("span")
    .html(`<span class="swatch" style="background:${COLORS[type]}"></span>${TYPE_LABELS[type]}`);
}

const topicSelect = d3.select("#topic");
topicSelect.append("option").attr("value", "all").text("All topics");
for (const topic of graph.topics) {
  topicSelect.append("option").attr("value", topic).text(`${topic} (${graph.topicCounts[topic]})`);
}
topicSelect.on("change", (event) => { state.topic = event.target.value; update(); });

d3.select("#min-degree").on("change", (event) => {
  state.minDegree = Math.max(1, +event.target.value || 1);
  update();
});
d3.select("#max-degree").on("change", (event) => {
  state.maxDegree = Math.max(state.minDegree, +event.target.value || 99999);
  update();
});
d3.select("#search").on("input", (event) => {
  state.search = event.target.value.trim().toLowerCase();
  update();
});
d3.select("#show-labels").on("change", (event) => { state.labels = event.target.checked; draw(); });
d3.select("#hide-isolated").on("change", (event) => { state.hideIsolated = event.target.checked; update(); });
d3.select("#reheat").on("click", () => { simulation.alpha(0.9).restart(); });
d3.select("#reset").on("click", () => {
  state.types = new Set(["theorem", "lemma", "term", "constant"]);
  state.minDegree = 2;
  state.maxDegree = 400;
  state.topic = "all";
  state.search = "";
  state.hideIsolated = true;
  state.selected = null;
  d3.selectAll("#type-filters input").property("checked", (d, i) => {
    const type = typeList[i];
    return state.types.has(type);
  });
  d3.select("#min-degree").property("value", 2);
  d3.select("#max-degree").property("value", 400);
  d3.select("#topic").property("value", "all");
  d3.select("#search").property("value", "");
  d3.select("#hide-isolated").property("checked", true);
  d3.select("#show-labels").property("checked", true);
  state.labels = true;
  renderDetails(null);
  simulation.alpha(0.7).restart();
  update();
});
d3.select("#preset-semantic").on("click", () => {
  state.types = new Set(["theorem", "lemma", "term", "constant"]);
  state.minDegree = 2;
  state.maxDegree = 400;
  syncControls();
  update();
});
d3.select("#preset-all").on("click", () => {
  state.types = new Set(typeList);
  state.minDegree = 1;
  state.maxDegree = 99999;
  syncControls();
  update();
});

function syncControls() {
  d3.selectAll("#type-filters input").property("checked", (d, i) => state.types.has(typeList[i]));
  d3.select("#min-degree").property("value", state.minDegree);
  d3.select("#max-degree").property("value", state.maxDegree);
}
syncControls();

const legend = d3.select("#legend");
for (const type of typeList) {
  legend.append("div").html(`<span class="swatch" style="background:${COLORS[type]}"></span>${TYPE_LABELS[type]}`);
}

const canvas = document.getElementById("graph");
const ctx = canvas.getContext("2d");
const wrap = document.getElementById("graphwrap");
const tooltip = document.getElementById("tooltip");
const loading = document.getElementById("loading");

let width = 0, height = 0, transform = d3.zoomIdentity;
let visibleCache = {nodes: [], links: []};
let drawCount = 0;

const zoom = d3.zoom()
  .scaleExtent([0.08, 12])
  .on("zoom", (event) => { transform = event.transform; draw(); });

d3.select(canvas).call(zoom);

function resize() {
  const rect = wrap.getBoundingClientRect();
  width = Math.max(320, rect.width);
  height = Math.max(320, rect.height);
  const ratio = window.devicePixelRatio || 1;
  canvas.width = Math.round(width * ratio);
  canvas.height = Math.round(height * ratio);
  ctx.setTransform(ratio, 0, 0, ratio, 0, 0);
  simulation.force("center", d3.forceCenter(width / 2, height / 2));
  simulation.alpha(0.3).restart();
  draw();
}

const simulation = d3.forceSimulation(nodes)
  .force("link", d3.forceLink(links)
    .id(d => d.index)
    .distance(l => (l.source.type === "theorem" || l.source.type === "lemma") ? 28 : 46)
    .strength(l => 1 / Math.max(3, Math.min(30, (l.source.degree || 1)))))
  .force("charge", d3.forceManyBody()
    .strength(d => (d.type === "theorem" || d.type === "lemma") ? -10 : -45)
    .distanceMax(260))
  .force("center", d3.forceCenter(820, 500))
  .force("collide", d3.forceCollide(d => nodeRadius(d) + 1).iterations(1))
  .alphaDecay(0.035)
  .velocityDecay(0.42)
  .on("tick", ticked);

new ResizeObserver(resize).observe(wrap);

function nodeRadius(d) {
  if (d.type === "theorem" || d.type === "lemma") return 2.4;
  return Math.min(13, 3.2 + Math.log2(1 + (d.degree || 1)) * 1.25);
}

function nodeVisible(d) {
  if (!state.types.has(d.type)) return false;
  if (d.type === "theorem" || d.type === "lemma") {
    if (state.topic !== "all" && d.topic !== state.topic) return false;
    if (state.search) {
      const selfMatch = d.label.toLowerCase().includes(state.search);
      const neighbourMatch = (proofToConcepts.get(d.index) || []).some(i => {
        const c = byIndex.get(i);
        return c && c.label.toLowerCase().includes(state.search);
      });
      if (!selfMatch && !neighbourMatch) return false;
    }
    if (state.hideIsolated && !state.search) {
      const neighbors = proofToConcepts.get(d.index) || [];
      if (!neighbors.some(i => conceptVisible(byIndex.get(i)))) return false;
    }
    return true;
  }
  return conceptVisible(d);
}

function conceptVisible(d) {
  if (!state.types.has(d.type)) return false;
  const degree = d.degree || 0;
  if (degree < state.minDegree || degree > state.maxDegree) return false;
  if (state.topic !== "all" && (!d.topics || !d.topics.includes(state.topic))) return false;
  if (state.search && !d.label.toLowerCase().includes(state.search)) return false;
  return true;
}

function ticked() {
  draw();
  if (simulation.alpha() < 0.05) {
    loading.style.opacity = "0";
    loading.style.pointerEvents = "none";
    simulation.stop();
  }
}

function recomputeVisibility() {
  const visible = nodes.filter(nodeVisible);
  const visibleSet = new Set(visible.map(d => d.index));
  const visibleLinks = links.filter(l => {
    const s = typeof l.source === "object" ? l.source.index : l.source;
    const t = typeof l.target === "object" ? l.target.index : l.target;
    return visibleSet.has(s) && visibleSet.has(t);
  });
  visibleCache = {nodes: visible, links: visibleLinks};
}

function draw() {
  if (!width || !height) return;
  ctx.clearRect(0, 0, width, height);
  ctx.save();
  ctx.translate(transform.x, transform.y);
  ctx.scale(transform.k, transform.k);

  const visible = visibleCache.nodes;
  const visibleLinks = visibleCache.links;

  ctx.lineWidth = 0.55 / transform.k;
  ctx.strokeStyle = "rgba(100,116,139,0.20)";
  ctx.beginPath();
  for (const l of visibleLinks) {
    ctx.moveTo(l.source.x, l.source.y);
    ctx.lineTo(l.target.x, l.target.y);
  }
  ctx.stroke();

  for (const d of visible) {
    const r = nodeRadius(d);
    ctx.beginPath();
    ctx.arc(d.x, d.y, r, 0, Math.PI * 2);
    ctx.fillStyle = COLORS[d.type] || "#64748b";
    ctx.globalAlpha = (d.type === "theorem" || d.type === "lemma") ? 0.72 : 0.92;
    ctx.fill();
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
    for (const d of visible) {
      const isProof = d.type === "theorem" || d.type === "lemma";
      const show = labelCandidates.has(d.index) || transform.k > 1.8 ||
        state.selected === d.index || state.hovered === d.index;
      if (!show) continue;
      const label = d.label;
      const x = d.x + nodeRadius(d) + 3 / transform.k;
      ctx.strokeStyle = "rgba(255,255,255,0.86)";
      ctx.lineWidth = 3 / transform.k;
      ctx.strokeText(label, x, d.y);
      ctx.fillStyle = isProof ? "#1e3a8a" : "#243041";
      ctx.globalAlpha = 0.9;
      ctx.fillText(label, x, d.y);
      ctx.globalAlpha = 1;
    }
  }
  ctx.restore();

  if (++drawCount % 10 === 0) {
    const label = `${visible.length.toLocaleString()} nodes · ${visibleLinks.length.toLocaleString()} edges`;
    d3.select("#visible-count").text(label);
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
  const radius = nodeRadius(best) + 5 / transform.k;
  return bestDist <= radius * radius ? best : null;
}

canvas.addEventListener("mousemove", (event) => {
  const d = nearestNode(event);
  state.hovered = d ? d.index : null;
  if (d) {
    tooltip.innerHTML = `<b>${escapeHtml(d.label)}</b><br>${TYPE_LABELS[d.type] || d.type}${d.topic ? " · " + escapeHtml(d.topic) : ""}`;
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

function escapeHtml(s) {
  return String(s).replace(/[&<>"']/g, c => ({"&":"&amp;","<":"&lt;",">":"&gt;",'"':"&quot;","'":"&#39;"}[c]));
}

function renderDetails(d) {
  const body = d3.select("#detail-body");
  body.html("");
  if (!d) {
    body.classed("empty", true).text("Click a proof or concept node. Drag to pan, scroll to zoom.");
    return;
  }
  body.classed("empty", false);
  const typeLabel = TYPE_LABELS[d.type] || d.type;
  body.append("div")
    .html(`<span class="pill" style="background:${COLORS[d.type] || "#64748b"}">${escapeHtml(typeLabel)}</span>`);
  body.append("div").attr("class", "detail-label").text(d.label);
  if (d.topic) body.append("p").text("Topic: " + d.topic);
  body.append("p").html(`Used by <b>${(d.degree || 0).toLocaleString()}</b> ${d.type === "theorem" || d.type === "lemma" ? "concepts" : "proofs"}.`);

  if (d.type === "theorem" || d.type === "lemma") {
    body.append("p").html(`<a href="${d.url}" target="_blank" rel="noopener">Open the Lean declaration ↗</a>`);
    body.append("p").attr("class", "small").text(d.url);
    return;
  }

  body.append("p").html(`<a href="${d.url}" target="_blank" rel="noopener">Open a representative Lean use ↗</a>`);
  const proofIndexes = (conceptToProofs.get(d.index) || []).slice().sort((a, b) => {
    const A = byIndex.get(a), B = byIndex.get(b);
    return (A.label || "").localeCompare(B.label || "");
  });
  body.append("p").attr("class", "small").text(`Occurs in ${proofIndexes.length.toLocaleString()} proofs.`);
  const list = body.append("ul").attr("class", "linklist");
  const shown = proofIndexes.slice(0, 200);
  for (const index of shown) {
    const p = byIndex.get(index);
    if (!p) continue;
    list.append("li").html(`<a href="${p.url}" target="_blank" rel="noopener">${escapeHtml(p.label)}</a><br><span class="small">${escapeHtml(p.topic || "")} · ${escapeHtml(p.type)}</span>`);
  }
  if (proofIndexes.length > shown.length) {
    body.append("p").attr("class", "small").text(`… and ${(proofIndexes.length - shown.length).toLocaleString()} more.`);
  }
}

function update() {
  recomputeVisibility();
  draw();
  if (simulation) simulation.alpha(0.2).restart();
}

// Initial size and deferred start.
setTimeout(() => {
  update();
  resize();
  simulation.alpha(1).restart();
  loading.textContent = "Laying out " + nodes.length.toLocaleString() + " nodes…";
}, 40);

// Never leave the overlay blocking the page if the simulation is slow.
setTimeout(() => {
  loading.style.opacity = "0";
  loading.style.pointerEvents = "none";
}, 6000);
</script>
</body>
</html>
"""

html = (
    html.replace("__GRAPH__", payload)
    .replace("__PROOFS__", f"{stats['proofs']:,}")
    .replace("__CONCEPTS__", f"{stats['concepts']:,}")
    .replace("__EDGES__", f"{stats['edges']:,}")
    .replace("__TOPICS__", f"{len(graph['topics']):,}")
)
OUT.write_text(html, encoding="utf-8")
print(
    f"wrote {OUT} with {len(nodes):,} nodes "
    f"({stats['proofs']:,} proofs, {stats['concepts']:,} concepts), "
    f"{len(links):,} links"
)
