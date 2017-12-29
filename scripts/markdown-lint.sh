#!/bin/bash

# List of folders to run markdown lint checker
folders=(
    "_source/quickstart-fragments"
    "_source/_code"
    "_source/_authentication-guide"
    "_source/_reference"
    "_source/_docs/how-to"
    "_source/_3rd_party_notices"
    "_source/_docs/api/getting_started"
)

for i in "${folders[@]}"
do
   mdl $i -c .markdownlintrc
done
