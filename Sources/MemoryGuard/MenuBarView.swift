import AppKit
import SwiftUI

struct MenuBarView: View {
    @ObservedObject var model: MemoryGuardProductModel
    let showDashboard: @MainActor () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                Image(systemName: model.snapshot.level.icon)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundStyle(model.snapshot.level.color)
                    .frame(width: 42, height: 42)
                    .background(model.snapshot.level.color.opacity(0.13), in: RoundedRectangle(cornerRadius: 11))
                VStack(alignment: .leading, spacing: 2) {
                    Text("MemoryGuard").font(.headline)
                    Text(model.hasCompletedSample ? "Memória \(model.snapshot.level.title.lowercased())" : "Lendo o sistema…")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer()
            }

            HStack(spacing: 10) {
                compactMetric(model.hasCompletedSample ? "\(model.snapshot.availablePercent)%" : "—", "Disponível")
                compactMetric(model.hasCompletedSample ? bytes(model.snapshot.swapUsedBytes) : "—", "Swap")
                compactMetric("\(model.heavyBuildCount)/\(model.buildGroups.count)", "Pesados / total")
            }

            Toggle("Alívio automático", isOn: $model.automaticRelief)
                .toggleStyle(.switch)

            if !model.buildGroups.isEmpty {
                VStack(spacing: 8) {
                    ForEach(model.buildGroups.prefix(3)) { group in
                        BuildRow(
                            group: group,
                            minimumGroupBytes: model.policy.minimumGroupBytes
                        )
                    }
                }
            }

            Text(model.lastAction)
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(2)

            Divider()

            HStack {
                Button("Abrir MemoryGuard") {
                    showDashboard()
                }
                .buttonStyle(.borderedProminent)

                Button {
                    Task { await model.sampleNow() }
                } label: {
                    Image(systemName: "arrow.clockwise")
                }
                .help("Verificar agora")
                .disabled(model.isSampling)
                .accessibilityLabel("Verificar memória agora")

                Spacer()
                Button("Sair") { model.terminateApp() }
            }
        }
        .padding(18)
        .frame(width: 370)
        .background(.ultraThinMaterial)
        .preferredColorScheme(model.appearance.colorScheme)
    }

    private func compactMetric(_ value: String, _ label: String) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(value)
                .font(.headline.monospacedDigit())
                .lineLimit(1)
                .minimumScaleFactor(0.75)
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .padding(10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.primary.opacity(0.05), in: RoundedRectangle(cornerRadius: 10))
    }

    private func bytes(_ value: UInt64) -> String {
        ByteCountFormatter.string(fromByteCount: Int64(value), countStyle: .memory)
    }
}
