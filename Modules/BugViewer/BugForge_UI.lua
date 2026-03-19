-- BugForge: UI for error viewing and management
local BugForge = _G["BugForge"]

-- Main frame
local frame = CreateFrame("Frame", "BugForgeFrame", UIParent, "BasicFrameTemplateWithInset")
frame:SetSize(600, 400)
frame:SetPoint("CENTER")
frame:SetMovable(true)
frame:EnableMouse(true)
frame:RegisterForDrag("LeftButton")
frame:SetScript("OnDragStart", frame.StartMoving)
frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
frame:Hide()

frame.title = frame:CreateFontString(nil, "OVERLAY")
frame.title:SetFontObject("GameFontHighlight")
frame.title:SetPoint("LEFT", frame.TitleBg, "LEFT", 5, 0)
frame.title:SetText("BugForge - Lua Error Log")

-- Error list (scrolling)
local scroll = CreateFrame("ScrollFrame", nil, frame, "UIPanelScrollFrameTemplate")
scroll:SetPoint("TOPLEFT", 10, -30)
scroll:SetPoint("BOTTOMRIGHT", -30, 50)

local content = CreateFrame("Frame", nil, scroll)
content:SetSize(1, 1)
scroll:SetScrollChild(content)

-- Store error buttons
frame.errorButtons = {}

local function RefreshErrorList()
    for _, btn in ipairs(frame.errorButtons) do btn:Hide() end
    local y = 0
    for i, err in ipairs(BugForge.errors) do
        local btn = frame.errorButtons[i] or CreateFrame("Button", nil, content, "UIPanelButtonTemplate")
        btn:SetSize(540, 30)
        btn:SetPoint("TOPLEFT", 0, -y)
        btn:SetText(string.format("[%d] %s (%s)", i, err.message:sub(1, 60), err.time))
        btn:SetScript("OnClick", function()
            BugForge_ShowErrorDetail(i)
        end)
        btn:Show()
        frame.errorButtons[i] = btn
        y = y + 32
    end
    content:SetHeight(y)
end

-- Error detail popup
function BugForge_ShowErrorDetail(idx)
    local err = BugForge.errors[idx]
    if not err then return end
    if not frame.detail then
        local d = CreateFrame("Frame", nil, frame, "DialogBoxFrame")
        d:SetSize(500, 300)
        d:SetPoint("CENTER")
        d.text = d:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        d.text:SetPoint("TOPLEFT", 20, -40)
        d.text:SetWidth(460)
        d.text:SetJustifyH("LEFT")
        d.close = CreateFrame("Button", nil, d, "UIPanelButtonTemplate")
        d.close:SetSize(80, 24)
        d.close:SetPoint("BOTTOM", 0, 10)
        d.close:SetText("Close")
        d.close:SetScript("OnClick", function() d:Hide() end)
        d.copy = CreateFrame("Button", nil, d, "UIPanelButtonTemplate")
        d.copy:SetSize(80, 24)
        d.copy:SetPoint("BOTTOMRIGHT", -20, 10)
        d.copy:SetText("Copy")
        d.copy:SetScript("OnClick", function()
            local text = err.message .. "\n" .. err.stack
            if CopyToClipboard then CopyToClipboard(text) end
        end)
        frame.detail = d
    end
    frame.detail.text:SetText(string.format("%s\n\nStack:\n%s\n\nTime: %s\nCount: %d", err.message, err.stack, err.time, err.count or 1))
    frame.detail:Show()
end

-- Copy all errors
local copyAllBtn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
copyAllBtn:SetSize(100, 24)
copyAllBtn:SetPoint("BOTTOMLEFT", 10, 10)
copyAllBtn:SetText("Copy All")
copyAllBtn:SetScript("OnClick", function()
    local all = {}
    for _, err in ipairs(BugForge.errors) do
        table.insert(all, string.format("%s\nStack:\n%s\nTime: %s\nCount: %d", err.message, err.stack, err.time, err.count or 1))
    end
    if CopyToClipboard then CopyToClipboard(table.concat(all, "\n\n---\n\n")) end
end)

-- Clear all errors
local clearBtn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
clearBtn:SetSize(100, 24)
clearBtn:SetPoint("BOTTOMLEFT", 120, 10)
clearBtn:SetText("Clear All")
clearBtn:SetScript("OnClick", function()
    if wipe then
        wipe(BugForge.errors)
    else
        for k in pairs(BugForge.errors) do BugForge.errors[k] = nil end
    end
    RefreshErrorList()
end)

-- Show UI command
SLASH_BUGFORGE1 = "/bugforge"
SLASH_BUGFORGE2 = "/errors"
if _G.SlashCmdList then
    SlashCmdList["BUGFORGE"] = function()
        RefreshErrorList()
        frame:Show()
    end
end

-- Minimap button (simple)
local minimapParent = _G.Minimap or UIParent
local mini = CreateFrame("Button", "BugForgeMiniBtn", minimapParent)
mini:SetSize(32, 32)
mini:SetNormalTexture("Interface/ICONS/INV_Misc_Bug_01")
mini:SetPoint("TOPLEFT", minimapParent, "BOTTOMLEFT", 0, 0)
mini:SetScript("OnClick", function()
    RefreshErrorList()
    frame:Show()
end)
mini:SetScript("OnEnter", function(self)
    if GameTooltip then
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText("BugForge: Show Lua Errors", 1, 1, 1)
        GameTooltip:Show()
    end
end)
mini:SetScript("OnLeave", function() if GameTooltip then GameTooltip:Hide() end end)

-- Export errors (as string)
local exportBtn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
exportBtn:SetSize(100, 24)
exportBtn:SetPoint("BOTTOMLEFT", 230, 10)
exportBtn:SetText("Export")
exportBtn:SetScript("OnClick", function()
    local all = {}
    for _, err in ipairs(BugForge.errors) do
        table.insert(all, string.format("%s\nStack:\n%s\nTime: %s\nCount: %d", err.message, err.stack, err.time, err.count or 1))
    end
    if CopyToClipboard then CopyToClipboard(table.concat(all, "\n\n---\n\n")) end
end)

-- Initial refresh
if C_Timer and C_Timer.After then
    C_Timer.After(2, RefreshErrorList)
else
    RefreshErrorList()
end
