#!/bin/bash

set -e

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

WORKFLOW_FILE=".github/workflows/local-check.yml"

echo "${YELLOW}========================================${NC}"
echo "${YELLOW}Running Local Tests for GitHub Action${NC}"
echo "${YELLOW}========================================${NC}"
echo ""

# Clean up previous test artifacts
echo "${YELLOW}Cleaning up previous test artifacts...${NC}"
rm -rf test/fixtures/generated test/output
echo "${GREEN}✓ Cleanup complete${NC}"
echo ""

# Run act to test the action locally
echo "${YELLOW}Running act to test the action...${NC}"
echo ""

if act -l -W $WORKFLOW_FILE; then
    echo "${GREEN}✓ Workflow file is valid${NC}"
else
    echo "${RED}✗ Workflow file has errors${NC}"
    exit 1
fi

echo ""
echo "${YELLOW}Executing workflow with act...${NC}"
echo "${YELLOW}(This may take a few minutes on first run to pull Docker images)${NC}"
echo ""

# Run act with the local workflow
# --artifact-server-path: where to store artifacts
# -v: verbose output
if act workflow_dispatch \
    -W $WORKFLOW_FILE \
    --artifact-server-path /tmp/artifacts \
    2>&1 | tee /tmp/act-test-output.log; then

    echo ""
    echo "${GREEN}✓ Act execution completed${NC}"
else
    echo ""
    echo "${RED}✗ Act execution failed${NC}"
    echo "${YELLOW}Check /tmp/act-test-output.log for details${NC}"
    exit 1
fi

echo ""
echo "${YELLOW}========================================${NC}"
echo "${GREEN}All tests passed! 🎉${NC}"
echo "${YELLOW}========================================${NC}"
