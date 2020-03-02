local _, Tranquilize = ...;
local UI = {
  releasedRows = {}
}

Tranquilize.UI = UI;

--

local ROW_INDENT = 40;
local ROW_VERTICAL_PADDING = 10;

local FRAME_WIDTH = 160;
local FRAME_VERTICAL_PADDING = 10;
local FRAME_BORDER_HEIGHT = 5;

--

UI.Frame = CreateFrame("Frame", "TranquilizeFrame", UIParent, "TranslucentFrameTemplate");

UI.Frame:SetSize(FRAME_WIDTH, 100);
UI.Frame:SetPoint("CENTER", UIParent, "CENTER");

function UI:Render()
  local rowCount = 0;
  local previous = nil

  for id, hunter in pairs(Tranquilize.Hunters.map) do
    self:RenderRow(hunter, previous);
    previous = hunter;
    rowCount = rowCount + 1;
  end

  if (rowCount == 0) then
    -- TODO empty render
  end

  self:SetFrameHeight(rowCount);
end

function UI:SetFrameHeight(rowCount)
  local height = (rowCount * (ROW_VERTICAL_PADDING + UI.rows[1]:GetHeight())) + (ROW_VERTICAL_PADDING * 2) + (FRAME_BORDER_HEIGHT * 2);
  UI.Frame:SetSize(FRAME_WIDTH, height);
end

function UI:CreateRow()
  local row = CreateFrame("Frame", "TranquilizeFrameRow", UI.Frame);
  local nameplate = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall");
  local counter = row:CreateFontString(nil, "OVERLAY", "NumberFontNormalYellow");

  row.nameplate = nameplate;
  row.counter = counter;

  row:SetSize(FRAME_WIDTH, 30);
  row:SetPoint("LEFT", UI.Frame.Bg, "LEFT", 5, 0);
  row:SetPoint("RIGHT", UI.Frame.Bg, "RIGHT", -5, 0);

  counter:SetPoint("CENTER", row, "CENTER");
  counter:SetPoint("LEFT", row, "LEFT", 5, 0);

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

function UI:RenderRow(index, hunter, previousHunter)
  hunter.row.nameplate:SetText(hunter.name);

  if (previousHunter ~= nil) then
    hunter.row:SetPoint("TOP", previousHunter.row, "BOTTOM", 0, -1 * ROW_VERTICAL_PADDING);
  else
    hunter.row:SetPoint("TOP", UI.Frame.Bg, "TOP", 0, -1 * ROW_VERTICAL_PADDING);
  end
end

function UI:Update()
  for id, hunter in pairs(Tranquilize.Hunters) do
    if (hunter.animating == false) then break end;

    hunter.row.counter:SetText(hunter.tranqCooldown);

    if (hunter.tranqCooldown == nil) then
      hunter.animating = false;
      self:UpdateRowNameplate(hunter);
    end
  end
end

function UI:UpdateRowNameplate(hunter)
  if (hunter.tranqCooldown ~= nil) then
    hunter.row.nameplate:SetFontObject("GameFontHighlightSmall");
  else
    hunter.row.nameplate:SetFontObject("GameFontDarkGraySmall");
  end
end
