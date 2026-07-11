<!-- AI AGENT OPERATING CONTRACT — See Task_ai_agent_contract.md for full rules. This file hosts the compact completed-task index and the active engineered queue. -->

## Completed Tasks

- 2026-07-11 14:02 CEST: [Add Privacy-Preserving Anonymous Usage Aggregates For Development Diagnostics](Task2_Archived.md#add-privacy-preserving-anonymous-usage-aggregates-for-development-diagnostics)
- 2026-07-11 13:50 CEST: [Audit And Align Hable Development Docs With Current Code](Task2_Archived.md#audit-and-align-hable-development-docs-with-current-code)
- 2026-07-11 13:17 CEST: [Repair SignUp SignIn And Forgot Password Network Failures](Task2_Archived.md#repair-signup-signin-and-forgot-password-network-failures)
- 2026-07-11 04:15 UTC: [Add Revocable iCal Feed For Native Calendar Subscriptions](Task2_Archived.md#add-revocable-ical-feed-for-native-calendar-subscriptions)
- 2026-07-11 05:30 UTC: [Run ADB Smoke Tests For Auth, Friend Harness, And Recent UI Changes](Task2_Archived.md#run-adb-smoke-tests-for-auth-friend-harness-and-recent-ui-changes)
- 2026-07-08 15:59 Z: [Add Cloudflare Worker Backend For Social Sync & Ephemeral Nudges](Task2_Archived.md#add-cloudflare-worker-backend-for-social-sync-ephemeral-nudges)
- 2026-07-08 16:08 Z: [Add Offline Inverted Index Search Engine For Local Documents](Task2_Archived.md#add-offline-inverted-index-search-engine-for-local-documents)
- 2026-07-08 16:44 Z: [Add JWT Authentication And Friend-Request Authorization For Sync APIs](Task2_Archived.md#add-jwt-authentication-and-friend-request-authorization-for-sync-apis)
- 2026-07-08 19:51 Z: [Wire Mutual Habit Friends Into Home UI And Habit-Colored Rings](Task2_Archived.md#wire-mutual-habit-friends-into-home-ui-and-habit-colored-rings)
- 2026-07-08 20:08 Z: [Add Twin-App Friend Flow Test Harness](Task2_Archived.md#add-twin-app-friend-flow-test-harness)
- 2026-07-08 21:10 Z: [Complete Account, Friend Search, Habit Recording Sync, And Leaderboard MVP](Task2_Archived.md#complete-account-friend-search-habit-recording-sync-and-leaderboard-mvp)
- 2026-07-08 21:10 Z: [Expand Authentication, User Search, and Leaderboards](Task2_Archived.md#expand-authentication-user-search-and-leaderboards)
- 2026-07-09 14:05 CEST: [Reuse Onboarding Habit Presets In Habit Creation With Partner Invites And Clear Progress Labels](Task2_Archived.md#reuse-onboarding-habit-presets-in-habit-creation-with-partner-invites-and-clear-progress-labels)
- 2026-07-09 14:49 CEST: [Promote Habit Creation To Home Without Turning Home Into Profile](Task2_Archived.md#promote-habit-creation-to-home-without-turning-home-into-profile)
- 2026-07-09 15:10 CEST: [Deploy Flutter Web To Cloudflare Pages With Production Smoke Tests](Task2_Archived.md#deploy-flutter-web-to-cloudflare-pages-with-production-smoke-tests)
- 2026-07-09 16:15 CEST: [Build Social Friends List UI and Fix Partner Selection](Task2_Archived.md#build-social-friends-list-ui-and-fix-partner-selection)
- 2026-07-09 18:55 CEST: [Verify Web-Era Changes On Android APKs](Task2_Archived.md#verify-web-era-changes-on-android-apks)
- 2026-07-09 19:02 CEST: [Apply Flutter Podium Leaderboard Card Design](Task2_Archived.md#apply-flutter-podium-leaderboard-card-design)
- 2026-07-09 19:42 CEST: [Phase 5: Profile-Based Habit CRUD UI](Task2_Archived.md#phase-5-profile-based-habit-crud-ui)

- 2026-07-11 14:30 CEST: [Refine Habit Card Ring Icon Partner Rings And Responsive State Model](Task2_Archived.md#refine-habit-card-ring-icon-partner-rings-and-responsive-state-model)
- 2026-07-11 02:56 CEST: [Add Partnership Roles And Enforce Habit Permissions In Backend](Task2_Archived.md#add-partnership-roles-and-enforce-habit-permissions-in-backend)
- 2026-07-11 03:05 CEST: [Add Server-Side Gamification Progression To Daily Sync](Task2_Archived.md#add-server-side-gamification-progression-to-daily-sync)
- 2026-07-11 03:22 CEST: [Polish Habit Cards And Profile With Role-Aware Progression Data](Task2_Archived.md#polish-habit-cards-and-profile-with-role-aware-progression-data)

## Remaining Tasks

<a id="complete-cross-app-habit-lifecycle-sync-and-twin-harness-verification"></a>
### [ ] Complete Cross-App Habit Lifecycle Sync And Twin-Harness Verification

**Raw source:** Add a habit, set a time, sync it, update it, delete it. see it in your friends app (if you added them as friend), update it in your friends app, see it in your app. do the same for multi-day habits. after adding them in your app, add them in your friends app, see them in your app. test everything. Update docs.

**Issue:** Profile habit CRUD exists locally, but cross-app habit lifecycle sync is not real yet. `createHabitWithSync`, `updateHabitDetails`, `archiveHabit`, completion, and skip actions enqueue `SyncAction.createHabit`, `updateHabit`, and `logHabit`; `SyncService` currently mocks those actions instead of sending habit/log records to Cloudflare. The backend has social partnerships and `habit_progress`, but no complete authorized habit metadata lifecycle that lets the primary/friend installs see shared habit create/update/archive/log changes from each other.

**Ponytail triage:**
- *Should exist:* Yes, this is the smallest root-cause fix needed before twin-app habit testing can mean anything.
- *Smallest safe scope:* Implement real sync for create, update, archive, and log actions; pull shared habit metadata/progress through daily sync; verify one shared normal habit and one multi-day habit across `primary` and `friend` flavors.
- *Skipped scope:* Hard delete, reminders, recurring schedules, calendar integration, realtime sockets, conflict-resolution UI, bulk editing, public friend habit feeds, and full automation frameworks.
- *Boundaries:* Keep Hable privacy rules. Friends must not see every habit automatically; cross-app visibility requires an accepted friendship plus explicit partnership/habit invite. Treat "delete" as archive/abandon unless a future task explicitly requires destructive deletion.

**Action:** Replace the mocked habit/log sync path with a real offline-first lifecycle. Local Drift remains the optimistic source for UI. Background sync sends queued habit/log mutations to authenticated backend endpoints, the backend persists and authorizes shared habit state, and daily sync pulls only allowed shared habit metadata/progress into the other app. Then run the twin harness to prove add/time/update/archive/log behavior works in both directions for a normal habit and a multi-day habit.

**Hable perspective:** The Home and Profile screens should continue to read only Drift/Riverpod streams. The backend is only the reconciliation layer. Partner visibility belongs to accepted relationships and per-habit partnerships, not general friendship. Shared updates must not expose private skip journal text or unrelated habit lists.

**Implementation scope:**
- Drift schema/DAO: audit `Habits`, `Logs`, `Partnerships`, `SyncQueue`, and `PartnerSnapshots`; add only the minimum field needed to represent "set a time" without corrupting multi-day duration semantics if the current `targetDuration/currentDuration` fields are insufficient.
- Database methods in `lib/database/database.dart`: enqueue full payloads for create/update/archive/log instead of only `habitId`; mark local rows synced only after backend success.
- Sync layer in `lib/services/sync_service.dart`: replace the mocked `SyncAction.createHabit`, `SyncAction.updateHabit`, and `SyncAction.logHabit` branch with real authenticated HTTP calls and retry-safe error handling.
- Backend D1/schema: add or align full habit metadata storage, progress/log upserts, shared-habit authorization, status/archive handling, updated timestamps, and needed indexes for `user_id`, `habit_id`, partnership lookups, and updated sync ordering.
- Backend routes in `backend/src/index.ts`: implement authenticated habit create/update/archive/log endpoints and extend `/api/sync/daily` to return only authorized shared habit metadata and partner progress.
- Riverpod/UI: keep `ProfileScreen`, `HabitFormSheet`, `HomeScreen`, and `PartnerTicker` wired to local Drift; add only minimal UI/state hooks needed to show shared synced habits after daily sync.
- Twin harness/testing: update `TWIN_TEST_HARNESS.md` and/or `08_Testing.md` with exact steps for primary-to-friend and friend-to-primary habit lifecycle testing; run the path on a device/emulator.
- Test surface: focused backend/API smoke checks for habit create/update/archive/log authorization plus one device smoke pass through the twin harness.

**Scalability considerations:** Habit and log sync can be one queued mutation per request for now. Add D1 indexes before shared habits grow, and keep daily sync scoped to accepted/partnered habits. If offline queues grow after long offline use, batch habit/log mutations in a separate task.

**Future split guidance:** Batch sync, hard deletion, conflict-resolution UI, realtime shared updates, reminders, and CI-grade device automation are deferred. Append separate raw tasks only after this bidirectional lifecycle works manually.

**Edge cases:** User is offline during create/update/archive/log, missing or expired JWT, friend request accepted but no habit partnership, invite pending/declined, user tries to see non-partner habits, duplicate queued updates, update/archive conflict from both apps, archive after completion, restore after archive, local row marked synced after failed backend call, stale daily sync payload, private skip journal leaking to partner payloads, duration unit mismatch between daily time and multi-day journey, and seeded harness data diverging from D1.

**Acceptance criteria:**
- Creating a habit from Profile writes Drift immediately and syncs the full habit metadata to the backend instead of being mocked.
- Setting/updating the habit time/duration preserves correct multi-day habit semantics and does not inflate day counts through unit mismatch.
- Updating title, duration/time, and color in one install syncs and appears in the partnered install after daily sync.
- Archiving a habit in one install removes it from active lists in both partnered installs after sync while preserving history locally.
- Completing and skipping a habit enqueue real `logHabit` payloads; skip journal text stays private and is not exposed to partners.
- A normal shared habit and a multi-day shared habit can be created from `primary`, seen/updated from `friend`, then seen back in `primary`.
- A shared habit created from `friend` can be seen in `primary` after sync.
- Non-partner friends cannot see private habit metadata.
- `SyncService` no longer mocks `createHabit`, `updateHabit`, or `logHabit`.
- `01_Schema_and_Core_Logic.md`, `02_Offline_Architecture.md`, `03_UI_UX_and_Animations.md`, `04_Social_and_Analytics.md`, `07_Multi_User_Social_Features.md`, `TWIN_TEST_HARNESS.md`, and `08_Testing.md` are verified and updated to match the implemented lifecycle.

**Dependencies:** `01_Schema_and_Core_Logic.md`, `02_Offline_Architecture.md`, `03_UI_UX_and_Animations.md`, `04_Social_and_Analytics.md`, `07_Multi_User_Social_Features.md`, `TWIN_TEST_HARNESS.md`, `08_Testing.md`

**Implementation progress notes:**
- Implemented shared standard habit presets in `lib/data/standard_habits.dart` and reused them from onboarding plus `HabitFormSheet`.
- Updated `HabitFormSheet` to create/edit habits in days, prefill preset title/duration/color, and offer accepted-friend partner chips from Drift/Riverpod.
- Updated `AppDatabase.createHabitWithSync` and `HabitActionsController.createHabit` to return the created habit id, enqueue full habit metadata, and enqueue `sendHabitInvitation` items after the local habit exists.
- Hardened `POST /api/social/habit-invitation` to require requester habit ownership, accepted friendship, non-self target, and idempotent duplicate pending invites.
- Updated docs in `01_Schema_and_Core_Logic.md`, `02_Offline_Architecture.md`, `03_UI_UX_and_Animations.md`, `04_Social_and_Analytics.md`, `07_Multi_User_Social_Features.md`, `TWIN_TEST_HARNESS.md`, and `08_Testing.md`.
- Verified: `flutter analyze`, `npx tsc --noEmit`, `flutter test`, and `flutter build apk --debug`.
- Added optimistic completion-state repair in `lib/database/database.dart` so local remaining days decrement and habits move to `completed` only when they actually hit zero.
- Updated `lib/screens/home_screen.dart` so completion/skip logs flush the sync queue immediately and skip payloads no longer send private journal text to the backend.
- Updated `lib/services/sync_service.dart` to mark pushed habits/logs as synced after backend success and to reconcile inbound shared habits using backend status plus viewer remaining days instead of forcing `active` + zero progress.
- Extended `GET /api/sync/daily` in `backend/src/index.ts` to return shared-habit `status` and `viewer_remaining_days` for local reconciliation.
- Verified the lifecycle fixes with `flutter analyze`, `flutter test test/profile_habit_crud_test.dart test/habit_completion_progress_test.dart`, and `npx tsc --noEmit`.
- Added repeatable backend lifecycle smoke script at `backend/scripts/lifecycle-smoke.mjs` and exposed it as `npm run smoke:lifecycle`.
- Verified local backend with `npm run db:setup` and a direct API lifecycle smoke covering seeded auth, case-insensitive friend search, friend acceptance, normal shared habit sync, multi-day shared habit sync, Bob-owned habit visibility in Alice, completion progress, owner-only metadata update enforcement, archive propagation, and private habit exclusion.
- Verified emulator harness setup on `emulator-5554`: `adb reverse tcp:8787 tcp:8787`, built `app-primary-debug.apk` and `app-friend-debug.apk` with seeded identities, installed both packages, launched both flavors, and dumped UI hierarchies showing Alice/Bob each reach Home with the reciprocal shared Hydration card.
- Remaining before completion: full tap-by-tap lifecycle UI verification is still not complete because the local MobAI device controller described by the mobile-control skill is not exposed in this session. Backend/API lifecycle and flavor boot verification are complete, but manual or MobAI-driven device interaction is still needed for habit create/edit/archive/log from the Flutter UI.
- Progress noted at 2026-07-11 14:46 CEST.

**Completion notes:** [Placeholder for completion notes, touched files, behavior verified, and completion timestamp]

<a id="wire-friend-requests-through-social-hub-and-twin-harness-verification"></a>
### [ ] Wire Friend Requests Through Social Hub And Twin-Harness Verification

**Raw source:** add a social feature, e.g., friend request. implement it via search and button (e.g., in settings or new people tab). after adding them in your app, add them in your friends app, see them in your app. test everything. Update docs.

**Issue:** Backend friend-request endpoints exist, and `SocialHubScreen` already has a user search tab with a person-add button, but the button only shows "not yet implemented." Search results also do not expose relationship state, incoming requests are not surfaced in Flutter, and accepted friend state is not cached locally for downstream habit invites, nudges, leaderboards, or twin-app verification.

**Ponytail triage:**
- *Should exist:* Yes, accepted friendship is the gate for habit partnerships and later shared habit visibility.
- *Smallest safe scope:* Reuse `SocialHubScreen` as the "Find Friends" surface, wire the existing add button to send friend requests, add a compact incoming request list with accept/decline, cache relationship state locally, and verify the flow between `primary` and `friend` app flavors.
- *Skipped scope:* New settings tab, contact import, QR/user-code invites, push notifications, chat, blocking/reporting, public profiles, friend suggestions, and full 3D social browsing.
- *Boundaries:* Friend search may be an explicit network action, but request status and accepted relationships should be cached into Drift for offline-first reads. Search must not expose habit metadata or private journal data.

**Action:** Complete the friend-request flow end to end. Update the backend search/request APIs to be idempotent and privacy-safe, add request listing/accept/decline support, wire Flutter's Social Hub button and request list to those APIs through Riverpod/Drift state, and verify primary-to-friend plus friend-to-primary visibility in the twin harness.

**Hable perspective:** Friendships are a social permission layer, not shared habit data by themselves. Accepted friends can later receive habit-partner invites, but simply becoming friends must not reveal habit lists, logs, skip journal text, partner snapshots, private messages, or milestone events.

**Implementation scope:**
- Backend routes in `backend/src/index.ts`: harden `POST /api/social/friend-request`, add/verify duplicate and self-request guards, add request list and decline endpoints if missing, and update `GET /api/social/search` to return `user_id`, `username`, `avatar_url`, and `relationship_state` only.
- Backend schema/indexes in `backend/schema.sql`: add indexes for `(requester_id, recipient_id, status)` and enforce or simulate uniqueness for pending/accepted request pairs.
- Drift schema in `lib/database/tables.dart`: add a minimal local friend/request cache table if no existing table can represent pending incoming, pending outgoing, accepted, declined, usernames, avatars, and timestamps.
- Database methods in `lib/database/database.dart`: upsert friend request/search relationship state, watch pending incoming requests, watch accepted friends, and update status optimistically on accept/decline.
- Riverpod/social state in `lib/providers/social_providers.dart` or a small companion provider: expose friend requests, accepted friends, send request, accept request, and decline request actions.
- UI in `lib/screens/social/social_hub_screen.dart`: replace the placeholder add-button snackbar with real send behavior; show request state labels/buttons; add an incoming requests section/tab without creating a new broad social screen.
- Sync layer in `lib/services/sync_service.dart`: pull request state through `/api/sync/daily` or a dedicated social request endpoint and persist it locally; keep UI non-blocking when offline.
- Twin harness/testing: update `TWIN_TEST_HARNESS.md` and `08_Testing.md` with primary sends request to friend, friend accepts, primary sees accepted relationship, then reverse or re-run from friend side as needed.
- Test surface: focused backend/API smoke checks for search state, duplicate requests, self-request rejection, accept/decline authorization, and one device/emulator twin-harness pass.

**Scalability considerations:** Friend search should stay prefix/equality based with a small limit and indexed usernames. Friend request lookups need indexed requester/recipient/status pairs before the graph grows. A full friend graph service, pagination, and recommendation system are deferred.

**Future split guidance:** Habit partner invitation from habit creation/edit, friend profile pages, friend blocking, push notifications, contact import, and 3D friend exploration should remain separate tasks. Implement them only after this accepted-friend primitive works.

**Edge cases:** Searching yourself, duplicate request taps, reciprocal pending requests, accepting a missing/rejected request, stale token, user deleted after request, offline during send/accept, declined requests re-sent later, relationship state not refreshing in the sender app, seeded twin users already connected in D1, search leaking `total_score` or habit data, and accepted friendship without any shared habits.

**Acceptance criteria:**
- Social Hub search results show safe fields plus relationship state (`none`, `pending_incoming`, `pending_outgoing`, `accepted`, or equivalent).
- Tapping the existing add/friend button sends a real friend request and updates local/request UI state without blocking unrelated app use.
- Incoming friend requests are visible in the receiving app with accept and decline actions.
- Accepting a request updates backend state and both installs eventually show the relationship as accepted.
- Duplicate friend requests and self-requests are rejected or treated idempotently.
- Accepted friends still do not expose habit metadata until a separate habit partnership/invite exists.
- The primary app can send a request to the friend app, the friend app can accept it, and the primary app can see accepted state after refresh/sync.
- The same flow is verified from the friend app side or documented as already covered by the symmetric backend path.
- `04_Social_and_Analytics.md`, `07_Multi_User_Social_Features.md`, `02_Offline_Architecture.md`, `03_UI_UX_and_Animations.md`, `TWIN_TEST_HARNESS.md`, and `08_Testing.md` are verified and updated to match the implemented flow.

**Dependencies:** `04_Social_and_Analytics.md`, `07_Multi_User_Social_Features.md`, `02_Offline_Architecture.md`, `03_UI_UX_and_Animations.md`, `TWIN_TEST_HARNESS.md`, `08_Testing.md`

**Completion notes:** [Placeholder for completion notes, touched files, behavior verified, and completion timestamp]

<a id="build-3d-abstract-habit-environment-prototype"></a>
### [ ] Build 3D Abstract Habit Environment Prototype

**Raw source:** 3D Multi-User Social Features Ideation (`07_Multi_User_Social_Features.md`). work on ideation of tracking multi habbits, and seeing your friends habits as well, in a 3D abstract environment.

**Issue:** We have all the backend social primitives (friend requests, partner snapshots, habit synchronization), but the UI is still a standard 2D list/ticker. To fulfill the "inspiring, social experience" vision, habits need to be visualized in a 3D abstract space.

**Ponytail triage:**
- *Should exist:* Yes, this is the core differentiator mentioned in the social ideation doc.
- *Smallest safe scope:* Prototype a lightweight 3D or pseudo-3D abstract visual using Flutter's native `CustomPainter` (pseudo-3D isometric/particles) or a lightweight package (such as shaders or simple transforms). Map the current user's active habits and the partner snapshots to abstract visual elements such as colored orbs whose size represents `currentDuration`.
- *Skipped scope:* Complex 3D game engines, physics simulations, custom GLTF authoring, multiplayer camera controls, and a broad Home-screen redesign.
- *Boundaries:* The visualizer should be a stateless read-only surface over existing Drift/Riverpod data. It must not block the main thread, require network calls to render, or replace the primary habit interaction controls.

**Action:** Determine the smallest rendering approach, implement a `HabitEnvironmentVisualizer` widget, and integrate it into `HomeScreen` or `SocialHubScreen` behind a clear entry point so the current habit list remains usable while the prototype is evaluated.

**Hable perspective:** This is a UI experiment layered on top of the existing offline-first architecture. The scene should consume local `Habits`, accepted-friend state, and partner snapshots already present in Drift/Riverpod. It must preserve privacy boundaries by showing only data already allowed on-device for the current user.

**Implementation scope:**
- `lib/widgets/habit_environment_visualizer.dart` or similar reusable widget for the abstract scene.
- `lib/screens/home_screen.dart` or `lib/screens/social/social_hub_screen.dart` integration using existing providers rather than ad hoc state.
- Mapping of `habit.colorHex`, completion/progress, and partner snapshot values to deterministic visual properties.
- Accessibility fallback text or a compact list summary so the prototype does not become a visual-only dead end.
- A focused smoke or widget test proving the visualizer can render zero-habit, single-habit, and friend-linked states without crashing.

**Scalability considerations:** Keep draw cost bounded. If the user has many habits or many partner-linked items, cap simultaneously rendered objects, avoid rebuild-heavy animations, and keep any layout math off hot build paths.

**Future split guidance:** True 3D navigation, richer shaders, social walkthroughs, environment sharing, and realtime friend presence should be separate follow-up tasks only after the lightweight prototype proves worthwhile.

**Edge cases:** Performance on low-end Android devices, handling users with zero habits or zero friends, overlapping visual elements, stale partner data while offline, unreadable low-contrast color combinations, and state updates causing animation jank.

**Acceptance criteria:**
- A prototype visualizer exists and renders from local habit/social state without requiring network reads.
- Habit colors and progress map to deterministic visual elements.
- The existing Home or Social Hub flow remains usable when the prototype is present.
- Zero-habit and zero-friend states render a stable empty/prose fallback instead of a broken scene.
- `07_Multi_User_Social_Features.md`, `03_UI_UX_and_Animations.md`, and `02_Offline_Architecture.md` are verified and updated if the prototype changes UI guidance or state expectations.

**Dependencies:** `07_Multi_User_Social_Features.md`, `03_UI_UX_and_Animations.md`, `02_Offline_Architecture.md`

**Completion notes:** [Placeholder for completion notes, touched files, behavior verified, and completion timestamp]

<a id="support-emoji-or-uploaded-profile-pictures"></a>
### [ ] Support Emoji Or Uploaded Profile Pictures

**Raw source:** make possible to set Profile Picture; user should choose either a funny emoji avatar or upload an image profile picture. Uploaded profile pictures must be optimized server-side for web/profile display, stored, and used across the app.

**Issue:** The profile UI now has an avatar tap target and an `AvatarPickerSheet`, but the prompt still assumes only local avatar strings. The app should let users choose between a curated emoji avatar and an uploaded profile image, persist the selection locally, sync it through the authenticated backend, and show the chosen avatar consistently across Profile, friend lists, partner tickers, and friend profile surfaces.

**Ponytail triage:**
- *Should exist:* Yes, profile identity is visible in social flows and the raw request explicitly asks for it.
- *Smallest safe scope:* Reuse the existing `AvatarPickerSheet`, `UserAvatar`, `AuthNotifier.updateAvatar`, local Drift `Users.avatarUrl`, and authenticated backend avatar routes. Keep emoji avatars as safe local tokens. Add one upload path that sends an image to the backend, lets the backend validate and optimize it, stores the optimized result, and returns the stored profile-image URL/key for `avatar_url`.
- *Skipped scope:* Camera capture, manual cropping UI, advanced moderation, animated avatars, custom drawing tools, profile redesign, and marketplace-style avatar packs.
- *Boundaries:* Emoji choices are local strings. Uploaded images must become backend-owned optimized assets before any app surface uses them. Social APIs still expose only `username`, `avatar_url`, and allowed relationship/habit fields.

**Action:** Update the profile-picture flow so tapping the current profile avatar opens a prompt with two choices: choose an emoji avatar or upload an image profile picture. Selecting an emoji updates the local Drift user row immediately and sends the authenticated backend update. Uploading an image sends the original file to the backend, which validates type/size, strips metadata, generates web/profile-optimized image variants, stores the optimized asset, persists the chosen avatar reference, and returns the value used by all `UserAvatar` surfaces.

**Hable perspective:** This is profile/social polish with a backend storage boundary. It should preserve the offline-first Drift/Riverpod read model and the existing API masking rules. Social surfaces should continue to receive only `username`, `avatar_url`, and allowed relationship/habit fields.

**Implementation scope:**
- `lib/widgets/avatar_picker_sheet.dart`: change the prompt to offer emoji selection or image upload, keep the emoji list as stable constants, add clear Semantics/tooltips, and avoid duplicate creation paths.
- `lib/widgets/user_avatar.dart`: ensure local emoji strings, optimized remote profile-image URLs, and username initials all render consistently.
- `lib/screens/profile_screen.dart`: keep the avatar edit affordance discoverable without adding a separate profile-edit screen.
- `lib/providers/auth_provider.dart`: ensure emoji updates and upload results persist the current user's existing required fields locally, update `updatedAt`/sync state correctly, and fail gracefully if offline or unauthenticated.
- Upload client path: add the smallest cross-platform image picker/upload path needed for web and mobile, with clear progress/error states and no permanent loading state.
- `backend/src/index.ts`: keep avatar updates authenticated. Accept safe emoji tokens for direct avatar updates. Add an authenticated image-upload route that rejects unsupported media, enforces size limits, strips metadata, generates profile/web optimized variants, stores the optimized asset, updates `users.avatar_url`, and returns the stored avatar reference.
- Backend storage: use the project storage layer appropriate for Cloudflare deployment, preferably R2 or an equivalent backend-owned object store. Do not store raw user image bytes in D1.
- Social propagation: verify `/api/sync/daily`, friend search/profile responses, `AcceptedFriends`, and `PartnerSnapshots` continue to carry the updated `avatar_url` into friend list and partner UI.
- Test surface: add the smallest widget/provider/backend test or manual smoke entry proving the prompt exposes emoji and upload choices, emoji selection updates the local user avatar, and upload returns an optimized stored avatar that renders in Profile.

**Scalability considerations:** Uploaded images introduce storage, optimization cost, and cache invalidation concerns. Keep the stored image small, generate deterministic profile/web variants, use cacheable URLs, and replace or garbage-collect old avatar assets when users upload a new one.

**Future split guidance:** Append separate raw tasks only if the product needs camera capture, manual cropping, remote avatar packs, deeper image moderation, account-wide profile editing, or cross-device cache invalidation beyond the existing sync payload.

**Edge cases:** Unauthenticated user reaches Profile, offline avatar update, backend rejects the avatar or upload, upload is too large, unsupported file type, corrupt image, EXIF orientation, metadata stripping, slow network, duplicate upload taps, old image cache remains after replacement, local user row is missing a username, selected emoji is multi-codepoint, old DiceBear URL avatars still exist, web font/browser emoji rendering differs from Android, friend caches keep stale avatar values until daily sync, and screen readers need meaningful labels for emoji-only choices.

**Acceptance criteria:**
- Profile avatar tap opens a prompt offering `Choose emoji` and `Upload image` paths.
- Emoji selection updates the Profile avatar immediately from local Drift state and syncs through the authenticated backend.
- Image upload sends the file to the backend, not directly to public storage from the client.
- The backend validates uploaded image type/size, strips metadata, creates optimized web/profile image output, stores the optimized asset, updates `users.avatar_url`, and returns the stored avatar reference.
- `AuthNotifier.updateAvatar` does not corrupt required local user fields when updating `Users.avatarUrl`.
- Authenticated backend avatar routes persist the chosen avatar for the current JWT user and reject unauthenticated updates.
- Friend list, partner ticker, and friend profile avatar renderers continue to handle local emoji tokens, optimized uploaded image URLs, and existing URL avatars.
- Offline or failed network update gives a clear non-crashing result and does not leave the UI in a permanent loading state.
- At least one focused test or documented smoke check verifies the prompt choices, emoji update behavior, upload optimization/storage behavior, and rendered uploaded avatar.
- `03_UI_UX_and_Animations.md`, `04_Social_and_Analytics.md`, `01_Schema_and_Core_Logic.md`, and `08_Testing.md` are verified and updated if behavior, schema assumptions, or test procedure changes.

**Dependencies:** `03_UI_UX_and_Animations.md`, `04_Social_and_Analytics.md`, `01_Schema_and_Core_Logic.md`, `08_Testing.md`

**Completion notes:** [Placeholder for completion notes, touched files, behavior verified, and completion timestamp]

<a id="build-notification-center-and-local-reminder-mvp"></a>
### [ ] Build Notification Center And Local Reminder MVP

**Raw source:** work on notification system for reminding tasks, getting friends interactions (requests acceptance/denial, nudges, etc), sync between devices, cross platform (android and web/ios), etc.

**Issue:** Hable receives social events through sync (`nudges`, private messages, habit invitations, friend requests, accepted friends), but those events are scattered across feature surfaces and are not persisted as a unified notification stream. There is also no cross-platform reminder permission/settings flow. The app needs one offline-first notification center that works from local Drift state first, plus a small local reminder path for habit/task reminders. Remote push should be designed deliberately, not bolted onto the first pass.

**Ponytail triage:**
- *Should exist:* Yes, notification center and reminders are core product plumbing for habit reminders and social interactions.
- *Smallest safe scope:* Add a local Drift-backed notification center, translate existing sync payloads into idempotent notification rows, expose unread/read state through Riverpod, and add opt-in local reminders for habit/task reminders on platforms where local notifications are supported.
- *Skipped scope:* Cloudflare web push broadcast, FCM/APNs production push, admin notification console, realtime sockets, marketing campaigns, notification recommendation logic, and rich media notifications.
- *Boundaries:* Flutter UI must read notifications from Drift/Riverpod. Remote social events arrive through authenticated sync and are stored locally before rendering. Local reminders are opt-in and device-local. Any future push subscription stores device endpoints separately from in-app notification events.

**Campusweb reference pass:** Before implementing, inspect and adapt the proven concepts from `../../campusweb`; do not copy Svelte UI into Flutter.
- In-app announcements: `../../campusweb/src/routes/api/notifications/+server.ts` uses a KV-backed notification document with type, title, message, link, expiry, and audience filters.
- Client unread model: `../../campusweb/src/lib/stores/notificationsStore.ts` and `../../campusweb/src/lib/components/AppNotifications.svelte` keep seen IDs locally, derive unread count/severity, fetch on open/startup, and provide mark-read/mark-all-read behavior.
- Push opt-in and preferences: `../../campusweb/src/lib/components/settings/SettingsNotifications.svelte`, `../../campusweb/src/lib/components/PushNotificationPrompt.svelte`, and `../../campusweb/src/lib/utils/pushSubscriptionSync.ts` show the useful consent-before-subscribe shape.
- Cloudflare push backend reference only: `../../campusweb/migrations/0000_create_push_subscriptions.sql`, `../../campusweb/migrations/0001_add_push_preferences.sql`, `../../campusweb/src/routes/api/push/subscribe/+server.ts`, `../../campusweb/src/routes/api/push/unsubscribe/+server.ts`, `../../campusweb/src/lib/server/push/broadcast.ts`, and `../../campusweb/src/service-worker.ts` separate D1 subscription storage, preference targeting, stale subscription pruning, VAPID signing, and service-worker display. Treat this as future Hable push architecture, not MVP scope.
- Cloudflare bindings: `../../campusweb/wrangler.toml.example` demonstrates separate KV/D1/R2 bindings. For Hable, use D1 for relational social/sync data, KV only for global/audience announcement documents if that future scope is added, and keep uploaded assets in R2 or equivalent object storage.

**Action:** Build the MVP notification center and local reminder path. Add a Drift notification-events table, persist notification rows from sync and local reminder scheduling, show an unread-count entry point in the app, let users mark notifications read/all-read, and add the smallest settings/permission flow needed for local habit reminders without enabling remote push yet.

**Hable perspective:** Notifications are another offline-first read model. The Home, Profile, and Social Hub should not directly parse backend event payloads for badges. `SyncService.pullDailySync` should normalize allowed remote events into local `NotificationEvents`, then the notification UI reads one local stream. This preserves privacy because only already-authorized social data becomes notifications.

**Implementation scope:**
- Drift schema in `lib/database/tables.dart`: add `NotificationEvents` with stable `id`, `userId`, `type`, `sourceType`, `sourceId`, `title`, `body`, optional `actionRoute`/payload JSON, `createdAt`, optional `expiresAt`, optional `readAt`, and indexes for `userId`, `readAt`, `createdAt`, and `(sourceType, sourceId)` idempotency.
- Database methods in `lib/database/database.dart`: upsert notification events idempotently, watch all/unread notifications for the current user, mark one/all as read, delete expired rows, and avoid duplicate rows when daily sync returns the same event twice.
- Sync normalization in `lib/services/sync_service.dart`: convert `nudges`, `messages`, `invitations`, `friend_requests`, and accepted-friend changes from `/api/sync/daily` into notification rows while still persisting their feature-specific tables. Do not show private habit data beyond what existing social payloads already allow.
- Riverpod in `lib/providers/notification_providers.dart` or equivalent: expose unread count, recent notifications, mark-read actions, and reminder settings/actions using the current user from auth state.
- Flutter UI: add a compact notification bell/entry point to an existing top-level surface, a notification center sheet/screen with unread/read states, type icons, timestamps, empty/error states, and action routing back to Social Hub, invitations, messages, or Home where possible.
- Local reminders: add an opt-in settings control for habit/task reminders, request platform permission only from a user action, schedule/cancel local reminders for supported Android/iOS/macOS paths, and use an in-app fallback state for web until a dedicated web-push task exists.
- Backend: keep MVP backend changes minimal. Extend `/api/sync/daily` only if a currently needed social event is not returned. Do not add Cloudflare push subscription storage in this task unless local notification implementation is already complete and the user explicitly expands scope.
- Documentation: update `01_Schema_and_Core_Logic.md`, `02_Offline_Architecture.md`, `03_UI_UX_and_Animations.md`, `04_Social_and_Analytics.md`, `07_Multi_User_Social_Features.md`, and `08_Testing.md` if schema, sync, UI, social, or manual testing guidance changes.
- Test surface: add focused Drift/provider tests for idempotent upsert and unread/read behavior, widget smoke for the notification center empty/unread states, and a documented manual smoke for local reminder permission/scheduling on at least one supported platform.

**Scalability considerations:** Keep notification events small and indexed by current user/read/time. Expire or prune old read notifications before the table becomes a long-term event log. If future remote push is needed, follow the campusweb separation: D1 stores push subscriptions/preferences, KV can store global audience announcements, and the app still writes in-app notification rows for durable state.

**Future split guidance:** Add Cloudflare web push, FCM/APNs, VAPID key management, admin broadcast UI, KV-backed global announcements, realtime sockets, notification digesting, quiet hours, and cross-device read-state sync as separate tasks after the local center works.

**Edge cases:** Duplicate sync payloads, same nudge received after app reinstall, notification source row missing after deletion, expired notification still unread, logged-out user with old notifications, account switch on same device, offline while marking read, local reminder permission denied, Android notification permission on newer versions, iOS/web support differences, web running without service worker push, sync returns a friend request after it was accepted elsewhere, and notification tap targets routing to unavailable screens.

**Acceptance criteria:**
- A `NotificationEvents` Drift table and DAO/provider surface exist for current-user notifications.
- `/api/sync/daily` social payloads are normalized into idempotent local notification rows without duplicate unread items.
- Users can open a notification center, see unread/read notifications, mark one read, and mark all read.
- The unread count updates from local Drift state and survives app restart.
- Notification actions route to the closest existing relevant surface or degrade gracefully when no route exists.
- Local habit/task reminder settings request permission from a user action and schedule/cancel supported local reminders without crashing unsupported platforms.
- Remote push subscriptions, Cloudflare broadcast, and service-worker push are explicitly deferred unless a later task expands scope.
- Focused tests or documented smoke checks cover idempotent upsert, unread/read state, empty state, and local reminder permission/scheduling behavior.
- The campusweb reference files above are used only as architecture guidance, and any adopted backend pattern is translated to Hable's Flutter/Cloudflare codebase.
- Required development docs are verified and updated if the implementation changes schema, sync, UI, social behavior, or test procedure.

**Dependencies:** `01_Schema_and_Core_Logic.md`, `02_Offline_Architecture.md`, `03_UI_UX_and_Animations.md`, `04_Social_and_Analytics.md`, `07_Multi_User_Social_Features.md`, `08_Testing.md`, `../../campusweb/src/routes/api/notifications/+server.ts`, `../../campusweb/src/lib/stores/notificationsStore.ts`, `../../campusweb/src/lib/server/push/broadcast.ts`

**Completion notes:** [Placeholder for completion notes, touched files, behavior verified, and completion timestamp]

<a id="add-friend-profile-drilldown-and-habit-scoped-nudge-actions"></a>
### [ ] Add Friend Profile Drilldown And Habit-Scoped Nudge Actions

**Raw source:** work on seeing friends profile by tapping on their name at homepage, and the nudging is exclusively for partners on the partnered habits cards (inside the card). Follow-up detail: you can see friends profile, and their active habbits, and able to follow their habits and nudge them without being partner in that habbit.

**Issue:** Home currently renders `PartnerTicker` from local `PartnerSnapshots`, and `PartnerTicker` has split behavior: avatar tap enqueues a nudge while username tap opens `ProfileScreen(userId: partner.partnerUserId)`. Friend profile rendering already exists in `ProfileScreen`, but the active-habit list uses a local-only "Nudged" snackbar and a follow button that only pre-fills `HabitFormSheet`. This makes profile navigation hard to discover, nudge behavior too global, and friend-profile encouragement/follow actions inconsistent with the real sync queue and privacy model.

**Ponytail triage:**
- *Should exist:* Yes, the current UI mixes profile navigation and nudge action in the Home partner ticker, and friend-profile actions do not match backend behavior.
- *Smallest safe scope:* Reuse the existing `ProfileScreen`, `friendProfileProvider`, `PartnerTicker`, `habitPartnersProvider`, `HabitFormSheet`, and nudge sync queue. Make Home partner names/avatars clearly open friend profiles, move real nudge controls into partnered habit cards, and make friend-profile follow use the existing habit creation sheet.
- *Skipped scope:* Public habit marketplace, recommendations, follow-feed persistence, push notifications, realtime presence, comments, non-friend profile browsing, full social graph redesign, and new backend tables for "following" habits.
- *Boundaries:* Do not expose private habit journals or non-allowed habit metadata. Do not let global Home partner widgets send ambiguous nudges. If friend-profile nudge remains allowed for accepted friends, label it as encouragement and keep backend authorization explicit.

**Action:** Tighten the friend drilldown and nudge UX. Make tapping a friend identity on Home open their profile consistently. Remove or demote the global partner-ticker nudge affordance. Add per-habit partner controls inside `_HabitCard` using `habitPartnersProvider(habit.habitId)` so nudges are sent from the specific partnered habit context. On friend profiles, keep the active habits list privacy-scoped, make "Follow" prefill a local habit creation flow, and replace local-only nudge feedback with the real queue-backed nudge action only when backend authorization permits it.

**Hable perspective:** Home remains the daily action surface and reads Drift/Riverpod state. Partner snapshots are local read models from `/api/sync/daily`. Friend profile loading may use the existing authenticated network provider because it is a deliberate drilldown, but the profile must only show fields the backend is allowed to expose. Nudge writes should be queued through `SyncQueue` and flushed by `SyncService`, not simulated with a snackbar.

**Implementation scope:**
- `lib/widgets/partner_ticker.dart`: make the primary tap target open `ProfileScreen` for the friend; remove the avatar-tap nudge side effect or replace it with a clearly separate profile-only affordance.
- `lib/screens/home_screen.dart`: stop wiring global `allPartnersProvider` nudges from the bottom ticker; render habit-specific partners inside `_HabitCard` using `habitPartnersProvider(habit.habitId)` and expose a small nudge action per partner on that card.
- `lib/providers/social_providers.dart`: reuse `enqueueNudge` for habit-card partner nudges and friend-profile encouragement; avoid creating a second nudge path.
- `lib/screens/profile_screen.dart`: keep `_buildFriendProfile` and `_FriendHabitListTile`, but make active habit rows show safe data only, make `Follow` open `HabitFormSheet.show(context, prefilledTitle: title)` with no hidden network mutation, and make any nudge/encourage button enqueue a real `sendNudge` item or be hidden/disabled when the viewer is not authorized.
- Backend route `backend/src/index.ts`: verify `GET /api/social/user/:id/profile` is authenticated and privacy-scoped to accepted friends or allowed relationships before returning active habits; verify `POST /api/social/nudge` matches the intended friend-vs-partner authorization rule.
- Drift/Riverpod: use existing `PartnerSnapshots`, `AcceptedFriends`, and stream providers; add only tiny DAO/provider helpers if needed to map partners by habit efficiently.
- Accessibility: update semantics so friend identity tap says it opens profile, and nudge buttons say which friend and habit they affect.
- Test surface: focused widget/provider test or documented smoke for profile navigation from Home, habit-card nudge enqueue, friend-profile follow prefill, and backend rejection/disable behavior for unauthorized nudges.
- Documentation: update `03_UI_UX_and_Animations.md`, `04_Social_and_Analytics.md`, `07_Multi_User_Social_Features.md`, and `08_Testing.md` if interaction placement, privacy rules, or smoke steps change.

**Scalability considerations:** Keep partner rendering per habit bounded; `habitPartnersProvider(habitId)` should watch one habit's partner snapshots rather than rebuilding Home from every partner row for every card. Friend profile active-habit lists should stay small and privacy-scoped; pagination can be a future task if profiles become large.

**Future split guidance:** A durable "follow habit" model, friend activity feed, profile privacy settings, public habit templates, richer encouragement messages, notifications for encouragement, and recommendation algorithms should be separate tasks. This task should only make existing friend profile, follow-prefill, and nudge mechanics coherent.

**Edge cases:** No partners on a habit, multiple partners on one habit, same partner appears on many habits, tapping a friend with stale profile data, friend profile network failure, accepted friend without shared habits, backend authorizes friend-level nudge but product wants partner-only nudge, user follows their own habit from their profile, duplicate follow-created habit titles, nudge queued offline, nudge button tapped repeatedly, stale partner snapshots after partnership removal, and screen readers confusing profile taps with nudge buttons.

**Acceptance criteria:**
- Tapping a friend identity from Home opens the existing friend profile screen with username, avatar, score, and allowed active habits.
- The global Home partner ticker no longer sends ambiguous nudges from the same tap target used for profile discovery.
- Partner nudge actions appear inside the relevant partnered habit card and enqueue `SyncAction.sendNudge` with the selected partner user id.
- Friend profile active-habit rows show only privacy-safe fields returned by the backend.
- Friend profile `Follow` opens the existing habit creation sheet with the friend's habit title prefilled and does not create remote follow state.
- Friend profile nudge/encourage action either enqueues a real nudge through the existing sync queue when authorized or is hidden/disabled with a clear non-crashing state when unauthorized.
- Backend profile and nudge routes do not expose private habit data or allow unauthorized users to inspect/nudge arbitrary users.
- Semantics labels distinguish "open profile" from "nudge partner".
- A focused test or documented smoke covers Home profile tap, habit-card nudge, friend-profile follow prefill, and unauthorized nudge handling.
- Dependency docs are verified and updated if UX placement, backend privacy rules, or smoke procedures change.

**Dependencies:** `03_UI_UX_and_Animations.md`, `04_Social_and_Analytics.md`, `07_Multi_User_Social_Features.md`, `08_Testing.md`

**Completion notes:** [Placeholder for completion notes, touched files, behavior verified, and completion timestamp]

<a id="keep-partner-shared-habits-visible-after-check-in-and-surface-nudges"></a>
### [ ] Keep Partner Shared Habits Visible After Check-In And Surface Nudges

**Raw source:** HABIT PARTNERING bug report:
- for partner, not creator, habit card shws up, but it gets deleted once the user checkes in (completes the ring), hoof, gone.
- nudge is not implemented yet:
  - just the announcement of the nudge has been sent appears at the very bottom of the home screen for a second, which is not enough. also, it should be more visible and obvious.
  - (the nudged person) is not aware of the nudge at all, in app or when it's closed.
  - when user is nudged, the card does not change state (the ring should animate in a special way)
  - research about how nudging/poking/reminding works and what is the best way to implement it (not spamming, but effective, psychological and fun).

**Issue:** Partner-accepted shared habit cards are being upserted into the recipient's local `Habits` table from `/api/sync/daily`, then completed through the same `_HabitCard._handleCompletion` path as owned habits. The current completion path can set `HabitStatus.completed`, and `watchActiveHabits(userId)` filters completed habits out of Home, so a partner-side check-in can make the shared card disappear. Nudge sending is also only a queued `sendNudge` plus a brief snackbar; received nudges are returned by `/api/sync/daily` but `SyncService` only logs them with `debugPrint`, so the recipient sees no durable in-app state, no card/ring reaction, and no useful feedback if the app was closed.

**Ponytail triage:**
- *Should exist:* Yes, this is a concrete user-visible regression in shared habit retention and a missing feedback loop for an already implemented backend nudge path.
- *Smallest safe scope:* Fix the root shared-habit lifecycle bug in the local completion/sync path, persist or expose received nudges enough for Home to react in-app, and make send/receive feedback visible on the relevant habit card without adding a full push-notification stack.
- *Skipped scope:* FCM/APNs/web push, service workers, notification permission UI, full notification center, real-time sockets, rich encouragement message authoring, anti-spam analytics, and a broad behavioral-science research project.
- *Boundaries:* Keep the app offline-first. Home must render from Drift/Riverpod. Do not expose private journal data. Do not let a nudge create progress/logs or pressure supporters into completion. Do not implement OS notifications here; defer that to the existing notification-center/reminder task.

**Action:** Repair shared habit check-in retention and make nudges visible in the existing Home card experience. Trace `_HabitCard._handleCompletion`, `watchActiveHabits`, `SyncService.pullDailySync`, `PartnerSnapshots`, and `/api/social/nudge`; prevent partner-side daily check-ins from changing the habit lifecycle status to a value that removes the card from Home; and convert received nudge payloads into local state that the relevant habit card can display with a clear temporary ring/card animation or persistent in-app indicator until seen.

**Hable perspective:** Shared habit visibility belongs to accepted habit partnerships, not local habit ownership. A partner can complete/skip their own daily log for a shared habit, but that should not archive or complete the shared habit metadata row unless the owner intentionally changes the habit lifecycle. Nudges are social cues for already-authorized shared habits: sender writes a queued local intent, Worker stores/returns an ephemeral event, and Flutter must persist enough local read-model state for Home to show it even after an app restart.

**Implementation scope:**
- Root-cause audit: inspect `lib/screens/home_screen.dart` `_HabitCard._handleCompletion`, `lib/database/database.dart` `watchActiveHabits` and `updateHabitStatus`, and `lib/services/sync_service.dart` shared-habit upsert behavior.
- Local lifecycle fix: ensure a partner/shared habit remains `HabitStatus.active` after the viewer completes today's ring; if the code needs to distinguish daily completion from challenge lifecycle completion, keep that distinction in Drift/provider logic rather than overloading `HabitStatus.completed`.
- Shared progress semantics: verify `currentDuration`, `targetDuration`, `_challengeDay`, and `_progressFraction` do not make a received shared habit look finished on day one because `/api/sync/daily` inserted it with `currentDuration = 0`.
- Backend sync check: verify `POST /api/sync/log` still accepts owner/partner completion and skip based on role, and verify `/api/sync/daily` returns enough habit metadata/progress to reconstruct the shared card without leaking private fields.
- Nudge receive state: convert `data['nudges']` in `SyncService.pullDailySync` from `debugPrint` only into a small local read model. Prefer an existing notification table/provider if the notification-center task has landed by then; otherwise add the smallest Drift-backed received-nudge cache needed for Home.
- Nudge card UI: make the relevant habit card/ring react when there is an unseen recent nudge from a partner, using a visible but non-spammy treatment such as a short pulse, badge, or "nudged by X" chip that clears after viewing or after a bounded TTL.
- Nudge send feedback: replace or supplement the bottom snackbar with card-local feedback near the partner chip so the sender sees which habit/person was nudged.
- Anti-spam baseline: keep nudges opt-in-by-context and bounded. Use one visible nudge state per sender/habit or a short cooldown/merge window rather than stacking repeated alerts.
- Tests: add focused Drift/provider/widget tests proving shared habits stay active after partner check-in, received nudges persist into local state, and Home renders a visible nudge indicator without duplicate spam.
- Manual smoke: update `08_Testing.md` with a twin-app flow: Alice invites Bob, Bob accepts, Bob checks in and the card remains visible, Alice nudges Bob, Bob syncs/reopens and sees an in-app card/ring nudge state.

**Scalability considerations:** Nudge state should stay bounded by TTL, sender, and habit so local storage does not become an unbounded event log. Repeated nudges should coalesce by `(habitId, senderId)` or expire quickly. Partner habit rendering should remain habit-scoped through `habitPartnersProvider(habitId)` and should not watch all nudge/social rows for every card.

**Future split guidance:** OS push when the app is closed, notification permissions, web push, configurable quiet hours, nudge cooldown policy, richer encouragement copy, analytics on nudge effectiveness, and psychology-backed personalization should be separate tasks. The existing **Build Notification Center And Local Reminder MVP** task can own durable notification-center design; this task should only create the minimal in-app state required for shared habit cards to react correctly.

**Research baseline:** Lightweight nudges should preserve user choice, stay relevant, and avoid excessive frequency. Behavior-change literature supports timely cues as useful short-term prompts, while notification research warns that overly frequent or irrelevant prompts create fatigue. Use this as a product guardrail: one contextual nudge per habit/partner state is better than generic repeated alerts. References reviewed during engineering: `https://pmc.ncbi.nlm.nih.gov/articles/PMC11161714/`, `https://pmc.ncbi.nlm.nih.gov/articles/PMC10337295/`, and `https://pmc.ncbi.nlm.nih.gov/articles/PMC10002044/`.

**Edge cases:** Partner checks in on a shared habit with `currentDuration = 0`, owner checks in on the final day of a challenge, partner skips instead of completes, sync log fails after optimistic local completion, user receives multiple nudges before opening the app, KV nudge is consumed by one sync before UI observes it, app restarts after receiving a nudge, stale partner snapshots after partnership removal, supporter receives or sends nudges but cannot complete/skip, nudge from a partner on a habit no longer active locally, and repeated taps causing duplicate queued nudges.

**Acceptance criteria:**
- A partner-side check-in on a shared habit no longer removes the habit card from the partner's Home active list.
- The fix is rooted in lifecycle/progress semantics, not a one-off UI reinsert hack.
- Shared habit cards inserted from `/api/sync/daily` have sane day/progress values and do not appear already complete on first receipt.
- Owner/partner completion and skip logs still sync through `SyncAction.logHabit` and backend role authorization.
- Received nudges from `/api/sync/daily` are persisted or exposed through a local Riverpod/Drift read model instead of only `debugPrint`.
- Home shows a clear in-app nudge state on or near the relevant habit card/ring for the nudged recipient.
- Sending a nudge gives visible feedback tied to the selected habit/partner, not only a barely noticeable bottom snackbar.
- Repeated nudges are coalesced, cooldown-bounded, or TTL-bound so the UI cannot become spammy.
- No OS push notification or service-worker scope is added in this task.
- Focused tests or documented smoke cover partner check-in retention, nudge send feedback, nudge receipt display, app restart after receipt, and duplicate nudge handling.
- `02_Offline_Architecture.md`, `03_UI_UX_and_Animations.md`, `04_Social_and_Analytics.md`, `07_Multi_User_Social_Features.md`, and `08_Testing.md` are verified and updated if lifecycle, sync, nudge UI, or testing behavior changes.

**Dependencies:** `02_Offline_Architecture.md`, `03_UI_UX_and_Animations.md`, `04_Social_and_Analytics.md`, `07_Multi_User_Social_Features.md`, `08_Testing.md`

**Completion notes:** [Placeholder for completion notes, touched files, behavior verified, and completion timestamp]

<a id="rework-daily-navigation-and-screen-information-architecture"></a>
### [ ] Rework Daily Navigation And Screen Information Architecture

**Raw source:** From `Task_Idea.md`: document different sections, tabs, and pages (`home`, `profile`, `social`, `settings`, etc.), then revise the structure and placement of them. Consider tabs for main navigation elements and a page for the most important action, creating a habit. Minimize clutter and use the fewest UI elements needed for the maximum information and functionality. Think as a designer and developer: Hable is a daily habit tracker, so it should stay simple, elegant, easy, fun, and engaging. Review the current UI and user journey, optimize common actions, remove redundant steps, add missing steps, and clarify Home, Profile, Social, Settings, and habit creation.

**Issue:** Hable's current app structure is still screen-push based: `_AppGate` sends authenticated users to `HomeScreen`, and Home opens Social Hub, habit creation, and Profile through header buttons. Profile also mixes account state, cloud activation, charts, habit management, calendar subscription, achievements, and avatar editing. Social Hub contains several tabs internally. There is no dedicated Settings surface. The result works functionally, but the information architecture is starting to blur daily action, account settings, social obligations, historical progress, and habit creation.

**Ponytail triage:**
- *Should exist:* Yes, the app has enough shipped surfaces that navigation and section ownership now need deliberate structure.
- *Smallest safe scope:* Produce a bounded in-app navigation and screen-ownership refactor: introduce or design a persistent main shell for Home, Social, Profile, and Settings; keep habit creation as a prominent action; move only clearly misplaced account/settings controls; and preserve current Home/Profile/Social functionality.
- *Skipped scope:* Full visual redesign, new brand system, onboarding rewrite, new backend features, OS notifications, settings for every future feature, desktop-specific navigation, and a separate design-system package.
- *Boundaries:* Do not rewrite feature logic while reorganizing surfaces. Home remains the daily action view. Profile remains progress/history. Social remains friends, requests, leaderboards, inbox, and shared obligations. Settings owns account, recovery, notifications/preferences, accessibility/language placeholders, and other durable configuration.

**Action:** Audit Hable's current screen structure and implement the smallest useful information-architecture cleanup. Define screen responsibilities, add a main navigation shell if warranted by the current UI, keep habit creation easy from daily use, move account/settings controls into an appropriate Settings surface, and update docs/tests to reflect the new navigation model.

**Hable perspective:** The Flutter app is offline-first and Riverpod/Drift-driven. Navigation changes must not introduce live-network-driven Home state or duplicate habit mutation paths. Habit creation should continue through `HabitFormSheet` or a deliberate replacement with the same Drift/sync behavior. Social and Profile may continue to use their existing providers, but the user should not have to remember hidden header buttons for core app areas.

**Implementation scope:**
- `lib/main.dart`: replace direct `HomeScreen` authentication target with an app shell only if it keeps `_AppGate` simple and preserves auth gating.
- Main navigation shell: add a small Flutter widget such as `AppShell` or `MainNavigationShell` with stable destinations for Home, Social, Profile, and Settings, plus an obvious create-habit action.
- `lib/screens/home_screen.dart`: keep daily habits and today's action primary. Remove duplicate or hidden navigation affordances once the shell owns navigation. Preserve empty-state habit creation and suggested presets only where they help the first-run daily flow.
- `lib/screens/profile_screen.dart`: keep user identity, progress/history, achievements, calendar subscription, and habit management; move sign-out, email/cloud activation, avatar/account editing, notification preferences, and future durable preferences to Settings where appropriate.
- `lib/screens/social/social_hub_screen.dart`: preserve friends, requests, leaderboard, find friends, and inbox; reduce nested navigation conflicts if the shell gives Social a top-level destination.
- Settings screen: add the smallest useful `SettingsScreen` if one does not exist, covering account, email/cloud recovery status, sign out, notification/preferences entry points, accessibility/language placeholders, and profile-picture/account edit entry points without pretending unbuilt settings are functional.
- Habit creation: decide whether creation stays as `HabitFormSheet` launched from a floating/center action or becomes a focused create page. Reuse existing creation logic and accepted-friend partner picker either way.
- Accessibility: ensure the shell destinations, create action, and settings groups have Semantics labels and large enough tap targets.
- Tests/smoke: add focused widget tests or documented smoke checks for authenticated navigation, main destinations, create action, sign-out route, and no loss of existing Social/Profile access.

**Scalability considerations:** A shell reduces navigation complexity as features grow, but it can also increase rebuilds if every destination watches broad providers. Keep each destination's provider watches local to that destination. Preserve lazy screen construction where possible so charts, social requests, and home habit streams do not all rebuild at once.

**Future split guidance:** A full design-system pass, desktop/tablet adaptive navigation, notification preference implementation, language/accessibility settings implementation, profile editing redesign, and a dedicated create-habit page should become separate tasks if the shell exposes larger product decisions. This task should settle ownership and navigation first.

**Edge cases:** Logged-out state, seed-user twin harness startup, Android back button from shell destinations, deep pushes to friend profile or habit form, unsaved habit form state, switching tabs while sync updates local Drift, small Android screens, web browser back button, settings controls for features not implemented yet, sign out from nested screens, and duplicated Profile/Social routes after introducing shell navigation.

**Acceptance criteria:**
- The app has a documented screen ownership model for Home, Social, Profile, Settings, and habit creation.
- Authenticated users can reach Home, Social, Profile, and Settings through clear top-level navigation or a deliberately documented equivalent.
- Creating a habit remains no more than one primary action away from Home and reuses the existing offline-first creation/sync path.
- Home stays focused on today's habits and does not become a generic dashboard.
- Profile no longer owns durable account/settings controls that belong in Settings, unless the task documents why a control intentionally remains there.
- Social Hub remains reachable and its internal tabs do not conflict with the new top-level navigation.
- Settings exposes only real or explicitly placeholder-safe controls; it must not create dead-end fake settings.
- Android back behavior and web/mobile layout do not trap the user or overflow on common viewports.
- Focused tests or documented smoke checks cover top-level navigation, create-habit launch, Social/Profile access, Settings access, and sign out.
- `03_UI_UX_and_Animations.md`, `02_Offline_Architecture.md`, `04_Social_and_Analytics.md`, and `08_Testing.md` are verified and updated if navigation, screen ownership, or smoke procedures change.

**Dependencies:** `03_UI_UX_and_Animations.md`, `02_Offline_Architecture.md`, `04_Social_and_Analytics.md`, `08_Testing.md`, `Task_Idea.md`

**Completion notes:** [Placeholder for completion notes, touched files, behavior verified, and completion timestamp]
