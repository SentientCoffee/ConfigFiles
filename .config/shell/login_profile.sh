printf -- "---------- Updating database for locate command... ----------\n"

UPDATEDB_DIR="${XDG_CACHE_HOME}/plocate"
mkdir -p "${UPDATEDB_DIR}"
/usr/bin/updatedb -l 0 -o "${UPDATEDB_DIR}/plocate.db"

printf -- "Done.\n\n"
