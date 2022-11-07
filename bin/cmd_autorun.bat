@echo off

:: ---------------------------------------
:: Set prompt to UTF-8
:: ---------------------------------------
chcp 65001 >nul

:: ---------------------------------------
:: Aliases
:: ---------------------------------------
doskey cat=%UserProfile%\bin\bat\bat.exe $*
doskey cd=cd /d $*

doskey lg=%UserProfile%\bin\lazygit\lazygit $*
doskey ll=dir /n /oG $*
doskey ls=dir /w /oG $*
doskey ls1=dir /b /oG $*

doskey ka=for /f "tokens=2" %%p in ('tasklist /nh ^^^| findstr /i "$*"') do @(taskkill /f /pid %%p)

doskey mkcd=mkdir $* $T chdir /d $*

doskey refresh=%UserProfile%\bin\refresh_env.bat $T %UserProfile%\bin\cmd_autorun.bat

doskey ssh-dbs="C:\Program Files\Git\usr\bin\ssh" dbs-mkm-03
