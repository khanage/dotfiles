Config {
     font =         "xft:Inconsolata-12"
   , bgColor =      "#0C0C0C"
   , fgColor =      "#9B26AF"
   , position =     BottomW C 95
   , alpha = 100
   , border =       BottomB
   , borderColor = "#8B169F"
   , sepChar =  "%"
   , alignSep = "}{"
   , template = "%StdinReader% }{ %battery% | %multicpu% | %memory% | %dynnetwork% | %volume% | %date% "
   , lowerOnStart =     True    -- send to bottom of window stack on start
   , hideOnStart =      False   -- start with window unmapped (hidden)
   , allDesktops =      True    -- show on all desktops
   --, overrideRedirect = True    -- set the Override Redirect flag (Xlib)
   --, pickBroadest =     False   -- choose widest display (multi-monitor)
   , persistent =       True    -- enable/disable hiding (True = disabled)
   , commands =
        -- volume monitor
        [ Run Com            "sh" ["/home/khan/.xmonad/volume.sh"] "volume" 10

        -- network monitor
        , Run DynNetwork     [ "--template" , "<tx>kB/s|<rx>kB/s"
                             , "--Low"      , "10000"       -- units: kB/s
                             , "--High"     , "50000"       -- units: kB/s
                             , "--high"     , "darkred"
                             ] 10

        -- cpu activity monitor
        , Run MultiCpu       [ "--template" , "Cpu: <total0>%|<total1>%|<total2>%|<total3>%"
                             , "--Low"      , "50"         -- units: %
                             , "--High"     , "85"         -- units: %
                             , "--normal"   , "darkorange"
                             , "--high"     , "darkred"
                             ] 10

        -- memory usage monitor
        , Run Memory         [ "--template" ,"Mem: <usedratio>%"
                             , "--Low"      , "20"        -- units: %
                             , "--High"     , "80"        -- units: %
                             , "--high"     , "darkred"
                             ] 10

        -- battery monitor
        , Run Battery        [ "--template" , "Batt: <acstatus>"
                             , "--Low"      , "15"        -- units: %
                             , "--High"     , "80"        -- units: %
                             , "--low"      , "darkred"
                             , "--normal"   , "darkorange"

                             , "--" -- battery specific options
                                       -- discharging status
                                       , "-o"	, "<left>% (<timeleft>)"
                                       -- AC "on" status
                                       , "-O"	, "<fc=#dAA520>Charging</fc> <left>%"
                                       -- charged status
                                       , "-i"	, "<fc=#800080>Charged</fc>"
                             ] 50
        -- stdin reader
        , Run StdinReader

        -- datetime indicator
        , Run Date           "<fc=#ABABAB>%D %A %T</fc>" "date" 10
        ]
   }
