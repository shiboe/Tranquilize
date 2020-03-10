local _, Tranquilize = ...;
local Events = {}

Tranquilize.Events = Events;

--

-- local SPELL_NAME = "Arcane Shot";
local SPELL_NAME = "Tranquilizing Shot";

function Events:OnCombatLogEvent(event, ...)
  local timestamp, subEvent, _, sourceGUID = ...;
  local spellName = select(13, ...);
  local targetName = select(9, ...);
  local player = UnitGUID("player");

  -- We validate that the event was triggered by our player and our spell.
  if (spellName == SPELL_NAME) then
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
  Tranquilize.UI:Render();
end

function Events:OnUpdateEvent(event, elapsed)
  if (Tranquilize.Hunters.loading) then
    -- print('update raid from list because loading...')
    Tranquilize.Hunters:UpdateRaidFromList();
    Tranquilize.UI:Render();
  end

  Tranquilize.Hunters:UpdateCooldowns(elapsed);
  Tranquilize.UI:Update();
end
