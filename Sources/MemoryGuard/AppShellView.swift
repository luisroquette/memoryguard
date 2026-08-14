import AppKit
import SwiftUI

struct AppShellView: View {
    @ObservedObject var model: MemoryGuardProductModel
    @State private var selection: AppSection? = .overview
    @State private var positionedWindow = false

    var body: some View {
        NavigationSplitView {
            List(AppSection.allCases, selection: $selection) { section in
                Label(section.title, systemImage: section.icon)
                    .tag(section)
                    .padding(.vertical, 3)
            }
            .navigationTitle("MemoryGuard")
            .navigationSplitViewColumnWidth(min: 180, ideal: 205, max: 235)
            .safeAreaInset(edge: .bottom) {
                sidebarStatus
            }
        } detail: {
            detailView
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.background)
        }
        .frame(minWidth: 760, minHeight: 560)
        .preferredColorScheme(model.appearance.colorScheme)
        .toolbar {
            ToolbarItemGroup {
                statusBadge
                Button {
                    Task { await model.sampleNow() }
                } label: {
                    Image(systemName: "arrow.clockwise")
                }
                .help("Verificar agora (⌘R)")
                .disabled(model.isSampling)
                .accessibilityLabel("Verificar memória agora")
            }
        }
        .onAppear { positionWindowIfNeeded() }
    }

    @ViewBuilder
    private var detailView: some View {
        switch selection ?? .overview {
        case .overview: OverviewView(model: model)
        case .activity: ActivityView(model: model)
        case .automation: AutomationView(model: model)
        case .settings: PreferencesView(model: model)
        case .about: AboutView(model: model)
        }
    }

    private var sidebarStatus: some View {
        HStack(spacing: 9) {
            Circle()
                .fill(model.snapshot.level.color)
                .frame(width: 8, height: 8)
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 1) {
                Text(model.hasCompletedSample ? model.snapshot.level.title : "Lendo…")
                    .font(.caption.weight(.semibold))
                Text(model.automaticRelief ? "Proteção ativa" : "Somente monitor")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding(12)
        .background(.bar)
        .accessibilityElement(children: .combine)
    }

    private var statusBadge: some View {
        Label(model.snapshot.level.title, systemImage: model.snapshot.level.icon)
            .font(.caption.weight(.semibold))
            .foregroundStyle(model.snapshot.level.color)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(model.snapshot.level.color.opacity(0.11), in: Capsule())
            .accessibilityLabel("Pressão de memória: \(model.snapshot.level.title)")
    }

    private func positionWindowIfNeeded() {
        guard !positionedWindow else { return }
        positionedWindow = true
        DispatchQueue.main.async {
            guard let window = NSApp.windows.first(where: { $0.title == "MemoryGuard" }),
                  let screen = NSScreen.main else { return }
            let origin = NSPoint(
                x: screen.visibleFrame.midX - window.frame.width / 2,
                y: screen.visibleFrame.midY - window.frame.height / 2
            )
            window.setFrameOrigin(origin)
            window.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
        }
    }
}
