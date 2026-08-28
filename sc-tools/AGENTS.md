# SC Tools Entity Guidelines

These rules apply to new or modified scripted entities in `sc-tools`.

## Base Selection

- Keep `sc_point`, `sc_anim`, and `sc_npc` as same-level Lua base entities. `sc_point` preserves the `base_point` chain, `sc_anim` preserves the `base_anim` chain, and `sc_npc` preserves the `base_ai` chain; do not make `sc_npc` inherit from `sc_point`.
- Use `sc_anim` instead of `sc_point` for anim/model entities. For example, MapBase's `prop_interactable` derives from `CDynamicProp`, which is closer to GMod's `base_anim` path than to a point entity.
- FGD inheritance may combine editor bases differently from GLua. Keep Hammer declarations aligned with the Lua base's observable inputs, but do not use FGD multi-base support as proof that the Lua runtime has multiple bases.

## Source And FGD Parity

- When a scripted entity overrides a built-in engine classname, implement the full keyvalue/input/output surface used by maps; GLua does not inherit the engine entity's C++ behavior.
- When editing FGD definitions for built-in or Source-compatible entities, compare the matching `GarrysMod/bin/*.fgd` entry first and keep shared fields, inputs, labels, descriptions, choices, and defaults aligned unless the Lua implementation deliberately differs. Exclude `sctools.fgd` itself from `*.fgd` searches because it may be the current or previous copy of `fgd/sctools.fgd`.
- To override a built-in class in FGD, define the replacement class after the included base FGDs so Hammer uses the final class definition.
- For MapBase-specific entity additions, prefer the MapBase C++ source over stock FGD behavior for new keyvalues, inputs, and runtime behavior.
- When porting Source or MapBase C++ behavior, trace both server and client code paths before implementing. Server entities often only package state; HUD, VGUI, prediction, networking, and effects behavior may live in client files.
- After implementing a C++ behavior port, compare the Lua flow against the original C++ flow one more time, including timing, default values, input routing, networking, and client/server ownership. Do not fill unknown behavior with guesses when source code can be checked.

## Entity I/O

- Route entity inputs through `ENT:InputXXX()` methods from `ENT:AcceptInput()`, matching the existing SC Tools style.
- In `ENT:AcceptInput()`, call `self:AddOutputFromAcceptInput(inputName, data)` instead of checking `inputName == "AddOutput"` directly. Do not manually parse the `AddOutput` input and feed it back through `SetKeyValue()`.
- In `ENT:KeyValue()`, call `self:AddOutputFromKeyValue(key, value)` before normal keyvalue handling.
- In `ENT:KeyValue()`, do not call `self:SetSpawnFlags()` for the `spawnflags` key because Garry's Mod implements it through `SetKeyValue()`.
- Fire outputs with `self:TriggerOutput("OutputName", activator)`.
- Set reentry guards or cooldown state before `TriggerOutput()` when an output can invoke the same input again, even if that map I/O would be invalid.

## Realm Boundaries

- Keep server-only entity logic behind a SERVER guard or a CLIENT early return; client definitions should only contain client-safe rendering or presentation code.

## Port Notes

- Current Map Labs NPC ports are map-focused GLua approximations. Do not claim full C++ parity without auditing pickup inputs, sound keyvalues, schedules, and engine-only NPC behavior.
- Keep `prop_interactable` close to MapBase's `CDynamicProp` path: preserve `solid=6` VPhysics static collision when possible, and only fall back when the model or physics init is unavailable.

## Validation

- When changing an existing entity, compare a representative VMF/I/O example before and after the change to confirm input names, output names, and ordinary keyvalue behavior stay the same.
