# Melody Auth

<p align="center">
  <strong>A turnkey, self-hosted OAuth & authentication system</strong>
</p>

<p align="center">
  <a href="https://github.com/ziyankhan/melody-auth/blob/main/LICENSE"><img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="License"></a>
  <a href="https://codecov.io/gh/ziyankhan/melody-auth"><img src="https://codecov.io/gh/ziyankhan/melody-auth/graph/badge.svg?token=AB3C1DCJJM" alt="Coverage"></a>
  <a href="https://github.com/ziyankhan/melody-auth/stargazers"><img src="https://img.shields.io/github/stars/ziyankhan/melody-auth" alt="Stars"></a>
</p>

---

## 🎯 About

**Melody Auth** is my take on what authentication should be: **simple to deploy, powerful to use, and completely yours to control**. 

Whether you're deploying to Cloudflare Workers in minutes or self-hosting with Node.js and PostgreSQL, Melody Auth gives you enterprise-grade authentication without the enterprise complexity.

### Why I Built This

Modern applications deserve modern authentication that doesn't lock you into proprietary platforms or charge per user. This project provides:
- ✅ **Full ownership** - Your data, your infrastructure, your rules
- ✅ **Multiple deployment options** - Cloudflare Workers, Node.js, or both
- ✅ **Production-ready** - OAuth 2.0, OpenID Connect, MFA, SSO, and more
- ✅ **Developer-friendly** - Comprehensive SDKs, clear docs, automated setup

### Quick Stats

- 🔐 **Enterprise Features**: OAuth 2.0, OpenID Connect, SAML SSO, MFA
- 🚀 **Fast Setup**: Get running in under 5 minutes with automated scripts
- 🌍 **Multi-language**: English, French, Chinese (more coming)
- 📦 **4 SDKs**: React, Angular, Vue, and vanilla JavaScript
- ✨ **Active Development**: Regular updates and community support

---

## 🚀 Quick Start

### Option 1: Automated Setup (Recommended)

```bash
git clone https://github.com/ziyankhan/melody-auth.git
cd melody-auth
npm run setup
```

The automated setup will:
- Install all dependencies
- Generate secrets
- Apply database migrations
- Configure environment files
- Provide next steps

### Option 2: Manual Setup

See our comprehensive [Development Guide](DEVELOPMENT.md) for detailed instructions.

### 💡 Need Help?

- 📖 **Documentation**: https://auth.ziyankhan.com
- 💬 **Discussions**: https://github.com/ziyankhan/melody-auth/discussions
- 🐛 **Issues**: https://github.com/ziyankhan/melody-auth/issues

---

**Disclaimer**: French translations in this project are AI-generated. Please review carefully before use.

---

## What's included?
- **OAuth & Authentication Server** [[Setup]](https://github.com/ziyankhan/melody-auth) [[Config]](https://github.com/ziyankhan/melody-auth)
- **Server-to-Server REST API** for backend integrations [[Setup]](https://github.com/ziyankhan/melody-auth) [[Swagger]](https://github.com/ziyankhan/melody-auth)
- **Admin Panel** for managing resources (also serves as a full-stack implementation example) [[Setup]](https://github.com/ziyankhan/melody-auth)

- **SDKs**:
  - react-sdk [[Package]](https://www.npmjs.com/package/@melody-auth/react) [[Doc]](https://github.com/ziyankhan/melody-auth)
  - angular-sdk [[Package]](https://www.npmjs.com/package/@melody-auth/angular) [[Doc]](https://github.com/ziyankhan/melody-auth)
  - vue-sdk [[Package]](https://www.npmjs.com/package/@melody-auth/vue) [[Doc]](https://github.com/ziyankhan/melody-auth)
  - web-sdk [[Package]](https://www.npmjs.com/package/@melody-auth/web) [[Doc]](https://github.com/ziyankhan/melody-auth)
- **Embedded Auth API** for embedding authentication flows directly within your application. [[Setup]](https://github.com/ziyankhan/melody-auth) [[Swagger]](https://github.com/ziyankhan/melody-auth)

## Auth Server Features Supported
- <b>OAuth 2.0</b>:
  - Authorize
  - Token Exchange
  - Refresh Token Revoke
  - App Consent
  - App Scopes
  - User Info Retrieval
  - OpenID Configuration
- <b>[Authorization](https://auth.ziyankhan.com/authentication.html)</b>:
  - Sign-In
  - Passwordless Sign-In
  - Sign-Up
  - Sign-Out
  - Email Verification
  - Password Reset
  - [Role-Based Access Control](https://auth.ziyankhan.com/rbac.html)
  - [User Attribute](https://auth.ziyankhan.com/user-attributes.html)
  - Account Linking
  - [Localization](https://auth.ziyankhan.com/localization.html)
- <b>External Identity Providers</b>:
  - [Social Sign-In](https://auth.ziyankhan.com/social-sign-in-provider-setup.html)
    - Google Sign-In
    - Facebook Sign-In
    - GitHub Sign-In
    - Discord Sign-In
    - Apple Sign-In
  - [OIDC Auth Provider Sign-In](https://auth.ziyankhan.com/oidc-sso-setup.html)
  - [SAML SSO Sign-In (Node.js environment only)](https://auth.ziyankhan.com/saml-sso-setup.html)
- <b>[Multi-Factor Authentication](https://auth.ziyankhan.com/mfa-setup.html)</b>
  - Email MFA
  - OTP MFA
  - SMS MFA
  - MFA Self Enrollment
  - Passkey Enrollment
  - Recovery Code
  - Remember Device for 30 days
- <b>[Policy](https://auth.ziyankhan.com/policies.html)</b>
  - sign_in_or_sign_up
  - update_info
  - change_password
  - change_email
  - reset_mfa
  - manage_passkey
  - manage_recovery_code
  - [saml_sso_[idp_name]](https://auth.ziyankhan.com/saml-sso-setup.html#_trigger-login-via-saml-sso-in-the-frontend)
  - [oidc_sso_[provider_name]](https://auth.ziyankhan.com/oidc-sso-setup.html#_trigger-oidc-redirects-from-your-frontend-via-policy)
- <b>Organization</b>:
  - [Branding config override](https://auth.ziyankhan.com/branding.html#per-organization-branding)
  - [Organization users](https://auth.ziyankhan.com/organizations.html)
  - [Organization groups](https://auth.ziyankhan.com/org-groups.html)
- <b>[Mailer Option](https://auth.ziyankhan.com/email-provider-setup.html)</b>
  - SendGrid
  - Mailgun
  - Brevo
  - Resend
  - Postmark
  - SMTP (Node.js environment only)
- <b>[SMS Option](https://auth.ziyankhan.com/sms-provider-setup.html)</b>
  - Twilio
- <b>JWT Authentication</b>
  - [RSA256 based JWT Authentication](https://auth.ziyankhan.com/jwt-and-jwks.html)
  - [JWT Secret Rotate](https://auth.ziyankhan.com/jwt-secret-rotate.html)
- <b>Brute-force Protection</b>:
  - Log in attempts
  - Password reset attempts
  - OTP MFA attempts
  - SMS MFA attempts
  - Email MFA attempts
  - Change Email attempts
- <b>Logging</b>:
  - Logger Level
  - Email Logs
  - SMS Logs
  - Sign-in Logs

## Admin Panel & S2S REST API Features Supported
- View Configurations
- Manage Users
  - [Impersonation](https://auth.ziyankhan.com/impersonation.html)
- Manage User Attributes
- Manage Apps
  - [App Level MFA Config](https://auth.ziyankhan.com/mfa-setup.html#_app-level-mfa-configuration)
  - [App Banner Config](https://auth.ziyankhan.com/app-banners.html)
- Manage Scopes
- Manage Roles
- Manage Organizations
- Manage SAML SSO IDPs
- [Manage Logs](https://auth.ziyankhan.com/log-management.html)
- [Admin Panel Access Control](https://auth.ziyankhan.com/admin-panel-setup.html#custom-role-access-for-the-admin-panel)

## Demo & Examples
- [Demo Site](https://auth-demo.ziyankhan.com)
- [Vite React Example](https://github.com/ziyankhan/melody-auth-examples/tree/main/vite-react-demo)
- [Angular Example](https://github.com/ziyankhan/melody-auth-examples/tree/main/angular-example)
- [Vite Vue Example](https://github.com/ziyankhan/melody-auth-examples/tree/main/vite-vue-example)
- [Next.js Full stack implementation Example](https://github.com/ziyankhan/melody-auth/tree/main/admin-panel)
- [Next.js Auth.js Example](https://github.com/ziyankhan/melody-auth-examples/tree/main/next-auth-js-example)
- [React Native Example](https://github.com/ziyankhan/melody-auth-examples/tree/main/react-native-example)
- [Vanilla JavaScript Example](https://github.com/ziyankhan/melody-auth-examples/tree/main/vite-web-example)
- [Embedded Auth API Example](https://github.com/ziyankhan/melody-auth-examples/tree/main/embedded-auth)

## Screenshots
[Authorization Screenshots](https://auth.ziyankhan.com/screenshots.html#identity-pages-and-emails)  
[Admin Panel Screenshots](https://auth.ziyankhan.com/screenshots.html#admin-panel-pages)

## License

This project is licensed under the MIT License. See the LICENSE file for details.
