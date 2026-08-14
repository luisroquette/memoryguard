import SwiftUI

struct OverviewView: View {
    @ObservedObject var model: MemoryGuardProductModel

    private let columns = [
        GridItem(.adaptive(minimum: 175, maximum: 260), spacing: 14),
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                PageHeader(
                    title: "Visão Geral",
                    subtitle: "Estado da memória e proteção do sistema em tempo real."
                )

                if let error = model.lastError {
                    errorBanner(error)
                }

                LazyVGrid(columns: columns, alignment: .leading, spacing: 14) {
                    MetricTile(
                        icon: "memorychip.fill",
                        value: model.hasCompletedSample ? "\(model.snapshot.availablePercent)%" : "—",
                        label: "Memória disponível",
                        detail: memoryDetail,
                        tint: model.snapshot.level.color
                    )
                    MetricTile(
                        icon: "externaldrive.fill",
                        value: model.hasCompletedSample ? bytes(model.snapshot.swapUsedBytes) : "—",
                        label: "Swap usado",
                        detail: model.hasCompletedSample ? "\(bytes(model.snapshot.swapFreeBytes)) livres" : "Aguardando leitura",
                        tint: .blue
                    )
                    MetricTile(
                        icon: model.snapshot.level.icon,
                        value: model.hasCompletedSample ? model.snapshot.level.title : "—",
                        label: "Pressão do kernel",
                        detail: "Nível \(model.snapshot.systemPressureLevel)",
                        tint: model.snapshot.level.color
                    )
                    MetricTile(
                        icon: "hammer.fill",
                        value: "\(model.heavyBuildCount) de \(model.buildGroups.count)",
                        label: "Builds pesados",
                        detail: model.pausedCount > 0
                            ? "\(model.pausedCount) pausado(s)"
                            : "Limite: \(bytes(model.policy.minimumGroupBytes))",
                        tint: .purple
                    )
                }

                ViewThatFits(in: .horizontal) {
                    HStack(alignment: .top, spacing: 14) {
                        protectionCard
                        recentActivityCard
                    }
                    VStack(spacing: 14) {
                        protectionCard
                        recentActivityCard
                    }
                }
            }
            .padding(28)
        }
    }

    private var protectionCard: some View {
        MGCard {
            VStack(alignment: .leading, spacing: 16) {
                SectionTitle("Proteção", detail: model.protectionProfile.title)
                HStack(spacing: 14) {
                    Image(systemName: model.automaticRelief ? "shield.checkered" : "eye.fill")
                        .font(.system(size: 27, weight: .semibold))
                        .foregroundStyle(model.automaticRelief ? .green : .secondary)
                        .frame(width: 48, height: 48)
                        .background((model.automaticRelief ? Color.green : Color.gray).opacity(0.12), in: RoundedRectangle(cornerRadius: 13))
                    VStack(alignment: .leading, spacing: 3) {
                        Text(model.automaticRelief ? "Alívio automático ativo" : "Somente monitoramento")
                            .font(.headline)
                        Text(model.protectionProfile.summary)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                Divider()
                Label("Nunca apaga arquivos ou encerra aplicativos", systemImage: "checkmark.circle.fill")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
    }

    private var recentActivityCard: some View {
        MGCard {
            VStack(alignment: .leading, spacing: 12) {
                SectionTitle("Atividade recente", detail: "Últimos eventos")
                if model.eventHistory.isEmpty {
                    EmptyState(
                        icon: "clock",
                        title: "Sem eventos",
                        detail: "As intervenções e alterações aparecerão aqui."
                    )
                } else {
                    ForEach(model.eventHistory.prefix(3)) { event in
                        EventRow(event: event)
                        if event.id != model.eventHistory.prefix(3).last?.id {
                            Divider()
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
    }

    private var memoryDetail: String {
        guard model.hasCompletedSample else { return "Aguardando leitura" }
        if let date = model.lastUpdatedAt {
            return "Atualizado às \(date.formatted(date: .omitted, time: .shortened))"
        }
        return "Monitoramento ativo"
    }

    private func errorBanner(_ message: String) -> some View {
        Label(message, systemImage: "exclamationmark.triangle.fill")
            .font(.callout)
            .foregroundStyle(.red)
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.red.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
            .accessibilityLabel("Erro de monitoramento: \(message)")
    }

    private func bytes(_ value: UInt64) -> String {
        ByteCountFormatter.string(fromByteCount: Int64(value), countStyle: .memory)
    }
}
