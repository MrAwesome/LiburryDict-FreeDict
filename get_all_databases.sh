#!/bin/sh

set -euxo pipefail
cd "$(dirname $0)"

mkdir -p "$DB_DIR"

curl https://freedict.org/freedict-database.json > /tmp/freedict-database.json

jq -r < /tmp/freedict-database.json '.[] | select(.headwords != null and .releases != null) | (.releases[] | select(.platform == "src")).URL' > /tmp/all_dicts.txt

# Note: spaces in filenames will break this, but it seems unlikely freedict would ever add them.
for dict in $(cat /tmp/all_dicts.txt); do
    wget -P "$DB_DIR" "$dict"
done
