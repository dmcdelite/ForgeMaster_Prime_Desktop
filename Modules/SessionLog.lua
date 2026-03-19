-- Modules/SessionLog.lua
-- ForgeMaster Prime: Session/History Log Module

local SessionLog = {}

function SessionLog:CreateView(parent)
    local f = CreateFrame("Frame", nil, parent)
    f:SetAllPoints()

    local title = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 16, -16)
    title:SetText("Session/History Log")

    local desc = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    desc:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
    desc:SetWidth(400)
    desc:SetJustifyH("LEFT")
    desc:SetText("View and export a log of ForgeMaster actions, errors, and session history. Useful for debugging and auditing.")

    -- Placeholder for log display
    local logBox = CreateFrame("ScrollFrame", nil, f, "UIPanelScrollFrameTemplate")
    logBox:SetSize(400, 180)
    logBox:SetPoint("TOPLEFT", desc, "BOTTOMLEFT", 0, -16)

    local logText = CreateFrame("EditBox", nil, logBox)
    logText:SetMultiLine(true)
    logText:SetFontObject(ChatFontNormal)
    logText:SetWidth(380)
    logText:SetAutoFocus(false)
    logText:SetText("Session log will appear here.")
    logBox:SetScrollChild(logText)

    f:Show()
    parent.View = f
    return f
end

ForgeMaster:RegisterModule("SessionLog", SessionLog)
return SessionLog
