import AppKit
import Foundation
import MemoryGuardCore
import ServiceManagement

@MainActor
final class MemoryGuardProductModel: ObservableObject {
    @Published private(set) var snapshot = MemorySnapshot(
        availablePercent: 100,
        swapUsedBytes: 0,
        swapTotalBytes: 0
    )
    @Published private(set) var buildGroups: [BuildGroup] = []
    @Published private(set) var lastAction = "Iniciando monitoramento…"
    @Published private(set) var lastError: String?
    @Published private(set) var settingsError: String?
    @Published private(set) var isSampling = false
    @Published private(set) var launchAtLoginEnabled = false
    @Published private(set) var launchAtLoginNeedsApproval = false
    @Published private(set) var isUpdatingLaunchAtLogin = false
    @Published private(set) var hasCompletedSample = false
    @Published private(set) var lastUpdatedAt: Date?
    @Published private(set) var eventHistory: [GuardEvent]

    @Published var automaticRelief: Bool {
        didSet {
            defaults.set(automaticRelief, forKey: "automaticRelief")
            if !automaticRelief, pausedCount > 0 {
                resumeAll(reason: "Alívio automático desativado; builds retomados.")
            }
            recordEvent(
                kind: .settings,
                message: automaticRelief ? "Alívio automático ativado." : "Alívio automático desativado."
            )
        }
    }

    @Published var protectionProfile: ProtectionProfile {
        didSet {
            defaults.set(protectionProfile.rawValue, forKey: "protectionProfile")
            recoverySamples = 0
            recordEvent(kind: .settings, message: "Perfil alterado para \(protectionProfile.title).")
        }
    }

    @Published var appearance: AppAppearance {
        didSet {
            defaults.set(appearance.rawValue, forKey: "appearance")
        }
    }

    @Published var samplingInterval: SamplingInterval {
        didSet {
            defaults.set(samplingInterval.rawValue, forKey: "samplingInterval")
            recordEvent(kind: .settings, message: "Frequência alterada para \(samplingInterval.title).")
        }
    }

    private let controller = BuildController()
    private let defaults: UserDefaults
    private var monitoringTask: Task<Void, Never>?
    private var recoverySamples = 0
    private var lastLoggedError: String?

    init(defaults: UserDefaults = .standard, startsMonitoring: Bool = true) {
        self.defaults = defaults
        protectionProfile = defaults.string(forKey: "protectionProfile")
            .flatMap(ProtectionProfile.init(rawValue:)) ?? .balanced
        appearance = defaults.string(forKey: "appearance")
            .flatMap(AppAppearance.init(rawValue:)) ?? .system
        samplingInterval = SamplingInterval(
            rawValue: defaults.integer(forKey: "samplingInterval")
        ) ?? .five
        automaticRelief = defaults.object(forKey: "automaticRelief") as? Bool ?? true
        eventHistory = GuardEventStore.load(defaults: defaults)
        launchAtLoginEnabled = defaults.bool(forKey: "launchAtLoginEnabled")
        recordEvent(kind: .information, message: "Monitoramento iniciado.")
        if startsMonitoring {
            start()
            refreshLaunchAtLoginStatus()
        }
    }

    deinit {
        monitoringTask?.cancel()
        controller.resumeAll()
    }

    var pausedCount: Int { controller.pausedGroupIDs.count }
    var policy: ReliefPolicy { protectionProfile.policy }
    var heavyBuildCount: Int {
        buildGroups.filter { $0.isHeavy(minimumBytes: policy.minimumGroupBytes) }.count
    }

    var appVersion: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "dev"
    }

    func setLaunchAtLogin(_ enabled: Bool) {
        guard !isUpdatingLaunchAtLogin else { return }
        isUpdatingLaunchAtLogin = true
        settingsError = nil

        Task {
            let result = await Self.updateLaunchAtLogin(enabled)
            isUpdatingLaunchAtLogin = false
            switch result {
            case .success(let state):
                applyLaunchAtLoginState(state)
                lastAction = switch state {
                case .enabled: "Inicialização automática ativada."
                case .disabled: "Inicialização automática desativada."
                case .requiresApproval: "Item de início aguardando aprovação do macOS."
                }
                recordEvent(kind: .settings, message: lastAction)
            case .failure(let message):
                settingsError = "Login item: \(message)"
                recordEvent(kind: .error, message: settingsError ?? "Falha no item de início.")
            }
        }
    }

    func start() {
        monitoringTask?.cancel()
        monitoringTask = Task { [weak self] in
            while !Task.isCancelled {
                await self?.sampleNow()
                let seconds = self?.samplingInterval.rawValue ?? 5
                try? await Task.sleep(for: .seconds(seconds))
            }
        }
    }

    func sampleNow() async {
        guard !isSampling else { return }
        isSampling = true
        defer { isSampling = false }

        do {
            let sample = try await SystemSampler.sample()
            snapshot = sample.memory
            buildGroups = ProcessAnalyzer.buildGroups(from: sample.processes)
            hasCompletedSample = true
            lastUpdatedAt = Date()
            lastError = nil
            lastLoggedError = nil

            if policy.isRecoverySample(snapshot) {
                recoverySamples += 1
            } else {
                recoverySamples = 0
            }

            guard automaticRelief else {
                if pausedCount > 0 { resumeAll(reason: "Alívio automático desativado.") }
                return
            }

            let decision = policy.decide(
                snapshot: snapshot,
                activeGroups: buildGroups,
                pausedGroupIDs: controller.pausedGroupIDs,
                recoverySamples: recoverySamples
            )
            try apply(decision)
        } catch {
            lastError = error.localizedDescription
            if lastLoggedError != lastError {
                recordEvent(kind: .error, message: error.localizedDescription)
                lastLoggedError = lastError
            }
        }
    }

    func resumeAll(reason: String = "Builds retomados manualmente.") {
        let resumedCount = controller.resumeAll()
        guard resumedCount > 0 else {
            lastAction = "Nenhum build está pausado."
            return
        }
        lastAction = reason
        recordEvent(kind: .recovery, message: reason)
        objectWillChange.send()
    }

    func clearHistory() {
        eventHistory.removeAll()
        GuardEventStore.clear(defaults: defaults)
        lastAction = "Histórico local limpo."
    }

    func restoreDefaults() {
        automaticRelief = true
        protectionProfile = .balanced
        appearance = .system
        samplingInterval = .five
        lastAction = "Preferências restauradas."
    }

    func copyDiagnostics() {
        let swapUsed = ByteCountFormatter.string(
            fromByteCount: Int64(snapshot.swapUsedBytes),
            countStyle: .memory
        )
        let diagnostic = """
        MemoryGuard \(appVersion)
        Memória disponível: \(snapshot.availablePercent)%
        Swap usado: \(swapUsed)
        Pressão do kernel: \(snapshot.systemPressureLevel)
        Builds reconhecidos: \(buildGroups.count)
        Builds pausados: \(pausedCount)
        Perfil: \(protectionProfile.title)
        Alívio automático: \(automaticRelief ? "ativado" : "desativado")
        """
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(diagnostic, forType: .string)
        lastAction = "Diagnóstico copiado sem comandos ou dados sensíveis."
        recordEvent(kind: .information, message: lastAction)
    }

    func terminateApp() {
        NSApplication.shared.terminate(nil)
    }

    func prepareForTermination() {
        guard pausedCount > 0 else { return }
        resumeAll(reason: "MemoryGuard encerrado; builds retomados.")
    }

    private func apply(_ decision: ReliefDecision) throws {
        switch decision.action {
        case .none:
            lastAction = decision.reason
        case .pause(let groupID):
            try controller.pause(groupID: groupID)
            lastAction = decision.reason
            recordEvent(kind: .intervention, message: decision.reason)
            objectWillChange.send()
        case .resumeAll:
            resumeAll(reason: decision.reason)
        }
    }

    private func recordEvent(kind: GuardEventKind, message: String) {
        if let first = eventHistory.first,
           first.kind == kind,
           first.message == message,
           Date().timeIntervalSince(first.date) < 2 {
            return
        }
        eventHistory.insert(GuardEvent(kind: kind, message: message), at: 0)
        if eventHistory.count > 100 {
            eventHistory.removeLast(eventHistory.count - 100)
        }
        GuardEventStore.save(eventHistory, defaults: defaults)
    }

    private func refreshLaunchAtLoginStatus() {
        Task {
            applyLaunchAtLoginState(await Self.readLaunchAtLoginStatus())
        }
    }

    private func applyLaunchAtLoginState(_ state: LaunchAtLoginState) {
        launchAtLoginEnabled = state == .enabled
        launchAtLoginNeedsApproval = state == .requiresApproval
        defaults.set(launchAtLoginEnabled, forKey: "launchAtLoginEnabled")
    }

    private nonisolated static func readLaunchAtLoginStatus() async -> LaunchAtLoginState {
        await Task.detached(priority: .utility) {
            launchAtLoginState()
        }.value
    }

    private nonisolated static func updateLaunchAtLogin(_ enabled: Bool) async -> LaunchAtLoginResult {
        await Task.detached(priority: .userInitiated) {
            do {
                if enabled {
                    try SMAppService.mainApp.register()
                } else {
                    try SMAppService.mainApp.unregister()
                }
                return .success(launchAtLoginState())
            } catch {
                return .failure(error.localizedDescription)
            }
        }.value
    }

    private enum LaunchAtLoginResult: Sendable {
        case success(LaunchAtLoginState)
        case failure(String)
    }

    private enum LaunchAtLoginState: Sendable {
        case enabled
        case disabled
        case requiresApproval
    }

    private nonisolated static func launchAtLoginState() -> LaunchAtLoginState {
        switch SMAppService.mainApp.status {
        case .enabled: .enabled
        case .requiresApproval: .requiresApproval
        default: .disabled
        }
    }
}
