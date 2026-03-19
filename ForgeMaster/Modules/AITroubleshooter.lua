local AI = {}

local AI = {}
function AI:OnInitialize()
    seterrorhandler(function(err)
        local stack = debugstack(2)
        local prompt = string.format(
            "Act as a WoW Addon Developer. Fix this 12.0.1 Lua Error:\n" ..
            "ERROR: %s\nSTACK: %s\nCONTEXT: [Combat Lockdown: %s]",
            err, stack, tostring(InCombatLockdown())
        )
        ForgeMaster:CopyToClipboard(prompt)
        print("|cffff0000ForgeMaster AI:|r Crash detected. Debug prompt copied to clipboard.")
    end)
end
