import SwiftUI
import MemoryGuardCore

struct AutomationView: View {
    @ObservedObject var model: MemoryGuardProductModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                PageHeader(
                    title: "Automação",
                    subtitle: "Defina quando o MemoryGuard pode serializar trabalho pesado."
                )

                MGCard {
                    VStack(alignment: .leading, spacing: 14) {
                        Toggle(isOn: $model.automaticRelief) {
                            VStack(alignment: .leading, spacing: 3) {
                                Text("Alívio automático")
                                    .font(.headline)
                                Text("Pausa e retoma builds somente dentro do contrato de segurança.")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .toggleStyle(.switch)
                        .accessibilityLabel("Ativar alívio automático")
                    }
                }

                VStack(alignment: .leading, spacing: 12) {
                    SectionTitle("Perfil de proteção", detail: "Escolha um comportamento")
                    LazyVGrid(
                        columns: [GridItem(.adaptive(minimum: 180, maximum: 260), spacing: 12)],
                        alignment: .leading,
                        spacing: 12
                    ) {
                        ForEach(ProtectionProfile.allCases) { profile in
                            ProtectionProfileCard(
                                profile: profile,
                                isSelected: model.protectionProfile == profile
                            ) {
                                model.protectionProfile = profile
                            }
                        }
                    }
                }

                policyDetails
                safetyFlow
            }
            .padding(28)
        }
    }

    private var policyDetails: some View {
        let policy = model.policy
        return MGCard {
            VStack(alignment: .leading, spacing: 14) {
                SectionTitle("Limites do perfil \(model.protectionProfile.title)")
                LazyVGrid(
                    columns: [GridItem(.adaptive(minimum: 120), spacing: 18)],
                    alignment: .leading,
                    spacing: 14
                ) {
                    threshold("RAM crítica", "≤ \(policy.criticalAvailablePercent)%")
                    threshold("Swap baixo", bytes(policy.lowSwapFreeBytes))
                    threshold("Build mínimo", bytes(policy.minimumGroupBytes))
                    threshold("Recuperação", "≥ \(policy.recoveryAvailablePercent)%")
                }
            }
        }
    }

    private var safetyFlow: some View {
        MGCard {
            VStack(alignment: .leading, spacing: 16) {
                SectionTitle("Como a proteção decide")
                flowStep(1, "Detecta risco", "Combina pressão do kernel, RAM disponível e swap livre.")
                flowStep(2, "Preserva progresso", "Exige dois ou mais builds pesados e pausa apenas o mais novo.")
                flowStep(3, "Retoma sozinho", "Aguarda duas leituras saudáveis antes de continuar o trabalho.")
            }
        }
    }

    private func threshold(_ title: String, _ value: String) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(value)
                .font(.headline.monospacedDigit())
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func flowStep(_ number: Int, _ title: String, _ detail: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Text("\(number)")
                .font(.caption.bold())
                .foregroundStyle(.white)
                .frame(width: 24, height: 24)
                .background(Color.accentColor, in: Circle())
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.subheadline.weight(.semibold))
                Text(detail).font(.caption).foregroundStyle(.secondary)
            }
        }
    }

    private func bytes(_ value: UInt64) -> String {
        ByteCountFormatter.string(fromByteCount: Int64(value), countStyle: .memory)
    }
}

private struct ProtectionProfileCard: View {
    let profile: ProtectionProfile
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: icon)
                        .font(.title3)
                    Spacer()
                    Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                        .foregroundStyle(isSelected ? Color.accentColor : Color.secondary)
                }
                Text(profile.title)
                    .font(.headline)
                Text(profile.summary)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(16)
            .frame(maxWidth: .infinity, minHeight: 150, alignment: .topLeading)
            .background(cardBackground, in: RoundedRectangle(cornerRadius: 14))
            .overlay {
                RoundedRectangle(cornerRadius: 14)
                    .stroke(cardStroke)
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Perfil \(profile.title). \(profile.summary)")
        .accessibilityValue(isSelected ? "Selecionado" : "Não selecionado")
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }

    private var cardBackground: Color {
        isSelected ? Color.accentColor.opacity(0.1) : Color.primary.opacity(0.04)
    }

    private var cardStroke: Color {
        isSelected ? Color.accentColor.opacity(0.65) : Color.primary.opacity(0.07)
    }

    private var icon: String {
        switch profile {
        case .balanced: "scale.3d"
        case .proactive: "bolt.shield.fill"
        case .conservative: "tortoise.fill"
        }
    }
}
