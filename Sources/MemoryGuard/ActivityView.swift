import SwiftUI

struct ActivityView: View {
    @ObservedObject var model: MemoryGuardProductModel
    @State private var confirmsClear = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                PageHeader(
                    title: "Atividade",
                    subtitle: "Builds reconhecidos e histórico local de decisões."
                )

                MGCard {
                    VStack(alignment: .leading, spacing: 12) {
                        SectionTitle(
                            "Trabalho reconhecido",
                            detail: "\(model.heavyBuildCount) pesado(s) de \(model.buildGroups.count)"
                        )
                        if model.buildGroups.isEmpty {
                            EmptyState(
                                icon: "checkmark.circle",
                                title: "Nenhum build ativo",
                                detail: "O MemoryGuard continua observando. Builds reconhecidos aparecem aqui com estado, memória e classificação."
                            )
                        } else {
                            ForEach(model.buildGroups) { group in
                                BuildRow(
                                    group: group,
                                    minimumGroupBytes: model.policy.minimumGroupBytes
                                )
                                if group.id != model.buildGroups.last?.id { Divider() }
                            }
                        }

                        if model.pausedCount > 0 {
                            Button("Retomar todos os builds") { model.resumeAll() }
                                .buttonStyle(.borderedProminent)
                        }
                    }
                }

                MGCard {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            SectionTitle("Histórico local", detail: "\(model.eventHistory.count) evento(s)")
                            Button("Limpar") { confirmsClear = true }
                                .buttonStyle(.borderless)
                                .disabled(model.eventHistory.isEmpty)
                        }

                        if model.eventHistory.isEmpty {
                            EmptyState(
                                icon: "list.bullet.rectangle",
                                title: "Histórico vazio",
                                detail: "Nenhum dado é enviado para fora deste Mac."
                            )
                        } else {
                            ForEach(model.eventHistory) { event in
                                EventRow(event: event)
                                if event.id != model.eventHistory.last?.id { Divider() }
                            }
                        }
                    }
                }
            }
            .padding(28)
        }
        .confirmationDialog(
            "Limpar todo o histórico?",
            isPresented: $confirmsClear
        ) {
            Button("Limpar histórico", role: .destructive) { model.clearHistory() }
            Button("Cancelar", role: .cancel) {}
        } message: {
            Text("Remove apenas eventos criados pelo MemoryGuard. Nenhum arquivo ou processo será afetado.")
        }
    }
}
