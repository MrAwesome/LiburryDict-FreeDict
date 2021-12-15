#!/bin/bash

#set -euxo pipefail
cd "$(dirname $0)"

. ./lib.sh

mkdir -p "$BUILD_DIR"

if [ "$1" == "" ]; then
    TARGETS=build/extracted/*/*.tei
else 
    TARGETS=$@
fi

for tei in $TARGETS; do
    dictname=$(basename -s '.tei' "$tei")
    csvname="${BUILD_DIR}/${dictname}.csv"

    echo 'Vocab,Definition' > "$csvname"

    xq < "$tei" | jq -r '
        .TEI.text[].entry[] | 
        [
            .form.orth, 
            (.sense |
                if type == "array" then [.[]] else [.] end |
                .[].cit |
                if type == "array" then [.[]] else [.] end |
                if length > 1 then 
                    [(to_entries[] | "\(.key+1): \(.value.quote)")] | join("'"$SEPARATOR"'") 
                else .[].quote end
            )
        ] | 
        @csv
        ' >> "$csvname"

    if [ "$?" != "0" ]; then
        echo "Failed!!! $tei";
        rm $csvname
        echo "$tei" >> build/FAILED.txt
    else
        echo "Passed: $tei";
    fi 
done

# jq -r '.TEI.text[].entry[] | [.form.orth, (.sense | if type == "array" then [.[]] else [.] end | .[].cit | if type == "array" then [.[]] else [.] end | .[].quote | if type == "array" then [.[]] else [.] end | if length > 1 then [(to_entries[] | "\(.key+1): \(.value)")] | join("☃") else .[] end) | @csv]'
