# Mermaid to SVG Action

This GitHub Action uses the Mermaid CLI to convert Mermaid diagrams from changed `.mmd` or `.md` files into SVG images.
It can also render [Architecture Diagrams](https://mermaid.js.org/syntax/architecture.html) with specified icon packages.

## Usage


### Example Workflow

This workflow automatically finds changed Mermaid files, generates SVG diagrams, and commits them back to the repository.

```yaml
name: 'Generate Mermaid Diagrams'

on:
  pull_request:
    paths:
      - '**.md'
      - '**.mmd'

jobs:
  generate-diagrams:
    runs-on: ubuntu-latest
    permissions:
      contents: write
    steps:
      - name: 'Checkout code'
        uses: actions/checkout@v4

      - name: 'Get changed files'
        id: changed-files
        uses: tj-actions/changed-files@v46
        with:
          files: |
            **.md
            **.mmd

      - name: 'Generate Mermaid diagrams'
        if: steps.changed-files.outputs.any_changed == 'true'
        uses: uni-3/render-mermaid-svg@v1
        with:
          input-files: ${{ steps.changed-files.outputs.all_changed_files }}
          icon-packages: '@iconify-json/logos @iconify-json/mdi'

      - name: Commit rendered svg files
        if: steps.changed-files.outputs.any_changed == 'true'
        uses: stefanzweifel/git-auto-commit-action@v6
        with:
          file_pattern: "*.svg"
          commit_message: "docs: Generate Mermaid diagrams"
```

This workflow will:
1.  Run on every push that includes changes to `.mmd` or `.md` files.
2.  Check out the repository's code.
3.  Use the `tj-actions/changed-files` action to get a list of modified files.
4.  If any relevant files have changed, it will run our Mermaid to SVG action.
5.  The generated SVG files will be placed in a `generated` folder in each source file's directory (by default).
6.  The `stefanzweifel/git-auto-commit-action` will commit the generated SVG files back to the repository.

## Inputs

| Name            | Description                                                                                                                              | Required | Default                        |
| --------------- | ---------------------------------------------------------------------------------------------------------------------------------------- | -------- | ------------------------------ |
| `input-files`   | A space-separated string of changed `.mmd` or `.md` files.                                                                               | **Yes**  | N/A                            |
| `output-dir`    | Optional. The directory to place generated files. If not set, it creates a `generated` folder in each source file's directory.        | No       | `''`                           |
| `version`       | The `minlag/mermaid-cli` docker image version (tag).                                                                                     | No       | `latest`                       |
| `icon-packages` | Icon packages to pass to the `mmdc --iconPacks` flag. Each package should be quoted and space-separated. e.g. `'@iconify-json/logos' '@iconify-json/mdi'` | No       | `` `@fortawesome/fontawesome-free` `` |

## Testing

This action includes local testing capabilities to verify that inputs are correctly processed and outputs are generated as expected.

### Quick Test (Recommended)

Run a quick test using Docker directly:

```bash
./test-quick.sh
```

This script will:
- ✅ Build the Docker image
- ✅ Test basic rendering (default output directory)
- ✅ Test custom output directory
- ✅ Verify SVG file existence and validity

### Full Test with Act

For a more comprehensive test that simulates the GitHub Actions environment:

```bash
./test-local.sh
```

This requires [act](https://github.com/nektos/act) to be installed. The script will:
- ✅ Run the complete workflow locally
- ✅ Test multiple scenarios
- ✅ Verify all outputs

### Manual Testing

You can also manually test the action:

```bash
# Build the Docker image
docker build -t render-mermaid-svg-test .

# Run with test files
docker run --rm \
  -v "$PWD:/github/workspace" \
  -w /github/workspace \
  render-mermaid-svg-test \
  "test/fixtures/simple.mmd" \
  "" \
  "latest" \
  "@fortawesome/fontawesome-free"

# Check generated files
ls -la test/fixtures/generated/
```
