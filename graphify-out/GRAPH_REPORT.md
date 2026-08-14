# Graph Report - MemoryGuard  (2026-08-14)

## Corpus Check
- 40 files · ~93,348 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 578 nodes · 927 edges · 34 communities (28 shown, 6 thin omitted)
- Extraction: 87% EXTRACTED · 13% INFERRED · 0% AMBIGUOUS · INFERRED: 116 edges (avg confidence: 0.83)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `1d0cc89a`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- Product Orchestration
- Memory Domain Policies
- macOS App Lifecycle
- Product Documentation
- Protection Decision Logic
- User Preferences
- Automation Interface
- System Sampling
- Reusable UI Components
- Local Event History
- Privacy and Safety
- Privacy and Safety
- Privacy and Safety
- Privacy and Safety
- Activity Screen States
- Activity Screen States
- Activity Screen States
- Activity Screen States
- SwiftUI Module Structure
- Build Process Control
- Navigation Shell
- Brand and Positioning
- Automation Workflow
- Page Layout Components
- Protection Profile UI
- App Icon Assets
- Overview Dashboard
- Website Interactions
- Website Validation
- App Packaging
- Issue Templates
- Swift Package Definition
- Preferences Storage
- Process Identifiers

## God Nodes (most connected - your core abstractions)
1. `MemoryGuardProductModel` - 60 edges
2. `MemoryGuardApplicationController` - 34 edges
3. `MemorySnapshot` - 21 edges
4. `BuildGroup` - 20 edges
5. `MemoryGuardCoreTests` - 16 edges
6. `ProtectionProfile` - 15 edges
7. `MGCard` - 14 edges
8. `ProcessRecord` - 14 edges
9. `AppSection` - 13 edges
10. `SectionTitle` - 13 edges

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

## Communities (34 total, 6 thin omitted)

### Community 0 - "Product Orchestration"
Cohesion: 0.06
Nodes (40): AppAppearance, GuardEventKind, MainActor, Never, ObservableObject, ProtectionProfile, SamplingInterval, LaunchAtLoginResult (+32 more)

### Community 1 - "Memory Domain Policies"
Cohesion: 0.07
Nodes (33): Equatable, Int32, ReliefPolicy, Sendable, BuildRow, .body, .weightLabel, .color (+25 more)

### Community 2 - "macOS App Lifecycle"
Cohesion: 0.07
Nodes (27): AnyCancellable, AnyObject, AnyView, Notification, NSApplication, NSApplicationDelegate, NSEvent, NSImage (+19 more)

### Community 3 - "Product Documentation"
Cohesion: 0.05
Nodes (46): Heavy versus below-threshold work visibility, History clearing leaves local history empty, Local 100-event decision history and sanitized diagnostics, MemoryGuard changelog, Accessible, crawlable, performant product site, Two-sample recovery and watchdog safety, MemoryGuard 1.3.0, MemoryGuard 1.3.1 (+38 more)

### Community 4 - "Protection Decision Logic"
Cohesion: 0.08
Nodes (18): Foundation, MemoryGuard, ProtectionProfile, balanced, conservative, .id, .policy, proactive (+10 more)

### Community 5 - "User Preferences"
Cohesion: 0.08
Nodes (28): CaseIterable, ColorScheme, Identifiable, Int, AppAppearance, .colorScheme, dark, .icon (+20 more)

### Community 6 - "Automation Interface"
Cohesion: 0.11
Nodes (27): MemoryGuard Automation screen, MemoryGuard Automation screen, MemoryGuard Automation screen, Automatic relief that pauses and resumes builds, MemoryGuard Automation screen, Balanced protection profile, Balanced limits: critical RAM at 12 percent or less, low swap at 512 MB, minimum build at 256 MB, recovery at 25 percent or more, Conservative protection profile (+19 more)

### Community 7 - "System Sampling"
Cohesion: 0.11
Nodes (15): LocalizedError, String, SystemSample, SystemSampler, SystemSamplerError, commandFailed, .errorDescription, invalidMemoryOutput (+7 more)

### Community 8 - "Reusable UI Components"
Cohesion: 0.13
Nodes (18): Content, .body, .protectionCard, .recentActivityCard, EmptyState, .body, EventRow, .body (+10 more)

### Community 9 - "Local Event History"
Cohesion: 0.18
Nodes (12): Codable, GuardEvent, GuardEventKind, error, information, intervention, recovery, settings (+4 more)

### Community 10 - "Privacy and Safety"
Cohesion: 0.15
Nodes (15): About Screen, Healthy, Protection Active, Build Continuity Without Sacrificing Open Work, 100% Local, History Limited to 100 Non-Sensitive Events, Local and Transparent Protection for Heavy Work on macOS, MemoryGuard, No Account, Cloud, or Telemetry (+7 more)

### Community 11 - "Privacy and Safety"
Cohesion: 0.15
Nodes (15): About Screen, Healthy, Protection Active, Build Continuity Without Sacrificing Open Work, 100% Local, History Limited to 100 Non-Sensitive Events, Local and Transparent Protection for Heavy Work on macOS, MemoryGuard, No Account, Cloud, or Telemetry (+7 more)

### Community 12 - "Privacy and Safety"
Cohesion: 0.15
Nodes (15): About Screen, Healthy, Protection Active, Build Continuity Without Sacrificing Open Work, 100% Local, History Limited to 100 Non-Sensitive Events, Local and Transparent Protection for Heavy Work on macOS, MemoryGuard, No Account, Cloud, or Telemetry (+7 more)

### Community 13 - "Privacy and Safety"
Cohesion: 0.15
Nodes (15): About Screen, Healthy, Protection Active, Build Continuity Without Sacrificing Open Work, 100% Local, History Limited to 100 Non-Sensitive Events, Local and Transparent Protection for Heavy Work on macOS, MemoryGuard, No Account, Cloud, or Telemetry (+7 more)

### Community 14 - "Activity Screen States"
Cohesion: 0.18
Nodes (13): Healthy, Protection Active, Activity Screen, Automatic Relief Activated, Background Observation Continues, Builds Resumed When MemoryGuard Exited, Clear Local History, Local Decision History, MemoryGuard (+5 more)

### Community 15 - "Activity Screen States"
Cohesion: 0.18
Nodes (13): Healthy, Protection Active, Activity Screen, Automatic Relief Activated, Background Observation Continues, Builds Resumed When MemoryGuard Exited, Clear Local History, Local Decision History, MemoryGuard (+5 more)

### Community 16 - "Activity Screen States"
Cohesion: 0.18
Nodes (13): Healthy, Protection Active, Activity Screen, Automatic Relief Activated, Background Observation Continues, Builds Resumed When MemoryGuard Exited, Clear Local History, Local Decision History, MemoryGuard (+5 more)

### Community 17 - "Activity Screen States"
Cohesion: 0.18
Nodes (13): Healthy, Protection Active, Activity Screen, Automatic Relief Activated, Background Observation Continues, Builds Resumed When MemoryGuard Exited, Clear Local History, Local Decision History, MemoryGuard (+5 more)

### Community 18 - "SwiftUI Module Structure"
Cohesion: 0.23
Nodes (5): AppKit, Combine, MemoryGuardCore, ServiceManagement, SwiftUI

### Community 19 - "Build Process Control"
Cohesion: 0.26
Nodes (7): Darwin, Process, BuildController, .pausedGroupIDs, Int, Int32, Set

### Community 20 - "Navigation Shell"
Cohesion: 0.22
Nodes (8): ActivityView, AppShellView, .body, .detailView, .sidebarStatus, .statusBadge, .statusTint, Color

### Community 21 - "Brand and Positioning"
Cohesion: 0.25
Nodes (9): Build-Aware Memory Protection, Free Software, Local-Only, macOS, Memory Shield Icon, MemoryGuard, Memory Monitoring Dashboard, Open Source (+1 more)

### Community 22 - "Automation Workflow"
Cohesion: 0.33
Nodes (6): AutomationView, .policyDetails, .safetyFlow, Int, String, UInt64

### Community 23 - "Page Layout Components"
Cohesion: 0.36
Nodes (7): AboutView, .body, String, .body, PageHeader, .body, View

### Community 24 - "Protection Profile UI"
Cohesion: 0.25
Nodes (8): ProtectionProfileCard, .body, .cardBackground, .cardStroke, .icon, Bool, Color, Void

### Community 25 - "App Icon Assets"
Cohesion: 0.38
Nodes (7): Memory chip with six green cells, MemoryGuard app icon, White protective shield, Memory chip with six green cells, Memory protection, MemoryGuard app icon, White protective shield

### Community 26 - "Overview Dashboard"
Cohesion: 0.43
Nodes (5): OverviewView, .body, .memoryDetail, String, UInt64

### Community 27 - "Website Interactions"
Cohesion: 0.40
Nodes (5): nav, pressureLab, setNavigation(), toggle, toggleLabel

## Knowledge Gaps
- **151 isolated node(s):** `Darwin`, `.pausedGroupIDs`, `make-app.sh script`, `PackageDescription`, `.colorScheme` (+146 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **6 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `MemoryGuardProductModel` connect `Product Orchestration` to `Memory Domain Policies`, `macOS App Lifecycle`, `Protection Decision Logic`, `Reusable UI Components`, `SwiftUI Module Structure`, `Navigation Shell`, `Automation Workflow`, `Page Layout Components`, `Overview Dashboard`?**
  _High betweenness centrality (0.175) - this node is a cross-community bridge._
- **Why does `MemoryGuardApplicationController` connect `macOS App Lifecycle` to `Product Orchestration`, `SwiftUI Module Structure`?**
  _High betweenness centrality (0.068) - this node is a cross-community bridge._
- **Why does `MemorySnapshot` connect `Memory Domain Policies` to `Product Orchestration`, `Protection Decision Logic`, `System Sampling`?**
  _High betweenness centrality (0.056) - this node is a cross-community bridge._
- **Are the 8 inferred relationships involving `MemoryGuardProductModel` (e.g. with `MemoryGuardApplicationController` and `.observeModel()`) actually correct?**
  _`MemoryGuardProductModel` has 8 INFERRED edges - model-reasoned connections that need verification._
- **Are the 7 inferred relationships involving `MemorySnapshot` (e.g. with `MemoryGuardProductModel` and `.criticalPressurePausesNewestOfTwoBuilds()`) actually correct?**
  _`MemorySnapshot` has 7 INFERRED edges - model-reasoned connections that need verification._
- **What connects `Darwin`, `.pausedGroupIDs`, `make-app.sh script` to the rest of the system?**
  _151 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Product Orchestration` be split into smaller, more focused modules?**
  _Cohesion score 0.06271186440677966 - nodes in this community are weakly interconnected._