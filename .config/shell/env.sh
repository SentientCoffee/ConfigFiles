export XDG_CACHE_HOME="${XDG_CACHE_HOME:="${HOME}/.cache"}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:="${HOME}/.config"}"
export XDG_DATA_HOME="${XDG_DATA_HOME:="${HOME}/.local/share"}"
export XDG_STATE_HOME="${XDG_STATE_HOME:="${HOME}/.local/state"}"
export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:="/run/user/${UID}"}"

# ----------------------------------------------------------------------------

export ANDROID_HOME="${XDG_DATA_HOME}/android"

export CARGO_HOME="${XDG_DATA_HOME}/cargo"
export GOPATH="${XDG_DATA_HOME}/go"

export GNUPGHOME="${XDG_DATA_HOME}/gnupg"

export GTK_RC_FILES="${XDG_CONFIG_HOME}/gtk-1.0/gtkrc"
export GTK2_RC_FILES="${XDG_CONFIG_HOME}/gtk-2.0/gtkrc"

export LESSHISTFILE="${XDG_CACHE_HOME}/less/history"

export NPM_CONFIG_USERCONFIG="${XDG_CONFIG_HOME}/npm/npmrc"

export QT_QPA_PLATFORMTHEME="qt5ct"

export RUSTUP_HOME="${XDG_DATA_HOME}/rustup"

export UPDATEDB_DIR="${XDG_CACHE_HOME}/plocate"

export WINEPREFIX="${XDG_DATA_HOME}/wineprefixes/default"

export XAUTHORITY="${XDG_RUNTIME_DIR}/Xauthority"
export XCURSOR_PATH="/usr/share/icons:${XDG_DATA_HOME}/icons"
export XINITRC="${XDG_CONFIG_HOME}/x11/xinitrc"

# ----------------------------------------------------------------------------

export BROWSER="librewolf"
export EDITOR="codium"

export PATH="${PATH}:${HOME}/.local/bin:${HOME}/desktop"
