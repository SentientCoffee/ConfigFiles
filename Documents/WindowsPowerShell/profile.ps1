$OutputEncoding = [console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

function Prompt {
    function Get-GitInfo {
        $Status = & { git status --porcelain --branch 2>$null }
        if ($Status.count -eq 0) {
            $Error.RemoveAt(0)
            return $null
        }
        $Output = ""

        $Staged    = 0
        $Unstaged  = 0
        $Untracked = 0
        foreach ($line in $Status) {
            if ($line -match "##\s(?<Branch>[^.]+(?:\(no branch\))?)(?:(?:\.\.\.)(?<Remote>[\w/]+))?\s*(?:\[(?:ahead (?<Ahead>\d+))?(?:,\s)?(?:behind (?<Behind>\d+))?[^]]*\])?") {
                $Output = "{0} {1}" -f $BRANCH_ICON, $Matches.Branch
                if ($Matches.ContainsKey("Ahead")) {
                    $Output += " {0} {1}" -f $AHEAD_SYMBOL, $Matches.Ahead
                }
                if ($Matches.ContainsKey("Behind")) {
                    $Output += " {0} {1}" -f $BEHIND_SYMBOL, $Matches.Behind
                }
            }

            elseif ($line -match "^[ACDMR]") {
                $Staged += 1
            }
            elseif ($line -match "^.[DM]") {
                $Unstaged += 1
            }
            elseif ($line -match "^\?") {
                $Untracked += 1
            }
        }

        $Output += " {0}" -f $STATUS_SEPARATOR

        if ($Staged -eq 0 -and $Unstaged -eq 0 -and $Untracked -eq 0) {
            $Output += " {0}" -f $STATUS_CLEAN
        }
        else {
            if ($Staged -gt 0) {
                $Output += " {0} {1}" -f $STAGED_SYMBOL, $Staged
            }
            if ($Unstaged -gt 0) {
                $Output += " {0} {1}" -f $UNSTAGED_SYMBOL, $Unstaged
            }
            if ($Untracked -gt 0) {
                $Output += " {0} {1}" -f $UNTRACKED_SYMBOL, $Untracked
            }
        }

        return $Output
    }

    class PromptColor {
        static [char]$ESC = [char]0x1b
        static [string]$RESET = [PromptColor]::ESC + "[0m"

        [string]$EscSeq

        PromptColor([string]$Fore, [string]$Back) {
            $this.Init($Fore, $Back, $false)
        }

        PromptColor([string]$Fore, [string]$Back, [bool]$Reverse) {
            $this.Init($Fore, $Back, $Reverse)
        }

        hidden Init([string]$Fore, [string]$Back, [bool]$Reverse) {
            if ($Fore -eq "" -and $Back -eq "") {
                $this.EscSeq = [PromptColor]::RESET
                return
            }

            if ($Reverse) {
                $this.EscSeq = [PromptColor]::ESC + "[7m" + [PromptColor]::ESC + "["
            }
            else {
                $this.EscSeq = [PromptColor]::ESC + "["
            }

            switch ($Fore) {
                Black       { $this.EscSeq += "30" }
                DarkRed     { $this.EscSeq += "31" }
                DarkGreen   { $this.EscSeq += "32" }
                DarkYellow  { $this.EscSeq += "33" }
                DarkBlue    { $this.EscSeq += "34" }
                DarkMagenta { $this.EscSeq += "35" }
                DarkCyan    { $this.EscSeq += "36" }
                DarkGray    { $this.EscSeq += "37" }
                Gray        { $this.EscSeq += "90" }
                Red         { $this.EscSeq += "91" }
                Green       { $this.EscSeq += "92" }
                Yellow      { $this.EscSeq += "93" }
                Blue        { $this.EscSeq += "94" }
                Magenta     { $this.EscSeq += "95" }
                Cyan        { $this.EscSeq += "96" }
                White       { $this.EscSeq += "97" }
                Default     { $this.EscSeq += ""  }
            }

            if ($Fore -ne "" -and $Back -ne "") {
                $this.EscSeq += ";"
            }

            switch ($Back) {
                Black       { $this.EscSeq += "40"  }
                DarkRed     { $this.EscSeq += "41"  }
                DarkGreen   { $this.EscSeq += "42"  }
                DarkYellow  { $this.EscSeq += "43"  }
                DarkBlue    { $this.EscSeq += "44"  }
                DarkMagenta { $this.EscSeq += "45"  }
                DarkCyan    { $this.EscSeq += "46"  }
                DarkGray    { $this.EscSeq += "47"  }
                Gray        { $this.EscSeq += "100" }
                Red         { $this.EscSeq += "101" }
                Green       { $this.EscSeq += "102" }
                Yellow      { $this.EscSeq += "103" }
                Blue        { $this.EscSeq += "104" }
                Magenta     { $this.EscSeq += "105" }
                Cyan        { $this.EscSeq += "106" }
                White       { $this.EscSeq += "107" }
                Default     { $this.EscSeq += ""    }
            }

            $this.EscSeq += "m"
        }
    }

    $STARTER          = ""
    $SEPARATOR        = ""
    $ENDER            = ""

    $BRANCH_ICON      = ""
    $STATUS_CLEAN     = ""
    $STATUS_SEPARATOR = "❯"

    $UNTRACKED_SYMBOL = "?"
    $UNSTAGED_SYMBOL  = ""
    $STAGED_SYMBOL    = "⟰"

    $AHEAD_SYMBOL     = ""
    $BEHIND_SYMBOL    = ""

    $STARTER_COLOR_1   = [PromptColor]::new("DarkRed"    , ""          , $true)
    $USER_HOST_COLOR   = [PromptColor]::new("White"      , "DarkRed"          )
    $SEPARATOR_COLOR_1 = [PromptColor]::new("DarkRed"    , "DarkGreen"        )
    $DIRECTORY_COLOR   = [PromptColor]::new("White"      , "DarkGreen"        )
    $ENDER_COLOR_1     = [PromptColor]::new("DarkGreen"  , ""                 )
    $SEPARATOR_COLOR_2 = [PromptColor]::new("DarkGreen"  , "DarkMagenta"      )
    $GIT_COLOR         = [PromptColor]::new("White"      , "DarkMagenta"      )
    $ENDER_COLOR_2     = [PromptColor]::new("DarkMagenta", ""                 )

    $STARTER_COLOR_2    = [PromptColor]::new("DarkBlue"  , ""          , $true)
    $SHELL_PROMPT_COLOR = [PromptColor]::new("White"     , "DarkBlue"         )
    $ENDER_COLOR_3      = [PromptColor]::new("DarkBlue"  , ""                 )

    # -----------------------------------------------

    $prompt_string = ""

    $prompt_string += $STARTER_COLOR_1.EscSeq   + "$STARTER" + [PromptColor]::RESET
    $prompt_string += $USER_HOST_COLOR.EscSeq   + " ${env:Username}@${env:ComputerName} "
    $prompt_string += $SEPARATOR_COLOR_1.EscSeq + "$SEPARATOR"
    $prompt_string += $DIRECTORY_COLOR.EscSeq   + " $(Get-Location) "

    $info = Get-GitInfo
    if ($null -eq $info) {
        $prompt_string += [PromptColor]::RESET + $ENDER_COLOR_1.EscSeq + "$SEPARATOR$ENDER" + [PromptColor]::RESET + "`n"
    }
    else {
        $prompt_string += $SEPARATOR_COLOR_2.EscSeq + "$SEPARATOR"
        $prompt_string += $GIT_COLOR.EscSeq         + " $info "
        $prompt_string += [PromptColor]::RESET + $ENDER_COLOR_2.EscSeq + "$SEPARATOR$ENDER" + [PromptColor]::RESET + "`n"
    }

    $prompt_string += $STARTER_COLOR_2.EscSeq    + "$STARTER" + [PromptColor]::RESET
    $prompt_string += $SHELL_PROMPT_COLOR.EscSeq + " PS "
    if (Test-Path variable:/PSDebugContext) {
        $prompt_string += "(DBG) "
    }
    foreach ($level in 0..$NestedPromptLevel) {
        $prompt_string += ">"
    }
    $prompt_string += " "
    $prompt_string += [PromptColor]::RESET + $ENDER_COLOR_3.EscSeq  + "$SEPARATOR$ENDER" + [PromptColor]::RESET + " "

    return $prompt_string
}

function Refresh-Profile {
    . $PROFILE.CurrentUserAllHosts
    . $PROFILE.CurrentUserCurrentHost
}

function Kill-All {
    param (
        [string]$name
    )

    $tl = & { tasklist }
    $exename = $name
    if ($name -notlike "*.exe") {
        $exename = "{0}.exe" -f $name
    }
    $regex = "{0}[^\d]*(?<PID>\d+).*" -f $exename

    foreach($t in $tl) {
        if ($t -match $regex) {
            $filter = "PID eq {0}" -f $Matches.PID
            taskkill /f /fi $filter
            break
        }
    }
}

New-Alias -Force -Name "lg"      -Value "lazygit.exe"
New-Alias -Force -Name "refresh" -Value "Refresh-Profile"
New-Alias -Force -Name "ka"      -Value "Kill-All"
