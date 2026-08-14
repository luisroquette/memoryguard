import Darwin
import Foundation

// Every mutable collection is protected by `lock`; signals operate only on copied IDs.
final class BuildController: @unchecked Sendable {
    private let lock = NSLock()
    private var paused: Set<Int32> = []
    private var watchdogs: [Int32: Process] = [:]

    var pausedGroupIDs: Set<Int32> {
        lock.withLock { paused }
    }

    func pause(groupID: Int32) throws {
        guard groupID > 1, groupID != getpgrp() else { return }
        guard !pausedGroupIDs.contains(groupID) else { return }
        let watchdog = makeWatchdog(for: groupID)
        try watchdog.run()

        guard kill(-groupID, SIGSTOP) == 0 else {
            watchdog.terminate()
            throw POSIXError(POSIXErrorCode(rawValue: errno) ?? .ESRCH)
        }

        lock.withLock {
            paused.insert(groupID)
            watchdogs[groupID] = watchdog
        }
    }

    func resume(groupID: Int32) {
        guard groupID > 1 else { return }
        _ = kill(-groupID, SIGCONT)
        lock.withLock {
            watchdogs.removeValue(forKey: groupID)?.terminate()
            paused.remove(groupID)
        }
    }

    @discardableResult
    func resumeAll() -> Int {
        let groups = pausedGroupIDs
        groups.forEach(resume(groupID:))
        return groups.count
    }

    private func makeWatchdog(for groupID: Int32) -> Process {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/bin/zsh")
        process.arguments = [
            "-c",
            "while /bin/kill -0 \(getpid()) 2>/dev/null; do /bin/sleep 2; done; /bin/kill -CONT -- -\(groupID) 2>/dev/null || true",
        ]
        process.standardOutput = FileHandle.nullDevice
        process.standardError = FileHandle.nullDevice
        return process
    }
}
