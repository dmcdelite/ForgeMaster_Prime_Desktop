if not _G.ForgeMaster then
    _G.ForgeMaster = {}
end
local ForgeMaster = _G.ForgeMaster
ForgeMaster.Theme = {
    Colors = {
        BG = {0.05, 0.05, 0.07, 0.95},
        Border = {0.2, 0.2, 0.2, 1},
        Accent = {0, 0.8, 1, 1},
        Warning = {1, 0.3, 0.3, 1}
    }
}

function ForgeMaster.Theme:CreatePanel(parent, name)
    local f = CreateFrame("Frame", name, parent, "BackdropTemplate")
    f:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8X8",
        edgeFile = "Interface\\Buttons\\WHITE8X8",
        edgeSize = 1,
        insets = { left = 0, right = 0, top = 0, bottom = 0 }
    })
    f:SetBackdropColor(unpack(self.Colors.BG))
    f:SetBackdropBorderColor(unpack(self.Colors.Border))
    return f
end

function ForgeMaster.Theme:ApplyStyle(f)
    f:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8X8",
        edgeFile = "Interface\\Buttons\\WHITE8X8",
        edgeSize = 1,
    })
    f:SetBackdropColor(unpack(self.Colors.BG))
    f:SetBackdropBorderColor(unpack(self.Colors.Border))
end
