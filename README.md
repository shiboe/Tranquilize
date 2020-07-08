# Tranquilize

Raid announcements for Tranquilizing Shot hit/miss along with timer UI.

## About this addon

This addon targets assisting usage of Tranqulizing Shot in raids with minimum overhead (it's very small!). It will display a list of all hunters in your raid, along with timers for their current Tranqulizing Shot cooldowns. Additionally, it will /raid when you hit or miss a Tranquilizing Shot. That's it! I'll probably add some additional features like parsing /raid to sync results beyond the 50y combat radius, but rotation based stuff is, and will always be, left to you!

Feel free to drop suggestions or bug details my way in comments. This is still actively in development as I expand upon a few key upcoming features.

## Currently supported commands

- **/tranqshow** - show and reset the UI
- **/tranqhide** - hide the UI

## Upcoming features

- Reorder hunter list with broadcast to sync.
- Specify a broadcast channel.
- Tranqhelp command to list commands with descriptions in game.

## Changelog

Features added in each version are documented here. Versions follow a modified semver, with a major.minor.patch structure. Patch is omitted from this changelog as it is simply used to iterate game versions.

### v3.2

- J/K maybe we actually fix the bug this time.

### v3.1

- Fix bug where simultaneous tranq shots only render for the first hunter.
- Update to latest WoW Classic version.

### v3.0

- Fix UI bug that causes hunter counters beyond the first in list to freeze.
- Change addon to be disabled by default.
- Change addon to always show hunter UI, even when solo.

### v2.5

- Fix new bug with announcements, where you announce on every hunter's tranq shot.

### v2.4

- Add /tranqdebug command to help live diagnose remaining UI issues in raid.

### v2.3

- Fix bug with hunter rows not being reusable and breaking the UI in some cases.
- Add print messages for some states (hiding the frame, long loading).

### v2.2

- Add unpartied default UI so it's not just a blank box when not grouped.
- Add additional scripting for easier dev (on mac only).

### v2.1

- Add zip script with better project structure for better publishing.

### v2.0

- Add frame UI showing all hunters in raid/party, updated on raid member changes, and (hopefully) queue a new render when raid member data isn't available yet.
- Add counters per hunter that operates on WoW update timer to countdown from 20 seconds with a 0.1 second precision.
- Add slash commands to show/reset/hide the UI frame.

### v1.0

- Add combat log monitoring for tranquilize events hit/miss.
- Broadcast to raid/party whenever tranquilize event occurs.
