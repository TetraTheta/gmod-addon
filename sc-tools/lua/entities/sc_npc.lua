-- Base of SC Tools' simple scripted NPC entities
if SERVER then AddCSLuaFile() end
---@class ENT : NPC
---@field ClassName string|nil
---@field DebrisModels string[]|nil
---@field DefaultHealth integer|nil
---@field OnKilled fun(self: ENT, dmginfo: CTakeDamageInfo|nil)
---@field SCClearEnemy fun(self: ENT)
---@field SCDead boolean|nil
---@field SCDropDebris fun(self: ENT, dmginfo: CTakeDamageInfo|nil, models: string[]|nil)
---@field SCFindClosestPlayer fun(self: ENT, maxDistance: number|nil): Player|nil, number
---@field SCHealth number|nil
---@field SCModel string|nil
---@field SCNotifyKilled fun(self: ENT, dmginfo: CTakeDamageInfo|nil)
---@field SCSetEnemy fun(self: ENT, enemy: Entity|nil)
---@field SCShouldIgnorePlayers fun(self: ENT): boolean
DEFINE_BASECLASS("base_ai")
ENT.Base = "base_ai"
ENT.DisableDuplicator = false
ENT.DoNotDuplicate = false
ENT.PhysgunDisabled = false
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.Type = "ai"

if CLIENT then
  function ENT:Draw(flags)
    self:DrawModel(flags)
  end

  function ENT:DrawTranslucent(flags)
    self:Draw(flags)
  end

  return
end
local DEFAULT_DEBRIS_MODELS = {
  "models/gibs/hgibs.mdl",
  "models/gibs/hgibs_spine.mdl",
  "models/gibs/hgibs_rib.mdl"
}

---@param ent Entity|nil
---@return boolean
local function IsAlivePlayer(ent)
  if ent == nil or not IsValid(ent) or not ent:IsPlayer() then return false end
  ---@cast ent Player
  if not ent:Alive() then return false end
  return true
end

---@param inputName string
---@param activator Entity
---@param caller Entity
---@param data string
function ENT:AcceptInput(inputName, activator, caller, data)
  local strInputFuncName = Format("Input%s", inputName:gsub("^%l", string.upper))
  if isfunction(self[strInputFuncName]) then
    local processed = self[strInputFuncName](self, activator, caller, data)
    return processed == nil and true or processed
  elseif inputName == "AddOutput" then
    local key, value = data:match("^(%S+)%s*(.*)$")
    if key ~= nil then
      self:SetKeyValue(key, value:gsub(":", ","))
      return true
    end
  end

  local name = self:GetName()
  local detail = Format("Unhandled AcceptInput: %s %s %s %s", inputName, tostring(activator), tostring(caller), data)
  if name == nil or name == "" then
    ErrorNoHalt("[ERROR] [", self.ClassName, "] ", detail, "\n")
  else
    ErrorNoHalt("[ERROR] [", self.ClassName, ": ", name, "] ", detail, "\n")
  end
end

function ENT:Initialize()
  local health = self.SCHealth
  if health == nil or health < 1 then health = self.DefaultHealth or 100 end
  self:SetHealth(health)
end

function ENT:InputKill(_, _, _)
  self:Remove()
end

function ENT:InputKillHierarchy(_, _, _)
  for _, v in pairs(self:GetChildren()) do
    v:Remove()
  end

  self:Remove()
end

function ENT:KeyValue(key, value)
  local lkey = key:lower()
  if lkey == "health" then
    self.SCHealth = tonumber(value) or self.SCHealth
  elseif lkey == "model" or lkey == "modelname" then
    self.SCModel = value
  elseif lkey == "targetname" then
    self:SetName(value)
  else
    self[key] = value
  end
end

function ENT:OnKilled(dmginfo)
  if self.SCDead then return end
  self.SCDead = true
  self:SCNotifyKilled(dmginfo)
  self:SCDropDebris(dmginfo)
  self:Remove()
end

function ENT:OnTakeDamage(dmginfo)
  if self.SCDead then return 0 end

  self:SetHealth(self:Health() - dmginfo:GetDamage())
  if self:Health() <= 0 then
    self:OnKilled(dmginfo)
  end

  return dmginfo:GetDamage()
end

---@param dmginfo CTakeDamageInfo|nil
function ENT:SCNotifyKilled(dmginfo)
  local attacker = dmginfo ~= nil and dmginfo:GetAttacker() or game.GetWorld()
  local inflictor = dmginfo ~= nil and dmginfo:GetInflictor() or attacker
  hook.Run("OnNPCKilled", self, attacker, inflictor)
end

---@param modelName string
---@return string|nil
function ENT:SCApplyModel(modelName)
  local selected = self.SCModel or modelName
  if selected ~= nil and selected ~= "" then
    if util.IsValidModel(selected) then
      util.PrecacheModel(selected)
    else
      ErrorNoHalt("[WARNING] [", self.ClassName or self:GetClass(), "] Model may be unavailable: ", selected, "\n")
    end

    self:SetModel(selected)
  end

  return selected
end

---@param dmginfo CTakeDamageInfo|nil
---@param models string[]|nil
---@return Player|nil, number
function ENT:SCDropDebris(dmginfo, models)
  local debrisModels = models or self.DebrisModels or DEFAULT_DEBRIS_MODELS
  local force = dmginfo ~= nil and dmginfo:GetDamageForce() or vector_origin
  local created = false

  for _, modelName in ipairs(debrisModels) do
    if util.IsValidModel(modelName) then
      local debris = ents.Create("prop_physics")
      if IsValid(debris) then
        debris:SetModel(modelName)
        debris:SetPos(self:GetPos() + VectorRand() * 8)
        debris:SetAngles(AngleRand())
        debris:Spawn()
        debris:SetCollisionGroup(COLLISION_GROUP_DEBRIS)

        local phys = debris:GetPhysicsObject()
        if IsValid(phys) then
          phys:Wake()
          phys:ApplyForceCenter(force + VectorRand() * 120)
        end

        created = true
      end
    end
  end

  local modelName = self:GetModel()
  if created or modelName == nil or not util.IsValidModel(modelName) then return end

  local debris = ents.Create("prop_physics")
  if not IsValid(debris) then return end

  debris:SetModel(modelName)
  debris:SetPos(self:GetPos())
  debris:SetAngles(self:GetAngles())
  debris:Spawn()
  debris:SetCollisionGroup(COLLISION_GROUP_DEBRIS)

  local phys = debris:GetPhysicsObject()
  if IsValid(phys) then
    phys:Wake()
    phys:ApplyForceCenter(force + VectorRand() * 120)
  end
end

---@param soundName string|nil
function ENT:SCEmitSound(soundName)
  if not isstring(soundName) or soundName == "" then return end
  ---@cast soundName string
  self:EmitSound(soundName)
end

---@param maxDistance number|nil
---@return Player|nil
---@return number
function ENT:SCFindClosestPlayer(maxDistance)
  local closest = nil
  local closestDist = maxDistance and maxDistance * maxDistance or math.huge
  local pos = self:GetPos()

  for _, ply in ipairs(player.GetAll()) do
    if IsAlivePlayer(ply) then
      local dist = pos:DistToSqr(ply:GetPos())
      if dist < closestDist then
        closest = ply
        closestDist = dist
      end
    end
  end

  return closest, closestDist
end

---@return boolean
function ENT:SCShouldIgnorePlayers()
  return GetConVar("ai_disabled"):GetBool() or GetConVar("ai_ignoreplayers"):GetBool()
end

function ENT:SCClearEnemy()
  ---@diagnostic disable-next-line: redundant-parameter
  self:SetEnemy(NULL)
  self:SetNPCState(NPC_STATE_IDLE)
  self:ClearSchedule()
end

---@param enemy Entity|nil
function ENT:SCSetEnemy(enemy)
  if not IsValid(enemy) then return end
  ---@cast enemy Entity
  self:AddEntityRelationship(enemy, D_HT, 99)
  ---@diagnostic disable-next-line: redundant-parameter
  self:SetEnemy(enemy)
  self:SetNPCState(NPC_STATE_COMBAT)
  ---@diagnostic disable-next-line: redundant-parameter
  self:UpdateEnemyMemory(enemy, enemy:GetPos())
end
