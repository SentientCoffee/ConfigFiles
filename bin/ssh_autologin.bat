@echo off

subst W: %UserProfile%\Repos\WORK
cmd.exe /k ""C:\Program Files\Git\bin\bash.exe" -c "${HOME}/.config/shell/ssh_autostart.sh""
