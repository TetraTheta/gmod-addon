# SC Turrets Instructions

## Scope

- `sc_turret` is an independent `base_anim` entity. Do not hook or wrap `npc_turret_floor`.
- Do not switch back to `base_ai`; idle and animation states can let the engine restore body yaw internally.
- `IsNPC()` may return `true` for Lua addon compatibility, but this entity is not a C++ engine NPC.
- Keep the spawnmenu entry in the NPC list, not the entity tab.
- Keep the menu label as `SC Entity` / `SC Resistance Turret`.
- Use only `target:Disposition(owner) == D_HT` for target hostility checks to avoid `npc_turret_floor` Combine/citizen relationship behavior.

## Files

- Main entity: `sc-turrets/lua/entities/sc_turret.lua`
- Do not restore the old hook-based `sc_turret_resistance_floor.lua`.

## Behavior Rules

- Keep `ENT.Range = 2048`. Valve's `FLOOR_TURRET_RANGE` is `1200`, but this project extends it to match Combine Soldier max look distance.
- Keep the original FOV behavior: `m_flFieldOfView = 0.4`. Candidate scan and active targeting must both require targets inside the forward view cone.
- Candidates are living `NPC` or `NextBot` entities inside range.
- Attack only candidates hostile to the spawning player.
- Store the spawning player only in the internal `_owner` field. Do not use it as `SetCreator` or bullet `Attacker`; killfeed attacker should remain the turret.
- Target priority is nearest to the turret.
- Do not directly rotate the turret body. Search and aim only with pose parameters; body movement/rotation belongs to physics interactions such as Gravity Gun or collisions.
- Do not use `base_ai`, NPC schedules, or yaw APIs. Keep the current target only in the internal `Target` field.
- Do not reintroduce `SetEnemy`, `NPC_STATE_*`, `SetSchedule`, `SetNPCClass`, or `SetIdealYawAndUpdate`.
- Treat `IsNPC()` spoofing as Lua addon compatibility only. Add unnecessary NPC methods only as no-op compatibility shims, not as real engine AI behavior.
- Preserve kill log behavior through bullet `Attacker = self` and manual `hook.Run("OnNPCKilled", self, attacker, inflictor)` when the turret dies.
- Normal damage must not reduce health or destroy the turret. Like the original turret, damage events should only apply physics force and force target reacquisition; destruction must happen through `SelfDestruct` or break flow.
- Do not spawn gibs on destruction. Keep only the small explosion effect/damage and remove the turret entity.
- When tipped over, spend `2` to `2.5` seconds in thrash/emergency behavior, then enter `inactive`. In `inactive`, stop emergency sounds/pings and return through `Enable()` when upright again.
- Aim at the first visible point in this order: head/eyes, torso, arms/legs, hands/feet, other.
- For head/eye targets, prefer pose-applied bone positions over `EyePos()` so NPCs such as `npc_fastzombie` do not aim above the real head.
- Prefer hitbox centers over named bones or attachments so aiming follows animation-moved hitboxes.
- Keep bullet spread as `vector_origin` for full accuracy.
- The original fires `PISTOL` ammo. Current damage is `sk_npc_dmg_pistol * 2`, or `10` when the ConVar is missing.
- Preserve original timing references: `FLOOR_TURRET_MAX_WAIT = 5`, `FLOOR_TURRET_SHORT_WAIT = 2.0`, and `AutoSearchThink` interval `0.2` to `0.4` seconds.
- Keep search animation updates at `0.05` seconds, but run expensive enemy scans only every `0.2` to `0.4` seconds.
- Preserve original input names: `Toggle`, `Enable`, `Disable`, `DepleteAmmo`, `RestoreAmmo`, and `SelfDestruct`.
- Preserve the original state flow as a Lua state machine: auto search, deploy, search, active, retire, disabled, tipped, inactive, self destruct.

## References

- Valve Source SDK 2013: `npc_turret_floor.cpp`
  - Original model, `1200` range, pistol-ammo fire, and deploy/search/active think flow.
- Valve Developer Wiki: `npc_turret_floor`
  - Use only to confirm original spawnflags, keyvalues, and I/O.

## Tunable Values

- Model: `ENT.ModelName`
- Muzzle/light attachments: `ENT.MuzzleAttachmentNames`, `ENT.EyeAttachmentNames`
- Skin: `ENT.SkinNumber`
- Sounds: `SOUNDS`
- Fire interval: `ENT.FireInterval`
- Detection range: `ENT.Range`
