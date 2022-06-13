#!/bin/bash

set -euxo pipefail
cd "$(dirname $0)"

. ./lib.sh

mkdir -p "$EXTRACTED_DICTD_DIR"

echo ${DB_DIR}/* | xargs -n1 | xargs -P "$PARELLELISM" -I{} tar xf {} --directory "$EXTRACTED_DICTD_DIR"
