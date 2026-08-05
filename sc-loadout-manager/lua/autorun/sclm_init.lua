SCLM = SCLM or {}

AddCSLuaFile("sclm/shared.lua")
AddCSLuaFile("sclm/client.lua")
AddCSLuaFile("ulx/xgui/sclm.lua")

include("sclm/shared.lua")

if SERVER then
  include("sclm/server.lua")
else
  include("sclm/client.lua")
end
