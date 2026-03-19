-- ForgeMaster_Prime: Core Engine
local addonName, FMP = ...
FMP.Queue = {}
FMP.IsScanning = false

local function UpdateStatus(text)
    if ForgeMaster_StatusText then
        ForgeMaster_StatusText:SetText("Status: " .. text)
    end
end

function ForgeMaster_StartScan(itemID)
    local id = tonumber(itemID)
    if id then
        table.insert(FMP.Queue, { id = id })
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
        return 
    end
    
    if C_AuctionHouse.IsThrottledMessageSystemReady() then
        local nextItem = table.remove(self.Queue, 1)
        UpdateStatus("Scanning: " .. nextItem.id .. " (" .. #self.Queue .. " left)")
        C_AuctionHouse.SendSearchQuery(C_AuctionHouse.MakeItemKey(nextItem.id), {}, false)
        self.IsScanning = true
    else
        UpdateStatus("|cffaaaaaaThrottled... waiting|r")
    end
    
    C_Timer.After(0.8, function() self:ProcessQueue() end)
end