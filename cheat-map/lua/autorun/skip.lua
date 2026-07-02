local efbn = ents.FindByName
local curmap = game.GetMap()

local function FireAll(name, input, value)
  local entTable = efbn(name)
  if not istable(entTable) then return end

  for i = 1, #entTable do
    local ent = entTable[i]
    if IsValid(ent) then ent:Fire(input, value or "") end
  end
end

local amalgam = {
  introEndPos = Vector(-515, -120, -735),
  introEndAng = Angle(0, -13, 0),
}

function amalgam.CancelIntroOutputs()
  FireAll("introstart", "CancelPending")
  FireAll("intro_relay", "CancelPending")
  FireAll("logic1", "CancelPending")
  FireAll("introtrigger1", "Disable")
  FireAll("trigger_tele_1", "Disable")
end

function amalgam.StopIntroSequence()
  FireAll("gmanintroscene", "Cancel")
  FireAll("gman_move_1", "CancelSequence")
  FireAll("gman_move_2", "CancelSequence")
  FireAll("gman_move_3", "CancelSequence")
  FireAll("gman_move_4", "CancelSequence")
  FireAll("gman_move_5", "CancelSequence")
end

function amalgam.StopIntroVisuals()
  FireAll("script_intro", "Deactivate")
  FireAll("script_intro", "Kill")
  FireAll("introcamera", "Disable")
  FireAll("introcamera2", "Disable")
  FireAll("introcamera2b", "Disable")
  FireAll("introcamera4", "Disable")
  FireAll("camera1", "Disable")
  FireAll("vis", "StopOverlays")
  FireAll("starfield", "TurnOff")
  FireAll("valojasaatana", "Disable")
  FireAll("zoomeri", "UnZoom")
  FireAll("introtext", "Kill")
end

function amalgam.StopIntroSounds()
  FireAll("telesound", "StopSound")
  FireAll("telesound2", "Kill")
  FireAll("telesound3", "Kill")
  FireAll("intromusic", "StopSound")
end

function amalgam.FinishIntroState()
  FireAll("metro1", "Kill")
  FireAll("metro2", "Kill")
  FireAll("metro3", "Kill")
  FireAll("arrest_civ", "Kill")
  FireAll("strider1", "Kill")
  FireAll("introactor1", "Kill")
  FireAll("thundertimer", "Enable")
end

function amalgam.RestorePlayerView(ply)
  if not IsValid(ply) or not ply:IsPlayer() then return end

  ply:Freeze(false)
  ply:SetViewEntity(ply)
  ply:SetFOV(0, 0)
  ply:ScreenFade(SCREENFADE.PURGE, Color(0, 0, 0, 0), 0, 0)
  ply:ConCommand("r_screenoverlay \"\"")
  ply:ConCommand("pp_mat_overlay \"\"")
  ply:SetPos(amalgam.introEndPos)
  ply:SetEyeAngles(amalgam.introEndAng)
end

function amalgam.SkipIntro1(ply)
  amalgam.CancelIntroOutputs()
  amalgam.StopIntroSequence()
  amalgam.StopIntroVisuals()
  amalgam.StopIntroSounds()
  amalgam.FinishIntroState()
  amalgam.RestorePlayerView(ply)

  print("[Amalgam] Skipped intro sequence: amg_01_intro_1")
end

local MAP_DATA = {
  ["amg_01_intro_1"] = {
    name = "amalgam",
    func = amalgam.SkipIntro1
  }
}

local function Skip(ply, _, args, _)
  if not SERVER then return end

  local mapName = args[2] and args[2]:lower() or args[1] and args[1]:lower() or curmap
  local data = MAP_DATA[mapName]
  if data and curmap == mapName then
    data.func(ply)
  else
    print("[Skip] There no skip registered for this map: " .. curmap)
  end
end

---@return table
local function SkipAutoComplete(cmd, _, args)
  local firstArg = args[1] and args[1]:lower() or ""
  local prefix = cmd .. " "

  if firstArg == "amalgam" then
    return {
      prefix .. "amalgam amg_01_intro_1"
    }
  end

  return {
    prefix .. "amalgam",
    prefix .. "amg_01_intro_1",
  }
end

concommand.Add("skip", Skip, SkipAutoComplete, "Skip sequences for various maps")
