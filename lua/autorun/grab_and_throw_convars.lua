GRAB_AND_THROW = GRAB_AND_THROW or {}
GRAB_AND_THROW.CVARS = GRAB_AND_THROW.CVARS or {}

local grab_and_throw_strength = CreateConVar("ttt_grab_and_throw_strength", "1000", {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED})
local grab_and_throw_range = CreateConVar("ttt_grab_and_throw_range", "500", {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED})

GRAB_AND_THROW.CVARS.grab_and_throw_strength = grab_and_throw_strength:GetInt()
GRAB_AND_THROW.CVARS.grab_and_throw_range = grab_and_throw_range:GetInt()

if SERVER then

  cvars.AddChangeCallback("ttt_grab_and_throw_strength", function(name, old, new)
    GRAB_AND_THROW.CVARS.grab_and_throw_strength = tonumber(new)
  end, nil)

  cvars.AddChangeCallback("ttt_grab_and_throw_range", function(name, old, new)
    GRAB_AND_THROW.CVARS.grab_and_throw_range = tonumber(new)
  end, nil)
end
