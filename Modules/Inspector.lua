local Inspector = {}

local Inspector = {}
function Inspector:OnEnable()
    self.Overlay = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
    self.Overlay:SetFrameStrata("TOOLTIP")
    ForgeMaster.Theme:ApplyStyle(self.Overlay)
    self.Overlay.bg = self.Overlay:CreateTexture(nil, "BACKGROUND")
    self.Overlay.bg:SetAllPoints()
    self.Overlay.txt = self.Overlay:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    self.Overlay.txt:SetPoint("BOTTOMLEFT", self.Overlay, "TOPLEFT", 0, 5)
    self.Overlay:Hide()
end

function Inspector:Start()
    self.Overlay:Show()
    self.Overlay:SetScript("OnUpdate", function(f)
        local focus = GetMouseFocus()
        if focus and focus ~= UIParent then
            f:ClearAllPoints()
            f:SetPoint("TOPLEFT", focus, "TOPLEFT")
            f:SetPoint("BOTTOMRIGHT", focus, "BOTTOMRIGHT")
            local isSecure = issecurevariable(focus, "SetShown")
            if not isSecure then
                f.bg:SetColorTexture(1, 0, 0, 0.5)
                f.txt:SetText("|cffff0000TAINTED|r: " .. (focus:GetName() or "Anon"))
            else
                f.bg:SetColorTexture(0, 1, 0.5, 0.4)
                f.txt:SetText("|cff00ff00SECURE|r: " .. (focus:GetName() or "Anon"))
            end
        end
    end)
end

ForgeMaster:RegisterModule("Inspector", Inspector)
