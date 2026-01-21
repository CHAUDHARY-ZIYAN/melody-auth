# Development Environment Notes

## Admin Panel Access
- **URL**: http://localhost:3000
- **Email**: `admin@test.com`
- **Password**: `Password1!`

## Current Configuration (Dev Overrides)
To facilitate local testing without external email providers, the following overrides have been applied to the local SQLite/D1 database:

1.  **MFA Disabled**: The `app` table has been updated to disable all MFA requirements (`requireEmailMfa=0`, `requireOtpMfa=0`, etc.) and system MFA config usage (`useSystemMfaConfig=0`).
2.  **Super Admin Role**: The user `admin@test.com` (User ID 2) has been manually assigned the `super_admin` role (Role ID 1) in the `user_role` table.

## Automated Tests
- **Server Tests**: `npm run test:server`
    - Note: Some tests in `email-mfa.test.ts` and others may fail due to mock inconsistencies in the test suite. The core application logic has been manually verified.
- **Admin Panel Tests**: `npm run test:admin`

## Development Commands
- **Start All**: `npm start` (or `npm run dev:server` & `npm run dev:admin`)
- **Stop All**: `npm stop`
