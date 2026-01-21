#!/bin/bash

# Melody Auth - Stop Development Servers
# This script stops the auth server and admin panel

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}Stopping Melody Auth development servers...${NC}"
echo ""

# Stop auth server (port 8787)
if lsof -ti:8787 > /dev/null 2>&1; then
    echo -e "Stopping auth server (port 8787)..."
    lsof -ti:8787 | xargs kill -9
    echo -e "${GREEN}✓ Auth server stopped${NC}"
else
    echo -e "${YELLOW}⚠ Auth server not running${NC}"
fi

# Stop admin panel (port 3000)
if lsof -ti:3000 > /dev/null 2>&1; then
    echo -e "Stopping admin panel (port 3000)..."
    lsof -ti:3000 | xargs kill -9
    echo -e "${GREEN}✓ Admin panel stopped${NC}"
else
    echo -e "${YELLOW}⚠ Admin panel not running${NC}"
fi

echo ""
echo -e "${GREEN}All servers stopped${NC}"
