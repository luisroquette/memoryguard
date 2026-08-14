import Foundation

public enum PressureLevel: String, Sendable {
    case normal
    case elevated
    case critical
}

public struct MemorySnapshot: Sendable, Equatable {
    public let availablePercent: Int
    public let swapUsedBytes: UInt64
    public let swapTotalBytes: UInt64
    public let systemPressureLevel: Int
    public let capturedAt: Date

    public init(
        availablePercent: Int,
        swapUsedBytes: UInt64,
        swapTotalBytes: UInt64,
        systemPressureLevel: Int = 1,
        capturedAt: Date = Date()
    ) {
        self.availablePercent = availablePercent
        self.swapUsedBytes = swapUsedBytes
        self.swapTotalBytes = swapTotalBytes
        self.systemPressureLevel = systemPressureLevel
        self.capturedAt = capturedAt
    }

    public var swapFreeBytes: UInt64 {
        swapTotalBytes > swapUsedBytes ? swapTotalBytes - swapUsedBytes : 0
    }

    public var level: PressureLevel {
        if systemPressureLevel >= 4 || availablePercent <= 12 { return .critical }
        if systemPressureLevel >= 2 || availablePercent <= 24 { return .elevated }
        return .normal
    }
}

public struct ProcessRecord: Sendable, Equatable {
    public let pid: Int32
    public let parentPID: Int32
    public let processGroupID: Int32
    public let residentBytes: UInt64
    public let elapsedSeconds: Int
    public let state: String
    public let command: String

    public init(
        pid: Int32,
        parentPID: Int32,
        processGroupID: Int32,
        residentBytes: UInt64,
        elapsedSeconds: Int,
        state: String,
        command: String
    ) {
        self.pid = pid
        self.parentPID = parentPID
        self.processGroupID = processGroupID
        self.residentBytes = residentBytes
        self.elapsedSeconds = elapsedSeconds
        self.state = state
        self.command = command
    }

    public var isStopped: Bool { state.contains("T") }
}

public struct BuildGroup: Sendable, Identifiable, Equatable {
    public let id: Int32
    public let residentBytes: UInt64
    public let elapsedSeconds: Int
    public let label: String
    public let isStopped: Bool

    public init(
        id: Int32,
        residentBytes: UInt64,
        elapsedSeconds: Int,
        label: String,
        isStopped: Bool
    ) {
        self.id = id
        self.residentBytes = residentBytes
        self.elapsedSeconds = elapsedSeconds
        self.label = label
        self.isStopped = isStopped
    }

    public func isHeavy(minimumBytes: UInt64) -> Bool {
        residentBytes >= minimumBytes
    }
}

public struct ReliefDecision: Sendable, Equatable {
    public enum Action: Sendable, Equatable {
        case none
        case pause(Int32)
        case resumeAll
    }

    public let action: Action
    public let reason: String

    public init(action: Action, reason: String) {
        self.action = action
        self.reason = reason
    }
}
