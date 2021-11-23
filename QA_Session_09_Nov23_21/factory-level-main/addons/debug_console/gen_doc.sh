#!/bin/sh

output=$(class_doctool ${1?:provide a file name})

if [ $? -eq 0 ]; then
    echo "$output" > docs/${1%.gd}.html
fi
