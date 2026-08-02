# Project Standards

These instructions are project-local rules for this Garry's Mod addon repository. They are written to apply after `%HOME%/.codex/AGENTS.md`.

## Common GLua Rules

- Do not add blank comment lines or blank lines between code-structure parts unless a rule explicitly requires them.
- If a file contains only one code-structure part, remove the part header comment.
- Sort functions and properties in alphanumeric ascending order by default.
- Every function must have LuaLS LuaDoc comments.
- Use short `snake_case` variable names while keeping the original meaning recognizable, such as `wep_cls` for `weapon_class` and `wep_name` for `weapon_name`.
- Use `UPPER_CASE` only for constants whose values never change.
- When rewriting code, preserve existing `--` comments where practical.
- Inline one-line `local function` bodies at their call sites. Never inline standard functions such as `SWEP:XXX()` or `ENT:XXX()`.
- For long functions, add short comments for each meaningful section that explain what that section does.
- Follow the ponytail skill: avoid reinventing the wheel, YAGNI, speculative abstractions, and unnecessary dependencies.

## Autorun Code

Autorun code means Lua code under `lua/autorun`.

### Code Rules

- Every console command with arguments must have an autocomplete function. Commands without separate arguments may keep `nil` autocomplete.
- Unless there is a specific reason not to, autocomplete candidates must be sorted in alphanumeric ascending order.
- Build autocomplete candidates from the command's real argument meaning. Do not add an empty autocomplete function just to satisfy structure rules.
- `lua/autorun/client/menu_lib_*.lua` files are copied common menu libraries. Keep all copies synchronized with each other.
- Treat `lua/autorun/client/menu_lib_*.lua`, `lua/autorun/client/menu_*.lua`, and `lua/autorun/server/sc_setservercvar_*.lua` as one connected menu/ConVar bridge surface.

### Code Structure

1. Local function variables: cache frequently used library functions in local variables.
2. `--`: blank comment.
3. Local variables.
4. `--`: blank comment.
5. Local functions.
6. `--`: blank comment.
7. `--[[# HOOK #]]`: five-line block comment, exactly as shown below.
8. HOOK: `hook.*` related code.
9. `--[[# MENU #]]`: five-line block comment, exactly as shown below.
10. MENU: `MENU` realm related code.
11. `--[[# NET #]]`: five-line block comment, exactly as shown below.
12. NET: `net.*` related code.
13. `--[[# TIMER #]]`: five-line block comment, exactly as shown below.
14. TIMER: `timer.*` related code.
15. `--[[# COMMAND #]]`: five-line block comment, exactly as shown below.
16. COMMAND: command body definitions.
17. `--[[# COMMAND AUTOCOMPLETE #]]`: five-line block comment, exactly as shown below.
18. COMMAND AUTOCOMPLETE: command autocomplete functions.
19. `--[[# COMMAND REGISTER #]]`: five-line block comment, exactly as shown below.
20. COMMAND REGISTER: `concommand.Add()` calls.

```lua
--[[
##############
#    HOOK    #
##############
]]

--[[
##############
#    MENU    #
##############
]]

--[[
#############
#    NET    #
#############
]]

--[[
###############
#    TIMER    #
###############
]]

--[[
#################
#    COMMAND    #
#################
]]

--[[
##############################
#    COMMAND AUTOCOMPLETE    #
##############################
]]

--[[
##########################
#    COMMAND REGISTER    #
##########################
]]
```

## SWEP Code

SWEP code means Lua code under `lua/weapons`.

### Code Structure

1. `if SERVER then AddCSLuaFile() end`
2. `--`: blank comment used to separate the file setup from the `SWEP.*` properties below.
3. `SWEP.*` properties:
   1. `SWEP.*`: all properties except `Primary.*` and `Secondary.*`.
   2. `SWEP.Primary.*`: properties for primary fire.
   3. `SWEP.Secondary.*`: properties for secondary fire.
4. `util.PrecacheModel()` x2: precache both ViewModel and WorldModel. Wrap this part above and below with `--` blank comments so it is separated from other parts.
5. `--[[# SWEP UTILITY #]]`: five-line block comment, exactly as shown below.
6. SWEP UTILITY: functions that are not standard `SWEP` functions but are required for SWEP behavior. Primary Fire, Secondary Fire, and Reload helpers belong in their matching parts instead.
   1. Local functions: generally avoid local functions in SWEP code, but place them here when they are needed.
   2. `SWEP:*XXX()`: non-standard `SWEP:` functions. Prefix them with `*` to distinguish them from standard functions.
7. `--[[# SWEP FUNCTION #]]`: five-line block comment, exactly as shown below.
8. SWEP FUNCTION: standard `SWEP:` functions, excluding Primary Fire, Secondary Fire, and Reload related functions.
9. `--[[# SWEP PRIMARY FIRE #]]`: five-line block comment, exactly as shown below.
10. SWEP PRIMARY FIRE: `SWEP:PrimaryAttack()` and directly related functions.
11. `--[[# SWEP SECONDARY FIRE #]]`: five-line block comment, exactly as shown below.
12. SWEP SECONDARY FIRE: `SWEP:SecondaryAttack()` and directly related functions.
13. `--[[# SWEP RELOAD #]]`: five-line block comment, exactly as shown below.
14. SWEP RELOAD: `SWEP:Reload()` and directly related functions.

```lua
--[[
######################
#    SWEP UTILITY    #
######################
]]

--[[
#######################
#    SWEP FUNCTION    #
#######################
]]

--[[
###########################
#    SWEP PRIMARY FIRE    #
###########################
]]

--[[
#############################
#    SWEP SECONDARY FIRE    #
#############################
]]

--[[
#####################
#    SWEP RELOAD    #
#####################
]]
```

## SENT Code

SENT code means Lua code under `lua/entities`. SENT is used to define an Entity or NPC. SNPC is a SENT subclass.

### Code Structure

1. `if SERVER then AddCSLuaFile() end`
2. `--`: blank comment used to separate the file setup from the `ENT.*` properties below.
3. `ENT.*` properties:
   1. Base properties defined on `ENT`:
      1. `ENT.Base`
      2. `ENT.Type`
      3. Other properties.
   2. SENT properties for internal use. Prefix them with `_` to distinguish them from base properties.
4. Internal local variables, such as constants.
5. Entity/NPC SpawnMenu registration code, following the example below.
6. `--[[# SHARED #]]`: five-line block comment, exactly as shown below.
7. SHARED: `ENT.` functions used by both the `CLIENT` and `SERVER` realms.
8. `--[[# CLIENT #]]`: five-line block comment, exactly as shown below.
9. CLIENT: `ENT.` functions used only by the `CLIENT` realm.
10. `--[[# SERVER #]]`: five-line block comment, exactly as shown below.
11. SERVER: `ENT.` functions used only by the `SERVER` realm.
12. `--[[# INPUT/OUTPUT #]]`: five-line block comment, exactly as shown below.
13. INPUT/OUTPUT: functions related to Hammer Editor I/O.

```lua
-- NPC SpawnMenu registration example
list.Set("NPC", "sc_turret", {
  Category = ENT.Category,
  Class = "sc_turret",
  Health = tostring(ENT.DefaultHealth),
  Model = ENT.ModelName,
  Name = ENT.PrintName,
  Offset = 8,
  OnFloor = true,
  Rotate = Angle(0, 180, 0)
} --[[@as NPCData]])

--[[
################
#    SHARED    #
################
]]

--[[
################
#    CLIENT    #
################
]]

--[[
################
#    SERVER    #
################
]]

--[[
######################
#    INPUT/OUTPUT    #
######################
]]
```

## Module Code

Module code means Lua code under `lua/includes/modules`.

### Code Structure

1. Module initialization code, following the example below.
2. Localized functions: cache frequently used library functions in local variables.
3. `--[[# LOCAL #]]`: five-line block comment, exactly as shown below.
4. LOCAL: functions that must not be exposed outside the module.
5. `--[[# PUBLIC #]]`: five-line block comment, exactly as shown below.
6. PUBLIC: functions exposed outside the module.
7. Optional submodules:
   1. `--[[# SUB: <SUBMODULE NAME> #]]`: five-line block comment, following the `SUB: COMMAND` example below.
   2. SUBMODULE: functions for that submodule.
8. `--[[# INITIALIZE #]]`: five-line block comment. Use this part for module initialization calls that must run after function definitions.
9. INITIALIZE: post-definition initialization calls, such as config reloads.
10. `--[[# RETURN #]]`: five-line block comment.
11. RETURN: the final module return statement.

```lua
-- Module initialization code
sctools = {} ---@diagnostic disable-line: lowercase-global
sctools.command = {} -- PUBLIC submodule predefinition
sctools._protect = {} -- Private table, prefixed with `_`
module("sctools", package.seeall)

--[[
###############
#    LOCAL    #
###############
]]

--[[
################
#    PUBLIC    #
################
]]

--[[
######################
#    SUB: COMMAND    #
######################
]]

--[[
######################
#     INITIALIZE     #
######################
]]

--[[
################
#    RETURN    #
################
]]
```
