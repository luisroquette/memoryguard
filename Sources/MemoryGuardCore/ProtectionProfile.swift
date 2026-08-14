import Foundation

public enum ProtectionProfile: String, CaseIterable, Codable, Identifiable, Sendable {
    case balanced
    case proactive
    case conservative

    public var id: String { rawValue }

    public var title: String {
        switch self {
        case .balanced: "Equilibrado"
        case .proactive: "Proativo"
        case .conservative: "Conservador"
        }
    }

    public var summary: String {
        switch self {
        case .balanced:
            "Intervém apenas quando pressão e swap indicam risco real."
        case .proactive:
            "Age mais cedo para reduzir travamentos durante trabalho pesado."
        case .conservative:
            "Espera uma condição crítica antes de serializar builds."
        }
    }

    public var policy: ReliefPolicy {
        switch self {
        case .balanced:
            ReliefPolicy()
        case .proactive:
            ReliefPolicy(
                criticalAvailablePercent: 18,
                recoveryAvailablePercent: 30,
                minimumGroupBytes: 192 * 1_024 * 1_024,
                lowSwapFreeBytes: 1_024 * 1_024 * 1_024,
                recoverySwapFreeBytes: 1_536 * 1_024 * 1_024
            )
        case .conservative:
            ReliefPolicy(
                criticalAvailablePercent: 8,
                recoveryAvailablePercent: 20,
                minimumGroupBytes: 384 * 1_024 * 1_024,
                lowSwapFreeBytes: 256 * 1_024 * 1_024,
                recoverySwapFreeBytes: 768 * 1_024 * 1_024
            )
        }
    }
}
