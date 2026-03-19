-- ForgeMaster_Prime: Core Engine
local addonName, FMP = ...
FMP.Queue = {}
FMP.IsScanning = false

-- Function for the XML Button to call
function ForgeMaster_StartScan(itemID)
    local id = tonumber(itemID)
    if id then
        table.insert(FMP.Queue, { id = id })
        if not FMP.IsScanning then FMP:ProcessQueue() end
    else
        print("|cffff0000ForgeMaster:|r Invalid Item ID.")
    end
end

function FMP:ProcessQueue()
    if #self.Queue == 0 then 
        print("|cff00ff00ForgeMaster:|r Scan Complete.")
        self.IsScanning = false 
        return 
    end
    
    if C_AuctionHouse.IsThrottledMessageSystemReady() then
        local nextItem = table.remove(self.Queue, 1)
        print("|cff00ffffForgeMaster:|r Scanning ItemID " .. nextItem.id)
        C_AuctionHouse.SendSearchQuery(C_AuctionHouse.MakeItemKey(nextItem.id), {}, false)
        self.IsScanning = true
    end
    
    C_Timer.After(0.8, function() self:ProcessQueue() end)
end