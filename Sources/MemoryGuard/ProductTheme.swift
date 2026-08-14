import SwiftUI
import MemoryGuardCore

enum AppSection: String, CaseIterable, Identifiable {
    case overview
    case activity
    case automation
    case settings
    case about

    var id: String { rawValue }

    var title: String {
        switch self {
        case .overview: "Visão Geral"
        case .activity: "Atividade"
        case .automation: "Automação"
        case .settings: "Ajustes"
        case .about: "Sobre"
        }
    }

    var icon: String {
        switch self {
        case .overview: "square.grid.2x2.fill"
        case .activity: "waveform.path.ecg"
        case .automation: "shield.lefthalf.filled"
        case .settings: "slider.horizontal.3"
        case .about: "info.circle"
        }
    }
}

extension PressureLevel {
    var color: Color {
        switch self {
        case .normal: .green
        case .elevated: .orange
        case .critical: .red
        }
    }

    var title: String {
        switch self {
        case .normal: "Saudável"
        case .elevated: "Elevada"
        case .critical: "Crítica"
        }
    }

    var icon: String {
        switch self {
        case .normal: "checkmark.shield.fill"
        case .elevated: "gauge.with.dots.needle.67percent"
        case .critical: "exclamationmark.shield.fill"
        }
    }
}

struct PageHeader: View {
    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.largeTitle.bold())
                .accessibilityAddTraits(.isHeader)
            Text(subtitle)
                .font(.body)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct MGCard<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(18)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.primary.opacity(0.045), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(.primary.opacity(0.07), lineWidth: 1)
            }
    }
}

struct MetricTile: View {
    let icon: String
    let value: String
    let label: String
    let detail: String
    let tint: Color

    var body: some View {
        MGCard {
            VStack(alignment: .leading, spacing: 14) {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(tint)
                    .frame(width: 34, height: 34)
                    .background(tint.opacity(0.14), in: RoundedRectangle(cornerRadius: 9))
                    .accessibilityHidden(true)

                VStack(alignment: .leading, spacing: 3) {
                    Text(value)
                        .font(.system(.title2, design: .rounded).bold().monospacedDigit())
                        .lineLimit(1)
                        .minimumScaleFactor(0.75)
                    Text(label)
                        .font(.subheadline.weight(.medium))
                    Text(detail)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
            }
        }
        .accessibilityElement(children: .combine)
    }
}

struct SectionTitle: View {
    let title: String
    let detail: String?

    init(_ title: String, detail: String? = nil) {
        self.title = title
        self.detail = detail
    }

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(title)
                .font(.headline)
            Spacer()
            if let detail {
                Text(detail)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

struct BuildRow: View {
    let group: BuildGroup
    let minimumGroupBytes: UInt64

    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(group.isStopped ? Color.orange : Color.green)
                .frame(width: 9, height: 9)
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 2) {
                Text(group.label)
                    .font(.subheadline.weight(.medium))
                Text("Grupo \(group.id) · \(duration(group.elapsedSeconds))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 2) {
                Text(group.isStopped ? "Pausado" : "Ativo")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(group.isStopped ? .orange : .green)
                Text("\(weightLabel) · \(bytes(group.residentBytes))")
                    .font(.caption.monospacedDigit())
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
        .accessibilityElement(children: .combine)
    }

    private var weightLabel: String {
        group.isHeavy(minimumBytes: minimumGroupBytes) ? "Pesado" : "Abaixo do limite"
    }

    private func bytes(_ value: UInt64) -> String {
        ByteCountFormatter.string(fromByteCount: Int64(value), countStyle: .memory)
    }

    private func duration(_ seconds: Int) -> String {
        if seconds >= 3_600 { return "\(seconds / 3_600)h \((seconds % 3_600) / 60)min" }
        if seconds >= 60 { return "\(seconds / 60)min" }
        return "\(seconds)s"
    }
}

struct EventRow: View {
    let event: GuardEvent

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(tint)
                .frame(width: 28, height: 28)
                .background(tint.opacity(0.12), in: Circle())
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 3) {
                Text(event.message)
                    .font(.subheadline)
                Text(event.date.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding(.vertical, 3)
        .accessibilityElement(children: .combine)
    }

    private var icon: String {
        switch event.kind {
        case .information: "info.circle.fill"
        case .intervention: "pause.circle.fill"
        case .recovery: "play.circle.fill"
        case .settings: "slider.horizontal.3"
        case .error: "exclamationmark.triangle.fill"
        }
    }

    private var tint: Color {
        switch event.kind {
        case .information: .blue
        case .intervention: .orange
        case .recovery: .green
        case .settings: .purple
        case .error: .red
        }
    }
}

struct EmptyState: View {
    let icon: String
    let title: String
    let detail: String

    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 30))
                .foregroundStyle(.secondary)
                .accessibilityHidden(true)
            Text(title)
                .font(.headline)
            Text(detail)
                .font(.callout)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 28)
        .accessibilityElement(children: .combine)
    }
}
