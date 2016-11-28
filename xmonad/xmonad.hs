import XMonad
import XMonad.Layout.Spacing
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run (spawnPipe)
import XMonad.Util.EZConfig (additionalKeys)
import System.IO

main = do
  xmproc <- spawnPipe "/run/current-system/sw/bin/xmobar /home/khan/.xmobarrc"
  xmonad $ defaultConfig
	{ manageHook = manageHook defaultConfig <+> manageDocks
        , terminal = "urxvt"
	-- , layoutHook = avoidStruts  $  layoutHook defaultConfig
        , layoutHook = avoidStruts $ smartSpacing 50 $ Tall 1 (3/100) (1/2)
        , handleEventHook = handleEventHook defaultConfig <+> docksEventHook
	, logHook = dynamicLogWithPP xmobarPP
			{ ppOutput = hPutStrLn xmproc
			, ppTitle = xmobarColor "green" "" . shorten 50
			}
      	}
