import Testing
@testable import MemoryGuardCore

struct MemoryGuardCoreTests {
    @Test func parsesProcessSnapshot() {
        let output = """
         100 50 100 512000 R 00:15 next-build (v16.3.0)
         101 100 100 64000 S 00:14 node helper
         200 60 200 300000 T 01:02 node /tmp/node_modules/.bin/vitest run
        """
        let records = ProcessAnalyzer.parsePS(output)
        let groups = ProcessAnalyzer.buildGroups(from: records)

        #expect(records.count == 3)
        #expect(groups.count == 2)
        #expect(groups.first?.label == "build Next.js")
        #expect(groups.last?.isStopped == true)
    }

    @Test func criticalPressurePausesNewestOfTwoBuilds() {
        let policy = ReliefPolicy(minimumGroupBytes: 1)
        let oldBuild = BuildGroup(
            id: 10,
            residentBytes: 500,
            elapsedSeconds: 100,
            label: "build Next.js",
            isStopped: false
        )
        let newBuild = BuildGroup(
            id: 20,
            residentBytes: 400,
            elapsedSeconds: 20,
            label: "build Swift",
            isStopped: false
        )
        let snapshot = MemorySnapshot(
            availablePercent: 8,
            swapUsedBytes: 0,
            swapTotalBytes: 0
        )

        let decision = policy.decide(
            snapshot: snapshot,
            activeGroups: [oldBuild, newBuild],
            pausedGroupIDs: [],
            recoverySamples: 0
        )
        #expect(decision.action == .pause(20))
    }

    @Test func neverPausesTheOnlyBuild() {
        let policy = ReliefPolicy(minimumGroupBytes: 1)
        let build = BuildGroup(
            id: 10,
            residentBytes: 500,
            elapsedSeconds: 10,
            label: "build Next.js",
            isStopped: false
        )
        let snapshot = MemorySnapshot(
            availablePercent: 5,
            swapUsedBytes: 0,
            swapTotalBytes: 0
        )

        let decision = policy.decide(
            snapshot: snapshot,
            activeGroups: [build],
            pausedGroupIDs: [],
            recoverySamples: 0
        )
        #expect(decision.action == .none)
    }

    @Test func resumesAfterTwoHealthySamples() {
        let policy = ReliefPolicy()
        let snapshot = MemorySnapshot(
            availablePercent: 40,
            swapUsedBytes: 0,
            swapTotalBytes: 0
        )
        let decision = policy.decide(
            snapshot: snapshot,
            activeGroups: [],
            pausedGroupIDs: [20],
            recoverySamples: 2
        )
        #expect(decision.action == .resumeAll)
    }

    @Test func doesNotCountRamOnlyAsFullRecovery() {
        let policy = ReliefPolicy()
        let lowSwap = MemorySnapshot(
            availablePercent: 40,
            swapUsedBytes: 7_900 * 1_024 * 1_024,
            swapTotalBytes: 8_192 * 1_024 * 1_024,
            systemPressureLevel: 2
        )
        let criticalKernel = MemorySnapshot(
            availablePercent: 40,
            swapUsedBytes: 0,
            swapTotalBytes: 0,
            systemPressureLevel: 4
        )

        #expect(policy.isRecoverySample(lowSwap) == false)
        #expect(policy.isRecoverySample(criticalKernel) == false)
    }

    @Test func parsesKernelAndSwapOutputs() {
        let memory = "System-wide memory free percentage: 37%\n"
        let swap = "vm.swapusage: total = 9216.00M  used = 7567.25M  free = 1648.75M"

        #expect(SystemOutputParser.availablePercent(memory) == 37)
        #expect(SystemOutputParser.pressureLevel("2\n") == 2)
        #expect(SystemOutputParser.swapUsage(swap).total == 9_663_676_416)
        #expect(SystemOutputParser.swapUsage(swap).used == 7_934_836_736)
    }

    @Test func ignoresCommandsThatOnlyMentionBuildMarkers() {
        #expect(ProcessAnalyzer.buildLabel(for: "rg next-build|swift-frontend|vitest") == nil)
        #expect(ProcessAnalyzer.buildLabel(for: "/bin/zsh -c echo next-build") == nil)
        #expect(ProcessAnalyzer.buildLabel(for: "/tmp/next-build (v16.3.0)") == "build Next.js")
    }

    @Test func recognizesCommonNodeBuildEntrypoints() {
        #expect(ProcessAnalyzer.buildLabel(for: "node /tmp/node_modules/next/dist/bin/next build") == "build Next.js")
        #expect(ProcessAnalyzer.buildLabel(for: "node /tmp/node_modules/vitest/vitest.mjs run") == "Vitest")
        #expect(ProcessAnalyzer.buildLabel(for: "node /tmp/node_modules/@playwright/test/cli.js test") == "Playwright")
        #expect(ProcessAnalyzer.buildLabel(for: "node /tmp/node_modules/typescript/lib/tsc.js -b") == "build TypeScript")
        #expect(ProcessAnalyzer.buildLabel(for: "node /tmp/node_modules/next/dist/bin/next dev") == nil)
    }

    @Test func buildAgeUsesRecognizedProcessInsteadOfNewestHelper() {
        let records = [
            ProcessRecord(pid: 10, parentPID: 1, processGroupID: 10, residentBytes: 400, elapsedSeconds: 120, state: "S", command: "next-build"),
            ProcessRecord(pid: 11, parentPID: 10, processGroupID: 10, residentBytes: 100, elapsedSeconds: 2, state: "S", command: "node helper"),
        ]

        #expect(ProcessAnalyzer.buildGroups(from: records).first?.elapsedSeconds == 120)
    }

    @Test func parsesLongElapsedTimes() {
        #expect(ProcessAnalyzer.parseElapsed("03:05") == 185)
        #expect(ProcessAnalyzer.parseElapsed("02:03:05") == 7_385)
        #expect(ProcessAnalyzer.parseElapsed("2-02:03:05") == 180_185)
        #expect(ProcessAnalyzer.parseElapsed("invalid") == nil)
    }

    @Test func warningAndExhaustedSwapTriggersRelief() {
        let policy = ReliefPolicy(minimumGroupBytes: 1)
        let groups = [
            BuildGroup(id: 10, residentBytes: 500, elapsedSeconds: 100, label: "build Next.js", isStopped: false),
            BuildGroup(id: 20, residentBytes: 400, elapsedSeconds: 20, label: "build Swift", isStopped: false),
        ]
        let snapshot = MemorySnapshot(
            availablePercent: 40,
            swapUsedBytes: 7_900 * 1_024 * 1_024,
            swapTotalBytes: 8_192 * 1_024 * 1_024,
            systemPressureLevel: 2
        )

        let decision = policy.decide(
            snapshot: snapshot,
            activeGroups: groups,
            pausedGroupIDs: [],
            recoverySamples: 0
        )
        #expect(decision.action == .pause(20))
    }

    @Test func oldSwapAloneDoesNotPauseBuilds() {
        let policy = ReliefPolicy(minimumGroupBytes: 1)
        let groups = [
            BuildGroup(id: 10, residentBytes: 500, elapsedSeconds: 100, label: "build Next.js", isStopped: false),
            BuildGroup(id: 20, residentBytes: 400, elapsedSeconds: 20, label: "build Swift", isStopped: false),
        ]
        let snapshot = MemorySnapshot(
            availablePercent: 40,
            swapUsedBytes: 7_000 * 1_024 * 1_024,
            swapTotalBytes: 9_216 * 1_024 * 1_024,
            systemPressureLevel: 2
        )

        let decision = policy.decide(
            snapshot: snapshot,
            activeGroups: groups,
            pausedGroupIDs: [],
            recoverySamples: 0
        )
        #expect(decision.action == .none)
    }

    @Test func protectionProfilesHaveOrderedThresholds() {
        let proactive = ProtectionProfile.proactive.policy
        let balanced = ProtectionProfile.balanced.policy
        let conservative = ProtectionProfile.conservative.policy

        #expect(proactive.criticalAvailablePercent > balanced.criticalAvailablePercent)
        #expect(balanced.criticalAvailablePercent > conservative.criticalAvailablePercent)
        #expect(proactive.lowSwapFreeBytes > balanced.lowSwapFreeBytes)
        #expect(balanced.lowSwapFreeBytes > conservative.lowSwapFreeBytes)
        #expect(proactive.minimumGroupBytes < balanced.minimumGroupBytes)
        #expect(balanced.minimumGroupBytes < conservative.minimumGroupBytes)
    }

    @Test func allProfilesPreserveMinimumSafetyContract() {
        for profile in ProtectionProfile.allCases {
            let policy = profile.policy
            #expect(policy.minimumGroupBytes >= 192 * 1_024 * 1_024)
            #expect(policy.recoveryAvailablePercent > policy.criticalAvailablePercent)
            #expect(policy.recoverySwapFreeBytes > policy.lowSwapFreeBytes)
        }
    }
}
