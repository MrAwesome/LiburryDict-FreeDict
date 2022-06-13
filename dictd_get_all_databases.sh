#!/bin/sh

set -euxo pipefail
cd "$(dirname $0)"

. ./lib.sh

mkdir -p "$DB_DIR"

curl https://freedict.org/freedict-database.json > /tmp/freedict-database.json

jq -r < /tmp/freedict-database.json '.[] | select(.headwords != null and .releases != null) | (.releases[] | select(.platform == "dictd")).URL' > /tmp/all_dicts.txt

# Note: spaces in filenames will break this, but it seems unlikely freedict would ever add them.
cat /tmp/all_dicts.txt | xargs -P "$PARELLELISM" -n 1 wget -P "$DB_DIR" 
