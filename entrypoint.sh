#!/bin/sh -l

INPUT_FILES=$1
OUTPUT_DIR=$2
VERSION=$3
ICON_PACKAGES=$4

MMDC_PATH="/home/mermaidcli/node_modules/.bin/mmdc"

echo "Generating diagrams with minlag/mermaid-cli:${VERSION}"
echo "Input files: ${INPUT_FILES}"

for file in ${INPUT_FILES}; do
  output_filename=$(basename "$file" | sed 's/\.\(mmd\|md\)$/.svg/')

  if [ -n "${OUTPUT_DIR}" ]; then
    final_output_dir="${OUTPUT_DIR}"
  else
    input_dir=$(dirname "$file")
    final_output_dir="$input_dir/generated"
  fi

  output_file="$final_output_dir/$output_filename"

  mkdir -p "$final_output_dir"

  echo "Processing '$file' -> '$output_file'"

  CMD="${MMDC_PATH} -p /puppeteer-config.json -i \"$file\" -o \"$output_file\" --iconPacks ${ICON_PACKAGES}"
  eval ${CMD}
done
