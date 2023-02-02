@REM :: Do not use "echo off" to not affect any child calls.

@REM :: Enable extensions, the `verify` call is a trick from the setlocal help
@REM @verify other 2>nul
@REM @setlocal EnableDelayedExpansion
@REM @if ERRORLEVEL 1 (
@REM     @echo Unable to enable extensions.
@REM     @goto failure
@REM )

@REM :: Start the ssh-agent if needed by git
@REM @for %%i in ("git.exe") do @(set GIT=%%~$PATH:i)
@REM @if exist "%GIT%" @(
@REM     :: Get the ssh-agent executable
@REM     for %%i in ("ssh-agent.exe") do @set SSH_AGENT=%%~$PATH:i
@REM     if not exist "%SSH_AGENT%" @(
@REM         for %%s in ("%GIT%") do @set GIT_DIR=%%~dps
@REM         for %%s in ("!GIT_DIR!") do @set GIT_DIR=!GIT_DIR:~0,-1!
@REM         for %%s in ("!GIT_DIR!") do @set GIT_ROOT=%%~dps
@REM         for %%s in ("!GIT_ROOT!") do @set GIT_ROOT=!GIT_ROOT:~0,-1!
@REM         for /d %%s in ("!GIT_ROOT!\usr\bin\ssh-agent.exe") do @set SSH_AGENT=%%~s
@REM         if not exist "!SSH_AGENT!" @goto ssh-agent-done
@REM     )
@REM     :: Get the ssh-add executable
@REM     for %%s in ("!SSH_AGENT!") do @set BIN_DIR=%%~dps
@REM     for %%s in ("!BIN_DIR!") do @set BIN_DIR=!BIN_DIR:~0,-1!
@REM     for /d %%s in ("!BIN_DIR!\ssh-add.exe") do @set SSH_ADD=%%~s
@REM     if not exist "!SSH_ADD!" @goto ssh-agent-done

@REM     :: Check if the agent is running
@REM     for /f "tokens=1-2" %%a in ('tasklist /nh /fi "imagename eq ssh-agent.exe" ^| findstr /r /c:"^$" /v') do @(
@REM         echo %%b | findstr /r /c:"[0-9][0-9]*" >nul
@REM         if "!ERRORLEVEL!" == "0" @(
@REM             @set SSH_AGENT_PID=%%b
@REM         ) else @(
@REM             :: Unset in the case a user kills the agent while a session is open
@REM             :: needed to remove the old files and prevent a false message
@REM             @set SSH_AGENT_PID=
@REM         )
@REM     )
@REM     :: Connect up the current ssh-agent
@REM     if [!SSH_AGENT_PID!] == []  @(
@REM         @echo Removing old ssh-agent sockets...
@REM         for /d %%d in (%TEMP%\ssh-??????*) do @(rmdir /s /q %%d)
@REM     ) else @(
@REM         @echo Found ssh-agent at !SSH_AGENT_PID!
@REM         for /d %%d in (%TEMP%\ssh-??????*) do @(
@REM             for %%f in (%%d\agent.*) do @(
@REM                 @set SSH_AUTH_SOCK=%%f
@REM                 @set SSH_AUTH_SOCK=!SSH_AUTH_SOCK:%TEMP%=/tmp!
@REM                 @set SSH_AUTH_SOCK=!SSH_AUTH_SOCK:\=/!
@REM             )
@REM         )
@REM         @if not [!SSH_AUTH_SOCK!] == [] @(
@REM             @echo Found ssh-agent socket at !SSH_AUTH_SOCK!.
@REM         ) else (
@REM             @echo Failed to find ssh-agent socket.
@REM             @set SSH_AGENT_PID=
@REM         )
@REM     )

@REM     :: See if we have the key
@REM     "!SSH_ADD!" -l 1>NUL 2>NUL
@REM     set result=!ERRORLEVEL!
@REM     if not !result! == 0 @(
@REM         if !result! == 2 @(
@REM             echo | @set /p=Starting ssh-agent...
@REM             for /f "tokens=1-2 delims==;" %%a IN ('"!SSH_AGENT!"') do @(
@REM                 if not [%%b] == [] @set %%a=%%b
@REM             )
@REM             echo. done
@REM         )
@REM         "!SSH_ADD!" "%USERPROFILE%\.ssh\id_ed25519"
@REM         "!SSH_ADD!" "%USERPROFILE%\.ssh\id_ed25519_ontariotech"
@REM         "!SSH_ADD!" "%USERPROFILE%\.ssh\id_ed25519_dbs-mkm"
@REM         "!SSH_ADD!" "%USERPROFILE%\.ssh\id_ed25519_gerrit"
@REM         echo.
@REM     )
@REM )

@REM :ssh-agent-done
@REM :failure

@REM @endlocal & @set "SSH_AUTH_SOCK=%SSH_AUTH_SOCK%" ^
@REM           & @set "SSH_AGENT_PID=%SSH_AGENT_PID%"

@REM @echo %cmdcmdline% | @findstr /l "\"\"" >NUL
@REM @if not ERRORLEVEL 1 @(
@REM     @call cmd %*
@REM )

@"C:\Program Files\Git\usr\bin\bash.exe" -c "${HOME}/.config/shell/ssh_autostart.sh"
