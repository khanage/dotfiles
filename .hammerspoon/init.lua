launch = hs.application.launchOrFocus
hs.hotkey.bind({ "cmd", "shift" }, "1", function() launch("iTerm") end)
hs.hotkey.bind({ "cmd", "shift" }, "3", function() launch("Slack") end)
hs.hotkey.bind({ "cmd", "shift" }, "2", function() launch("Firefox") end)
hs.hotkey.bind({ "cmd", "shift" }, "4", function() launch("Microsoft Outlook") end)
hs.hotkey.bind({ "cmd", "shift" }, "5", function() launch("Microsoft Teams") end)
hs.hotkey.bind({ "cmd", "shift" }, "=", function() launch("Obsidian") end)
hs.hotkey.bind({ "cmd", "shift" }, "0", function() hs.reload() end)
