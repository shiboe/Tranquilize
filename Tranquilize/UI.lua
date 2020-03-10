local _, Tranquilize = ...;
local UI = {
  releasedRows = {}
}

Tranquilize.UI = UI;

--

local ROW_INDENT = 30;
local ROW_VERTICAL_PADDING = 2;
local ROW_HEIGHT = 24;

local FRAME_WIDTH = 180;
local FRAME_INNER_PADDING = 4;
local FRAME_OUTER_PADDING = 9;

--

UI.Frame = CreateFrame("Frame", "TranquilizeFrame", UIParent, "TranslucentFrameTemplate");

UI.Frame:SetSize(FRAME_WIDTH, 100);
UI.Frame:SetPoint("CENTER", UIParent, "CENTER");

UI.Frame:SetMovable(true);
UI.Frame:EnableMouse(true);
UI.Frame:RegisterForDrag("LeftButton");
UI.Frame:SetScript("OnDragStart", UI.Frame.StartMoving);
UI.Frame:SetScript("OnDragStop", UI.Frame.StopMovingOrSizing);

UI.Frame.header = UI.Frame:CreateFontString(nil, "OVERLAY", "GameFontNormal");
UI.Frame.header:SetPoint("TOP", UI.Frame.Bg, "TOP", 0 , -14);
UI.Frame.header:SetPoint("CENTER", UI.Frame.Bg, "CENTER");
UI.Frame.header:SetText("Tranquilize");
UI.Frame.header:SetPoint("LEFT", UI.Frame.Bg, "LEFT", 5, 0);
UI.Frame.header:SetPoint("RIGHT", UI.Frame.Bg, "RIGHT", -5, 0);

UI.Frame.subheader = UI.Frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall");
UI.Frame.subheader:SetPoint("CENTER", UI.Frame.Bg, "CENTER");
UI.Frame.subheader:SetPoint("TOP", UI.Frame.header, "BOTTOM");
UI.Frame.subheader:SetText("Join a raid/party to start.");
UI.Frame.subheader:SetPoint("LEFT", UI.Frame.Bg, "LEFT", 5, 0);
UI.Frame.subheader:SetPoint("RIGHT", UI.Frame.Bg, "RIGHT", -5, 0);

function UI:Render()
  local rowCount = 0;
  local previous = nil;
  local row = nil;

  for id, hunter in pairs(Tranquilize.Hunters.map) do
    row = self:RenderRow(hunter, previous);
    previous = hunter;
    rowCount = rowCount + 1;
  end

  if (row ~= nil) then
    self:SetFrameHeightWithRows(row:GetHeight(), rowCount);
    UI.Frame.header:Hide();
    UI.Frame.subheader:Hide();
  else
    UI.Frame:SetSize(FRAME_WIDTH, 70);
    UI.Frame.header:Show();
    UI.Frame.subheader:Show();
  end
end

function UI:Reset()
  UI.Frame:SetPoint("CENTER", UIParent, "CENTER");
end

function UI:SetFrameHeightWithRows(rowHeight, rowCount)
  local height = (rowCount * (ROW_VERTICAL_PADDING + rowHeight)) + (FRAME_INNER_PADDING * 2) + (FRAME_OUTER_PADDING * 2);
  UI.Frame:SetSize(FRAME_WIDTH, height);
end

function UI:CreateRow()
  local row = CreateFrame("Frame", "TranquilizeFrameRow", UI.Frame);
  local nameplate = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall");
  local counter = row:CreateFontString(nil, "OVERLAY", "NumberFontNormalYellow");

  row.nameplate = nameplate;
  row.counter = counter;
  row:SetBackdrop({
	  bgFile = [[Textures/white.blp]], tile = false, tileSize=0,
	  --edgeFile = [[white.blp]],
--	  edgeFile="Interface/Tooltips/UI-Tooltip-Border",
	  edgeSize = 0,
--	  insets = {left=2, top=2, right=2, bottom=2}
	})
  row:SetBackdropColor(1, .2, 1, 0.4);
  --row:SetBackdropBorderColor(1, .4, 1, 0.7);

  row:SetSize(FRAME_WIDTH, ROW_HEIGHT);
  row:SetPoint("LEFT", UI.Frame.Bg, "LEFT", 5, 0);
  row:SetPoint("RIGHT", UI.Frame.Bg, "RIGHT", -5, 0);

  counter:SetWidth(28);
  counter:SetPoint("CENTER", row, "CENTER");
  counter:SetPoint("LEFT", row, "LEFT", 5, 0);
  counter:SetText('rdy');

  nameplate:SetPoint("CENTER", row, "CENTER");
  nameplate:SetPoint("LEFT", counter, "RIGHT", 10, 0);

  return row;
end

function UI:GetRow()
  local row = nil;

  if (#self.releasedRows > 0) then
    row = self.releasedRows[#self.releasedRows];
    self.releasedRows[#self.releasedRows] = nil;
  else
    row = self:CreateRow();
  end

  row.active = true;

  return row;
end

function UI:ReleaseRow(row)
  self.releasedRows[#self.releasedRows + 1] = row;
  row.active = false;
  row:Hide();
end

function UI:RenderRow(hunter, previousHunter)
  hunter.row.nameplate:SetText(hunter.name);

  if (previousHunter ~= nil) then
    hunter.row:SetPoint("TOP", previousHunter.row, "BOTTOM", 0, -1 * ROW_VERTICAL_PADDING);
  else
    hunter.row:SetPoint("TOP", UI.Frame.Bg, "TOP", 0, -1 * FRAME_INNER_PADDING);
  end

  return hunter.row;
end

function UI:Update()
  for id, hunter in pairs(Tranquilize.Hunters.map) do
    if (hunter.animating == false) then break end;

    self:UpdateRowCounter(hunter);

    if (hunter.tranqCooldown == nil) then
      hunter.animating = false;
      self:UpdateRowNameplate(hunter);
    end
  end
end

function UI:UpdateRowNameplate(hunter)
  if (hunter.tranqCooldown == nil) then
    hunter.row.nameplate:SetFontObject("GameFontHighlightSmall");
  else
    hunter.row.nameplate:SetFontObject("GameFontDarkGraySmall");
  end
end

function UI:UpdateRowCounter(hunter)
  if (hunter.tranqCooldown == nil) then
    hunter.row.counter:SetText('rdy');
  else
    hunter.row.counter:SetText(self:Round(hunter.tranqCooldown, 1));
  end
end

-- Helper rounding method for numbers.
function UI:Round(number, decimals)
  return (("%%.%df"):format(decimals)):format(number);
end
