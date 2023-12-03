#!/usr/bin/env bash

set -e

usage() {
    cat <<EOT

$0 - transform postman collections and environments to jmeter jmx files

Usage: $0 [OPTIONS]

Options:
  -c, --collection           Path to postman collection file (mandatory)
  -e, --environment          Path to postman environment file (mandatory)
  -t, --target_file          Path to target jmx file to be created (mandatory)
  -p, --prefix_variables     Space separated string of variables to be prefixed with thread number, e.g. "var1 var2 var3" (optional)
  -s, --suffix_variables     Space separated string of variables to be suffixed with thread number, e.g. "var1 var2 var3" (optional)
  -h, --help                 Show this help
EOT
    exit 3
}


args() {

  while [[ "$1" != "" ]]; do
    case $1 in
      -c|--collection )             shift
                                    COLLECTION="$1"
                                    shift
                                    ;;
      -e|--environment )            shift
                                    ENVIRONMENT="$1"
                                    shift
                                    ;;
      -t|--target_file )            shift
                                    TARGET="$1"
                                    shift
                                    ;;
      -p|--prefix_variables )       shift
                                    PREFIX_VARS="$1"
                                    shift
                                    ;;
      -p|--suffix_variables )       shift
                                    SUFFIX_VARS="$1"
                                    shift
                                    ;;
      -h|--help )                   usage
                                    ;;
      -*)                           echo "Unrecognized option $1"
                                    usage
                                    ;;
      *)                            echo "Unrecognized argument $1"
                                    shift
                                    ;;
    esac
  done

  if [[ "${COLLECTION}" == "" || "${ENVIRONMENT}" == "" || "${TARGET}" == "" ]]; then
    usage
  fi

}

copy_files() {
  [[ -d workdir ]] || mkdir workdir
  cp ${COLLECTION} workdir/postman_collection.json
  cp ${ENVIRONMENT} workdir/postman_environment.json
}

prefix_vars() {
  for var in ${PREFIX_VARS}; do
    echo "Prefixing var $var with thread number"
    sed -i "s/{{$var}}/\${__threadNum}{{$var}}/g" ./workdir/postman_collection.json
  done
}

suffix_vars() {
  for var in ${SUFFIX_VARS}; do
    echo "Suffixing var $var with thread number"
    sed -i "s/{{$var}}/{{$var}}\${__threadNum}/g" ./workdir/postman_collection.json
  done
}

pre_processing() {
  # Replace postman variable syntax with jmeter variable syntax
  sed -i 's/{{\([^}]\+\)}}/${\1}/g' ./workdir/postman_collection.json

  # remove line feeds and tabs
  sed -i 's/\\r//g' ./workdir/postman_collection.json
  sed -i 's/\\n//g' ./workdir/postman_collection.json
  sed -i 's/\\t//g' ./workdir/postman_collection.json

  # Replace javascript snippets with groovy
  sed -i '/jmeter_keep/ s/JSON.parse( *responseBody *)/jsonSlurper.parseText(prev.getResponseDataAsString())/g' ./workdir/postman_collection.json
  sed -i '/jmeter_keep/ s/pm.response.json()/jsonSlurper.parseText(prev.getResponseDataAsString())/g' ./workdir/postman_collection.json

  sed -i '/jmeter_keep/ s/responseCode.code *===\? *\([0-9]\+\)/prev.getResponseCode() == \\\"\1\\\"/g' ./workdir/postman_collection.json
  sed -i '/jmeter_keep/ s/pm.response.status *===\? *\([0-9]\+\)/prev.getResponseCode() == \\\"\1\\\"/g' ./workdir/postman_collection.json

  sed -i '/jmeter_keep/ s/pm.environment.set(\([^,]\+\)/vars.put(\1/g' ./workdir/postman_collection.json
  sed -i '/jmeter_keep/ s/pm.collectionVariables.set(\([^,]\+\)/vars.put(\1/g' ./workdir/postman_collection.json
  sed -i '/jmeter_keep/ s/pm.globals.set(\([^,]\+\)/vars.put(\1/g' ./workdir/postman_collection.json
  sed -i '/jmeter_keep/ s/postman.setEnvironmentVariable(\([^,]\+\)/vars.put(\1/g' ./workdir/postman_collection.json
  sed -i '/jmeter_keep/ s/postman.setCollectionVariable(\([^,]\+\)/vars.put(\1/g' ./workdir/postman_collection.json
  sed -i '/jmeter_keep/ s/postman.setGlobalVariable(\([^,]\+\)/vars.put(\1/g' ./workdir/postman_collection.json

  sed -i '/jmeter_keep/ s/pm.response.headers.get(\([^)]\+\))/headers\[\1\]/g' ./workdir/postman_collection.json
  sed -i '/jmeter_keep/ s/postman.getResponseHeader(\([^)]\+\))/headers\[\1\]/g' ./workdir/postman_collection.json

  sed -i '/jmeter_keep/ s/\([" ]\)var /\1def /g' ./workdir/postman_collection.json
  sed -i '/jmeter_keep/ s/\([" ]\)const /\1def /g' ./workdir/postman_collection.json
}

post_processing() {
  printf '%b\n' "$string_result" > workdir/tmp_result.jmx

  sed -i 's/^"//' workdir/tmp_result.jmx
  sed -i 's/"$//' workdir/tmp_result.jmx
  sed -i 's/\\"/"/g' workdir/tmp_result.jmx
  sed -i '1 i\<?xml version="1.0" encoding="UTF-8"?>' workdir/tmp_result.jmx

  xmllint --format workdir/tmp_result.jmx > workdir/result.jmx

  cp workdir/result.jmx ${TARGET}
}

main() {

  args "$@"

  copy_files

  prefix_vars

  suffix_vars

  pre_processing

  string_result=$(jsonnet create_jmx.jsonnet)

  post_processing
}

main "$@"

