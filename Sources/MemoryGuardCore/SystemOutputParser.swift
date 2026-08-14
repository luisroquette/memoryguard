import Foundation

public enum SystemOutputParser {
    public static func availablePercent(_ output: String) -> Int? {
        let prefix = "System-wide memory free percentage:"
        guard let line = output.split(separator: "\n").last(where: { $0.contains(prefix) }) else {
            return nil
        }
        return line.split(separator: ":").last
            .flatMap { $0.trimmingCharacters(in: .whitespaces).split(separator: "%").first }
            .flatMap { Int($0) }
            .map { min(100, max(0, $0)) }
    }

    public static func swapUsage(_ output: String) -> (used: UInt64, total: UInt64) {
        func megabytes(after marker: String) -> UInt64 {
            guard let range = output.range(of: marker) else { return 0 }
            let suffix = output[range.upperBound...]
            let token = suffix.trimmingCharacters(in: .whitespaces).split(separator: "M").first ?? "0"
            let value = Double(token.trimmingCharacters(in: .whitespaces)) ?? 0
            return UInt64(max(0, value) * 1_024 * 1_024)
        }
        return (megabytes(after: "used ="), megabytes(after: "total ="))
    }

    public static func pressureLevel(_ output: String) -> Int {
        Int(output.trimmingCharacters(in: .whitespacesAndNewlines)) ?? 1
    }
}
