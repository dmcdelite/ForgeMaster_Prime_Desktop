-- AI Generated Fix for Secret Value Taint
local h = UnitHealth("target")
if type(h) == "number" then
    ForgeMaster.MainFrame.Label:SetText("Health: " .. h)
else
    ForgeMaster.MainFrame.Label:SetText("Health: [SECRET VALUE]")
end
