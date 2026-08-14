import Foundation

enum GuardEventKind: String, Codable, Sendable {
    case information
    case intervention
    case recovery
    case settings
    case error
}

struct GuardEvent: Codable, Identifiable, Sendable, Equatable {
    let id: UUID
    let date: Date
    let kind: GuardEventKind
    let message: String

    init(
        id: UUID = UUID(),
        date: Date = Date(),
        kind: GuardEventKind,
        message: String
    ) {
        self.id = id
        self.date = date
        self.kind = kind
        self.message = message
    }
}

enum GuardEventStore {
    private static let key = "guardEventHistory"
    private static let limit = 100

    static func load(defaults: UserDefaults = .standard) -> [GuardEvent] {
        guard let data = defaults.data(forKey: key),
              let events = try? JSONDecoder().decode([GuardEvent].self, from: data) else {
            return []
        }
        return Array(events.prefix(limit))
    }

    static func save(_ events: [GuardEvent], defaults: UserDefaults = .standard) {
        let trimmed = Array(events.prefix(limit))
        guard let data = try? JSONEncoder().encode(trimmed) else { return }
        defaults.set(data, forKey: key)
    }

    static func clear(defaults: UserDefaults = .standard) {
        defaults.removeObject(forKey: key)
    }
}
