import Cert
namespace FiniteWindowZeros
open PartialTail

def Sseg : Cx := ⟨⟨(1 / 2 : ℚ), (1 / 2 : ℚ)⟩, ⟨(5 : ℚ), (500001 / 100000 : ℚ)⟩⟩
#eval ((sumBox (params 2) S0).re.lo : ℚ).toFloat
#eval ((sumBox (params 2) Sseg).re.lo : ℚ).toFloat
#eval ((sumBox (params 2) S0).re.hi : ℚ).toFloat
#eval ((sumBox (params 2) Sseg).re.hi : ℚ).toFloat

end FiniteWindowZeros
