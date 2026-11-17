import Closure6
import SubCone
import DensityCertificates
import DensityCertificates5

/-!
# Axiom audit

`./check.sh Audit.lean` prints the axioms used by the three closed rungs.  All
three are expected to depend only on

```
[propext, Classical.choice, Quot.sound]
```

i.e. no `sorryAx`, no extra hypotheses, and no `native_decide` axioms (the
generated certificates use `norm_num`, not `native_decide`, throughout; see
[`../HANDOFF-M0P-NEXT.md`](../HANDOFF-M0P-NEXT.md) §2.4).
-/

#print axioms PrimeSpectrumTensor.gaussianGram4_posDef
#print axioms PrimeSpectrumTensor.gaussianGram5_posDef
#print axioms PrimeSpectrumTensor.gaussianGram6_posDef
#print axioms PrimeSpectrumTensor.gaussianGram6_quadraticForm_nonneg
#print axioms PrimeSpectrumTensor.sum_poleTerm_eq
#print axioms PrimeSpectrumTensor.poleTerm_unbounded
#print axioms PrimeSpectrumTensor.sum_poleTerm_eq_zero
