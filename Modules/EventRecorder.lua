local EventRec = {}

function EventRec:OnInitialize()
    self.Logs = {}
    self.Filter = ""
end

function EventRec:CreateView(parent)
    local f = ForgeMaster.Theme:CreatePanel(parent, "FM_EventRecorder")
    f:SetAllPoints()
    local label = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    label:SetPoint("TOP", 0, -20)
    label:SetText("Event Filter & Recorder\nLive event log with filter:")
    local edit = CreateFrame("EditBox", nil, f, "InputBoxTemplate")
    edit:SetSize(200, 20)
    edit:SetPoint("TOP", label, "BOTTOM", 0, -10)
    edit:SetAutoFocus(false)
    edit:SetText("")
    f.Edit = edit
    local log = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    log:SetPoint("TOP", edit, "BOTTOM", 0, -10)
    log:SetJustifyH("LEFT")
    log:SetWidth(600)
    f.Log = log
    local function updateLog()
        local lines = {}
        for i, entry in ipairs(self.Logs) do
            if self.Filter == "" or entry:lower():find(self.Filter:lower()) then
                table.insert(lines, entry)
            end
            if #lines >= 20 then break end
        end
        f.Log:SetText(table.concat(lines, "\n"))
    end
    edit:SetScript("OnTextChanged", function(self)
        EventRec.Filter = self:GetText()
        updateLog()
    end)
    self.UpdateLog = updateLog
    self.View = f
end

function EventRec:OnEnable()
    self:RegisterAllEvents(function(event, ...)
        local msg = string.format("[%s] %s", date("%H:%M:%S"), event)
        table.insert(self.Logs, 1, msg)
        if self.UpdateLog then self:UpdateLog() end
        if #self.Logs > 100 then table.remove(self.Logs) end
    end)
end
