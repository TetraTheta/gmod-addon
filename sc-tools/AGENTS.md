# SC Tools AddOutput Guidelines

These rules apply to new or modified scripted entities in `sc-tools`.

- Keep `sc_point`, `sc_anim`, and `sc_npc` as same-level Lua base entities. `sc_point` preserves the `base_point` chain, `sc_anim` preserves the `base_anim` chain, and `sc_npc` preserves the `base_ai` chain.
- Do not make `sc_npc` inherit from `sc_point`; Garry's Mod supports base chains, but each SENT has one `ENT.Base`, and NPC behavior depends on the `base_ai` path.
- Use `sc_anim` instead of `sc_point` for anim/model entities such as `prop_interactable`. MapBase's `prop_interactable` derives from `CDynamicProp`, which is closer to GMod's `base_anim` path than to a point entity.
- FGD inheritance may combine editor bases differently from GLua. Keep Hammer declarations aligned with the Lua base's observable inputs, but do not use FGD multi-base support as proof that the Lua runtime has multiple bases.
- Current Map Labs NPC ports are map-focused GLua approximations. Do not claim full C++ parity without auditing pickup inputs, sound keyvalues, schedules, and engine-only NPC behavior.
- Do not manually parse the `AddOutput` input and feed it back through `SetKeyValue()`.
- Route entity inputs through `ENT:InputXXX()` methods from `ENT:AcceptInput()`, matching the existing SC Tools style.
- Keep server-only entity logic behind a SERVER guard or a CLIENT early return; client definitions should only contain client-safe rendering or presentation code.
- In `ENT:AcceptInput()`, call `self:AddOutputFromAcceptInput(inputName, data)` instead of checking `inputName == "AddOutput"` directly.
- In `ENT:KeyValue()`, call `self:AddOutputFromKeyValue(key, value)` before normal keyvalue handling.
- In `ENT:KeyValue()`, do not call `self:SetSpawnFlags()` for the `spawnflags` key because Garry's Mod implements it through `SetKeyValue()`.
- Fire outputs with `self:TriggerOutput("OutputName", activator)`.
- Set reentry guards or cooldown state before `TriggerOutput()` when an output can invoke the same input again, even if that map I/O would be invalid.
- When a scripted entity overrides a built-in engine classname, implement the full keyvalue/input/output surface used by maps; GLua does not inherit the engine entity's C++ behavior.
- To override a built-in class in FGD, define the replacement class after the included base FGDs so Hammer uses the final class definition.
- Keep `prop_interactable` close to MapBase's `CDynamicProp` path: preserve `solid=6` VPhysics static collision when possible, and only fall back when the model or physics init is unavailable.
- When changing an existing entity, compare a representative VMF/I/O example before and after the change to confirm input names, output names, and ordinary keyvalue behavior stay the same.
