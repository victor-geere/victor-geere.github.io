import FixedBox
import BigCheck

noncomputable section
namespace FiniteWindowZeros
open PartialTail

theorem blockFold_1e6 :
    Cx.mem (∑ m ∈ Finset.range (1000 * 1000), pairTerm s14 m)
      (foldPairs g12 g12_pos (blockPairs 1000 1000 S14 s14)) :=
  blockFold_mem g12_pos allOK_fast_1000000 (by norm_num) mem_S14

end FiniteWindowZeros
