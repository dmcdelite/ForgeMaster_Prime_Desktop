-- ForgeMaster global scan stub for XML compatibility
function ForgeMaster_StartScan(itemID)
    print("[ForgeMaster] Scan started for itemID:", itemID or "<none>")
    -- TODO: Implement actual scan logic here
end
-- ForgeMaster_Prime: Core Engine
local addonName, TMP = ...
TMP.Queue = {}
TMP.IsScanning = false

-- The Throttler: Respecting the 2026 AH "Points" Limit
function TMP:ProcessQueue()
    if #self.Queue == 0 then 
        print("|cff00ff00ForgeMaster_Prime:|r Scan Complete.")
        self.IsScanning = false 
        return 
    end
    
    -- Check if the AH System is ready for a new request
    if C_AuctionHouse.IsThrottledMessageSystemReady() then
        local nextItem = table.remove(self.Queue, 1)
        print("|cff00ffffForgeMaster_Prime:|r Scanning ItemID " .. nextItem.id)
        
        -- Patch 11.2 specific search call
        C_AuctionHouse.SendSearchQuery(C_AuctionHouse.MakeItemKey(nextItem.id), {}, false)
        self.IsScanning = true
    end
    
    -- Wait 0.8 seconds before next check to stay "Safe"
    C_Timer.After(0.8, function() self:ProcessQueue() end)
end

-- Usage: /fmp scan <itemID>
SLASH_FORGEMASTER_SCAN1 = "/fmpscan"
SlashCmdList["FORGEMASTER_SCAN"] = function(msg)
    local id = tonumber(msg:match("scan (%d+)"))
    if id then
        table.insert(TMP.Queue, { id = id })
        if not TMP.IsScanning then TMP:ProcessQueue() end
    else
        print("Usage: /fmpscan scan <itemID>")
    end
end