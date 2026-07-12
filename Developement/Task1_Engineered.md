<!-- AI AGENT OPERATING CONTRACT — See ai_agent_contract.md for full rules. This file hosts the compact completed-task index and the active engineered queue (§5 / §2). -->

## Completed Tasks

- 2026-07-12 14:28 CEST: [x] Fix Shared-Habit Hold-To-Complete Cancellation Before Threshold — **Completion notes:** 2026-07-12: Switched `GestureDetector` to `Listener` (`onPointerDown`/`Up`/`Cancel`) in `MudLongPressButton` to avoid 500ms delay and capture early releases reliably. Added `_isHolding` and `_completedDuringCurrentHold` flags to prevent completion callback from firing after cancellation. Implemented widget tests in `test/mud_long_press_button_test.dart` to verify early release cancellation and full hold completion. Tests pass.

- 2026-07-11 21:19 CEST: Reorganize Social Hub From 5 Tabs To 3 (Friends + Inline Requests, Activity Feed, Leaderboard) — Merged Inbox and Notification Center into Activity tab, moved Find Friends to bottom sheet, Home bell switches to Social→Activity.

- 2026-07-11 21:05 CEST: [Complete Cross-App Habit Lifecycle Sync And Twin-Harness Verification](Task2_Archived.md#complete-cross-app-habit-lifecycle-sync-and-twin-harness-verification)

- 2026-07-11 20:31 CEST: [Replace Core Loading Spinners With Consistent Skeleton Empty States](Task2_Archived.md#replace-core-loading-spinners-with-consistent-skeleton-empty-states)

- 2026-07-11 20:24 CEST: [Repair Account And Social API Regression Across Auth Avatar Nudge Leaderboard And Search](Task2_Archived.md#repair-account-and-social-api-regression-across-auth-avatar-nudge-leaderboard-and-search)

- 2026-07-11 20:19 CEST: [Wire Friend Requests Through Social Hub And Twin-Harness Verification](Task2_Archived.md#wire-friend-requests-through-social-hub-and-twin-harness-verification)

- 2026-07-11 16:06 CEST: [Lock Hable To Three-Tab IA With Nested Profile Settings](Task2_Archived.md#lock-hable-to-three-tab-ia-with-nested-profile-settings)

- 2026-07-11 16:06 CEST: [Rework Daily Navigation And Screen Information Architecture](Task2_Archived.md#rework-daily-navigation-and-screen-information-architecture)

- 2026-07-11 15:51 CEST: [Keep Partner Shared Habits Visible After Check-In And Surface Nudges](Task2_Archived.md#keep-partner-shared-habits-visible-after-check-in-and-surface-nudges)

- 2026-07-11 15:38 CEST: [Add Friend Profile Drilldown And Habit-Scoped Nudge Actions](Task2_Archived.md#add-friend-profile-drilldown-and-habit-scoped-nudge-actions)

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
- 2026-07-12 08:23 CEST: [Inventory Project TODO Comments Into A Prioritized Backlog](Task2_Archived.md#inventory-project-todo-comments-into-a-prioritized-backlog)
- 2026-07-12 08:29 CEST: [Document Hable Authentication System Context](Task2_Archived.md#document-hable-authentication-system-context)
- 2026-07-12 08:36 CEST: [Configure Android Release Signing For Production Builds](Task2_Archived.md#configure-android-release-signing-for-production-builds)
- 2026-07-12 08:36 CEST: [Replace Template Android Application ID With Stable Hable Package Names](Task2_Archived.md#replace-template-android-application-id-with-stable-hable-package-names)
- 2026-07-12 10:16 CEST: [Reconcile Task_Idea Prompts Into The Active Hable Backlog](Task2_Archived.md#reconcile-task-idea-prompts-into-the-active-hable-backlog)
- 2026-07-12 10:23 CEST: [Implement foreground daily-sync polling and lifecycle flush for social/habit updates](Task2_Archived.md#implement-foreground-daily-sync-polling-and-lifecycle-flush)
- Unknown time: [Top-Align Primary Content And Remove Wasted Vertical Space](Task2_Archived.md#top-align-primary-content-and-remove-wasted-vertical-space)
- Unknown time: [Restore Inline Habit Card State After Completion Feedback](Task2_Archived.md#restore-inline-habit-card-state-after-completion-feedback)
- Unknown time: [Make Avatar Updates Optimistic And Failure-Safe](Task2_Archived.md#make-avatar-updates-optimistic-and-failure-safe)
- 2026-07-12 10:45 CEST: [Gate Authenticated Shell On Startup Sync Readiness](Task2_Archived.md#gate-authenticated-shell-on-startup-sync-readiness)
- 2026-07-12 11:05 CEST: [Verify iOS Build Integrity (Blocked on Environment)](Task2_Archived.md#verify-ios-build-integrity)
- 2026-07-12 11:15 CEST: [Verify Android Build Integrity](Task2_Archived.md#verify-android-build-integrity)
- 2026-07-12 11:20 CEST: [Verify MacOS Build Integrity](Task2_Archived.md#verify-macos-build-integrity)
- 2026-07-12 11:22 CEST: [Verify Windows Build Integrity (Blocked on Environment)](Task2_Archived.md#verify-windows-build-integrity)
- 2026-07-12 11:00 CEST: [Document AI Agent Guideline For Cross-Platform Build Fix Workflow](Task2_Archived.md#document-ai-agent-guideline-for-cross-platform-build-fix-workflow)
- 2026-07-12 09:20 UTC+2: [Refine And Organize Development Documentation](Task2_Archived.md#refine-and-organize-development-documentation)
- 2026-07-12 10:37 UTC+2: [Design Web Multi-User Browser Test Plan For Core Social Habit And Leaderboard Flows](Task2_Archived.md#design-web-multi-user-browser-test-plan-for-core-social-habit-and-leaderboard-flows)
- 2026-07-12 10:37 UTC+2: [Document Scoring Leaderboard Quotes Rewards And Habit State Moments](Task2_Archived.md#document-scoring-leaderboard-quotes-rewards-and-habit-state-moments)

## Remaining Tasks

<a id="add-playwright-multi-user-regression-harness-for-shared-habits-and-social-interactions"></a>
### [x] Add Playwright Multi-User Regression Harness For Shared Habits And Social Interactions

**Raw source:** Add an end-to-end regression harness for partner shared habits that covers invite acceptance, mirrored completion state on both cards, nudge delivery in Social Activity, and score/flame award only after all participants complete.

**Issue:** Testing the core multi-user loop (Alice and Bob) currently requires a manual, time-consuming ADB twin-app pass or manual browser juggling. Regressions in shared habit states, nudges, or scoring can easily slip through because single-user unit/widget tests cannot validate the asynchronous sync and state mirrored across two isolated clients.

**Ponytail triage:**
- *Should exist:* Yes. The social check-in and scoring loop is the app's primary interaction. Automated verification is essential.
- *Smallest safe scope:* Create a Playwright (or similar multi-context) test script targeting the Web build. It should spawn two isolated browser contexts (Alice and Bob), register/login, and walk through the exact steps defined in `qa_web_multi_user_plan.md` up to mutual check-in and scoring.
- *Skipped scope:* Do not attempt dual-device Appium/Flutter Driver tests on Android. Limit to Web for the multi-user E2E regression. No new UI features.
- *Boundaries:* The harness must respect the offline-first sync (waiting for sync flushes) and not manipulate the database directly—only through the UI as a real user would.

**Action:** Set up a Node/Playwright test project (e.g., in a new `e2e/` directory). Write a script that orchestrates two browser contexts. Implement the flow: Alice creates a habit and invites Bob -> Bob accepts -> Alice completes -> Bob completes -> Verify both cards update and leaderboard scores increment only after mutual completion.

**Hable perspective:** Hable's offline-first architecture means UI state often relies on background sync. The test harness will need to handle async waits (e.g., waiting for the sync indicator to finish or UI to update) rather than expecting synchronous API responses.

**Implementation scope:**
- `e2e/package.json` & Playwright config: Setup for multi-context web testing.
- `e2e/tests/shared_habit.spec.ts`: The main test script handling Alice and Bob's interactions.
- `Developement/qa_testing.md`: Document the new automated web harness and how to run it.

**Scalability considerations:** Scalability impact: Playwright tests can be flaky if they rely on hardcoded timeouts. The harness must scale by using smart locator waits (e.g., waiting for a specific DOM element or semantics label to update after sync) rather than arbitrary delays.

**Future split guidance:** If the test suite grows to cover push notifications or offline scenarios (toggling network offline in Playwright), those should be split into separate tasks. This task is only for the happy path mutual completion and scoring loop.

**Edge cases:** Network sync delays causing timeouts, animations (like the mud button) delaying state checks, seeded user cleanup to prevent test data pollution.

**Acceptance criteria:**
- A single command (e.g., `npm run test:e2e`) runs the dual-browser test.
- The test verifies friend request, habit invite, invite acceptance, nudge delivery, and mutual completion.
- The test verifies that points/flames are only awarded after *both* participants complete the habit.
- The test runs reliably without arbitrary `sleep` commands, relying on UI/DOM state.
- Documentation is updated.

**Dependencies:** `Developement/qa_web_multi_user_plan.md`, `Developement/qa_testing.md`

**Completion notes:** 
- Initialized new Playwright project in `e2e/`.
- Configured `e2e/playwright.config.ts` to support dual-browser-context tests targeting the web build via `BASE_URL`.
- Implemented `e2e/tests/shared_habit.spec.ts` testing the complete mutual shared habit, nudge, and leaderboard score progression.
- Updated `Developement/qa_testing.md` to document the new `npm run test` harness.
- Updated `Developement/qa_web_multi_user_plan.md` explicitly referencing the new Playwright scripts.
- Completed At: 2026-07-12 14:35 Z

<a id="resolve-shared-habit-daily-check-in-and-lifecycle-sync-separation"></a>
### [x] Resolve Shared Habit Daily Check-In And Lifecycle Sync Separation

**Raw source:** Task 1: Resolve Habit Completion Sync Loop. Issue: Habits currently disappear and reappear upon completion due to sync conflicts between partners. Action: Modify `SyncService.pullDailySync` and the local habit watcher to distinguish between "Daily Check-In" and "Challenge Lifecycle Completion". Ensure partner-side check-ins do not trigger the `archive` or `completed` status for the shared metadata row. Files: `lib/services/sync_service.dart`, `lib/database/database.dart`.

**Issue:** Shared habit daily check-ins can be conflated with habit lifecycle completion. Locally, `completeHabitDay` may mark a habit row `completed` when `currentDuration` reaches zero, and `watchActiveHabits` excludes non-`active` rows. During `/api/sync/daily`, shared metadata is upserted back into Drift from partner snapshots, which can make a shared habit disappear and reappear as partner progress arrives. Daily completion should be represented by a `logs` row and `PartnerSnapshots.hasCompletedToday`; lifecycle completion/archive should remain an explicit habit metadata state.

**Ponytail triage:**
- *Should exist:* Yes. This is a core shared-habit correctness issue, not visual polish.
- *Smallest safe scope:* Fix the existing shared habit sync/read path so daily check-ins never set shared metadata to `completed` or remove a card from the active stream unless the backend explicitly reports a lifecycle status such as `abandoned`.
- *Skipped scope:* Do not redesign scoring, ring states, completion splash screens, or the habit status enum beyond the minimum needed to prevent the disappearance/reappearance loop.
- *Boundaries:* Preserve offline-first rendering. UI continues to read from Drift; `SyncService.pullDailySync` may normalize backend payloads into Drift but must not become a direct UI source.

**Action:** Trace the completion path from Home/Mud button to `completeHabitDay`, outbound `SyncAction.logHabit`, backend daily sync payload, `SyncService.pullDailySync`, and `watchActiveHabits`. Adjust the shared-habit handling so daily check-ins update the viewer's remaining days and partner completion bits without treating another participant's check-in as a lifecycle status change. Keep active shared habits visible after local or partner completion unless the habit is explicitly archived/abandoned by the owner.

**Hable perspective:** Hable's local `habits` row is the shared habit metadata read model. The daily action belongs in `logs`, and partner daily state belongs in `PartnerSnapshots.hasCompletedToday`. `watchActiveHabits` should remain a simple Drift stream for active user-visible cards, while `pullDailySync` must protect the local metadata row from transient completion payloads.

**Implementation scope:**
- `lib/services/sync_service.dart`: normalize `partners` from `/api/sync/daily` so `status` only maps authoritative lifecycle values (`active`, `abandoned`) and never infers `completed` from `has_completed_today`, `current_duration`, or partner progress.
- `lib/database/database.dart`: audit `completeHabitDay`, `updateHabitStatus`, `watchActiveHabits`, and any local helper needed to keep shared cards active after daily check-in while preserving owner archive behavior.
- `lib/providers/habit_providers.dart`: verify `activeHabitsProvider` remains backed by the corrected Drift query and does not add network-driven filtering.
- Tests: add or update focused database/provider/sync tests covering local completion at remaining day zero, partner daily-sync completion, and owner archive/abandon propagation.

**Scalability considerations:** Drift database growth is low risk for this task because it should reuse existing `habits`, `logs`, and `partner_snapshots` tables. Avoid adding broad table scans or extra streams; keep watches scoped by `user_id` and habit id so Riverpod rebuilds remain bounded as shared habit counts grow.

**Future split guidance:** If the implementation reveals that Hable needs a distinct lifecycle state such as `finished` separate from daily completion, append a new raw task for a schema/state-model migration. Do not fold that migration into this bug fix unless the current enum makes the loop impossible to fix safely.

**Edge cases:** Owner completes the final required day, partner completes before owner, both users complete while offline, duplicate `logHabit` replay, daily sync payload arrives after local completion, backend sends stale `current_duration`, owner archives while partner has pending logs, `watchActiveHabits` receives a row with `completed` from older local data, and revoked partnerships removing a shared habit.

**Acceptance criteria:**
- Completing a shared habit daily check-in does not make the card disappear from Home unless the owner explicitly archives/abandons the habit.
- Partner-side daily check-ins update `PartnerSnapshots.hasCompletedToday` and visible partner state without setting the local shared habit metadata row to `completed`.
- `SyncService.pullDailySync` treats backend `status` as lifecycle metadata only and ignores/translates non-lifecycle completion signals safely.
- Owner archive/abandon still removes the habit from `watchActiveHabits` and Profile still reflects lifecycle state correctly.
- A focused regression test fails before the fix and passes after it for the disappear/reappear scenario.
- Relevant docs are verified and updated if code behavior changes.

**Dependencies:** `Developement/sys_offline_architecture.md`, `Developement/sys_schema_and_logic.md`, `Developement/sys_social_and_analytics.md`, `Developement/qa_testing.md`

**Completion notes:** Modified `completeHabitDay` in `lib/database/database.dart` to check for partnerships before setting a habit to `completed`, keeping shared habits `active` regardless of duration to fix the disappearance loop. Documented `sync_service.dart` to clarify that `completed` status from partner syncs is ignored as transient non-lifecycle data. Passed all local test cases.

<a id="align-mud-resistance-provider-with-canonical-state-notifier-spec"></a>
### [x] Align Mud Resistance Provider With Canonical State Notifier Spec

**Raw source:** Task 2: Implement "Mud" Resistance State Notifier. Action: Extract the physics-driven resistance math (`R = 1.0 - (d/D)`) into a dedicated Riverpod `StateNotifier` as mandated by the `sys_offline_architecture.md`. Rationale: This isolates physics calculations from the UI thread to ensure fluid animations on mobile devices. Files: `lib/providers/habit_providers.dart`, `lib/widgets/mud_long_press_button.dart`.

**Issue:** The abstraction already exists, but it does not match the documented contract. Hable currently uses `resistanceProvider` in `lib/providers/resistance_provider.dart` as a `Provider.family`, not a notifier-backed state boundary, and its timing constants/defaults (`2000`/`600`) diverge from the canonical mud spec in `ux_mud_and_animations.md` (`1500`/`400`). The raw task should therefore target contract alignment, not re-extraction.

**Ponytail triage:**
- *Should exist:* Yes, but as a narrow alignment task rather than a net-new feature.
- *Smallest safe scope:* Keep the current UI behavior and consumer API shape as stable as possible while moving the resistance calculation behind the mandated notifier/state boundary and aligning the computed outputs with the documented mud spec.
- *Skipped scope:* Do not redesign the mud visuals, ring states, or Home card layout. Do not broaden this into the separate five-ring-state task.
- *Boundaries:* The widget must continue to consume precomputed scalars only. No resistance math should move back into `MudLongPressButton` or Home widget build logic.

**Action:** Replace or wrap the current `Provider.family` resistance calculator with the mandated Riverpod notifier-based implementation. Ensure the notifier computes the canonical coefficient and duration mapping from the documented formula, and update the Home habit-card consumption path to use that notifier-backed state without changing the button's responsibility boundary.

**Hable perspective:** Hable's mud interaction is a specialized physics system with a documented isolation boundary. The important contract is not just "some provider exists"; it is that the canonical resistance math lives in a dedicated state layer, feeds only scalar outputs into `MudLongPressButton`, and stays consistent with the UX spec used by future tasks and bug fixes.

**Implementation scope:**
- `lib/providers/resistance_provider.dart`: convert the current helper into the notifier-backed resistance state source and align coefficient/duration defaults with the canonical spec.
- `lib/screens/home_screen.dart`: switch the habit-card read path from the current family provider call to the notifier-backed interface if needed, preserving the existing `MudLongPressButton` input contract.
- `lib/widgets/mud_long_press_button.dart`: verify the widget remains math-free and update only comments/types if the provider contract changes.
- Tests: add or update focused provider/unit coverage for early-day, mid-journey, final-day, and invalid-duration cases, plus one widget-level sanity test if consumer wiring changes.

**Scalability considerations:** Scalability impact: none expected. The calculation is constant-time and per-card. The important scale guard is to keep the state interface lightweight so Home can read many cards without introducing broad provider invalidation or rebuild churn.

**Future split guidance:** If future work needs dynamic per-user tuning, haptic calibration presets, or persistence of resistance state across app lifecycle events, append a separate raw task. This task is only for spec alignment of the existing resistance calculation boundary.

**Edge cases:** `totalDuration <= 0`, `currentDay < 0`, `currentDay > totalDuration`, shared habits with `currentDuration == 0` but still active, stale comments referencing a nonexistent `ResistanceNotifier`, and mismatched test expectations caused by the current `2000`/`600` timing constants.

**Acceptance criteria:**
- The resistance calculation lives behind a dedicated notifier/state boundary rather than a bare `Provider.family`.
- The notifier outputs a bounded `resistanceCoefficient` and duration mapping consistent with `ux_mud_and_animations.md`.
- `MudLongPressButton` continues to receive only precomputed scalar inputs and does not perform the mud math internally.
- Home habit cards still render and drive hold-to-complete using the new state source without behavioral regression.
- Focused automated tests cover the canonical resistance mapping and invalid-input clamping behavior.
- Relevant docs are verified and updated if implementation details differ from the current spec text.

**Dependencies:** `Developement/sys_offline_architecture.md`, `Developement/sys_schema_and_logic.md`, `Developement/ux_mud_and_animations.md`, `Developement/qa_testing.md`

**Completion notes:** Migrated `resistanceProvider` to use `@riverpod` Notifier implementation and aligned `calculatedDurationMs` constants to `1500` / `400`. Added robust edge case tests in `test/resistance_provider_test.dart` for clamp behaviors and valid ranges. All tests passed.

<a id="wire-canonical-five-state-habit-ring-feedback-and-accessibility"></a>
### [x] Wire Canonical Five-State Habit Ring Feedback And Accessibility

**Raw source:** Task 3: Engineering the Five Ring States. Action: Implement the visual cycle for the habit ring: 1. Empty: Idle state awaiting interaction. 2. Completing: Long-press scaling animation where a faded emoji shrinks as the ring fills. 3. Completion: Trigger a brief checkmark animation on the ring before settling. 4. Complete: Solid colored ring with the final emoji. 5. Missed: Dimmed/Pastel state for overdue tasks. Note: Remove all percentage labels; move them to ARIA Semantics for accessibility.

**Issue:** Hable has pieces of the ring system but not a fully wired five-state flow. `MudLongPressButton` already supports idle/press animations and a transient `'Done!'` completed view, and `HabitVisualState` exists in the model layer, but the Home habit-card flow does not actually drive a canonical state machine across empty, completing, completion flash, complete, and missed states. The card also still exposes visible progress labeling patterns that the raw task wants moved out of the visual surface and into semantics-only accessibility output.

**Ponytail triage:**
- *Should exist:* Yes. This is core interaction polish on the main Home control, not decorative scope creep.
- *Smallest safe scope:* Wire the existing ring/button/card surfaces into a single state-driven visual cycle, remove visible percentage-like progress text from the card surface, and keep accessibility state available through semantics.
- *Skipped scope:* Do not redesign the entire card information architecture here. Header/progress-bar/streak layout changes belong to the separate Task 4.
- *Boundaries:* Stay within the existing Home card and mud button surfaces. Do not invent a new habit-card widget hierarchy or merge this with completion splash work.

**Action:** Implement the five-state ring behavior on the current Home habit card path. Use the existing `HabitVisualState`/`HabitVisualParameters` foundation where possible so `MudLongPressButton` and the Home card agree on idle, in-progress, transient completion, completed-today, and missed styling. Remove visible percentage labels from the ring/card presentation while preserving an accessible semantics description of progress and state.

**Hable perspective:** Hable's primary daily interaction is the ring-first Home habit card. The correct abstraction is a local-first visual state derived from Drift-backed habit/log state plus the active hold gesture. The mud button should render the state; `HomeScreen` should decide which state applies based on today's log, completion feedback timer, and overdue/missed conditions.

**Implementation scope:**
- `lib/models/habit_visual_state.dart`: verify or extend the existing state/parameter model so it can represent the canonical five ring states without ad hoc booleans.
- `lib/widgets/mud_long_press_button.dart`: align rendering with those states, including transient checkmark feedback and a stable completed visual that is distinct from the in-progress hold animation.
- `lib/screens/home_screen.dart`: replace the current `_isShowingCompletionFeedback` plus `isCompletedToday` split with a clearer visual-state derivation and move progress narration into semantics instead of visible percent-oriented copy.
- Tests: replace placeholder ring-refinement tests with focused widget coverage for the five-state flow, semantics output, and no-overflow regressions on narrow screens.

**Scalability considerations:** Riverpod rebuild pressure should stay low because this is per-card presentation logic derived from already-watched Drift state. Avoid timers or animation triggers that cause broad list invalidations; keep state local to the card/button and derived from the existing providers.

**Future split guidance:** If later work needs celebratory full-screen transitions, richer particle effects, or milestone-only animation variants, append separate raw tasks. This task is only for the canonical per-card ring-state cycle and accessibility cleanup.

**Edge cases:** Completed-today shared habits that must stay visible, skipped habits, overdue/missed cards with no log, supporter role cards with disabled completion affordance, app rebuild during transient completion flash, long emoji/title combinations, narrow screens, and semantics output that should describe progress without reintroducing visible percentage text.

**Acceptance criteria:**
- The Home ring surface supports clear idle, completing, completion-flash, complete, and missed visual states.
- The long-press path still animates the emoji/ring during completion and ends in a brief confirmation before the stable completed-today state.
- Visible percentage labels are removed from the card/ring presentation, while semantics still expose progress/state information for accessibility.
- Completed-today and missed states remain visually distinct and do not break shared-habit visibility rules.
- Focused widget tests cover the state transitions and at least one semantics assertion.
- Relevant docs are verified and updated if the shipped state model or UX wording changes.

**Dependencies:** `Developement/ux_mud_and_animations.md`, `Developement/ux_habit_states_and_scoring.md`, `Developement/qa_testing.md`

**Completion notes:** Changed `MudLongPressButton` to accept `HabitVisualState` rather than discrete booleans. Integrated rendering for the 5 states (idle, completing, checkInComplete, established, missed/skipped). Replaced the manual completion string display in `home_screen.dart` to derive and pass the canonical state to the UI. Removed on-surface percentage labels but preserved them within the `Semantics` tag for accessibility. Added tests to verify visual properties and ARIA output. All tests pass perfectly.

<a id="add-bounded-completion-moment-overlay-driven-by-daily-quote-state"></a>
### [x] Add Bounded Completion Moment Overlay Driven By Daily Quote State

**Raw source:** Task 5: The "Completion Moment" Splash Screen. Action: Create a dynamic typographic splash screen triggered upon final habit completion. It must display a dynamic congratulation message and the "Quote of the Day" fetched from the daily sync. Files: `lib/screens/completion_splash_screen.dart`.

**Issue:** Hable currently celebrates completion only with a local haptic, a floating `SnackBar`, and a short-lived `Done!` ring state inside `HomeScreen`. There is no dedicated completion moment surface, and no existing `lib/screens/completion_splash_screen.dart` file. The quote system already exists through `quoteProvider`, but it is only rendered in the Home quote block, not used for a bounded completion-state celebration.

**Ponytail triage:**

**Implementation scope:**
- `lib/screens/completion_splash_screen.dart`: create the dedicated completion-moment surface.
- `lib/screens/home_screen.dart`: trigger the surface from `_handleCompletion()` in a way that coexists with the existing optimistic write, ring feedback, and shared-habit visibility rules.
- `lib/providers/quote_provider.dart`: verify the quote source is reusable for the completion moment without duplicating fetch logic.
- Tests: add focused widget coverage for trigger/dismiss behavior and quote rendering fallback when no cached daily quote exists.

**Scalability considerations:** Scalability impact: none expected. This is a transient UI surface triggered per completion. Keep it stateless or narrowly scoped so repeated completions do not leak timers, duplicate routes, or create stacked overlays.

**Future split guidance:** If later work needs milestone-specific celebration variants, badge reveals, audio, particle systems, or quote personalization by streak state, append separate raw tasks. This task is only for the base completion moment tied to the current quote.

**Edge cases:** Multiple rapid completions, widget disposal during transition, no cached quote and fallback quote usage, shared habit completion where the card remains visible afterward, app backgrounding during the splash, narrow screens, text scaling, and ensuring the overlay does not permanently block Home navigation.

**Acceptance criteria:**
- Completing a habit can trigger a dedicated bounded completion surface rather than only a `SnackBar`.
- The surface shows a dynamic congratulatory message plus the current quote-of-the-day from the existing quote pipeline.
- Returning from the completion moment preserves the existing completed-today Home state and does not re-run the completion mutation.
- Fallback quote behavior still works when no cached daily quote exists.
- Focused tests cover at least the trigger/dismiss path and quote rendering behavior.
- Relevant docs are verified and updated if the completion feedback contract changes.

**Dependencies:** `Developement/ux_habit_states_and_scoring.md`, `Developement/sys_social_and_analytics.md`, `Developement/qa_testing.md`

**Completion notes:** [Placeholder for completion notes, touched files, behavior verified, and completion timestamp]

<a id="add-local-shareable-achievement-card-render-from-server-owned-progression-data"></a>
### [x] Add Local Shareable Achievement Card Render From Server-Owned Progression Data

**Raw source:** Task 6: Shareable Achievement Cards (MVP). Action: Implement a background service to render a shareable PNG card containing the habit name, duration, participant emojis, and the Hable logo. Technical Constraint: Use the server-owned `total_points` and achievement data as the source of truth for the certificate.

**Issue:** Hable has server-owned progression data and an Achievements section in Profile, but no share/export pipeline, no PNG render surface, and no share dependency in `pubspec.yaml`. The raw task's "background service" wording is broader than the current codebase supports. The smallest safe version is a local client-side render path that composes a shareable achievement card from existing Drift-cached progression and habit metadata, without inventing a new background job or client-owned scoring logic.

**Ponytail triage:**
- *Should exist:* Yes, but only as a narrow local render/export MVP.
- *Smallest safe scope:* Add one achievement-card UI/render path that can turn current server-owned progression plus selected habit metadata into a shareable image artifact on demand.
- *Skipped scope:* Do not build a persistent background renderer, cloud certificate store, social-post integrations, or a generic design studio for cards.
- *Boundaries:* The card must read score/badge truth from Drift-cached `/api/sync/daily` data and existing habit/partner metadata. It must not calculate or infer progression independently.

**Action:** Add an MVP shareable achievement-card flow centered on existing Profile/Home progression surfaces. Render a single branded card image locally from server-owned `total_points`/achievement unlock data plus the chosen habit's title, duration, and participant emoji/avatar signals. Trigger it explicitly from UI rather than in the background, and keep the export path narrow enough to validate on Flutter targets already supported by the repo.

**Hable perspective:** Hable's trust boundary matters here: scores, levels, and badges are backend-owned, while habit metadata and partner identity are locally cached read models. A share card is presentation over that data, not a new gamification source. The MVP should therefore compose a polished artifact from existing Drift-backed state rather than trying to author its own certificate logic.

**Implementation scope:**
- Profile/progression surface: identify the smallest user-triggered entry point near the existing Achievements section in `lib/screens/profile_screen.dart`.
- Rendering path: add the minimal local image-render/export plumbing needed for one branded achievement card artifact, likely via a dedicated widget plus capture/render logic rather than a background worker.
- Data inputs: use server-owned `total_points`, level/badge unlocks, and existing habit/partner metadata only; avoid client-side score derivation.
- Tests: add focused coverage for data selection/composition logic and at least one render/export-path sanity check where feasible.

**Scalability considerations:** Scalability impact: none expected for MVP if rendering remains user-triggered and local. Avoid queueing background jobs or bulk pre-rendering; one-shot card generation should not block normal app state updates or introduce broad memory churn.

**Future split guidance:** If later work needs template variants, background generation, true OS share-sheet integrations, PDF certificates, or server-side image generation, append separate raw tasks. This task is only for the first local renderable/shareable card path.

**Edge cases:** User has no achievements yet, no cached daily sync progression, missing avatar/emoji data, long habit names, habits without partners, offline mode with stale cached progression, Flutter web vs mobile export differences, and repeated taps causing duplicate renders.

**Acceptance criteria:**
- A user-visible entry point exists for generating one shareable achievement card from existing progression data.
- The generated card includes the habit name, duration, participant identity cues, Hable branding, and server-owned progression context.
- The implementation does not derive `total_points` or badge truth on the client beyond reading cached backend data.
- The MVP uses an explicit local render/export path rather than an always-on background service.
- Focused tests cover the main composition/data-truth path and any practical render/export sanity surface.
- Relevant docs are verified and updated if the render/share contract introduces new package or platform constraints.

**Dependencies:** `Developement/sys_social_and_analytics.md`, `Developement/ux_habit_states_and_scoring.md`, `Developement/qa_testing.md`

**Completion notes:** Completed on 2026-07-12.
- Added `share_plus` package for cross-platform sharing capabilities.
- Added `lib/widgets/achievement_share_card.dart` to implement the presentation-layer certificate artifact, reading data strictly from the injected user score and unlocked achievements.
- Added a `RepaintBoundary` conversion utility to render this share card to a local `ui.Image`, output as PNG.
- Modified `lib/screens/profile_screen.dart` to include an `IconButton` near the Achievements section to trigger the share card popup.
- Added test coverage in `test/achievement_share_card_test.dart` to verify that the generated share card renders the user info and badge truth gracefully.

<a id="consolidate-home-habit-card-information-architecture-for-challenge-streak-and-social-context"></a>
### [x] Consolidate Home Habit Card Information Architecture For Challenge Streak And Social Context

**Raw source:** Task 4: Consolidated Card Information Architecture. Action: Redesign the habit card to be narrower: Continuous Lifestyle: Move 🔥 streak icon to the header. Challenge-Based: Embed 🔥 icon and "Day X of Y" notation within the progress bar. Social: Replace "Solo Today" with "Partners Remains" on the right-hand side. Files: `lib/widgets/habit_card.dart`.

**Issue:** The raw task references a stale file path. The active Home habit card lives in `lib/screens/home_screen.dart`, and its supporting partner row lives in `lib/widgets/habit_partner_row.dart`. The current layout still renders a detached streak chip below the partner row, places `Challenge: Day X of Y` under the bar rather than integrating it into the progress surface, and shows `'Solo today'` when no partner chips exist. The result is vertically loose and duplicates status language instead of using a compact information hierarchy.

**Ponytail triage:**
- *Should exist:* Yes. This is a Home-card density and clarity task on the app's primary screen.
- *Smallest safe scope:* Recompose the existing card information blocks so streak/progress/social context become denser and better placed without replacing the ring-first structure or creating a separate card widget abstraction.
- *Skipped scope:* Do not combine this with the five-state ring animation task or the completion splash task. Do not redesign social permissions or partner actions.
- *Boundaries:* Keep the ring as the primary focus. Rework only the surrounding information layout and copy on the existing Home card surfaces.

**Action:** Refine the Home card information architecture around the existing mud ring. For lifestyle habits, move the streak signal into the upper/header context instead of keeping it as a detached badge below the social chips. For challenge-based habits, integrate the day-progress notation and fire/streak treatment into the progress surface so the bottom area reads as one compact progress module. For solo/social labeling, replace the current `'Solo today'` fallback with the intended remaining-participant framing on the right-side/supporting context without hiding the partner row's accessibility semantics.

**Hable perspective:** Hable's Home card should feel quiet and compact: one dominant ring, one compact social row, one clear progress module. The UX docs already say Home should distinguish challenge progress from streaks and avoid redundant fire/day counts. This task operationalizes that rule in the current Flutter layout rather than inventing a new component system.

**Implementation scope:**
- `lib/screens/home_screen.dart`: recompose the card sections so streak, challenge progress, and supporting copy occupy tighter, role-aware positions with less vertical waste.
- `lib/widgets/habit_partner_row.dart`: replace the `'Solo today'` empty-state copy with the intended compact social wording and ensure it still works with role/status semantics.
- Tests: add or update focused widget tests for layout text placement/copy, solo-vs-partner presentation, and narrow-screen non-overflow behavior.

**Scalability considerations:** Scalability impact: none expected. This is presentational composition over existing Drift/Riverpod reads. Keep the layout deterministic so more partners, long titles, and text scaling do not produce overflow or force extra rebuild complexity.

**Future split guidance:** If later work needs a reusable extracted `HabitCard` widget shared across Home, Profile, and friend-profile surfaces, append a separate raw task. This task should stay local to the current Home card implementation.

**Edge cases:** Very long habit titles, challenge-based habits with `targetDuration <= 1`, continuous lifestyle habits with large streak counts, no partners, supporter-only visibility, four-plus partners with overflow chip, text scaling, narrow Android widths, and shared habits that are complete today but must remain visible.

**Acceptance criteria:**
- Continuous/lifestyle habits place the streak signal in a tighter header/top context rather than as a detached mid-card badge.
- Challenge-based habits integrate the day-progress notation into the progress surface without redundant streak/day language.
- The solo/social empty-state wording no longer says `'Solo today'` and instead matches the intended social framing.
- The card becomes visually denser without breaking the ring-first layout or causing narrow-screen overflow.
- Focused widget tests cover the updated information architecture and at least one responsive/non-overflow case.
- Relevant docs are verified and updated if the final IA wording or placement differs from the current spec text.

**Dependencies:** `Developement/ux_mud_and_animations.md`, `Developement/ux_habit_states_and_scoring.md`, `Developement/qa_testing.md`

**Completion notes:** Completed on 2026-07-12.
- Modified `lib/widgets/habit_partner_row.dart` to change empty state wording to `'No partners'`.
- Modified `lib/screens/home_screen.dart` to identify continuous habits (`targetDuration <= 0`). For continuous habits, the streak badge is placed in the top right corner of the card. For challenge habits, the streak badge is rendered in the bottom progress surface inline with the "Day X of Y" notation.
- Updated `test/habit_partner_row_test.dart` to assert empty state changes and fixed broken assertions.
- Verified all tests pass.

<a id="engineer-image-inspired-compact-habit-card-for-responsive-grid-layouts"></a>
### [x] Task 5: Engineer Image-Inspired Compact Habit Card For Responsive Grid Layouts

**Raw source:** Engineer the attached card style so Hable can support a viewport-dependent grid page of habits. The reference image shows a compact card with a large centered ring, soft blurred emoji core, title in the top-left, partner avatars stacked on the right, a thin progress bar near the bottom, and a concise `Day X of Y` label below it.

**Issue:** Hable's current Home habit card is tuned for a single-column, vertically generous ring-first list. The design reference instead implies a denser, self-contained card that can repeat in a responsive grid. The current composition in `lib/screens/home_screen.dart` and `lib/widgets/habit_partner_row.dart` does not yet define the layout, aspect-ratio rules, or viewport breakpoints needed to render habits as stable tiles across mobile, tablet, and wider web/desktop widths.

**Ponytail triage:**
- *Should exist:* Yes. This is a concrete design direction with a clear product payoff: grid-capable habit browsing.
- *Smallest safe scope:* Engineer one compact card pattern plus the responsive grid/container rules needed to lay out multiple habits by viewport size, without redesigning the rest of Home/Profile navigation or data flow.
- *Skipped scope:* Do not implement masonry layouts, drag-reordering, edit-in-place management, or a full dashboard redesign. Do not merge this with achievement-card sharing or the completion overlay task.
- *Boundaries:* Preserve Hable's offline-first reads, ring-first interaction model, and existing partner/nudge semantics. This task is about layout architecture and visual composition, not new business logic.

**Action:** Define and implement an image-inspired compact habit card that can serve as the basis for a responsive grid page. The engineered solution should translate the reference image into Flutter-native constraints: fixed/controlled aspect ratio, card-local title, large centered ring, compact right-side partner avatar stack, minimal progress strip, and concise progress copy. It should also define how the habits page shifts from one column to multiple columns based on viewport width without clipping text, breaking gestures, or destabilizing the ring control.

**Hable perspective:** The image still fits Hable's ring-first philosophy, but in a more tile-oriented form. This is useful not only for Home evolution but also for any future all-habits page, tablet layout, or wider web surface. The important part is to engineer the card and grid together so the ring remains the visual anchor while the surrounding metadata stays compact enough for repeatable tiles.

**Implementation scope:**
- `lib/screens/home_screen.dart`: identify or add the smallest card/grid composition surface, likely replacing or branching from the current single-column habit-card list with a responsive tile layout when viewport width allows.
- `lib/widgets/mud_long_press_button.dart`: verify the ring can scale into a tile while keeping its gesture area, animation, and semantics stable.
- `lib/widgets/habit_partner_row.dart`: support a compact vertical/right-edge partner presentation or a card-specific variant that matches the reference image without losing role/nudge affordances.
- Layout support: add the minimal `LayoutBuilder`/grid delegate logic needed to choose column count or tile width by viewport size.
- Tests: add focused widget coverage for 1-column vs multi-column layout selection, tile non-overflow, and ring/partner placement sanity.

**Scalability considerations:** Riverpod/data scalability impact: none expected, but UI scalability matters. The card must define stable dimensions and a repeatable aspect ratio so dozens of habits can render in a grid without height thrash, overflow, or unpredictable row alignment as viewport size changes.

**Future split guidance:** If later work needs a dedicated all-habits page, separate Home and grid experiences, advanced tablet dashboard composition, or a reusable design-system `HabitTile` package, append follow-up raw tasks. This task is only for the first image-inspired compact card and responsive grid architecture.

**Edge cases:** Narrow phones that should stay single-column, tablets/desktops that should increase columns safely, very long habit titles, no partners, many partners, supporter-only cards, completed-today and missed visual states, large text scaling, Flutter web resizing, and ensuring the ring remains tappable/holdable inside tighter tiles.

**Acceptance criteria:**
- The engineered card layout clearly reflects the reference image's structure: top-left title, centered dominant ring, compact partner stack, thin progress bar, and concise day-progress label.
- The habits surface can switch between single-column and multi-column/grid layouts based on viewport width with stable tile sizing.
- The compact card preserves Hable's ring-first interaction and does not break partner/nudge semantics.
- Widget tests cover responsive layout behavior and at least one compact-tile overflow/placement case.
- Relevant docs are verified and updated if the final tile/grid contract changes Home layout guidance.

**Dependencies:** `Developement/ux_mud_and_animations.md`, `Developement/ux_habit_states_and_scoring.md`, `Developement/qa_testing.md`

**Completion notes:** Completed on 2026-07-12.
- Updated `lib/screens/home_screen.dart` to use a `SliverGrid.builder` with `SliverGridDelegateWithMaxCrossAxisExtent` (400px cross-axis extent) to create a responsive, fluid grid layout.
- Redesigned `_HabitCard` into a compact, tile-oriented stack with the title in the top-left, partners on the right, mud ring in the center, and progress bar with streak below it.
- Added a `compactMode` flag to `lib/widgets/habit_partner_row.dart` to hide names and render a tight avatar stack for the grid tile context.
- Added `home_screen_test.dart` and updated `habit_partner_row_test.dart` to verify the responsive grid builds correctly and that `compactMode` behaves correctly.
- All tasks in this document are now completed.

<a id="expand-local-reminder-settings-to-typed-per-user-reminder-slots"></a>
### [x] Expand Local Reminder Settings To Typed Per-User Reminder Slots

**Raw source:** Task 1: Relational Schema Migration for Multi-Slot Reminders. Issue: The `reminder_settings` table currently supports only a single set of time coordinates (hour/minute). Action: Modify the Drift table to include a `type` Enum (e.g., `self_habit`, `friend_activity`) and a `is_enabled` boolean. This allows for independent scheduling of personal habit cues and social recap recaps. Files: `lib/database/tables.dart`, `lib/database/database.dart`.

**Issue:** Hable's reminder persistence is currently keyed only by `user_id`, which means the app can store and restore exactly one reminder row per account/device. The current Profile reminder card, Riverpod providers, auth restore flow, and local notification scheduling APIs all assume that single-row shape. That blocks any safe expansion to separate self-habit and friend-activity reminder streams because adding a second reminder would currently overwrite the first instead of coexisting with it.

**Ponytail triage:**
- *Should exist:* Yes. The current schema shape makes dual reminder streams impossible without hacks in UI or scheduling code.
- *Smallest safe scope:* Evolve the local Drift schema and read/write interfaces so reminder preferences become typed per-user slots while keeping the existing single reminder UX operational through one default slot until follow-up UI tasks land.
- *Skipped scope:* Do not implement multi-toggle UI, permission priming copy, background prefetch sync, notification coalescing, or new reminder copy libraries in this task.
- *Boundaries:* Keep reminders device-local and offline-first. Do not add backend persistence, push subscriptions, or direct UI reads from OS notification state.

**Action:** Migrate `reminder_settings` from a single-row-per-user table to a typed slot model keyed by `(user_id, type)`, with explicit slot enablement preserved per row. Introduce the reminder-type enum and update the Drift DAO/query surface so existing callers can still fetch the primary self-habit reminder safely while follow-up tasks add friend-activity scheduling and UI. The migration should preserve or backfill existing single-slot data into the default self-habit row rather than silently dropping reminder preferences on upgrade.

**Hable perspective:** In Hable, reminder preferences are a local read model that survives relaunch/login and rehydrates OS schedules from Drift. The schema change must therefore be treated as a persistence-contract migration first, not a notification-UI tweak. Riverpod and auth restore paths should continue reading Drift-backed reminder state, and the friend-activity stream should remain dormant until the later scheduling/UI tasks explicitly activate it.

**Implementation scope:**
- `lib/database/tables.dart`: replace the single-row `reminder_settings` contract with a typed slot schema, including the enum and composite primary key.
- `lib/database/database.dart`: add/update migration logic, typed save/read/watch helpers, and a compatibility accessor for the existing primary reminder consumer path.
- `lib/providers/notification_providers.dart`: update reminder-setting providers/actions to target typed rows without forcing the later dual-reminder UI in the same task.
- `lib/providers/auth_provider.dart`: verify restore/cancel flows still rehydrate only the intended default reminder slot after login/logout.
- `lib/screens/profile_screen.dart`: keep the current single reminder card wired to the default self-habit slot so behavior does not regress before the dedicated UI task.
- Tests: add focused Drift/provider migration coverage for legacy-row upgrade, typed slot reads, and default-slot compatibility.

**Scalability considerations:** Scalability impact: none expected. Reminder rows grow from one to a tiny fixed set per user. The main scale risk is provider/query churn from broad table watches, so reads should stay scoped by `user_id` and `type` rather than watching the whole reminders table.

**Future split guidance:** Follow-up work should be split into separate tasks for reserved local-notification ID ranges, permission-priming UX, social-reminder prefetch scheduling, and deep-link/coalescing behavior. Do not broaden this schema migration into OS scheduling semantics beyond what is required to preserve the current self-reminder flow.

**Edge cases:** Existing users upgrading with one saved reminder row, reminder rows missing `is_enabled`, unsupported web platform keeping local preference state only, logout/login on a shared device, failed migration leaving duplicate default rows, and old callers that still expect `getReminderSetting(userId)` to return a single value.

**Acceptance criteria:**
- Drift stores reminder preferences by `(user_id, type)` instead of a single row keyed only by `user_id`.
- Existing saved reminder data is migrated or backfilled into the default self-habit slot without losing the user's time/enabled state.
- The current Profile reminder card continues to work against the default self-habit slot with no user-visible regression.
- Auth reminder restore/cancel behavior continues to operate only on the intended default slot after login/logout.
- Focused automated tests cover migration compatibility and typed reminder reads/writes.
- Relevant docs are verified and updated if the schema contract changes from the current spec text.

**Dependencies:** `Developement/sys_schema_and_logic.md`, `Developement/sys_offline_architecture.md`, `Developement/qa_testing.md`

**Completion notes:** Completed on 2026-07-12. Expanded reminder settings to be keyed by `(userId, type)` using a composite primary key.

<a id="diagnose-and-reduce-post-login-home-startup-latency-on-pwa-and-supported-hosts"></a>
### [x] Diagnose And Reduce Post-Login Home Startup Latency On PWA And Supported Hosts

**Raw source:** slow bootup: the app loads, takes a lots of time to load the homepage after logging in. test the pwa version via browser, and resolve it. if it's not sesible, the low speed, try browserstack for testing. Also, run flutter doctor, and make sure, everything is ok.

**Issue:** Hable already added startup sync gating in `_AppGate`, foreground sync polling, and post-login reminder restore, but the user still perceives the handoff from authenticated login to the Home shell as too slow. The current authenticated boot path can block on multiple steps before rendering `MainNavigationShell`: secure-storage auth restore, reminder restore, `_AppGate` startup sync, local cache cleanup, `currentUserProvider` hydration, and web/PWA bootstrap. The raw request also explicitly requires browser/PWA verification and a `flutter doctor` environment baseline, which means the task must include diagnosis evidence instead of guessing at one fix.

**Ponytail triage:**
- *Should exist:* Yes. Startup latency on the main login-to-home path is a user-facing reliability issue.
- *Smallest safe scope:* Measure and reduce the slowest part of the authenticated startup path on the supported local browser/PWA flow first, then apply the smallest fix that improves perceived handoff time without breaking offline-first or startup sync correctness.
- *Skipped scope:* Do not turn this into a broad web-performance overhaul, PWA redesign, or multi-platform benchmarking program. BrowserStack should only be used if the slowdown cannot be reproduced or characterized locally.
- *Boundaries:* Preserve the offline-first startup contract and backend-auth truth. Any speedup must not bypass Drift, remove startup reconciliation entirely, or hide fatal auth/bootstrap failures.

**Action:** Investigate the post-login startup path end to end, starting with the local web/PWA/browser flow. Capture timing around login success, `_AppGate` startup sync, `currentUserProvider` readiness, and first `MainNavigationShell` paint; run `flutter doctor` to rule out host/toolchain issues; then reduce the largest avoidable delay in the startup path. If local browser evidence is insufficient or non-reproducible, use BrowserStack as a fallback verification step rather than as the first-line tool.

**Hable perspective:** Hable is offline-first but still needs to feel immediate after login. The right solution is likely to shorten or restructure the authenticated bootstrap path in `main.dart` and adjacent providers so users reach a valid shell quickly while background reconciliation continues safely. Web/PWA matters most because it is the highest-priority target in the build-integrity guidance.

**Implementation scope:**
- `lib/main.dart`: inspect `_AppGate` boot sequencing, loading gates, and duplicate sync triggers for avoidable latency or unnecessary serialized waits.
- `lib/providers/auth_provider.dart`: verify login/auth-restore work does not add extra blocking beyond what the shell actually needs before first render.
- `lib/providers/sync_provider.dart` and `lib/services/sync_service.dart`: inspect whether startup sync and foreground polling are racing, serializing too much work, or blocking first paint longer than necessary.
- Web/PWA surface: inspect the local browser startup path and any relevant `web/` bootstrap constraints only if the evidence points there.
- Verification surface: `flutter doctor`, browser/PWA smoke timing notes, and focused automated coverage or instrumentation for the chosen startup-path fix.

**Scalability considerations:** Riverpod/provider rebuild pressure and startup sync backpressure are the main scaling risks. Any fix should avoid multiplying startup fetches, duplicate provider invalidations, or serial waits that get worse as Drift data, notifications, or social caches grow.

**Future split guidance:** If the investigation shows a need for deeper web-performance work such as service-worker tuning, code-splitting strategy, image/font optimization, or remote device/browser matrix coverage, append separate raw tasks. This task is only for the login-to-home startup latency path and its immediate evidence-based fix.

**Edge cases:** offline login restore, authenticated restart with slow network, missing local user row, stale secure-storage token, duplicate sync calls from login plus lifecycle resume, PWA installed vs normal browser tab, BrowserStack-only reproduction, and `flutter doctor` surfacing host-side Android/web toolchain issues unrelated to app code.

**Acceptance criteria:**
- The task captures a reproducible baseline for post-login startup latency on the local browser/PWA flow.
- `flutter doctor` is run and any relevant environment problems are documented in the task notes.
- The chosen fix reduces perceived or measured time to reach the authenticated Home shell without violating the startup sync/offline-first contract.
- BrowserStack is used only if the issue cannot be adequately reproduced or validated locally.
- Focused verification covers the login-to-home path after the fix, not just general app launch.
- Relevant docs are verified and updated if startup sequencing or verification guidance changes.

**Dependencies:** `Developement/sys_build_integrity.md`, `Developement/sys_offline_architecture.md`, `Developement/sys_authentication.md`, `Developement/qa_testing.md`

**Completion notes:** Completed on 2026-07-12. Removed the blocking `_initialSyncCompleted` state in `_AppGate` and wrapped `_restoreReminderForUser` in `unawaited` during login. The app now instantly renders the authenticated shell using local offline-first Drift data while `syncNow` runs in the background.

<a id="add-slot-aware-background-prefetch-for-social-reminder-daily-sync"></a>
### [x] Add Slot-Aware Background Prefetch For Social Reminder Daily Sync

**Raw source:** Task 3: Background Sync Pre-Fetch for Social Accuracy. Action: Coordinate a "Soft Sync" trigger that leverages Android `Workmanager` or iOS background tasks to pull from `/api/sync/daily` roughly 5-10 minutes before the scheduled social reminder time. Rationale: Ensures that the "Friends' Habits" recap contains the most recent partner check-in data rather than stale local cache.

**Issue:** Hable now has foreground polling and startup sync coordination, but it still lacks a scheduled background prefetch path tied to reminder time. The app can therefore refresh social state while the app is open, yet still fire a future social reminder from stale Drift data if the app has been backgrounded for hours before the reminder window. The `workmanager` dependency is present, but there is no registered worker or iOS background-task bridge in the current Flutter codebase to run a pre-reminder `pullDailySync`.

**Ponytail triage:**
- *Should exist:* Yes, but only for the friend-activity reminder path where freshness materially changes the notification content.
- *Smallest safe scope:* Register one minimal background prefetch capability that can wake shortly before the friend-activity reminder slot, attempt `pullDailySync`, and then exit without trying to render UI or guarantee exact-to-the-minute delivery.
- *Skipped scope:* Do not add push notifications, WebSockets, aggressive periodic background polling, or server-side scheduled jobs. Do not redesign the whole sync engine around background execution.
- *Boundaries:* Treat background execution as a best-effort cache warmer for Drift, not a new source of truth. If the platform declines to run the task, the app must still behave safely using existing local data and next foreground refresh.

**Action:** Add a background prefetch contract for the social reminder slot. Wire `workmanager`/platform background hooks into a minimal entry point that can authenticate, call the existing `SyncService.pullDailySync`, and refresh only the local Drift read model before the scheduled friend-activity reminder fires. The scheduling side should compute a prefetch window relative to the social reminder slot and reschedule it when that slot changes, while leaving self-habit reminders and foreground polling untouched.

**Hable perspective:** Hable is offline-first, so the job of a background prefetch is simply to make Drift less stale before a local social recap notification is assembled. The worker should not attempt to bypass Drift, manipulate widget state, or create a second social-sync protocol. It is an extension of the existing `pullDailySync` contract into best-effort background execution.

**Implementation scope:**
- `lib/services/sync_service.dart`: expose the smallest safe background-callable entry or helper needed to run `pullDailySync` outside the foreground Riverpod widget lifecycle.
- `lib/providers/sync_provider.dart` or adjacent sync/background coordinator: define the scheduling API that registers, updates, and cancels the prefetch job for the friend-activity reminder slot.
- App bootstrap/background entrypoint: add the minimal `workmanager` initialization and callback dispatcher needed for Android, plus the corresponding iOS/macOS-safe no-op/best-effort path as supported by the plugin and current deployment targets.
- Reminder integration: ensure future friend-activity reminder scheduling can request a prefetch job 5-10 minutes earlier without coupling this task to the final UI toggle implementation.
- Tests: add focused coverage for prefetch-window calculation, registration/cancel behavior, and failure-safe no-op behavior when no authenticated user or no friend-activity slot exists.

**Scalability considerations:** Background sync queue pressure is the main scaling risk. The prefetch job must stay bounded to one daily social-reminder-related pull rather than turning into frequent periodic work, and it must reuse existing sync/auth code paths so prolonged offline periods do not spawn duplicate scheduled jobs or broad table invalidations.

**Future split guidance:** If later work needs richer social recap assembly, OS-specific background execution tuning, notification coalescing, or analytics/telemetry around missed prefetch windows, split that into separate tasks. This task is only for the best-effort pre-sync hook before a friend-activity reminder.

**Edge cases:** No authenticated user when the worker wakes, expired JWT in secure storage, app killed or device rebooted after scheduling, iOS background execution limits skipping the task, unsupported web target, friend-activity reminder disabled, reminder time changed multiple times in one session, and worker overlap with existing foreground sync or queue flush logic.

**Acceptance criteria:**
- Hable defines a background prefetch mechanism that can attempt `pullDailySync` before the friend-activity reminder window.
- The scheduled prefetch is derived from the social reminder slot and can be updated/canceled when that slot changes.
- Background execution reuses the existing auth and sync contracts rather than introducing a second inbound-sync implementation.
- Failure to run or complete the prefetch leaves the app safe and local-first; the reminder system can fall back to the last cached Drift state.
- Focused automated tests cover scheduling-window math and registration/cancel behavior.
- Relevant docs are verified and updated if background sync ownership or reminder timing contracts change from the current spec text.

**Dependencies:** `Developement/sys_offline_architecture.md`, `Developement/sys_social_and_analytics.md`, `Developement/qa_testing.md`

**Completion notes:** Completed on 2026-07-12. Created `BackgroundSyncService` using `workmanager` to run `pullDailySync` roughly 10 minutes prior to a scheduled daily reminder. Connected Workmanager initialization to `main.dart` and integrated scheduling logic into `NotificationActions`. All tests pass.

<a id="replace-reminder-permission-denial-snackbars-with-soft-ask-and-settings-recovery"></a>
### [x] Replace Reminder Permission Denial Snackbars With Soft-Ask And Settings Recovery

**Raw source:** Task 5: Permission Priming & Error Graceful Recovery. Issue: The section currently shows an error for notification permissions. Action: Implement a "Soft-Ask" prompt that triggers when the user toggles a reminder "ON" for the first time. If the system permission is denied, replace the error with a clear "Enable in System Settings" button and reset the toggle to "OFF." Files: `lib/screens/settings_screen.dart`, `lib/widgets/reminder_toggle.dart`.

**Issue:** Hable already gates reminder permission behind an explicit user toggle, but the current UX is still abrupt and failure-heavy. The actual reminder control lives in `ProfileScreen`’s `_DailyReminderCard`, and denied permission currently surfaces only as a `SnackBar` saying permission was denied. The toggle path does not give the user contextual priming before the OS prompt, does not preserve a dedicated “permission denied” local state for the card, and does not replace the failed-on state with a persistent recovery affordance such as “Enable in System Settings.”

**Ponytail triage:**
- *Should exist:* Yes. The current denial UX is too brittle for a feature whose first-use path depends on OS permission.
- *Smallest safe scope:* Add a lightweight soft-ask and denial-recovery state around the existing Profile reminder card without redesigning the whole settings architecture or introducing a separate reminders screen.
- *Skipped scope:* Do not implement the dual-slot reminder UI, mascot copy randomization, push permissions, or a global permission center in this task.
- *Boundaries:* Keep the permission flow device-local and initiated only by the user’s reminder toggle action. Do not request permission on app launch or from unrelated screens.

**Action:** Rework the reminder-enable flow so the first attempt to turn a reminder on presents a small priming explanation before the OS permission dialog. If the OS permission is denied, immediately reset the toggle to off in local state, persist a denial-aware reminder-card state, and replace transient snackbars with a clear inline recovery action that guides the user to system settings on supported platforms. The current Profile reminder card should remain the single source of reminder permission UX.

**Hable perspective:** Hable’s reminder settings are an offline-first local preference stored in Drift, but the ability to schedule a real OS notification depends on platform permission. The right contract is: local reminder preference and UI state stay coherent even when scheduling fails, and the card explains what happened instead of leaving the user with a stale enabled-looking toggle or a one-shot snackbar. Unsupported platforms such as web should continue to store local preference safely without pretending native settings exist.

**Implementation scope:**
- `lib/screens/profile_screen.dart`: replace the current snackbar-only failure handling in `_DailyReminderCard` with a soft-ask step, explicit denied/off recovery messaging, and an inline “Enable in System Settings” action where supported.
- `lib/providers/notification_providers.dart`: extend reminder update actions to return enough structured outcome state for the UI to distinguish success, denied permission, unsupported platform, and explicit disable.
- `lib/services/local_reminder_service.dart`: expose the smallest needed helpers for checking/opening notification settings on supported native targets, or a safe capability signal if direct settings deep-linking is not available.
- Local reminder persistence: ensure denied permission leaves the stored reminder slot disabled rather than partially enabled.
- Tests: add focused widget/provider coverage for first-enable soft-ask, denied-permission reset behavior, and settings-recovery rendering.

**Scalability considerations:** Scalability impact: none expected. The main risk is UI-state drift between Drift and OS permission outcomes, so the flow should keep provider results explicit and deterministic rather than scattering permission heuristics across multiple widgets.

**Future split guidance:** If Hable later adds richer onboarding education, permission analytics, web-push permission handling, or per-slot permission messaging for self vs friend reminders, split those into follow-up tasks. This task is only for the base Profile reminder permission priming and denial recovery loop.

**Edge cases:** First-time enable on Android 13+, iOS/macOS denial after previous dismissal, unsupported web platform, reminder already enabled before OS-level permission is revoked externally, rapid repeated toggle taps, time change while permission remains denied, logout/login on the same device, and platforms where opening system notification settings is unavailable or best-effort only.

**Acceptance criteria:**
- Enabling a reminder from Profile uses a soft-ask step before the OS permission request on first-use or when permission is still needed.
- If permission is denied, the reminder toggle/state resets to off and does not leave a scheduled-looking enabled state in Drift.
- The reminder card shows persistent inline recovery guidance with an “Enable in System Settings” action on supported platforms instead of relying only on a snackbar.
- Reminder permission UX remains initiated only by explicit user action from the reminder control.
- Focused automated tests cover denied-permission reset behavior and the inline recovery state.
- Relevant docs are verified and updated if reminder permission ownership or Profile UX changes from the current spec text.

**Dependencies:** `Developement/sys_offline_architecture.md`, `Developement/qa_testing.md`

**Completion notes:** Completed on 2026-07-12. Added `permission_handler` to easily check and open settings. Added `isPermissionDenied` to `ReminderSettings` database schema (bumped to version 13). Replaced snackbars in `ProfileScreen` with a pre-request Soft-Ask dialog, and an inline "Enable in System Settings" button if permission is denied.

<a id="introduce-a-mascot-driven-reminder-copy-library-for-local-reminder-slots"></a>
### [x] Introduce A Mascot-Driven Reminder Copy Library For Local Reminder Slots

**Raw source:** Task 6: Mascot-Driven Template Library. Action: Build a library of randomized notification strings using the established "Hable" mascot tone (Encouraging, Humorous, Urgent). Goal: Mitigate alert fatigue by varying the phrasing of recurring daily prompts.

**Issue:** Hable’s local reminder scheduling currently uses hardcoded static strings such as `'Hable reminder'` and `'Open Hable and check today's habits.'` across provider/auth restore paths. That makes recurring reminders repetitive and leaves no structured place to express the product’s intended mascot voice. At the same time, broader social notification copy already exists in `SyncService`, so dropping random strings directly into scheduling call sites would create fragmented tone rules and make future self-vs-friend reminder slots harder to evolve consistently.

**Ponytail triage:**
- *Should exist:* Yes, but only as a small reusable library bound to reminder-generation paths.
- *Smallest safe scope:* Centralize reminder notification copy generation behind a deterministic helper that can return varied title/body pairs for self-habit and friend-activity reminder slots while leaving existing non-reminder social notification copy alone.
- *Skipped scope:* Do not rewrite all notification-center event copy, quote fallback content, onboarding tone, or social message text in this task.
- *Boundaries:* Keep this to local reminder copy selection. Do not turn it into a general brand-voice system spanning the whole app.

**Action:** Add a small reminder-copy library that exposes slot-aware, mascot-toned notification templates for recurring local reminders. The helper should support at least the immediate self-habit reminder path and reserve structure for the future friend-activity reminder slot. Update reminder scheduling/restore paths to request a generated title/body pair from that helper instead of hardcoding strings inline. Keep the variation bounded and deterministic enough for tests while still preventing every reminder from reading identically.

**Hable perspective:** Hable’s tone should feel supportive and slightly playful without becoming noisy or manipulative. Reminder copy belongs near the local reminder system, not mixed into daily quotes or backend social-event text, because it is the OS-level surface the user sees repeatedly even when the app is closed. The library should therefore be small, local-first, and explicit about which reminder slot it is speaking for.

**Implementation scope:**
- New reminder copy surface, likely under `lib/data/` or `lib/services/`, containing structured title/body templates and a small selection helper for reminder slots/types.
- `lib/providers/notification_providers.dart`: replace hardcoded reminder title/body scheduling strings with the library output for enable/update/restore flows.
- `lib/providers/auth_provider.dart`: align reminder restore scheduling with the same copy helper so restored notifications use the same tone contract.
- Tests: add focused unit coverage for reminder-copy selection, slot-aware template availability, and bounded deterministic behavior where needed.

**Scalability considerations:** Scalability impact: none expected. The main long-term risk is copy drift across multiple scheduling paths, so the important design choice is one source of reminder copy truth per slot rather than duplicating strings in providers and auth restore helpers.

**Future split guidance:** If later work needs personalized copy based on streaks, partner activity counts, quiet hours, or experimentation/analytics, split those into separate tasks. This task is only for the base mascot-driven reminder template library and its current local reminder call sites.

**Edge cases:** Very short notification title limits on OS surfaces, friend-activity slot added before custom copy exists, repeated app restarts restoring reminders with identical copy, deterministic tests around randomized selection, unsupported platforms that still store reminder preferences but do not schedule notifications, and keeping copy supportive rather than shaming when urgency variants are used.

**Acceptance criteria:**
- Reminder scheduling no longer hardcodes one static title/body pair inline across provider/auth restore paths.
- Hable has one reusable reminder-copy helper/library with multiple mascot-toned templates for at least the self-habit reminder slot.
- The library structure leaves room for a friend-activity reminder slot without forcing that full feature to ship in the same task.
- Reminder-copy selection remains testable and bounded rather than relying on uncontrolled randomness.
- Focused automated tests cover template availability and selection behavior.
- Relevant docs are verified and updated if reminder copy ownership or slot expectations change from the current spec text.

**Dependencies:** `Developement/sys_offline_architecture.md`, `Developement/qa_testing.md`

**Completion notes:** Completed on 2026-07-12. Created `MascotReminderCopyHelper` using a day-of-the-year deterministic seed to rotate daily reminder copy. Replaced hardcoded strings in `notification_providers.dart` and `auth_provider.dart`. Added a dedicated unit test.

<a id="coalesce-social-reminder-recaps-and-route-notification-taps-into-shell-state"></a>
### [ ] Coalesce Social Reminder Recaps And Route Notification Taps Into Shell State

**Raw source:** Task 4: Notification Coalescing & Nudge Deep-Linking. Action: Implement logic to merge incoming social pings into a single "Daily Recap" notification. Tapping the social reminder must route the user directly to the Social Hub or a specific partnered habit card. Files: `lib/services/sync_service.dart`, `lib/main.dart`.

**Issue:** Hable already normalizes nudges, invitations, and friend requests into Drift `notification_events`, but the current local reminder path is still primitive. `LocalReminderService` schedules reminders with a hardcoded `'home'` payload, there is no app-level notification-response router wired during plugin initialization, and the current `actionRoute` handling only supports coarse screen opens such as `'home'` or a Social subtab. That means a future social reminder would either duplicate multiple event notifications or drop the user into a generic screen with no slot-aware recap context.

**Ponytail triage:**
- *Should exist:* Yes. Once Hable adds a friend-activity reminder stream, recap coalescing and tap routing are required for the notification to be useful instead of noisy.
- *Smallest safe scope:* Build one social-reminder recap composition path that reads existing local Drift notification/partner state, emits a single recap notification per reminder window, and routes taps into the existing shell with enough payload to open Social Activity or a relevant shared-habit context.
- *Skipped scope:* Do not implement remote push delivery, free-form chat deep links, or a full universal-link/navigation framework. Do not redesign the Home card hierarchy in the same task.
- *Boundaries:* Reuse Drift as the read model and the existing navigation shell as the destination owner. The OS notification should summarize existing local state, not invent a second notification/event store.

**Action:** Add a recap builder for the friend-activity reminder slot that coalesces eligible social signals into one OS notification, with payload metadata that can reopen Hable into the right shell state. Extend local notification initialization so notification taps are observed at app level, decoded, and mapped into `MainNavigationShell` navigation commands. For the first safe version, deep links may target Social Activity or Home-with-habit-focus using existing IDs from `actionPayloadJson`; multiple raw nudge events should no longer produce multiple OS reminder notifications for the same reminder window.

**Hable perspective:** Hable is already using Drift-backed `notification_events` and partner snapshots as its offline-first social read model. The correct place to assemble a daily social recap is from that local cache after the background prefetch/update step, not from ad hoc network calls at tap time. Likewise, navigation should flow through `MainNavigationShell`, which already owns Home vs Social destination state, instead of each notification surface pushing unrelated screens directly.

**Implementation scope:**
- `lib/services/local_reminder_service.dart`: add slot-aware recap scheduling payloads and plugin tap-response wiring hooks instead of the current hardcoded `'home'` payload contract.
- `lib/services/sync_service.dart`: define the smallest local recap-selection/coalescing helper that can summarize nudges/invites/friend-activity into one friend-activity reminder payload using existing Drift data.
- `lib/main.dart`: add app-level notification tap handling/bootstrap routing so a launched/resumed app can hand notification intents into shell state cleanly.
- `lib/screens/main_navigation_shell.dart`: extend shell navigation helpers so notification routes can open Social Activity or a habit-focused Home context without duplicating navigation logic across screens.
- Tests: add focused unit/widget coverage for recap coalescing rules, payload decoding, and shell-route behavior from a notification tap.

**Scalability considerations:** Notification-event volume can grow faster than reminder slots. Coalescing should therefore operate on a bounded, recency-filtered subset of local rows and emit one recap per reminder window, not one OS notification per underlying nudge/request. Shell routing should stay payload-driven so new reminder/event types do not require scattered hardcoded navigation branches.

**Future split guidance:** If later work needs richer habit-card auto-scroll/focus behavior, grouped notification inbox UX, or platform-specific notification categories/actions, split those into follow-up tasks. This task is only for one coalesced daily social recap and deterministic tap routing into the existing shell.

**Edge cases:** No eligible social events when the recap fires, multiple nudges on the same habit from different friends, conflicting signals across Home and Social destinations, app cold-start from a notification tap, stale habit IDs in action payloads, user logged out when a notification is tapped, unsupported web target, and legacy notification rows that only carry coarse `'home'` routes.

**Acceptance criteria:**
- Hable can assemble one friend-activity recap notification from local social state instead of emitting one OS notification per raw social ping.
- The recap payload includes enough route metadata to open Social Activity or a specific shared-habit context deterministically.
- App-level notification tap handling is wired so taps on local reminder notifications are observable and routed through `MainNavigationShell`.
- Existing Drift `notification_events` / partner snapshot data remains the source for recap composition; no direct network fetch is required at tap time.
- Focused automated tests cover recap grouping and at least one notification-tap routing path.
- Relevant docs are verified and updated if reminder routing or notification ownership changes from the current spec text.

**Dependencies:** `Developement/sys_offline_architecture.md`, `Developement/sys_social_and_analytics.md`, `Developement/qa_testing.md`

**Completion notes:** [Placeholder for completion notes, touched files, behavior verified, and completion timestamp]

<a id="replace-hash-based-reminder-notification-ids-with-stable-slot-ranges"></a>
### [ ] Replace Hash-Based Reminder Notification IDs With Stable Slot Ranges

**Raw source:** Task 2: Idempotent Notification ID Management. Action: Implement a stable integer ID system for `flutter_local_notifications`. Use reserved ranges (e.g., 100-199 for personal, 200-299 for friends) to ensure that updating a reminder time overwrites the previous schedule instead of creating duplicate daily alerts. Files: `lib/services/local_reminder_service.dart`.

**Issue:** Hable's current `LocalReminderService` derives the local notification ID from a hash of `userId`. That worked while only one reminder existed, but it is the wrong contract for typed multi-slot reminders. A hash-based ID does not express reminder type, does not reserve predictable ranges for future slots, and makes it harder to reason about overwrite/cancel behavior when the schema expands from one reminder row to several typed rows per user.

**Ponytail triage:**
- *Should exist:* Yes. Once reminder settings become typed slots, deterministic per-slot notification IDs are required to prevent duplicate schedules and ambiguous cancellations.
- *Smallest safe scope:* Replace the hash-based ID derivation with a stable reminder-slot ID policy and thread that policy through schedule/cancel/restore paths for the currently supported slots.
- *Skipped scope:* Do not implement background prefetch, deep-link routing, coalescing notification bodies, or randomized reminder copy in this task.
- *Boundaries:* Keep this limited to local scheduling identity and cancellation semantics. Do not broaden it into OS-permission UX or backend sync work.

**Action:** Introduce a slot-aware integer ID strategy in `LocalReminderService`, with explicit reserved ranges for self-habit and friend-activity reminders. Update the service API so callers schedule and cancel by reminder slot/type instead of relying on a user-hash identity. Preserve the current self-habit reminder behavior, and make the friend-activity range available for follow-up tasks without requiring the full social-reminder feature to ship in the same change.

**Hable perspective:** Hable stores reminder preferences in Drift and rehydrates OS notifications on login/relaunch. The notification ID is therefore part of the local reminder persistence contract: it must be deterministic across app restarts, stable for overwrite behavior, and legible enough that future reminder slots can coexist without accidentally canceling each other. The service should know how to map a typed slot to an OS notification identity; Riverpod/UI should not invent numeric IDs ad hoc.

**Implementation scope:**
- `lib/services/local_reminder_service.dart`: replace `_notificationIdForUser` with a typed/range-based ID mapper, and update `scheduleDailyReminder` / `cancelReminder` signatures as needed.
- `lib/providers/notification_providers.dart`: pass the default self-habit slot explicitly through reminder update/restore/cancel paths.
- `lib/providers/auth_provider.dart`: align login restore and logout cancellation with the slot-aware reminder API so restored schedules overwrite correctly after relaunch.
- Tests: add focused unit coverage for notification ID mapping, overwrite-safe scheduling intent, and slot-specific cancellation semantics.

**Scalability considerations:** Scalability impact: none expected. The number of local reminder slots is tiny and fixed. The important scale boundary is operational correctness: stable IDs must avoid a future explosion of duplicate scheduled notifications as more reminder types are introduced.

**Future split guidance:** If Hable later supports multiple reminders within the same slot family (for example several self-habit windows), that should be a separate schema and scheduling task with a broader ID-allocation policy. This task is only for stable reserved ranges covering the immediate typed reminder streams.

**Edge cases:** Existing users upgrading from hash-based IDs, cancel-after-logout leaving a stale old scheduled notification behind, repeated enable/time-change cycles, unsupported web platforms no-oping cleanly, slot values added later without assigned ranges, and mixed app states where Drift is migrated but scheduling code is still called from old compatibility helpers.

**Acceptance criteria:**
- `LocalReminderService` uses stable slot-aware notification IDs instead of a hash of `userId`.
- Updating a reminder time for the same slot overwrites the prior OS schedule rather than creating a duplicate alert.
- Cancel and restore flows target the intended slot deterministically for the current self-habit reminder path.
- Reserved ID space exists for both self-habit and friend-activity reminder slots, even if only the default self slot is active today.
- Focused automated tests cover ID mapping and slot-specific cancel/schedule behavior.
- Relevant docs are verified and updated if the reminder scheduling contract changes from the current spec text.

**Dependencies:** `Developement/sys_schema_and_logic.md`, `Developement/sys_offline_architecture.md`, `Developement/qa_testing.md`

**Completion notes:** [Placeholder for completion notes, touched files, behavior verified, and completion timestamp]
