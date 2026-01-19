#!/bin/bash
set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}Building and deploying garden to Cloudflare Pages...${NC}"

# Build
echo -e "${YELLOW}Building Quartz...${NC}"
bun run quartz build

# Deploy
echo -e "${YELLOW}Deploying to Cloudflare Pages...${NC}"
bunx wrangler pages deploy public --project-name=garden

echo -e "${GREEN}Done!${NC}"
