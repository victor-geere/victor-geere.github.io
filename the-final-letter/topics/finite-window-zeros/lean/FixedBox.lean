import Interval
import BoxNorm

noncomputable section
namespace FiniteWindowZeros
open PartialTail

/-- Snap a real box outward to the grid `g`. -/
def snapIv (g : ℚ) (hg : 0 < g) (I : Iv) : Iv :=
  ⟨gridDown g I.lo, gridUp g I.hi⟩

theorem snapIv_mem {g : ℚ} (hg : 0 < g) {I : Iv} {x : ℝ} (hx : I.memR x) :
    (snapIv g hg I).memR x := by
  constructor
  · have h1 : (gridDown g I.lo : ℚ) ≤ I.lo := gridDown_le hg
    exact le_trans (by exact_mod_cast h1) hx.1
  · have h2 : I.hi ≤ gridUp g I.hi := le_gridUp hg
    exact le_trans hx.2 (by exact_mod_cast h2)

/-- Snap a complex box outward to the grid `g`. -/
def snapCx (g : ℚ) (hg : 0 < g) (B : Cx) : Cx :=
  ⟨snapIv g hg B.re, snapIv g hg B.im⟩

theorem snapCx_mem {g : ℚ} (hg : 0 < g) {B : Cx} {z : ℂ} (hz : Cx.mem z B) :
    Cx.mem z (snapCx g hg B) :=
  ⟨snapIv_mem hg hz.1, snapIv_mem hg hz.2⟩

/-- The zero complex box `[0,0] + [0,0]i`. -/
def zeroCx : Cx := ⟨⟨0, 0⟩, ⟨0, 0⟩⟩

theorem zeroCx_mem : Cx.mem 0 zeroCx := by
  constructor <;> simp [zeroCx, Cx.mem, Iv.memR]

/-- Snap-rounded fold of pair boxes, right-associated. -/
def foldSnap (g : ℚ) (hg : 0 < g) (ps : List CpowPair) (S : Cx) : Cx :=
  ps.foldr (fun p acc => snapCx g hg ((pairBox p S).add acc)) zeroCx

theorem foldSnap_mem {g : ℚ} (hg : 0 < g) (ps : List CpowPair) (S : Cx) (s : ℂ)
    (hs : Cx.mem s S) (h : ∀ p ∈ ps, PairConditions p S) :
    Cx.mem (sumValue ps s) (foldSnap g hg ps S) := by
  induction ps with
  | nil =>
      simp [sumValue, foldSnap, zeroCx_mem]
  | cons p ps ih =>
      have hp : PairConditions p S := h p (by simp)
      have hps : ∀ q ∈ ps, PairConditions q S := fun q hq => h q (by simp [hq])
      have hrec := ih hps
      rw [sumValue, List.map_cons, List.sum_cons, foldSnap, List.foldr_cons]
      exact snapCx_mem hg (Cx.mem_add (pairBox_mem hs hp) hrec)

/-- Grid denominator `10^12`. -/
def g12 : ℚ := 1 / 1000000000000

theorem g12_pos : 0 < g12 := by norm_num [g12]

/-- Integer-rounded snapped real box. -/
def snapIvInt (g : ℚ) (hg : 0 < g) (I : Iv) : Iv :=
  ⟨gridDownInt g I.lo, gridUpInt g I.hi⟩

theorem snapIvInt_mem {g : ℚ} (hg : 0 < g) {I : Iv} {x : ℝ} (hx : I.memR x) :
    (snapIvInt g hg I).memR x := by
  constructor
  · have h1 : (gridDownInt g I.lo : ℚ) ≤ I.lo := gridDownInt_le hg
    exact le_trans (by exact_mod_cast h1) hx.1
  · have h2 : I.hi ≤ gridUpInt g I.hi := le_gridUpInt hg
    exact le_trans hx.2 (by exact_mod_cast h2)

def snapCxInt (g : ℚ) (hg : 0 < g) (B : Cx) : Cx :=
  ⟨snapIvInt g hg B.re, snapIvInt g hg B.im⟩

theorem snapCxInt_mem {g : ℚ} (hg : 0 < g) {B : Cx} {z : ℂ} (hz : Cx.mem z B) :
    Cx.mem z (snapCxInt g hg B) :=
  ⟨snapIvInt_mem hg hz.1, snapIvInt_mem hg hz.2⟩

def foldSnapInt (g : ℚ) (hg : 0 < g) (ps : List CpowPair) (S : Cx) : Cx :=
  ps.foldr (fun p acc => snapCxInt g hg ((pairBox p S).add acc)) zeroCx

theorem foldSnapInt_mem {g : ℚ} (hg : 0 < g) (ps : List CpowPair) (S : Cx) (s : ℂ)
    (hs : Cx.mem s S) (h : ∀ p ∈ ps, PairConditions p S) :
    Cx.mem (sumValue ps s) (foldSnapInt g hg ps S) := by
  induction ps with
  | nil =>
      simp [sumValue, foldSnapInt, zeroCx_mem]
  | cons p ps ih =>
      have hp : PairConditions p S := h p (by simp)
      have hps : ∀ q ∈ ps, PairConditions q S := fun q hq => h q (by simp [hq])
      have hrec := ih hps
      rw [sumValue, List.map_cons, List.sum_cons, foldSnapInt, List.foldr_cons]
      exact snapCxInt_mem hg (Cx.mem_add (pairBox_mem hs hp) hrec)

/-- Fold a list of complex boxes with snapping after each addition. -/
def foldBlocks (g : ℚ) (hg : 0 < g) (boxes : List Cx) : Cx :=
  boxes.foldr (fun b acc => snapCxInt g hg (b.add acc)) zeroCx

theorem foldBlocks_mem {g : ℚ} (hg : 0 < g) (boxes : List Cx) (vals : List ℂ)
    (hlen : boxes.length = vals.length)
    (h : ∀ b v, (b, v) ∈ boxes.zip vals → Cx.mem v b) :
    Cx.mem vals.sum (foldBlocks g hg boxes) := by
  induction boxes generalizing vals with
  | nil =>
      cases vals with
      | nil => simpa [foldBlocks, zeroCx_mem]
      | cons v vs => simp at hlen
  | cons b bs ih =>
      cases vals with
      | nil => simp at hlen
      | cons v vs =>
          have hb : Cx.mem v b := h b v (by simp)
          have htail : ∀ b' v', (b', v') ∈ bs.zip vs → Cx.mem v' b' := by
            intro b' v' hmem
            exact h b' v' (by simp [hmem])
          have hlen' : bs.length = vs.length := by simpa using hlen
          have hrec := ih vs hlen' htail
          rw [List.sum_cons, foldBlocks, List.foldr_cons]
          exact snapCxInt_mem hg (Cx.mem_add hb hrec)

/-- Sum of a mapped range as a `Finset.sum`. -/
theorem list_sum_range (B : ℕ) (f : ℕ → ℂ) :
    (List.map f (List.range B)).sum = ∑ j ∈ Finset.range B, f j := by
  induction B with
  | zero => simp
  | succ B ih =>
      rw [List.range_succ, List.map_append, List.sum_append, ih]
      simp [Finset.sum_range_succ, List.sum_cons]

/-- The values of the blocks of size `M`. -/
def blockVals (B M : ℕ) (s : ℂ) : List ℂ :=
  (List.range B).map (fun j => ∑ i ∈ Finset.range M, pairTerm s (j * M + i))

theorem blockVals_sum_finset (B M : ℕ) (s : ℂ) :
    (blockVals B M s).sum =
      ∑ j ∈ Finset.range B, ∑ i ∈ Finset.range M, pairTerm s (j * M + i) := by
  rw [blockVals, list_sum_range]

theorem blockVals_sum (B M : ℕ) (s : ℂ) :
    (blockVals B M s).sum = ∑ m ∈ Finset.range (B * M), pairTerm s m := by
  rw [blockVals_sum_finset, sum_blocks_eq]

/-- Fold a list of `(box, value)` pairs with snapping. -/
def foldPairs (g : ℚ) (hg : 0 < g) (pairs : List (Cx × ℂ)) : Cx :=
  pairs.foldr (fun p acc => snapCxInt g hg (p.1.add acc)) zeroCx

theorem foldPairs_mem {g : ℚ} (hg : 0 < g) (pairs : List (Cx × ℂ))
    (h : ∀ p ∈ pairs, Cx.mem p.2 p.1) :
    Cx.mem (pairs.map Prod.snd).sum (foldPairs g hg pairs) := by
  induction pairs with
  | nil => simp [foldPairs, zeroCx_mem]
  | cons p ps ih =>
      have hp : Cx.mem p.2 p.1 := h p (by simp)
      have hps : ∀ q ∈ ps, Cx.mem q.2 q.1 := fun q hq => h q (by simp [hq])
      have hrec := ih hps
      rw [List.map_cons, List.sum_cons, foldPairs, List.foldr_cons]
      exact snapCxInt_mem hg (Cx.mem_add hp hrec)

/-- The boxes and values of the blocks of size `M`. -/
def blockPairs (B M : ℕ) (S : Cx) (s : ℂ) : List (Cx × ℂ) :=
  (List.range B).map (fun j =>
    (sumBox (paramsBlock (j * M) M) S,
      ∑ i ∈ Finset.range M, pairTerm s (j * M + i)))

theorem blockPairs_mem {N B M : ℕ} {S : Cx} {s : ℂ}
    (h : allOK (paramsFast N) S = true) (hNM : B * M ≤ N) (hs : Cx.mem s S) :
    ∀ p ∈ blockPairs B M S s, Cx.mem p.2 p.1 := by
  intro p hp
  rw [blockPairs] at hp
  rcases List.mem_map.mp hp with ⟨j, hj, rfl⟩
  have hjB : j < B := List.mem_range.mp hj
  have h1 : (j + 1) * M ≤ B * M :=
    Nat.mul_le_mul_right M (Nat.succ_le_of_lt hjB)
  have h2 : j * M + M = (j + 1) * M := by ring
  have hoff : j * M + M ≤ N := by omega
  exact blockBox_mem h hoff hs

theorem blockFold_mem {g : ℚ} (hg : 0 < g) {N B M : ℕ} {S : Cx} {s : ℂ}
    (h : allOK (paramsFast N) S = true) (hNM : B * M ≤ N) (hs : Cx.mem s S) :
    Cx.mem (∑ m ∈ Finset.range (B * M), pairTerm s m)
      (foldPairs g hg (blockPairs B M S s)) := by
  have hpairs := blockPairs_mem h hNM hs
  have hmem := foldPairs_mem hg (blockPairs B M S s) hpairs
  have hval : ((blockPairs B M S s).map Prod.snd).sum = (blockVals B M s).sum := by
    simp only [blockPairs, blockVals, List.map_map]
    congr 1
  rw [hval, blockVals_sum] at hmem
  exact hmem

end FiniteWindowZeros
