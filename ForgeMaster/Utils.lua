function ForgeMaster:FormatMoney(amount)
    local floor = math.floor
    local gold = floor(amount / 10000)
    local silver = floor((amount % 10000) / 100)
    local copper = amount % 100
    return string.format("|cffffd700%dg|r |cffc7c7c7%ds|r |cffeda55f%dc|r", gold, silver, copper)
end

function ForgeMaster:CopyToClipboard(text)
    if not self.CopyFrame then
        local f = CreateFrame("Frame", nil, UIParent, "DialogBoxFrame")
        f:SetSize(450, 150); f:SetPoint("CENTER"); f:SetFrameStrata("TOOLTIP")
        local eb = CreateFrame("EditBox", nil, f, "InputBoxTemplate")
        eb:SetSize(400, 40); eb:SetPoint("CENTER", 0, 10); eb:SetMultiLine(true)
        f.eb = eb; self.CopyFrame = f
    end
    self.CopyFrame.eb:SetText(text)
    self.CopyFrame:Show()
    self.CopyFrame.eb:SetFocus()
    self.CopyFrame.eb:HighlightText()
    print("|cff00ff80ForgeMaster:|r Code Copied to Clipboard. Use Ctrl+V externally.")
end
