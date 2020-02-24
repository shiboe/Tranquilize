local _, Tranquilize = ...;
local Events = {}

Tranquilize.Events = Events;

-- 

function Events:OnCombatLogEvent(event, ...)
  local timestamp, subEvent, _, sourceGUID = ...;
  local spellName = select(13, ...);
  local targetName = select(9, ...);
  local player = UnitGUID("player");

  -- We validate that the event was triggered by our player and our spell.
  if (sourceGUID~=player) then return end

  if (spellName~="Tranquilizing Shot") then 
    self:HandleTranqShot(timestamp, subEvent, sourceGUID, targetName);
  end
end

function Events:HandleTranqShot(timestamp, subEvent, sourceGUID, targetName)
  -- Only for testing purposes with something like arcane shot
  if (subEvent=="SPELL_DAMAGE") then
    Tranquilize.Hunters:TranqFire(timestamp, sourceGUID, "HIT", targetName);
  end

  if (subEvent=="SPELL_MISSED") then
    Tranquilize.Hunters:TranqFire(timestamp, sourceGUID, "MISS", targetName);
  end

  if (subEvent=="SPELL_DISPEL") then
    Tranquilize.Hunters:TranqFire(timestamp, sourceGUID, "HIT", targetName);
  end
end

function Events:OnGroupRosterUpdateEvent(event, ...)
  Tranquilize.Hunters:UpdateRaidFromList();
end