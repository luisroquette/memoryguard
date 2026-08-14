# Graph Report - MemoryGuard  (2026-08-14)

## Corpus Check
- 30 files · ~93,348 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 569 nodes · 965 edges · 31 communities (27 shown, 4 thin omitted)
- Extraction: 86% EXTRACTED · 14% INFERRED · 0% AMBIGUOUS · INFERRED: 133 edges (avg confidence: 0.82)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `60ef9c1d`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- MemoryGuardProductModel
- String
- MemoryGuardApplicationController
- MemoryGuard product site
- MGCard
- ProtectionProfile
- Automatic relief active
- BuildController
- SectionTitle
- GuardEvent
- MemoryGuard
- MemoryGuard
- MemoryGuard
- MemoryGuard
- Local Decision History
- Local Decision History
- Local Decision History
- Local Decision History
- ProductTheme.swift
- AppShellView
- MemoryGuard
- AutomationView
- View
- ProtectionProfileCard
- Memory protection
- OverviewView
- script.js
- SiteParser
- make-app.sh
- Blank issues enabled
- Package.swift

## God Nodes (most connected - your core abstractions)
1. `MemoryGuardProductModel` - 61 edges
2. `MemoryGuardApplicationController` - 34 edges
3. `MemorySnapshot` - 21 edges
4. `BuildGroup` - 20 edges
5. `GuardEvent` - 19 edges
6. `ProtectionProfile` - 16 edges
7. `ReliefPolicy` - 16 edges
8. `MemoryGuardCoreTests` - 16 edges
9. `MGCard` - 14 edges
10. `ProcessRecord` - 14 edges

## Surprising Connections (you probably didn't know these)
- `Exact allow-list process recognition` --semantically_similar_to--> `Recognized build process groups`  [INFERRED] [semantically similar]
  CONTRIBUTING.md → README.md
- `Local 100-event decision history and sanitized diagnostics` --semantically_similar_to--> `Capped local audit history and sanitized diagnostics`  [INFERRED] [semantically similar]
  CHANGELOG.md → README.md
- `Two-sample recovery and watchdog safety` --semantically_similar_to--> `Resume after two consecutive healthy samples`  [INFERRED] [semantically similar]
  CHANGELOG.md → README.md
- `Non-destructive safety contract` --semantically_similar_to--> `No deletion, termination, or only-build pause`  [INFERRED] [semantically similar]
  CONTRIBUTING.md → README.md
- `Narrow behavior as a basis for testability and trust` --semantically_similar_to--> `No deletion, termination, or only-build pause`  [INFERRED] [semantically similar]
  docs/index.html → README.md

## Import Cycles
- None detected.

## Hyperedges (group relationships)
- **Protection profile options** — docs_img_automation_balanced_profile, docs_img_automation_proactive_profile, docs_img_automation_conservative_profile [EXTRACTED 1.00]
- **System health snapshot** — docs_img_overview_available_memory, docs_img_overview_swap_usage, docs_img_overview_healthy_kernel_pressure, docs_img_overview_recognized_builds [EXTRACTED 1.00]
- **MemoryGuard Privacy Guarantees** — docs_img_about_1410_fully_local, docs_img_about_1410_no_account_cloud_telemetry, docs_img_about_1410_limited_history [EXTRACTED 1.00]
- **MemoryGuard Safety Guarantees** — docs_img_about_1410_no_data_deletion, docs_img_about_1410_no_app_termination, docs_img_about_1410_recognized_build_groups_only, docs_img_about_1410_watchdog_recovery [EXTRACTED 1.00]
- **MemoryGuard Privacy Guarantees** — docs_img_about_470_fully_local, docs_img_about_470_no_account_cloud_telemetry, docs_img_about_470_limited_history [EXTRACTED 1.00]
- **MemoryGuard Safety Guarantees** — docs_img_about_470_no_data_deletion, docs_img_about_470_no_app_termination, docs_img_about_470_recognized_build_groups_only, docs_img_about_470_watchdog_recovery [EXTRACTED 1.00]
- **MemoryGuard Privacy Guarantees** — docs_img_about_940_fully_local, docs_img_about_940_no_account_cloud_telemetry, docs_img_about_940_limited_history [EXTRACTED 1.00]
- **MemoryGuard Safety Guarantees** — docs_img_about_940_no_data_deletion, docs_img_about_940_no_app_termination, docs_img_about_940_recognized_build_groups_only, docs_img_about_940_watchdog_recovery [EXTRACTED 1.00]
- **MemoryGuard Privacy Guarantees** — docs_img_about_fully_local, docs_img_about_no_account_cloud_telemetry, docs_img_about_limited_history [EXTRACTED 1.00]
- **MemoryGuard Safety Guarantees** — docs_img_about_no_data_deletion, docs_img_about_no_app_termination, docs_img_about_recognized_build_groups_only, docs_img_about_watchdog_recovery [EXTRACTED 1.00]
- **Recorded Activity Event Types** — docs_img_activity_1410_monitoring_started, docs_img_activity_1410_automatic_relief_activated, docs_img_activity_1410_builds_resumed_on_exit [EXTRACTED 1.00]
- **Recorded Activity Event Types** — docs_img_activity_470_monitoring_started, docs_img_activity_470_automatic_relief_activated, docs_img_activity_470_builds_resumed_on_exit [EXTRACTED 1.00]
- **Recorded Activity Event Types** — docs_img_activity_940_monitoring_started, docs_img_activity_940_automatic_relief_activated, docs_img_activity_940_builds_resumed_on_exit [EXTRACTED 1.00]
- **Recorded Activity Event Types** — docs_img_activity_monitoring_started, docs_img_activity_automatic_relief_activated, docs_img_activity_builds_resumed_on_exit [EXTRACTED 1.00]
- **MemoryGuard Distribution Principles** — github_social_preview_free_software, github_social_preview_open_source, github_social_preview_local_only [EXTRACTED 1.00]
- **Automated Memory Safety Flow** — readme_two_sample_recovery [EXTRACTED 1.00]

## Communities (31 total, 4 thin omitted)

### Community 0 - "MemoryGuardProductModel"
Cohesion: 0.07
Nodes (35): MainActor, Never, ObservableObject, LaunchAtLoginResult, failure, success, LaunchAtLoginState, disabled (+27 more)

### Community 1 - "String"
Cohesion: 0.06
Nodes (41): Equatable, Sendable, BuildRow, .body, .weightLabel, .color, .icon, .title (+33 more)

### Community 2 - "MemoryGuardApplicationController"
Cohesion: 0.07
Nodes (27): AnyCancellable, AnyObject, AnyView, Notification, NSApplication, NSApplicationDelegate, NSEvent, NSImage (+19 more)

### Community 3 - "MemoryGuard product site"
Cohesion: 0.05
Nodes (46): Heavy versus below-threshold work visibility, History clearing leaves local history empty, Local 100-event decision history and sanitized diagnostics, MemoryGuard changelog, Accessible, crawlable, performant product site, Two-sample recovery and watchdog safety, MemoryGuard 1.3.0, MemoryGuard 1.3.1 (+38 more)

### Community 4 - "MGCard"
Cohesion: 0.67
Nodes (3): Content, MGCard, .body

### Community 5 - "ProtectionProfile"
Cohesion: 0.06
Nodes (36): CaseIterable, ColorScheme, Identifiable, Int, AppAppearance, .colorScheme, dark, .icon (+28 more)

### Community 6 - "Automatic relief active"
Cohesion: 0.11
Nodes (27): MemoryGuard Automation screen, MemoryGuard Automation screen, MemoryGuard Automation screen, Automatic relief that pauses and resumes builds, MemoryGuard Automation screen, Balanced protection profile, Balanced limits: critical RAM at 12 percent or less, low swap at 512 MB, minimum build at 256 MB, recovery at 25 percent or more, Conservative protection profile (+19 more)

### Community 7 - "BuildController"
Cohesion: 0.10
Nodes (19): Darwin, LocalizedError, Process, BuildController, .pausedGroupIDs, Int, Int32, Set (+11 more)

### Community 8 - "SectionTitle"
Cohesion: 0.18
Nodes (11): .body, .recentActivityCard, EmptyState, .body, EventRow, .body, .icon, .tint (+3 more)

### Community 9 - "GuardEvent"
Cohesion: 0.10
Nodes (16): Codable, Foundation, MemoryGuard, GuardEvent, GuardEventKind, error, information, intervention (+8 more)

### Community 10 - "MemoryGuard"
Cohesion: 0.15
Nodes (15): About Screen, Healthy, Protection Active, Build Continuity Without Sacrificing Open Work, 100% Local, History Limited to 100 Non-Sensitive Events, Local and Transparent Protection for Heavy Work on macOS, MemoryGuard, No Account, Cloud, or Telemetry (+7 more)

### Community 11 - "MemoryGuard"
Cohesion: 0.15
Nodes (15): About Screen, Healthy, Protection Active, Build Continuity Without Sacrificing Open Work, 100% Local, History Limited to 100 Non-Sensitive Events, Local and Transparent Protection for Heavy Work on macOS, MemoryGuard, No Account, Cloud, or Telemetry (+7 more)

### Community 12 - "MemoryGuard"
Cohesion: 0.15
Nodes (15): About Screen, Healthy, Protection Active, Build Continuity Without Sacrificing Open Work, 100% Local, History Limited to 100 Non-Sensitive Events, Local and Transparent Protection for Heavy Work on macOS, MemoryGuard, No Account, Cloud, or Telemetry (+7 more)

### Community 13 - "MemoryGuard"
Cohesion: 0.15
Nodes (15): About Screen, Healthy, Protection Active, Build Continuity Without Sacrificing Open Work, 100% Local, History Limited to 100 Non-Sensitive Events, Local and Transparent Protection for Heavy Work on macOS, MemoryGuard, No Account, Cloud, or Telemetry (+7 more)

### Community 14 - "Local Decision History"
Cohesion: 0.18
Nodes (13): Healthy, Protection Active, Activity Screen, Automatic Relief Activated, Background Observation Continues, Builds Resumed When MemoryGuard Exited, Clear Local History, Local Decision History, MemoryGuard (+5 more)

### Community 15 - "Local Decision History"
Cohesion: 0.18
Nodes (13): Healthy, Protection Active, Activity Screen, Automatic Relief Activated, Background Observation Continues, Builds Resumed When MemoryGuard Exited, Clear Local History, Local Decision History, MemoryGuard (+5 more)

### Community 16 - "Local Decision History"
Cohesion: 0.18
Nodes (13): Healthy, Protection Active, Activity Screen, Automatic Relief Activated, Background Observation Continues, Builds Resumed When MemoryGuard Exited, Clear Local History, Local Decision History, MemoryGuard (+5 more)

### Community 17 - "Local Decision History"
Cohesion: 0.18
Nodes (13): Healthy, Protection Active, Activity Screen, Automatic Relief Activated, Background Observation Continues, Builds Resumed When MemoryGuard Exited, Clear Local History, Local Decision History, MemoryGuard (+5 more)

### Community 18 - "ProductTheme.swift"
Cohesion: 0.24
Nodes (5): AppKit, Combine, MemoryGuardCore, ServiceManagement, SwiftUI

### Community 20 - "AppShellView"
Cohesion: 0.33
Nodes (6): AppShellView, .body, .sidebarStatus, .statusBadge, .statusTint, Color

### Community 21 - "MemoryGuard"
Cohesion: 0.25
Nodes (9): Build-Aware Memory Protection, Free Software, Local-Only, macOS, Memory Shield Icon, MemoryGuard, Memory Monitoring Dashboard, Open Source (+1 more)

### Community 22 - "AutomationView"
Cohesion: 0.33
Nodes (6): AutomationView, .policyDetails, .safetyFlow, Int, String, UInt64

### Community 23 - "View"
Cohesion: 0.36
Nodes (6): AboutView, .body, String, ActivityView, .detailView, View

### Community 24 - "ProtectionProfileCard"
Cohesion: 0.18
Nodes (11): .body, ProtectionProfileCard, .body, .cardBackground, .cardStroke, .icon, Bool, Color (+3 more)

### Community 25 - "Memory protection"
Cohesion: 0.38
Nodes (7): Memory chip with six green cells, MemoryGuard app icon, White protective shield, Memory chip with six green cells, Memory protection, MemoryGuard app icon, White protective shield

### Community 26 - "OverviewView"
Cohesion: 0.24
Nodes (8): OverviewView, .body, .memoryDetail, .protectionCard, String, UInt64, MetricTile, .body

### Community 27 - "script.js"
Cohesion: 0.40
Nodes (5): nav, pressureLab, setNavigation(), toggle, toggleLabel

## Knowledge Gaps
- **150 isolated node(s):** `PackageDescription`, `make-app.sh script`, `system`, `light`, `dark` (+145 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **4 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `MemoryGuardProductModel` connect `MemoryGuardProductModel` to `String`, `MemoryGuardApplicationController`, `ProtectionProfile`, `BuildController`, `SectionTitle`, `GuardEvent`, `ProductTheme.swift`, `AppShellView`, `AutomationView`, `View`, `OverviewView`?**
  _High betweenness centrality (0.198) - this node is a cross-community bridge._
- **Why does `MemoryGuardApplicationController` connect `MemoryGuardApplicationController` to `MemoryGuardProductModel`, `ProductTheme.swift`?**
  _High betweenness centrality (0.070) - this node is a cross-community bridge._
- **Why does `MemorySnapshot` connect `String` to `MemoryGuardProductModel`, `BuildController`?**
  _High betweenness centrality (0.037) - this node is a cross-community bridge._
- **Are the 9 inferred relationships involving `MemoryGuardProductModel` (e.g. with `MemoryGuardApplicationController` and `.observeModel()`) actually correct?**
  _`MemoryGuardProductModel` has 9 INFERRED edges - model-reasoned connections that need verification._
- **Are the 7 inferred relationships involving `MemorySnapshot` (e.g. with `MemoryGuardProductModel` and `.criticalPressurePausesNewestOfTwoBuilds()`) actually correct?**
  _`MemorySnapshot` has 7 INFERRED edges - model-reasoned connections that need verification._
- **What connects `PackageDescription`, `make-app.sh script`, `system` to the rest of the system?**
  _150 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `MemoryGuardProductModel` be split into smaller, more focused modules?**
  _Cohesion score 0.06753246753246753 - nodes in this community are weakly interconnected._