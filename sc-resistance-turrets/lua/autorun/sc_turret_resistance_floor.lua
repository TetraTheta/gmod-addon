-- Register 'Resistance Turret'
list.Set("NPC", "sc_turret_resistance_floor", {
  Category = "SC Entities",
  Class = "npc_turret_floor",
  Health = "255",
  KeyValues = { custom_turret = "1" },
  Model = "models/sc_turret_resistance/floor_turret.mdl",
  Name = "SC Resistance Turret",
  Offset = 8,
  OnFloor = true,
  Rotate = Angle(0, 180, 0),
  Skin = 2, -- TODO: Add hook for NPC creation for assigning skin to it
  TotalSpawnFlags = SF_FLOOR_TURRET_CITIZEN
})

if not SERVER then return end

local e_fbc = ents.FindByClass
local e_fic = ents.FindInCone
local m_cos = math.cos
local m_rad = math.rad

---@param src Vector
---@param pos1 Vector
---@param pos2 Vector
---@return number result `0` if distance between src-pos1 and src-pos2 are same.<br>`-1` if distance between src-pos1 is smaller than src-pos2.<br>`1` if distance between src-pos1 is larger than src-pos2.
local function CompareDistance(src, pos1, pos2)
  local d1, d2 = src:DistToSqr(pos1), src:DistToSqr(pos2)
  if d1 < d2 then
    return -1
  elseif d1 > d2 then
    return 1
  else
    return 0
  end
end

---@param ent Entity
---@return boolean
local function IsSCTurret(ent)
  if not IsValid(ent) then return false end
  if ent:GetClass() ~= "npc_turret_floor" then return false end
  local m = ent:GetModel() ---@cast m string
  local t = util.KeyValuesToTablePreserveOrder(util.GetModelInfo(m)["ModelKeyValues"])
  for _, v in ipairs(t) do
    if (v["Key"] == "custom_turret" and v["Value"] == 1) then return true end
  end
  return false
end

---@param ent Entity
---@param data table
hook.Add("EntityFireBullets", "sc_turret_resistance_floor_firebullets", function(ent, data)
  if not SERVER then return end
  if not IsSCTurret(ent) then return end
  ---@cast ent NPC
  local enemy = ent:GetEnemy()
  if IsValid(enemy) then
    -- Modify bullet data
    local teye = ent:EyePos() -- or use 'eyes' attachment position
    local sub = Vector(0, 0, 5)
    if enemy:GetClass() == "npc_fastzombie" or enemy:GetClass() == "npc_poisonzombie" then
      sub = Vector(0, 0, 15)
    elseif enemy:GetClass() == "npc_cscanner" then
      sub = Vector(0, 0, 0)
    end
    local eeye = enemy:LookupAttachment("eyes") > 0 and enemy:GetAttachment(enemy:LookupAttachment("eyes")).Pos or enemy:EyePos()
    eeye = eeye - sub
    debugoverlay.Line(teye, eeye)
    data.Dir = (eeye - teye):GetNormalized()
    data.Spread = Vector(0, 0, 0)
    return true
  end
end)

local deg = m_cos(m_rad(90))

-- Using Timer instead of Think
timer.Create("sc_turret_resistance_floor_timer", 0.1, 0, function()
  local ply = Entity(1)
  if not ply:IsValid() then return end

  for _, t in ipairs(e_fbc("npc_turret_floor")) do
    ---@cast t NPC
    if not IsSCTurret(t) then continue end
    local enemy = t:GetEnemy()
    if IsValid(enemy) then
      continue
    else
      local teye = t:EyePos()
      local tang = t:GetAngles():Forward()

      local coneTargets = e_fic(teye, tang, 1200, deg)
      local bestTarget = NULL
      for _, e in ipairs(coneTargets) do
        if not IsValid(e) or not e:IsNPC() or e == t then continue end
        ---@cast e NPC

        if e:Health() <= 0 then continue end

        if t:Visible(e) then
          local disp, _ = e:Disposition(ply)
          if disp == D_HT then
            if bestTarget:IsValid() then
              local pos_t = t:GetPos()
              local pos_e = e:GetPos()
              local pos_b = bestTarget:GetPos()
              if CompareDistance(pos_t, pos_e, pos_b) == -1 then
                bestTarget = e
              end
            else
              bestTarget = e
            end
          end
        end
      end

      if bestTarget:IsValid() then
        bestTarget:AddFlags(FL_OBJECT)
        t:AddEntityRelationship(bestTarget, D_HT, 99)
        t:SetEnemy(bestTarget)
        t:UpdateEnemyMemory(bestTarget, bestTarget:GetPos())
      end
    end
  end
end)
