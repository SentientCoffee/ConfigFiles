echo -e "===== Updating database for locate command... ===== "
UPDATEDB_DIR="${XDG_CACHE_HOME}/plocate"

mkdir -p "${UPDATEDB_DIR}"
updatedb -l 0 -o "${UPDATEDB_DIR}/plocate.db"

