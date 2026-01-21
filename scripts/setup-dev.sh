#!/bin/bash

# Melody Auth - Development Environment Setup Script
# This script automates the initial setup of the Melody Auth development environment

set -e  # Exit on error

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}╔══════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║  Melody Auth - Development Setup            ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════╝${NC}"
echo ""

# Check Node.js version
echo -e "${YELLOW}[1/8] Checking Node.js version...${NC}"
NODE_VERSION=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
if [ "$NODE_VERSION" -lt 20 ]; then
    echo -e "${RED}Error: Node.js 20.x or higher required. Current: $(node -v)${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Node.js $(node -v) detected${NC}"
echo ""

# Install root dependencies
echo -e "${YELLOW}[2/8] Installing root dependencies...${NC}"
npm install
echo -e "${GREEN}✓ Root dependencies installed${NC}"
echo ""

# Install server dependencies
echo -e "${YELLOW}[3/8] Installing server dependencies...${NC}"
cd server
npm install
echo -e "${GREEN}✓ Server dependencies installed${NC}"
echo ""

# Install admin panel dependencies
echo -e "${YELLOW}[4/8] Installing admin panel dependencies...${NC}"
cd ../admin-panel
npm install
echo -e "${GREEN}✓ Admin panel dependencies installed${NC}"
cd ..
echo ""

# Setup server environment
echo -e "${YELLOW}[5/8] Setting up server environment...${NC}"
if [ ! -f "server/.dev.vars" ]; then
    cp server/.dev.vars.example server/.dev.vars
    echo -e "${GREEN}✓ Created server/.dev.vars from example${NC}"
    echo -e "${YELLOW}  → Please edit server/.dev.vars with your configuration${NC}"
else
    echo -e "${YELLOW}⚠ server/.dev.vars already exists, skipping${NC}"
fi
echo ""

# Generate secrets
echo -e "${YELLOW}[6/8] Generating authentication secrets...${NC}"
cd server
npm run dev:secret:generate
echo -e "${GREEN}✓ Secrets generated${NC}"
cd ..
echo ""

# Apply database migrations
echo -e "${YELLOW}[7/8] Applying database migrations...${NC}"
cd server
echo -e "${YELLOW}This will create all database tables...${NC}"
npm run dev:migration:apply <<EOF
Y
EOF
echo -e "${GREEN}✓ Database migrations applied${NC}"
cd ..
echo ""

# Retrieve app credentials and setup admin panel environment
echo -e "${YELLOW}[8/8] Configuring admin panel environment...${NC}"
cd server

# Get app credentials from database
APP_DATA=$(npx wrangler d1 execute melody-auth --command="select clientId, secret, type from app order by id" --local 2>/dev/null || echo "")

if [ -z "$APP_DATA" ]; then
    echo -e "${RED}Error: Could not retrieve app credentials from database${NC}"
    echo -e "${YELLOW}Please run manually: npx wrangler d1 execute melody-auth --command=\"select * from app\" --local${NC}"
    exit 1
fi

# Parse the output to get SPA and S2S credentials
SPA_CLIENT_ID=$(echo "$APP_DATA" | grep "│ spa" | awk '{print $2}')
S2S_CLIENT_ID=$(echo "$APP_DATA" | grep "│ s2s" | awk '{print $2}')
S2S_CLIENT_SECRET=$(echo "$APP_DATA" | grep "│ s2s" | awk '{print $4}')

if [ -z "$SPA_CLIENT_ID" ] || [ -z "$S2S_CLIENT_ID" ] || [ -z "$S2S_CLIENT_SECRET" ]; then
    echo -e "${YELLOW}⚠ Could not auto-parse credentials. Checking if .env.local exists...${NC}"
    
    if [ ! -f "../admin-panel/.env.local" ]; then
        echo -e "${YELLOW}Creating admin-panel/.env.local template...${NC}"
        cp ../admin-panel/.env.example ../admin-panel/.env.local
        echo -e "${YELLOW}→ Please manually configure admin-panel/.env.local with app credentials${NC}"
        echo -e "${YELLOW}→ Run: npx wrangler d1 execute melody-auth --command=\"select * from app\" --local${NC}"
    else
        echo -e "${YELLOW}⚠ admin-panel/.env.local already exists${NC}"
    fi
else
    # Create admin panel .env.local file
    cat > ../admin-panel/.env.local <<EOF
NEXT_PUBLIC_CLIENT_URI=http://localhost:3000
NEXT_PUBLIC_SERVER_URI=http://localhost:8787
NEXT_PUBLIC_CLIENT_ID=${SPA_CLIENT_ID}
NEXT_PUBLIC_SUPPORTED_LOCALES=en,fr
SERVER_CLIENT_ID=${S2S_CLIENT_ID}
SERVER_CLIENT_SECRET=${S2S_CLIENT_SECRET}
EOF
    echo -e "${GREEN}✓ Admin panel environment configured${NC}"
fi

cd ..
echo ""

# Final message
echo -e "${GREEN}╔══════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║  Setup Complete! 🎉                          ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo ""
echo -e "1. Start the auth server:"
echo -e "   ${GREEN}cd server && npm run dev:start${NC}"
echo ""
echo -e "2. In a new terminal, start the admin panel:"
echo -e "   ${GREEN}cd admin-panel && npm run dev${NC}"
echo ""
echo -e "3. Access the application:"
echo -e "   • Admin Panel: ${GREEN}http://localhost:3000${NC}"
echo -e "   • Auth Server: ${GREEN}http://localhost:8787${NC}"
echo ""
echo -e "4. Create your first admin user:"
echo -e "   • Sign up at http://localhost:3000"
echo -e "   • Grant super_admin role:"
echo -e "     ${GREEN}cd server${NC}"
echo -e "     ${GREEN}npx wrangler d1 execute melody-auth --command=\"insert into user_role (userId, roleId) values (1, 1)\" --local${NC}"
echo -e "   • Logout and login again"
echo ""
echo -e "${YELLOW}For detailed documentation, see:${NC}"
echo -e "  • ${GREEN}DEVELOPMENT.md${NC} - Development workflow and debugging"
echo -e "  • ${GREEN}DEPLOYMENT.md${NC} - Production deployment guide"
echo ""
