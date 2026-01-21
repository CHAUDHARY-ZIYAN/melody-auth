# Deployment Guide - Melody Auth

This guide covers deploying Melody Auth to production environments.

## Table of Contents
- [Cloudflare Production](#cloudflare-production)
- [Node.js Production](#nodejs-production)
- [Environment Variables Reference](#environment-variables-reference)
- [Security Checklist](#security-checklist)
- [Monitoring & Logging](#monitoring--logging)

## Cloudflare Production

### Prerequisites
- Cloudflare account
- Domain (optional, recommended for production)
- Wrangler CLI configured (`npx wrangler login`)

### 1. Create Cloudflare Resources

**Create Worker:**
1. Go to Cloudflare Dashboard → Workers & Pages
2. Click "Create Worker"
3. Name it "melody-auth"
4. Go to Settings → Variables and Secrets
5. Add variable: `AUTH_SERVER_URL` = your worker URL

**Create D1 Database:**
1. Go to Storage & Databases → D1 SQL Database
2. Click "Create" and name it "melody-auth"
3. Note the database ID

**Create KV Namespace:**
1. Go to Storage & Databases → KV
2. Click "Create" and name it "melody-auth-kv"
3. Note the namespace ID

### 2. Configure Wrangler

Update `server/wrangler.toml` with your resource IDs:

```toml
name = "melody-auth"
main = "src/index.tsx"
compatibility_date = "2024-01-01"

[vars]
AUTH_SERVER_URL = "https://melody-auth.khanziyan2019.workers.dev"
EMAIL_PROVIDER_NAME = "resend"
RESEND_SENDER_ADDRESS = "khanziyan2019@gmail.com"
EMAIL_MFA_IS_REQUIRED = true

[[kv_namespaces]]
binding = "KV"
id = "1a96f348f3dc4a29afc21ef2b29ca18a"

[[d1_databases]]
binding = "DB"
database_name = "melody-auth"
database_id = "86a6f9ed-7a93-45d5-adc8-005c4af2d862"
```

### 3. Set Environment Variables

In Cloudflare Dashboard → Worker Settings → Variables and Secrets, add:

**Required:**
- `SESSION_SECRET` - Generate with `npm run prod:secret:generate`
- `ENVIRONMENT` - Set to any value except "dev"

**Optional (based on your needs):**
- Email provider credentials
- SMS provider credentials  
- Social login credentials

See [Environment Variables Reference](#environment-variables-reference) for complete list.

### 4. Deploy

```bash
cd server

# Generate production secrets
npm run prod:secret:generate

# Apply migrations to production database
npm run prod:migration:apply

# Build and deploy
npm run prod:deploy
```

### 5. Verify Deployment

Test your deployment:
```bash
curl https://melody-auth.[your-account].workers.dev/.well-known/openid-configuration
```

You should see the OpenID configuration JSON.

### 6. Deploy Admin Panel

**Option A: Deploy to Cloudflare Workers**

```bash
cd admin-panel

# Create .env file with production values
cat > .env << EOF
NEXT_PUBLIC_CLIENT_URI=https://admin.yourdomain.com
NEXT_PUBLIC_SERVER_URI=https://auth.yourdomain.com
NEXT_PUBLIC_CLIENT_ID=[SPA Client ID from production DB]
EOF

# Build and deploy
npm run cf:build
npm run cf:deploy
```

**Note:** If deploying both auth server and admin panel to Cloudflare, they must:
- Have custom domains (e.g., auth.example.com and admin.example.com), OR
- Be in separate Cloudflare accounts

**Option B: Deploy to Node.js/Vercel/Netlify**

Standard Next.js deployment:
```bash
cd admin-panel
npm run build
npm run start  # or deploy to your platform
```

## Node.js Production

### Prerequisites
- Node.js v20.19.0 or higher
- PostgreSQL database
- Redis instance
- Process manager (PM2 recommended)

### 1. Database Setup

**PostgreSQL:**
```bash
# Create database
createdb melody-auth

# Apply migrations
cd server
npm run node:migration:apply
```

**Redis:**
Ensure Redis is running and accessible.

### 2. Environment Configuration

Create `server/.env` for production:

```env
# Environment
ENVIRONMENT=production

# Server URL
AUTH_SERVER_URL=https://auth.yourdomain.com

# Database
PG_CONNECTION_STRING=postgresql://user:password@localhost:5432/melody-auth
REDIS_CONNECTION_STRING=redis://localhost:6379

# Secrets (generate with npm run node:secret:generate)
SESSION_SECRET=your_generated_secret
JWT_SECRET_KEY=your_generated_jwt_secret

# Email Provider (example: SendGrid)
SENDGRID_API_KEY=your_api_key
SENDGRID_SENDER_EMAIL=noreply@yourdomain.com

# Add other providers as needed
```

### 3. Build and Deploy

```bash
cd server

# Generate production secrets
npm run node:secret:generate
npm run node:saml:secret:generate

# Build
npm run node:build

# Start with PM2
pm2 start dist/node.js --name melody-auth-server

# Or run directly
npm run node:start
```

### 4. Process Management with PM2

Create `ecosystem.config.js`:

```javascript
module.exports = {
  apps: [{
    name: 'melody-auth-server',
    script: './dist/node.js',
    instances: 2,
    exec_mode: 'cluster',
    env: {
      NODE_ENV: 'production',
    },
    error_file: './logs/err.log',
    out_file: './logs/out.log',
    log_date_format: 'YYYY-MM-DD HH:mm:ss Z',
  }]
}
```

Start:
```bash
pm2 start ecosystem.config.js
pm2 save
pm2 startup  # Configure to start on reboot
```

## Environment Variables Reference

### Auth Server

| Variable | Required | Description | Example |
|----------|----------|-------------|---------|
| `ENVIRONMENT` | Yes | Environment mode | `production` / `dev` |
| `AUTH_SERVER_URL` | Yes | Base URL of auth server | `https://auth.example.com` |
| `SESSION_SECRET` | Yes | Session encryption secret | Generate with script |
| `JWT_SECRET_KEY` | Yes | JWT signing key | Generate with script |
| `PG_CONNECTION_STRING` | Node.js only | PostgreSQL connection | `postgresql://user:pass@host:5432/db` |
| `REDIS_CONNECTION_STRING` | Node.js only | Redis connection | `redis://localhost:6379` |

**Email Providers (choose one):**
- SendGrid: `SENDGRID_API_KEY`, `SENDGRID_SENDER_EMAIL`
- Mailgun: `MAILGUN_API_KEY`, `MAILGUN_DOMAIN`, `MAILGUN_SENDER_EMAIL`
- Brevo: `BREVO_API_KEY`, `BREVO_SENDER_EMAIL`
- Resend: `RESEND_API_KEY`, `RESEND_SENDER_EMAIL`
- Postmark: `POSTMARK_API_KEY`, `POSTMARK_SENDER_EMAIL`
- SMTP (Node.js): `SMTP_HOST`, `SMTP_PORT`, `SMTP_USERNAME`, `SMTP_PASSWORD`, `SMTP_SENDER_EMAIL`

**SMS Providers:**
- Twilio: `TWILIO_ACCOUNT_SID`, `TWILIO_AUTH_TOKEN`, `TWILIO_PHONE_NUMBER`

**Social Login:**
- Google: `GOOGLE_CLIENT_ID`, `GOOGLE_CLIENT_SECRET`
- Facebook: `FACEBOOK_CLIENT_ID`, `FACEBOOK_CLIENT_SECRET`
- GitHub: `GITHUB_CLIENT_ID`, `GITHUB_CLIENT_SECRET`
- Discord: `DISCORD_CLIENT_ID`, `DISCORD_CLIENT_SECRET`
- Apple: `APPLE_CLIENT_ID`, `APPLE_TEAM_ID`, `APPLE_KEY_ID`

### Admin Panel

| Variable | Required | Description |
|----------|----------|-------------|
| `NEXT_PUBLIC_CLIENT_URI` | Yes | Admin panel URL |
| `NEXT_PUBLIC_SERVER_URI` | Yes | Auth server URL |
| `NEXT_PUBLIC_CLIENT_ID` | Yes | SPA client ID from database |
| `SERVER_CLIENT_ID` | Yes | S2S client ID from database |
| `SERVER_CLIENT_SECRET` | Yes | S2S client secret from database |
| `NEXT_PUBLIC_SUPPORTED_LOCALES` | No | Supported languages (default: en,fr) |

## Security Checklist

### Before Going Live

- [ ] Change all default secrets and passwords
- [ ] Use HTTPS/SSL for all endpoints
- [ ] Set `ENVIRONMENT` to non-dev value
- [ ] Enable rate limiting (configured in database)
- [ ] Review CORS settings
- [ ] Enable WAF/DDoS protection
- [ ] Set up monitoring and alerting
- [ ] Configure backup strategy
- [ ] Review and update security policies
- [ ] Test OAuth flows thoroughly
- [ ] Verify email/SMS providers work
- [ ] Set up log aggregation
- [ ] Document incident response procedures

### Ongoing Security

- [ ] Rotate secrets regularly (use JWT rotation feature)
- [ ] Monitor for suspicious activity
- [ ] Keep dependencies updated
- [ ] Review access logs regularly
- [ ] Perform security audits
- [ ] Test backup restoration
- [ ] Review user permissions

## Monitoring & Logging

### Cloudflare

**Built-in Monitoring:**
- Workers Dashboard → Analytics
- Real User Monitoring (RUM)
- Worker logs via `wrangler tail`

**Tailing Logs:**
```bash
npx wrangler tail melody-auth
```

**Third-party Integration:**
- Sentry for error tracking
- Datadog for APM
- LogDNA for log aggregation

### Node.js

**PM2 Monitoring:**
```bash
pm2 monit              # Real-time monitoring
pm2 logs melody-auth  # View logs
pm2 status            # Process status
```

**Log Files:**
Configure in PM2 ecosystem file or use logging libraries:
- Winston
- Pino
- Morgan (HTTP logging)

**APM Tools:**
- New Relic
- Datadog
- AppSignal

### Key Metrics to Monitor

1. **Performance:**
   - Response times
   - Token generation time
   - Database query performance

2. **Usage:**
   - Sign-in/sign-up rates
   - Active users
   - API call volume

3. **Errors:**
   - Failed login attempts
   - Server errors (5xx)
   - Rate limit violations

4. **Security:**
   - Brute force attempts
   - Invalid token usage
   - Unusual access patterns

## Updating Production

### Cloudflare

```bash
git pull origin main
cd server

# Apply new migrations if any
npm run prod:migration:apply

# Deploy
npm run prod:deploy
```

### Node.js

```bash
git pull origin main
cd server

# Apply migrations
npm run node:migration:apply

# Build
npm run node:build

# Graceful restart with PM2
pm2 reload melody-auth-server
```

## Rollback Procedure

### Cloudflare Workers

```bash
# Rollback to previous version via dashboard
# Or redeploy previous release
npm run prod:deploy
```

### Node.js

```bash
# Checkout previous version
git checkout <previous-commit>

# Rebuild and restart
cd server
npm run node:build
pm2 restart melody-auth-server
```

## Backup Strategy

### Database Backups

**Cloudflare D1:**
```bash
# Export database
npx wrangler d1 export melody-auth --remote --output=backup.sql

# Import database
npx wrangler d1 execute melody-auth --remote --file=backup.sql
```

**PostgreSQL:**
```bash
# Backup
pg_dump melody-auth > backup.sql

# Restore
psql melody-auth < backup.sql
```

### Recommended Backup Schedule
- Daily automated backups
- Retain last 30 days
- Weekly backups retained for 3 months
- Monthly backups retained for 1 year

## Troubleshooting Production Issues

### High CPU/Memory Usage

1. Check number of concurrent requests
2. Review database query performance
3. Check for memory leaks
4. Scale horizontally if needed

### Database Connection Errors

1. Verify connection strings
2. Check database server status
3. Review connection pool settings
4. Check firewall rules

### JWT/Session Issues

1. Verify secrets are set correctly
2. Check token expiration settings
3. Review secret rotation logs
4. Validate JWT signature algorithms

## Support

For production issues:

1. **Check Documentation**: https://auth.ziyankhan.com
2. **Review Issues**: https://github.com/ziyankhan/melody-auth/issues
3. **Community Support**: https://github.com/ziyankhan/melody-auth/discussions
4. **Security Issues**: Open a security advisory on GitHub
