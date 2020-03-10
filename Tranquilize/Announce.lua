local _, Tranquilize = ...;
local Announce = {}

Tranquilize.Announce = Announce;

--

local TRANQ_MSG = "Tranquilizing %s... [%s]";

--

function Announce:Chat(mob, result)
  if (UnitInRaid("player")) then
    SendChatMessage(TRANQ_MSG:format(mob, result), "RAID");
  elseif (UnitInParty("player")) then
    SendChatMessage(TRANQ_MSG:format(mob, result), "PARTY");
  end
end
