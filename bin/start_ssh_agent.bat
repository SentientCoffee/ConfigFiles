:: Do not use "echo off" to not affect any child calls.

:: Enable extensions, the `verify` call is a trick from the setlocal help
@verify other 2>nul
@setlocal EnableDelayedExpansion
@if ERRORLEVEL 1 (
    @echo Unable to enable extensions.
    @goto failure
)

:: Start the ssh-agent if needed by git
@for %%i in ("git.exe") do @(set GIT=%%~$PATH:i)
@if exist "%GIT%" @(
    :: Get the ssh-agent executable
    for %%i in ("ssh-agent.exe") do @set SSH_AGENT=%%~$PATH:i
    if not exist "%SSH_AGENT%" @(
        for %%s in ("%GIT%") do @set GIT_DIR=%%~dps
        for %%s in ("!GIT_DIR!") do @set GIT_DIR=!GIT_DIR:~0,-1!
        for %%s in ("!GIT_DIR!") do @set GIT_ROOT=%%~dps
        for %%s in ("!GIT_ROOT!") do @set GIT_ROOT=!GIT_ROOT:~0,-1!
        for /d %%s in ("!GIT_ROOT!\usr\bin\ssh-agent.exe") do @set SSH_AGENT=%%~s
        if not exist "!SSH_AGENT!" @goto ssh-agent-done
    )
    :: Get the ssh-add executable
    for %%s in ("!SSH_AGENT!") do @set BIN_DIR=%%~dps
    for %%s in ("!BIN_DIR!") do @set BIN_DIR=!BIN_DIR:~0,-1!
    for /d %%s in ("!BIN_DIR!\ssh-add.exe") do @set SSH_ADD=%%~s
    if not exist "!SSH_ADD!" @goto ssh-agent-done

    :: Check if the agent is running
    for /f "tokens=1-2" %%a in ('tasklist /nh /fi "imagename eq ssh-agent.exe" ^| findstr /r /c:"^$" /v') do @(
        echo %%b | findstr /r /c:"[0-9][0-9]*" >nul
        if "!ERRORLEVEL!" == "0" @(
            @set SSH_AGENT_PID=%%b
        ) else @(
            :: Unset in the case a user kills the agent while a session is open
            :: needed to remove the old files and prevent a false message
            @set SSH_AGENT_PID=
        )
    )
    :: Connect up the current ssh-agent
    if [!SSH_AGENT_PID!] == []  @(
        @echo Removing old ssh-agent sockets...
        for /d %%d in (%TEMP%\ssh-??????*) do @(rmdir /s /q %%d)
    ) else @(
        @echo Found ssh-agent at !SSH_AGENT_PID!
        for /d %%d in (%TEMP%\ssh-??????*) do @(
            for %%f in (%%d\agent.*) do @(
                @set SSH_AUTH_SOCK=%%f
                @set SSH_AUTH_SOCK=!SSH_AUTH_SOCK:%TEMP%=/tmp!
                @set SSH_AUTH_SOCK=!SSH_AUTH_SOCK:\=/!
            )
        )
        @if not [!SSH_AUTH_SOCK!] == [] @(
            @echo Found ssh-agent socket at !SSH_AUTH_SOCK!.
        ) else (
            @echo Failed to find ssh-agent socket.
            @set SSH_AGENT_PID=
        )
    )

    :: See if we have the key
    "!SSH_ADD!" -l 1>NUL 2>NUL
    set result=!ERRORLEVEL!
    if not !result! == 0 @(
        if !result! == 2 @(
            echo | @set /p=Starting ssh-agent...
            for /f "tokens=1-2 delims==;" %%a IN ('"!SSH_AGENT!"') do @(
                if not [%%b] == [] @set %%a=%%b
            )
            echo. done
        )
        "!SSH_ADD!" "%USERPROFILE%\.ssh\id_ed25519"
        "!SSH_ADD!" "%USERPROFILE%\.ssh\id_ed25519_ontariotech"
        "!SSH_ADD!" "%USERPROFILE%\.ssh\id_ed25519_dbs-mkm"
        "!SSH_ADD!" "%USERPROFILE%\.ssh\id_ed25519_gerrit"
        echo.
    )
)

:ssh-agent-done
:failure

@endlocal & @set "SSH_AUTH_SOCK=%SSH_AUTH_SOCK%" ^
          & @set "SSH_AGENT_PID=%SSH_AGENT_PID%"

@echo %cmdcmdline% | @findstr /l "\"\"" >NUL
@if not ERRORLEVEL 1 @(
    @call cmd %*
)
