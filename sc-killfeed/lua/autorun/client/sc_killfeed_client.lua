--[[
Client ConVar

sc_killfeed_enabled <0|1> - Enable SC Killfeed
sc_killfeed_show_headshot <0|1> - Show headshot icons in the killfeed

I'm declaring ConVar here to make sure they are present before being used
]]
local enabled = CreateClientConVar("sc_killfeed_enabled", "1", true, false, "Enable SC Killfeed", 0, 1)
local show_headshot = CreateClientConVar("sc_killfeed_show_headshot", "1", true, false, "Show headshot icons in the killfeed", 0, 1)

local hud_deathnotice_time = GetConVar("hud_deathnotice_time")
local cl_drawhud = GetConVar("cl_drawhud") -- 'cl_drawhud' is engine ConVar which is always present.

local death_notice_headshot = 4
local headshot_size = 28
local headshot_gap = 8
local weapon_color = Color(255, 80, 0)

local deaths = {}
local pending_headshots = {}
local headshot_mat = Material("effects/killicons/headshot")

local function GetDeathColor(team_id)
  -- Enemy
  if team_id == -1 then return Color(250, 50, 50, 255) end
  -- Friendly
  if team_id == -2 then return Color(50, 200, 50, 255) end

  local team_color = team.GetColor(team_id)
  return Color(team_color.r, team_color.g, team_color.b, team_color.a or 255)
end

local function ClearDeathState()
  deaths = {}
  pending_headshots = {}
end

local function AddDeathNoticeEntry(attacker, attacker_team, inflictor, victim, victim_team, flags)
  if inflictor == "suicide" then attacker = nil end

  local death = {}
  death.time = CurTime()
  death.left = attacker
  death.right = victim
  death.icon = inflictor
  death.flags = flags or 0
  death.color1 = GetDeathColor(attacker_team)
  death.color2 = GetDeathColor(victim_team)

  table.insert(deaths, death)
end

--[[
#############
#    NET    #
#############
]]

-- Queue one headshot marker per death and consume it from AddDeathNotice.
net.Receive("SC_KillfeedHeadshot", function()
  table.insert(pending_headshots, net.ReadBool())
end)

--[[
##############
#    HOOK    #
##############
]]

-- Capture the stock AddDeathNotice event and replace only the rendering path.
---@diagnostic disable-next-line:redundant-parameter -- This hook intentionally mirrors the engine callback signature.
hook.Add("AddDeathNotice", "SC_Killfeed_AddDeathNotice", function(attacker, attacker_team, inflictor, victim, victim_team, flags)
  if not enabled:GetBool() then
    ClearDeathState()
    return
  end

  flags = flags or 0

  local is_headshot = table.remove(pending_headshots, 1)
  if show_headshot:GetBool() and is_headshot then
    flags = bit.bor(flags, death_notice_headshot)
  end

  AddDeathNoticeEntry(attacker, attacker_team, inflictor, victim, victim_team, flags)

  return true
end)

-- Render one death notice line while preserving the original base layout.
local function DrawDeath(x, y, death, time)
  local icon_width, icon_height = killicon.GetSize(death.icon)
  local has_weapon_icon = icon_width ~= nil and icon_height ~= nil

  if not has_weapon_icon then
    icon_width = 0
    icon_height = 16
  end

  local fadeout = (death.time + time) - CurTime()
  local alpha = math.Clamp(fadeout * 255, 0, 255)

  death.color1.a = alpha
  death.color2.a = alpha

  local has_headshot_icon = has_weapon_icon and bit.band(death.flags or 0, death_notice_headshot) ~= 0 and show_headshot:GetBool() and not headshot_mat:IsError()
  local icon_group_width = has_headshot_icon and icon_width + headshot_gap + headshot_size or icon_width
  local icon_x = x - icon_group_width / 2
  local center_y = y + icon_height / 2

  -- Draw the weapon icon.
  if has_weapon_icon then
    killicon.Render(icon_x, y, death.icon, alpha)
  end

  -- Draw the headshot icon on the same virtual centerline as the weapon icon and text.
  if has_headshot_icon then
    local headshot_x = icon_x + icon_width + headshot_gap
    local headshot_y = center_y - headshot_size / 2

    surface.SetMaterial(headshot_mat)
    surface.SetDrawColor(weapon_color.r, weapon_color.g, weapon_color.b, math.floor(alpha * 0.5))
    surface.DrawTexturedRect(headshot_x, headshot_y, headshot_size, headshot_size)
  end

  -- Draw the attacker name.
  if death.left then
    draw.SimpleText(death.left, "ChatFont", x - (icon_group_width / 2) - 16, y + icon_height / 2, death.color1, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
  end

  -- Draw the victim name.
  draw.SimpleText(death.right, "ChatFont", x + (icon_group_width / 2) + 16, y + icon_height / 2, death.color2, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

  return math.ceil(y + icon_height * 0.75)
end

-- Draw a custom death notice list while preserving base positioning and animation.
hook.Add("DrawDeathNotice", "SC_Killfeed_DrawDeathNotice", function(x, y)
  if not enabled:GetBool() then
    ClearDeathState()
    return
  end

  -- 'cl_drawhud' is engine ConVar which always present. No need to check its presence.
  if cl_drawhud:GetInt() == 0 then return end

  local time = hud_deathnotice_time and hud_deathnotice_time:GetFloat() or 6
  local reset = deaths[1] ~= nil

  x = x * ScrW()
  y = y * ScrH()

  for _, death in ipairs(deaths) do
    if death.time + time > CurTime() then
      if death.lerp then
        x = x * 0.3 + death.lerp.x * 0.7
        y = y * 0.3 + death.lerp.y * 0.7
      end

      death.lerp = death.lerp or {}
      death.lerp.x = x
      death.lerp.y = y

      y = DrawDeath(math.floor(x), math.floor(y), death, time)
      reset = false
    end
  end

  -- Keep the original behavior of clearing the table only after every entry expires.
  if reset then deaths = {} end
end)
