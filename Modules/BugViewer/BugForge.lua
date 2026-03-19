-- BugForge: Core error capture and storage
local ADDON_NAME = ...
local BugForge = {}

-- Error structure: {message, stack, time, session, count}
BugForge.errors = {}

-- Error handler hook (WoW API)
local origHandler = geterrorhandler and geterrorhandler() or function(msg) print(msg) end
local function BugForge_ErrorHandler(err)
    local stack = debugstack and debugstack(2) or "(no stack)"
    local now = date and date("%Y-%m-%d %H:%M:%S") or "(no date)"
    local session = GetTime and GetTime() or 0
    -- Check for duplicate (same message+stack)
    for _, e in ipairs(BugForge.errors) do
        if e.message == err and e.stack == stack then
            e.count = (e.count or 1) + 1
            e.time = now
            return
        end
    end
    table.insert(BugForge.errors, {
        message = err,
        stack = stack,
        time = now,
        session = session,
        count = 1,
    })
    -- Call original handler
    if origHandler then origHandler(err) end
end

if seterrorhandler then seterrorhandler(BugForge_ErrorHandler) end

-- On load: restore DB
local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("PLAYER_LOGOUT")
f:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == ADDON_NAME then
        if _G.BugForgeDB and type(_G.BugForgeDB) == "table" then
            BugForge.errors = _G.BugForgeDB
        else
            BugForge.errors = {}
        end
    elseif event == "PLAYER_LOGOUT" then
        _G.BugForgeDB = BugForge.errors
    end
end)

_G["BugForge"] = BugForge
