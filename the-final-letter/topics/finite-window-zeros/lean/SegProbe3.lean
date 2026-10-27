import Cert
namespace FiniteWindowZeros
open PartialTail

def Sseg : Cx := ⟨⟨(1 / 2 : ℚ), (1 / 2 : ℚ)⟩, ⟨(5 : ℚ), (500001 / 100000 : ℚ)⟩⟩
#eval ((sumBox (params 10) S0).re.lo : ℚ).toFloat
#eval ((sumBox (params 10) Sseg).re.lo : ℚ).toFloat
#eval ((sumBox (params 20) S0).re.lo : ℚ).toFloat
#eval ((sumBox (params 20) Sseg).re.lo : ℚ).toFloat
#eval ((sumBox (params 40) S0).re.lo : ℚ).toFloat
#eval ((sumBox (params 40) Sseg).re.lo : ℚ).toFloat

end FiniteWindowZeros
