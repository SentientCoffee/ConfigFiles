echo "---------- Updating database for locate command... ----------"

mkdir -p "${UPDATEDB_DIR}"
updatedb --output="${UPDATEDB_DIR}/locate.db"

source "${XDG_CONFIG_HOME}/shell/ssh_autostart.sh"
