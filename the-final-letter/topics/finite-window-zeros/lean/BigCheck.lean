import ZetaBox14

noncomputable section
namespace FiniteWindowZeros
open PartialTail

theorem allOK_fast_1000000 : allOK (paramsFast 1000000) S14 = true := by
  native_decide

end FiniteWindowZeros
