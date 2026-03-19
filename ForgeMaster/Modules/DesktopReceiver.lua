local Receiver = {}

function Receiver:OnInitialize()
    self:RegisterEvent("PLAYER_ENTERING_WORLD", "ProcessInbound")
end

function Receiver:ProcessInbound()
    local db = ForgeMaster.db.profile
    if db.InboundQueue and #db.InboundQueue > 0 then
        PlaySound(115663)
        if ForgeMaster.MainFrame and ForgeMaster.MainFrame.Workbench and ForgeMaster.MainFrame.Workbench.Editor then
            local latest = db.InboundQueue[#db.InboundQueue]
            ForgeMaster.MainFrame.Workbench.Editor:SetText(latest.payload)
        end
        print("|cff00ff80[ForgeMaster Link]:|r Remote payload injected successfully.")
        wipe(db.InboundQueue)
    end
end
