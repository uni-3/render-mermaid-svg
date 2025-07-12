#!/bin/sh -l

echo "Generating diagrams with minlag/mermaid-cli:${INPUT_VERSION}"
for file in ${INPUT_CHANGED_FILES}; do
  output_filename=$(basename "$file" | sed 's/\.\(mmd\|md\)$/.svg/')

  if [ -n "${INPUT_OUTPUT_DIR}" ]; then
    final_output_dir="${INPUT_OUTPUT_DIR}"
  else
    input_dir=$(dirname "$file")
    final_output_dir="$input_dir/auto_generated"
  fi

  output_file="$final_output_dir/$output_filename"

  mkdir -p "$final_output_dir"

  echo "Processing '$file' -> '$output_file'"

  mmdc -i "$file" -o "$output_file" --puppeteerConfigFile "${INPUT_PUPPETEER_CONFIG}" --iconPacks "${INPUT_ICON_PACKAGES}"
done
