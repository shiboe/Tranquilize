local _, Tranquilize = ...;
local Announce = {};

Tranquilize.Announce = Announce;

--

local TRANQ_MSG = "Tranquilizing %s... [%s]";

--

function Announce:Chat(mob, result)
  if (Tranquilize.UI.Frame:IsVisible() == false) then return end;

  if (UnitInRaid("player")) then
    SendChatMessage(TRANQ_MSG:format(mob, result), "RAID");
  elseif (UnitInParty("player")) then
    SendChatMessage(TRANQ_MSG:format(mob, result), "PARTY");
  else
    print(TRANQ_MSG:format(mob, result));
  end
end
