# Changelog

All notable changes to MemoryGuard are documented here.

## 1.3.0 — 2026-08-14

### Added

- Native Overview, Activity, Automation, Settings and About surfaces.
- Balanced, Proactive and Conservative protection profiles.
- Local 100-event decision history and sanitized diagnostics.
- Launch-at-login support with macOS approval-state feedback.
- Recognition for Next.js, Swift, TypeScript, Vitest and Playwright groups.

### Safety

- Recovery now requires two fully healthy RAM, kernel-pressure and swap samples.
- The only heavy build is never paused.
- A watchdog resumes paused groups if MemoryGuard exits unexpectedly.
- Shutdown no longer records false recovery events when nothing was paused.

### Quality

- Adaptive macOS layout and improved accessibility labels.
- Asynchronous launch-at-login operations.
- 18 unit and integration tests, validated with Thread and Address Sanitizers.
