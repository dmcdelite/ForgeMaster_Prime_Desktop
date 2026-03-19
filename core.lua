-- ForgeMaster_Prime: Core Engine
local addonName, FMP = ...
FMP.Queue = {}
FMP.IsScanning = false
FMP._throttleRetries = 0
local MAX_THROTTLE_RETRIES = 150  -- ~2 minutes at 0.8 s/retry before giving up

local function UpdateStatus(text)
    if ForgeMaster_StatusText then
        ForgeMaster_StatusText:SetText("Status: " .. text)
    end
end

-- Initialize SavedVariables on addon load
local function OnAddonLoaded(self, event, addon)
    if addon == addonName then
        if not ForgeMasterDB then ForgeMasterDB = {} end
        if not ForgeMasterDB.history then ForgeMasterDB.history = {} end
        UpdateStatus("Ready")
    end
end

-- Log an entry to persistent history (capped at 500 entries)
local HISTORY_CAP = 500
local function LogHistory(entryType, message)
    if ForgeMasterDB and ForgeMasterDB.history then
        table.insert(ForgeMasterDB.history, {
            type = entryType,
            message = message,
            timestamp = date("%Y-%m-%d %H:%M:%S"),
        })
        local h = ForgeMasterDB.history
        if #h > HISTORY_CAP then
            local trimmed = {}
            local start = #h - HISTORY_CAP + 1
            for i = start, #h do
                trimmed[#trimmed + 1] = h[i]
            end
            ForgeMasterDB.history = trimmed
        end
    end
end

-- Search history for a keyword and print matches
function FMP:SearchHistory(query)
    if not ForgeMasterDB or not ForgeMasterDB.history then
        print("|cffff8000ForgeMaster:|r No history found.")
        return
    end
    local q = query and query:lower() or ""
    local header = q ~= "" and ("History - search: '" .. q .. "'") or "History (all entries)"
    print("|cff00ff80ForgeMaster " .. header .. "|r")
    local count = 0
    for _, entry in ipairs(ForgeMasterDB.history) do
        if q == "" or (entry.message and entry.message:lower():find(q, 1, true)) then
            print(string.format("  [%s] %s: %s", entry.timestamp, entry.type, entry.message))
            count = count + 1
        end
    end
    if count == 0 then
        print("|cffff8000ForgeMaster:|r No matching history entries.")
    end
end

-- Global wrapper so the XML button can call history search
function ForgeMasterPrime_SearchHistory(query)
    FMP:SearchHistory(query)
end

-- Slash command: /fm history [query] | /fm history clear
SLASH_FORGEMASTER1 = "/fm"
SlashCmdList["FORGEMASTER"] = function(msg)
    local cmd, rest = msg:match("^(%S+)%s*(.*)")
    if cmd and cmd:lower() == "history" then
        if (rest or ""):lower() == "clear" then
            if ForgeMasterDB and ForgeMasterDB.history then
                ForgeMasterDB.history = {}
                print("|cff00ff80ForgeMaster:|r History cleared.")
            end
        else
            FMP:SearchHistory(rest ~= "" and rest or nil)
        end
    else
        print("|cff00ff80ForgeMaster Prime|r - Commands:")
        print("  /fm history [search] - Search previous scan history")
        print("  /fm history clear    - Wipe all history entries")
    end
end

function ForgeMaster_StartScan(itemID)
    local id = tonumber(itemID)
    if id then
        table.insert(FMP.Queue, { id = id })
        LogHistory("scan", "Item " .. id)
        UpdateStatus("Item " .. id .. " added to queue.")
        if not FMP.IsScanning then FMP:ProcessQueue() end
    else
        UpdateStatus("|cffff0000Invalid ID|r")
    end
end

function FMP:ProcessQueue()
    if #self.Queue == 0 then 
        UpdateStatus("|cff00ff00Scan Complete|r")
        self.IsScanning = false
        self._throttleRetries = 0
        return 
    end

    -- Mark as scanning immediately so concurrent StartScan calls don't spawn a second loop
    self.IsScanning = true

    if C_AuctionHouse.IsThrottledMessageSystemReady() then
        self._throttleRetries = 0
        local nextItem = table.remove(self.Queue, 1)
        UpdateStatus("Scanning: " .. nextItem.id .. " (" .. #self.Queue .. " left)")
        C_AuctionHouse.SendSearchQuery(C_AuctionHouse.MakeItemKey(nextItem.id), {}, false)
    else
        self._throttleRetries = self._throttleRetries + 1
        if self._throttleRetries >= MAX_THROTTLE_RETRIES then
            UpdateStatus("|cffff0000Scan timed out (throttled too long)|r")
            self.Queue = {}
            self.IsScanning = false
            self._throttleRetries = 0
            return
        end
        UpdateStatus("|cffaaaaaaThrottled... waiting|r")
    end
    
    C_Timer.After(0.8, function() self:ProcessQueue() end)
end

-- Register addon loaded event
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:SetScript("OnEvent", OnAddonLoaded)