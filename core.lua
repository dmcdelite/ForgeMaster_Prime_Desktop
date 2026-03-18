-- TradeMaster_Prime: Core Engine
local addonName, TMP = ...
TMP.Queue = {}
TMP.IsScanning = false

-- The Throttler: Respecting the 2026 AH "Points" Limit
function TMP:ProcessQueue()
    if #self.Queue == 0 then 
        print("|cff00ff00TradeMaster:|r Scan Complete.")
        self.IsScanning = false 
        return 
    end
    
    -- Check if the AH System is ready for a new request
    if C_AuctionHouse.IsThrottledMessageSystemReady() then
        local nextItem = table.remove(self.Queue, 1)
        print("|cff00ffffTradeMaster:|r Scanning ItemID " .. nextItem.id)
        
        -- Patch 11.2 specific search call
        C_AuctionHouse.SendSearchQuery(C_AuctionHouse.MakeItemKey(nextItem.id), {}, false)
        self.IsScanning = true
    end
    
    -- Wait 0.8 seconds before next check to stay "Safe"
    C_Timer.After(0.8, function() self:ProcessQueue() end)
end

-- Slash command to test: /tmp scan 12345
SLASH_TRADEMASTER1 = "/tmp"
SlashCmdList["TRADEMASTER"] = function(msg)
    local id = tonumber(msg:match("scan (%d+)"))
    if id then
        table.insert(TMP.Queue, { id = id })
        if not TMP.IsScanning then TMP:ProcessQueue() end
    else
        print("Usage: /tmp scan <itemID>")
    end
end