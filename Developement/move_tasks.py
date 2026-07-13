import os

guidance_path = "/Users/h.ettefagh/Documents/VibeCoding/Flutter/hable/Developement/future_split_guidance.md"
raw_tasks_path = "/Users/h.ettefagh/Documents/VibeCoding/Flutter/hable/Developement/Task0_Raw.md"

with open(guidance_path, "r") as f:
    content = f.read()

tasks_to_move = [
"""- **Multiple Reminders per Slot:** Support multiple reminders within the same slot family (for example several self-habit windows) with a broader ID-allocation policy. 
  - *Context:* Requires expanding the Drift `reminder_settings` table schema and robustly handling the cancellation lifecycle.
  - *User Perspective:* The flexibility to set multiple nudges (e.g., a morning reminder and an evening follow-up) for a single habit.""",

"""- **Advanced Background Prefetch:** Implement richer social recap assembly, OS-specific background execution tuning, notification coalescing, or analytics/telemetry around missed prefetch windows. 
  - *Context:* Analytics must remain compliant with the anonymous bounds defined in `sys_schema_and_logic.md` (`UsageAggregateBuckets` table).
  - *User Perspective:* Opening the app instantly shows what your friends did overnight, without waiting for a loading spinner to fetch new data.""",

"""- **Tablet & Grid Dashboards:** Create a dedicated all-habits page, separate Home and grid experiences, advanced tablet dashboard composition, or a reusable design-system `HabitTile` package. 
  - *User Perspective:* An optimized, gorgeous layout that makes perfect use of the extra screen space if you're using an iPad or an ultra-wide web browser.

- **Notification Inbox UX:** Build richer habit-card auto-scroll/focus behavior, grouped notification inbox UX, or platform-specific notification categories/actions. 
  - *Context:* Inbound data normalizes into the `notification_events` Drift table (`sys_schema_and_logic.md`). 
  - *User Perspective:* A clean, organized inbox that makes it easy to catch up on friend nudges and habit invites without feeling cluttered.""",

"""- **Mac App Store:** Set up Mac App Store distribution.
  - *User Perspective:* A native Mac application that lives in your dock and updates seamlessly through the Mac App Store.

- **Windows Installers:** Create Windows installer creation.
  - *User Perspective:* A dedicated Windows app that you can install on your PC for quick access to your habits while working."""
]

for task in tasks_to_move:
    content = content.replace(task + "\n", "")
    content = content.replace(task, "")

with open(guidance_path, "w") as f:
    f.write(content)

with open(raw_tasks_path, "a") as f:
    f.write("\n")
    f.write("\n\n".join(tasks_to_move))
    f.write("\n")
