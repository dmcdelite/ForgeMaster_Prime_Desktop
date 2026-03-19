-- Modules/MediaBrowser.lua
-- ForgeMaster Prime: Sound & Media Browser Module

local MediaBrowser = {}

function MediaBrowser:CreateView(parent)
    local f = CreateFrame("Frame", nil, parent)
    f:SetAllPoints()

    local title = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 16, -16)
    title:SetText("Sound & Media Browser")

    local desc = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    desc:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
    desc:SetWidth(400)
    desc:SetJustifyH("LEFT")
    desc:SetText("Browse, preview, and use WoW sound and media assets. Useful for finding icons, textures, and sound files for your addons.")

    -- Placeholder for search box and preview
    local searchBox = CreateFrame("EditBox", nil, f, "InputBoxTemplate")
    searchBox:SetSize(220, 28)
    searchBox:SetPoint("TOPLEFT", desc, "BOTTOMLEFT", 0, -16)
    searchBox:SetAutoFocus(false)
    searchBox:SetText("")
    searchBox:SetScript("OnEnterPressed", function(self)
        -- Placeholder: Search logic to be implemented
        self:ClearFocus()
    end)

    local preview = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    preview:SetPoint("TOPLEFT", searchBox, "BOTTOMLEFT", 0, -12)
    preview:SetWidth(400)
    preview:SetJustifyH("LEFT")
    preview:SetText("Media preview will appear here.")

    f:Show()
    parent.View = f
    return f
end

ForgeMaster:RegisterModule("MediaBrowser", MediaBrowser)
return MediaBrowser
