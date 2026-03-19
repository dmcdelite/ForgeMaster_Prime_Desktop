-- Utility: CopyToClipboard
-- WoW does not provide a native clipboard API, but we can use an editbox for copying
function CopyToClipboard(text)
    if not BugForgeCopyBox then
        local eb = CreateFrame("EditBox", "BugForgeCopyBox", UIParent, "InputBoxTemplate")
        eb:SetMultiLine(true)
        eb:SetSize(500, 200)
        eb:SetPoint("CENTER")
        eb:SetAutoFocus(true)
        eb:Hide()
        eb:SetScript("OnEscapePressed", function(self) self:Hide() end)
        BugForgeCopyBox = eb
    end
    BugForgeCopyBox:SetText(text)
    BugForgeCopyBox:HighlightText()
    BugForgeCopyBox:Show()
end
