# 06 - Authentication System and Session Management

This document outlines the authentication and user session architecture within the Hable app. It covers the hybrid online-offline session state, the Riverpod state management implementation, Cloudflare backend routes, and the security model.

## 1. Overview and Hybrid Session Model

Hable uses a hybrid authentication model to support its offline-first architecture:
- **Online (Cloudflare Backend):** Relies on standard JSON Web Tokens (JWT). Android, iOS, and Web persist the session through their existing host storage path; macOS deliberately keeps the token only in Riverpod memory for the running process. All authenticated API requests require a `Bearer <token>` header.
- **Offline (Drift Local Database):** Upon successful login, the backend responds with the user's profile which is cached in the local SQLite database (`Users` table). Platforms with persisted sessions can boot offline by matching the saved JWT and `userId`. macOS requires explicit login after every process launch, but retains local Drift data while signed out.

## 2. State Management (Riverpod)

Authentication state is managed globally by the `authProvider` (`NotifierProvider<AuthNotifier, AuthState>`).

### `AuthState` Properties
- `isLoading`: Boolean flag indicating active network requests (e.g., login, register, PIN requests).
- `isInitialized`: Boolean flag set to `true` once startup session initialization has finished. Android, iOS, and Web attempt their persisted-session path; macOS clears the legacy snapshot and initializes signed out without touching Keychain.
- `isAuthenticated`: A derived boolean getter (`token != null && userId != null`).
- `error`: Stores user-friendly error messages parsed from backend or network exceptions.
- `token`, `userId`, `username`: Core session identifiers stored in memory.

### Session Lifecycle Hooks
- **Startup (`build()` & `_loadStoredAuth`):** Android, iOS, and Web read the persisted JWT and `userId`. macOS never restores credentials: it removes the legacy SharedPreferences token snapshot, initializes signed out, and requires explicit login. Once a persisted session is restored on a supported host, local reminders are asynchronously reloaded via `localReminderServiceProvider`.
- **Explicit macOS login:** A successful login writes the token only to `AuthState`. Riverpod consumers and `SyncService.tokenProvider` use that in-memory token until logout or process exit. macOS auth fields publish disabled autofill configuration so the platform password service is not invoked.
- **Logout:** Cancels pending local reminders and resets `AuthState`. Persisted credentials are cleared on platforms that use them; macOS does not call Keychain read, write, or delete operations.

### Universal Startup Presentation

`StartupSplashBoundary` is a presentation-only overlay above `AppGate`. It keeps
the first Flutter frame visible for at least 800 ms, then fades once both auth
restoration and the bounded startup guards have resolved. `AppGate` remains the
only owner of auth, version-gate, sync, profile, and first-run quote routing, and
emits its readiness signal at most once. Background Workmanager initialization
runs after the first frame and never blocks `runApp` or the splash handoff.

## 3. Local Persistence and Security

### `flutter_secure_storage`
The following keys are stored securely on supported session-persistence hosts (Keychain on iOS and the existing secure host storage on other supported targets; EncryptedSharedPreferences on Android):
- `jwt_token`: The Bearer token.
- `user_id`: The canonical UUID.
- `username`: The user's handle.

macOS is an intentional exception: auth credentials are process-local and never pass through `flutter_secure_storage`. Existing Keychain entries are ignored rather than deleted, because deletion could invoke the system-credential path this policy disables. Non-sensitive per-user presentation flags, including first-run quote and revealed-badge state, use SharedPreferences on macOS so post-login UI cannot reintroduce Keychain prompts.

### Android restore boundary

Android release builds explicitly allow encrypted local Drift database backup for
reconciliation after an explicit login, while excluding SharedPreferences,
files, root storage, and external storage from Auto Backup and device transfer.
JWT credentials remain outside the backup set through `flutter_secure_storage`
and the excluded preference/file domains. A restored install therefore starts
signed out; it must not silently resurrect a session or switch accounts. Logout
and account switching continue to use the existing auth/cache clearing paths,
and restore does not add a backend backup or full-database replay request.

### Drift Database (`Users` Table)
The local database acts as the offline source of truth. The `_ensureUserInDb` method handles upserting the user profile when they log in or register.
Fields cached locally include `userId`, `username`, `email`, `avatarUrl`, and `emailVerifiedAt`.

## 4. Cloudflare Backend Routes

The backend provides a REST API for auth actions:
- **`POST /api/auth/login`**: Accepts `username` and `password` (or just `user_id` in test harnesses). Returns the JWT and full profile data.
- **`POST /api/auth/register`**: Accepts `username` and `password`. Creates a new account and returns the JWT.
- **`POST /api/auth/request-pin`**: Requests a password reset PIN via email (unauthenticated).
- **`POST /api/auth/reset-password`**: Commits a password reset with email, PIN, and new password (unauthenticated).

### Email Verification and Sync Activation
To participate in social/cloud sync features, users must verify their email. This requires an active JWT:
- **`POST /api/user/email/request-pin`**: Sends an OTP to the user's email. (Requires `Bearer` token).
- **`POST /api/user/email/verify-pin`**: Validates the OTP. On success, it updates the local Drift `emailVerifiedAt` timestamp to unlock sync features.

### Email Delivery Configuration
- `PRIVATE_EMAIL_SENDER_HABLE`: Verified sender address used by Hable's email flow.
- `CLOUDFLARE_ACCOUNT_ID`: Cloudflare account ID for the email-sending API.
- `PRIVATE_CLOUDFLARE_EMAIL_API_TOKEN`: API token with permission to send email for the Hable account.
- `EMAIL_WORKER`: Optional Cloudflare service binding for PIN delivery without duplicating sender/API-token secrets.
- To push the current Doppler values into the Hable Pages project, run `cd /Flutter/hable/backend && npm run sync:pages-secrets`.

## 5. Error Handling and Normalization

The `AuthNotifier` intercepts exceptions and normalizes them into user-friendly UI strings in `state.error`:
- **Network Failures:** Intercepts browser fetch/CORS failures, native socket failures, and timeouts, then maps them to one calm retry-oriented message family rather than exposing platform-specific exception text.
- **Backend Errors:** Extracts the structured `error.code` / `error.message` envelope where available, while still remaining compatible with legacy `{ error: '...' }` responses during migration.

Auth must not display raw exception text, backend URLs, stack traces, or raw response bodies in visible UI. Shared standards for error envelope shape, tone, and safe display are defined in [`sys_error_handling.md`](sys_error_handling.md).
