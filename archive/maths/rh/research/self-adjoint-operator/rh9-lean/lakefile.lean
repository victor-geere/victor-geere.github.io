import Lake
open Lake DSL

package «RH9» where
  -- Update the Mathlib4 tag below to the current release, then run `lake update`.

require mathlib from git
  "https://github.com/leanprover-community/mathlib4" @ "v4.14.0"

-- .andSubmodules includes RH9.lean itself plus everything under RH9/
lean_lib «RH9» where
  globs := #[.andSubmodules `RH9]
