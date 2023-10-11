@echo off

echo ========== Setting up environment ==========

:: ---------------------------------------
:: Start ssh-agent
:: ---------------------------------------
call "C:\Program Files\Git\usr\bin\bash.exe" -c "${HOME}/.config/shell/ssh_autostart.sh"

:: ---------------------------------------
:: Custom prompt
:: ---------------------------------------
call %UserProfile%\bin\cmd_prompt.bat

:: ---------------------------------------
:: Refresh environment variables (just in case)
:: ---------------------------------------
echo ========== Refreshing environment variables ==========
call %UserProfile%\bin\refresh_env.bat
