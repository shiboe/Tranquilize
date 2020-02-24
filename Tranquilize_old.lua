local FRAME = TranquilizeFrame
local TRANQ_MSG = "Tranquilizing %s... [%s]"
local HUNTERS = {} -- Map of hunters by id, that contains their name, last tranq result and timestamp.
local HUNTER_COUNT = 0
local ROW_COUNT = 0

FRAME.rows = {}
FRAME:Hide()

FRAME:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

FRAME:SetScript("OnEvent", function(self, event, ...)
  if (event=="COMBAT_LOG_EVENT_UNFILTERED") then 
    self:OnCombatLogEvent(event, CombatLogGetCurrentEventInfo())
  end
end)

function FRAME:OnCombatLogEvent(event, ...)
  local timestamp, subEvent, _, sourceGUID = ...
  local spellName = select(13, ...)
  local target = select(9, ...)
  local player = UnitGUID("player")

  -- We validate that the event was triggered by our player and our spell.
  if (sourceGUID~=player) then return end
  if (spellName~="Tranquilizing Shot") then return end

  -- print(...)

  if (subEvent=="SPELL_DAMAGE") then
    self:OnSpellHit(target)
  end

  if (subEvent=="SPELL_MISSED") then
    self:OnSpellMiss(target)
  end

  if (subEvent=="SPELL_DISPEL") then
    self:OnSpellHit(target)
  end
end

function FRAME:SpeakResult(mob, result)
  if (UnitInRaid("player")) then
    SendChatMessage(TRANQ_MSG:format(mob, result), "RAID")
  end
end

function FRAME:OnSpellMiss(mob) 
  self:SpeakResult(mob, "MISS")
end

function FRAME:OnSpellHit(mob)
  self:SpeakResult(mob, "HIT")
end

function FRAME:resize(rows)
  if (rows==0) then
    self:SetSize(200, 80)
  else
    local size = (rows * 30) + 60
    -- print(size)
    self:SetSize(200, size)
  end
end

FRAME:resize(0)

--local test = TranquilizeHunter1
--test:SetPoint("TOPLEFT")
--TranquilizeHunter2:SetPoint("TOPLEFT")

function FRAME:addHunter(id, name)
  if (HUNTERS[id] ~= nil) then return end

  HUNTERS[id] = {}
  HUNTERS[id]["name"] = name

  HUNTER_COUNT = self:getLength(HUNTERS)
end

function FRAME:removeHunter(id)
  HUNTERS[id] = nil
  HUNTER_COUNT = self:getLength(HUNTERS)
end

function FRAME:getLength(table)
  local count = 0

  for key, value in pairs(table) do
    count = count + 1

  return count
  end
end

function FRAME:updateHunter(id, lastTranqTimestamp, lastTranqResult)
  HUNTERS[id]["lastTranqTimestamp"] = lastTranqTimestamp
  HUNTERS[id]["lastTranqResult"] = lastTranqResult
end

function FRAME:syncRowsToHunters()
  local neededRows = HUNTER_COUNT - ROW_COUNT
  local start = ROW_COUNT + 1
  local fin = ROW_COUNT + neededRows

  for i = start, fin, 1 do
    local item = CreateFrame("Button", "TranquilizeRow" .. idx, frame, "SecureActionButtonTemplate")
    FRAME.rows[i] = item
  end
end

function FRAME:render()
  for hunterId, hunterProps in pairs(HUNTERS) do
    print(k, v[1], v[2], v[3])
  end
end