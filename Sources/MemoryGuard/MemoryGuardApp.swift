import AppKit
import Combine
import SwiftUI

@MainActor
final class MemoryGuardApplicationController: NSObject, NSApplicationDelegate, NSWindowDelegate, NSMenuItemValidation {
    let model = MemoryGuardProductModel()

    private var dashboardWindow: NSWindow?
    private var settingsWindow: NSWindow?
    private var statusItem: NSStatusItem?
    private var statusPopover: NSPopover?
    private var automaticReliefMenuItem: NSMenuItem?
    private var cancellables: Set<AnyCancellable> = []
    private var hasStarted = false

    func applicationDidFinishLaunching(_ notification: Notification) {
        start()
    }

    func start() {
        guard !hasStarted else { return }
        hasStarted = true
        configureMainMenu()
        configureStatusItem()
        observeModel()
        showDashboard()
    }

    func applicationShouldHandleReopen(
        _ sender: NSApplication,
        hasVisibleWindows flag: Bool
    ) -> Bool {
        showDashboard()
        return true
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        false
    }

    func applicationWillTerminate(_ notification: Notification) {
        model.prepareForTermination()
    }

    @objc func showDashboard() {
        let window: NSWindow

        if let dashboardWindow {
            window = dashboardWindow
        } else {
            window = makeWindow(
                title: "MemoryGuard",
                size: NSSize(width: 940, height: 680),
                minimumSize: NSSize(width: 760, height: 560),
                rootView: AnyView(
                    AppShellView(model: model)
                        .preferredColorScheme(model.appearance.colorScheme)
                )
            )
            window.setFrameAutosaveName("MemoryGuardDashboard")
            dashboardWindow = window
        }

        present(window)
    }

    @objc func showSettings() {
        let window: NSWindow

        if let settingsWindow {
            window = settingsWindow
        } else {
            window = makeWindow(
                title: "Ajustes do MemoryGuard",
                size: NSSize(width: 500, height: 340),
                minimumSize: NSSize(width: 500, height: 340),
                rootView: AnyView(SettingsWindowView(model: model))
            )
            window.styleMask.remove(.resizable)
            settingsWindow = window
        }

        present(window)
    }

    @objc func showAbout() {
        let options: [NSApplication.AboutPanelOptionKey: Any] = [
            .applicationName: "MemoryGuard",
            .applicationVersion: "Versão \(model.appVersion)",
            .credits: NSAttributedString(
                string: "Monitor local e seguro de pressão de memória.",
                attributes: [.foregroundColor: NSColor.secondaryLabelColor]
            )
        ]
        NSApp.orderFrontStandardAboutPanel(options: options)
        NSApp.activate(ignoringOtherApps: true)
    }

    @objc func sampleNow() {
        Task { await model.sampleNow() }
    }

    @objc func toggleAutomaticRelief() {
        model.automaticRelief.toggle()
    }

    @objc func resumeAll() {
        model.resumeAll()
    }

    @objc func copyDiagnostics() {
        model.copyDiagnostics()
    }

    @objc func quit() {
        model.terminateApp()
    }

    func validateMenuItem(_ menuItem: NSMenuItem) -> Bool {
        switch menuItem.action {
        case #selector(sampleNow):
            return !model.isSampling
        case #selector(resumeAll):
            return model.pausedCount > 0
        default:
            return true
        }
    }

    @objc private func toggleStatusPopover(_ sender: NSStatusBarButton) {
        guard let popover = statusPopover else { return }

        if popover.isShown {
            popover.performClose(sender)
        } else {
            popover.show(relativeTo: sender.bounds, of: sender, preferredEdge: .minY)
        }
    }

    private func makeWindow(
        title: String,
        size: NSSize,
        minimumSize: NSSize,
        rootView: AnyView
    ) -> NSWindow {
        let window = NSWindow(contentViewController: NSHostingController(rootView: rootView))
        window.title = title
        window.setContentSize(size)
        window.minSize = minimumSize
        window.styleMask = [.titled, .closable, .miniaturizable, .resizable]
        window.titlebarAppearsTransparent = true
        window.isReleasedWhenClosed = false
        window.collectionBehavior = [.managed, .moveToActiveSpace]
        window.delegate = self
        window.center()
        return window
    }

    private func present(_ window: NSWindow) {
        if window.isMiniaturized {
            window.deminiaturize(nil)
        }
        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    private func configureStatusItem() {
        let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        statusItem.button?.image = NSImage(systemSymbolName: "memorychip", accessibilityDescription: "MemoryGuard")
        statusItem.button?.target = self
        statusItem.button?.action = #selector(toggleStatusPopover(_:))
        statusItem.button?.sendAction(on: [.leftMouseUp])

        let popover = NSPopover()
        popover.behavior = .transient
        popover.animates = true
        popover.contentSize = NSSize(width: 370, height: 420)
        popover.contentViewController = NSHostingController(
            rootView: MenuBarView(model: model, showDashboard: showDashboard)
        )

        self.statusItem = statusItem
        statusPopover = popover
    }

    private func configureMainMenu() {
        let mainMenu = NSMenu()

        let appMenuItem = NSMenuItem()
        let appMenu = NSMenu(title: "MemoryGuard")
        appMenu.addItem(item("Sobre o MemoryGuard", action: #selector(showAbout)))
        appMenu.addItem(.separator())
        appMenu.addItem(item("Ajustes…", action: #selector(showSettings), key: ","))
        appMenu.addItem(.separator())
        let servicesItem = NSMenuItem(title: "Serviços", action: nil, keyEquivalent: "")
        let servicesMenu = NSMenu(title: "Serviços")
        servicesItem.submenu = servicesMenu
        NSApp.servicesMenu = servicesMenu
        appMenu.addItem(servicesItem)
        appMenu.addItem(.separator())
        appMenu.addItem(item("Ocultar MemoryGuard", action: #selector(NSApplication.hide(_:)), key: "h", target: NSApp))
        appMenu.addItem(item("Ocultar Outros", action: #selector(NSApplication.hideOtherApplications(_:)), key: "h", modifiers: [.command, .option], target: NSApp))
        appMenu.addItem(item("Mostrar Todos", action: #selector(NSApplication.unhideAllApplications(_:)), target: NSApp))
        appMenu.addItem(.separator())
        appMenu.addItem(item("Sair do MemoryGuard", action: #selector(quit), key: "q"))
        appMenuItem.submenu = appMenu
        mainMenu.addItem(appMenuItem)

        let monitorItem = NSMenuItem()
        let monitorMenu = NSMenu(title: "Monitoramento")
        monitorMenu.addItem(item("Abrir MemoryGuard", action: #selector(showDashboard), key: "o", modifiers: [.command, .shift]))
        monitorMenu.addItem(item("Verificar agora", action: #selector(sampleNow), key: "r"))
        let automaticItem = item("Alívio automático", action: #selector(toggleAutomaticRelief))
        automaticReliefMenuItem = automaticItem
        monitorMenu.addItem(automaticItem)
        monitorMenu.addItem(item("Retomar todos os builds", action: #selector(resumeAll), key: "r", modifiers: [.command, .shift]))
        monitorMenu.addItem(.separator())
        monitorMenu.addItem(item("Copiar diagnóstico", action: #selector(copyDiagnostics)))
        monitorItem.submenu = monitorMenu
        mainMenu.addItem(monitorItem)

        let windowItem = NSMenuItem()
        let windowMenu = NSMenu(title: "Janela")
        let minimizeItem = item("Minimizar", action: #selector(NSWindow.performMiniaturize(_:)), key: "m")
        minimizeItem.target = nil
        windowMenu.addItem(minimizeItem)
        let zoomItem = item("Zoom", action: #selector(NSWindow.performZoom(_:)))
        zoomItem.target = nil
        windowMenu.addItem(zoomItem)
        windowMenu.addItem(.separator())
        windowMenu.addItem(item("Trazer Tudo para Frente", action: #selector(NSApplication.arrangeInFront(_:)), target: NSApp))
        windowItem.submenu = windowMenu
        mainMenu.addItem(windowItem)
        NSApp.windowsMenu = windowMenu

        NSApp.mainMenu = mainMenu
    }

    private func item(
        _ title: String,
        action: Selector,
        key: String = "",
        modifiers: NSEvent.ModifierFlags = [.command],
        target: AnyObject? = nil
    ) -> NSMenuItem {
        let item = NSMenuItem(title: title, action: action, keyEquivalent: key)
        item.keyEquivalentModifierMask = modifiers
        item.target = target ?? self
        return item
    }

    private func observeModel() {
        model.$snapshot
            .sink { [weak self] snapshot in
                let symbol: String
                switch snapshot.level {
                case .normal: symbol = "memorychip"
                case .elevated: symbol = "memorychip.fill"
                case .critical: symbol = "exclamationmark.triangle.fill"
                }
                self?.statusItem?.button?.image = NSImage(
                    systemSymbolName: symbol,
                    accessibilityDescription: "MemoryGuard: \(snapshot.level.title)"
                )
            }
            .store(in: &cancellables)

        model.$automaticRelief
            .sink { [weak self] enabled in
                self?.automaticReliefMenuItem?.state = enabled ? .on : .off
            }
            .store(in: &cancellables)
    }
}

@main
enum MemoryGuardMain {
    @MainActor
    static func main() {
        let application = NSApplication.shared
        let controller = MemoryGuardApplicationController()
        application.setActivationPolicy(.regular)
        application.delegate = controller
        controller.start()
        application.run()
        withExtendedLifetime(controller) {}
    }
}
