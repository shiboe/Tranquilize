local _, Tranquilize = ...;
local Hunters = {
  map = {},
  loading = false,
}

Tranquilize.Hunters = Hunters;

--

local TRANQ_COOLDOWN = 20.0;

--

function Hunters:MarkAllStale()
  for id, hunter in pairs(self.map) do
    hunter.stale = true;
  end
end

function Hunters:PurgeStale()
  for id, hunter in pairs(self.map) do
    if (hunter.stale == true) then
      self:Remove(id);
    end
  end
end

function Hunters:UpdateSolo()
  self:MarkAllStale()

  local _, class = UnitClass("player");
  local name = UnitName("player");
  local GUID = UnitGUID("player");

  if (class == 'HUNTER') then
    if (self.map[GUID] == nil) then
      self:Add(GUID, name);
    else
      self:Update(GUID, name);
    end
  end

  self:PurgeStale();
end


function Hunters:UpdateRaidFromList()
  self:MarkAllStale()

  for i = 1, GetNumGroupMembers() do
    local name, rank, subgroup, level, class, classNormalized, zone, online, isDead, role, isMasterLooter = GetRaidRosterInfo(i);
    -- print('member', name, classNormalized)
    -- If our get request failed, we will have to try again later.
    if (name == nil) then
      self.loading = true;
      return
    end

    if (classNormalized == 'HUNTER') then
      local GUID = UnitGUID(name);

      -- TODO: pass online, dead, etc for more status displays!
      if (self.map[GUID] == nil) then
        self:Add(GUID, name);
      else
        self:Update(GUID, name);
      end
    end
  end

  -- print('done loading.')
  self.loading = false;
  self:PurgeStale();
end

function Hunters:PrintHunter(hunter)
  print('H - id: ', hunter.id, ' n: ', hunter.name, ' cd: ', hunter.tranqCooldown, ' an: ', hunter.animating, ' st: ', hunter.stale);
  if (hunter.row == nil) then
    print('(no row)');
  else
    Tranquilize.UI:PrintRow(hunter.row);
  end
end

function Hunters:Add(id, name)
  if (self.map[id] ~= nil) then
    self.map[id].name = name;
  else
    self.map[id] = {
      id = id,
      name = name,
      row = Tranquilize.UI:GetRow(),
      tranqCooldown = nil,
      animating = false,
      stale = false,
    };
  end
end

function Hunters:Update(id, name)
  local hunter = self.map[id];

  hunter.name = name;
  hunter.stale = false;
end

function Hunters:Get(id)
  return self.map[id];
end

function Hunters:Remove(id)
  Tranquilize.UI:ReleaseRow(self.map[id].row);
  self.map[id].row = nil;
  self.map[id] = nil;
end

function Hunters:UpdateCooldowns(elapsed)
  for id, hunter in pairs(self.map) do
    if (hunter.tranqCooldown ~= nil) then
      hunter.tranqCooldown = hunter.tranqCooldown - elapsed;

      if (hunter.tranqCooldown <= 0) then
        hunter.tranqCooldown = nil;
      end
    end
  end
end

function Hunters:TranqFire(timestamp, sourceGUID, result, targetName)
  local hunter = self:Get(sourceGUID);
  if (hunter == nil) then return end;

  hunter.animating = true;
  hunter.tranqCooldown = TRANQ_COOLDOWN;

  Tranquilize.UI:UpdateRowNameplate(hunter);
  Tranquilize.UI:UpdateRowCounter(hunter);

  if (UnitGUID("player") == sourceGUID) then
    Tranquilize.Announce:Chat(targetName, result);
  end
end
