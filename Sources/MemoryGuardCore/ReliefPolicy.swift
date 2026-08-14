import Foundation

public struct ReliefPolicy: Sendable {
    public let criticalAvailablePercent: Int
    public let recoveryAvailablePercent: Int
    public let minimumGroupBytes: UInt64
    public let lowSwapFreeBytes: UInt64
    public let recoverySwapFreeBytes: UInt64

    public init(
        criticalAvailablePercent: Int = 12,
        recoveryAvailablePercent: Int = 25,
        minimumGroupBytes: UInt64 = 256 * 1_024 * 1_024,
        lowSwapFreeBytes: UInt64 = 512 * 1_024 * 1_024,
        recoverySwapFreeBytes: UInt64 = 1_024 * 1_024 * 1_024
    ) {
        self.criticalAvailablePercent = criticalAvailablePercent
        self.recoveryAvailablePercent = recoveryAvailablePercent
        self.minimumGroupBytes = minimumGroupBytes
        self.lowSwapFreeBytes = lowSwapFreeBytes
        self.recoverySwapFreeBytes = recoverySwapFreeBytes
    }

    public func decide(
        snapshot: MemorySnapshot,
        activeGroups: [BuildGroup],
        pausedGroupIDs: Set<Int32>,
        recoverySamples: Int
    ) -> ReliefDecision {
        if !pausedGroupIDs.isEmpty,
           isRecoverySample(snapshot),
           recoverySamples >= 2 {
            return ReliefDecision(
                action: .resumeAll,
                reason: "Memória recuperada: \(snapshot.availablePercent)% disponível."
            )
        }

        let swapIsKnown = snapshot.swapTotalBytes > 0
        let kernelIsCritical = snapshot.systemPressureLevel >= 4
        let warningWithLowSwap = snapshot.systemPressureLevel >= 2 &&
            swapIsKnown && snapshot.swapFreeBytes <= lowSwapFreeBytes
        let requiresRelief = snapshot.availablePercent <= criticalAvailablePercent ||
            kernelIsCritical || warningWithLowSwap
        guard requiresRelief else {
            return ReliefDecision(action: .none, reason: "Pressão de memória segura.")
        }

        let candidates = activeGroups.filter {
            !$0.isStopped &&
            !pausedGroupIDs.contains($0.id) &&
            $0.residentBytes >= minimumGroupBytes
        }

        guard candidates.count >= 2 else {
            return ReliefDecision(
                action: .none,
                reason: "Pressão crítica, mas há menos de dois builds pesados."
            )
        }

        // Pause the newest build. The older build can finish and free memory sooner.
        guard let newest = candidates.min(by: { $0.elapsedSeconds < $1.elapsedSeconds }) else {
            return ReliefDecision(action: .none, reason: "Nenhum build seguro para pausar.")
        }
        return ReliefDecision(
            action: .pause(newest.id),
            reason: "Pausando temporariamente o \(newest.label) mais novo."
        )
    }

    public func isRecoverySample(_ snapshot: MemorySnapshot) -> Bool {
        let swapIsKnown = snapshot.swapTotalBytes > 0
        let swapRecovered = !swapIsKnown || snapshot.swapFreeBytes >= recoverySwapFreeBytes
        return snapshot.availablePercent >= recoveryAvailablePercent &&
            snapshot.systemPressureLevel < 4 &&
            swapRecovered
    }
}
