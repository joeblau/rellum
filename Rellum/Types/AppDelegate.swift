//
//  AppDelegate.swift
//  Rellum
//
//  Created by Joe Blau on 9/3/18.
//  Copyright © 2018 Joe Blau. All rights reserved.
//

import Cocoa
import ServiceManagement

class AppDelegate: NSObject, NSApplicationDelegate {

    fileprivate var statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    private let rellumTextField = RellumTextField()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        NSWindow().collectionBehavior = .canJoinAllSpaces

        statusItem.menu = NSMenu()
        statusItem.view = NSView()
        statusItem.highlightMode = false

        rellumTextField.rellumDelegate = self

        buildMenu()
        configureViews()
        subscribeToAllEvents()
    }

    // MARK: - Selectors

    @objc func quit() {
        NSApp.terminate(self)
    }

    // MARK: - Private

    private func buildMenu() {
        guard let statusItemMenu = statusItem.menu else { return }
        statusItemMenu.addItem(withTitle: NSLocalizedString("quit", comment: "quit"),
                               action: #selector(quit),
                               keyEquivalent: "")
    }

    private func configureViews() {
        guard let statusItemView = statusItem.view else { return }
        statusItemView.translatesAutoresizingMaskIntoConstraints = false
        statusItemView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        statusItemView.heightAnchor.constraint(equalToConstant: NSStatusBar.system.thickness).isActive = true

        statusItemView.addSubview(rellumTextField)
        rellumTextField.topAnchor.constraint(equalTo: statusItemView.topAnchor, constant: 2).isActive = true
        rellumTextField.bottomAnchor.constraint(equalTo: statusItemView.bottomAnchor, constant: -2).isActive = true
        rellumTextField.leftAnchor.constraint(equalTo: statusItemView.leftAnchor).isActive = true
        rellumTextField.rightAnchor.constraint(equalTo: statusItemView.rightAnchor).isActive = true
    }

    private func subscribeToAllEvents() {
        NSEvent.addGlobalMonitorForEvents(matching: .mouseMoved) { (_) in

            guard let principalScreenHeight = NSScreen.screens.first?.frame.size.height else { return }
            let mouseInWindow =  NSPoint(x: NSEvent.mouseLocation.x,
                                         y: principalScreenHeight - NSEvent.mouseLocation.y)

            let pixel = CGRect(x: mouseInWindow.x,
                               y: mouseInWindow.y,
                               width: 1,
                               height: 1)
            guard let pixelImage = CGWindowListCreateImage(pixel, .optionOnScreenOnly, 0, .bestResolution),
                let pixelColor = NSBitmapImageRep(cgImage: pixelImage).colorAt(x: 0, y: 0)  else {
                    return
            }
            self.rellumTextField.rellum(rellum: RelativeLuminance.of(color: pixelColor))
        }
    }

    private func killLauncher() {
        let launcherAppId = "com.joeblau.LauncherApplication"
        let runningApps = NSWorkspace.shared.runningApplications
        let isRunning = !runningApps.filter { $0.bundleIdentifier == launcherAppId }.isEmpty

        SMLoginItemSetEnabled(launcherAppId as CFString, true)

        if isRunning {
            DistributedNotificationCenter.default().post(name: .killLauncher,
                                                         object: Bundle.main.bundleIdentifier!)
        }
    }
}

extension AppDelegate: RellumTextFieldDelegate {
    func showMenu() {
        guard let statusItemMenu = statusItem.menu else { return }
        statusItem.popUpMenu(statusItemMenu)
    }
}
