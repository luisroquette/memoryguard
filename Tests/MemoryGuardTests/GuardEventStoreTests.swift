import Foundation
import Testing
@testable import MemoryGuard

struct GuardEventStoreTests {
    @Test func eventHistoryRoundTripsAndClears() {
        let suiteName = "MemoryGuardTests.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suiteName)!
        defer { defaults.removePersistentDomain(forName: suiteName) }

        let events = [
            GuardEvent(kind: .intervention, message: "Pausa segura"),
            GuardEvent(kind: .recovery, message: "Retomada segura"),
        ]
        GuardEventStore.save(events, defaults: defaults)

        #expect(GuardEventStore.load(defaults: defaults) == events)
        GuardEventStore.clear(defaults: defaults)
        #expect(GuardEventStore.load(defaults: defaults).isEmpty)
    }

    @Test func eventHistoryIsCappedAtOneHundredItems() {
        let suiteName = "MemoryGuardTests.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suiteName)!
        defer { defaults.removePersistentDomain(forName: suiteName) }

        let events = (0..<125).map {
            GuardEvent(kind: .information, message: "Evento \($0)")
        }
        GuardEventStore.save(events, defaults: defaults)

        let loaded = GuardEventStore.load(defaults: defaults)
        #expect(loaded.count == 100)
        #expect(loaded.first?.message == "Evento 0")
        #expect(loaded.last?.message == "Evento 99")
    }

    @Test func preferenceOptionsHaveStableRawValues() {
        #expect(AppAppearance.system.rawValue == "system")
        #expect(SamplingInterval.five.rawValue == 5)
        #expect(SamplingInterval.thirty.rawValue == 30)
    }

    @Test @MainActor func modelPersistsIntoInjectedDefaultsAndDeduplicatesRapidEvents() {
        let suiteName = "MemoryGuardTests.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suiteName)!
        defer { defaults.removePersistentDomain(forName: suiteName) }

        let model = MemoryGuardProductModel(defaults: defaults, startsMonitoring: false)
        model.automaticRelief = false
        model.automaticRelief = false

        #expect(defaults.bool(forKey: "automaticRelief") == false)
        #expect(model.eventHistory.filter { $0.message == "Alívio automático desativado." }.count == 1)
        #expect(GuardEventStore.load(defaults: defaults) == model.eventHistory)
    }

    @Test @MainActor func clearingHistoryLeavesHistoryEmpty() {
        let suiteName = "MemoryGuardTests.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suiteName)!
        defer { defaults.removePersistentDomain(forName: suiteName) }

        let model = MemoryGuardProductModel(defaults: defaults, startsMonitoring: false)
        #expect(model.eventHistory.isEmpty == false)

        model.clearHistory()

        #expect(model.eventHistory.isEmpty)
        #expect(GuardEventStore.load(defaults: defaults).isEmpty)
        #expect(model.lastAction == "Histórico local limpo.")
    }
}
