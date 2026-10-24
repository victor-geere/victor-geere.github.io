import Mathlib

namespace FreeOrbit

/-- A free action of a finite group splits the set into orbits of size `|G|`, so
`|G|` divides `|X|`. -/
theorem card_dvd_card_of_free_action
    {G X : Type*} [Group G] [MulAction G X] [Fintype G] [Fintype X]
    (hfree : ∀ g : G, ∀ x : X, g • x = x → g = 1) :
    Fintype.card G ∣ Fintype.card X := by
  classical
  have hstab : ∀ x : X, MulAction.stabilizer G x = ⊥ := by
    intro x
    ext g
    rw [Subgroup.mem_bot, MulAction.mem_stabilizer_iff]
    exact ⟨fun h => hfree g x h, fun h => by rw [h]; exact MulAction.one_smul x⟩
  have horb : ∀ ω : Quotient (MulAction.orbitRel G X),
      Fintype.card (G ⧸ MulAction.stabilizer G ω.out) = Fintype.card G := by
    intro ω
    simp only [hstab ω.out]
    exact Fintype.card_congr (QuotientGroup.quotientBot (G := G))
  rw [Fintype.card_congr (MulAction.selfEquivSigmaOrbitsQuotientStabilizer (G := G) (X := X)),
    Fintype.card_sigma]
  refine Finset.dvd_sum ?_
  intro ω _
  rw [horb ω]

end FreeOrbit
