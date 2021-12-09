#!/usr/bin/env bash

PACKAGES=$(lerna list -p -l)
PACKAGE_NAMES=()
EXIT_CODE=0

arraySet() { 
    local array=$1 index=$2 value=$3
    declare "$array_$index=$value"
}

arrayGet() { 
    local array=$1 index=$2
    local i="${array}_$index"
    printf '%s' "${!i}"
}

# Loop through packages
while IFS= read -r line; do

    # Read package info
    IFS=':' read -ra ADDR <<< "$line"
    PACKAGE_PATH="${ADDR[0]}"
    PACKAGE_NAME="${ADDR[1]}"
    PACKAGE_VERSION="${ADDR[2]}"

    # Calculate current and previous package paths / names
    PREV="$PACKAGE_NAME@canary"
    CURRENT="$PACKAGE_PATH/dist/"


    # Run the comparison and record the exit code
    echo ""
    echo ""
    echo "${PACKAGE_NAME}"
    echo "================================================="
    node /Users/levente.balogh/grafana/poc3/dist/bin.js compare --prev $PREV --current $CURRENT

    # Check if the comparison returned with a non-zero exit code
    # Record the output, maybe with some additional information
    # declare "RETURN_VALUES_$PACKAGE_NAME=$?"
    STATUS=$?

    # Final exit code
    # (non-zero if any of the packages failed the checks) 
    if [ $STATUS -gt 0 ]
    then
        EXIT_CODE=1
    fi


    # Final message

    # echo "Path: ${PACKAGE_PATH}"
    # echo "Name: ${PACKAGE_NAME}"
    # echo "Version: ${PACKAGE_VERSION}"
    # echo "--prev: $PREV"
    # echo "--current: $CURRENT"
    # echo ""
    # echo ""
done <<< "$PACKAGES"

# Loop through the outputs  
    # 1) format a final message
    # 2) compute final exit code

# Export final message as an environment variable

# Return with the computed exit code
