-- BugViewer: Core error capture and storage
local ADDON_NAME = ...
local BugViewer = {}

-- Persistent storage
global BugViewerDB

-- Error structure: {message, stack, time, session, count}
BugViewer.errors = {}

-- Hook for error capture
local origHandler = geterrorhandler()
local function BugViewer_ErrorHandler(err)
    local stack = debugstack(2)
    local now = date("%Y-%m-%d %H:%M:%S")
    -- Check for duplicate (same message+stack)
    for _, e in ipairs(BugViewer.errors) do
        if e.message == err and e.stack == stack then
            e.count = e.count + 1
            e.time = now
            return
        end
    end
    table.insert(BugViewer.errors, {
        message = err,
        stack = stack,
        time = now,
        session = GetTime(),
        count = 1,
    })
    -- Call original handler
    origHandler(err)
end

seterrorhandler(BugViewer_ErrorHandler)

-- On load: restore DB
local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("PLAYER_LOGOUT")
f:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == ADDON_NAME then
        if BugViewerDB and type(BugViewerDB) == "table" then
            BugViewer.errors = BugViewerDB
        else
            BugViewer.errors = {}
        end
    elseif event == "PLAYER_LOGOUT" then
        BugViewerDB = BugViewer.errors
    end
end)

_G["BugViewer"] = BugViewer
