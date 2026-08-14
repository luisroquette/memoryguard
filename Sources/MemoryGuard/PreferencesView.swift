import SwiftUI

struct PreferencesView: View {
    @ObservedObject var model: MemoryGuardProductModel
    @State private var confirmsRestore = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                PageHeader(
                    title: "Ajustes",
                    subtitle: "Personalize aparência, frequência e inicialização."
                )

                MGCard {
                    VStack(alignment: .leading, spacing: 16) {
                        SectionTitle("Aparência")
                        Picker("Tema", selection: $model.appearance) {
                            ForEach(AppAppearance.allCases) { appearance in
                                Label(appearance.title, systemImage: appearance.icon)
                                    .tag(appearance)
                            }
                        }
                        .pickerStyle(.segmented)
                        .labelsHidden()
                        .accessibilityLabel("Tema da interface")
                    }
                }

                MGCard {
                    VStack(alignment: .leading, spacing: 16) {
                        SectionTitle("Monitoramento")
                        LabeledContent("Frequência de leitura") {
                            Picker("Frequência de leitura", selection: $model.samplingInterval) {
                                ForEach(SamplingInterval.allCases) { interval in
                                    Text(interval.title).tag(interval)
                                }
                            }
                            .pickerStyle(.menu)
                            .labelsHidden()
                            .frame(width: 160)
                            .accessibilityLabel("Frequência de monitoramento")
                        }
                        Divider()
                        Toggle(
                            "Abrir ao iniciar sessão",
                            isOn: Binding(
                                get: { model.launchAtLoginEnabled },
                                set: { model.setLaunchAtLogin($0) }
                            )
                        )
                        .toggleStyle(.switch)
                        .disabled(model.isUpdatingLaunchAtLogin)
                        .accessibilityLabel("Abrir MemoryGuard ao iniciar sessão")

                        if model.isUpdatingLaunchAtLogin {
                            HStack(spacing: 8) {
                                ProgressView().controlSize(.small)
                                Text("Atualizando item de início…")
                            }
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .accessibilityElement(children: .combine)
                        }

                        if model.launchAtLoginNeedsApproval {
                            Label(
                                "Aprovação pendente em Ajustes do Sistema › Geral › Itens de Início.",
                                systemImage: "person.badge.clock.fill"
                            )
                            .font(.caption)
                            .foregroundStyle(.orange)
                        }

                        if let error = model.settingsError {
                            Label(error, systemImage: "exclamationmark.triangle.fill")
                                .font(.caption)
                                .foregroundStyle(.red)
                        }
                    }
                }

                MGCard {
                    VStack(alignment: .leading, spacing: 14) {
                        SectionTitle("Diagnóstico e privacidade")
                        Text("O diagnóstico contém apenas métricas, perfil e estado da automação. Comandos, caminhos e conteúdo de processos não são copiados.")
                            .font(.callout)
                            .foregroundStyle(.secondary)
                        HStack {
                            Button("Copiar diagnóstico") { model.copyDiagnostics() }
                                .buttonStyle(.borderedProminent)
                            Button("Restaurar padrões") { confirmsRestore = true }
                        }
                    }
                }
            }
            .padding(28)
        }
        .confirmationDialog("Restaurar preferências padrão?", isPresented: $confirmsRestore) {
            Button("Restaurar") { model.restoreDefaults() }
            Button("Cancelar", role: .cancel) {}
        } message: {
            Text("O histórico será preservado e nenhum processo será afetado.")
        }
    }
}

struct SettingsWindowView: View {
    @ObservedObject var model: MemoryGuardProductModel

    var body: some View {
        Form {
            Picker("Aparência", selection: $model.appearance) {
                ForEach(AppAppearance.allCases) { appearance in
                    Text(appearance.title).tag(appearance)
                }
            }
            .accessibilityLabel("Aparência")
            Picker("Frequência", selection: $model.samplingInterval) {
                ForEach(SamplingInterval.allCases) { interval in
                    Text(interval.title).tag(interval)
                }
            }
            .accessibilityLabel("Frequência de monitoramento")
            Toggle("Alívio automático", isOn: $model.automaticRelief)
                .accessibilityLabel("Ativar alívio automático")
            Toggle(
                "Abrir ao iniciar sessão",
                isOn: Binding(
                    get: { model.launchAtLoginEnabled },
                    set: { model.setLaunchAtLogin($0) }
                )
            )
            .disabled(model.isUpdatingLaunchAtLogin)
            .accessibilityLabel("Abrir MemoryGuard ao iniciar sessão")

            if model.isUpdatingLaunchAtLogin {
                ProgressView("Atualizando item de início…")
                    .controlSize(.small)
            }

            if model.launchAtLoginNeedsApproval {
                Label("Aprovação pendente nos Itens de Início do macOS.", systemImage: "person.badge.clock.fill")
                    .font(.caption)
                    .foregroundStyle(.orange)
            }

            if let error = model.settingsError {
                Label(error, systemImage: "exclamationmark.triangle.fill")
                    .font(.caption)
                    .foregroundStyle(.red)
                    .accessibilityLabel("Erro: \(error)")
            }
        }
        .formStyle(.grouped)
        .padding(8)
        .frame(width: 500, height: 340)
        .preferredColorScheme(model.appearance.colorScheme)
    }
}
