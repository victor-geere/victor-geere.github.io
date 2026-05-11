theory delta_range
  imports GDST_Base
begin

lemma delta_range [simp]: "delta n x \<in> {0,1}"
proof (cases n)
  case 0
  then show ?thesis
    by (simp add: delta.simps)
next
  case (Suc m)
  then show ?thesis
    by (simp add: delta.simps)
qed

end