@echo off

doskey cat=%UserProfile%\bin\bat\bat.exe $*
doskey cd=cd /d $*

doskey lg=%UserProfile%\bin\lazygit\lazygit $*
doskey ll=dir /n /oG $*
doskey ls=dir /w /oG $*
doskey ls1=dir /b /oG $*

doskey mkcd=mkdir $* $T chdir /d $*

