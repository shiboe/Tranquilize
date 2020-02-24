local _, Tranquilize = ...;
local Hunters = {
  map = {},
}

Tranquilize.Hunters = Hunters;

--

local TRANQ_COOLDOWN = 20.0;

--

function Hunters:MarkAllStale()
  for i = 1, #self do
    self[i].stale = true;
  end
end

function Hunters:PurgeStale()
  print('test2', #self)
  for i = 1, #self do
    print('purge?', i)
    if (self[i].stale) then
      print('purged!')
      self:Remove(self[i].id);
    end
  end
end


function Hunters:UpdateRaidFromList()
  self:MarkAllStale()

  for i = 1, GetNumGroupMembers() do
    local name, rank, subgroup, level, class, classNormalized, zone, online, isDead, role, isMasterLooter = GetRaidRosterInfo(i);
    if (classNormalized ~= "HUNTER") then return end;

    local GUID = UnitGUID("raid" .. i);
    
    if (self.map[GUID] == nil) then
      self:Add(GUID, name); -- TODO: pass online, dead, etc for more status displays!
    else
      self[self.map[GUID]].stale = false;
    end
  end

  self:PurgeStale();
end

function Hunters:Add(id, name)
  local n = #self + 1;

  self[n] = {
    id = id,
    name = name,
    row = nil,
    tranqCooldown = nil, 
    animating = false,
    stale = false,
  };

  self.map[id] = n;
end

function Hunters:Remove(id)
  if (self.map[id] ~= nil) then
    self[self.map[id]] = nil;
    self.map[id] = nil;
  end
end

function Hunters:Get(id)
  if (self.map[id] ~= nil) then
    return self[self.map[id]];
  else
    return nil;
  end
end

function Hunters:SetRow(hunter, row)
  hunter.row = row;
end

function Hunters:UpdateCooldowns(elapsed)
  print('test', #self)
  for i = 1, #self do
    if (self[i].tranqCooldown ~= nil) then
      self[i].tranqCooldown = self[i].tranqCooldown - elapsed;

      if (self[i].tranqCooldown <= 0) then
        self[i].tranqCooldown = nil;
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
end