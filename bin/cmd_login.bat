@echo off

echo ---------- Setting up environment ----------

:: ---------------------------------------
:: Directory aliases
:: ---------------------------------------
subst W: %UserProfile%\Repos\WORK >nul

:: ---------------------------------------
:: Custom prompt
:: ---------------------------------------
call %UserProfile%\bin\cmd_prompt.bat

:: ---------------------------------------
:: Start ssh-agent
:: ---------------------------------------
:: echo ---------- Starting ssh-agent ----------
:: call %UserProfile%\bin\start_ssh_agent.bat
call "C:\Program Files\Git\usr\bin\bash.exe" -c "${HOME}/.config/shell/ssh_autostart.sh"

:: ---------------------------------------
:: Refresh environment variables (just in case)
:: ---------------------------------------
echo ---------- Refreshing environment variables ----------
call %UserProfile%\bin\refresh_env.bat
