-- Modules/HotSwap.lua
-- ForgeMaster Prime: Reload & Module Hot-Swap Module

local HotSwap = {}

function HotSwap:CreateView(parent)
    local f = CreateFrame("Frame", nil, parent)
    f:SetAllPoints()

    local title = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 16, -16)
    title:SetText("Reload & Module Hot-Swap")

    local desc = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    desc:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
    desc:SetWidth(400)
    desc:SetJustifyH("LEFT")
    desc:SetText("Reload the UI or hot-swap individual ForgeMaster modules without a full reload. Useful for rapid development and debugging.")

    local reloadBtn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    reloadBtn:SetSize(120, 28)
    reloadBtn:SetPoint("TOPLEFT", desc, "BOTTOMLEFT", 0, -16)
    reloadBtn:SetText("Reload UI")
    reloadBtn:SetScript("OnClick", function()
        ReloadUI()
    end)

    local moduleLabel = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    moduleLabel:SetPoint("TOPLEFT", reloadBtn, "BOTTOMLEFT", 0, -18)
    moduleLabel:SetText("Select a module to hot-swap:")

    local moduleDropdown = CreateFrame("Frame", "FM_HotSwapDropdown", f, "UIDropDownMenuTemplate")
    moduleDropdown:SetPoint("LEFT", moduleLabel, "RIGHT", 8, 0)

    local swapBtn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    swapBtn:SetSize(140, 26)
    swapBtn:SetText("Hot-Swap Selected")
    swapBtn:SetPoint("LEFT", moduleDropdown, "RIGHT", 16, 0)

    local status = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    status:SetPoint("TOPLEFT", moduleLabel, "BOTTOMLEFT", 0, -12)
    status:SetWidth(500)
    status:SetJustifyH("LEFT")
    status:SetText("")

    local modules = {}
    if ForgeMaster and ForgeMaster.Modules then
        for name, _ in pairs(ForgeMaster.Modules) do
            table.insert(modules, name)
        end
        table.sort(modules)
    end

    local selectedModule = nil
    UIDropDownMenu_Initialize(moduleDropdown, function(self, level, menuList)
        local info = UIDropDownMenu_CreateInfo()
        for _, name in ipairs(modules) do
            info.text = name
            info.func = function()
                UIDropDownMenu_SetSelectedName(moduleDropdown, name)
                selectedModule = name
            end
            UIDropDownMenu_AddButton(info)
        end
    end)
    if #modules > 0 then
        UIDropDownMenu_SetSelectedName(moduleDropdown, modules[1])
        selectedModule = modules[1]
    end

    local function hotSwapModule(name)
        if not name or not ForgeMaster or not ForgeMaster.Modules[name] then
            status:SetText("|cffff0000Module not found or not loaded.|r")
            return
        end
        local ok, err = pcall(function()
            -- Unload the module
            ForgeMaster.Modules[name] = nil
            package.loaded["Modules."..name] = nil
            -- Try to reload
            local loaded, mod = pcall(function() return require("Modules."..name) end)
            if loaded and mod then
                ForgeMaster.Modules[name] = mod
                if mod.OnEnable then pcall(function() mod:OnEnable() end) end
                status:SetText("|cff00ff00Hot-swapped module:|r "..name)
            else
                status:SetText("|cffff0000Failed to reload module:|r "..name.."\n"..tostring(mod))
            end
        end)
        if not ok then
            status:SetText("|cffff0000Error during hot-swap:|r "..tostring(err))
        end
    end

    swapBtn:SetScript("OnClick", function()
        if selectedModule then
            hotSwapModule(selectedModule)
        else
            status:SetText("Select a module to hot-swap.")
        end
    end)

    f:Show()
    parent.View = f
    return f
end

return HotSwap
