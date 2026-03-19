-- ForgeMaster_Prime: UI Layout (Sidebar Navigation)
local ForgeMaster = _G.ForgeMaster or {}
local UI = ForgeMaster


-- Only create the main frame on demand (slash/minimap)
function UI:EnsureMainFrame()
    if not self.MainFrame then
        self:CreateMainFrame()
    end
end

-- Add a slash command to toggle the main frame
SLASH_FORGEMASTER1 = "/forgemaster"
SLASH_FORGEMASTER_PRIME1 = "/fmp"
SlashCmdList["FORGEMASTER"] = function()
    UI:EnsureMainFrame()
    if UI.MainFrame:IsShown() then
        UI.MainFrame:Hide()
    else
        UI.MainFrame:Show()
    end
end
SlashCmdList["FORGEMASTER_PRIME"] = SlashCmdList["FORGEMASTER"]

function UI:CreateMainFrame()
    local f = CreateFrame("Frame", "ForgeMasterMain", UIParent, "PortraitFrameTemplate")
    f:SetSize(850, 550)
    f:SetPoint("CENTER")
    f.TitleText:SetText("ForgeMaster Prime |cff00ff80v1.2.1|r")
    f:Hide()

    -- Progress Bar UI
    local progressBar = CreateFrame("StatusBar", nil, f)
    progressBar:SetSize(320, 18)
    progressBar:SetPoint("BOTTOM", f, "BOTTOM", 0, 32)
    progressBar:SetStatusBarTexture("Interface\\TARGETINGFRAME\\UI-StatusBar")
    progressBar:SetMinMaxValues(0, 14)
    progressBar:SetValue(0)
    progressBar.Text = progressBar:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    progressBar.Text:SetPoint("CENTER")
    progressBar.Text:SetText("Progress: 0/14 modules")

    local updateBtn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    updateBtn:SetSize(140, 24)
    updateBtn:SetPoint("BOTTOM", progressBar, "TOP", 0, 8)
    updateBtn:SetText("Update Progress")
    updateBtn:SetScript("OnClick", function()
        local completed = 0
        if ForgeMaster and ForgeMaster.GetModuleCompletionCount then
            completed = ForgeMaster:GetModuleCompletionCount() or 0
        end
        progressBar:SetValue(completed)
        progressBar.Text:SetText(string.format("Progress: %d/14 modules", completed))
    end)
    
    -- Add background to main frame
    local bg = f:CreateTexture(nil, "BACKGROUND")
    bg:SetTexture([[Interface\\AddOns\\ForgeMaster_Prime\\Media\\FM_Background]])
    bg:SetAllPoints(f)
    f.Bg = bg

    -- Sidebar
    local sidebar = CreateFrame("Frame", nil, f, "BackdropTemplate")
    sidebar:SetPoint("TOPLEFT", f, "TOPLEFT", 4, -60)
    sidebar:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 4, 4)
    sidebar:SetWidth(150)
    if ForgeMaster.Theme and ForgeMaster.Theme.ApplyStyle then ForgeMaster.Theme:ApplyStyle(sidebar) end

    -- Content Area with tabbed frames
    f.Content = {}
    local contentArea = CreateFrame("Frame", nil, f, "BackdropTemplate")
    contentArea:SetPoint("TOPLEFT", sidebar, "TOPRIGHT", 2, 0)
    contentArea:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -4, 4)
    if ForgeMaster.Theme and ForgeMaster.Theme.ApplyStyle then ForgeMaster.Theme:ApplyStyle(contentArea) end
    f.ContentArea = contentArea

    -- Create content frames for each tab first
    local tabNames = {"Dashboard", "Inspector", "Assets", "Warband", "Tables", "Fonts", "Performance", "Events", "API", "Inspect", "HotSwap", "Export", "Taint", "Media", "Log", "Compat", "AI", "Macro", "Settings"}
    for _, name in ipairs(tabNames) do
        local tabFrame = CreateFrame("Frame", nil, contentArea)
        tabFrame:SetAllPoints(contentArea)
        tabFrame:Hide()
        f.Content[name] = tabFrame
    end
    -- Now wire up module UIs
    if ForgeMaster.GetModule then
        local modules = {
            Macro = "MacroRunner",
            AI = "AIAssistant",
            Compat = "CompatChecker",
            Log = "SessionLog",
            Media = "MediaBrowser",
            Taint = "TaintAnalyzer",
            Export = "ExportImport",
            HotSwap = "HotSwap",
            Inspect = "UnitInspector",
            API = "APIExplorer",
            Events = "EventRecorder",
            Performance = "Performance",
            Fonts = "FontStyler",
            Inspector = "Inspector",
            Assets = "AssetBrowser",
            Warband = "WarbandScanner",
            Tables = "TableVisualizer",
            Settings = "Settings",
        }
        for tab, mod in pairs(modules) do
            local m = ForgeMaster:GetModule(mod, true)
            if m and m.CreateView and f.Content[tab] then
                m:CreateView(f.Content[tab])
            elseif f.Content[tab] then
                local label = f.Content[tab]:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
                label:SetPoint("CENTER")
                label:SetText(mod .. " module not loaded.")
            end
        end
    end

    -- Dashboard: simple info panel
    do
        local frame = f.Content["Dashboard"]
        local label = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        label:SetPoint("TOP", 0, -40)
        label:SetText("Welcome to ForgeMaster Prime\nSelect a tool from the sidebar.")
    end

    -- Inspector: module UI
    if ForgeMaster.GetModule then
        local Inspector = ForgeMaster:GetModule("Inspector", true)
        if Inspector and Inspector.CreateView then
            Inspector:CreateView(f.Content["Inspector"])
        else
            local label = f.Content["Inspector"]:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
            label:SetPoint("CENTER")
            label:SetText("Inspector module not loaded.")
        end
    end

    -- Assets: module UI
    if ForgeMaster.GetModule then
        local Assets = ForgeMaster:GetModule("AssetBrowser", true)
        if Assets and Assets.CreateView then
            Assets:CreateView(f.Content["Assets"])
        else
            local label = f.Content["Assets"]:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
            label:SetPoint("CENTER")
            label:SetText("AssetBrowser module not loaded.")
        end
    end

    -- Warband: module UI
    if ForgeMaster.GetModule then
        local Warband = ForgeMaster:GetModule("WarbandScanner", true)
        if Warband and Warband.CreateView then
            Warband:CreateView(f.Content["Warband"])
        else
            local label = f.Content["Warband"]:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
            label:SetPoint("CENTER")
            label:SetText("WarbandScanner module not loaded.")
        end
    end

    -- TableVisualizer: module UI
    if ForgeMaster.GetModule then
        local TableVis = ForgeMaster:GetModule("TableVisualizer", true)
        if TableVis and TableVis.CreateView then
            TableVis:CreateView(f.Content["Tables"])
        else
            local label = f.Content["Tables"]:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
            label:SetPoint("CENTER")
            label:SetText("TableVisualizer module not loaded.")
        end
    end

    -- Add logo to the top of the main frame
    local logo = f:CreateTexture(nil, "OVERLAY")
    logo:SetSize(64, 64)
    logo:SetPoint("TOP", 0, -10)
    logo:SetTexture([[Interface\\AddOns\\ForgeMaster_Prime\\Media\\INV_Gizmo_01_FM]])
    f.Logo = logo

    -- Navigation Buttons
    f.Modules = {}
    local tabs = {
        { name = "Dashboard", icon = "Interface\\Icons\\INV_Gizmo_01" },
        { name = "Inspector", icon = "Interface\\Icons\\INV_Misc_Eye_01" },
        { name = "Assets",    icon = "Interface\\Icons\\INV_Misc_Bag_07" },
        { name = "Warband",   icon = "Interface\\Icons\\INV_Misc_GroupLooking" },
        { name = "Tables",    icon = "Interface\\Icons\\INV_Misc_Note_05" },
        { name = "Fonts",     icon = "Interface\\Icons\\INV_Misc_Quiver_08" },
        { name = "Performance", icon = "Interface\\Icons\\INV_Misc_PocketWatch_01" },
        { name = "Events",    icon = "Interface\\Icons\\INV_Misc_QuestionMark" },
        { name = "API",       icon = "Interface\\Icons\\INV_Misc_Book_09" },
        { name = "Inspect",   icon = "Interface\\Icons\\INV_Misc_Head_Dragon_01" },
        { name = "HotSwap",   icon = "Interface\\Icons\\INV_Misc_ScrewDriver_01" },
        { name = "Export",    icon = "Interface\\Icons\\INV_Misc_Bag_10" },
        { name = "Taint",     icon = "Interface\\Icons\\INV_Misc_Orb_05" },
        { name = "Media",     icon = "Interface\\Icons\\INV_Misc_MonsterClaw_01" },
        { name = "Log",       icon = "Interface\\Icons\\INV_Misc_Note_06" },
        { name = "Compat",    icon = "Interface\\Icons\\INV_Misc_PuzzlePiece_02" },
        { name = "AI",        icon = "Interface\\Icons\\INV_Misc_Gem_Pearl_06" },
        { name = "Macro",     icon = "Interface\\Icons\\INV_Misc_Book_11" },
        { name = "Settings",  icon = "Interface\\Icons\\INV_Gizmo_GoblinBoomBox_01" },
    }
        -- Settings: module UI
        if ForgeMaster.GetModule then
            local Settings = ForgeMaster:GetModule("Settings", true)
            if Settings and Settings.CreateView then
                Settings:CreateView(f.Content["Settings"])
            else
                local label = f.Content["Settings"]:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
                label:SetPoint("CENTER")
                label:SetText("Settings module not loaded.")
            end
        end
    for i, tab in ipairs(tabs) do
        local btn = CreateFrame("Button", nil, sidebar, "UIPanelButtonTemplate")
        btn:SetSize(140, 40)
        btn:SetPoint("TOP", sidebar, "TOP", 0, -10 - ((i-1) * 45))
        btn:SetText(tab.name)
        btn:SetScript("OnClick", function()
            if UI.SwitchTab then UI:SwitchTab(tab.name) end
        end)
        f.Modules[tab.name] = btn
    end
    self.MainFrame = f
end

function UI:SwitchTab(tabName)
    print("|cff00ff80ForgeMaster:|r Switching to " .. tabName)
    if not self.MainFrame or not self.MainFrame.Content then return end
    for name, frame in pairs(self.MainFrame.Content) do
        if name == tabName then
            frame:Show()
        else
            frame:Hide()
        end
    end
end
