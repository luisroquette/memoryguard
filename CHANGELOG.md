# Changelog

All notable changes to MemoryGuard are documented here.

## 1.3.1 — 2026-08-14

### Improved

- Active work now shows whether each recognized group is heavy or below the selected profile threshold.
- Overview and menu-bar metrics distinguish heavy work from all recognized groups.
- Clearing local history now leaves it empty, as requested.
- The initial toolbar status stays in a loading state until the first real system sample.
- The product page now uses local fonts, responsive lossless WebP screenshots, stricter browser security policy and complete keyboard navigation.

### Quality

- Added regression tests for exact heavy-build thresholds and history clearing.
- Improved landing-page accessibility, metadata, crawlability and mobile performance.

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
