local TableVis = {}

function TableVis:CreateView(parent)
    local f = ForgeMaster.Theme:CreatePanel(parent, "FM_TableVis")
    f:SetAllPoints()
    local label = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    label:SetPoint("TOP", 0, -20)
    label:SetText("Table Visualizer\nPaste a Lua table below:")
    local edit = CreateFrame("EditBox", nil, f, "InputBoxTemplate")
    edit:SetSize(400, 30)
    edit:SetPoint("TOP", label, "BOTTOM", 0, -10)
    edit:SetAutoFocus(false)
    f.Edit = edit
    local btn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    btn:SetSize(120, 25)
    btn:SetText("Visualize Table")
    btn:SetPoint("TOP", edit, "BOTTOM", 0, -10)
    btn:SetScript("OnClick", function()
        -- Placeholder: In a real version, parse and display the table
        f.Result:SetText("[Table visualization coming soon]")
    end)
    local result = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    result:SetPoint("TOP", btn, "BOTTOM", 0, -10)
    result:SetText("")
    f.Result = result
    self.View = f
end

ForgeMaster:RegisterModule("TableVisualizer", TableVis)
