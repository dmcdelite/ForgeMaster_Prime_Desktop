-- ForgeMaster Prime: Minimap Icon & DataBroker

local LDB = LibStub("LibDataBroker-1.1"):NewDataObject("ForgeMasterPrime", {
    type = "launcher",
    text = "ForgeMaster Prime",
    icon = "Interface\\AddOns\\ForgeMaster_Prime\\Media\\INV_Gizmo_01_FM",
    OnClick = function(self, button)
        if ForgeMaster and ForgeMaster.MainFrame then
            if ForgeMaster.MainFrame:IsShown() then
                ForgeMaster.MainFrame:Hide()
            else
                ForgeMaster.MainFrame:Show()
            end
        end
    end,
    OnTooltipShow = function(tooltip)
        tooltip:AddLine("ForgeMaster Prime")
        tooltip:AddLine("|cff00ff80Click|r to toggle main UI.")
    end,
})

local icon = LibStub("LibDBIcon-1.0")
ForgeMasterDB = ForgeMasterDB or { minimap = { hide = false } }
icon:Register("ForgeMasterPrime", LDB, ForgeMasterDB.minimap)

function ForgeMaster:ToggleMinimapIcon()
    ForgeMasterDB.minimap.hide = not ForgeMasterDB.minimap.hide
    if ForgeMasterDB.minimap.hide then
        icon:Hide("ForgeMasterPrime")
    else
        icon:Show("ForgeMasterPrime")
    end
end
