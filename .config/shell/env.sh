export XDG_CACHE_HOME="${XDG_CACHE_HOME:="${HOME}/.cache"}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:="${HOME}/.config"}"
export XDG_DATA_HOME="${XDG_DATA_HOME:="${HOME}/.local/share"}"
export XDG_STATE_HOME="${XDG_STATE_HOME:="${HOME}/.local/state"}"
export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:="/run/user/${UID}"}"

# ----------------------------------------------------------------------------

export ANDROID_HOME="${XDG_DATA_HOME}/android"

export CARGO_HOME="${XDG_DATA_HOME}/cargo"
export CLANG_FOLDER="/c/BuildTools/VC/Tools/Llvm"
export COLORTERM="truecolor"

export GOPATH="${XDG_DATA_HOME}/go"

export LESSHISTFILE="${XDG_CACHE_HOME}/less/history"

export MICRO_TRUECOLOR=1

export RUSTUP_HOME="${XDG_DATA_HOME}/rustup"

export UPDATEDB_DIR="${XDG_CACHE_HOME}/locate"

# ----------------------------------------------------------------------------

export BROWSER="brave"
export EDITOR="code"

export PATH="${PATH}:${HOME}/.local/bin:${HOME}/desktop"
