local _, Tranquilize = ...;

--

local UPDATE_INTERVAL = 1.0;

--

Tranquilize.UI.Frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
Tranquilize.UI.Frame:RegisterEvent("GROUP_ROSTER_UPDATE");

--

Tranquilize.Hunters:Add('123', "Shiboe");
Tranquilize.Hunters:Add('456', "Amaroq");
Tranquilize.Hunters:Add('789', "Gheed");
Tranquilize.Hunters:Add('789', "Testo");
Tranquilize.Hunters:Add('789', "McGee");
Tranquilize.UI:Render();

Tranquilize.UI.Frame.TimeSinceLastUpdate = 0;
Tranquilize.UI.Frame:SetScript("OnUpdate", function(self, elapsed)
  self.TimeSinceLastUpdate = self.TimeSinceLastUpdate + elapsed; 
  

  while (self.TimeSinceLastUpdate > UPDATE_INTERVAL) do
    -- Store elapsed time so we can reset the interval timer before calling other methods.
    -- This way if there's an error, we don't miss our chance to slow the interval down.
    local storedElapsed = self.TimeSinceLastUpdate;
    self.TimeSinceLastUpdate = self.TimeSinceLastUpdate - UPDATE_INTERVAL;

    Tranquilize.Hunters:UpdateCooldowns(storedElapsed);
    Tranquilize.UI:RenderUpdate();

    
  end
end);

Tranquilize.UI.Frame:SetScript("OnEvent", function(self, event, ...)
  if (event == "COMBAT_LOG_EVENT_UNFILTERED") then 
    Tranquilize.Events:OnCombatLogEvent(event, CombatLogGetCurrentEventInfo());
  end
  
  if (event == "GROUP_ROSTER_UPDATE") then
    Tranquilize.Events:OnGroupRosterUpdateEvent(event);
  end
end)