#!/bin/bash

# Melody Auth - Health Check Script
# Verifies that the development environment is properly configured

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

ISSUES=0

echo -e "${GREEN}╔══════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║  Melody Auth - Health Check                 ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════╝${NC}"
echo ""

# Check Node.js
echo -e "${YELLOW}Checking Node.js...${NC}"
if command -v node &> /dev/null; then
    NODE_VERSION=$(node -v)
    echo -e "${GREEN}✓ Node.js ${NODE_VERSION}${NC}"
else
    echo -e "${RED}✗ Node.js not found${NC}"
    ISSUES=$((ISSUES+1))
fi

# Check npm
echo -e "${YELLOW}Checking npm...${NC}"
if command -v npm &> /dev/null; then
    NPM_VERSION=$(npm -v)
    echo -e "${GREEN}✓ npm ${NPM_VERSION}${NC}"
else
    echo -e "${RED}✗ npm not found${NC}"
    ISSUES=$((ISSUES+1))
fi

# Check root dependencies
echo -e "${YELLOW}Checking root dependencies...${NC}"
if [ -d "node_modules" ]; then
    echo -e "${GREEN}✓ Root node_modules exists${NC}"
else
    echo -e "${RED}✗ Root dependencies not installed${NC}"
    echo -e "  Run: npm install"
    ISSUES=$((ISSUES+1))
fi

# Check server dependencies
echo -e  "${YELLOW}Checking server dependencies...${NC}"
if [ -d "server/node_modules" ]; then
    echo -e "${GREEN}✓ Server node_modules exists${NC}"
else
    echo -e "${RED}✗ Server dependencies not installed${NC}"
    echo -e "  Run: cd server && npm install"
    ISSUES=$((ISSUES+1))
fi

# Check admin panel dependencies  
echo -e "${YELLOW}Checking admin panel dependencies...${NC}"
if [ -d "admin-panel/node_modules" ]; then
    echo -e "${GREEN}✓ Admin panel node_modules exists${NC}"
else
    echo -e "${RED}✗ Admin panel dependencies not installed${NC}"
    echo -e "  Run: cd admin-panel && npm install"
    ISSUES=$((ISSUES+1))
fi

# Check server environment file
echo -e "${YELLOW}Checking server environment...${NC}"
if [ -f "server/.dev.vars" ]; then
    echo -e "${GREEN}✓ server/.dev.vars exists${NC}"
    
    # Check for required variables
    if grep -q "ENVIRONMENT=dev" server/.dev.vars; then
        echo -e "${GREEN}  ✓ ENVIRONMENT is set${NC}"
    else
        echo -e "${YELLOW}  ⚠ ENVIRONMENT not set to 'dev'${NC}"
    fi
else
    echo -e "${RED}✗ server/.dev.vars not found${NC}"
    echo -e "  Run: cp server/.dev.vars.example server/.dev.vars"
    ISSUES=$((ISSUES+1))
fi

# Check admin panel environment file
echo -e "${YELLOW}Checking admin panel environment...${NC}"
if [ -f "admin-panel/.env.local" ]; then
    echo -e "${GREEN}✓ admin-panel/.env.local exists${NC}"
    
    # Check for required variables
    if grep -q "NEXT_PUBLIC_CLIENT_ID" admin-panel/.env.local; then
        echo -e "${GREEN}  ✓ NEXT_PUBLIC_CLIENT_ID is set${NC}"
    else
        echo -e "${YELLOW}  ⚠ NEXT_PUBLIC_CLIENT_ID not configured${NC}"
    fi
else
    echo -e "${RED}✗ admin-panel/.env.local not found${NC}"
    echo -e "  Run: cp admin-panel/.env.example admin-panel/.env.local"
    ISSUES=$((ISSUES+1))
fi

# Check database
echo -e "${YELLOW}Checking database...${NC}"
if [ -d "server/.wrangler/state/v3/d1" ]; then
    echo -e "${GREEN}✓ Local D1 database exists${NC}"
else
    echo -e "${YELLOW}⚠ Local D1 database not found${NC}"
    echo -e "  Run: cd server && npm run dev:migration:apply"
fi

# Check if servers are running
echo -e "${YELLOW}Checking running servers...${NC}"

if lsof -ti:8787 > /dev/null 2>&1; then
    echo -e "${GREEN}✓ Auth server is running on port 8787${NC}"
else
    echo -e "${YELLOW}⚠ Auth server is not running${NC}"
    echo -e "  To start: cd server && npm run dev:start"
fi

if lsof -ti:3000 > /dev/null 2>&1; then
    echo -e "${GREEN}✓ Admin panel is running on port 3000${NC}"
else
    echo -e "${YELLOW}⚠ Admin panel is not running${NC}"
    echo -e "  To start: cd admin-panel && npm run dev"
fi

# Test server endpoint if running
if lsof -ti:8787 > /dev/null 2>&1; then
    echo -e "${YELLOW}Testing auth server endpoint...${NC}"
    if curl -s -f http://localhost:8787/.well-known/openid-configuration > /dev/null; then
        echo -e "${GREEN}✓ Auth server is responding${NC}"
    else
        echo -e "${RED}✗ Auth server is not responding properly${NC}"
        ISSUES=$((ISSUES+1))
    fi
fi

echo ""
echo -e "${GREEN}╔══════════════════════════════════════════════╗${NC}"
if [ $ISSUES -eq 0 ]; then
    echo -e "${GREEN}║  Health Check Passed! ✓                      ║${NC}"
else
    echo -e "${YELLOW}║  Health Check: ${ISSUES} issue(s) found        ║${NC}"
fi
echo -e "${GREEN}╚══════════════════════════════════════════════╝${NC}"
echo ""

exit $ISSUES
