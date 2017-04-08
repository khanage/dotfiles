import           Codec.Binary.UTF8.String     (encodeString)
import           Data.List                    (intercalate)
import           Data.Maybe                   (catMaybes)
import           Graphics.X11.ExtraTypes.XF86
import           System.IO
import           XMonad
import           XMonad.Hooks.DynamicLog
import           XMonad.Hooks.ManageDocks
import           XMonad.Hooks.UrgencyHook     (readUrgents)
import           XMonad.Layout.Spacing
import qualified XMonad.StackSet              as S
import           XMonad.Util.EZConfig         (additionalKeys)
import           XMonad.Util.NamedWindows     (getName)
import           XMonad.Util.Run              (spawnPipe)
import           XMonad.Hooks.EwmhDesktops

main = do
  xmproc <- spawnPipe "xmobar /home/khan/.xmonad/xmobar.hs"
  -- For whatever reason I need to do this twice?
  spawn "amixer set Master 100% ; amixer set Master 100%"
  xmonad $ ewmh def
	{ manageHook = manageHook defaultConfig <+> manageDocks
        , modMask = myModMask
        , focusedBorderColor = focusColor
        , terminal = "urxvt"
        , layoutHook = avoidStruts $ smartSpacingWithEdge 15 $ Tall 1 (3/100) (1/2)
        , handleEventHook = handleEventHook defaultConfig <+> docksEventHook
	, logHook = customLogWithPP xmobarPP
			{ ppOutput = hPutStrLn xmproc
			, ppTitle = xmobarColor focusColor "" . shorten 50
			}
      	} `additionalKeys`
           [ ((0, xF86XK_AudioRaiseVolume), spawn "amixer set Master 2+")
           , ((0, xF86XK_AudioLowerVolume), spawn "amixer set Master 2-")
           , ((0, xF86XK_AudioMute), spawn "amixer set Master toggle")
           , ((myModMask .|. shiftMask, xK_l), sendMessage Shrink)
           , ((myModMask, xK_p), spawn "rofi -show run")
           ]

myModMask = mod4Mask
focusColor = "#69EFAD"

-- | Format the current status using the supplied pretty-printing format,
--   and write it to stdout.
customLogWithPP :: PP -> X ()
customLogWithPP pp = customLogString pp >>= io . ppOutput pp

-- | The same as 'dynamicLogWithPP', except it simply returns the status
--   as a formatted string without actually printing it to stdout, to
--   allow for further processing, or use in some application other than
--   a status bar.
customLogString :: PP -> X String
customLogString pp = do

    winset <- gets windowset
    urgents <- readUrgents
    sort' <- ppSort pp

    -- workspace list
    let ws = pprWindowSet sort' urgents pp winset

    -- window title
    wt <- maybe (return "") (fmap show . getName) . S.peek $ winset

    -- run extra loggers, ignoring any that generate errors.
    extras <- mapM (flip catchX (return Nothing)) $ ppExtras pp

    return $ encodeString . intercalate (ppSep pp) . ppOrder pp $
                        [ ws
                        , ppTitle  pp wt
                        ]
                        ++ catMaybes extras
