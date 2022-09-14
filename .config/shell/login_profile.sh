echo -e "===== Updating database for locate command... ===== "

mkdir -p "${UPDATEDB_DIR}"
updatedb --output="${UPDATEDB_DIR}/locate.db"
