@echo off

:: --------------------------------------------------
:: Directory aliases
:: --------------------------------------------------

subst W: %UserProfile%\Repos\WORK

:: --------------------------------------------------
:: Command aliases
:: --------------------------------------------------

doskey cat=%UserProfile%\bin\bat\bat.exe $*
doskey cd=cd /d $*

doskey ls=dir /w /oG $*
doskey ls1=dir /b /oG $*
doskey ll=dir /n /oG $*

