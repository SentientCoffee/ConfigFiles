@echo off
cls
echo [101;93m STYLES [0m
echo ^<ESC^>[0m [0m Reset [0m
echo ^<ESC^>[1m [1m Bold [0m
echo ^<ESC^>[4m [4m Underline [0m
echo ^<ESC^>[7m [7m Inverse [0m
echo.
echo [101;93m FOREGROUND COLORS [0m
echo ^<ESC^>[30m [30m Black [0m (black)
echo ^<ESC^>[31m [31m Red [0m
echo ^<ESC^>[32m [32m Green [0m
echo ^<ESC^>[33m [33m Yellow [0m
echo ^<ESC^>[34m [34m Blue [0m
echo ^<ESC^>[35m [35m Magenta [0m
echo ^<ESC^>[36m [36m Cyan [0m
echo ^<ESC^>[37m [37m White [0m
echo ^<ESC^>[90m [90m Bright Black [0m
echo ^<ESC^>[91m [91m Bright Red [0m
echo ^<ESC^>[92m [92m Bright Green [0m
echo ^<ESC^>[93m [93m Bright Yellow [0m
echo ^<ESC^>[94m [94m Bright Blue [0m
echo ^<ESC^>[95m [95m Bright Magenta [0m
echo ^<ESC^>[96m [96m Bright Cyan [0m
echo ^<ESC^>[97m [97m Bright White [0m
echo.
@REM echo [101;93m STRONG FOREGROUND COLORS [0m
echo.
echo [101;93m BACKGROUND COLORS [0m
echo ^<ESC^>[40m  [40m Black [0m
echo ^<ESC^>[41m  [41m Red [0m
echo ^<ESC^>[42m  [42m Green [0m
echo ^<ESC^>[43m  [43m Yellow [0m
echo ^<ESC^>[44m  [44m Blue [0m
echo ^<ESC^>[45m  [45m Magenta [0m
echo ^<ESC^>[46m  [46m Cyan [0m
echo ^<ESC^>[47m  [47m White [0m (white)
echo ^<ESC^>[100m [100m Bright Black [0m
echo ^<ESC^>[101m [101m Bright Red [0m
echo ^<ESC^>[102m [102m Bright Green [0m
echo ^<ESC^>[103m [103m Bright Yellow [0m
echo ^<ESC^>[104m [104m Bright Blue [0m
echo ^<ESC^>[105m [105m Bright Magenta [0m
echo ^<ESC^>[106m [106m Bright Cyan [0m
echo ^<ESC^>[107m [107m Bright White [0m
echo.
@REM echo [101;93m STRONG BACKGROUND COLORS [0m
echo.
echo [101;93m COMBINATIONS [0m
echo ^<ESC^>[31m                     [31m red foreground color [0m
echo ^<ESC^>[7m                      [7m inverse foreground ^<-^> background [0m
echo ^<ESC^>[7;31m                   [7;31m inverse red foreground color [0m
echo ^<ESC^>[7m and nested ^<ESC^>[31m [7m before [31m nested [0m
echo ^<ESC^>[31m and nested ^<ESC^>[7m [31m before [7m nested [0m
