import re
from pathlib import Path

import pytest

ROOT = Path(__file__).resolve().parents[1]
sys_path = str(ROOT / "python")
import sys

sys.path.insert(0, sys_path)

import audit  # noqa: E402


def test_audit_matrix_is_valid():
    audit.validate()
    ids = [row["id"] for row in audit.AUDIT_ROWS]
    assert len(ids) == len(set(ids)) == 22


def test_audit_classes_are_known_and_counted():
    assert set(audit.summary()) == {"E1", "E2", "E3", "X", "F", "O"}
    assert audit.summary() == {"E1": 6, "E2": 7, "E3": 5, "X": 1, "F": 1, "O": 2}
    for row in audit.AUDIT_ROWS:
        assert row["classification"] in audit.CLASSES


def test_exact_rows_are_not_given_fallback_evaluators():
    for row in audit.AUDIT_ROWS:
        if row["classification"] in {"E1", "E2", "E3"}:
            assert row["exact_transform"] == "yes"
            assert "fallback only" not in row["evaluator"].lower()
        if row["classification"] == "F":
            assert row["exact_transform"] == "no"
            assert "fallback" in row["evaluator"].lower()
        if row["classification"] == "O":
            assert row["exact_transform"] == "open"
            assert row["evaluator"].lower().startswith("not assigned")


def test_markdown_audit_contains_every_row():
    text = (ROOT / "EXACTNESS-AUDIT.md").read_text()
    ids = set(re.findall(r"^\| (A\d+) \|", text, flags=re.MULTILINE))
    assert ids == {row["id"] for row in audit.AUDIT_ROWS}
    assert "**No RH proof yet.**" in text


def test_every_audited_object_has_evidence_and_a_policy():
    for row in audit.AUDIT_ROWS:
        assert row["evidence"].strip()
        assert row["evaluator"].strip()
        assert row["domain"].strip()
        assert row["convergence"].strip()


def test_audit_covers_all_transform_kinds():
    kinds = {row["kind"] for row in audit.AUDIT_ROWS}
    assert {"series", "integral", "product", "contour", "evaluator"} <= kinds
