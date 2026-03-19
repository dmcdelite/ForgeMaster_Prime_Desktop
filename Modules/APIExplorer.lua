-- Modules/APIExplorer.lua
-- ForgeMaster Prime: API Explorer Module

local APIExplorer = {}


function APIExplorer:CreateView(parent)
    local f = CreateFrame("Frame", nil, parent)
    f:SetAllPoints()

    local title = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 16, -16)
    title:SetText("API Explorer")

    local desc = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    desc:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
    desc:SetWidth(400)
    desc:SetJustifyH("LEFT")
    desc:SetText("Browse, search, and inspect WoW Lua API functions, C API, and global environment. Type a function name to see documentation, usage, and live call results.")

    local searchBox = CreateFrame("EditBox", nil, f, "InputBoxTemplate")
    searchBox:SetSize(220, 28)
    searchBox:SetPoint("TOPLEFT", desc, "BOTTOMLEFT", 0, -16)
    searchBox:SetAutoFocus(false)
    searchBox:SetText("")

    local searchBtn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    searchBtn:SetSize(80, 24)
    searchBtn:SetText("Search")
    searchBtn:SetPoint("LEFT", searchBox, "RIGHT", 8, 0)

    local results = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    results:SetPoint("TOPLEFT", searchBox, "BOTTOMLEFT", 0, -12)
    results:SetWidth(400)
    results:SetJustifyH("LEFT")
    results:SetText("Results will appear here.")

    local callLabel = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    callLabel:SetPoint("TOPLEFT", results, "BOTTOMLEFT", 0, -16)
    callLabel:SetText("Call Function:")
    callLabel:Hide()

    local argBox = CreateFrame("EditBox", nil, f, "InputBoxTemplate")
    argBox:SetSize(220, 24)
    argBox:SetPoint("LEFT", callLabel, "RIGHT", 8, 0)
    argBox:SetAutoFocus(false)
    argBox:SetText("")
    argBox:Hide()

    local callBtn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    callBtn:SetSize(80, 22)
    callBtn:SetText("Call")
    callBtn:SetPoint("LEFT", argBox, "RIGHT", 8, 0)
    callBtn:Hide()

    local callResult = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    callResult:SetPoint("TOPLEFT", callLabel, "BOTTOMLEFT", 0, -8)
    callResult:SetWidth(400)
    callResult:SetJustifyH("LEFT")
    callResult:Hide()

    local function getGlobalFunctionInfo(name)
        local fn = _G[name]
        if type(fn) == "function" then
            local info = debugstack and debugstack(2, 1, 0) or "<no debug info>"
            return fn, info
        end
        return nil, nil
    end

    local function showFunctionInfo(name)
        local fn, info = getGlobalFunctionInfo(name)
        if fn then
            results:SetText("Function: |cff00ff00"..name.."|r\n"..(info or "<no debug info>"))
            callLabel:Show()
            argBox:Show()
            callBtn:Show()
            callResult:Hide()
        else
            results:SetText("|cffff0000No global function named '|r"..name.."|cffff0000' found.|r")
            callLabel:Hide()
            argBox:Hide()
            callBtn:Hide()
            callResult:Hide()
        end
    end

    local function safeCall(fn, ...)
        local ok, res = pcall(fn, ...)
        if ok then return tostring(res) end
        return "|cffff0000Error:|r "..tostring(res)
    end

    local function parseArgs(str)
        local args = {}
        for arg in string.gmatch(str, "[^,]+") do
            arg = arg:gsub("^%s+", ""):gsub("%s+$", "")
            if tonumber(arg) then
                table.insert(args, tonumber(arg))
            elseif arg == "true" then
                table.insert(args, true)
            elseif arg == "false" then
                table.insert(args, false)
            elseif arg == "nil" then
                table.insert(args, nil)
            else
                table.insert(args, arg)
            end
        end
        return unpack(args)
    end

    local function doSearch()
        local name = searchBox:GetText():gsub("^%s+", ""):gsub("%s+$", "")
        if name == "" then
            results:SetText("Enter a global function name to search.")
            callLabel:Hide()
            argBox:Hide()
            callBtn:Hide()
            callResult:Hide()
            return
        end
        showFunctionInfo(name)
    end

    searchBox:SetScript("OnEnterPressed", function(self)
        doSearch()
        self:ClearFocus()
    end)
    searchBtn:SetScript("OnClick", doSearch)

    callBtn:SetScript("OnClick", function()
        local name = searchBox:GetText():gsub("^%s+", ""):gsub("%s+$", "")
        local fn = _G[name]
        if type(fn) == "function" then
            local args = argBox:GetText()
            local result = safeCall(fn, parseArgs(args))
            callResult:SetText("Result: "..result)
            callResult:Show()
        else
            callResult:SetText("|cffff0000Function not found.|r")
            callResult:Show()
        end
    end)

    f:Show()
    parent.View = f
    return f
end

ForgeMaster:RegisterModule("APIExplorer", APIExplorer)
return APIExplorer
