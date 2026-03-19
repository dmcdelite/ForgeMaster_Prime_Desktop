-- Modules/MacroRunner.lua
-- ForgeMaster Prime: Custom Macro/Script Runner Module

local MacroRunner = {}

function MacroRunner:CreateView(parent)
    local f = CreateFrame("Frame", nil, parent)
    f:SetAllPoints()

    local title = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 16, -16)
    title:SetText("Custom Macro/Script Runner")

    local desc = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    desc:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
    desc:SetWidth(400)
    desc:SetJustifyH("LEFT")
    desc:SetText("Write, save, and run custom Lua macros or scripts in a safe sandbox. Useful for rapid prototyping and automation.")

    -- Placeholder for macro input and run button
    local macroBox = CreateFrame("EditBox", nil, f, "InputBoxTemplate")
    macroBox:SetSize(400, 28)
    macroBox:SetPoint("TOPLEFT", desc, "BOTTOMLEFT", 0, -16)
    macroBox:SetAutoFocus(false)
    macroBox:SetText("")

    local runBtn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    runBtn:SetSize(120, 28)
    runBtn:SetPoint("LEFT", macroBox, "RIGHT", 8, 0)
    runBtn:SetText("Run Macro")
    runBtn:SetScript("OnClick", function()
        -- Placeholder: Macro execution logic to be implemented
        print("Macro execution not yet implemented.")
    end)

    f:Show()
    parent.View = f
    return f
end

ForgeMaster:RegisterModule("MacroRunner", MacroRunner)
return MacroRunner
