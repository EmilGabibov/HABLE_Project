<!-- AI AGENT OPERATING CONTRACT — See Task_ai_agent_contract.md for full rules. This file hosts the compact completed-task index and the active engineered queue. -->

## Completed Tasks

- 2026-07-11 15:32 CEST: [Build Notification Center And Local Reminder MVP](Task2_Archived.md#build-notification-center-and-local-reminder-mvp)

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

### [X] Wire Friend Requests Through Social Hub And Twin-Harness Verification

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

<a id="complete-cross-app-habit-lifecycle-sync-and-twin-harness-verification"></a>
### [X] Complete Cross-App Habit Lifecycle Sync And Twin-Harness Verification

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

<a id="lock-hable-to-three-tab-ia-with-nested-profile-settings"></a>
### [ ] Lock Hable To Three-Tab IA With Nested Profile Settings

**Raw source:** Refined Core Information Architecture & UX Strategy: implement a highly focused 3-tab navigation shell for Hable with Home, Social, and Profile as the primary destinations. Home should stay dedicated to today's active habits and immediate progress, with a persistent FAB as the main habit-creation entry point. Social should own friends, partnered habits, mutual obligations, nudges/activity history, and friend-profile drilldown. Profile should own identity, long-term history, all-habit management, progress charts, and a clear gear entry point to nested Settings. Settings should handle durable account/system configuration including authenticated email, name, username, avatar customization, notification preferences, and future accessibility/language foundations. Habit creation should launch from the Home FAB as a focused onboarding-style flow with partner selection and custom emoji options. Minimize clutter, keep daily use lightweight, and avoid turning the app into an overwhelming dashboard. Raw source: `Task_Idea.md` "Hable: Core Information Architecture & UX Strategy".

**Issue:** The previous IA task identifies the navigation problem, but it still leaves a key product choice open by allowing Settings to be either a top-level destination or an equivalent surface. The refined strategy makes that decision explicit: authenticated Hable should use exactly three primary destinations - Home, Social, and Profile - while Settings is nested under Profile. Current code still routes `_AppGate` directly to `HomeScreen`; Home owns header buttons for Social, Add Habit, and Profile; Profile owns sign-out, avatar, email activation, charts, history, calendar, and habit management; and there is no dedicated Settings screen. The result works, but it does not yet match the intended lightweight daily ritual IA.

**Ponytail triage:**
- *Should exist:* Yes, because it resolves the ambiguity in the older IA task and prevents implementing a four-tab shell that contradicts the refined plan.
- *Smallest safe scope:* Add a three-tab shell for Home, Social, and Profile; make habit creation a prominent Home FAB using the existing `HabitFormSheet`; add a nested Settings route from Profile; move only durable account/system controls that already exist or can be represented safely.
- *Skipped scope:* Full visual redesign, new design system, new backend features, OS notifications, image upload backend work, notification preference implementation, language/accessibility implementation, desktop/tablet adaptive navigation, and a new custom habit-creation engine.
- *Boundaries:* Do not duplicate habit creation logic, do not make Settings a fourth tab, do not move social data into Home, and do not let live network responses directly drive Home state.

**Action:** Implement the refined IA as a focused navigation and ownership refactor. Replace Home's header-button navigation with an authenticated three-tab app shell, keep Home as the daily action surface, route habit creation through a Home FAB, keep Social as the multiplayer destination, keep Profile as identity/history/management, and add nested Settings behind a gear in Profile for durable account/system controls.

**Hable perspective:** Hable is offline-first and Riverpod/Drift-driven. The shell must not introduce a parallel state model or direct network-driven dashboard. `HomeScreen`, `SocialHubScreen`, `ProfileScreen`, and `HabitFormSheet` should keep their existing providers and local-first behavior, but their responsibilities should become clearer. This task supersedes the ambiguous parts of `Rework Daily Navigation And Screen Information Architecture`; the implementer should prefer the three-tab decision here when the two tasks conflict.

**Implementation scope:**
- App shell: add a small authenticated navigation shell, likely `MainNavigationShell`, and have `_AppGate` route authenticated users to it instead of directly to `HomeScreen`.
- Home: remove Social/Profile header navigation buttons after the shell owns them; expose habit creation as a persistent FAB and keep empty-state creation wired to `HabitFormSheet.show`.
- Social: keep `SocialHubScreen` as the Social tab and preserve its internal tabs for friends, requests, leaderboard, find friends, inbox, and social activity.
- Profile: keep identity, history, progression, charts, calendar, all-habit management, and friend-profile drilldown behavior; add a gear entry point to nested Settings.
- Settings: add the smallest real `SettingsScreen` needed for sign out, email/cloud activation, avatar/account access, and safe placeholders for notifications, accessibility, and language.
- State and sync: keep Riverpod watches scoped inside each destination and preserve Drift-backed reads; do not add new tables or backend endpoints for navigation alone.
- Accessibility: add Semantics labels for tab destinations, Home FAB, Profile settings gear, and settings sections; preserve large tap targets on small Android screens.
- Tests/smoke: add focused widget tests or documented smoke checks for authenticated shell routing, three tab destinations, Home FAB creation launch, Profile gear to Settings, sign out, Android back behavior, and no loss of Social/Profile access.

**Scalability considerations:** The shell should not cause every destination to rebuild together. Keep provider watches inside destination widgets and preserve lazy construction where practical so Home habit streams, Social network-backed providers, and Profile charts do not all execute on every tab switch.

**Future split guidance:** If implementation exposes larger needs, append separate raw tasks for notification preferences, accessibility/language settings, uploaded profile-picture storage, desktop/tablet adaptive navigation, and a full habit-creation redesign. Do not expand this task into those features.

**Edge cases:** Logged-out app startup, seed-user twin harness startup, switching tabs while `/api/sync/daily` updates Drift, Android back button from each tab and nested Settings, returning from Settings after sign out, Home FAB while a habit sheet is already open, unsaved habit form state when switching tabs, Social Hub's internal tab controller inside the shell, friend profile pushes from Social or partner rows, small screens with keyboard open, web browser back behavior, and placeholder settings that look interactive before they are implemented.

**Acceptance criteria:**
- Authenticated users land in a three-tab shell with exactly Home, Social, and Profile as primary destinations.
- Settings is nested under Profile behind a clear gear entry point, not exposed as a fourth primary tab.
- Home remains focused on today's active habits and immediate progress.
- Habit creation is available from a persistent Home FAB and still uses the existing offline-first `HabitFormSheet` creation path.
- Home no longer relies on header buttons for Social/Profile navigation once the shell owns top-level navigation.
- Social keeps friends, partnered habits, requests, leaderboard, search, inbox/activity, and friend drilldown reachable.
- Profile keeps identity, history/progress charts, achievements, calendar, and habit management while moving durable account/system actions to Settings where appropriate.
- Settings exposes only real controls or clearly safe placeholders; sign out and profile activation continue to work.
- Navigation does not create duplicate sync paths, duplicate habit mutation paths, or direct network-driven Home reads.
- Focused tests or smoke notes cover the shell, all three tabs, Home FAB, Settings route, sign out, and Android back behavior.
- `03_UI_UX_and_Animations.md`, `02_Offline_Architecture.md`, `04_Social_and_Analytics.md`, and `08_Testing.md` are verified and updated if navigation, screen ownership, or smoke procedures change.

**Dependencies:** `03_UI_UX_and_Animations.md`, `02_Offline_Architecture.md`, `04_Social_and_Analytics.md`, `08_Testing.md`, `Task_Idea.md`

**Completion notes:** [Placeholder for completion notes, touched files, behavior verified, and completion timestamp]
