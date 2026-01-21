#!/bin/bash

# Melody Auth - Start Development Servers
# This script starts both the auth server and admin panel in the background

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}Starting Melody Auth development environment...${NC}"
echo ""

# Check if servers are already running
if lsof -ti:8787 > /dev/null 2>&1; then
    echo -e "${YELLOW}⚠ Port 8787 is already in use${NC}"
    echo -e "  Auth server may already be running"
fi

if lsof -ti:3000 > /dev/null 2>&1; then
    echo -e "${YELLOW}⚠ Port 3000 is already in use${NC}"
    echo -e "  Admin panel may already be running"
fi

echo -e "${YELLOW}Starting auth server on port 8787...${NC}"
cd server
npm run dev:start > ../logs/server.log 2>&1 &
SERVER_PID=$!
cd ..

sleep 3

echo -e "${YELLOW}Starting admin panel on port 3000...${NC}"
cd admin-panel
npm run dev > ../logs/admin.log 2>&1 &
ADMIN_PID=$!
cd ..

sleep 5

echo ""
echo -e "${GREEN}✓ Servers started!${NC}"
echo ""
echo -e "Auth Server PID: ${SERVER_PID}"
echo -e "Admin Panel PID: ${ADMIN_PID}"
echo ""
echo -e "Access points:"
echo -e "  • Admin Panel: ${GREEN}http://localhost:3000${NC}"
echo -e "  • Auth Server: ${GREEN}http://localhost:8787${NC}"
echo ""
echo -e "View logs:"
echo -e "  • Server: ${GREEN}tail -f logs/server.log${NC}"
echo -e "  • Admin: ${GREEN}tail -f logs/admin.log${NC}"
echo ""
echo -e "Stop servers:"
echo -e "  ${GREEN}npm run stop${NC}"
echo ""
