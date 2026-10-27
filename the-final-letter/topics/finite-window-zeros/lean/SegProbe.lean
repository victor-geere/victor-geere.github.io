import Topic
import CpowBox
namespace FiniteWindowZeros
open PartialTail

def Sseg : Cx := ⟨⟨(1 / 2 : ℚ), (1 / 2 : ℚ)⟩, ⟨(5 : ℚ), (500001 / 100000 : ℚ)⟩⟩
#eval (Sseg.im.hi : ℚ)
#eval (Sseg.im.lo : ℚ)
#eval (Sseg.im.hi - Sseg.im.lo : ℚ)

end FiniteWindowZeros
