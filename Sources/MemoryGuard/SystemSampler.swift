import Foundation
import MemoryGuardCore

struct SystemSample: Sendable {
    let memory: MemorySnapshot
    let processes: [ProcessRecord]
}

enum SystemSamplerError: LocalizedError {
    case commandFailed(String)
    case invalidMemoryOutput

    var errorDescription: String? {
        switch self {
        case .commandFailed(let command): "Não foi possível executar \(command)."
        case .invalidMemoryOutput: "Não foi possível ler a pressão de memória do macOS."
        }
    }
}

enum SystemSampler {
    static func sample() async throws -> SystemSample {
        async let memoryOutput = run("/usr/bin/memory_pressure", [])
        async let swapOutput = run("/usr/sbin/sysctl", ["vm.swapusage"])
        async let pressureOutput = run("/usr/sbin/sysctl", [
            "-n", "kern.memorystatus_vm_pressure_level"
        ])
        async let psOutput = run("/bin/ps", [
            "-axo", "pid=,ppid=,pgid=,rss=,state=,etime=,command="
        ])

        let (memoryText, swapText, pressureText, processText) = try await (
            memoryOutput,
            swapOutput,
            pressureOutput,
            psOutput
        )

        guard let available = SystemOutputParser.availablePercent(memoryText) else {
            throw SystemSamplerError.invalidMemoryOutput
        }
        let swap = SystemOutputParser.swapUsage(swapText)
        return SystemSample(
            memory: MemorySnapshot(
                availablePercent: available,
                swapUsedBytes: swap.used,
                swapTotalBytes: swap.total,
                systemPressureLevel: SystemOutputParser.pressureLevel(pressureText)
            ),
            processes: ProcessAnalyzer.parsePS(processText)
        )
    }

    private static func run(_ executable: String, _ arguments: [String]) async throws -> String {
        try await Task.detached(priority: .utility) {
            let process = Process()
            let pipe = Pipe()
            process.executableURL = URL(fileURLWithPath: executable)
            process.arguments = arguments
            process.standardOutput = pipe
            process.standardError = FileHandle.nullDevice
            try process.run()
            // Drain while the child is alive. Reading only after termination can
            // deadlock when `ps` writes more than the pipe buffer.
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            process.waitUntilExit()
            guard process.terminationStatus == 0 else {
                throw SystemSamplerError.commandFailed(executable)
            }
            return String(decoding: data, as: UTF8.self)
        }.value
    }
}
