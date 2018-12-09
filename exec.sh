#!/bin/sh

for arg in "$@"
do
    echo "- $arg"
    /bin/sh -c "$arg"
    if [ "$?" -ne 0 ]; then
        echo "ERROR EXIT"
        exit 1
    fi
done
