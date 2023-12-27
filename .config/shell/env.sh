export XDG_CACHE_HOME="${XDG_CACHE_HOME:="${HOME}/.cache"}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:="${HOME}/.config"}"
export XDG_DATA_HOME="${XDG_DATA_HOME:="${HOME}/.local/share"}"
export XDG_STATE_HOME="${XDG_STATE_HOME:="${HOME}/.local/state"}"
export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:="/run/user/${UID}"}"

# ----------------------------------------------------------------------------

export ANDROID_HOME="${XDG_DATA_HOME}/android"
export ANDROID_SDK_HOME="${ANDROID_HOME}"
export ANDROID_AVD_HOME="${ANDROID_HOME}/avd"
export ANDROID_PATH="${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/emulator"

export CARGO_HOME="${XDG_DATA_HOME}/cargo"
export CHECKUPDATE_DB="${XDG_CACHE_HOME}/checkupdate-${USER}"
export CUDA_CACHE_PATH="${XDG_CACHE_HOME}/nv"

export GNUPGHOME="${XDG_DATA_HOME}/gnupg"
export GOPATH="${XDG_DATA_HOME}/go"
export GTK_RC_FILES="${XDG_CONFIG_HOME}/gtk-1.0/gtkrc"
export GTK2_RC_FILES="${XDG_CONFIG_HOME}/gtk-2.0/gtkrc"

export JAVA_JDK="/usr/lib/jvm/default/bin"

export LESSHISTFILE="${XDG_CACHE_HOME}/less/history"

export NPM_CONFIG_USERCONFIG="${XDG_CONFIG_HOME}/npm/npmrc"

export PYTHONSTARTUP="${XDG_CONFIG_HOME}/python/pythonrc"

export QT_QPA_PLATFORMTHEME="qt5ct"

export RANDFILE="${XDG_DATA_HOME}/rand"
export RUSTUP_HOME="${XDG_DATA_HOME}/rustup"

export UPDATEDB_DIR="${XDG_CACHE_HOME}/plocate"

export WINEPREFIX="${XDG_DATA_HOME}/wineprefixes/default"

export XAUTHORITY="${XDG_RUNTIME_DIR}/Xauthority"
export XCURSOR_PATH="${XDG_DATA_HOME}/icons:/usr/share/icons"
export XINITRC="${XDG_CONFIG_HOME}/x11/xinitrc"

# ----------------------------------------------------------------------------

export BROWSER="librewolf"
export CALCULATOR="speedcrunch"
export EDITOR="focus"

export PATH="${HOME}/.local/bin:${HOME}/desktop:${ANDROID_PATH}:${PATH}"
