# Security Policy

## Supported Versions

The following versions of Melody Auth are currently supported with security updates:

| Version | Supported          |
| ------- | ------------------ |
| 1.3.x   | :white_check_mark: |
| < 1.3   | :x:                |

## Reporting a Vulnerability

The Melody Auth team takes security bugs seriously. We appreciate your efforts to responsibly disclose your findings and will make every effort to acknowledge your contributions.

### How to Report a Security Vulnerability

**Please do not report security vulnerabilities through public GitHub issues.**

Instead, please report them through one of the following methods:

1. **GitHub Security Advisories** (Recommended)
   - Go to the [Security tab](https://github.com/ziyankhan/melody-auth/security)
   - Click "Report a vulnerability"
   - Fill out the form with details about the vulnerability

2. **Email**
   - Send an email to: [security@ziyankhan.com](mailto:security@ziyankhan.com)
   - Include "SECURITY" in the subject line
   - Provide detailed information about the vulnerability

### What to Include in Your Report

To help us better understand and resolve the issue, please include as much of the following information as possible:

- Type of issue (e.g., buffer overflow, SQL injection, cross-site scripting, etc.)
- Full paths of source file(s) related to the manifestation of the issue
- The location of the affected source code (tag/branch/commit or direct URL)
- Any special configuration required to reproduce the issue
- Step-by-step instructions to reproduce the issue
- Proof-of-concept or exploit code (if possible)
- Impact of the issue, including how an attacker might exploit it

### Response Timeline

- **Initial Response**: We aim to acknowledge receipt of your vulnerability report within 48 hours
- **Status Update**: We will send you regular updates (at least once per week) on our progress
- **Resolution**: We aim to resolve critical vulnerabilities within 7 days, high severity within 30 days, and medium/low severity within 90 days

### Disclosure Policy

- Please give us reasonable time to address the issue before making it public
- We will coordinate with you on the disclosure timeline
- We will publicly acknowledge your responsible disclosure (unless you prefer to remain anonymous)

## Security Best Practices

### For Developers

1. **Keep Dependencies Updated**
   ```bash
   npm audit
   npm audit fix
   ```

2. **Environment Variables**
   - Never commit `.env`, `.dev.vars`, or `.env.local` files
   - Use strong, randomly generated secrets
   - Rotate secrets regularly using the built-in JWT rotation feature

3. **Database Access**
   - Use least-privilege principles for database access
   - Regularly review and audit access logs
   - Keep backups encrypted

4. **Authentication Flows**
   - Always use HTTPS in production
   - Implement rate limiting (configured in database)
   - Enable MFA for admin accounts

### For Production Deployments

1. **SSL/TLS**
   - Use HTTPS for all endpoints
   - Keep certificates up to date
   - Use TLS 1.2 or higher

2. **Secrets Management**
   - Use Cloudflare Workers Secrets or equivalent
   - Never hardcode secrets in source code
   - Rotate secrets periodically

3. **Monitoring**
   - Set up logging and monitoring
   - Alert on suspicious activities
   - Regular security audits

4. **Updates**
   - Subscribe to security advisories
   - Test updates in staging before production
   - Have a rollback plan

5. **Headers & CSP**
   - Implement proper security headers
   - Use Content Security Policy (CSP)
   - Enable CORS only for trusted origins

### For Users

1. **Admin Accounts**
   - Use strong, unique passwords
   - Enable MFA
   - Regularly review user permissions

2. **Regular Backups**
   - Back up database regularly
   - Test backup restoration
   - Store backups securely

3. **Access Control**
   - Follow principle of least privilege
   - Regular audit of user roles and permissions
   - Remove inactive users/apps

## Known Security Considerations

### Session Management
- Sessions are encrypted using the SESSION_SECRET
- Session tokens expire based on configured timeout
- Refresh tokens can be revoked via the admin panel or API

### JWT Tokens
- JWTs are signed using RSA256
- JWT secrets can be rotated without invalidating existing tokens
- See [JWT Secret Rotation](https://auth.ziyankhan.com/jwt-secret-rotate.html)

### Password Storage
- Passwords are hashed using bcrypt
- Minimum password strength requirements configurable per app
- Password reset tokens expire after configured timeout

### Rate Limiting
- Built-in rate limiting for authentication endpoints
- Configurable via database settings
- Protects against brute force attacks

### CORS
- CORS is configurable per app
- Restrict to trusted origins only
- Wildcards should be avoided in production

## Security Audit History

| Date       | Type          | Findings | Status |
|------------|---------------|----------|--------|
| 2025-12-11 | Internal Review | Initial security policy created | ✅ Complete |

## Security Contact

- **Email**: security@ziyankhan.com
- **GitHub**: https://github.com/ziyankhan/melody-auth/security

## Acknowledgments

We would like to thank the following people for responsibly disclosing security issues:

- *No security issues reported yet*

---

This security policy may be updated from time to time. Please check back regularly for updates.

Last Updated: December 11, 2025
