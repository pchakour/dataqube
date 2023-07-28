#!/usr/bin/env bash

### TODO
# - merge function print_param and print_subparam

DIRNAME=$(dirname $0)
PARSER_PATH="${DIRNAME}/../../parser.sh"
TMP_JSON_DOC="${DIRNAME}/.doc.json"

OUTPUT_DIR="${DIRNAME}/../documentation/parsing_tool/plugins"
INPUTS_DOC="${OUTPUT_DIR}/inputs"
OUTPUTS_DOC="${OUTPUT_DIR}/outputs"
EXTRACTORS_DOC="${OUTPUT_DIR}/extractors"
TRANSFORMERS_DOC="${OUTPUT_DIR}/transformers"
ASSERTIONS_DOC="${OUTPUT_DIR}/assertions"

echo $PARSER_PATH
$PARSER_PATH --build-json-doc > $TMP_JSON_DOC

rm -rf $OUTPUT_DIR

mkdir -p $INPUTS_DOC
mkdir -p $OUTPUTS_DOC
mkdir -p $EXTRACTORS_DOC
mkdir -p $TRANSFORMERS_DOC
mkdir -p $ASSERTIONS_DOC


function _jq() {
  echo $1 | base64 --decode | jq -r "$2"
}

function print_subparam {
  subparams=$1
  output=$2
  title_mark=$3
  indent=$4

  for subparam_name in $(_jq $subparams "keys[]")
  do
    echo "$title_mark $subparam_name" >> $output
    echo "" >> $output
    echo "<br/>" >> $output
    if [ "$(_jq $subparams '.options')" == "null" ] || [ "$(_jq $subparams '.options | has("default")')" == "false" ]
    then
      echo "<Badge type="tip" text="required" vertical="bottom" />" >> $output
    else
      echo "<Badge type="warning" text="optional" vertical="bottom" />" >> $output
    fi
    echo "" >> $output
    if [ "$(_jq $subparams .$subparam_name' | has("config_param")')" == "true" ]
    then
      echo "" >> $output
      echo "Value type is an object composed by the following properties: " >> $output
      print_subparam $(_jq $subparams .$subparam_name'.config_param | @base64') $output "$title_mark#" "$indent$indent"
    else 
      description=$(_jq $subparams .$subparam_name.desc)
      echo "$indent$description" >> $output
      echo "" >> $output
      echo "$indent- Value type is \`$(_jq $subparams .type)\`" >> $output

      if [ "$(_jq $subparams '.options.multi')" == "true" ]
      then
        echo "- [Multi mode](#) is supported by this parameter" >> $output
      fi

      if [ "$(_jq $subparams '.options.field_interpretation')" == "true" ]
      then
        echo "- [Field interpretation](#) is supported by this parameter" >> $output
      fi
    fi
  done
}

function print_param {
  params=$1
  output=$2

  echo "### $(_jq $params .name)" >> $output
  echo "<br/>" >> $output
  if [ "$(_jq $params '.options')" == "null" ] || [ "$(_jq $params '.options | has("default")')" == "false" ]
  then
    echo "<Badge type="tip" text="required" vertical="bottom" />" >> $output
  else
    echo "<Badge type="warning" text="optional" vertical="bottom" />" >> $output
  fi
  echo "" >> $output
  description=$(_jq $params .description)
  if [ "$description" != "null" ]
  then
    echo "$description" >> $output
  fi

  if [ "$(_jq $params '.type | type')" == "object" ]
  then
    echo "" >> $output
    echo "Value type is an object composed by the following properties: " >> $output
    print_subparam $(_jq $params '.type | @base64') $output "####" "  "
  else
    echo "- Value type is \`$(_jq $params .type)\`" >> $output
  fi

  if [ "$(_jq $params '.options | has("default")')" == "true" ]
  then
    default=$(_jq $params '.options.default')
    echo "- The default is \`$default\`" >> $output
  fi

  if [ "$(_jq $params '.options.multi')" == "true" ]
  then
    echo "- [Multi mode](#) is supported by this parameter" >> $output
  fi

  if [ "$(_jq $params '.options.field_interpretation')" == "true" ]
  then
    echo "- [Field interpretation](#) is supported for this parameter" >> $output
  fi

  echo "" >> $output
}

function write_data {
  type=$1
  title=$2
  output_dir=$3

  index_output="$output_dir/index.md"
  echo "# $title" > $index_output
  echo "" >> $index_output

  plugin_type_description=$(jq -r ".common.$type.description" $TMP_JSON_DOC)
  echo "$plugin_type_description" >> $index_output

  echo "" >> $index_output
  echo "| Plugin | Description |" >> $index_output
  echo "|---|---|" >> $index_output

  for plugin in $(jq -r ".$type | keys[]" $TMP_JSON_DOC)
  do
    plugin_output="$output_dir/$plugin.md"
    plugin_license=$(jq -r ".$type.$plugin.license" $TMP_JSON_DOC)
    echo "# $plugin <Badge type='tip' text='$plugin_license' vertical='top' />" >> $plugin_output
    echo "" >> $plugin_output
    echo "## Description" >> $plugin_output
    plugin_description=$(echo -n "$(jq -r ".$type.$plugin.description" $TMP_JSON_DOC)" | sed -z "s/\n/<br\/>/g")
    plugin_details=$(jq -r ".$type.$plugin.details" $TMP_JSON_DOC)
    if [ "$plugin_description" != "null" ]
    then
      echo "$plugin_description" >> $plugin_output
    fi

    if [ "$plugin_details" != "null" ]
    then
      echo "$plugin_details" >> $plugin_output
    fi

    echo "| [$plugin](./$plugin.md) | $plugin_description |" >> $index_output

    echo "" >> $plugin_output
    echo "## List of parameters" >> $plugin_output
    echo "| Parameter | Description | Required | Default |" >> $plugin_output
    echo "|---|---|---|---|" >> $plugin_output

    global_common_parameters=$(jq -r ".common.plugin.params[] | @base64" $TMP_JSON_DOC)
    plugin_parameters=$(jq -r ".$type.$plugin.params[] | @base64" $TMP_JSON_DOC)
    type_common_parameters=""

    if [ "$(jq -c '.common.'$type $TMP_JSON_DOC)" == "null" ]
    then
      parameters=$(echo -n "$global_common_parameters $plugin_parameters")
    else
      type_common_parameters=$(jq -r ".common.$type.params[] | @base64" $TMP_JSON_DOC)
      parameters=$(echo -n "$global_common_parameters $type_common_parameters $plugin_parameters")
    fi

    for params in $parameters
    do
      required='No'
      default='null'
      if [ "$(_jq $params '.options')" == "null" ] || [ "$(_jq $params '.options | has("default")')" == "false" ]
      then
        required='Yes'
      fi

      if [ "$(_jq $params '.options')" != "null" ]
      then
        default="$(_jq $params '.options.default')"
      fi

      param_name="$(_jq $params '.name')"
      param_description="$(echo -n "$(_jq $params '.description')" | sed -z "s/\n/<br\/>/g")"

      echo "| [$param_name](#$param_name) | $param_description | $required | $default |" >> $plugin_output
    done
  
    echo "" >> $plugin_output

    echo "## Common parameters" >> $plugin_output
    for params in $global_common_parameters
    do
      print_param $params $plugin_output
    done

    for params in $type_common_parameters
    do
      print_param $params $plugin_output
    done

    echo "## Plugin parameters" >> $plugin_output
    for params in $plugin_parameters
    do
      print_param $params $plugin_output
    done
  done
}

write_data "input" "Inputs" $INPUTS_DOC
write_data "output" "Outputs" $OUTPUTS_DOC
write_data "extractor" "Extractors" $EXTRACTORS_DOC
write_data "transformer" "Transformers" $TRANSFORMERS_DOC
write_data "assertion" "Assertions" $ASSERTIONS_DOC

# rm $TMP_JSON_DOC
