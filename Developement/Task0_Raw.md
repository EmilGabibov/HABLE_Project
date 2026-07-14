<!-- AI AGENT OPERATING CONTRACT — See ai_agent_contract.md for full rules. This file is the raw intake queue (§5 / §2). -->

## Raw Tasks Intake

- issue report: Users are not able to see their friends' active habits; every user have a set of data available on server:
  - public: username, profilePicture (emoji)
  - friends: 
    - username, profilePicture (emoji), active habits, lifetime score, acheivements (list of names, or ids (for programming perspective) which includes your mutual habits(partnersd-up with eachother, and also with others).
  - Transferred on 2026-07-14 to [Surface Accepted Friends' Active Habit Summaries With Privacy-Scoped Friend Profiles](Task1_Engineered.md#surface-accepted-friends-active-habit-summaries-with-privacy-scoped-friend-profiles)

- in search modal, the buttons and status should be dynamic; the add button should change state to request sent (able to click again to cancel the request). consider the abusing, but be genrase.
  - Transferred on 2026-07-14 to [Make Friend Search Result Actions Stateful, Revocable, And Abuse-Resistant](Task1_Engineered.md#make-friend-search-result-actions-stateful-revocable-and-abuse-resistant)

- on MacOS after during signing in, app prompts system consistantly for using autofill data: Hable wants to use your confidential information stored in "flutter_secure_storage_service" in your keychain.
  - its disturbing, because it keeps asking again and again, no matter you allow or deny! 
  - good to be able to use system passwords, but in a propper safe way for user. not abusing way.
  - Transferred on 2026-07-14 to [Stop Repetitive macOS Keychain Prompts While Preserving Safe Auth Session Storage](Task1_Engineered.md#stop-repetitive-macos-keychain-prompts-while-preserving-safe-auth-session-storage)

- revise the habit creator modal texts; too much subtitles, it's confusing.
  - Transferred on 2026-07-14 to [Simplify Habit Creation Copy And Introduce Anchored Duration Selection Without Rewriting Mud Progression](Task1_Engineered.md#simplify-habit-creation-copy-and-introduce-anchored-duration-selection-without-rewriting-mud-progression)
next 
- writing a new ai ahent contract to use github issues instead of 
