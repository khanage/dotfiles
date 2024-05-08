launch = hs.application.launchOrFocus
hs.hotkey.bind({ "cmd" }, "1", function() launch("iTerm") end)
hs.hotkey.bind({ "cmd" }, "3", function() launch("Slack") end)
hs.hotkey.bind({ "cmd" }, "2", function() launch("Firefox") end)
hs.hotkey.bind({ "cmd" }, "4", function() launch("Microsoft Outlook") end)
hs.hotkey.bind({ "cmd", "ctrl" }, "0", function() hs.reload() end)
