#!/usr/bin/env python3
"""Generate the-final-letter/topics/index-lean.md from the Lean sources.

The index lists every named `theorem` and `lemma` declaration under
`the-final-letter/topics/**/*.lean`, with a link to the declaration line.
Anonymous `example` proofs and files with no named proofs are listed
separately.
"""
from __future__ import annotations

import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

DECL_RE = re.compile(
    r"^\s*(?:(?:private|protected|noncomputable|local|scoped|unsafe|partial)\s+)*"
    r"(?:@\[[^\]]*\]\s*)*(theorem|lemma)\s+([^\s(:\{]+)"
)
EXAMPLE_RE = re.compile(
    r"^\s*(?:(?:private|protected|noncomputable|local|scoped|unsafe|partial)\s+)*"
    r"(?:@\[[^\]]*\]\s*)*example\b"
)

# Machine-generated density certificates: thousands of auxiliary lemmas per
# file.  They are listed under "Generated certificates" instead of being
# expanded into the declaration index.
GENERATED_RE = re.compile(r"^[^/]+/lean/DensityC\d+_\d+\.lean$")


def strip_comments(text: str) -> str:
    """Blank out Lean comments and string literals, preserving line numbers."""
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


SYM = {
    "ℂ": r"\mathbb{C}", "ℝ": r"\mathbb{R}", "ℕ": r"\mathbb{N}", "ℤ": r"\mathbb{Z}",
    "ℚ": r"\mathbb{Q}", "𝔽": r"\mathbb{F}", "𝕜": r"\mathbb{k}",
    "α": r"\alpha", "β": r"\beta", "γ": r"\gamma", "δ": r"\delta",
    "ε": r"\varepsilon", "ϵ": r"\epsilon", "ζ": r"\zeta", "η": r"\eta",
    "θ": r"\theta", "ι": r"\iota", "κ": r"\kappa", "λ": r"\lambda",
    "μ": r"\mu", "ν": r"\nu", "ξ": r"\xi", "π": r"\pi", "ρ": r"\rho",
    "σ": r"\sigma", "τ": r"\tau", "υ": r"\upsilon", "φ": r"\varphi",
    "ϕ": r"\phi", "χ": r"\chi", "ψ": r"\psi", "ω": r"\omega",
    "Γ": r"\Gamma", "Δ": r"\Delta", "Θ": r"\Theta", "Λ": r"\Lambda",
    "Ξ": r"\Xi", "Π": r"\Pi", "Σ": r"\Sigma", "Φ": r"\Phi",
    "Ψ": r"\Psi", "Ω": r"\Omega",
    "∀": r"\forall", "∃": r"\exists", "→": r"\to", "←": r"\leftarrow",
    "↔": r"\leftrightarrow", "⇒": r"\Rightarrow", "⇔": r"\Leftrightarrow",
    "↦": r"\mapsto", "↑": r"\uparrow", "↓": r"\downarrow",
    "∧": r"\land", "∨": r"\lor", "¬": r"\neg", "⊢": r"\vdash",
    "≤": r"\le", "≥": r"\ge", "≠": r"\ne", "≈": r"\approx",
    "≡": r"\equiv", "∼": r"\sim", "∈": r"\in", "∉": r"\notin",
    "⊆": r"\subseteq", "⊂": r"\subset", "∪": r"\cup", "∩": r"\cap",
    "∖": r"\setminus", "∑": r"\sum", "∏": r"\prod", "∫": r"\int",
    "∂": r"\partial", "∞": r"\infty", "×": r"\times", "·": r"\cdot",
    "∘": r"\circ", "∗": r"\ast", "•": r"\bullet", "‖": r"\Vert",
    "⟨": r"\langle", "⟩": r"\rangle", "⌊": r"\lfloor", "⌋": r"\rfloor",
    "⌈": r"\lceil", "⌉": r"\rceil", "∅": r"\emptyset", "⊤": r"\top",
    "⊥": r"\bot", "∣": r"\mid", "∤": r"\nmid", "∇": r"\nabla",
    "√": r"\surd", "∝": r"\propto", "≪": r"\ll", "≫": r"\gg",
    "⊗": r"\otimes", "⊕": r"\oplus", "⁻¹": "^{-1}", "⁻": "^{-1}",
    "½": r"\tfrac{1}{2}", "∮": r"\oint", "⨆": r"\bigsqcup", "⬝": r"\cdot",
    "𝓝": r"\mathcal{N}", "𝓕": r"\mathcal{F}", "ᶠ": "^{f}",
    "ᵥ": "_{v}", "ᴴ": "^{H}", "ᶜ": "^{c}", "ᵐ": "^{m}", "ˢ": "^{s}",
    "ᵀ": "^{T}", "↥": r"\uparrow",
    "²": "^{2}", "³": "^{3}", "₀": "_{0}", "₁": "_{1}", "₂": "_{2}",
    "₃": "_{3}", "₄": "_{4}", "₅": "_{5}", "₆": "_{6}", "₇": "_{7}",
    "₈": "_{8}", "₉": "_{9}",
}
SYM_SORTED = sorted(SYM.items(), key=lambda kv: -len(kv[0]))
MULTI = [
    ("<=>", r"\leftrightarrow"), ("=>", r"\Rightarrow"), ("->", r"\to"),
    ("<-", r"\leftarrow"), (">=", r"\ge"), ("<=", r"\le"),
    ("!=", r"\ne"), ("...", r"\ldots"),
]
OPENERS = {"(": ")", "[": "]", "{": "}", "⦃": "⦄"}


def split_top(text: str, sep: str = ":") -> tuple[str | None, str]:
    """Split at the first top-level separator, ignoring nested brackets."""
    depth = 0
    for i, c in enumerate(text):
        if c in OPENERS:
            depth += 1
        elif c in OPENERS.values():
            depth = max(0, depth - 1)
        elif c == sep and depth == 0:
            return text[:i], text[i + 1:]
    return None, text


def take_atom(text: str, i: int) -> tuple[str, int]:
    """Take the token after ^ or _ (braced group, parenthesised group, or atom)."""
    while i < len(text) and text[i].isspace():
        i += 1
    start = i
    if i < len(text) and text[i] in "({":
        opener = text[i]
        closer = ")" if opener == "(" else "}"
        depth = 0
        while i < len(text):
            if text[i] == opener:
                depth += 1
            elif text[i] == closer:
                depth -= 1
                if depth == 0:
                    i += 1
                    break
            i += 1
        return text[start + 1:i - 1], i
    match = re.match(r"[\w.']+", text[i:])
    if match:
        return match.group(0), i + len(match.group(0))
    if i < len(text):
        return text[i], i + 1
    return "", i


def ident_tex(word: str) -> str:
    """Render a Lean identifier, keeping dotted names together where possible."""
    parts = word.split(".")
    if all(not (len(p) == 1 and p.isalpha()) for p in parts):
        return r"\mathrm{" + word.replace("_", r"\_") + "}"
    rendered = []
    for part in parts:
        if len(part) == 1 and part.isalpha():
            rendered.append(part)
        elif re.fullmatch(r"[A-Za-z]'+", part):
            rendered.append(part)
        elif re.fullmatch(r"[A-Za-z][0-9]+", part):
            rendered.append(f"{part[0]}_{{{part[1:]}}}")
        elif part:
            rendered.append(r"\mathrm{" + part.replace("_", r"\_") + "}")
        else:
            rendered.append("")
    return ".".join(rendered)


def convert_expr(text: str) -> str:
    """Mechanical LaTeX rendering of a Lean type expression."""
    out: list[str] = []
    i = 0
    while i < len(text):
        c = text[i]
        if c.isspace():
            while i < len(text) and text[i].isspace():
                i += 1
            out.append(r"\ ")
            continue

        matched = False
        for key, value in SYM_SORTED:
            if text.startswith(key, i):
                out.append(value)
                i += len(key)
                # A control word must not be glued to a following letter
                # (\Vertz, \cdotx); close it explicitly.
                if (re.fullmatch(r"\\[A-Za-z]+", value)
                        and i < len(text) and text[i].isalpha()):
                    out.append("{}")
                matched = True
                break
        if matched:
            continue
        for key, value in MULTI:
            if text.startswith(key, i):
                out.append(value)
                i += len(key)
                if i < len(text) and text[i].isalpha():
                    out.append("{}")
                matched = True
                break
        if matched:
            continue

        if c in "^_":
            arg, i = take_atom(text, i + 1)
            out.append(("^{" if c == "^" else "_{") + convert_expr(arg) + "}")
            continue
        if c.isalpha():
            match = re.match(r"[A-Za-z][A-Za-z0-9.']*", text[i:])
            if not match:
                out.append(r"\text{" + c + "}")
                i += 1
                continue
            word = match.group(0)
            i += len(word)
            if word == "fun":
                out.append(r"\lambda")
            elif word in {"if", "then", "else", "let", "in", "match", "with"}:
                out.append(r"\text{" + word + "}")
            else:
                out.append(ident_tex(word))
            continue
        if c.isdigit():
            match = re.match(r"[0-9]+(?:\.[0-9]+)?", text[i:])
            if not match:
                out.append(c)
                i += 1
                continue
            word = match.group(0)
            i += len(word)
            out.append(word)
            continue
        if c in "{}":
            out.append("\\" + c)
        elif c in "%&#$":
            out.append("\\" + c)
        elif c == "|":
            out.append(r"\vert")
            if i + 1 < len(text) and text[i + 1].isalpha():
                out.append("{}")
        elif c == "*":
            out.append(r"\cdot")
            if i + 1 < len(text) and text[i + 1].isalpha():
                out.append("{}")
        elif c == "\\":
            out.append(r"\backslash")
            if i + 1 < len(text) and text[i + 1].isalpha():
                out.append("{}")
        else:
            out.append(c)
        i += 1
    return "".join(out)


def cleanup_latex(text: str) -> str:
    """Remove redundant control spaces around operators and opening brackets."""
    for op in ["=", "+", "-", "<", ">", "/", ":", "(", "["]:
        text = text.replace(r"\ " + op, op).replace(op + r"\ ", op)
    for op in [")", "]"]:
        text = text.replace(r"\ " + op, op)
    for token in [r"\cdot", r"\to", r"\le", r"\ge", r"\ne", r"\times",
                  r"\Rightarrow", r"\leftrightarrow", r"\mapsto"]:
        # Only remove the space *before* the macro: removing the space after
        # would glue a control word to a following letter (\cdotb, \Rightarrows).
        text = text.replace(r"\ " + token, token)
    text = text.replace(r"\ ^", "^").replace(r"\ _", "_")
    text = re.sub(r"(\\ ){2,}", r"\\ ", text)
    return re.sub(r"\s{2,}", " ", text).strip()


def name_tex(name: str) -> str:
    out = []
    for index, c in enumerate(name):
        if c in SYM:
            value = SYM[c]
            out.append(value)
            if (re.fullmatch(r"\\[A-Za-z]+", value)
                    and index + 1 < len(name) and name[index + 1].isalpha()):
                out.append("{}")
        elif c == "_":
            out.append(r"\_")
        else:
            out.append(c)
    return re.sub(r"([A-Za-z])([0-9]+)", r"\1_{\2}", "".join(out))


def statement_text(lines: list[str], index: int, pos: int) -> str:
    """Extract the binders-and-type text of a declaration, without its body."""
    line = lines[index]
    chunks: list[str] = []
    depth = 0
    for i in range(index, len(lines)):
        chunk = lines[i]
        if i == index:
            chunk = chunk[pos:]
        stripped = chunk.lstrip()
        if depth == 0 and (stripped == "where" or stripped.startswith("where ")):
            break
        cut = None
        for j, c in enumerate(chunk):
            if c in OPENERS:
                depth += 1
            elif c in OPENERS.values():
                depth = max(0, depth - 1)
            elif c == ":" and j + 1 < len(chunk) and chunk[j + 1] == "=" and depth == 0:
                cut = j
                break
        if cut is not None:
            chunks.append(chunk[:cut])
            break
        chunks.append(chunk)
    return re.sub(r"\s+", " ", " ".join(chunks)).strip()


def latex_statement(statement: str) -> str:
    """Render a Lean theorem statement as inline LaTeX."""
    statement = statement.strip()
    if not statement:
        return ""
    prefix, typ = split_top(statement, ":")
    if prefix is None:
        prefix, typ = "", statement

    groups: list[tuple[str, str]] = []
    i = 0
    while prefix.strip() and i < len(prefix):
        if prefix[i].isspace():
            i += 1
            continue
        opener = prefix[i]
        if opener not in OPENERS:
            groups = []
            break
        closer = OPENERS[opener]
        depth = 0
        j = i
        while j < len(prefix):
            if prefix[j] == opener:
                depth += 1
            elif prefix[j] == closer:
                depth -= 1
                if depth == 0:
                    break
            j += 1
        if j >= len(prefix):
            groups = []
            break
        groups.append((opener, prefix[i + 1:j]))
        i = j + 1

    if not groups:
        return "$" + cleanup_latex(convert_expr(statement)) + "$"

    parts = []
    for opener, content in groups:
        if opener == "[":
            parts.append(r"\forall\," + "[" + cleanup_latex(convert_expr(content)) + "],")
            continue
        names, binder_type = split_top(content, ":")
        if names is None:
            parts.append(r"\forall\," + cleanup_latex(convert_expr(content)) + ",")
            continue
        names = re.sub(r"\s+", " ", names.strip())
        rendered_names = r"\,".join(name_tex(n) for n in names.split(" "))
        parts.append(
            r"\forall\," + rendered_names + " : "
            + cleanup_latex(convert_expr(binder_type.strip()))
            + ","
        )
    parts.append(cleanup_latex(convert_expr(typ.strip())))
    return "$" + r"\ ".join(parts) + "$"


def scan(path: Path) -> tuple[list[tuple[int, str, str, str]], list[int]]:
    stripped = strip_comments(path.read_text(encoding="utf-8"))
    lines = stripped.split("\n")
    decls: list[tuple[int, str, str, str]] = []
    examples: list[int] = []
    for number, line in enumerate(lines, start=1):
        match = DECL_RE.match(line)
        if match:
            kind, name = match.group(1), match.group(2)
            statement = statement_text(lines, number - 1, match.end())
            decls.append((number, kind, name, latex_statement(statement)))
        elif EXAMPLE_RE.match(line):
            examples.append(number)
    return decls, examples


all_files = sorted(
    path for path in ROOT.rglob("*.lean")
    if "target" not in path.parts and ".lake" not in path.parts
)
generated = [p for p in all_files if GENERATED_RE.match(p.relative_to(ROOT).as_posix())]
files = [p for p in all_files if not GENERATED_RE.match(p.relative_to(ROOT).as_posix())]

by_topic: dict[str, list[dict]] = {}
no_proofs: list[tuple[str, int]] = []
examples_all: list[tuple[str, int]] = []
sorries: list[str] = []
axioms: list[str] = []

for path in files:
    rel = path.relative_to(ROOT).as_posix()
    topic = rel.split("/", 1)[0]
    decls, examples = scan(path)
    by_topic.setdefault(topic, []).append({
        "rel": rel,
        "decls": decls,
        "examples": examples,
    })
    if not decls:
        no_proofs.append((rel, len(examples)))
    examples_all.extend((rel, line) for line in examples)

    stripped = strip_comments(path.read_text(encoding="utf-8"))
    if re.search(r"\b(sorry|admit)\b", stripped):
        sorries.append(rel)
    if re.search(r"^\s*axiom\b", stripped, re.MULTILINE):
        axioms.append(rel)

all_decls = [d for entries in by_topic.values() for entry in entries for d in entry["decls"]]
n_theorems = sum(1 for _, kind, _, _ in all_decls if kind == "theorem")
n_lemmas = sum(1 for _, kind, _, _ in all_decls if kind == "lemma")


def count(topic: str, kind: str) -> int:
    return sum(
        1 for entry in by_topic[topic] for _, k, _, _ in entry["decls"] if k == kind
    )


lines: list[str] = []
add = lines.append

add("# Lean proof index")
add("")
add(
    "Every named `theorem` and `lemma` declaration under "
    "`the-final-letter/topics/**/*.lean`, with a link to the declaration line "
    "and a LaTeX rendering of its statement."
)
add("")
add(
    f"**Coverage:** {len(by_topic)} topic folders · {len(files)} Lean files · "
    f"**{len(all_decls):,} named proofs** ({n_theorems:,} theorems, "
    f"{n_lemmas:,} lemmas) · {len(examples_all)} anonymous `example` proofs."
)
if generated:
    add("")
    add(
        f"The {len(generated)} generated `DensityC*_*.lean` certificate chunks "
        "are excluded from the declaration index; see "
        "[Generated certificates](#generated-certificates)."
    )
add("")
add("**Visualisations:** [concept graph](lean-graph.html) · [proof–conjecture graph](lean-conjecture-graph.html).")
add("")
add(
    "Generated by [`tools/build_lean_index.py`](tools/build_lean_index.py). "
    "Regenerate with:"
)
add("")
add("```bash")
add("python3 the-final-letter/topics/tools/build_lean_index.py")
add("```")
add("")
add("## How to read this index")
add("")
add("- Each row links to the **line of the declaration** in its Lean file.")
add(
    "- Scope: named `theorem` and `lemma` declarations. `def`, `instance`, "
    "`abbrev`, `structure` and `inductive` bodies are definitions rather than "
    "named proofs, so they are excluded; anonymous `example`s are listed "
    "separately."
)
add(
    "- Comments and string literals are stripped before scanning, so prose "
    "mentioning a theorem is not counted."
)
add(
    "- The **Statement (LaTeX)** column is a mechanical rendering of the Lean "
    "type, not a hand-edited mathematical statement. Binders become `\\forall` "
    "clauses, identifiers are set in `\\mathrm`, and Lean-specific syntax such "
    "as `∫ ... in ...` is kept literal. The Lean source is authoritative."
)
add(
    "- The index records names, statements and locations. It does not re-run "
    "Lean; see each topic's `lean/check.sh` for its build."
)
if not sorries and not axioms:
    add(
        "- A comment-stripped scan found **no `sorry`, `admit` or `axiom`** "
        "in these files."
    )
else:
    add(
        "- **Integrity finding:** forbidden tokens were found in "
        + ", ".join(f"`{x}`" for x in sorted(set(sorries + axioms)))
        + "."
    )
add("")
add("## Summary by topic")
add("")
add("| Topic | Lean files | Theorems | Lemmas | Proofs |")
add("|---|---:|---:|---:|---:|")
for topic in sorted(by_topic):
    entries = by_topic[topic]
    add(
        f"| [`{topic}`](#{topic}) | {len(entries)} | {count(topic, 'theorem'):,} | "
        f"{count(topic, 'lemma'):,} | {sum(len(e['decls']) for e in entries):,} |"
    )
add(
    f"| **Total** | **{len(files)}** | **{n_theorems:,}** | "
    f"**{n_lemmas:,}** | **{len(all_decls):,}** |"
)
add("")

for topic in sorted(by_topic):
    entries = by_topic[topic]
    total = sum(len(e["decls"]) for e in entries)
    add(f"## {topic}")
    add("")
    add(
        f"{len(entries)} Lean {'file' if len(entries) == 1 else 'files'} · "
        f"{total:,} named {'proof' if total == 1 else 'proofs'}."
    )
    add("")
    for entry in entries:
        rel = entry["rel"]
        decls = entry["decls"]
        add(f"### [`{rel}`]({rel}) — {len(decls):,} " + ("proof" if len(decls) == 1 else "proofs"))
        add("")
        if not decls:
            add("_No named `theorem` or `lemma` declarations._")
            if entry["examples"]:
                add("")
                add(
                    "Anonymous examples: "
                    + ", ".join(
                        f"[line {n}]({rel}#L{n})" for n in entry["examples"]
                    )
                    + "."
                )
            add("")
            continue
        add("| Line | Kind | Proof | Statement (LaTeX) |")
        add("|---:|---|---|---|")
        for number, kind, name, latex in decls:
            add(f"| [{number}]({rel}#L{number}) | {kind} | `{name}` | {latex} |")
        add("")

add("## Anonymous `example` proofs")
add("")
if examples_all:
    add("| File | Line |")
    add("|---|---:|")
    for rel, number in examples_all:
        add(f"| [`{rel}`]({rel}) | [{number}]({rel}#L{number}) |")
else:
    add("_None._")
add("")

add("## Lean files with no named proofs")
add("")
if no_proofs:
    for rel, n_examples in no_proofs:
        suffix = f" ({n_examples} anonymous example{'s' if n_examples != 1 else ''})" if n_examples else ""
        add(f"- [`{rel}`]({rel}){suffix}")
else:
    add("_None._")
add("")

add("## Generated certificates")
add("")
if generated:
    add(
        "These files are emitted by "
        "[`prime-spectrum-tensor/lean/gen/panels.py`]"
        "(prime-spectrum-tensor/lean/gen/panels.py) and are not expanded into "
        "the declaration index.  Their entry point is "
        "[`prime-spectrum-tensor/lean/DensityCertificates.lean`]"
        "(prime-spectrum-tensor/lean/DensityCertificates.lean), which proves "
        "`gaussianGram4_posDef`."
    )
    add("")
    add("| File |")
    add("|---|")
    for path in generated:
        rel = path.relative_to(ROOT).as_posix()
        add(f"| [`{rel}`]({rel}) |")
else:
    add("_None._")
add("")

(ROOT / "index-lean.md").write_text("\n".join(lines), encoding="utf-8")
print(
    f"wrote {ROOT / 'index-lean.md'} with {len(by_topic)} topics, "
    f"{len(files)} Lean files and {len(all_decls)} named proofs"
)
