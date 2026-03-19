-- Modules/UnitInspector.lua
-- ForgeMaster Prime: Unit/Tooltip/Item Inspector Module

local UnitInspector = {}

function UnitInspector:CreateView(parent)
    local f = CreateFrame("Frame", nil, parent)
    f:SetAllPoints()

    local title = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 16, -16)
    title:SetText("Unit/Tooltip/Item Inspector")

    local desc = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    desc:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
    desc:SetWidth(400)
    desc:SetJustifyH("LEFT")
    desc:SetText("Inspect units, tooltips, and items. Hover or enter a unit/item name to see all available info, GUIDs, and tooltip data.")

    local input = CreateFrame("EditBox", nil, f, "InputBoxTemplate")
    input:SetSize(220, 28)
    input:SetPoint("TOPLEFT", desc, "BOTTOMLEFT", 0, -16)
    input:SetAutoFocus(false)
    input:SetText("")

    local inspectBtn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    inspectBtn:SetSize(80, 24)
    inspectBtn:SetText("Inspect")
    inspectBtn:SetPoint("LEFT", input, "RIGHT", 8, 0)

    local results = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    results:SetPoint("TOPLEFT", input, "BOTTOMLEFT", 0, -12)
    results:SetWidth(500)
    results:SetJustifyH("LEFT")
    results:SetText("Inspection results will appear here.")

    -- Tooltip for live hover inspection
    local hoverTip = CreateFrame("GameTooltip", "FM_UnitInspectorTooltip", UIParent, "GameTooltipTemplate")
    hoverTip:SetOwner(f, "ANCHOR_NONE")
    hoverTip:Hide()

    local function inspectUnitOrItem(name)
        if not name or name == "" then
            results:SetText("Enter a unit or item name.")
            return
        end
        -- Try unit first
        if UnitExists(name) then
            local guid = UnitGUID(name)
            local class = UnitClass(name) or "?"
            local level = UnitLevel(name) or "?"
            local health = UnitHealth(name) or "?"
            local maxHealth = UnitHealthMax(name) or "?"
            local info = string.format("|cff00ff00Unit:|r %s\n|cff00ff00GUID:|r %s\n|cff00ff00Class:|r %s\n|cff00ff00Level:|r %s\n|cff00ff00Health:|r %s / %s", name, guid or "?", class, level, health, maxHealth)
            results:SetText(info)
            -- Show tooltip
            hoverTip:ClearLines()
            hoverTip:SetOwner(f, "ANCHOR_NONE")
            hoverTip:SetUnit(name)
            hoverTip:SetPoint("TOPLEFT", results, "BOTTOMLEFT", 0, -8)
            hoverTip:Show()
            return
        end
        -- Try item
        local itemName, itemLink = GetItemInfo(name)
        if itemName then
            local info = string.format("|cff00ff00Item:|r %s\n|cff00ff00Link:|r %s", itemName, itemLink or "?")
            results:SetText(info)
            hoverTip:ClearLines()
            hoverTip:SetOwner(f, "ANCHOR_NONE")
            hoverTip:SetHyperlink(itemLink)
            hoverTip:SetPoint("TOPLEFT", results, "BOTTOMLEFT", 0, -8)
            hoverTip:Show()
            return
        end
        -- Not found
        results:SetText("|cffff0000No unit or item found with that name.|r")
        hoverTip:Hide()
    end

    input:SetScript("OnEnterPressed", function(self)
        inspectUnitOrItem(self:GetText())
        self:ClearFocus()
    end)
    inspectBtn:SetScript("OnClick", function()
        inspectUnitOrItem(input:GetText())
    end)

    -- Live hover inspection: show info for unit under mouse
    local hoverFrame = CreateFrame("Frame", nil, f)
    hoverFrame:SetAllPoints(f)
    hoverFrame:SetFrameStrata("TOOLTIP")
    hoverFrame:EnableMouse(true)
    hoverFrame:SetScript("OnEnter", function()
        local focus = GetMouseFocus()
        if focus and focus.GetUnit then
            local unit = focus:GetUnit() or "mouseover"
            if UnitExists(unit) then
                inspectUnitOrItem(unit)
            end
        end
    end)
    hoverFrame:SetScript("OnLeave", function()
        hoverTip:Hide()
    end)

    f:Show()
    parent.View = f
    return f
end

return UnitInspector
