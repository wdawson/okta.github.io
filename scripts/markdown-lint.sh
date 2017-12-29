#!/bin/bash

# List of files to run markdown lint checker
files=( "_source/quickstart-fragments" "_source/_code" "_source/_authentication-guide" "_source/_reference")

for i in "${files[@]}"
do
   mdl $i -c .markdownlintrc
done
