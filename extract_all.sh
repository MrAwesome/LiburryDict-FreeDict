#!/bin/bash

set -euxo pipefail

cd "$(dirname $0)"

for db in dbs/*; do
    tar xf "$db"  --directory extracted/ --wildcards '*/*.tei'
done
