#!/usr/bin/env bash

# Preparation
# TODO change to input file
#cp ./example/example.postman_collection.json workdir/postman_collection.json
#cp ./example/URI-Getter.postman_collection.json workdir/postman_collection.json
cp ./example/SCIMProxy.postman_collection.json workdir/postman_collection.json
cp ./example/example_dev.postman_environment.json workdir/postman_environment.json


# Replace postman variable syntax with jmeter variable syntax
sed -i 's/{{\([^}]\+\)}}/${\1}/g' ./workdir/postman_collection.json
sed -i 's/\\r//g' ./workdir/postman_collection.json
sed -i 's/\\n//g' ./workdir/postman_collection.json
sed -i 's/\\t//g' ./workdir/postman_collection.json

# Execution
string_result=$(jsonnet create_jmx.jsonnet)

# Postprocessing
printf '%b\n' "$string_result" > workdir/tmp_result.jmx

sed -i 's/^"//' workdir/tmp_result.jmx
sed -i 's/"$//' workdir/tmp_result.jmx
sed -i 's/\\"/"/g' workdir/tmp_result.jmx
sed -i '1 i\<?xml version="1.0" encoding="UTF-8"?>' workdir/tmp_result.jmx

xmllint --format workdir/tmp_result.jmx > workdir/result.jmx

cp workdir/result.jmx workdir/result.xml