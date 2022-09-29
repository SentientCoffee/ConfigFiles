@echo off

:: ---------------------------------------
:: Set prompt to UTF-8
:: ---------------------------------------
chcp 65001 >nul

:: ---------------------------------------
:: Custom prompt
:: ---------------------------------------
call %UserProfile%\bin\cmd_prompt.bat

:: ---------------------------------------
:: Aliases
:: ---------------------------------------
doskey cat=%UserProfile%\bin\bat\bat.exe $*
doskey cd=cd /d $*
doskey cd~=cd /d %UserProfile%\$*

doskey git-dotfiles=git --git-dir="%UserProfile%/.dotfiles" --work-tree="%UserProfile%" $*

doskey lg=%UserProfile%\bin\lazygit\lazygit $*
doskey lg-dotfiles=%UserProfile%\bin\lazygit\lazygit -g "%UserProfile%/.dotfiles" -w "%UserProfile%" $*
doskey ll=dir /n /oG $*
doskey ls=dir /w /oG $*
doskey ls-1=dir /b /oG $*

doskey mkcd=mkdir $* $T chdir /d $*

doskey refresh=%UserProfile%\bin\refresh_env.bat $T %UserProfile%\bin\cmd_autorun.bat

doskey ssh-dbs=ssh dbs-mkm-03
