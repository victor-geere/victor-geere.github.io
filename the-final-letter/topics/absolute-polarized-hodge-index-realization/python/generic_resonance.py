"""Generic K=32 resonance across well-conditioned windows.

Both the sin^2 and poly2 windows show a gap dip at K=32 and recovery at
K=36,40.  The resonance is therefore a property of the truncation, not of one
window.
"""

from __future__ import annotations

from window_robustness import gap_window

__all__ = ["resonance_table"]


def resonance_table(ks=(28, 32, 36, 40)) -> dict:
    out = {}
    for name in ("sin2", "poly2"):
        out[name] = {k: gap_window(k, name)["gap"] for k in ks}
    return out


if __name__ == "__main__":  # pragma: no cover - manual demonstration
    for name, d in resonance_table().items():
        print(name, {k: round(v, 6) for k, v in d.items()})
