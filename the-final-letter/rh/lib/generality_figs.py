"""Figures for 011 — the generality audit of Routes A/B/C.

Self-contained SVG.  Run:  python3 lib/generality_figs.py [outdir]
"""
from __future__ import annotations
import os, sys

INK, MUTED, RULE, ACC2, ACC, GREEN, RED, PURPLE, AMBER = (
    "#17202a", "#5b6b7c", "#d8dee6", "#1f4e79", "#7a2e2e", "#1e6b3a", "#8a1c1c",
    "#7a4e9e", "#8a5a14")


def head(w, h, title):
    return (f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {w} {h}" width="100%" '
            f'style="max-width:{w}px;font-family:Georgia,serif">'
            f'<defs><marker id="ar" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="6" '
            f'markerHeight="6" orient="auto"><path d="M0,0 L10,5 L0,10 z" fill="{ACC2}"/></marker></defs>'
            f'<rect width="{w}" height="{h}" fill="#fdfdfb"/>'
            f'<text x="{w/2}" y="24" text-anchor="middle" font-size="15" fill="{INK}">{title}</text>')


def box(s, x, y, w, h, lines, stroke, fill, fs=11.5, title=None):
    s.append(f'<rect x="{x}" y="{y}" width="{w}" height="{h}" rx="5" fill="{fill}" stroke="{stroke}" stroke-width="1.5"/>')
    o = 0
    if title:
        s.append(f'<text x="{x+w/2:.0f}" y="{y+18}" text-anchor="middle" font-size="12" fill="{stroke}">{title}</text>')
        o = 16
    for i, ln in enumerate(lines):
        s.append(f'<text x="{x+w/2:.0f}" y="{y+o+17+i*14:.0f}" text-anchor="middle" font-size="{fs}" fill="{INK}">{ln}</text>')


def fig_layers(path):
    W, H = 920, 470
    s = [head(W, H, "What is already general (green) and what every new instantiation must supply (amber)")]
    L, M, R = 40, 380, 660           # left edge, column split, right edge
    cw = M - L - 20                  # core column width
    iw = R - M - 20
    rows = [
        ("Route A", ["exists_unique_root_of_sign_change"], ["an interval evaluator for f, f\u2032",
         "(sign of f at the ends,", "a one-signed bound for f\u2032)"]),
        ("Route B", ["turing_reduction   (any Finset \u03b1)", "routeB_reduction_general   (\u2200 f)"],
         ["functional equation  f(1\u2212s) = f(s)", "reality  f(conj s) = conj(f s)",
          "zero data + orders, logDeriv evaluator"]),
        ("Route C", ["validated_truncation_bound", "(n\u2011tail form: \u00a74)"],
         ["the explicit formula for the object", "a bound per tail",
          "(prime side needs an Euler product)"]),
    ]
    y = 52
    for name, core, inst in rows:
        h = max(52, 24 + 15 * max(len(core), len(inst)))
        s.append(f'<text x="{L-6}" y="{y+h/2+4:.0f}" text-anchor="end" font-size="13.5" fill="{ACC}">{name}</text>')
        box(s, L, y, cw, h, core, GREEN, "#f6fbf7", title="theorem core \u2014 ALREADY GENERAL")
        box(s, M + 20, y, iw, h, inst, AMBER, "#fdf9f0", title="instantiation \u2014 function-specific")
        s.append(f'<line x1="{M}" y1="{y}" x2="{M+14}" y2="{y+h/2:.0f}" stroke="{ACC2}" stroke-width="1.5" marker-end="url(#ar)"/>')
        y += h + 26
    s.append(f'<text x="{W/2:.0f}" y="{y+6:.0f}" text-anchor="middle" font-size="11.5" fill="{MUTED}">'
             f'the green column is what the Lean already quantifies over; the amber column is the price of a new object</text>')
    s.append('</svg>')
    open(path, "w", encoding="utf-8").write("\n".join(s))


def fig_ladder(path):
    W, H = 900, 400
    s = [head(W, H, "Four readings of \u201cgeneralise\u201d, and how far each one goes")]
    items = [
        ("L1", "generalise the STATEMENTS", "DONE \u2014 the 010 theorems are already \u2200 f and \u2200 Finset \u03b1",
         GREEN, "#f6fbf7"),
        ("L2", "generalise the INSTANTIATION", "PARTIAL \u2014 Dirichlet L: FE normalisation proved; two named lemmas missing",
         AMBER, "#fdf9f0"),
        ("L3", "generalise the METHOD", "TRANSFERABLE \u2014 enclosure\u21d2sign\u21d2root; count squeeze; pointwise\u21d2locally uniform\u21d2Weierstrass",
         ACC2, "#f4f8fc"),
        ("L4", "generalise to ALL zeros", "IMPOSSIBLE \u2014 that is RH, and no finite certificate reaches it",
         RED, "#fdf6f6"),
    ]
    y = 54
    for tag, title, verdict, col, fill in items:
        s.append(f'<rect x="40" y="{y}" width="60" height="60" rx="6" fill="{col}"/>')
        s.append(f'<text x="70" y="{y+38}" text-anchor="middle" font-size="20" fill="#fff">{tag}</text>')
        s.append(f'<rect x="108" y="{y}" width="752" height="60" rx="6" fill="{fill}" stroke="{col}" stroke-width="1.4"/>')
        s.append(f'<text x="126" y="{y+25}" font-size="13.5" fill="{col}">{title}</text>')
        s.append(f'<text x="126" y="{y+46}" font-size="11.5" fill="{INK}">{verdict}</text>')
        y += 76
    s.append('</svg>')
    open(path, "w", encoding="utf-8").write("\n".join(s))


def main():
    out = sys.argv[1] if len(sys.argv) > 1 else "research/twin-prime-parity/011/figures"
    os.makedirs(out, exist_ok=True)
    fig_layers(os.path.join(out, "general-layers.svg"))
    fig_ladder(os.path.join(out, "general-ladder.svg"))
    print("wrote general-layers.svg, general-ladder.svg to", out)


if __name__ == "__main__":
    main()
