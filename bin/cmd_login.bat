@echo off

:: ---------------------------------------
:: Directory aliases
:: ---------------------------------------
subst W: %UserProfile%\Repos\WORK >nul

:: ---------------------------------------
:: Custom prompt
:: ---------------------------------------
call %UserProfile%\bin\cmd_prompt.bat
setx PROMPT %CUSTOM_PROMPT%

:: ---------------------------------------
:: Refresh environment variables (just in case)
:: ---------------------------------------
echo ---------- Refreshing environment variables ----------
call %UserProfile%\bin\refresh_env.bat

:: ---------------------------------------
:: Start ssh-agent
:: ---------------------------------------
echo ---------- Starting ssh-agent ----------
%UserProfile%\bin\start-ssh-agent.cmd
