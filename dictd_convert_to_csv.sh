#!/bin/bash

set -euxo pipefail
cd "$(dirname $0)"

. ./lib.sh

E="$EXTRACTED_DICTD_DIR"
cd "$E"

echo * | xargs -n1 | xargs -P "$PARELLELISM" -I{} ../../dictd_wrapper.sh {}/*.dict.dz {}/*.index {}/{}.csv
