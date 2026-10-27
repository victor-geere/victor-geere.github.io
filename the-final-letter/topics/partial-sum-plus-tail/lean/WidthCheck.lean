import Width
import Replay
import ReplayAtoms

namespace PartialTail.Replay

open PartialTail

/-- The ζ(2) replay certificate passes the width checker at the target `10⁻⁴`,
with every atom discharged by `ReplayAtoms`.  (The actual width is ≈ `1.5·10⁻⁵`;
`10⁻⁴` leaves a safety margin against tight rational arithmetic in the checker.) -/
theorem cert_wfWidth : cert.wfWidth A ((1 : ℚ) / 10000) = true := by
  native_decide

/-- Consequence of the width-certification soundness theorem: the ζ(2) replay is
enclosed in a box of width at most `10⁻⁴`. -/
theorem cert_mem_width :
    Cx.mem (cert.eval σ) cert.box ∧ cert.box.width ≤ ((1 : ℚ) / 10000) :=
  Expr.wfWidth_sound atom_mem' cert ((1 : ℚ) / 10000) cert_wfWidth

end PartialTail.Replay
