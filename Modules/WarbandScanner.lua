local Warband = {}

function Warband:OnInitialize()
    self.Data = { Gold = 0, Tabs = {} }
end

function Warband:CreateView()
    local f = ForgeMaster.Theme:CreatePanel(ForgeMaster.MainFrame.Content, "FM_WarbandView")
    f:SetAllPoints()
    f.Header = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    f.Header:SetPoint("TOPLEFT", 15, -15)
    f.Header:SetText("Warband Account Summary")
    f.Gold = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightMedium")
    f.Gold:SetPoint("TOPLEFT", f.Header, "BOTTOMLEFT", 0, -10)
    f.Refresh = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    f.Refresh:SetSize(140, 25); f.Refresh:SetText("SCAN WARBAND")
    f.Refresh:SetPoint("TOPRIGHT", -15, -15)
    f.Refresh:SetScript("OnClick", function() self:UpdateData() end)
    self.View = f
    self:UpdateData()
end

function Warband:UpdateData()
    local totalGold = C_Bank.GetAutoDepositMoney() 
    self.View.Gold:SetText(string.format("Total Warband Gold: |cffffd700%s|r", GetMoneyString(totalGold)))
    print("|cff00ff80[ForgeMaster Warband]|r Account wealth scanned.")
end

ForgeMaster:RegisterModule("WarbandScanner", Warband)
