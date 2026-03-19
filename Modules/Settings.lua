local Settings = {}

function Settings:CreateView(parent)
    local f = CreateFrame("Frame", nil, parent)
    f:SetAllPoints()

    local title = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 16, -16)
    title:SetText("ForgeMaster Settings & Profiles")

    local desc = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    desc:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
    desc:SetWidth(400)
    desc:SetJustifyH("LEFT")
    desc:SetText("Configure addon preferences, UI options, and manage profiles.")

    -- Minimap toggle
    local miniBtn = CreateFrame("CheckButton", nil, f, "UICheckButtonTemplate")
    miniBtn:SetPoint("TOPLEFT", desc, "BOTTOMLEFT", 0, -16)
    miniBtn.text:SetText("Show minimap icon")
    miniBtn:SetChecked(not (ForgeMasterDB and ForgeMasterDB.minimap and ForgeMasterDB.minimap.hide))
    miniBtn:SetScript("OnClick", function(self)
        if ForgeMaster and ForgeMaster.ToggleMinimapIcon then
            ForgeMaster:ToggleMinimapIcon()
        end
    end)

    -- Profile management
    ForgeMasterDB = ForgeMasterDB or {}
    ForgeMasterDB.profiles = ForgeMasterDB.profiles or { ["Default"] = {} }
    ForgeMasterDB.activeProfile = ForgeMasterDB.activeProfile or "Default"

    local profLabel = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    profLabel:SetPoint("TOPLEFT", miniBtn, "BOTTOMLEFT", 0, -20)
    profLabel:SetText("Active Profile:")

    local profDrop = CreateFrame("Frame", nil, f, "UIDropDownMenuTemplate")
    profDrop:SetPoint("LEFT", profLabel, "RIGHT", 8, 0)
    UIDropDownMenu_SetWidth(profDrop, 120)
    UIDropDownMenu_SetText(profDrop, ForgeMasterDB.activeProfile)

    UIDropDownMenu_Initialize(profDrop, function(self, level, menuList)
        local info = UIDropDownMenu_CreateInfo()
        for name in pairs(ForgeMasterDB.profiles) do
            info.text = name
            info.checked = (name == ForgeMasterDB.activeProfile)
            info.func = function()
                ForgeMasterDB.activeProfile = name
                UIDropDownMenu_SetText(profDrop, name)
            end
            UIDropDownMenu_AddButton(info)
        end
    end)

    local newProfBtn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    newProfBtn:SetSize(100, 22)
    newProfBtn:SetPoint("TOPLEFT", profDrop, "BOTTOMLEFT", 0, -10)
    newProfBtn:SetText("New Profile")
    newProfBtn:SetScript("OnClick", function()
        StaticPopupDialogs["FORGEMASTER_NEW_PROFILE"] = {
            text = "Enter new profile name:",
            button1 = "Create",
            button2 = "Cancel",
            hasEditBox = true,
            OnAccept = function(self)
                local name = self.editBox:GetText()
                if name and name ~= "" and not ForgeMasterDB.profiles[name] then
                    ForgeMasterDB.profiles[name] = {}
                    ForgeMasterDB.activeProfile = name
                    UIDropDownMenu_SetText(profDrop, name)
                end
            end,
            timeout = 0,
            whileDead = true,
            hideOnEscape = true,
        }
        StaticPopup_Show("FORGEMASTER_NEW_PROFILE")
    end)

    return f
end

_G.ForgeMasterSettings = Settings
ForgeMaster:RegisterModule("Settings", Settings)
