local Perf = {}

function Perf:CreateView(parent)
    local f = ForgeMaster.Theme:CreatePanel(parent, "FM_Performance")
    f:SetAllPoints()
    local label = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    label:SetPoint("TOP", 0, -20)
    label:SetText("Performance Profiler\nCPU/Memory usage by addon:")
    local list = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    list:SetPoint("TOP", label, "BOTTOM", 0, -20)
    list:SetJustifyH("LEFT")
    f.List = list
    local btn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    btn:SetSize(120, 25)
    btn:SetText("Refresh")
    btn:SetPoint("TOP", list, "BOTTOM", 0, -10)
    btn:SetScript("OnClick", function()
        UpdateAddOnMemoryUsage()
        local data = {}
        for i = 1, GetNumAddOns() do
            local mem = GetAddOnMemoryUsage(i)
            local name = GetAddOnInfo(i)
            if mem > 0 then
                table.insert(data, {name = name, mem = mem})
            end
        end
        table.sort(data, function(a, b) return a.mem > b.mem end)
        local lines = {}
        for i, entry in ipairs(data) do
            table.insert(lines, string.format("%s: %.1f KB", entry.name, entry.mem))
            if i >= 10 then break end
        end
        f.List:SetText(table.concat(lines, "\n"))
    end)
    f.List:SetText("Click Refresh to view stats.")
    self.View = f
end

ForgeMaster:RegisterModule("Performance", Perf)
