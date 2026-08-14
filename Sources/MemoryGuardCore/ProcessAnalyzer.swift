import Foundation

public enum ProcessAnalyzer {
    public static func parseElapsed(_ value: String) -> Int? {
        let daySplit = value.split(separator: "-", maxSplits: 1).map(String.init)
        let clock = (daySplit.count == 2 ? daySplit[1] : daySplit[0])
            .split(separator: ":")
            .compactMap { Int($0) }
        guard clock.count == 2 || clock.count == 3 else { return nil }

        let days = daySplit.count == 2 ? Int(daySplit[0]) ?? 0 : 0
        let hours = clock.count == 3 ? clock[0] : 0
        let minutes = clock.count == 3 ? clock[1] : clock[0]
        let seconds = clock.count == 3 ? clock[2] : clock[1]
        return days * 86_400 + hours * 3_600 + minutes * 60 + seconds
    }

    public static func parsePS(_ output: String) -> [ProcessRecord] {
        output.split(separator: "\n").compactMap { rawLine in
            let fields = rawLine.split(
                maxSplits: 6,
                omittingEmptySubsequences: true,
                whereSeparator: { $0 == " " || $0 == "\t" }
            )
            guard fields.count == 7,
                  let pid = Int32(fields[0]),
                  let ppid = Int32(fields[1]),
                  let pgid = Int32(fields[2]),
                  let rssKB = UInt64(fields[3]),
                  let elapsed = parseElapsed(String(fields[5]))
            else { return nil }

            let (residentBytes, overflow) = rssKB.multipliedReportingOverflow(by: 1_024)
            guard !overflow else { return nil }

            return ProcessRecord(
                pid: pid,
                parentPID: ppid,
                processGroupID: pgid,
                residentBytes: residentBytes,
                elapsedSeconds: elapsed,
                state: String(fields[4]),
                command: String(fields[6])
            )
        }
    }

    public static func buildGroups(from records: [ProcessRecord]) -> [BuildGroup] {
        let grouped = Dictionary(grouping: records.filter { $0.processGroupID > 1 }) {
            $0.processGroupID
        }

        return grouped.compactMap { groupID, members in
            let matches = members.compactMap { process -> (label: String, elapsed: Int)? in
                guard let label = buildLabel(for: process.command) else { return nil }
                return (label, process.elapsedSeconds)
            }
            guard let oldestMatch = matches.max(by: { $0.elapsed < $1.elapsed }) else { return nil }

            let residentBytes = members.reduce(UInt64.zero) { partial, member in
                let (sum, overflow) = partial.addingReportingOverflow(member.residentBytes)
                return overflow ? .max : sum
            }

            return BuildGroup(
                id: groupID,
                residentBytes: residentBytes,
                elapsedSeconds: oldestMatch.elapsed,
                label: oldestMatch.label,
                isStopped: members.contains(where: \.isStopped)
            )
        }
        .sorted {
            if $0.residentBytes == $1.residentBytes {
                return $0.elapsedSeconds < $1.elapsedSeconds
            }
            return $0.residentBytes > $1.residentBytes
        }
    }

    public static func buildLabel(for command: String) -> String? {
        let tokens = command.split(whereSeparator: { $0 == " " || $0 == "\t" })
        guard let executable = tokens.first.map(String.init) else { return nil }
        let executableName = URL(fileURLWithPath: executable).lastPathComponent

        switch executableName {
        case "next-build":
            return "build Next.js"
        case "swift-frontend", "swift-build":
            return "build Swift"
        case "vitest":
            return "Vitest"
        case "playwright":
            return "Playwright"
        case "tsc":
            return "build TypeScript"
        case "next":
            return tokens.dropFirst().contains("build") ? "build Next.js" : nil
        case "node":
            guard tokens.count >= 2 else { return nil }
            let script = String(tokens[1])
            if script.contains("/node_modules/next/dist/bin/next"),
               tokens.dropFirst(2).contains("build") {
                return "build Next.js"
            }
            if script.contains("/node_modules/.bin/vitest") ||
                script.contains("/node_modules/vitest/") ||
                script.contains("/vitest/dist/workers") {
                return "Vitest"
            }
            if script.contains("/node_modules/.bin/playwright") ||
                script.contains("/node_modules/playwright/") ||
                script.contains("/node_modules/@playwright/test/") {
                return "Playwright"
            }
            if script.contains("/node_modules/.bin/tsc") ||
                script.contains("/node_modules/typescript/bin/tsc") ||
                script.contains("/node_modules/typescript/lib/tsc.js") {
                return "build TypeScript"
            }
            return nil
        default:
            return nil
        }
    }
}
