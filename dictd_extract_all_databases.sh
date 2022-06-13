#!/bin/bash

set -euxo pipefail
cd "$(dirname $0)"

. ./lib.sh

mkdir -p "$EXTRACTED_DICTD_DIR"

for db in ${DB_DIR}/*; do
    tar xf "$db"  --directory "$EXTRACTED_DICTD_DIR"
done
