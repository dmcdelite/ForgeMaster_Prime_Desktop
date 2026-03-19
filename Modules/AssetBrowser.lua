local Assets = {}

function Assets:OnInitialize()
    self.currentFilter = ""
end

function Assets:CreateView()
    local f = ForgeMaster.Theme:CreatePanel(ForgeMaster.MainFrame.Content, "FM_AssetBrowser")
    f:SetAllPoints()
    f.Search = CreateFrame("EditBox", nil, f, "SearchBoxTemplate")
    f.Search:SetSize(250, 20); f.Search:SetPoint("TOPLEFT", 10, -10)
    f.Scroll = CreateFrame("ScrollFrame", "FM_AssetScroll", f, "UIPanelScrollFrameTemplate")
    f.Scroll:SetPoint("TOPLEFT", 10, -40); f.Scroll:SetPoint("BOTTOMRIGHT", -30, 40)
    local model = CreateFrame("PlayerModel", nil, f)
    model:SetSize(250, 300); model:SetPoint("TOPRIGHT", f, "TOPRIGHT", -10, -40)
    model:SetConfigColor(0, 0, 0, 1); model:SetDisplayInfo(1)
    f.Export = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    f.Export:SetSize(100, 25); f.Export:SetText("EXPORT ID"); f.Export:SetPoint("TOPRIGHT", model, "BOTTOMRIGHT", 0, -10)
    f.Export:SetScript("OnClick", function()
        local id = model:GetDisplayInfo()
        ForgeMaster:CopyToClipboard(string.format("m:SetDisplayInfo(%d)", id))
    end)
    self.View = f
end

ForgeMaster:RegisterModule("AssetBrowser", Assets)
