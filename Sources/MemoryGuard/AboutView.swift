import AppKit
import SwiftUI

struct AboutView: View {
    @ObservedObject var model: MemoryGuardProductModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                PageHeader(
                    title: "Sobre",
                    subtitle: "Proteção local e transparente para trabalho pesado no macOS."
                )

                MGCard {
                    HStack(spacing: 22) {
                        Image(nsImage: NSApplication.shared.applicationIconImage)
                            .resizable()
                            .frame(width: 92, height: 92)
                            .accessibilityHidden(true)
                        VStack(alignment: .leading, spacing: 5) {
                            Text("MemoryGuard")
                                .font(.title.bold())
                            Text("Versão \(model.appVersion)")
                                .foregroundStyle(.secondary)
                            Text("Mantém builds avançando sem sacrificar seu trabalho aberto.")
                                .font(.callout)
                                .foregroundStyle(.secondary)
                        }
                    }
                }

                MGCard {
                    VStack(alignment: .leading, spacing: 14) {
                        SectionTitle("Contrato de segurança")
                        contractRow("trash.slash.fill", "Nunca apaga arquivos, caches ou dados")
                        contractRow("xmark.app.fill", "Nunca encerra aplicativos, abas ou Terminal")
                        contractRow("pause.circle.fill", "Só pausa grupos de build reconhecidos")
                        contractRow("play.circle.fill", "Watchdog retoma tudo se o app encerrar")
                    }
                }

                MGCard {
                    VStack(alignment: .leading, spacing: 12) {
                        SectionTitle("Privacidade")
                        Label("100% local", systemImage: "laptopcomputer")
                        Label("Sem conta, nuvem ou telemetria", systemImage: "icloud.slash.fill")
                        Label("Histórico limitado a 100 eventos não sensíveis", systemImage: "lock.shield.fill")
                    }
                    .font(.callout)
                }

                Text("© 2026 Luis Roquette")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding(28)
        }
    }

    private func contractRow(_ icon: String, _ text: String) -> some View {
        Label(text, systemImage: icon)
            .font(.callout)
            .foregroundStyle(.secondary)
    }
}
