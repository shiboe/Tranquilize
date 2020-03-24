local _, Tranquilize = ...;

--

local UPDATE_INTERVAL = 0.1;

--

SLASH_TRANQUILIZESHOW1 = "/tranqshow";
SlashCmdList["TRANQUILIZESHOW"] = function(msg)
  Tranquilize.UI.Frame:Show();
  Tranquilize.UI:Reset();
end

SLASH_TRANQUILIZEHIDE1 = "/tranqhide";
SlashCmdList["TRANQUILIZEHIDE"] = function(msg)
  Tranquilize.UI.Frame:Hide();
  print("[Tranquilize] Hidden: Restore with /tranqshow");
end

SLASH_TRANQUILIZEDEBUG1 = "/tranqdebug";
SlashCmdList["TRANQUILIZEDEBUG"] = function(msg)
  print("--HUNTERS--");
  for id, hunter in pairs(Tranquilize.Hunters.map) do
    Tranquilize.Hunters:PrintHunter(hunter);
  end

  print('\n');
  print("--ROWS--");
  for id, row in pairs(Tranquilize.UI.rows) do
    Tranquilize.UI:PrintRow(row);
  end

  print('\n');
  print("TOTAL: ", #Tranquilize.UI.rows);
  print("RELEASED: ", #Tranquilize.UI.releasedRows)
end

--

Tranquilize.UI.Frame:RegisterEvent("ADDON_LOADED");
Tranquilize.UI.Frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
Tranquilize.UI.Frame:RegisterEvent("GROUP_ROSTER_UPDATE");

--

Tranquilize.UI.Frame.TimeSinceLastUpdate = 0;
Tranquilize.UI.Frame:SetScript("OnUpdate", function(self, elapsed)
  self.TimeSinceLastUpdate = self.TimeSinceLastUpdate + elapsed;

  -- Only perform an action when our interval timer has elapsed.
  -- Store elapsed time so we can reset the interval timer before calling other methods.
  -- This way if there's an error, we don't miss our chance to slow the interval down.
  while (self.TimeSinceLastUpdate > UPDATE_INTERVAL) do
    local storedElapsed = self.TimeSinceLastUpdate;
    self.TimeSinceLastUpdate = self.TimeSinceLastUpdate - UPDATE_INTERVAL;
    Tranquilize.Events:OnUpdateEvent(event, storedElapsed);
  end
end);

Tranquilize.UI.Frame:SetScript("OnEvent", function(self, event, ...)
  if (event == "ADDON_LOADED" and ... == 'Tranquilize') then
    Tranquilize.Events:OnGroupRosterUpdateEvent(event);
    Tranquilize.UI.Frame:Hide();
    print("[Tranquilize] Loaded: Start blastin' with /tranqshow");
  end

  if (event == "COMBAT_LOG_EVENT_UNFILTERED") then
    Tranquilize.Events:OnCombatLogEvent(event, CombatLogGetCurrentEventInfo());
  end

  if (event == "GROUP_ROSTER_UPDATE") then
    Tranquilize.Events:OnGroupRosterUpdateEvent(event);
  end
end);
