# Mermaid to SVG Action

This GitHub Action uses the Mermaid CLI to convert Mermaid diagrams from changed `.mmd` or `.md` files into SVG images.

## Usage

You can use this action in your workflow by referencing it with `@v1` (once a version 1 is released).

### Example Workflow

```yaml
name: 'Generate Mermaid Diagrams'

on:
  push:
    paths:
      - '**.mmd'
      - '**.md'

jobs:
  generate-diagrams:
    runs-on: ubuntu-latest
    steps:
      - name: 'Checkout code'
        uses: actions/checkout@v3

      - name: 'Get changed files'
        id: changed-files
        uses: tj-actions/changed-files@v35
        with:
          files: |
            **.mmd
            **.md

      - name: 'Generate Mermaid diagrams'
        if: steps.changed-files.outputs.any_changed == 'true'
        uses: ./ # Uses an action in the same repository
        with:
          changed-files: ${{ steps.changed-files.outputs.all_changed_files }}
          output-dir: 'generated-diagrams'
```

This workflow will:
1.  Run on every push that includes changes to `.mmd` or `.md` files.
2.  Check out the repository's code.
3.  Use the `tj-actions/changed-files` action to get a list of modified files.
4.  If any relevant files have changed, it will run our Mermaid to SVG action.
5.  The generated SVG files will be placed in the `generated-diagrams` directory.

## Inputs

| Name               | Description                                                                                                                              | Required | Default                        |
| ------------------ | ---------------------------------------------------------------------------------------------------------------------------------------- | -------- | ------------------------------ |
| `changed-files`    | A space-separated string of changed `.mmd` or `.md` files.                                                                               | **Yes**  | N/A                            |
| `output-dir`       | Optional. The directory to place generated files. If not set, it creates an `auto_generated` folder in each source file's directory.        | No       | `''`                           |
| `version`          | The `minlag/mermaid-cli` docker image version (tag).                                                                                     | No       | `latest`                       |
| `icon-packages`    | Icon packages to pass to the `mmdc --iconPacks` flag.                                                                                    | No       | `@fortawesome/fontawesome-free` |
| `puppeteer-config` | Path to the puppeteer config file.                                                                                                       | No       | `puppeteer-config.json`        |
