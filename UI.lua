local _, Tranquilize = ...;
local UI = {
  rows = {}
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
  local count = #Tranquilize.Hunters;

  if (count > 0) then
    self:RenderHunters(count);
  else
    self:RenderEmpty();
  end

  self:SetFrameHeight(count);
end

function UI:RenderHunters(count)
  for i = 1, count do
    if (UI.rows[i] == nil) then
      UI.rows[i] = UI:CreateRow();
    end

    Tranquilize.Hunters:SetRow(Tranquilize.Hunters[i], UI.rows[i]);
    UI:UpdateRow(i, Tranquilize.Hunters[i]);
  end

  for i = count + 1, #UI.rows do
    UI.rows[i]:Hide();
  end
end

function UI:RenderCooldowns()

end

function UI:RenderEmpty()
  for i = 1, #UI.rows do
    UI.rows[i]:Hide();
  end
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

function UI:UpdateRow(index, hunter)
  UI.rows[index].nameplate:SetText(hunter.name);

  if (index > 1) then
    UI.rows[index]:SetPoint("TOP", UI.rows[index - 1], "BOTTOM", 0, -1 * ROW_VERTICAL_PADDING);
  else
    UI.rows[index]:SetPoint("TOP", UI.Frame.Bg, "TOP", 0, -1 * ROW_VERTICAL_PADDING);
  end
end

function UI:RenderUpdate()
  for i = 1, #Tranquilize.Hunters do
    local hunter = Tranquilize.Hunters[i];
    if (hunter.animating == false) then return end;

    self:UpdateRowCounter(hunter);

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

function UI:UpdateRowCounter(hunter)
  hunter.row.counter:SetText(hunter.tranqCooldown);
end